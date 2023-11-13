<?php

use App\Models\User;

define('gitLabId', \App\Models\Service::where('name', '=', 'GitLab')->first()->id);

function isIssueCreated(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    $user = User::find($userId);

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", gitLabId)->first()->access_token;

    $gitLabService = new \App\Library\GitLabService($access_token);

    $result = $gitLabService->getIssues($timeRefresh, $config["labels"]);

    if (!$result->ok())
        return null;

    $resultParsed = $result->json();

    if (count($resultParsed) === 0)
        return null;

    $issue = $resultParsed[0];

    return [
        'issue_title' => $issue["title"],
        'issue_description' => $issue["description"],
        'issue_author' => $issue["author"]["name"],
        'issue_url' => $issue["web_url"],
        'issue_due_date' => $issue["due_date"],
    ];
}

function isRepoIssueCreated(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    $user = User::find($userId);

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", gitLabId)->first()->access_token;

    $gitLabService = new \App\Library\GitLabService($access_token);

    $result = $gitLabService->getRepoIssues($timeRefresh, $config["labels"], $config["repo_url"]);

    if (!$result->ok())
        return null;

    $resultParsed = $result->json();

    if (count($resultParsed) === 0)
        return null;

    $issue = $resultParsed[0];

    return [
        'issue_title' => $issue["title"],
        'issue_description' => $issue["description"],
        'issue_author' => $issue["author"]["name"],
        'issue_url' => $issue["web_url"],
        'issue_due_date' => $issue["due_date"],
    ];
}

function isRepoCommitCreated(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    $user = User::find($userId);

    if (!$user)
        return null;

    $access_token = $user->auths()->where("service_id", gitLabId)->first()->access_token;

    $gitLabService = new \App\Library\GitLabService($access_token);

    $result = $gitLabService->getRepoCommits($timeRefresh, $config["repo_url"], $config["branch"]);

    if (!$result->ok())
        return null;

    $resultParsed = $result->json();

    if (count($resultParsed) === 0)
        return null;

    $commit = $resultParsed[0];

    return [
        'commit_title' => $commit["title"],
        'commit_author' => $commit["author_name"],
        'commit_author_email' => $commit["author_email"],
        'commit_url' => $commit["web_url"],
        'commit_message' => $commit["message"],
    ];
}

function createIssue(int $userId, $config): void
{
    $user = User::find($userId);

    if (!$user)
        return;

    $access_token = $user->auths()->where("service_id", gitLabId)->first()->access_token;

    $gitLabService = new \App\Library\GitLabService($access_token);

    $gitLabService->createRepoIssue($config["repo_url"], $config["title"], $config["description"], $config["due_date"], $config["labels"]);
}

function createBranch(int $userId, $config): void
{
    $user = User::find($userId);

    if (!$user)
        return;

    $access_token = $user->auths()->where("service_id", gitLabId)->first()->access_token;

    $gitLabService = new \App\Library\GitLabService($access_token);

    $gitLabService->createRepoBranch($config["repo_url"], $config["branch_name"], $config["branch_ref"]);
}
