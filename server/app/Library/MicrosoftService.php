<?php

namespace App\Library;

use Illuminate\Http\Client\PendingRequest;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Response;

class MicrosoftService {

    private $accessToken;


    public function __construct($accessToken)
    {
        $this->accessToken = $accessToken;
    }

    function sendMail($receiver, $subject, $content) {
        $formatted = '{
  "message": {
    "subject": "'. $subject . '",
    "body": {
      "contentType": "text",
      "content": ""
    },
    "toRecipients": [
      {
        "emailAddress": {
          "address": "'. $receiver . '"
        }
      }
    ]
  },
  "saveToSentItems": "true"
}';

        $formatted = json_decode($formatted);
        $formatted->message->body->content = $content;

        $response = Http::withHeaders([
            "Authorization" => "Bearer ". $this->accessToken,
            "Content-Type" => "application/json; charset=utf-8",
            "Accept" => "application/json",
        ])->post('https://graph.microsoft.com/v1.0/me/sendMail', $formatted);
        return $response;
    }

    function getUserEvents() {
        $response = Http::withHeaders([
            "Authorization" => "Bearer ". $this->accessToken,
            "Prefer" => "outlook.body-content-type=\"text\""
        ])->get('https://graph.microsoft.com/v1.0/me/events');
        return $response;
    }

    function createNote(string $title, string $content) {
        $formattedData = "<!DOCTYPE html><html><head><title>$title</title></head><body><p>$content</p></body></html>";
        $formattedData = str_replace("\r\n","<br>", $formattedData);
        $formattedData = str_replace("\n","<br>", $formattedData);
        error_log($formattedData);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'https://graph.microsoft.com/v1.0/me/onenote/pages');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $formattedData);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            "Authorization: Bearer ". $this->accessToken,
            "content-type:application/xhtml+xml; charset=utf-8"
        ));
        $response = curl_exec($ch);
        if (curl_errno($ch)) {
            error_log(curl_error($ch));
        }
        return $response;
    }

}
