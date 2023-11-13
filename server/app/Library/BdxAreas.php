<?php

function isMoreThanXBikes(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    try {
        $bdxService = new \App\Library\BdxService();

        $res = $bdxService->getStationData($config["station_name"]);

        if (!$res->ok()) {
            return null;
        }

        $resParsed = $res->json();

        $stationList = $resParsed["features"];

        $goodStation = null;

        foreach ($stationList as $station) {
            if ($station["properties"]["nom"] === $config["station_name"]) {
                $goodStation = $station['properties'];
                break;
            }
        }

        if ($goodStation === null) {
            return null;
        }

        if ($goodStation['nbvelos'] <= $config['nb_cible']) {
            $actionConfig->update([
                "isTriggered" => false
            ]);
            return null;
        } else {
            if ($actionConfig["isTriggered"] === true) {
                return null;
            }
            $actionConfig->update([
                "isTriggered" => true
            ]);
            return [
                'station_name' => $goodStation['nom'],
                'station_bikes' => $goodStation['nbvelos'],
                'station_classic_bikes' => $goodStation['nbclassiq'],
                'station_elec_bikes' => $goodStation['nbelec'],
                'station_stands' => $goodStation['nbplaces'],
                'station_nb_free' => $goodStation['nbplaces'] - $goodStation['nbvelos']
            ];
        }
    } catch (Exception $e) {
        error_log($e);
        return null;
    }
}

function isLessThanXBikes(int $userId, $config, int $timeRefresh, $actionConfig): ?array
{
    try {
        $bdxService = new \App\Library\BdxService();

        $res = $bdxService->getStationData($config["station_name"]);

        if (!$res->ok()) {
            return null;
        }

        $resParsed = $res->json();

        $stationList = $resParsed["features"];

        $goodStation = null;

        foreach ($stationList as $station) {
            if ($station["properties"]["nom"] === $config["station_name"]) {
                $goodStation = $station['properties'];
                break;
            }
        }

        if ($goodStation == null) {
            return null;
        }

        if ($goodStation['nbvelos'] >= $config['nb_cible']) {
            $actionConfig->update([
                "isTriggered" => false
            ]);
            return null;
        } else {
            if ($actionConfig["isTriggered"] === true) {
                return null;
            }
            $actionConfig->update([
                "isTriggered" => true
            ]);
            return [
                'station_name' => $goodStation['nom'],
                'station_bikes' => $goodStation['nbvelos'],
                'station_classic_bikes' => $goodStation['nbclassiq'],
                'station_elec_bikes' => $goodStation['nbelec'],
                'station_stands' => $goodStation['nbplaces'],
                'station_nb_free' => $goodStation['nbplaces'] - $goodStation['nbvelos']
            ];
        }
    } catch (Exception $e) {
        error_log($e);
        return null;
    }
}
