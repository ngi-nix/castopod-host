<?php

declare(strict_types=1);

/**
 * @copyright  2021 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

namespace App\Models;

use App\Entities\Actor;
use Modules\Fediverse\Models\ActorModel as FediverseActorModel;

class ActorModel extends FediverseActorModel
{
    /**
     * @var string
     */
    protected $returnType = Actor::class;
}
