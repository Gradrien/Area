<?php

namespace Tests\Feature;

// use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_register_unprocessable_password_mismatch(): void
    {
        $response = $this->postJson('/api/auth/register', [
            "name" => "John Doe",
            "email" => "john@doe.com",
            "password" => "password",
            "password_confirmation" => "passwordother"
        ]);

        $response
            ->assertStatus(422)
            ->assertJson([
                "message" => "The password field confirmation does not match.",
                "errors" => [
                    "password" => [
                        "The password field confirmation does not match."
                    ]
                ]
            ]);
    }

//    public function test_register_unprocessable_not_email(): void
//    {
//        $response = $this->postJson('/api/auth/register', [
//            "name" => "John Doe",
//            "email" => "johndoe.com",
//            "password" => "password",
//            "password_confirmation" => "passwordother"
//        ]);
//
//        $response
//            ->assertStatus(422)
//            ->assertJson([
//                "message" => "The password field confirmation does not match.",
//                "errors" => [
//                    "password" => [
//                        "The password field confirmation does not match."
//                    ]
//                ]
//            ]);
//    }

    public function test_register_valid_response(): void
    {
        $response = $this->postJson('/api/auth/register', [
            "name" => "John Doe",
            "email" => "john@example.com",
            "password" => "password",
            "password_confirmation" => "password"
        ]);

        $response->assertStatus(201);
    }

    public function test_login_unprocessable_missing_field(): void
    {
        $response = $this->postJson('/api/auth/login', [
            "name" => "John Doe",
            "email" => "john@doe.com"
        ]);

        $response
            ->assertStatus(401);
    }

    public function test_login_unprocessable_missing_name(): void
    {
        $response = $this->postJson('/api/auth/login', [
            "password" => "password"
        ]);

        $response
            ->assertStatus(401);
    }

    public function test_login_invalid(): void
    {
        User::create([
            "name" => "John",
            "password" => Hash::make("password"),
            "email" => "john@doe.com",
            "isGoogleAccount" => "false",
        ]);
        $response = $this->postJson('/api/auth/login', [
            "email" => "john@doe.com",
            "password" => "passwordo"
        ]);

        $response->assertStatus(401);
    }

    public function test_login_valid(): void
    {
        User::create([
            "name" => "John",
            "password" => Hash::make("password"),
            "email" => "john@doe.com",
            "isGoogleAccount" => "false",
        ]);

        $response = $this->postJson('/api/auth/login', [
            "email" => "john@doe.com",
            "password" => "password"
        ]);

        $response->assertStatus(200);
    }

    public function test_logout(): void
    {
        User::create([
            "name" => "John",
            "password" => Hash::make("password"),
            "email" => "john@doe.com",
            "isGoogleAccount" => "false",
        ]);

        $response = $this->postJson('/api/auth/login', [
            "email" => "john@doe.com",
            "password" => "password"
        ]);

        $this->post("/api/auth/logout")->withHeaders([
            "Authorization" => "Bearer {$response["authorization"]["token"]}"
        ]);

        $res = $this->getJson("/api/user", [
            "Authorization" => "Bearer {$response["authorization"]["token"]}"
        ]);
        $res->assertStatus(401);
    }

}
