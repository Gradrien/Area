<?php

namespace App\Http\Controllers;

use App\Models\Auth;
use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Routing\ControllerMiddlewareOptions;
use Symfony\Component\HttpFoundation\JsonResponse;
use Illuminate\Database\Eloquent\ModelNotFoundException;

/**
 * @OA\Schema(
 *  schema="Action_Reaction",
 *  @OA\Property(
 *      property="id",
 *      type="integer",
 *      ),
 *  @OA\Property(
 *      property="name",
 *      type="string",
 *      example="Add a track to a playlist"
 *    ),
 *  @OA\Property(
 *      property="api_endpoint",
 *      type="string",
 *      example="https://api.spotify.com/v1/"
 *  ),
 *  @OA\Property(
 *      property="return_params",
 *      type="string",
 *      example=""
 *  ),
 *  @OA\Property(
 *      property="default_config",
 *      type="string",
 *      example=""
 *  ),
 *  @OA\Property(
 *      property="service_id",
 *      type="integer",
 *      example="1"
 *  ),
 *  @OA\Property(
 *     property="description",
 *     type="string",
 *     example="Add a track to a playlist"
 * ),
 * )
 */

class ServiceController extends Controller
{

    public function __construct() {
        $this->middleware('auth:api');
    }

    /**
     * @OA\Get(
     *     path="/services",
     *     tags={"Service"},
     *     summary="Get all services",
     *     @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="array",
     *              @OA\Items(
     *                  type="object",
     *                  @OA\Property(
     *                      property="id",
     *                      type="integer",
     *                  ),
     *                  @OA\Property(
     *                      property="name",
     *                      type="string",
     *                      example="Spotify"
     *                  ),
     *                  @OA\Property(
     *                      property="api_endpoint",
     *                      type="string",
     *                      example="http://localhost:8000/storage/icons/spotify.svg"
     *                  ),
     *                  @OA\Property(
     *                      property="no_auth",
     *                      type="boolean",
     *                      example="false"
     *                 ),
     *                  @OA\Property(
     *                      property="actions",
     *                      type="array",
     *                      @OA\Items(
     *                          type="object",
     *                          oneOf={
     *                              @OA\Schema(ref="#/components/schemas/Action_Reaction"),
     *                          }
     *                      ),
     *                  ),
     *                  @OA\Property(
     *                      property="reactions",
     *                      type="array",
     *                      @OA\Items(
     *                          oneOf={
     *                              @OA\Schema(ref="#/components/schemas/Action_Reaction"),
     *                          }
     *                      )
     *                  ),
     *              ),
     *          ),
     *     ),
     *     @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *     ),
     * )
     *
     */
    public function index() : JsonResponse {
        $services = Service::with('actions', 'reactions')->get();

        $formattedServices = [];

        foreach ($services as $service) {
            $service['service_icon'] = asset("storage/icons/".$service->name.".svg");
            $formattedServices[] = $service;
        }

        return response()->json($formattedServices);
    }

    /**
     * @OA\Get(
     *     path="/services/{serviceId}/actions",
     *     tags={"Service"},
     *     summary="Get all actions for a service",
     *     @OA\Parameter(
     *          name="serviceId",
     *          in="path",
     *          description="ID of the service",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *          )
     *     ),
     *     @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  type="array",
     *                  property="actions",
     *                  @OA\Items(
     *                      type="object",
     *                      oneOf={
     *                          @OA\Schema(ref="#/components/schemas/Action_Reaction"),
     *                      }
     *                  ),
     *              ),
     *              @OA\Property(
     *                  property="service_icon",
     *                  type="string",
     *                  example="http://localhost:8000/storage/icons/spotify.svg"
     *              ),
     *         ),
     *     ),
     *     @OA\Response(
     *          response=400,
     *          description="Bad Request ID need to be numeric.",
     *     ),
     *     @OA\Response(
     *          response=404,
     *          description="400 Bad Request Wrong id used please try again with valid ID.",
     *     ),
     *  )
     *
     */
    public function actions($serviceId) : JsonResponse {
        if (!is_numeric($serviceId)) {
            return response()->json([
                'code' => 400,
                'message' => 'Bad Request ID need to be numeric.'
            ], 400);
        }
        try {
            $actions = Service::findOrFail($serviceId)->actions;
            return response()->json(['service_icon' => asset("storage/icons/".$actions->first()->service()->first()->name.".svg"), 'actions' => $actions]);
        } catch (ModelNotFoundException $e) {
            return response()->json([
                'code' => 404,
                'message' => 'Not found.'
            ], 404);
        }
    }

    /**
     * @OA\Get(
     *     path="/services/{serviceId}/reactions",
     *     tags={"Service"},
     *     summary="Get all reactions for a service",
     *     @OA\Parameter(
     *          name="serviceId",
     *          in="path",
     *          description="ID of the service",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *          )
     *     ),
     *      @OA\Response(
     *           response=200,
     *           description="Successful operation",
     *           @OA\JsonContent(
     *               type="object",
     *               @OA\Property(
     *                   type="array",
     *                   property="reactions",
     *                   @OA\Items(
     *                       type="object",
     *                       oneOf={
     *                           @OA\Schema(ref="#/components/schemas/Action_Reaction"),
     *                       }
     *                   ),
     *               ),
     *               @OA\Property(
     *                   property="service_icon",
     *                   type="string",
     *                   example="http://localhost:8000/storage/icons/spotify.svg"
     *               ),
     *          ),
     *      ),
     *     @OA\Response(
     *          response=400,
     *          description="Bad Request ID need to be numeric.",
     *     ),
     *     @OA\Response(
     *          response=404,
     *          description="400 Bad Request Wrong id used please try again with valid ID.",
     *     ),
     *  )
     *
     */
    public function reactions($serviceId): JsonResponse {
        if (!is_numeric($serviceId)) {
            return response()->json([
                'code' => 400,
                'message' => '400 Bad Request ID need to be numeric.'
            ], 400);
        }
        try {
            $reactions = Service::findOrFail($serviceId)->reactions;
            return response()->json(['service_icon' => asset("storage/icons/".$reactions->first()->service()->first()->name.".svg"), 'reactions' => $reactions]);
        } catch (ModelNotFoundException $e) {
            return response()->json([
                'code' => 404,
                'message' => 'Not found.'
            ], 404);
        }
    }

    public function deleteService($serviceId) {
        try {

            if (!is_numeric($serviceId)) {
                return response()->json([
                    'code' => 400,
                    'message' => 'Bad Request ID need to be numeric.'
                ], 400);
            }

            $user = auth()->user();
            $user->auths()->where('service_id', $serviceId)->delete();

            $areas = $user->areas()->get();

            foreach ($areas as $area) {
                $actionService = $area->actionConfig()->first()->action()->first()->service()->first()->id;
                $reactionService = $area->reactionConfig()->first()->reaction()->first()->service()->first()->id;

                if ($actionService == $serviceId || $reactionService == $serviceId) {
                    $area->delete();
                }
            }

            return response()->json([
                'code' => 200,
                'message' => 'Service deleted.'
            ], 200);
        } catch (Exception $e) {
            error_log($e);
            return response()->json([
                'code' => 500,
                'message' => 'Internal server error.'
            ], 500);

        }
    }

}
