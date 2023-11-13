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
        Schema::create('auths', function (Blueprint $table) {
            $table->id();
            $table->string('access_token');
            $table->string('refresh_token');
        });
        Schema::create('services', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('api_endpoint');
        });
        Schema::create('actions', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('api_endpoint');
            $table->jsonb('return_params');
            $table->jsonb('default_config');
        });
        Schema::create('reactions', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('api_endpoint');
            $table->jsonb('params');
            $table->jsonb('default_config');
        });
        Schema::create('actionConfigs', function (Blueprint $table) {
            $table->id();
            $table->jsonb('config');
        });
        Schema::create('reactionConfigs', function (Blueprint $table) {
            $table->id();
            $table->jsonb('config');
        });
        Schema::create('areas', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->integer('refresh');
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
