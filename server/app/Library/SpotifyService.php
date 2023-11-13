<?php

namespace App\Library;

use Illuminate\Support\Facades\Http;
use Mockery\Exception;

class SpotifyService
{
    private $accessToken;

    public function __construct($accessToken)
    {
        $this->accessToken = $accessToken;
    }

    public function get_player_infos()
    {
        try {
            error_log("get player infos");
            $response = Http::withHeaders([
                "Authorization" => "Bearer " . $this->accessToken,
                "Content-Type" => "application/json",
                "Accept" => "application/json",
            ])->get('https://api.spotify.com/v1/me/player');
            if (!$response->ok()) {
                error_log("error get infos");
                error_log(json_encode($response->json()));
                return null;
            }
            if ($response->status() === 204)
                return null;
            return $response->json();
        } catch (Exception $err) {
            error_log($err);
            return null;
        }
    }

    public function next_music()
    {
        try {
            return Http::withHeaders([
                "Authorization" => "Bearer " . $this->accessToken,
                "Content-Type" => "application/json",
                "Accept" => "application/json",
            ])->post('https://api.spotify.com/v1/me/player/next');
        } catch (\Exception $err) {
            error_log($err);
            return null;
        }
    }

    public function previous_music()
    {
        try {
            return Http::withHeaders([
                "Authorization" => "Bearer " . $this->accessToken,
                "Content-Type" => "application/json",
                "Accept" => "application/json",
            ])->post('https://api.spotify.com/v1/me/player/previous');
        } catch (\Exception $err) {
            error_log($err);
            return null;
        }
    }

    public function play_music()
    {
        try {
            error_log("send plau music");
            $response = Http::withHeaders([
                "Authorization" => "Bearer " . $this->accessToken,
                "Content-Type" => "application/json",
                "Accept" => "application/json",
            ])->put('https://api.spotify.com/v1/me/player/play', [
                "device_id" => "03cef017d345f0c24e83f68d3b4a93034be32833"
            ]);
            if (!$response->ok()) {
                error_log(json_encode($response->json()));
                return null;
            }
            return null;
        } catch (\Exception $err) {
            error_log($err);
            return null;
        }
    }

    public function pause_music()
    {
        try {
            $response = Http::withHeaders([
                "Authorization" => "Bearer " . $this->accessToken,
                "Content-Type" => "application/json",
                "Accept" => "application/json",
            ])->put('https://api.spotify.com/v1/me/player/pause');
            if (!$response->ok()) {
                error_log($response->json());
                return null;
            }
            return $response;
        } catch (\Exception $err) {
            error_log($err);
            return null;
        }
    }
}
