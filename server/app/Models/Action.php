<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @mixin IdeHelperAction
 */
class Action extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $fillable = ['name', 'description', 'api_endpoint', 'return_params', 'default_config'];

    public function service(): BelongsTo {
        return $this->belongsTo(Service::class);
    }

    public function actionConfigs(): HasMany {
        return $this->hasMany(ActionConfig::class);
    }
}
