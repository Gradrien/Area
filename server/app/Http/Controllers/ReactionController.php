<?php

namespace App\Http\Controllers;

use App\Models\Reaction;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReactionController extends Controller
{
    /**
     * @OA\Get(
     *     path="/reactions/{reactionId}/defaultConfig",
     *     tags={"Action / Reaction"},
     *     summary="Get default config for a reaction",
     *     @OA\Parameter(
     *          name="actionId",
     *          in="path",
     *          description="ID of reaction that needs to be fetched",
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
    public function defaultConfig($reactionId) : JsonResponse {
        if (!is_numeric($reactionId)) {
            return response()->json([
                'code' => 400,
                'message' => '400 Bad Request ID need to be numeric.'
            ], 400);
        }
        try {
            $defaultConfig = Reaction::findOrFail($reactionId)->default_config;
            return response()->json($defaultConfig);
        } catch (ModelNotFoundException $e) {
            return response()->json([
                'code' => 404,
                'message' => 'Not found.'
            ], 404);
        }
    }
}
