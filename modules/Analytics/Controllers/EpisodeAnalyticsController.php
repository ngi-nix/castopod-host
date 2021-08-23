<?php

declare(strict_types=1);

/**
 * @copyright  2020 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

namespace Modules\Analytics\Controllers;

use CodeIgniter\Controller;
use CodeIgniter\HTTP\RedirectResponse;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\Services;
use Modules\Analytics\Config\Analytics;
use Psr\Log\LoggerInterface;

class EpisodeAnalyticsController extends Controller
{
    /**
     * An array of helpers to be loaded automatically upon class instantiation. These helpers will be available to all
     * other controllers that extend Analytics.
     *
     * @var string[]
     */
    protected $helpers = ['analytics'];

    protected Analytics $config;

    /**
     * Constructor.
     */
    public function initController(
        RequestInterface $request,
        ResponseInterface $response,
        LoggerInterface $logger
    ): void {
        // Do Not Edit This Line
        parent::initController($request, $response, $logger);

        set_user_session_deny_list_ip();
        set_user_session_location();
        set_user_session_player();

        $this->config = config('Analytics');
    }

    public function hit(string $base64EpisodeData, string ...$audioFilePath): RedirectResponse
    {
        $session = Services::session();
        $session->start();

        $serviceName = '';
        if (isset($_GET['_from'])) {
            $serviceName = $_GET['_from'];
        } elseif ($session->get('embeddable_player_domain') !== null) {
            $serviceName = $session->get('embeddable_player_domain');
        } elseif ($session->get('referer') !== null && $session->get('referer') !== '- Direct -') {
            $serviceName = parse_url($session->get('referer'), PHP_URL_HOST);
        }

        $episodeData = unpack(
            'IpodcastId/IepisodeId/IbytesThreshold/IfileSize/Iduration/IpublicationDate',
            base64_url_decode($base64EpisodeData),
        );

        podcast_hit(
            $episodeData['podcastId'],
            $episodeData['episodeId'],
            $episodeData['bytesThreshold'],
            $episodeData['fileSize'],
            $episodeData['duration'],
            $episodeData['publicationDate'],
            $serviceName,
        );

        return redirect()->to($this->config->getAudioFileUrl(['podcasts', ...$audioFilePath]));
    }
}
