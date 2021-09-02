<?php

declare(strict_types=1);

/**
 * @copyright  2020 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

namespace Modules\Admin\Controllers;

use App\Entities\Image;
use App\Entities\Location;
use App\Entities\Podcast;
use App\Models\CategoryModel;
use App\Models\EpisodeModel;
use App\Models\LanguageModel;
use App\Models\PodcastModel;
use CodeIgniter\Exceptions\PageNotFoundException;
use CodeIgniter\HTTP\RedirectResponse;
use Config\Services;

class PodcastController extends BaseController
{
    protected Podcast $podcast;

    public function _remap(string $method, string ...$params): mixed
    {
        if ($params === []) {
            return $this->{$method}();
        }

        if (
            ($podcast = (new PodcastModel())->getPodcastById((int) $params[0])) !== null
        ) {
            $this->podcast = $podcast;
            return $this->{$method}();
        }

        throw PageNotFoundException::forPageNotFound();
    }

    public function list(): string
    {
        if (! has_permission('podcasts-list')) {
            $data = [
                'podcasts' => (new PodcastModel())->getUserPodcasts((int) user_id()),
            ];
        } else {
            $data = [
                'podcasts' => (new PodcastModel())->findAll(),
            ];
        }

        return view('podcast/list', $data);
    }

    public function view(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/view', $data);
    }

    public function viewAnalytics(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/analytics/index', $data);
    }

    public function viewAnalyticsWebpages(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/analytics/webpages', $data);
    }

    public function viewAnalyticsLocations(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/analytics/locations', $data);
    }

    public function viewAnalyticsUniqueListeners(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/analytics/unique_listeners', $data);
    }

    public function viewAnalyticsListeningTime(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/analytics/listening_time', $data);
    }

    public function viewAnalyticsTimePeriods(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/analytics/time_periods', $data);
    }

    public function viewAnalyticsPlayers(): string
    {
        $data = [
            'podcast' => $this->podcast,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/analytics/players', $data);
    }

    public function create(): string
    {
        helper(['form', 'misc']);

        $languageOptions = (new LanguageModel())->getLanguageOptions();
        $categoryOptions = (new CategoryModel())->getCategoryOptions();

        $data = [
            'languageOptions' => $languageOptions,
            'categoryOptions' => $categoryOptions,
            'browserLang' => get_browser_language($this->request->getServer('HTTP_ACCEPT_LANGUAGE')),
        ];

        return view('podcast/create', $data);
    }

    public function attemptCreate(): RedirectResponse
    {
        $rules = [
            'image' =>
                'uploaded[image]|is_image[image]|ext_in[image,jpg,png]|min_dims[image,1400,1400]|is_image_squared[image]',
        ];

        if (! $this->validate($rules)) {
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', $this->validator->getErrors());
        }

        if (
            ($partnerId = $this->request->getPost('partner_id')) === '' ||
            ($partnerLinkUrl = $this->request->getPost('partner_link_url')) === '' ||
            ($partnerImageUrl = $this->request->getPost('partner_image_url')) === '') {
            $partnerId = null;
            $partnerLinkUrl = null;
            $partnerImageUrl = null;
        }

        $podcast = new Podcast([
            'guid' => podcast_uuid(url_to('podcast_feed', $this->request->getPost('handle'))),
            'title' => $this->request->getPost('title'),
            'handle' => $this->request->getPost('handle'),
            'description_markdown' => $this->request->getPost('description'),
            'image' => new Image($this->request->getFile('image')),
            'language_code' => $this->request->getPost('language'),
            'category_id' => $this->request->getPost('category'),
            'parental_advisory' =>
                $this->request->getPost('parental_advisory') !== 'undefined'
                    ? $this->request->getPost('parental_advisory')
                    : null,
            'owner_name' => $this->request->getPost('owner_name'),
            'owner_email' => $this->request->getPost('owner_email'),
            'publisher' => $this->request->getPost('publisher'),
            'type' => $this->request->getPost('type'),
            'copyright' => $this->request->getPost('copyright'),
            'location' => $this->request->getPost('location_name') === '' ? null : new Location($this->request->getPost(
                'location_name'
            )),
            'payment_pointer' => $this->request->getPost(
                'payment_pointer'
            ) === '' ? null : $this->request->getPost('payment_pointer'),
            'custom_rss_string' => $this->request->getPost('custom_rss'),
            'partner_id' => $partnerId,
            'partner_link_url' => $partnerLinkUrl,
            'partner_image_url' => $partnerImageUrl,
            'is_blocked' => $this->request->getPost('block') === 'yes',
            'is_completed' => $this->request->getPost('complete') === 'yes',
            'is_locked' => $this->request->getPost('lock') === 'yes',
            'created_by' => user_id(),
            'updated_by' => user_id(),
        ]);

        $podcastModel = new PodcastModel();
        $db = db_connect();

        $db->transStart();

        if (! ($newPodcastId = $podcastModel->insert($podcast, true))) {
            $db->transRollback();
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', $podcastModel->errors());
        }

        $authorize = Services::authorization();
        $podcastAdminGroup = $authorize->group('podcast_admin');

        $podcastModel->addPodcastContributor(user_id(), $newPodcastId, (int) $podcastAdminGroup->id);

        // set Podcast categories
        (new CategoryModel())->setPodcastCategories(
            (int) $newPodcastId,
            $this->request->getPost('other_categories') ?? [],
        );

        // set interact as the newly created podcast actor
        $createdPodcast = (new PodcastModel())->getPodcastById($newPodcastId);
        set_interact_as_actor($createdPodcast->actor_id);

        $db->transComplete();

        return redirect()->route('podcast-view', [$newPodcastId]);
    }

    public function edit(): string
    {
        helper('form');

        $languageOptions = (new LanguageModel())->getLanguageOptions();
        $categoryOptions = (new CategoryModel())->getCategoryOptions();

        $data = [
            'podcast' => $this->podcast,
            'languageOptions' => $languageOptions,
            'categoryOptions' => $categoryOptions,
        ];

        replace_breadcrumb_params([
            0 => $this->podcast->title,
        ]);
        return view('podcast/edit', $data);
    }

    public function attemptEdit(): RedirectResponse
    {
        $rules = [
            'image' =>
                'is_image[image]|ext_in[image,jpg,png]|min_dims[image,1400,1400]|is_image_squared[image]',
        ];

        if (! $this->validate($rules)) {
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', $this->validator->getErrors());
        }

        if (
            ($partnerId = $this->request->getPost('partner_id')) === '' ||
            ($partnerLinkUrl = $this->request->getPost('partner_link_url')) === '' ||
            ($partnerImageUrl = $this->request->getPost('partner_image_url')) === '') {
            $partnerId = null;
            $partnerLinkUrl = null;
            $partnerImageUrl = null;
        }

        $this->podcast->title = $this->request->getPost('title');
        $this->podcast->description_markdown = $this->request->getPost('description');

        $image = $this->request->getFile('image');
        if ($image !== null && $image->isValid()) {
            $this->podcast->image = new Image($image);
        }
        $this->podcast->language_code = $this->request->getPost('language');
        $this->podcast->category_id = $this->request->getPost('category');
        $this->podcast->parental_advisory =
            $this->request->getPost('parental_advisory') !== 'undefined'
                ? $this->request->getPost('parental_advisory')
                : null;
        $this->podcast->publisher = $this->request->getPost('publisher');
        $this->podcast->owner_name = $this->request->getPost('owner_name');
        $this->podcast->owner_email = $this->request->getPost('owner_email');
        $this->podcast->type = $this->request->getPost('type');
        $this->podcast->copyright = $this->request->getPost('copyright');
        $this->podcast->location = $this->request->getPost('location_name') === '' ? null : new Location(
            $this->request->getPost('location_name')
        );
        $this->podcast->payment_pointer = $this->request->getPost(
            'payment_pointer'
        ) === '' ? null : $this->request->getPost('payment_pointer');
        $this->podcast->custom_rss_string = $this->request->getPost('custom_rss');
        $this->podcast->partner_id = $partnerId;
        $this->podcast->partner_link_url = $partnerLinkUrl;
        $this->podcast->partner_image_url = $partnerImageUrl;
        $this->podcast->is_blocked = $this->request->getPost('block') === 'yes';
        $this->podcast->is_completed =
            $this->request->getPost('complete') === 'yes';
        $this->podcast->is_locked = $this->request->getPost('lock') === 'yes';
        $this->podcast->updated_by = (int) user_id();

        $db = db_connect();
        $db->transStart();

        $podcastModel = new PodcastModel();
        if (! $podcastModel->update($this->podcast->id, $this->podcast)) {
            $db->transRollback();
            return redirect()
                ->back()
                ->withInput()
                ->with('errors', $podcastModel->errors());
        }

        // set Podcast categories
        (new CategoryModel())->setPodcastCategories(
            $this->podcast->id,
            $this->request->getPost('other_categories') ?? [],
        );

        $db->transComplete();

        return redirect()->route('podcast-view', [$this->podcast->id]);
    }

    public function latestEpisodes(int $limit, int $podcastId): string
    {
        $episodes = (new EpisodeModel())
            ->where('podcast_id', $podcastId)
            ->orderBy('created_at', 'desc')
            ->findAll($limit);

        return view('podcast/latest_episodes', [
            'episodes' => $episodes,
            'podcast' => (new PodcastModel())->getPodcastById($podcastId),
        ]);
    }

    public function delete(): RedirectResponse
    {
        (new PodcastModel())->delete($this->podcast->id);

        return redirect()->route('podcast-list');
    }
}
