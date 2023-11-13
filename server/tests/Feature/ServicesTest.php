<?php

namespace Tests\Feature;

use App\Models\Service;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ServicesTest extends TestCase
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

    private function createAndLogin(): string
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

        return $response["authorization"]["token"];
    }

    public function test_get_services(): void
    {
        $this->createBaseServices();
        $token = $this->createAndLogin();

        $response = $this->getJson('/api/services', [
            "Authorization" => "Bearer {$token}"
        ]);

        $response
            ->assertStatus(200)
            ->assertJson([
                [
                    "id" => 1,
                    "name" => "Test",
                    "no_auth" => 0,
                    "actions" => [
                        [
                            'name' => 'Test action',
                            'description' => "Action de test",
                            'api_endpoint' => 'test.com',
                            'return_params' => '[{"name" : "email", "help" : "L\'adresse mail de la personne qui a envoyé le mail"}, {"name" : "email_content", "help" : "Le contenu du mail"}, {"name" : "email_object", "help" : "L\'objet du mail"}]',
                            'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
                            "id" => 1,
                            "service_id" => 1,
                        ]
                    ],
                    "reactions" => [
                        [
                            'name' => 'Test reaction',
                            'description' => "Reaction de test",
                            'api_endpoint' => 'test.com',
                            'params' => '{}',
                            'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
                            "id" => 1,
                            "service_id" => 1,
                        ]
                    ]
                ]
            ]);
    }

    public function test_get_services_unauthorized(): void
    {
        $this->createBaseServices();

        $response = $this->getJson('/api/services');

        $response->assertStatus(401);
    }

    public function test_get_services_actions_by_id(): void
    {
        $this->createBaseServices();
        $token = $this->createAndLogin();

        $response = $this->getJson('/api/services/1/actions', [
            "Authorization" => "Bearer {$token}"
        ]);

        $response
            ->assertStatus(200)
            ->assertJson([
                "actions" => [
                    [
                        'name' => 'Test action',
                        'description' => "Action de test",
                        'api_endpoint' => 'test.com',
                        'return_params' => '[{"name" : "email", "help" : "L\'adresse mail de la personne qui a envoyé le mail"}, {"name" : "email_content", "help" : "Le contenu du mail"}, {"name" : "email_object", "help" : "L\'objet du mail"}]',
                        'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
                        "id" => 1,
                        "service_id" => 1,
                    ]
                ],
                "service_icon" => "http://localhost/storage/icons/Test.svg"
            ]);
    }

    public function test_get_services_actions_unauthorized(): void
    {
        $this->createBaseServices();

        $response = $this->getJson('/api/services/1/actions');

        $response->assertStatus(401);
    }

    public function test_get_services_reactions_by_id(): void
    {
        $this->createBaseServices();
        $token = $this->createAndLogin();

        $response = $this->getJson('/api/services/1/reactions', [
            "Authorization" => "Bearer {$token}"
        ]);

        $response
            ->assertStatus(200)
            ->assertJson([
                "reactions" => [
                    [
                        'name' => 'Test reaction',
                        'description' => "Reaction de test",
                        'api_endpoint' => 'test.com',
                        'params' => '{}',
                        'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
                        "id" => 1,
                        "service_id" => 1,
                    ]
                ],
                "service_icon" => "http://localhost/storage/icons/Test.svg"
            ]);
    }

    public function test_get_services_reactions_unauthorized(): void
    {
        $this->createBaseServices();

        $response = $this->getJson('/api/services/1/reactions');

        $response->assertStatus(401);
    }
}
