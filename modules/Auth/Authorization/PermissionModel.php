<?php

declare(strict_types=1);

namespace Modules\Auth\Authorization;

use Myth\Auth\Authorization\PermissionModel as MythAuthPermissionModel;

class PermissionModel extends MythAuthPermissionModel
{
    /**
     * Checks to see if a user, or one of their groups, has a specific permission.
     */
    public function doesGroupHavePermission(int $groupId, int $permissionId): bool
    {
        // Check group permissions and take advantage of caching
        $groupPerms = $this->getPermissionsForGroup($groupId);

        return count($groupPerms) &&
            array_key_exists($permissionId, $groupPerms);
    }

    /**
     * Gets all permissions for a group in a way that can be easily used to check against:
     *
     * [ id => name, id => name ]
     *
     * @return array<int, string>
     */
    public function getPermissionsForGroup(int $groupId): array
    {
        $cacheName = "group{$groupId}_permissions";
        if (! ($found = cache($cacheName))) {
            $groupPermissions = $this->db
                ->table('auth_groups_permissions')
                ->select('id, auth_permissions.name')
                ->join('auth_permissions', 'auth_permissions.id = permission_id', 'inner')
                ->where('group_id', $groupId)
                ->get()
                ->getResultObject();

            $found = [];
            foreach ($groupPermissions as $row) {
                $found[$row->id] = strtolower($row->name);
            }

            cache()
                ->save($cacheName, $found, 300);
        }

        return $found;
    }
}
