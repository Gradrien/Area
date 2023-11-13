<?php

namespace App\Jobs;

use App\Library\AreaHandler;
use App\Models\Area;
use App\Models\Auth;
use App\Models\Service;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Http;

class AreaJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    private int $areaId;
    private int $refreshTime;

    /**
     * Create a new job instance.
     */
    public function __construct(int $areaId)
    {
        $this->areaId = $areaId;
        $this->refreshTime = Area::find($areaId)->refresh;
    }


    private function getAppIds($serviceName)
    {
        switch ($serviceName) {
            case "Google":
                return [
                    'client_id' => env('GOOGLE_CLIENT_ID'),
                    'client_secret' => env('GOOGLE_CLIENT_SECRET'),
                ];
            case "Microsoft":
                return [
                    'client_id' => env('MICROSOFT_CLIENT_ID'),
                    'client_secret' => env('MICROSOFT_CLIENT_SECRET'),
                ];
            case "Spotify":
                return [
                    'client_id' => env('SPOTIFY_CLIENT_ID'),
                    'client_secret' => env('SPOTIFY_CLIENT_SECRET'),
                ];
            case "GitLab":
                return [
                    'client_id' => env('GITLAB_CLIENT_ID'),
                    'client_secret' => env('GITLAB_CLIENT_SECRET'),
                ];
            default:
                return [];
        }
    }

    private function refreshToken(Auth $auth, array $serviceSecret, Service $service)
    {
        if ($auth->expires_at < date('Y-m-d H:i:s', strtotime("+5 minutes"))) {
            error_log("here");
            $response = Http::asForm()->post($service->api_endpoint, [
                'grant_type' => 'refresh_token',
                'refresh_token' => $auth->refresh_token,
                'client_id' => $serviceSecret['client_id'],
                'client_secret' => $serviceSecret['client_secret'],
            ]);
            if (!$response->ok())
                return;
            $data = $response->json();
            $formattedExpiration = $data['expires_in'];
            $formattedExpiration = date('Y-m-d H:i:s', strtotime("+$formattedExpiration seconds"));
            $auth->update([
                'expires_at' => $formattedExpiration,
                'access_token' => $data['access_token'],
            ]);
            error_log("here");
        }
    }

    private function checkAccessTokens()
    {
        $actionService = Area::find($this->areaId)->actionConfig()->first()->action->service()->first();
        $reactionService = Area::find($this->areaId)->reactionConfig()->first()->reaction->service()->first();

        $user = Area::find($this->areaId)->user()->first();
        $actionAuth = $user->auths()->where('service_id', $actionService->id)->first();
        $reactionAuth = $user->auths()->where('service_id', $reactionService->id)->first();


        $actionIds = $this->getAppIds($actionService->name);
        $reactionIds = $this->getAppIds($reactionService->name);

        if (count($actionIds) === 0 || count($reactionIds) === 0)
            return;


        $this->refreshToken($actionAuth, $actionIds, $actionService);
        $this->refreshToken($reactionAuth, $reactionIds, $reactionService);
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $area = Area::find($this->areaId);
        if ($area === null) {
            return;
        }
        if (!$area->active) {
            dispatch((new AreaJob($this->areaId))->delay(now()->addMinutes($this->refreshTime)));
            return;
        }
        $this->checkAccessTokens();
        $areaHandler = new AreaHandler($this->areaId);
        error_log('Start the check of action ' . time());
        $actionsInfos = $areaHandler->action();
        if ($actionsInfos === null) {
            error_log('Action not triggered ' . time());
            dispatch((new AreaJob($this->areaId))->delay(now()->addMinutes($this->refreshTime)));
            return;
        }
        error_log('Start the reaction ' . time());
        $areaHandler->reaction($actionsInfos);
        error_log('Job executed ' . time());
        dispatch((new AreaJob($this->areaId))->delay(now()->addMinutes($this->refreshTime)));
    }
}
