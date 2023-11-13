<?php

namespace Tests\Feature;

use App\Models\Service;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    private function createBaseServices(): void
    {

        Service::create([
            'name' => 'Test',
            'api_endpoint' => 'Test.com'
        ]);

        Service::all()->where('name', '=', 'Test')->first()->actions()->create([
            'name' => 'Test action',
            'description' => "Action de test",
            'api_endpoint' => 'test.com',
            'return_params' => '[{"name" : "email", "help" : "L\'adresse mail de la personne qui a envoyé le mail"}, {"name" : "email_content", "help" : "Le contenu du mail"}, {"name" : "email_object", "help" : "L\'objet du mail"}]',
            'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
        ]);

        Service::all()->where('name', '=', 'Test')->first()->reactions()->create([
            'name' => 'Test reaction',
            'description' => "Reaction de test",
            'api_endpoint' => 'test.com',
            'params' => '{}',
            'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
        ]);

    }

    public function test_get_user(): void
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

        $res = $this->getJson("/api/user", [
            "Authorization" => "Bearer {$response["authorization"]["token"]}"
        ]);

        $res
            ->assertStatus(200)
            ->assertJson([
                "id" => $response->json()['user']['id'],
                "name" => "John",
                "email" => "john@doe.com",
            ]);
    }

    public function test_get_user_unauthorized(): void
    {
        User::create([
            "name" => "John",
            "password" => Hash::make("password"),
            "email" => "john@doe.com",
            "isGoogleAccount" => "false",
        ]);

        $res = $this->getJson("/api/user");

        $res->assertStatus(401);
    }

    public function test_get_user_services(): void
    {
        $this->createBaseServices();
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

        $res = $this->getJson("/api/user/services", [
            "Authorization" => "Bearer {$response["authorization"]["token"]}"
        ]);

        $res->assertStatus(200);
    }

    public function test_get_user_services_unauthorized(): void
    {
        $this->createBaseServices();
        User::create([
            "name" => "John",
            "password" => Hash::make("password"),
            "email" => "john@doe.com",
            "isGoogleAccount" => "false",
        ]);

        $res = $this->getJson("/api/user/services");

        $res->assertStatus(401);
    }


    public function test_get_user_area(): void
    {
        $this->createBaseServices();
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

        $res = $this->getJson("/api/user/areas", [
            "Authorization" => "Bearer {$response["authorization"]["token"]}"
        ]);

        $res->assertStatus(200);
    }

    public function test_get_user_area_unauthorized(): void
    {
        $this->createBaseServices();
        User::create([
            "name" => "John",
            "password" => Hash::make("password"),
            "email" => "john@doe.com",
            "isGoogleAccount" => "false",
        ]);

        $res = $this->getJson("/api/user/areas");

        $res->assertStatus(401);
    }
}
