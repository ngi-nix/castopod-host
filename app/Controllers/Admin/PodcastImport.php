<?php

/**
 * @copyright  2020 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

namespace App\Controllers\Admin;

use App\Models\CategoryModel;
use App\Models\LanguageModel;
use App\Models\PodcastModel;
use App\Models\EpisodeModel;
use App\Models\PlatformModel;
use App\Models\PersonModel;
use App\Models\PodcastPersonModel;
use App\Models\EpisodePersonModel;
use Config\Services;
use League\HTMLToMarkdown\HtmlConverter;

class PodcastImport extends BaseController
{
    /**
     * @var \App\Entities\Podcast|null
     */
    protected $podcast;

    public function _remap($method, ...$params)
    {
        if (count($params) > 0) {
            if (
                !($this->podcast = (new PodcastModel())->getPodcastById(
                    $params[0],
                ))
            ) {
                throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound();
            }
        }

        return $this->$method();
    }

    public function index()
    {
        helper(['form', 'misc']);

        $languageOptions = (new LanguageModel())->getLanguageOptions();
        $categoryOptions = (new CategoryModel())->getCategoryOptions();

        $data = [
            'languageOptions' => $languageOptions,
            'categoryOptions' => $categoryOptions,
            'browserLang' => get_browser_language(
                $this->request->getServer('HTTP_ACCEPT_LANGUAGE'),
            ),
        ];

        return view('admin/podcast/import', $data);
    }

    public function attemptImport()
    {
        helper(['media', 'misc']);

        $rules = [
            'imported_feed_url' => 'required|validate_url',
            'season_number' => 'is_natural_no_zero|permit_empty',
            'max_episodes' => 'is_natural_no_zero|permit_empty',
        ];

        if (!$this->validate($rules)) {
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', $this->validator->getErrors());
        }
        try {
            ini_set('user_agent', 'Castopod/' . CP_VERSION);
            $feed = simplexml_load_file(
                $this->request->getPost('imported_feed_url'),
            );
        } catch (\ErrorException $ex) {
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', [
                    $ex->getMessage() .
                    ': <a href="' .
                    $this->request->getPost('imported_feed_url') .
                    '" rel="noreferrer noopener" target="_blank">' .
                    $this->request->getPost('imported_feed_url') .
                    ' ⎋</a>',
                ]);
        }
        $nsItunes = $feed->channel[0]->children(
            'http://www.itunes.com/dtds/podcast-1.0.dtd',
        );
        $nsPodcast = $feed->channel[0]->children(
            'https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md',
        );
        $nsContent = $feed->channel[0]->children(
            'http://purl.org/rss/1.0/modules/content/',
        );

        /*if ((string) $nsPodcast->locked === 'yes') {
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', [lang('PodcastImport.lock_import')]);
        }*/

        $converter = new HtmlConverter();

        $channelDescriptionHtml = (string) $feed->channel[0]->description;

        try {
            $podcast = new \App\Entities\Podcast([
                'name' => $this->request->getPost('name'),
                'imported_feed_url' => $this->request->getPost(
                    'imported_feed_url',
                ),
                'new_feed_url' => base_url(
                    route_to('podcast_feed', $this->request->getPost('name')),
                ),
                'title' => (string) $feed->channel[0]->title,
                'description_markdown' => $converter->convert(
                    $channelDescriptionHtml,
                ),
                'description_html' => $channelDescriptionHtml,
                'image' =>
                    $nsItunes->image && !empty($nsItunes->image->attributes())
                        ? download_file(
                            (string) $nsItunes->image->attributes()['href'],
                        )
                        : ($feed->channel[0]->image &&
                        !empty($feed->channel[0]->image->url)
                            ? download_file(
                                (string) $feed->channel[0]->image->url,
                            )
                            : null),
                'language_code' => $this->request->getPost('language'),
                'category_id' => $this->request->getPost('category'),
                'parental_advisory' => empty($nsItunes->explicit)
                    ? null
                    : (in_array($nsItunes->explicit, ['yes', 'true'])
                        ? 'explicit'
                        : (in_array($nsItunes->explicit, ['no', 'false'])
                            ? 'clean'
                            : null)),
                'owner_name' => (string) $nsItunes->owner->name,
                'owner_email' => (string) $nsItunes->owner->email,
                'publisher' => (string) $nsItunes->author,
                'type' => empty($nsItunes->type) ? 'episodic' : $nsItunes->type,
                'copyright' => (string) $feed->channel[0]->copyright,
                'is_blocked' => empty($nsItunes->block)
                    ? false
                    : $nsItunes->block === 'yes',
                'is_completed' => empty($nsItunes->complete)
                    ? false
                    : $nsItunes->complete === 'yes',
                'location_name' => !$nsPodcast->location
                    ? null
                    : (string) $nsPodcast->location,
                'location_geo' =>
                    !$nsPodcast->location ||
                    empty($nsPodcast->location->attributes()['geo'])
                        ? null
                        : (string) $nsPodcast->location->attributes()['geo'],
                'location_osmid' =>
                    !$nsPodcast->location ||
                    empty($nsPodcast->location->attributes()['osm'])
                        ? null
                        : (string) $nsPodcast->location->attributes()['osm'],
                'created_by' => user()->id,
                'updated_by' => user()->id,
            ]);
        } catch (\ErrorException $ex) {
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', [
                    $ex->getMessage() .
                    ': <a href="' .
                    $this->request->getPost('imported_feed_url') .
                    '" rel="noreferrer noopener" target="_blank">' .
                    $this->request->getPost('imported_feed_url') .
                    ' ⎋</a>',
                ]);
        }

        $podcastModel = new PodcastModel();
        $db = \Config\Database::connect();

        $db->transStart();

        if (!($newPodcastId = $podcastModel->insert($podcast, true))) {
            $db->transRollback();
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', $podcastModel->errors());
        }

        $authorize = Services::authorization();
        $podcastAdminGroup = $authorize->group('podcast_admin');

        $podcastModel->addPodcastContributor(
            user()->id,
            $newPodcastId,
            $podcastAdminGroup->id,
        );

        $podcastsPlatformsData = [];
        $platformTypes = [
            ['name' => 'podcasting', 'elements' => $nsPodcast->id],
            ['name' => 'social', 'elements' => $nsPodcast->social],
            ['name' => 'funding', 'elements' => $nsPodcast->funding],
        ];
        $platformModel = new PlatformModel();
        foreach ($platformTypes as $platformType) {
            foreach ($platformType['elements'] as $platform) {
                $platformLabel = $platform->attributes()['platform'];
                $platformSlug = slugify($platformLabel);
                if ($platformModel->getPlatform($platformSlug)) {
                    array_push($podcastsPlatformsData, [
                        'platform_slug' => $platformSlug,
                        'podcast_id' => $newPodcastId,
                        'link_url' => $platform->attributes()['url'],
                        'link_content' => $platform->attributes()['id'],
                        'is_visible' => false,
                    ]);
                }
            }
        }
        if (count($podcastsPlatformsData) > 1) {
            $platformModel->createPodcastPlatforms(
                $newPodcastId,
                $podcastsPlatformsData,
            );
        }

        foreach ($nsPodcast->person as $podcastPerson) {
            $personModel = new PersonModel();
            $newPersonId = null;
            if ($newPerson = $personModel->getPerson($podcastPerson)) {
                $newPersonId = $newPerson->id;
            } else {
                if (
                    !($newPersonId = $personModel->createPerson(
                        $podcastPerson,
                        $podcastPerson->attributes()['href'],
                        $podcastPerson->attributes()['img'],
                    ))
                ) {
                    return redirect()
                        ->back()
                        ->withInput()
                        ->with('errors', $personModel->errors());
                }
            }

            $personGroup = empty($podcastPerson->attributes()['group'])
                ? ['slug' => '']
                : \Podlibre\PodcastNamespace\ReversedTaxonomy::$taxonomy[
                    (string) $podcastPerson->attributes()['group']
                ];
            $personRole =
                empty($podcastPerson->attributes()['role']) ||
                empty($personGroup)
                    ? ['slug' => '']
                    : $personGroup['roles'][
                        strval($podcastPerson->attributes()['role'])
                    ];
            $newPodcastPerson = new \App\Entities\PodcastPerson([
                'podcast_id' => $newPodcastId,
                'person_id' => $newPersonId,
                'person_group' => $personGroup['slug'],
                'person_role' => $personRole['slug'],
            ]);
            $podcastPersonModel = new PodcastPersonModel();

            if (!$podcastPersonModel->insert($newPodcastPerson)) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('errors', $podcastPersonModel->errors());
            }
        }

        $numberItems = $feed->channel[0]->item->count();
        $lastItem =
            !empty($this->request->getPost('max_episodes')) &&
            $this->request->getPost('max_episodes') < $numberItems
                ? $this->request->getPost('max_episodes')
                : $numberItems;

        $slugs = [];

        //////////////////////////////////////////////////////////////////
        // For each Episode:
        for ($itemNumber = 1; $itemNumber <= $lastItem; $itemNumber++) {
            $item = $feed->channel[0]->item[$numberItems - $itemNumber];

            $nsItunes = $item->children(
                'http://www.itunes.com/dtds/podcast-1.0.dtd',
            );
            $nsPodcast = $item->children(
                'https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md',
            );
            $nsContent = $item->children(
                'http://purl.org/rss/1.0/modules/content/',
            );

            $slug = slugify(
                $this->request->getPost('slug_field') === 'title'
                    ? $item->title
                    : basename($item->link),
            );
            if (in_array($slug, $slugs)) {
                $slugNumber = 2;
                while (in_array($slug . '-' . $slugNumber, $slugs)) {
                    $slugNumber++;
                }
                $slug = $slug . '-' . $slugNumber;
            }
            $slugs[] = $slug;

            $itemDescriptionHtml = null;
            switch ($this->request->getPost('description_field')) {
                case 'content':
                    $itemDescriptionHtml = $nsContent->encoded;
                    break;
                case 'summary':
                    $itemDescriptionHtml = $nsItunes->summary;
                    break;
                case 'subtitle_summary':
                    $itemDescriptionHtml =
                        $nsItunes->subtitle . '<br/>' . $nsItunes->summary;
                    break;
                default:
                    $itemDescriptionHtml = $item->description;
            }

            $newEpisode = new \App\Entities\Episode([
                'podcast_id' => $newPodcastId,
                'guid' => empty($item->guid) ? null : $item->guid,
                'title' => $item->title,
                'slug' => $slug,
                'audio_file' => download_file(
                    $item->enclosure->attributes()['url'],
                ),
                'description_markdown' => $converter->convert(
                    $itemDescriptionHtml,
                ),
                'description_html' => $itemDescriptionHtml,
                'image' =>
                    !$nsItunes->image || empty($nsItunes->image->attributes())
                        ? null
                        : download_file(
                            (string) $nsItunes->image->attributes()['href'],
                        ),
                'parental_advisory' => empty($nsItunes->explicit)
                    ? null
                    : (in_array($nsItunes->explicit, ['yes', 'true'])
                        ? 'explicit'
                        : (in_array($nsItunes->explicit, ['no', 'false'])
                            ? 'clean'
                            : null)),
                'number' =>
                    $this->request->getPost('force_renumber') === 'yes'
                        ? $itemNumber
                        : (!empty($nsItunes->episode)
                            ? $nsItunes->episode
                            : null),
                'season_number' => empty(
                    $this->request->getPost('season_number')
                )
                    ? (!empty($nsItunes->season)
                        ? $nsItunes->season
                        : null)
                    : $this->request->getPost('season_number'),
                'type' => empty($nsItunes->episodeType)
                    ? 'full'
                    : $nsItunes->episodeType,
                'is_blocked' => empty($nsItunes->block)
                    ? false
                    : $nsItunes->block === 'yes',
                'location_name' => !$nsPodcast->location
                    ? null
                    : $nsPodcast->location,
                'location_geo' =>
                    !$nsPodcast->location ||
                    empty($nsPodcast->location->attributes()['geo'])
                        ? null
                        : $nsPodcast->location->attributes()['geo'],
                'location_osmid' =>
                    !$nsPodcast->location ||
                    empty($nsPodcast->location->attributes()['osm'])
                        ? null
                        : $nsPodcast->location->attributes()['osm'],
                'transcript_file_remote_url' => !$nsPodcast->transcript
                    ? null
                    : $nsPodcast->transcript->attributes()['url'],
                'chapters_file_remote_url' => !$nsPodcast->chapters
                    ? null
                    : $nsPodcast->chapters->attributes()['url'],
                'created_by' => user()->id,
                'updated_by' => user()->id,
                'published_at' => strtotime($item->pubDate),
            ]);

            $episodeModel = new EpisodeModel();

            if (!($newEpisodeId = $episodeModel->insert($newEpisode, true))) {
                // FIXME: What shall we do?
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('errors', $episodeModel->errors());
            }

            foreach ($nsPodcast->person as $episodePerson) {
                $personModel = new PersonModel();
                $newPersonId = null;
                if ($newPerson = $personModel->getPerson($episodePerson)) {
                    $newPersonId = $newPerson->id;
                } else {
                    if (
                        !($newPersonId = $personModel->createPerson(
                            $episodePerson,
                            $episodePerson->attributes()['href'],
                            $episodePerson->attributes()['img'],
                        ))
                    ) {
                        return redirect()
                            ->back()
                            ->withInput()
                            ->with('errors', $personModel->errors());
                    }
                }

                $personGroup = empty($episodePerson->attributes()['group'])
                    ? ['slug' => '']
                    : \Podlibre\PodcastNamespace\ReversedTaxonomy::$taxonomy[
                        strval($episodePerson->attributes()['group'])
                    ];
                $personRole =
                    empty($episodePerson->attributes()['role']) ||
                    empty($personGroup)
                        ? ['slug' => '']
                        : $personGroup['roles'][
                            strval($episodePerson->attributes()['role'])
                        ];
                $newEpisodePerson = new \App\Entities\PodcastPerson([
                    'podcast_id' => $newPodcastId,
                    'episode_id' => $newEpisodeId,
                    'person_id' => $newPersonId,
                    'person_group' => $personGroup['slug'],
                    'person_role' => $personRole['slug'],
                ]);

                $episodePersonModel = new EpisodePersonModel();
                if (!$episodePersonModel->insert($newEpisodePerson)) {
                    return redirect()
                        ->back()
                        ->withInput()
                        ->with('errors', $episodePersonModel->errors());
                }
            }
        }

        // set interact as the newly imported podcast actor
        $importedPodcast = (new PodcastModel())->getPodcastById($newPodcastId);
        set_interact_as_actor($importedPodcast->actor_id);

        $db->transComplete();

        return redirect()->route('podcast-view', [$newPodcastId]);
    }
}
