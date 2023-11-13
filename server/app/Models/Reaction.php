<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @mixin IdeHelperReaction
 */
class Reaction extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'description', 'api_endpoint', 'params', 'default_config'];
    public $timestamps = false;
    public function service(): BelongsTo {
        return $this->belongsTo(Service::class);
    }

    public function reactionConfigs(): HasMany {
        return $this->hasMany(ReactionConfig::class);
    }
}
