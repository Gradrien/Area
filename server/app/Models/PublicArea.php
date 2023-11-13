<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * @mixin IdeHelperArea
 */
class PublicArea extends Model
{
    use HasFactory;

    public $timestamps = false;

    public function area(): HasOne
    {
        return $this->hasOne(Area::class);
    }

    protected $fillable = [
        'name',
        'refresh',
        'area_id'
    ];
}
