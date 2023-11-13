<?php

namespace App\Library;

class BdxService
{
    public function getStationData() {

        $key = env('BDX_METROPOLE_ID');

        $response = \Http::get("https://data.bordeaux-metropole.fr/geojson?key=$key&typename=ci_vcub_p");

        return $response;
    }
}
