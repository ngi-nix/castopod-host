<?php

declare(strict_types=1);

/**
 * @copyright  2021 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

namespace ActivityPub\Models;

use ActivityPub\Activities\AnnounceActivity;
use ActivityPub\Activities\CreateActivity;
use ActivityPub\Activities\DeleteActivity;
use ActivityPub\Activities\UndoActivity;
use ActivityPub\Entities\Actor;
use ActivityPub\Entities\Post;
use ActivityPub\Objects\TombstoneObject;
use CodeIgniter\Database\BaseResult;
use CodeIgniter\Database\Query;
use CodeIgniter\Events\Events;
use CodeIgniter\HTTP\URI;
use CodeIgniter\I18n\Time;
use Exception;
use Michalsn\Uuid\UuidModel;

class PostModel extends UuidModel
{
    /**
     * @var string
     */
    protected $table = 'activitypub_posts';

    /**
     * @var string
     */
    protected $primaryKey = 'id';

    /**
     * @var string[]
     */
    protected $uuidFields = ['id', 'in_reply_to_id', 'reblog_of_id'];

    /**
     * @var string[]
     */
    protected $allowedFields = [
        'id',
        'uri',
        'actor_id',
        'in_reply_to_id',
        'reblog_of_id',
        'message',
        'message_html',
        'favourites_count',
        'reblogs_count',
        'replies_count',
        'published_at',
    ];

    /**
     * @var string
     */
    protected $returnType = Post::class;

    /**
     * @var bool
     */
    protected $useSoftDeletes = false;

    /**
     * @var bool
     */
    protected $useTimestamps = true;

    protected $updatedField;

    /**
     * @var array<string, string>
     */
    protected $validationRules = [
        'actor_id' => 'required',
        'message_html' => 'max_length[500]',
    ];

    /**
     * @var string[]
     */
    protected $beforeInsert = ['setPostId'];

    public function getPostById(string $postId): ?Post
    {
        $cacheName = config('ActivityPub')
            ->cachePrefix . "post#{$postId}";
        if (! ($found = cache($cacheName))) {
            $found = $this->find($postId);

            cache()
                ->save($cacheName, $found, DECADE);
        }

        return $found;
    }

    public function getPostByUri(string $postUri): ?Post
    {
        $hashedPostUri = md5($postUri);
        $cacheName =
            config('ActivityPub')
                ->cachePrefix . "post-{$hashedPostUri}";
        if (! ($found = cache($cacheName))) {
            $found = $this->where('uri', $postUri)
                ->first();

            cache()
                ->save($cacheName, $found, DECADE);
        }

        return $found;
    }

    /**
     * Retrieves all published posts for a given actor ordered by publication date
     *
     * @return Post[]
     */
    public function getActorPublishedPosts(int $actorId): array
    {
        $cacheName =
            config('ActivityPub')
                ->cachePrefix .
            "actor#{$actorId}_published_posts";
        if (! ($found = cache($cacheName))) {
            $found = $this->where([
                'actor_id' => $actorId,
                'in_reply_to_id' => null,
            ])
                ->where('`published_at` <= NOW()', null, false)
                ->orderBy('published_at', 'DESC')
                ->findAll();

            $secondsToNextUnpublishedPost = $this->getSecondsToNextUnpublishedPosts($actorId);

            cache()
                ->save($cacheName, $found, $secondsToNextUnpublishedPost ? $secondsToNextUnpublishedPost : DECADE);
        }

        return $found;
    }

    /**
     * Returns the timestamp difference in seconds between the next post to publish and the current timestamp. Returns
     * false if there's no post to publish
     */
    public function getSecondsToNextUnpublishedPosts(int $actorId): int | false
    {
        $result = $this->select('TIMESTAMPDIFF(SECOND, NOW(), `published_at`) as timestamp_diff')
            ->where([
                'actor_id' => $actorId,
            ])
            ->where('`published_at` > NOW()', null, false)
            ->orderBy('published_at', 'asc')
            ->get()
            ->getResultArray();

        return $result !== []
            ? (int) $result[0]['timestamp_diff']
            : false;
    }

    /**
     * Retrieves all published replies for a given post. By default, it does not get replies from blocked actors.
     *
     * @return Post[]
     */
    public function getPostReplies(string $postId, bool $withBlocked = false): array
    {
        $cacheName =
            config('ActivityPub')
                ->cachePrefix .
            "post#{$postId}_replies" .
            ($withBlocked ? '_withBlocked' : '');

        if (! ($found = cache($cacheName))) {
            if (! $withBlocked) {
                $this->select('activitypub_posts.*')
                    ->join('activitypub_actors', 'activitypub_actors.id = activitypub_posts.actor_id', 'inner')
                    ->where('activitypub_actors.is_blocked', 0);
            }

            $this->where('in_reply_to_id', $this->uuid->fromString($postId) ->getBytes())
                ->where('`published_at` <= NOW()', null, false)
                ->orderBy('published_at', 'ASC');
            $found = $this->findAll();

            cache()
                ->save($cacheName, $found, DECADE);
        }

        return $found;
    }

    /**
     * Retrieves all published reblogs for a given post
     *
     * @return Post[]
     */
    public function getPostReblogs(string $postId): array
    {
        $cacheName =
            config('ActivityPub')
                ->cachePrefix . "post#{$postId}_reblogs";

        if (! ($found = cache($cacheName))) {
            $found = $this->where('reblog_of_id', $this->uuid->fromString($postId) ->getBytes())
                ->where('`published_at` <= NOW()', null, false)
                ->orderBy('published_at', 'ASC')
                ->findAll();

            cache()
                ->save($cacheName, $found, DECADE);
        }

        return $found;
    }

    public function addPreviewCard(string $postId, int $previewCardId): Query | bool
    {
        return $this->db->table('activitypub_posts_preview_cards')
            ->insert([
                'post_id' => $this->uuid->fromString($postId)
                    ->getBytes(),
                'preview_card_id' => $previewCardId,
            ]);
    }

    /**
     * Adds post in database along preview card if relevant
     *
     * @return string|false returns the new post id if success or false otherwise
     */
    public function addPost(
        Post $post,
        bool $createPreviewCard = true,
        bool $registerActivity = true
    ): string | false {
        helper('activitypub');

        $this->db->transStart();

        if (! ($newPostId = $this->insert($post, true))) {
            $this->db->transRollback();

            // Couldn't insert post
            return false;
        }

        if ($createPreviewCard) {
            // parse message
            $messageUrls = extract_urls_from_message($post->message);

            if (
                $messageUrls !== [] &&
                ($previewCard = get_or_create_preview_card_from_url(new URI($messageUrls[0]))) &&
                ! $this->addPreviewCard($newPostId, $previewCard->id)
            ) {
                $this->db->transRollback();
                // problem when linking post to preview card
                return false;
            }
        }

        model('ActorModel', false)
            ->where('id', $post->actor_id)
            ->increment('posts_count');

        if ($registerActivity) {
            // set post id and uri to construct NoteObject
            $post->id = $newPostId;
            $post->uri = url_to('post', $post->actor->username, $newPostId);

            $createActivity = new CreateActivity();
            $noteObjectClass = config('ActivityPub')
                ->noteObject;
            $createActivity
                ->set('actor', $post->actor->uri)
                ->set('object', new $noteObjectClass($post));

            $activityId = model('ActivityModel', false)
                ->newActivity(
                    'Create',
                    $post->actor_id,
                    null,
                    $newPostId,
                    $createActivity->toJSON(),
                    $post->published_at,
                    'queued',
                );

            $createActivity->set('id', url_to('activity', $post->actor->username, $activityId));

            model('ActivityModel', false)
                ->update($activityId, [
                    'payload' => $createActivity->toJSON(),
                ]);
        }

        Events::trigger('on_post_add', $post);

        $this->clearCache($post);

        $this->db->transComplete();

        return $newPostId;
    }

    public function editPost(Post $updatedPost): bool
    {
        $this->db->transStart();

        // update post create activity schedule in database
        $scheduledActivity = model('ActivityModel', false)
            ->where([
                'type' => 'Create',
                'post_id' => $this->uuid
                    ->fromString($updatedPost->id)
                    ->getBytes(),
            ])
            ->first();

        // update published date in payload
        $newPayload = $scheduledActivity->payload;
        $newPayload->object->published = $updatedPost->published_at->format(DATE_W3C);
        model('ActivityModel', false)
            ->update($scheduledActivity->id, [
                'payload' => json_encode($newPayload, JSON_THROW_ON_ERROR),
                'scheduled_at' => $updatedPost->published_at,
            ]);

        // update post
        $updateResult = $this->update($updatedPost->id, $updatedPost);

        Events::trigger('on_post_edit', $updatedPost);

        $this->clearCache($updatedPost);

        $this->db->transComplete();

        return $updateResult;
    }

    /**
     * Removes a post from the database and decrements meta data
     */
    public function removePost(Post $post, bool $registerActivity = true): BaseResult | bool
    {
        $this->db->transStart();

        model('ActorModel', false)
            ->where('id', $post->actor_id)
            ->decrement('posts_count');

        if ($post->in_reply_to_id !== null) {
            // Post to remove is a reply
            model('PostModel', false)
                ->where('id', $this->uuid->fromString($post->in_reply_to_id) ->getBytes())
                ->decrement('replies_count');

            Events::trigger('on_reply_remove', $post);
        }

        // remove all post reblogs
        foreach ($post->reblogs as $reblog) {
            // FIXME: issue when actor is not local, can't get actor information
            $this->removePost($reblog);
        }

        // remove all post replies
        foreach ($post->replies as $reply) {
            $this->removePost($reply);
        }

        // check that preview card is no longer used elsewhere before deleting it
        if (
            $post->preview_card &&
            $this->db
                ->table('activitypub_posts_preview_cards')
                ->where('preview_card_id', $post->preview_card->id)
                ->countAll() <= 1
        ) {
            model('PreviewCardModel', false)->deletePreviewCard($post->preview_card->id, $post->preview_card->url);
        }

        if ($registerActivity) {
            $deleteActivity = new DeleteActivity();
            $tombstoneObject = new TombstoneObject();
            $tombstoneObject->set('id', $post->uri);
            $deleteActivity
                ->set('actor', $post->actor->uri)
                ->set('object', $tombstoneObject);

            $activityId = model('ActivityModel', false)
                ->newActivity(
                    'Delete',
                    $post->actor_id,
                    null,
                    null,
                    $deleteActivity->toJSON(),
                    Time::now(),
                    'queued',
                );

            $deleteActivity->set('id', url_to('activity', $post->actor->username, $activityId));

            model('ActivityModel', false)
                ->update($activityId, [
                    'payload' => $deleteActivity->toJSON(),
                ]);
        }

        $result = model('PostModel', false)
            ->delete($post->id);

        Events::trigger('on_post_remove', $post);

        $this->clearCache($post);

        $this->db->transComplete();

        return $result;
    }

    public function addReply(
        Post $reply,
        bool $createPreviewCard = true,
        bool $registerActivity = true
    ): string | false {
        if (! $reply->in_reply_to_id) {
            throw new Exception('Passed post is not a reply!');
        }

        $this->db->transStart();

        $postId = $this->addPost($reply, $createPreviewCard, $registerActivity);

        model('PostModel', false)
            ->where('id', $this->uuid->fromString($reply->in_reply_to_id) ->getBytes())
            ->increment('replies_count');

        Events::trigger('on_post_reply', $reply);

        $this->clearCache($reply);

        $this->db->transComplete();

        return $postId;
    }

    public function reblog(Actor $actor, Post $post, bool $registerActivity = true): string | false
    {
        $this->db->transStart();

        $reblog = new Post([
            'actor_id' => $actor->id,
            'reblog_of_id' => $post->id,
            'published_at' => Time::now(),
        ]);

        // add reblog
        $reblogId = $this->insert($reblog);

        model('ActorModel', false)
            ->where('id', $actor->id)
            ->increment('posts_count');

        model('PostModel', false)
            ->where('id', $this->uuid->fromString($post->id)->getBytes())
            ->increment('reblogs_count');

        if ($registerActivity) {
            $announceActivity = new AnnounceActivity($reblog);

            $activityId = model('ActivityModel', false)
                ->newActivity(
                    'Announce',
                    $actor->id,
                    null,
                    $post->id,
                    $announceActivity->toJSON(),
                    $reblog->published_at,
                    'queued',
                );

            $announceActivity->set('id', url_to('activity', $post->actor->username, $activityId));

            model('ActivityModel', false)
                ->update($activityId, [
                    'payload' => $announceActivity->toJSON(),
                ]);
        }

        Events::trigger('on_post_reblog', $actor, $post);

        $this->clearCache($post);

        $this->db->transComplete();

        return $reblogId;
    }

    public function undoReblog(Post $reblogPost, bool $registerActivity = true): BaseResult | bool
    {
        $this->db->transStart();

        model('ActorModel', false)
            ->where('id', $reblogPost->actor_id)
            ->decrement('posts_count');

        model('PostModel', false)
            ->where('id', $this->uuid->fromString($reblogPost->reblog_of_id) ->getBytes())
            ->decrement('reblogs_count');

        if ($registerActivity) {
            $undoActivity = new UndoActivity();
            // get like activity
            $activity = model('ActivityModel', false)
                ->where([
                    'type' => 'Announce',
                    'actor_id' => $reblogPost->actor_id,
                    'post_id' => $this->uuid
                        ->fromString($reblogPost->reblog_of_id)
                        ->getBytes(),
                ])
                ->first();

            $announceActivity = new AnnounceActivity($reblogPost);
            $announceActivity->set('id', url_to('activity', $reblogPost->actor->username, $activity->id),);

            $undoActivity
                ->set('actor', $reblogPost->actor->uri)
                ->set('object', $announceActivity);

            $activityId = model('ActivityModel', false)
                ->newActivity(
                    'Undo',
                    $reblogPost->actor_id,
                    null,
                    $reblogPost->reblog_of_id,
                    $undoActivity->toJSON(),
                    Time::now(),
                    'queued',
                );

            $undoActivity->set('id', url_to('activity', $reblogPost->actor->username, $activityId));

            model('ActivityModel', false)
                ->update($activityId, [
                    'payload' => $undoActivity->toJSON(),
                ]);
        }

        $result = model('PostModel', false)
            ->delete($reblogPost->id);

        Events::trigger('on_post_undo_reblog', $reblogPost);

        $this->clearCache($reblogPost);

        $this->db->transComplete();

        return $result;
    }

    public function toggleReblog(Actor $actor, Post $post): void
    {
        if (
            ! ($reblogPost = $this->where([
                'actor_id' => $actor->id,
                'reblog_of_id' => $this->uuid
                    ->fromString($post->id)
                    ->getBytes(),
            ])->first())
        ) {
            $this->reblog($actor, $post);
        } else {
            $this->undoReblog($reblogPost);
        }
    }

    public function clearCache(Post $post): void
    {
        $cachePrefix = config('ActivityPub')
            ->cachePrefix;

        $hashedPostUri = md5($post->uri);

        model('ActorModel', false)
            ->clearCache($post->actor);
        cache()
            ->deleteMatching($cachePrefix . "post#{$post->id}*");
        cache()
            ->deleteMatching($cachePrefix . "post-{$hashedPostUri}*");

        if ($post->in_reply_to_id !== null) {
            $this->clearCache($post->reply_to_post);
        }

        if ($post->reblog_of_id !== null) {
            $this->clearCache($post->reblog_of_post);
        }
    }

    /**
     * @param array<string, array<string|int, mixed>> $data
     * @return array<string, array<string|int, mixed>>
     */
    protected function setPostId(array $data): array
    {
        $uuid4 = $this->uuid->{$this->uuidVersion}();
        $data['data']['id'] = $uuid4->toString();

        if (! isset($data['data']['uri'])) {
            $actor = model('ActorModel', false)
                ->getActorById((int) $data['data']['actor_id']);

            $data['data']['uri'] = url_to('post', $actor->username, $uuid4->toString());
        }

        return $data;
    }
}
