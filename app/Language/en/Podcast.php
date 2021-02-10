<?php

/**
 * @copyright  2020 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

return [
    'all_podcasts' => 'All podcasts',
    'no_podcast' => 'No podcast found!',
    'create' => 'Create a podcast',
    'import' => 'Import a podcast',
    'new_episode' => 'New Episode',
    'feed' => 'RSS',
    'view' => 'View podcast',
    'edit' => 'Edit podcast',
    'delete' => 'Delete podcast',
    'see_episodes' => 'See episodes',
    'see_contributors' => 'See contributors',
    'go_to_page' => 'Go to page',
    'latest_episodes' => 'Latest episodes',
    'see_all_episodes' => 'See all episodes',
    'form' => [
        'identity_section_title' => 'Podcast identity',
        'identity_section_subtitle' => 'These fields allow you to get noticed.',
        'image' => 'Cover image',
        'title' => 'Title',
        'name' => 'Name',
        'name_hint' =>
            'Used for generating the podcast URL. Uppercase, lowercase, numbers and underscores are accepted.',
        'type' => [
            'label' => 'Type',
            'hint' =>
                '- <strong>episodic</strong>: if episodes are intended to be consumed without any specific order. Newest episodes will be presented first.<br/>- <strong>serial</strong>: if episodes are intended to be consumed in sequential order. The oldest episodes will be presented first.',
            'episodic' => 'Episodic',
            'serial' => 'Serial',
        ],
        'description' => 'Description',
        'classification_section_title' => 'Classification',
        'classification_section_subtitle' =>
            'These fields will impact your audience and competition.',
        'language' => 'Language',
        'category' => 'Category',
        'other_categories' => 'Other categories',
        'parental_advisory' => [
            'label' => 'Parental advisory',
            'hint' => 'Does it contain explicit content?',
            'undefined' => 'undefined',
            'clean' => 'Clean',
            'explicit' => 'Explicit',
        ],
        'author_section_title' => 'Author',
        'author_section_subtitle' => 'Who is managing the podcast?',
        'owner_name' => 'Owner name',
        'owner_name_hint' =>
            'For administrative use only. Visible in the public RSS feed.',
        'owner_email' => 'Owner email',
        'owner_email_hint' =>
            'Will be used by most platforms to verify the podcast ownership. Visible in the public RSS feed.',
        'publisher' => 'Publisher',
        'publisher_hint' =>
            'The group responsible for creating the show. Often refers to the parent company or network of a podcast. This field is sometimes labeled as ’Author’.',
        'copyright' => 'Copyright',
        'location_section_title' => 'Location',
        'location_section_subtitle' => 'What place is this podcast about?',
        'location_name' => 'Location name or address',
        'location_name_hint' => 'This can be a real place or fictional',
        'monetization_section_title' => 'Monetization',
        'monetization_section_subtitle' =>
            'Earn money thanks to your audience.',
        'payment_pointer' => 'Payment Pointer for Web Monetization',
        'payment_pointer_hint' =>
            'This is your where you will receive money thanks to Web Monetization',
        'status_section_title' => 'Status',
        'status_section_subtitle' => 'Dead or alive?',
        'block' => 'Podcast should be hidden from all platforms',
        'complete' => 'Podcast will not be having new episodes',
        'lock' => 'Prevent podcast from being copied',
        'lock_hint' =>
            'The purpose is to tell other podcast platforms whether they are allowed to import this feed. A value of yes means that any attempt to import this feed into a new platform should be rejected.',
        'submit_create' => 'Create podcast',
        'submit_edit' => 'Save podcast',
    ],
    'category_options' => [
        'uncategorized' => 'uncategorized',
        'arts' => 'Arts',
        'business' => 'Business',
        'comedy' => 'Comedy',
        'education' => 'Education',
        'fiction' => 'Fiction',
        'government' => 'Government',
        'health_and_fitness' => 'Health &amp Fitness',
        'history' => 'History',
        'kids_and_family' => 'Kids &amp Family',
        'leisure' => 'Leisure',
        'music' => 'Music',
        'news' => 'News',
        'religion_and_spirituality' => 'Religion &amp Spirituality',
        'science' => 'Science',
        'society_and_culture' => 'Society &amp Culture',
        'sports' => 'Sports',
        'technology' => 'Technology',
        'true_crime' => 'True Crime',
        'tv_and_film' => 'TV &amp Film',
        'books' => 'Books',
        'design' => 'Design',
        'fashion_and_beauty' => 'Fashion &amp Beauty',
        'food' => 'Food',
        'performing_arts' => 'Performing Arts',
        'visual_arts' => 'Visual Arts',
        'careers' => 'Careers',
        'entrepreneurship' => 'Entrepreneurship',
        'investing' => 'Investing',
        'management' => 'Management',
        'marketing' => 'Marketing',
        'non_profit' => 'Non-Profit',
        'comedy_interviews' => 'Comedy Interviews',
        'improv' => 'Improv',
        'stand_up' => 'Stand-Up',
        'courses' => 'Courses',
        'how_to' => 'How To',
        'language_learning' => 'Language Learning',
        'self_improvement' => 'Self-Improvement',
        'comedy_fiction' => 'Comedy Fiction',
        'drama' => 'Drama',
        'science_fiction' => 'Science Fiction',
        'alternative_health' => 'Alternative Health',
        'fitness' => 'Fitness',
        'medicine' => 'Medicine',
        'mental_health' => 'Mental Health',
        'nutrition' => 'Nutrition',
        'sexuality' => 'Sexuality',
        'education_for_kids' => 'Education for Kids',
        'parenting' => 'Parenting',
        'pets_and_animals' => 'Pets &amp Animals',
        'stories_for_kids' => 'Stories for Kids',
        'animation_and_manga' => 'Animation &amp Manga',
        'automotive' => 'Automotive',
        'aviation' => 'Aviation',
        'crafts' => 'Crafts',
        'games' => 'Games',
        'hobbies' => 'Hobbies',
        'home_and_garden' => 'Home &amp Garden',
        'video_games' => 'Video Games',
        'music_commentary' => 'Music Commentary',
        'music_history' => 'Music History',
        'music_interviews' => 'Music Interviews',
        'business_news' => 'Business News',
        'daily_news' => 'Daily News',
        'entertainment_news' => 'Entertainment News',
        'news_commentary' => 'News Commentary',
        'politics' => 'Politics',
        'sports_news' => 'Sports News',
        'tech_news' => 'Tech News',
        'buddhism' => 'Buddhism',
        'christianity' => 'Christianity',
        'hinduism' => 'Hinduism',
        'islam' => 'Islam',
        'judaism' => 'Judaism',
        'religion' => 'Religion',
        'spirituality' => 'Spirituality',
        'astronomy' => 'Astronomy',
        'chemistry' => 'Chemistry',
        'earth_sciences' => 'Earth Sciences',
        'life_sciences' => 'Life Sciences',
        'mathematics' => 'Mathematics',
        'natural_sciences' => 'Natural Sciences',
        'nature' => 'Nature',
        'physics' => 'Physics',
        'social_sciences' => 'Social Sciences',
        'documentary' => 'Documentary',
        'personal_journals' => 'Personal Journals',
        'philosophy' => 'Philosophy',
        'places_and_travel' => 'Places &amp Travel',
        'relationships' => 'Relationships',
        'baseball' => 'Baseball',
        'basketball' => 'Basketball',
        'cricket' => 'Cricket',
        'fantasy_sports' => 'Fantasy Sports',
        'football' => 'Football',
        'golf' => 'Golf',
        'hockey' => 'Hockey',
        'rugby' => 'Rugby',
        'running' => 'Running',
        'soccer' => 'Soccer',
        'swimming' => 'Swimming',
        'tennis' => 'Tennis',
        'volleyball' => 'Volleyball',
        'wilderness' => 'Wilderness',
        'wrestling' => 'Wrestling',
        'after_shows' => 'After Shows',
        'film_history' => 'Film History',
        'film_interviews' => 'Film Interviews',
        'film_reviews' => 'Film Reviews',
        'tv_reviews' => 'TV Reviews',
    ],
    'by' => 'By {publisher}',
    'season' => 'Season {seasonNumber}',
    'list_of_episodes_year' => '{year} episodes',
    'list_of_episodes_season' => 'Season {seasonNumber} episodes',
    'no_episode' => 'No episode found!',
    'no_episode_hint' =>
        'Navigate the podcast episodes with the navigation bar above.',
];
