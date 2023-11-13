<?php

namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\Request;

class AboutController extends Controller
{
    public function about(Request $request) {

        $services = [];

        $allServices = Service::all();

        foreach ($allServices as $service) {
            $formattedActions = [];
            $formattedReactions = [];

            foreach ($service->actions as $action) {
                $formattedActions[] = [
                    "name" => $action->name,
                    "description" => $action->description,
                ];
            }

            foreach ($service->reactions as $reaction) {
                $formattedReactions[] = [
                    "name" => $reaction->name,
                    "description" => $reaction->description,
                ];
            }

            $formattedService = [
                "name" => $service->name,
                "actions" => $formattedActions,
                "reactions" => $formattedReactions,
            ];
            $services[] = $formattedService;
        }

        return response()->json([
            "client" => [
                "host" => $request->ip(),
            ],
            "server" => [
                "current_time" => time(),
                "services" => $services,
            ],
        ])->withHeaders(["Content-Type" => "application/json;charset=utf-8"]);
    }
}
