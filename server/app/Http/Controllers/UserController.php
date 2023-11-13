<?php

namespace App\Http\Controllers;

use App\Http\Requests\UpdateUserRequest;
use App\Models\Service;
use Illuminate\Http\JsonResponse;
use SebastianBergmann\Type\Exception;
use function response;

class UserController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api');
    }

    /**
     * @OA\Get(
     *      path="/user",
     *      tags={"User"},
     *      summary="Get the connected user",
     *      @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  property="id",
     *                  type="integer",
     *              ),
     *              @OA\Property(
     *                  property="name",
     *                  type="string",
     *                  example="John Doe"
     *              ),
     *              @OA\Property(
     *                  property="email",
     *                  type="string",
     *                  example="john@example.com"
     *                ),
     *              @OA\Property(
     *                  property="email_verified_at",
     *                  type="string",
     *                  example="2021-03-18T14:00:00.000000Z"
     *              ),
     *              @OA\Property(
     *                  property="created_at",
     *                  type="string",
     *                  example="2021-03-18T14:00:00.000000Z"
     *              ),
     *              @OA\Property(
     *                  property="updated_at",
     *                  type="string",
     *                  example="2021-03-18T14:00:00.000000Z"
     *              ),
     *          )
     *       ),
     *      @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *      ),
     *     )
     */
    public function index(): JsonResponse
    {
        return response()->json(auth()->user());
    }

    /**
     * @OA\Get(
     *      path="/user/services",
     *      tags={"User"},
     *      summary="Get the connected user's services",
     *      @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  property="name",
     *                  type="string",
     *                  example="John Doe"
     *              ),
     *              @OA\Property(
     *                  property="email",
     *                  type="string",
     *                  example="john@example.com"
     *              ),
     *              @OA\Property(
     *                  property="services",
     *                  type="array",
     *                  @OA\Items(
     *                  type="object",
     *                      @OA\Property(
     *                          property="id",
     *                          type="integer",
     *                      ),
     *                      @OA\Property(
     *                          property="name",
     *                          type="string",
     *                          example="Spotify"
     *                     ),
     *                      @OA\Property(
     *                          property="api_endpoint",
     *                          type="string",
     *                           example="spotify.com"
     *                      ),
     *                      @OA\Property(
     *                          property="is_enabled",
     *                          type="boolean",
     *                          example="true"
     *                      ),
     *                      @OA\Property(
     *                          property="service_icon",
     *                          type="string",
     *                          example="http://localhost:8000/storage/icons/spotify.svg"
     *                      ),
     *                 ),
     *             ),
     *         ),
     *     ),
     *     @OA\Response(
     *     response=401,
     *     description="Unauthenticated",
     *     ),
     *     )
     */
    public function userServices()
    {
        $user = auth()->user();
        if (!$user) {
            return response()->json([
                'message' => 'Unauthorized',
            ], 401);
        }

        $services = Service::with('actions', 'reactions')->get();

        foreach ($services as $service) {
            if ($user->auths()->where('service_id', $service->id)->count() === 0 && !$service->no_auth) {
                $service['is_enabled'] = false;
            } else {
                $service['is_enabled'] = true;
            }
            $service['service_icon'] = asset("storage/icons/" . $service->name . ".svg");
        }

        return [
            "name" => $user->name,
            "email" => $user->email,
            "services" => $services
        ];
    }

    /**
     * @OA\Get(
     *      path="/user/areas",
     *      tags={"User"},
     *      summary="Get the connected user's areas",
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
     *                       property="active",
     *                       type="boolean",
     *                       example=false
     *                  ),
     *                  @OA\Property(
     *                        property="public",
     *                        type="boolean",
     *                        example=false
     *                  ),
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
    public function userAreas()
    {

        try {
            $areas = auth()->user()->areas()->get();

            $formattedAreas = [];

            foreach ($areas as $area) {
                $formattedArea = $area;
                $formattedArea['action_name'] = $area->actionConfig()->first()->action()->first()->name;
                $formattedArea['reaction_name'] = $area->reactionConfig()->first()->reaction()->first()->name;
                $formattedArea['action_icon'] = asset("storage/icons/" . $area->actionConfig()->first()->action()->first()->service()->first()->name . ".svg");
                $formattedArea['reaction_icon'] = asset("storage/icons/" . $area->reactionConfig()->first()->reaction()->first()->service()->first()->name . ".svg");
                $formattedAreas[] = $formattedArea;
            }

            return $formattedAreas;
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Internal Server Error',
            ], 500);
        }

    }

    /**
     * @OA\Put(
     *     path="/user",
     *     tags={"User"},
     *     summary="Update the connected user's name",
     *     @OA\RequestBody(
     *          description="User object that needs to be updated",
     *          required=true,
     *          @OA\JsonContent(
     *              required={"name"},
     *              @OA\Property(
     *                  property="name",
     *                  type="string",
     *                  example="John Doe"
     *              ),
     *          ),
     *     ),
     *     @OA\Response(
     *          response=204,
     *          description="Successful operation",
     *     ),
     *     @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *     ),
     *     @OA\Response(
     *          response=500,
     *          description="Internal Server Error",
     *     ),
     * )
     *
     */

    public function updateUser(UpdateUserRequest $request)
    {
        try {
            $userAuth = auth()->user();
            \App\Models\User::find($userAuth->id)->update([
                'name' => $request['name']
            ]);
            return response()->json([], 204);
        } catch (\Exception $exception) {
            error_log($exception);
            return response()->json([
                'message' => 'Internal server error',
            ], 500);
        }
    }
}
