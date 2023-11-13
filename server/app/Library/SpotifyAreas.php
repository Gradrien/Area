<?php

use App\Library\SpotifyService;
use App\Models\User;

define('spotifyId', \App\Models\Service::where('name', '=', 'Spotify')->first()->id);

function spotify_next_music(int $userId, $config,)
{
    $user = User::find($userId);
    $access_token = $user->auths()->where("service_id", spotifyId)->first()->access_token;
    $spotifyService = new SpotifyService($access_token);

    $spotifyService->next_music();
}

function spotify_previous_music(int $userId, $config,)
{
    $user = User::find($userId);
    $access_token = $user->auths()->where("service_id", spotifyId)->first()->access_token;
    $spotifyService = new SpotifyService($access_token);

    $spotifyService->previous_music();
}

function spotify_play_music(int $userId, $config,)
{
    $user = User::find($userId);
    $access_token = $user->auths()->where("service_id", spotifyId)->first()->access_token;
    $spotifyService = new SpotifyService($access_token);

    $spotifyService->play_music();
}

function spotify_pause_music(int $userId, $config,)
{
    $user = User::find($userId);
    $access_token = $user->auths()->where("service_id", spotifyId)->first()->access_token;
    $spotifyService = new SpotifyService($access_token);

    $spotifyService->pause_music();
}

function spotify_start_listen(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    try {
        $user = User::find($userId);
        $access_token = $user->auths()->where("service_id", spotifyId)->first()->access_token;
        $spotifyService = new SpotifyService($access_token);
//        $actionConf = \App\Models\ActionConfig::find($actionConfig)->first();

        $data = $spotifyService->get_player_infos();
        if ($data === null || !$data["is_playing"]) {
            $actionConfig->update([
                "isTriggered" => false
            ]);
            return null;
        }
        if ($actionConfig["isTriggered"] === true) {
            return null;
        }

        $actionConfig->update([
            "isTriggered" => true
        ]);
        return [
            "device_name" => $data["device"]["name"],
            "device_type" => $data["device"]["type"],
            "device_volume" => $data["device"]["volume_percent"],
            "track_image" => $data["item"]["album"]["images"][0]["url"],
            "track_name" => $data["item"]["name"],
            "track_release" => $data["item"]["album"]["release_date"],
            "artist_name" => $data["item"]["artists"][0]["name"]
        ];

    } catch (Exception $err) {
        error_log($err);
        return null;
    }
}
