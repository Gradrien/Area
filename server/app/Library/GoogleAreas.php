<?php

use App\Models\User;

define('googleId', \App\Models\Service::where('name', '=', 'Google')->first()->id);


function isMailReceived(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    $user = User::find($userId);

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", googleId)->first()->access_token;

    $googleService = new \App\Library\GoogleService($access_token);

    $result = $googleService->getMailsByQuery($config["email"], $timeRefresh);

    $resultParsed = $result->json();

    if (!array_key_exists("messages", $resultParsed))
        return null;

    $message = $resultParsed["messages"][0];

    $messageData = $googleService->getMailInfos($message["id"])->json();

    $email = "";
    $subject = "";
    foreach ($messageData["payload"]["headers"] as $header) {
        if ($header["name"] === "From") {
            $email = $header["value"];
            break;
        }
    }

    foreach ($messageData["payload"]["headers"] as $header) {
        if ($header["name"] === "Subject") {
            $subject = $header["value"];
            break;
        }
    }

    return [
        'email' => $email,
        'email_object' => $subject,
        'email_content' => base64_decode($messageData["payload"]["parts"][0]["body"]["data"]),
    ];
}

function isFileUploaded(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    $user = User::find($userId);

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", googleId)->first()->access_token;

    $googleService = new \App\Library\GoogleService($access_token);

    $result = $googleService->getFilesSince($timeRefresh);

    $resultParsed = $result->json();
    if (!array_key_exists("files", $resultParsed))
        return null;

    if (count($resultParsed['files']) === 0)
        return null;

    $file = $resultParsed["files"][0];
    return [
        'file_name' => $file["name"],
        'file_type' => $file["mimeType"],
    ];
}

function sendMail(int $userId, $config): void
{
    $user = User::find($userId);

    if (!$user)
        return;

    $access_token = $user->auths()->where("service_id", googleId)->first()->access_token;

    $googleService = new \App\Library\GoogleService($access_token);

    $googleService->sendMail($user->email, $config["email"], $config["email_object"], $config["email_content"]);
    return;
}
