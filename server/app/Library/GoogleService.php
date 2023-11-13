<?php

namespace App\Library;

use App\Models\User;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Response;

class GoogleService {


    private $accessToken;


    public function __construct($accessToken)
    {
        $this->accessToken = $accessToken;
    }

    function sendMail($sender, $receiver, $subject, $content) {
        $test = Http::withHeaders([
            "Authorization" => "Bearer ". $this->accessToken,
            "Content-Type" => "message/rfc822; charset=utf-8",
            "Accept" => "message/rfc822",
        ])->post("https://gmail.googleapis.com/gmail/v1/users/me/messages/send", [
            "raw" => base64_encode('Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: '. $receiver .'
from: '. $sender .'
subject: '. $subject .'

'. $content),
        ]);

        return $test;
    }

    function getMailsByQuery(string $from, int $since) : \Illuminate\Http\Client\Response
    {
        $delay = strtotime("-".$since." minutes");
        $query = "from:". $from ." after:". $delay;
        return Http::Get("https://gmail.googleapis.com/gmail/v1/users/me/messages?q=".$query."&maxResults=10", [
            "access_token" => $this->accessToken,
            "q" => $query,
        ]);
    }

    function getMailInfos($mailId) : \Illuminate\Http\Client\Response {
        $test = Http::Get("https://gmail.googleapis.com/gmail/v1/users/me/messages/". $mailId, [
            "access_token" => $this->accessToken,
        ]);
        return $test;
    }

    function getFilesSince(int $since) {
        $delay = new \DateTime;
        $delay->modify("-".$since." minutes");
        $delay = $delay->format(\DateTimeInterface::RFC3339);
        $query = "createdTime > ". "'".$delay."'";
        return Http::Get("https://www.googleapis.com/drive/v3/files?q=".$query."&maxResults=10", [
            "access_token" => $this->accessToken,
            "q" => $query,
        ]);
    }

    function getFileDetails(string $fileId) {
        error_log("https://www.googleapis.com/drive/v3/files/".$fileId."?alt=media");
        return Http::Get("https://www.googleapis.com/drive/v3/files/".$fileId."?alt=media", [
            "accept" => "image/jpeg",
            "access_token" => $this->accessToken,
        ]);
    }
}

