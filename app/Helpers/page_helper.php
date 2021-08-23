<?php

declare(strict_types=1);

/**
 * @copyright  2020 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

use App\Models\PageModel;

if (! function_exists('render_page_links')) {
    /**
     * Returns instance pages as links inside nav tag
     *
     * @return string html pages navigation
     */
    function render_page_links(string $class = null): string
    {
        $pages = (new PageModel())->findAll();
        $links = anchor(route_to('home'), lang('Common.home'), [
            'class' => 'px-2 py-1 underline hover:no-underline',
        ]);
        $links .= anchor(route_to('credits'), lang('Person.credits'), [
            'class' => 'px-2  py-1 underline hover:no-underline',
        ]);
        foreach ($pages as $page) {
            $links .= anchor($page->link, $page->title, [
                'class' => 'px-2  py-1 underline hover:no-underline',
            ]);
        }

        return '<nav class="' . $class . '">' . $links . '</nav>';
    }
}
