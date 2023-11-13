<?php

// @formatter:off
/**
 * A helper file for your Eloquent Models
 * Copy the phpDocs from this file to the correct Model,
 * And remove them from this file, to prevent double declarations.
 *
 * @author Barry vd. Heuvel <barryvdh@gmail.com>
 */


namespace App\Models{
/**
 * App\Models\Action
 *
 * @property int $id
 * @property string $name
 * @property string $api_endpoint
 * @property mixed $return_params
 * @property mixed $default_config
 * @property int $service_id
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\ActionConfig> $actionConfigs
 * @property-read int|null $action_configs_count
 * @property-read \App\Models\Service $service
 * @method static \Illuminate\Database\Eloquent\Builder|Action newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Action newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Action query()
 * @method static \Illuminate\Database\Eloquent\Builder|Action whereApiEndpoint($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Action whereDefaultConfig($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Action whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Action whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Action whereReturnParams($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Action whereServiceId($value)
 * @mixin \Eloquent
 */
	class IdeHelperAction {}
}

namespace App\Models{
/**
 * App\Models\ActionConfig
 *
 * @property int $id
 * @property mixed $config
 * @property int $action_id
 * @property int $area_id
 * @property-read \App\Models\Action $action
 * @property-read \App\Models\Area $area
 * @method static \Illuminate\Database\Eloquent\Builder|ActionConfig newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|ActionConfig newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|ActionConfig query()
 * @method static \Illuminate\Database\Eloquent\Builder|ActionConfig whereActionId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|ActionConfig whereAreaId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|ActionConfig whereConfig($value)
 * @method static \Illuminate\Database\Eloquent\Builder|ActionConfig whereId($value)
 * @mixin \Eloquent
 */
	class IdeHelperActionConfig {}
}

namespace App\Models{
/**
 * App\Models\AreaHandler
 *
 * @property int $id
 * @property string $name
 * @property int $refresh
 * @property int $user_id
 * @property-read \App\Models\ActionConfig|null $actionConfig
 * @property-read \App\Models\ReactionConfig|null $reactionConfig
 * @property-read \App\Models\User $user
 * @method static \Illuminate\Database\Eloquent\Builder|Area newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Area newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Area query()
 * @method static \Illuminate\Database\Eloquent\Builder|Area whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Area whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Area whereRefresh($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Area whereUserId($value)
 * @mixin \Eloquent
 */
	class IdeHelperArea {}
}

namespace App\Models{
/**
 * App\Models\Auth
 *
 * @property int $id
 * @property string $access_token
 * @property string $refresh_token
 * @property int $user_id
 * @property int $service_id
 * @property-read \App\Models\Service $service
 * @property-read \App\Models\User $user
 * @method static \Illuminate\Database\Eloquent\Builder|Auth newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Auth newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Auth query()
 * @method static \Illuminate\Database\Eloquent\Builder|Auth whereAccessToken($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Auth whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Auth whereRefreshToken($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Auth whereServiceId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Auth whereUserId($value)
 * @mixin \Eloquent
 */
	class IdeHelperAuth {}
}

namespace App\Models{
/**
 * App\Models\Reaction
 *
 * @property int $id
 * @property string $name
 * @property string $api_endpoint
 * @property mixed $params
 * @property mixed $default_config
 * @property int $service_id
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\ReactionConfig> $reactionConfigs
 * @property-read int|null $reaction_configs_count
 * @property-read \App\Models\Service $service
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction query()
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction whereApiEndpoint($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction whereDefaultConfig($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction whereParams($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Reaction whereServiceId($value)
 * @mixin \Eloquent
 */
	class IdeHelperReaction {}
}

namespace App\Models{
/**
 * App\Models\ReactionConfig
 *
 * @property int $id
 * @property mixed $config
 * @property int $reaction_id
 * @property int $area_id
 * @property-read \App\Models\Area $area
 * @property-read \App\Models\Reaction $reaction
 * @method static \Illuminate\Database\Eloquent\Builder|ReactionConfig newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|ReactionConfig newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|ReactionConfig query()
 * @method static \Illuminate\Database\Eloquent\Builder|ReactionConfig whereAreaId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|ReactionConfig whereConfig($value)
 * @method static \Illuminate\Database\Eloquent\Builder|ReactionConfig whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|ReactionConfig whereReactionId($value)
 * @mixin \Eloquent
 */
	class IdeHelperReactionConfig {}
}

namespace App\Models{
/**
 * App\Models\Service
 *
 * @property int $id
 * @property string $name
 * @property string $api_endpoint
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Action> $actions
 * @property-read int|null $actions_count
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Auth> $auths
 * @property-read int|null $auths_count
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Reaction> $reactions
 * @property-read int|null $reactions_count
 * @method static \Illuminate\Database\Eloquent\Builder|Service newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Service newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|Service query()
 * @method static \Illuminate\Database\Eloquent\Builder|Service whereApiEndpoint($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Service whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|Service whereName($value)
 * @mixin \Eloquent
 */
	class IdeHelperService {}
}

namespace App\Models{
/**
 * App\Models\User
 *
 * @property int $id
 * @property string $name
 * @property string $email
 * @property \Illuminate\Support\Carbon|null $email_verified_at
 * @property mixed $password
 * @property string|null $remember_token
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Area> $areas
 * @property-read int|null $areas_count
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Auth> $auths
 * @property-read int|null $auths_count
 * @property-read \Illuminate\Notifications\DatabaseNotificationCollection<int, \Illuminate\Notifications\DatabaseNotification> $notifications
 * @property-read int|null $notifications_count
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \Laravel\Sanctum\PersonalAccessToken> $tokens
 * @property-read int|null $tokens_count
 * @method static \Database\Factories\UserFactory factory($count = null, $state = [])
 * @method static \Illuminate\Database\Eloquent\Builder|User newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|User newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|User query()
 * @method static \Illuminate\Database\Eloquent\Builder|User whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|User whereEmail($value)
 * @method static \Illuminate\Database\Eloquent\Builder|User whereEmailVerifiedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|User whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|User whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|User wherePassword($value)
 * @method static \Illuminate\Database\Eloquent\Builder|User whereRememberToken($value)
 * @method static \Illuminate\Database\Eloquent\Builder|User whereUpdatedAt($value)
 * @mixin \Eloquent
 */
	class IdeHelperUser {}
}
