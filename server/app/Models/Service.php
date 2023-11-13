<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @mixin IdeHelperService
 */
class Service extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $fillable = ['name', 'api_endpoint', 'no_auth'];
    public function auths(): HasMany {
        return $this->hasMany(Auth::class);
    }

    public function actions(): HasMany {
        return $this->hasMany(Action::class);
    }

    public function reactions(): HasMany {
        return $this->hasMany(Reaction::class);
    }
}
