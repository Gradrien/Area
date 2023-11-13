<?php

use App\Models\User;

define('microsoftId', \App\Models\Service::where('name', '=', 'Microsoft')->first()->id);

function sendEmailOutlook(int $userId, $config)
{
    $user = User::find($userId);

    if (str_contains($config["email"], '<')) {
        $config["email"] = substr($config["email"], strpos($config["email"], '<') + 1);
        $config["email"] = substr_replace($config["email"], "", -1);
    }

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", microsoftId)->first()->access_token;

    $outlookService = new \App\Library\MicrosoftService($access_token);

    $outlookService->sendMail($config["email"], $config["email_object"], $config["email_content"]);
}

function isEventCreated(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    $user = User::find($userId);

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", microsoftId)->first()->access_token;

    $outlookService = new \App\Library\MicrosoftService($access_token);

    $result = $outlookService->getUserEvents();

    if (!$result->ok()) {
        error_log($result->body());
        return null;
    };

    $resultParsed = $result->json();


    if (!array_key_exists("value", $resultParsed)) {
        return null;
    }

    $resultParsed = $resultParsed["value"];

    error_log(count($resultParsed));
    $lastCheckTime = strtotime("-" . $timeRefresh . " minutes");

    foreach ($resultParsed as $event) {
        $createdTime = strtotime($event['createdDateTime']);

        if ($createdTime > $lastCheckTime) {
            return [
                'event_title' => $event['subject'],
                'event_description' => $event['bodyPreview'],
                'event_start' => $event['start']['dateTime'],
                'event_end' => $event['end']['dateTime'],
                'event_location' => $event['location']['displayName'],
                'organizer_name' => $event['organizer']['emailAddress']['name'],
                'organizer_email' => $event['organizer']['emailAddress']['address'],
            ];
        }
    }
    return null;
}

function createNote(int $userId, $config)
{
    error_log("Here note");
    $user = User::find($userId);

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", microsoftId)->first()->access_token;

    $outlookService = new \App\Library\MicrosoftService($access_token);

    error_log(json_encode($config));
    $outlookService->createNote(
        $config["title"],
        $config["body"]
    );

    return null;
}
