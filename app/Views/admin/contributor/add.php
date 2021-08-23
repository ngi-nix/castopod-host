<?= $this->extend('admin/_layout') ?>

<?= $this->section('title') ?>
<?= lang('Contributor.add_contributor', [$podcast->title]) ?>
<?= $this->endSection() ?>

<?= $this->section('pageTitle') ?>
<?= lang('Contributor.add_contributor', [$podcast->title]) ?>
<?= $this->endSection() ?>


<?= $this->section('content') ?>

<?= form_open(route_to('contributor-add', $podcast->id), [
    'class' => 'flex flex-col max-w-sm',
]) ?>
<?= csrf_field() ?>
    
<?= component('Forms/Label', ['text' => lang('Contributor.form.user')], ['for' => 'user']) ?>
<?= form_dropdown('user', $userOptions, [old('user', '')], [
    'id' => 'user',
    'class' => 'form-select mb-4',
    'required' => 'required',
    'placeholder' => lang('Contributor.form.user_placeholder')
]) ?>

<?= component('Forms/Label', ['text' => lang('Contributor.form.role')], ['for' => 'role']) ?>
<?= form_dropdown('role', $roleOptions, [old('role', '')], [
    'id' => 'role',
    'class' => 'form-select mb-4',
    'required' => 'required',
    'placeholder' => lang('Contributor.form.role_placeholder')
]) ?>

<?= button(
    lang('Contributor.form.submit_add'),
    '',
    ['variant' => 'primary'],
    ['type' => 'submit', 'class' => 'self-end'],
) ?>

<?= form_close() ?>

<?= $this->endSection() ?>
