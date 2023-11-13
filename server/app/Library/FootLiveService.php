<?php

namespace App\Library;
class FootLiveService
{
    public function getTeams()
    {

        $key = env('FOOTLIVE_ID');

        $response = \Http::get("https://apiv3.apifootball.com/?action=get_teams&league_id=152&APIkey=$key");

        return $response;
    }

    public function getMatchOfTheDay(int $teamId)
    {
        $key = env('FOOTLIVE_ID');
        $currentDate = date('Y-m-d');

        $response = \Http::get("https://apiv3.apifootball.com/?action=get_events&team_id=$teamId&from=$currentDate&to=$currentDate&APIkey=$key");

        return $response;
    }
}
