<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @mixin IdeHelperActionConfig
 */
class ActionConfig extends Model
{
    use HasFactory;

    public $timestamps = false;

    public function action(): BelongsTo
    {
        return $this->belongsTo(Action::class);
    }

    public function area(): BelongsTo
    {
        return $this->belongsTo(Area::class);
    }

    protected $fillable = [
        'config',
        'action_id',
        'isTriggered'
    ];
}
