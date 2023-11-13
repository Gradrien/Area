<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * @mixin IdeHelperArea
 */
class Area extends Model
{
    use HasFactory;

    public $timestamps = false;

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function actionConfig(): HasOne
    {
        return $this->hasOne(ActionConfig::class);
    }

    public function reactionConfig(): HasOne
    {
        return $this->hasOne(ReactionConfig::class);
    }

    protected $fillable = [
        'name',
        'refresh',
        'active',
        'public'
    ];
}
