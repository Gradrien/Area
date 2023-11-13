<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('auths', function (Blueprint $table) {
            $table->foreignIdFor(\App\Models\Service::class)->constrained()->cascadeOnDelete();
        });

        Schema::table('actions', function (Blueprint $table) {
            $table->foreignIdFor(\App\Models\Service::class)->constrained()->cascadeOnDelete();
        });

        Schema::table('reactions', function (Blueprint $table) {
            $table->foreignIdFor(\App\Models\Service::class)->constrained()->cascadeOnDelete();
        });

        Schema::table('actionConfigs', function (Blueprint $table) {
            $table->foreignIdFor(\App\Models\Action::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(\App\Models\Area::class)->constrained()->cascadeOnDelete();
        });

        Schema::table('reactionConfigs', function (Blueprint $table) {
            $table->foreignIdFor(\App\Models\Reaction::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(\App\Models\Area::class)->constrained()->cascadeOnDelete();
        });

        Schema::table('areas', function (Blueprint $table) {
            $table->foreignIdFor(\App\Models\User::class)->constrained()->cascadeOnDelete();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
