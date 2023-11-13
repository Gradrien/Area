<?php

namespace App\Library;
require_once('GoogleAreas.php');
require_once('MicrosoftAreas.php');
require_once('SpotifyAreas.php');
require_once('GitLabAreas.php');
require_once('BdxAreas.php');
require_once('FootLiveAreas.php');

use App\Models\Area;

class AreaHandler
{
    private int $areaId;
    private int $userId;
    private $actionConfig;
    private $reactionConfig;

    private string $actionName;
    private string $reactionName;
    private int $timeRefresh;

    private const actionsMap = [
        'Recevoir un mail' => 'isMailReceived',
        'Un fichier est uploadé sur Google Drive' => 'isFileUploaded',
        'Un évènement est créé sur Outlook' => 'isEventCreated',
        'Une nouvelle issue est créée' => 'isIssueCreated',
        'Une nouvelle issue est créée sur un repository' => 'isRepoIssueCreated',
        'Un commit est push sur un repository' => 'isRepoCommitCreated',
        "Une session d'écoute commence" => 'spotify_start_listen',
        'Le nombre de vélos disponible à une station dépasse X' => 'isMoreThanXBikes',
        'Le nombre de vélos disponible à une station passe sous X' => 'isLessThanXBikes',
        "Mon équipe joue" => 'myTeamIsPlaying'
    ];

    private const reactionsMap = [
        'Envoyer un mail avec Gmail' => 'sendMail',
        'Envoyer un mail avec Outlook' => 'sendEmailOutlook',
        'Musique suivante' => 'spotify_next_music',
        'Musique précédente' => 'spotify_previous_music',
        'Mettre la musique sur pause' => 'spotify_pause_music',
//        'Démarrer la musique' => 'spotify_play_music'
        'Créer une note sur OneNote' => 'createNote',
        'Créer une issue' => 'createIssue',
        'Créer une nouvelle branche' => 'createBranch',
    ];

    function __construct(int $areaId)
    {
        $this->areaId = $areaId;
        $area = Area::find($areaId);
        error_log($area);
        $this->userId = $area->user()->first()->id;
        $this->actionConfig = $area->actionConfig()->first();
        $this->reactionConfig = $area->reactionConfig()->first();
        error_log("Here");
        $this->actionName = $this->actionConfig->action()->first()->name;
        $this->reactionName = $this->reactionConfig->reaction()->first()->name;
        error_log("Here");
        $this->timeRefresh = $area->refresh;
    }

    private function mergeConfigs($reactionConfig, array $actionResult): array
    {
        $merged = $actionResult;
        foreach ($reactionConfig as $field) {
            if ($field['value'] !== '') {
                $merged[$field['name']] = $field['value'];
            }
        }
        return $merged;
    }

    private function formatConfig($config): array
    {
        $formatted = [];
        foreach ($config as $field) {
            $formatted[$field['name']] = $field['value'];
        }
        return $formatted;
    }

    private function formatReactionData($reactionConfig, $values): array
    {
        error_log("start format config");
        $formatted = $this->formatConfig(json_decode($reactionConfig->config, true));
        error_log("config formatted");
        $patterns = [];
        foreach ($values as $key => $value) {
            $patterns[$key] = "/{{" . $key . "}}/";
        }
        return preg_replace($patterns, $values, $formatted);
    }

    public function action(): ?array
    {
        try {
            error_log($this->actionName . ' ' . $this->userId);
            error_log(self::actionsMap[(string)$this->actionName]);
            return call_user_func(self::actionsMap[(string)$this->actionName], $this->userId, $this->formatConfig(json_decode($this->actionConfig->config, true)), $this->timeRefresh, $this->actionConfig);
        } catch (\Exception $err) {
            error_log($err);
            return null;
        }
    }

    public function reaction(array $values): void
    {
        try {
            $data = $this->formatReactionData($this->reactionConfig, $values);
            error_log("============");
            foreach ($data as $key => $value) {
                error_log("$key => $value");
            }
            error_log("============");
            call_user_func(self::reactionsMap[(string)$this->reactionName], $this->userId, $data);
        } catch (\Exception $err) {
            error_log($err);
        }
    }
}
