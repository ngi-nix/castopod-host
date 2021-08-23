<?= $this->extend('Modules\Admin\Views\_layout') ?>

<?= $this->section('title') ?>
<?= lang('User.edit_roles', ['username' => $user->username]) ?>
<?= $this->endSection() ?>

<?= $this->section('pageTitle') ?>
<?= lang('User.edit_roles', ['username' => $user->username]) ?>
<?= $this->endSection() ?>


<?= $this->section('content') ?>

<?= form_open(route_to('user-edit', $user->id), [
    'class' => 'flex flex-col max-w-sm',
]) ?>
<?= csrf_field() ?>

<?= form_label(lang('User.form.roles'), 'roles') ?>
<?= component('Forms/MultiSelect', ['options' => $roleOptions, 'selected' => $user->roles], [
    'id' => 'roles',
    'name' => 'roles[]',
    'class' => 'mb-4',
]) ?>

<?= button(
    lang('User.form.submit_edit'),
    '',
    ['variant' => 'primary'],
    ['type' => 'submit', 'class' => 'self-end'],
) ?>

<?= form_close() ?>

<?= $this->endSection() ?>
