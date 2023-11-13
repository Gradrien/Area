<?php

namespace App\Http\Controllers;

use App\Http\Requests\MicrosoftOAuthRequest;
use App\Models\Service;
use App\Models\User;
use Exception;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;

class GoogleController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api');
    }

    public function login(MicrosoftOAuthRequest $request)
    {
        try {
            if (!$request['code']) {
                return response()->json([
                    'message' => 'Field code must be present',
                ], 400);
            }
            if ($request->input('type') === 'mobile') {
                $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                    'grant_type' => 'authorization_code',
                    'code' => $request['code'],
                    'client_id' => env('GOOGLE_MOBILE_ID'),
                    'redirect_uri' => 'com.googleusercontent.apps.633240126918-9kthlorqhcl57sebud08t232htlo0h9d:/'
                ]);
            } else {
                $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                    'grant_type' => 'authorization_code',
                    'code' => $request['code'],
                    'client_id' => env('GOOGLE_CLIENT_ID'),
                    'client_secret' => env('GOOGLE_CLIENT_SECRET'),
                    'redirect_uri' => 'http://localhost:8081/oauth/google-service/login'
                ]);
            }
            if (!$response->ok())
                return response()->json([
                    'message' => 'Cannot validate code with Google',
                    'error' => $response->json(),
                    'code_used' => $request['code']
                ], 400);
            $data = $response->json();
            $formattedExpiration = $data['expires_in'];
            $formattedExpiration = date('Y-m-d H:i:s', strtotime("+$formattedExpiration seconds"));

            $user = User::find(Auth::user()->id);
            $service = Service::where(['name' => 'Google'])->first();
            if (!$data['access_token'] || !$data['refresh_token'] || !$user || !$service)
                return response()->json([
                    'message' => 'Bad request',
                ], 400);
            $user->auths()->create([
                'expires_at' => $formattedExpiration,
                'access_token' => $data['access_token'],
                'refresh_token' => $data['refresh_token'],
                'service_id' => $service['id']
            ]);
            $user->save();
            return response()->json([
                'message' => 'Authentication created successfully',
            ], 201);
        } catch (Exception $err) {
            return response()->json([
                'message' => "Internal server error: $err",
            ], 500);
        }
    }
}