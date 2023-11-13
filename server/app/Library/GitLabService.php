<?php

namespace App\Library;

use Illuminate\Support\Facades\Http;
use Mockery\Exception;

class GitLabService
{
    private $accessToken;

    public function __construct($accessToken)
    {
        $this->accessToken = $accessToken;
    }

    public function getIssues(int $since, string $label) {
        $delay = strtotime("-".$since." minutes");
        $delay = date('c', $delay);
        $query = "https://gitlab.com/api/v4/issues?created_after=". $delay ."&labels=". $label;

        $response = Http::withHeaders([
            "Authorization" => "Bearer " . $this->accessToken,
            "Content-Type" => "application/json; charset=utf-8",
            "Accept" => "application/json",
        ])->get($query);

        return $response;
    }

    public function getRepoIssues(int $since, string $label, string $repoUrl) {
        $delay = strtotime("-".$since." minutes");
        $delay = date('c', $delay);
        $repoUrl = urlencode($repoUrl);
        $query = "https://gitlab.com/api/v4/projects/$repoUrl/issues?created_after=". $delay ."&labels=". $label;

        $response = Http::withHeaders([
            "Authorization" => "Bearer " . $this->accessToken,
            "Content-Type" => "application/json; charset=utf-8",
            "Accept" => "application/json",
        ])->get($query);

        return $response;
    }

    public function getRepoCommits(int $since, string $repoUrl, string $branch) {
        $delay = strtotime("-".$since." minutes");
        $delay = date('c', $delay);
        $repoUrl = urlencode($repoUrl);
        $query = "https://gitlab.com/api/v4/projects/$repoUrl/repository/commits?since=". $delay ."&ref_name=". $branch;

        $response = Http::withHeaders([
            "Authorization" => "Bearer " . $this->accessToken,
            "Content-Type" => "application/json; charset=utf-8",
            "Accept" => "application/json",
        ])->get($query);

        return $response;
    }

    public function createRepoIssue(string $repoUrl, string $title, string $description, string $dueDate, string $labels) {
        $repoUrl = urlencode($repoUrl);
        $query = "https://gitlab.com/api/v4/projects/$repoUrl/issues";

        $response = Http::withHeaders([
            "Authorization" => "Bearer " . $this->accessToken,
            "Content-Type" => "application/json; charset=utf-8",
            "Accept" => "application/json",
        ])->post($query, [
            "title" => $title,
            "description" => $description,
            "due_date" => $dueDate,
            "labels" => $labels,
        ]);

        return $response;
    }

    public function createRepoBranch(string $repoUrl, string $branchName, string $ref) {
        $repoUrl = urlencode($repoUrl);
        $query = "https://gitlab.com/api/v4/projects/$repoUrl/repository/branches";

        $response = Http::withHeaders([
            "Authorization" => "Bearer " . $this->accessToken,
            "Content-Type" => "application/json; charset=utf-8",
            "Accept" => "application/json",
        ])->post($query, [
            "branch" => $branchName,
            "ref" => $ref,
        ]);

        return $response;
    }

}
