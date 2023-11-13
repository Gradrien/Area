<?php

use App\Http\Controllers\ActionController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\GitLabController;
use App\Http\Controllers\GoogleController;
use App\Http\Controllers\MicrosoftController;
use App\Http\Controllers\ReactionController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\AboutController;
use App\Http\Controllers\SpotifyController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

//require_once('../app/Library/GoogleService.php');


Route::prefix('auth')->controller(AuthController::class)->group(function () {
    Route::post('/login', 'login')->name('login');
    Route::post('/register', 'register')->name('register');
    Route::post('/logout', 'logout')->name('logout');
    Route::post('/refresh', 'refresh')->name('refresh');
    Route::post('/google-signup', 'googleSignUp')->name('googleSignUp');
    Route::post('/google-signin', 'googleSignIn')->name('googleSignIn');
});

Route::prefix('user')->name('user.')->controller(UserController::class)->group(function () {
    Route::get('/', 'index')->name('index');
    Route::get('/services', 'userServices')->name('services');
    Route::get('/areas', 'userAreas')->name('areas');
    Route::put('/', 'updateUser')->name('update');
});

Route::prefix('services')->controller(ServiceController::class)->group(function () {
    Route::get('/', 'index');
    Route::get('/{serviceId}/actions', 'actions');
    Route::get('/{serviceId}/reactions', 'reactions');
    Route::delete('/{serviceId}', 'deleteService');
});

Route::prefix('actions')->controller(ActionController::class)->group(function () {
    Route::get('/{actionId}/default-config', 'defaultConfig');
});

Route::prefix('reactions')->controller(ReactionController::class)->group(function () {
    Route::get('/{reactionId}/default-config', 'defaultConfig');
});

Route::prefix('area')->controller(\App\Http\Controllers\AreaController::class)->group(function () {
    Route::post('/', 'createArea')->name('createArea');
    Route::get('/public', 'getPublicAreas')->name('getPublicAreas');
    Route::get('/{areaId}', 'getArea')->name('getArea');
    Route::delete('/{areaId}', 'deleteArea')->name('deleteArea');
    Route::put('/{areaId}', 'updateArea')->name('updateArea');
    Route::get('/{areaId}/data', 'getAreaDetails')->name('getAreaDetails');
    Route::post('/{areaId}/start', 'startArea')->name('startArea');
    Route::post('/{areaId}/public', 'publishArea')->name('publishArea');
    Route::delete('/{areaId}/public', 'removePublicArea')->name('removePublicArea');
    Route::get('/{areaId}/public', 'getPublicAreaDetails')->name('getPublicAreaDetails');
    Route::post('/{areaId}/copy', 'copyArea')->name('copyArea');
});

Route::prefix('oauth')->name('oauth.')->group(function () {
    Route::post('/microsoft', [MicrosoftController::class, 'login'])->name('microsoft');
    Route::post('/spotify', [SpotifyController::class, 'login'])->name('spotify');
    Route::post('/gitlab', [GitLabController::class, 'login'])->name('gitlab');
    Route::post('/google-service', [GoogleController::class, 'login'])->name('google');
});
