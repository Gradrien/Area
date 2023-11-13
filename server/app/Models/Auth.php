<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @mixin IdeHelperAuth
 */
class Auth extends Model
{
    use HasFactory;

    public $timestamps = false;

    public function user(): BelongsTo {
        return $this->belongsTo(User::class);
    }

    public function service(): BelongsTo {
        return $this->belongsTo(Service::class);
    }

    protected $fillable = [
        'access_token',
        'refresh_token',
        'service_id',
        'expires_at'
    ];
}
