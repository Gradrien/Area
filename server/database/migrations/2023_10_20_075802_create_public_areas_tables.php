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
        Schema::create('public_areas', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->integer('refresh');
            $table->foreignIdFor(\App\Models\Area::class)->constrained()->cascadeOnDelete();
        });

        Schema::table('areas', function (Blueprint $table) {
            $table->boolean('public')->default(false);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('public_areas');
    }
};
