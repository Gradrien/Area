<?php

namespace App\Http\Controllers;

use App\Http\Requests\GoogleSignUpRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\Service;
use App\Models\User;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;

class AuthController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api', ['except' => ['login', 'register', 'googleSignUp', 'googleSignIn']]);
    }

    /**
     * @OA\Post(
     *      path="/login",
     *      tags={"Auth"},
     *      summary="Login",
     *      @OA\RequestBody(
     *          required=true,
     *          @OA\JsonContent(
     *              required={"email","password"},
     *              @OA\Property(
     *                  property="email",
     *                  type="string",
     *                  example="john@example.com"
     *              ),
     *              @OA\Property(
     *                  property="password",
     *                  type="string",
     *                  example="password"
     *              ),
     *          ),
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *                  @OA\Property(
     *                      property="user",
     *                      type="object",
     *                      @OA\Property(
     *                          property="id",
     *                          type="integer",
     *                      ),
     *                      @OA\Property(
     *                          property="name",
     *                          type="string",
     *                          example="John Doe"
     *                      ),
     *                      @OA\Property(
     *                          property="email",
     *                          type="string",
     *                          example="john@example.com"
     *                      ),
     *                      @OA\Property(
     *                          property="email_verified_at",
     *                          type="string",
     *                          example="2021-03-18T14:00:00.000000Z"
     *                      ),
     *                      @OA\Property(
     *                          property="created_at",
     *                          type="string",
     *                          example="2021-03-18T14:00:00.000000Z"
     *                      ),
     *                      @OA\Property(
     *                          property="updated_at",
     *                          type="string",
     *                          example="2021-03-18T14:00:00.000000Z"
     *                      ),
     *                  ),
     *                  @OA\Property(
     *                      property="authorization",
     *                      type="object",
     *                      @OA\Property(
     *                          property="token",
     *                          type="string",
     *                          example="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"
     *                      ),
     *                      @OA\Property(
     *                          property="type",
     *                          type="string",
     *                          example="bearer"
     *                      ),
     *                  ),
     *              ),
     *          ),
     *     )
     * )
     */
    public function login(Request $request): JsonResponse
    {
        $credentials = $request->only('email', 'password');
        $token = Auth::attempt($credentials);

        if (!$token) {
            return response()->json([
                'message' => 'Identifiant ou Mot de passe incorrect',
            ], 401);
        }

        $user = Auth::user();
        return response()->json([
            'user' => $user,
            'authorization' => [
                'token' => $token,
                'type' => 'bearer',
            ]
        ]);
    }

    /**
     * @OA\Post(
     *      path="/register",
     *      tags={"Auth"},
     *      summary="Register",
     *      @OA\RequestBody(
     *          required=true,
     *          @OA\JsonContent(
     *              required={"name","email","password","password_confirmation"},
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
     *                  property="password",
     *                  type="string",
     *                  example="password"
     *              ),
     *              @OA\Property(
     *                  property="password_confirmation",
     *                  type="string",
     *                  example="password"
     *              ),
     *          ),
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  property="message",
     *                  type="string",
     *                  example="User created successfully"
     *              ),
     *              @OA\Property(
     *                  property="user",
     *                  type="object",
     *                  @OA\Property(
     *                       property="id",
     *                       type="integer",
     *                  ),
     *                  @OA\Property(
     *                       property="name",
     *                       type="string",
     *                       example="John Doe"
     *                  ),
     *                  @OA\Property(
     *                       property="email",
     *                       type="string",
     *                       example="john@example.com"
     *                  ),
     *                  @OA\Property(
     *                       property="email_verified_at",
     *                       type="string",
     *                       example="2021-03-18T14:00:00.000000Z"
     *                  ),
     *                  @OA\Property(
     *                       property="created_at",
     *                       type="string",
     *                       example="2021-03-18T14:00:00.000000Z"
     *                  ),
     *                  @OA\Property(
     *                       property="updated_at",
     *                       type="string",
     *                       example="2021-03-18T14:00:00.000000Z"
     *                  ),
     *              ),
     *          ),
     *     ),
     * )
     */
    public function register(RegisterRequest $request): JsonResponse
    {
        try {
            $user = User::create([
                'name' => $request['name'],
                'email' => $request['email'],
                'password' => Hash::make($request['password']),
            ]);

            $user->save();
            $credentials = $request->only('email', 'password');
            $token = Auth::attempt($credentials);

            return response()->json([
                'message' => 'User created successfully',
                'user' => $user,
                'authorization' => [
                    'token' => $token,
                    'type' => 'bearer',
                ]
            ], 201);
        } catch (Exception $err) {
            return response()->json([
                'message' => "Internal server error: $err",
            ], 500);
        }
    }

    /**
     * @OA\Post(
     *      path="/logout",
     *      tags={"Auth"},
     *      summary="Logout",
     *      security={{"bearerAuth":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  property="message",
     *                  type="string",
     *                  example="Successfully logged out"
     *              ),
     *          ),
     *      ),
     *      @OA\Response(
     *          response=401,
     *          description="Unauthenticated",
     *     ),
     * )
     */
    public function logout(): JsonResponse
    {
        Auth::logout();
        return response()->json([
            'message' => 'Successfully logged out',
        ]);
    }

    /**
     * @OA\Post(
     *     path="/refresh",
     *     tags={"Auth"},
     *     summary="Refresh token",
     *     security={{"bearerAuth":{}}},
     *     @OA\Response(
     *          response=200,
     *          description="Successful operation",
     *          @OA\JsonContent(
     *              type="object",
     *              @OA\Property(
     *                  property="user",
     *                  type="object",
     *                  @OA\Property(
     *                      property="id",
     *                      type="integer",
     *                  ),
     *                  @OA\Property(
     *                      property="name",
     *                      type="string",
     *                      example="John Doe"
     *                   ),
     *                  @OA\Property(
     *                      property="email",
     *                      type="string",
     *                      example="john@example.com"
     *                  ),
     *                  @OA\Property(
     *                      property="email_verified_at",
     *                      type="string",
     *                      example="2021-03-18T14:00:00.000000Z"
     *                  ),
     *                  @OA\Property(
     *                      property="created_at",
     *                      type="string",
     *                   example="2021-03-18T14:00:00.000000Z"
     *                  ),
     *                  @OA\Property(
     *                      property="updated_at",
     *                      type="string",
     *                      example="2021-03-18T14:00:00.000000Z"
     *                  ),
     *              ),
     *              @OA\Property(
     *                  property="authorization",
     *                  type="object",
     *                  @OA\Property(
     *                      property="token",
     *                      type="string",
     *                      example="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"
     *                  ),
     *                  @OA\Property(
     *                      property="type",
     *                      type="string",
     *                      example="bearer"
     *                  ),
     *              ),
     *          ),
     *     ),
     *  )
     */
    public function refresh(): JsonResponse
    {
        return response()->json([
            'user' => Auth::user(),
            'authorization' => [
                'token' => Auth::refresh(),
                'type' => 'bearer',
            ]
        ]);
    }

    public function getGoogleUserInfos(string $code, string $redirectUri, bool $mobile): ?array
    {
        $headers = [
            'code' => $code,
            'client_id' => env('GOOGLE_CLIENT_ID'),
            'client_secret' => env('GOOGLE_CLIENT_SECRET'),
            'redirect_uri' => $redirectUri,
            'grant_type' => 'authorization_code'
        ];
        $mobileHeaders = [
            'code' => $code,
            'client_id' => env('GOOGLE_MOBILE_ID'),
            'redirect_uri' => $redirectUri,
            'grant_type' => 'authorization_code'
        ];
        $tokens = Http::post('https://oauth2.googleapis.com/token', $mobile ? $mobileHeaders : $headers);
        if (!$tokens->ok()) {
            return null;
        }
        $accessToken = $tokens['access_token'];
        $refreshToken = $tokens['refresh_token'];
        $expiresAt = $tokens['expires_in'];
        $userInfos = Http::withToken($accessToken)->get('https://openidconnect.googleapis.com/v1/userinfo');
        if (!$userInfos->ok() || !$userInfos['email_verified']) {
            return null;
        }
        return [
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'expires_at' => $expiresAt,
            'user_name' => $userInfos['given_name'],
            'user_email' => $userInfos['email'],
        ];
    }

    public function googleSignUp(GoogleSignUpRequest $request): JsonResponse
    {
        if (!$request['code'] || !$request['redirect']) {
            return response()->json([
                'message' => 'Bad request 1',
            ], 400);
        }
        try {
            $userInfos = $this->getGoogleUserInfos($request['code'], $request['redirect'], $request['type'] == "mobile");
            $formattedExpiration = $userInfos['expires_at'];
            $formattedExpiration = date('Y-m-d H:i:s', strtotime("+$formattedExpiration seconds"));

            if (!$userInfos) {
                return response()->json([
                    'message' => 'Bad request 2',
                ], 400);
            }
            $service = Service::where(['name' => 'Google'])->first();
            $user = User::create([
                'name' => $userInfos['user_name'],
                'email' => $userInfos['user_email'],
                'password' => '',
                'isGoogleAccount' => true
            ])->auths()->create([
                'expires_at' => $formattedExpiration,
                'access_token' => $userInfos['access_token'],
                'refresh_token' => $userInfos['refresh_token'],
                'service_id' => $service['id']
            ]);
            $user->save();
            $token = Auth::attempt([
                "email" => $userInfos['user_email'],
                "password" => '',
                "isGoogleAccount" => true
            ]);
            return response()->json([
                'message' => 'User created successfully',
                'user' => $user,
                'authorization' => [
                    'token' => $token,
                    'type' => 'bearer',
                ]
            ], 201);
        } catch (Exception $err) {
            return response()->json([
                'message' => "Internal server error: $err",
            ], 500);
        }
    }

    public function googleSignIn(GoogleSignUpRequest $request): JsonResponse
    {
        if (!$request['code'] || !$request['redirect']) {
            return response()->json([
                'message' => 'Bad request',
            ], 400);
        }
        try {
            $userInfos = $this->getGoogleUserInfos($request['code'], $request['redirect'], $request['type'] == "mobile");
//            dd($userInfos);
            if (!$userInfos) {
                return response()->json([
                    'message' => 'Bad request',
                ], 400);
            }
            $token = Auth::attempt([
                "email" => $userInfos['user_email'],
                "password" => '',
                "isGoogleAccount" => true
            ]);

            if (!$token) {
                $service = Service::where(['name' => 'Google'])->first();
                $formattedExpiration = $userInfos['expires_at'];
                $formattedExpiration = date('Y-m-d H:i:s', strtotime("+$formattedExpiration seconds"));
                User::create([
                    'name' => $userInfos['user_name'],
                    'email' => $userInfos['user_email'],
                    'password' => '',
                    'isGoogleAccount' => true
                ])->auths()->create([
                    'expires_at' => $formattedExpiration,
                    'access_token' => $userInfos['access_token'],
                    'refresh_token' => $userInfos['refresh_token'],
                    'service_id' => $service['id']
                ])->save();
                $token = Auth::attempt([
                    "email" => $userInfos['user_email'],
                    "password" => '',
                    "isGoogleAccount" => true
                ]);
            }

            $user = Auth::user();
            return response()->json([
                'user' => $user,
                'authorization' => [
                    'token' => $token,
                    'type' => 'bearer',
                ]
            ]);
        } catch (Exception $err) {
            return response()->json([
                'message' => "Internal server error: $err",
            ], 500);
        }
    }
}
