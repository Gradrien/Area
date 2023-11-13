<?php

namespace App\Http\Controllers;

use App\Models\Action;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ActionController extends Controller
{
    /**
     * @OA\Get(
     *     path="/actions/{actionId}/defaultConfig",
     *     tags={"Action / Reaction"},
     *     summary="Get default config for an action",
     *     @OA\Parameter(
     *          name="actionId",
     *          in="path",
     *          description="ID of action that needs to be fetched",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *              format="int64"
     *          )
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="successful operation",
     *          @OA\JsonContent(
     *              type="string",
     *              example="{}"
     *          )
     *      ),
     *      @OA\Response(
     *          response=400,
     *          description="Bad Request ID need to be numeric.",
     *      ),
     *      @OA\Response(
     *          response=404,
     *          description="Not found.",
     *      ),
     * )
     */
    public function defaultConfig($actionId) : JsonResponse {
        if (!is_numeric($actionId)) {
            return response()->json([
                'code' => 400,
                'message' => 'Bad Request ID need to be numeric.'
            ], 400);
        }
        try {
            $defaultConfig = Action::findOrFail($actionId)->default_config;
            return response()->json($defaultConfig);
        } catch (ModelNotFoundException $e) {
            return response()->json([
                'code' => 404,
                'message' => 'Not found.'
            ], 404);
        }
    }
}
