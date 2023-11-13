<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @mixin IdeHelperReactionConfig
 */
class ReactionConfig extends Model
{
    use HasFactory;

    public $timestamps = false;
    public function reaction(): BelongsTo {
        return $this->belongsTo(Reaction::class);
    }

    public function area(): BelongsTo {
        return $this->belongsTo(Area::class);
    }
    protected $fillable = [
        'config',
        'reaction_id'
    ];
}
