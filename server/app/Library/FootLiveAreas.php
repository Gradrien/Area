<?php

use App\Library\FootLiveService;

function myTeamIsPlaying(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    try {
        $footLive = new FootLiveService();

        $res = $footLive->getMatchOfTheDay($config["team_id"]);

        if (!$res->ok()) {
            return null;
        }

        $allMatches = $res->json();

        if (count($allMatches) == 0 || $allMatches["error"] != null) {
            return null;
        }
        if (count($allMatches[0]["goalscorer"]) == 0) {
            $score = "0 - 0";
        } else {
            $score = end($allMatches[0]["goalscorer"])["score"];
        }
        return [
            "home_team_name" => $allMatches[0]["match_hometeam_name"],
            "away_team_name" => $allMatches[0]["match_awayteam_name"],
            "stadium" => $allMatches[0]["match_stadium"],
            "referee" => $allMatches[0]["match_referee"],
            "score" => $score,
        ];
    } catch (Exception $e) {
        error_log($e);
        return null;
    }
}
