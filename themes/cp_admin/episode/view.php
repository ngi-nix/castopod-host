<?= $this->extend('_layout') ?>

<?= $this->section('title') ?>
<?= $episode->title ?>
<?= $this->endSection() ?>

<?= $this->section('pageTitle') ?>
<?= $episode->title ?>    
<?= $this->endSection() ?>

<?= $this->section('headerLeft') ?>
<?= publication_pill(
    $episode->published_at,
    $episode->publication_status,
    'text-sm ml-2 align-middle',
) ?>
<?= $this->endSection() ?>

<?= $this->section('headerRight') ?>
<?= publication_button(
    $podcast->id,
    $episode->id,
    $episode->publication_status,
) ?>
<?= $this->endSection() ?>


<?= $this->section('content') ?>

<div class="mb-12">
    <?= audio_player($episode->audio_file_url, $episode->audio_file_mimetype) ?>
</div>

<div class="grid grid-cols-1 gap-4 lg:grid-cols-2">
    <Charts.XY title="<?= lang('Charts.episode_by_day') ?>" dataUrl="<?= route_to(
    'analytics-filtered-data',
    $podcast->id,
    'PodcastByEpisode',
    'ByDay',
    $episode->id,
) ?>"/>

    <Charts.XY title="<?= lang('Charts.episode_by_month') ?>" dataUrl="<?= route_to(
    'analytics-filtered-data',
    $podcast->id,
    'PodcastByEpisode',
    'ByMonth',
    $episode->id,
) ?>"/>
</div>


<?= service('vite')
    ->asset('js/charts.ts', 'js') ?>
<?= $this->endSection() ?>
