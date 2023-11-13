<?php

namespace App\Http\Controllers;

use App\Http\Requests\AreaConfig;
use App\Http\Requests\AreaCreate;
use App\Http\Requests\AreaUpdate;
use App\Models\Action;
use App\Models\ActionConfig;
use App\Models\Area;
use App\Models\Auth;
use App\Models\PublicArea;
use App\Models\Reaction;
use App\Models\ReactionConfig;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use SebastianBergmann\Type\Exception;

class AreaController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api');
    }


    /**
     * @OA\Post (
     *     path="/area",
     *     tags={"Area"},
     *     summary="Create an area",
     *     @OA\RequestBody(
     *          required=true,
     *          @OA\JsonContent(
     *              type="object",
     *              required={"action_id","reaction_id","refresh"},
     *              @OA\Property(
     *                  property="action_id",
     *                  type="integer",
     *                  example="1"
     *              ),
     *              @OA\Property(
     *                  property="reaction_id",
     *                  type="integer",
     *                  example="1"
     *              ),
     *              @OA\Property(
     *                  property="refresh",
     *                  type="integer",
     *                  example="1"
     *              ),
     *          ),
     *     ),
     *     @OA\Response(
     *          response=201,
     *          description="Area created successfully",
     *                @OA\JsonContent(
     *                type="object",
     *                @OA\Property(
     *                    property="name",
     *                    type="string",
     *                    example="Add a track to a playlist"
     *                ),
     *                @OA\Property(
     *                    property="action_name",
     *                    type="string",
     *                    example="Add a track to a playlist"
     *                ),
     *                @OA\Property(
     *                    property="action_config",
     *                    type="string",
     *                    example="{}"
     *                 ),
     *                @OA\Property(
     *                    property="reaction_name",
     *                    type="string",
     *                    example="Add a track to a playlist"
     *                 ),
     *                @OA\Property(
     *                    property="reaction_config",
     *                    type="string",
     *                    example="{}"
     *                 ),
     *                @OA\Property(
     *                    property="id",
     *                    type="integer",
     *                    example="1"
     *                 ),
     *                @OA\Property(
     *                    property="refresh",
     *                    type="integer",
     *                    example="1"
     *                ),
     *                @OA\Property(
     *                   property="action_icon",
     *                   type="string",
     *                   example="http://localhost:8000/storage/icons/spotify.svg"
     *               ),
     *               @OA\Property(
     *                   property="reaction_icon",
     *                   type="string",
     *                   example="http://localhost:8000/storage/icons/spotify.svg"
     *               ),
     *           ),
     *     ),
     *     @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *     ),
     *     @OA\Response(
     *          response=500,
     *          description="Internal server error",
     *     ),
     * )
     *
     */
    public function createArea(AreaCreate $request): JsonResponse
    {
        try {
            $user = auth()->user();

            $newArea = new Area([
                'name' => "Nouvelle area ".uniqid(),
                'refresh' => $request->input('refresh'),
            ]);

            $actionId = $request->input('action_id');
            $reactionId = $request->input('reaction_id');

            $baseAction = Action::findOrFail($actionId);

            $newActionConfig = new ActionConfig([
                'action_id' => $request->input('action_id'),
                'config' => $baseAction->default_config,
            ]);


            $baseReaction = Reaction::findOrFail($reactionId);

            $newReactionConfig = new ReactionConfig([
                'reaction_id' => $request->input('reaction_id'),
                'config' => $baseReaction->default_config
            ]);


            $user->areas()->save($newArea);
            $newArea->actionConfig()->save($newActionConfig);
            $newArea->reactionConfig()->save($newReactionConfig);

            $user->update([
                'first_area' => false
            ]);

            return response()->json([
                'name' => $newArea->name,
                'action_name' => $newArea->actionConfig()->first()->action()->first()->name,
                'action_config' => $newArea->actionConfig()->first()->config,
                'reaction_name' => $newArea->reactionConfig()->first()->reaction()->first()->name,
                'reaction_config' => $newArea->reactionConfig()->first()->config,
                'action_icon' => asset("storage/icons/" . $newArea->actionConfig()->first()->action()->first()->service()->first()->name . ".svg"),
                'reaction_icon' => asset("storage/icons/" . $newArea->reactionConfig()->first()->reaction()->first()->service()->first()->name . ".svg"),
                'id' => $newArea->id,
                'refresh' => $newArea->refresh
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * @OA\Delete(
     *     path="/area/{areaId}",
     *     tags={"Area"},
     *     summary="Delete an area",
     *     @OA\Parameter(
     *          name="areaId",
     *          in="path",
     *          description="ID of area that needs to be deleted",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *              format="int64"
     *          )
     *     ),
     *     @OA\Response(
     *          response=200,
     *          description="Area deleted successfully",
     *     ),
     *     @OA\Response(
     *          response=400,
     *          description="Bad Request ID need to be numeric.",
     *     ),
     *     @OA\Response(
     *          response=404,
     *          description="This area doesn't exist.",
     *     ),
     *     @OA\Response(
     *          response=500,
     *          description="Internal server error",
     *     ),
     * )
     */
    public function deleteArea($areaId): JsonResponse
    {
        try {
            $user = auth()->user();

            if (!is_numeric($areaId)) {
                return response()->json([
                    'message' => 'AreaId is not a number.',
                ], 400);
            }

            $area = $user->areas()->find($areaId);

            if ($area === null) {
                return response()->json([
                    'message' => 'This area doesn\'t exist.',
                ], 404);
            }

            $area->delete();
            return response()->json([
                'message' => 'Area deleted successfully',
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/area/{areaId}",
     *     tags={"Area"},
     *     summary="Get infos of the specified area",
     *     @OA\Parameter(
     *          name="areaId",
     *          in="path",
     *          description="ID of area",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *              format="int64"
     *          )
     *     ),
     *     @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              @OA\Property(
     *                  property="name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="action_name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="reaction_name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="id",
     *                  type="integer",
     *                  example="1"
     *              ),
     *              @OA\Property(
     *                  property="action_icon",
     *                  type="string",
     *                  example="http://localhost:8000/storage/icons/spotify.svg"
     *              ),
     *              @OA\Property(
     *                  property="reaction_icon",
     *                  type="string",
     *                  example="http://localhost:8000/storage/icons/spotify.svg"
     *              ),
     *         ),
     *     ),
     *     @OA\Response(
     *          response=400,
     *          description="AreaId is not a number.",
     *     ),
     *     @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *     ),
     *     @OA\Response(
     *          response=500,
     *          description="Internal server error",
     *     ),
     * )
     */
    public function getArea($areaId): JsonResponse
    {
        try {
            $user = auth()->user();

            if (!is_numeric($areaId)) {
                return response()->json([
                    'message' => 'AreaId is not a number.',
                ], 400);
            }

            $area = $user->areas()->find($areaId);

            if ($area === null) {
                return response()->json([
                    'message' => 'This area doesn\'t exist.',
                ], 404);
            }

            return response()->json([
                'name' => $area->name,
                'action_name' => $area->actionConfig()->first()->action()->first()->name,
                'reaction_name' => $area->reactionConfig()->first()->reaction()->first()->name,
                'action_icon' => asset("storage/icons/" . $area->actionConfig()->first()->action()->first()->service()->first()->name . ".svg"),
                'reaction_icon' => asset("storage/icons/" . $area->reactionConfig()->first()->reaction()->first()->service()->first()->name . ".svg"),
                'id' => $area->id
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/area/{areaId}/data",
     *     tags={"Area"},
     *     summary="Get area details",
     *     @OA\Parameter(
     *          name="areaId",
     *          in="path",
     *          description="ID of area",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *              format="int64"
     *          )
     *     ),
     *     @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  property="name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="active",
     *                  type="boolean",
     *                  example="true"
     *              ),
     *              @OA\Property(
     *                  property="action_name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="action_config",
     *                  type="string",
     *                  example="{}"
     *               ),
     *              @OA\Property(
     *                  property="reaction_name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *               ),
     *              @OA\Property(
     *                  property="reaction_config",
     *                  type="string",
     *                  example="{}"
     *               ),
     *              @OA\Property(
     *                  property="id",
     *                  type="integer",
     *                  example="1"
     *               ),
     *              @OA\Property(
     *                  property="refresh",
     *                  type="integer",
     *                  example="1"
     *              ),
     *              @OA\Property(
     *                  property="action_icon",
     *                  type="string",
     *                  example="http://localhost:8000/storage/icons/spotify.svg"
     *              ),
     *              @OA\Property(
     *                  property="reaction_icon",
     *                  type="string",
     *                  example="http://localhost:8000/storage/icons/spotify.svg"
     *              ),
     *              @OA\Property(
     *                  property="public",
     *                  type="boolean",
     *                  example="true"
     *              ),
     *          ),
     *     ),
     *     @OA\Response(
     *          response=400,
     *          description="AreaId is not a number.",
     *     ),
     *     @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *     ),
     *     @OA\Response(
     *          response=404,
     *          description="Area not found",
     *      ),
     *     @OA\Response(
     *          response=500,
     *          description="Internal server error",
     *     ),
     *)
     */
    public function getAreaDetails($areaId): JsonResponse
    {

        try {
            $user = auth()->user();

            if (!is_numeric($areaId)) {
                return response()->json([
                    'message' => 'AreaId is not a number.',
                ], 400);
            }

            $area = $user->areas()->find($areaId);

            if ($area === null) {
                return response()->json([
                    'message' => 'This area doesn\'t exist.',
                ], 404);
            }

            $actionConfig = $area->actionConfig()->first();
            $reactionConfig = $area->reactionConfig()->first();

            return response()->json([
                'name' => $area->name,
                'active' => $area->active,
                'action_name' => $actionConfig->action()->first()->name,
                'action_config' => $actionConfig->config,
                'action_params' => $actionConfig->action()->first()->return_params,
                'reaction_name' => $reactionConfig->reaction()->first()->name,
                'reaction_config' => $reactionConfig->config,
                'action_icon' => asset("storage/icons/" . $actionConfig->action()->first()->service()->first()->name . ".svg"),
                'reaction_icon' => asset("storage/icons/" . $reactionConfig->reaction()->first()->service()->first()->name . ".svg"),
                'id' => $area->id,
                'refresh' => $area->refresh,
                'public' => $area->public
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * @OA\Put(
     *      path="/area/{areaId}",
     *      tags={"Area"},
     *      summary="Update an area",
     *      @OA\Parameter(
     *          name="areaId",
     *          in="path",
     *          description="ID of area that needs to be updated",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *              format="int64"
     *          )
     *      ),
     *      @OA\RequestBody(
     *          required=true,
     *          @OA\JsonContent(
     *              required={"name","action_config","reaction_config","refresh", "active"},
     *              @OA\Property(
     *                  property="name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="action_config",
     *                  type="string",
     *                  example="{}"
     *              ),
     *              @OA\Property(
     *                  property="reaction_config",
     *                  type="string",
     *                  example="{}"
     *              ),
     *              @OA\Property(
     *                  property="refresh",
     *                  type="integer",
     *                  example="1"
     *              ),
     *              @OA\Property(
     *                  property="active",
     *                  type="boolean",
     *                   example="true"
     *              ),
     *          ),
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="Area updated successfully",
     *      ),
     *      @OA\Response(
     *          response=400,
     *          description="Bad Request ID need to be numeric.",
     *      ),
     *      @OA\Response(
     *          response=404,
     *          description="This area doesn't exist.",
     *      ),
     *      @OA\Response(
     *          response=500,
     *          description="Internal server error",
     *      ),
     * )
     *
     */

    public function updateArea($areaId, AreaUpdate $request): JsonResponse
    {

        try {
            $action_config = json_decode($request->input('action_config'), true);
            $reaction_config = json_decode($request->input('reaction_config'), true);

            foreach ($action_config as $conf) {
                if ($conf['mandatory'] === true && $conf['value'] === '') {
                    return response()->json([
                        'message' => "La configuration de l'action n'est pas valide",
                    ], 400);
                }
            }

            foreach ($reaction_config as $conf) {
                if ($conf['mandatory'] === true && $conf['value'] === '') {
                    return response()->json([
                        'message' => "La configuration de la réaction n'est pas valide",
                    ], 400);
                }
            }

            $user = auth()->user();

            if (!is_numeric($areaId)) {
                return response()->json([
                    'message' => 'AreaId is not a number.',
                ], 400);
            }

            $area = $user->areas()->find($areaId);

            if ($area === null) {
                return response()->json([
                    'message' => 'This area doesn\'t exist.',
                ], 404);
            }

            $area->update([
                'refresh' => $request->input('refresh'),
                'name' => $request->input('name'),
                'active' => $request->input('active')
            ]);

            $area->actionConfig()->first()->update([
                'config' => $request->input('action_config')
            ]);

            $area->reactionConfig()->first()->update([
                'config' => $request->input('reaction_config')
            ]);
            return response()->json([
                'message' => 'Area updated successfully',
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal Server Error',
            ], 500);
        }
    }

    /**
     *  @OA\Post (
     *      path="/area/{areadId}/start",
     *      tags={"Area"},
     *      summary="Dispatch an area",
     *      @OA\Parameter(
     *          name="areaId",
     *          in="path",
     *          description="ID of area that needs to be dispatched",
     *          required=true,
     *          @OA\Schema(
     *               type="integer",
     *               format="int64"
     *          )
     *      ),
     *      @OA\Response(
     *           response=201,
     *           description="Area created successfully",
     *      ),
     *      @OA\Response(
     *           response=401,
     *           description="Unauthenticated",
     *      ),
     *      @OA\Response(
     *           response=500,
     *           description="Internal server error",
     *      ),
     *  )
     */
    public function startArea($areaId): JsonResponse
    {
        try {
            if (!is_numeric($areaId)) {
                return response()->json([
                    'message' => 'AreaId is not a number.',
                ], 400);
            }
            dispatch((new \App\Jobs\AreaJob($areaId)));
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
        return response()->json([
            'message' => 'Area dispatched successfully',
        ], 200);
    }

    /**
     * @OA\Post (
     *       path="/area/{areadId}/public",
     *       tags={"Area"},
     *       summary="Publish an area",
     *       @OA\Parameter(
     *           name="areaId",
     *           in="path",
     *           description="ID of area that needs to be dispatched",
     *           required=true,
     *           @OA\Schema(
     *                type="integer",
     *                format="int64"
     *           )
     *       ),
     *       @OA\Response(
     *            response=200,
     *            description="Area published successfully",
     *       ),
     *       @OA\Response(
     *            response=401,
     *            description="Unauthenticated",
     *       ),
     *       @OA\Response(
     *             response=403,
     *             description="This area doesn't belong to you",
     *       ),
     *       @OA\Response(
     *              response=409,
     *              description="Area already published",
     *       ),
     *       @OA\Response(
     *            response=500,
     *            description="Internal server error",
     *       ),
     *   )
     */
    public function publishArea($areaId) {

        try {
            $user = auth()->user();

            $area = Area::findOrFail($areaId);

            if ($area->user->id !== $area->user_id) {
                return response()->json([
                    'message' => 'This area doesn\'t belong to you',
                ], 403);
            }

            if (PublicArea::where('area_id', $area->id)->first() !== null) {
                return response()->json([
                    'message' => 'Area already published',
                ], 409);
            }

            $newPublicArea = PublicArea::create([
                'name' => $area->name,
                'refresh' => 1,
                'area_id' => $area->id
            ]);

            $area->public = true;
            $area->save();

            return response()->json([
                'message' => 'Area published successfully',
                'id' => $newPublicArea->id
            ], 200);
        } catch (Exception $e) {
            error_log($e);
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * @OA\Delete(
     *      path="/area/{areaId}/public",
     *      tags={"Area"},
     *      summary="Delete a public area",
     *      @OA\Parameter(
     *           name="areaId",
     *           in="path",
     *           description="ID of area that needs to be deleted",
     *           required=true,
     *           @OA\Schema(
     *               type="integer",
     *               format="int64"
     *           )
     *      ),
     *      @OA\Response(
     *           response=200,
     *           description="Public Area removed successfully",
     *      ),
     *      @OA\Response(
     *          response=403,
     *          description="This area doesn't belong to you",
     *      ),
     *      @OA\Response(
     *           response=404,
     *           description="Public Area not found",
     *      ),
     *      @OA\Response(
     *           response=500,
     *           description="Internal server error",
     *      ),
     *  )
     */
    public function removePublicArea($areaId) {

            try {
                $area = Area::findOrFail($areaId);

                if ($area->user->id !== $area->user_id) {
                    return response()->json([
                        'message' => 'This area doesn\'t belong to you',
                    ], 403);
                }

                if (PublicArea::where('area_id', $area->id)->first() === null) {
                    return response()->json([
                        'message' => 'Public Area not found',
                    ], 404);
                }

                $publicArea = PublicArea::where('area_id', $area->id)->first();
                $publicArea->delete();

                $area->public = false;
                $area->save();

                return response()->json([
                    'message' => 'Public Area removed successfully',
                ], 200);
            } catch (Exception $e) {
                error_log($e);
                return response()->json([
                    'message' => 'Internal server error',
                ], 500);
            }
    }

    /**
     * @OA\Get(
     *      path="/area/public",
     *      tags={"Area"},
     *      summary="Get all the public areas",
     *      @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="array",
     *              @OA\Items(
     *                  type="object",
     *                  @OA\Property(
     *                      property="name",
     *                      type="string",
     *                      example="My AreaHandler"
     *                  ),
     *                  @OA\Property(
     *                      property="action_name",
     *                      type="string",
     *                      example="Receive an email"
     *                  ),
     *                  @OA\Property(
     *                      property="reaction_name",
     *                      type="string",
     *                      example="Send an email"
     *                  ),
     *                  @OA\Property(
     *                      property="user_id",
     *                      type="integer",
     *                  ),
     *                  @OA\Property(
     *                       property="refresh",
     *                       type="integer",
     *                  ),
     *                  @OA\Property(
     *                      property="id",
     *                      type="integer",
     *                      example="1"
     *                  ),
     *                  @OA\Property(
     *                      property="action_icon",
     *                      type="string",
     *                      example="http://localhost:8000/storage/icons/email.svg"
     *                  ),
     *                  @OA\Property(
     *                      property="reaction_icon",
     *                      type="string",
     *                      example="http://localhost:8000/storage/icons/email.svg"
     *                  ),
     *                  @OA\Property(
     *                      property="active",
     *                      type="boolean",
     *                      example=false
     *                  ),
     *                  @OA\Property(
     *                       property="public",
     *                       type="boolean",
     *                       example=false
     *                   ),
     *                   @OA\Property(
     *                        property="is_available",
     *                        type="boolean",
     *                        example=false
     *                    )
     *              ),
     *          ),
     *     ),
     *     @OA\Response(
     *     response=401,
     *     description="Unauthenticated",
     *     ),
     *     @OA\Response(
     *          response=500,
     *          description="Internal Server Error",
     *     ),
     * )
     *
     */

    public function getPublicAreas() {
        try {
            $publicAreas = PublicArea::all();

            $areas = [];

            foreach ($publicAreas as $publicArea) {
                $area = Area::findOrFail($publicArea->area_id);

                $isAvailable = false;
                $actionConfig = $area->actionConfig()->first();
                $reactionConfig = $area->reactionConfig()->first();

                $actionService = $actionConfig->action()->first()->service()->first();
                $reactionService = $reactionConfig->reaction()->first()->service()->first();

                $user = auth()->user();
                if (($actionService->no_auth || $user->auths()->where('service_id', $actionService->id)->first() !== null) && ($reactionService->no_auth || $user->auths()->where('service_id', $reactionService->id)->first() !== null)) {
                    $isAvailable = true;
                }

                $area['action_name'] = $actionConfig->action()->first()->name;
                $area['reaction_name'] = $reactionConfig->reaction()->first()->name;
                $area['action_icon'] = asset("storage/icons/" . $actionConfig->action()->first()->service()->first()->name . ".svg");
                $area['reaction_icon'] = asset("storage/icons/" . $reactionConfig->reaction()->first()->service()->first()->name . ".svg");
                $area['is_available'] = $isAvailable;
                $areas[] = $area;
            }
            return response()->json($areas, 200);
        } catch (Exception $e) {
            error_log($e);
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/area/{areaId}/public",
     *     tags={"Area"},
     *     summary="Get public area details",
     *     @OA\Parameter(
     *          name="areaId",
     *          in="path",
     *          description="ID of the public area",
     *          required=true,
     *          @OA\Schema(
     *              type="integer",
     *              format="int64"
     *          )
     *     ),
     *     @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  property="name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="active",
     *                  type="boolean",
     *                  example="true"
     *              ),
     *              @OA\Property(
     *                  property="action_name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *              ),
     *              @OA\Property(
     *                  property="action_config",
     *                  type="string",
     *                  example="{}"
     *               ),
     *              @OA\Property(
     *                  property="reaction_name",
     *                  type="string",
     *                  example="Add a track to a playlist"
     *               ),
     *              @OA\Property(
     *                  property="reaction_config",
     *                  type="string",
     *                  example="{}"
     *               ),
     *              @OA\Property(
     *                  property="id",
     *                  type="integer",
     *                  example="1"
     *               ),
     *              @OA\Property(
     *                  property="refresh",
     *                  type="integer",
     *                  example="1"
     *              ),
     *              @OA\Property(
     *                  property="action_icon",
     *                  type="string",
     *                  example="http://localhost:8000/storage/icons/spotify.svg"
     *              ),
     *              @OA\Property(
     *                  property="reaction_icon",
     *                  type="string",
     *                  example="http://localhost:8000/storage/icons/spotify.svg"
     *              ),
     *              @OA\Property(
     *                  property="public",
     *                  type="boolean",
     *                  example="true"
     *              ),
     *          ),
     *     ),
     *     @OA\Response(
     *          response=400,
     *          description="AreaId is not a number.",
     *     ),
     *     @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *     ),
     *     @OA\Response(
     *          response=404,
     *          description="Area not found",
     *      ),
     *     @OA\Response(
     *          response=500,
     *          description="Internal server error",
     *     ),
     *)
     */

    public function getPublicAreaDetails($areaId) {
        try {
            if (!is_numeric($areaId)) {
                return response()->json([
                    'message' => 'AreaId is not a number.',
                ], 400);
            }

            $area = Area::find($areaId);

            if ($area === null) {
                return response()->json([
                    'message' => 'This area doesn\'t exist.',
                ], 404);
            }

            if (!$area->public) {
                return response()->json([
                    'message' => 'This area is not public.',
                ], 403);
            }

            $actionConfig = $area->actionConfig()->first();
            $reactionConfig = $area->reactionConfig()->first();

            $user = auth()->user();
            $actionService = $actionConfig->action()->first()->service()->first();
            $reactionService = $reactionConfig->reaction()->first()->service()->first();

            $isAvailable = false;

            if (($actionService->no_auth || $user->auths()->where('service_id', $actionService->id)->first() !== null) && ($reactionService->no_auth || $user->auths()->where('service_id', $reactionService->id)->first() !== null)) {
                $isAvailable = true;
            }

            $formattedActionConfig = (preg_replace("/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b/", "*****EMAIL*****", $actionConfig->config));
            $formattedReactionConfig = (preg_replace("/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b/", "*****EMAIL*****", $reactionConfig->config));

            return response()->json([
                'name' => $area->name,
                'active' => $area->active,
                'action_name' => $actionConfig->action()->first()->name,
                'action_config' => $formattedActionConfig,
                'action_params' => $actionConfig->action()->first()->return_params,
                'reaction_name' => $reactionConfig->reaction()->first()->name,
                'reaction_config' => $formattedReactionConfig,
                'action_icon' => asset("storage/icons/" . $actionConfig->action()->first()->service()->first()->name . ".svg"),
                'reaction_icon' => asset("storage/icons/" . $reactionConfig->reaction()->first()->service()->first()->name . ".svg"),
                'id' => $area->id,
                'refresh' => $area->refresh,
                'public' => $area->public,
                'is_available' => $isAvailable,
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * @OA\Post (
     *       path="/area/{areadId}/copy",
     *       tags={"Area"},
     *       summary="Copy a public area",
     *       @OA\Parameter(
     *           name="areaId",
     *           in="path",
     *           description="ID of area that needs to be copied",
     *           required=true,
     *           @OA\Schema(
     *                type="integer",
     *                format="int64"
     *           )
     *       ),
     *       @OA\Response(
     *            response=400,
     *            description="AreaId is not a number",
     *       ),
     *       @OA\Response(
     *            response=404,
     *            description="This area doesn't exist",
     *       ),
     *       @OA\Response(
     *             response=403,
     *             description="This area is not public",
     *       ),
     *       @OA\Response(
     *            response=500,
     *            description="Internal server error",
     *       ),
     *       @OA\Response(
     *           response=200,
     *           description="Area copied successfully",
     *      )
     *   )
     */

    public function copyArea($areaId) {
        try {
            $user = auth()->user();

            if (!is_numeric($areaId)) {
                return response()->json([
                    'message' => 'AreaId is not a number.',
                ], 400);
            }

            $area = Area::find($areaId);

            if ($area === null) {
                return response()->json([
                    'message' => 'This area doesn\'t exist.',
                ], 404);
            }

            if (!$area->public) {
                return response()->json([
                    'message' => 'This area is not public.',
                ], 403);
            }

            $newArea = $area->replicate();
            $newArea->name = $area->name . " (copie)";
            $newArea->user_id = $user->id;
            $newArea->public = false;
            $newArea->active = false;
            $newArea->save();

            $newActionConfig = $area->actionConfig()->first()->replicate();
            $newActionConfig->config = preg_replace("/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b/", "*****EMAIL*****", $newActionConfig->config);
            $newActionConfig->area_id = $newArea->id;
            $newActionConfig->save();

            $newReactionConfig = $area->reactionConfig()->first()->replicate();
            $newReactionConfig->config = preg_replace("/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b/", "*****EMAIL*****", $newReactionConfig->config);
            $newReactionConfig->area_id = $newArea->id;
            $newReactionConfig->save();

            $this->startArea($newArea->id);

            return response()->json([
                'message' => 'Area copied successfully',
                'id' => $newArea->id
            ], 200);
        } catch (Exception $e) {
            error_log($e);
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }
}
