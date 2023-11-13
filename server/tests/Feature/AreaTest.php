<?php

namespace Tests\Feature;

use App\Models\Action;
use App\Models\Reaction;
use App\Models\Service;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AreaTest extends TestCase {
    use RefreshDatabase;

    private function createAndLogin() : string {
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

    private function createBaseServices() : void {

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

    public function test_create_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response
            ->assertStatus(201)
            ->assertJson([
                "action_name" => $action->name,
                "action_config" => $action->default_config,
                "reaction_name" => $reaction->name,
                "reaction_config" => $reaction->default_config,
                "refresh" => 1,
            ]);
    }

    public function test_create_area_invalid_action(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $reaction = Reaction::first();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => 999,
            "reaction_id" => $reaction->id,
        ]);

        $response
            ->assertStatus(404);
    }

    public function test_create_area_invalid_reaction(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => 999,
        ]);

        $response
            ->assertStatus(404);
    }

    public function test_create_area_unauthenticated(): void {
        $this->createBaseServices();

        $action = Action::first();

        $response = $this->withHeaders([
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => 999,
        ]);

        $response
            ->assertStatus(401)->assertJson([
                "message" => "Unauthenticated."
            ]);
    }

    public function test_create_area_no_reaction(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
        ]);

        $response
            ->assertStatus(422);
    }

    public function test_create_area_no_action(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $reaction = Reaction::first();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "reaction_id" => $reaction->id,
        ]);

        $response
            ->assertStatus(422);
    }

    public function test_get_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/{$responseCreation["id"]}");

        $response->assertStatus(200)->assertJson([
            "reaction_name" => $reaction->name,
            "action_name" => $action->name,
            "id" => $responseCreation["id"],
            "action_icon" => "http://localhost/storage/icons/Test.svg",
            "reaction_icon" => "http://localhost/storage/icons/Test.svg"
        ]);
    }

    public function test_get_non_existing_area(): void {
        $bearer = $this->createAndLogin();
        $response = $this->withHeaders([

            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/404");

        $response->assertStatus(404)->assertJson([
            "message" => "This area doesn't exist."
        ]);
    }

    public function test_get_wrong_id_area(): void {
        $bearer = $this->createAndLogin();
        $response = $this->withHeaders([

            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/aaa");

        $response->assertStatus(400)->assertJson([
            "message" => "AreaId is not a number."
        ]);
    }

    public function test_update_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $creationResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->putJson("/api/area/{$creationResponse['id']}", [
            "name" => "Add a track to a playlist",
            "action_config" => '[{"name": "email", "value": "test", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "reaction_config" => '[{"name": "email", "value": "test2", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "refresh" => 4,
            "active" => false,
        ]);

        $response->assertStatus(200)->assertJson([
            'message' => 'Area updated successfully',
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/{$creationResponse["id"]}");

        $response->assertStatus(200)->assertJson([
            "name" => "Add a track to a playlist",
            "reaction_name" => $reaction->name,
            "action_name" => $action->name,
            "action_icon" => "http://localhost/storage/icons/Test.svg",
            "reaction_icon" => "http://localhost/storage/icons/Test.svg",
        ]);

    }

    public function test_update_area_miss_mandatory_reaction(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $creationResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->putJson("/api/area/{$creationResponse['id']}", [
            "name" => "Add a track to a playlist",
            "action_config" => '[{"name": "email", "value": "test", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "reaction_config" => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "refresh" => 4,
            "active" => false,
        ]);

        $response->assertStatus(400)->assertJson([
            'message' => "La configuration de la réaction n'est pas valide",
        ]);
    }

    public function test_update_area_miss_mandatory_action(): void
    {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $creationResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->putJson("/api/area/{$creationResponse['id']}", [
            "name" => "Add a track to a playlist",
            "action_config" => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "reaction_config" => '[{"name": "email", "value": "test", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "refresh" => 4,
            "active" => false,
        ]);

        $response->assertStatus(400)->assertJson([
            'message' => "La configuration de l'action n'est pas valide",
        ]);
    }

    public function test_update_area_wrong_id(): void
    {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $creationResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->putJson("/api/area/aaa", [
            "name" => "Add a track to a playlist",
            "action_config" => '[{"name": "email", "value": "test", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "reaction_config" => '[{"name": "email", "value": "test", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "refresh" => 4,
            "active" => false,
        ]);

        $response->assertStatus(400)->assertJson([
            'message' => "AreaId is not a number.",
        ]);
    }

    public function test_update_non_existing_area(): void
    {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $creationResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->putJson("/api/area/404", [
            "name" => "Add a track to a playlist",
            "action_config" => '[{"name": "email", "value": "test", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "reaction_config" => '[{"name": "email", "value": "test", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            "refresh" => 4,
            "active" => false,
        ]);

        $response->assertStatus(404)->assertJson([
            'message' => "This area doesn't exist.",
        ]);
    }

    public function test_delete_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $deleteResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer"
        ])->delete("/api/area/{$response["id"]}");

        $deleteResponse->assertStatus(200)->assertJson(
            [
                "message" => "Area deleted successfully",
            ]
        );
    }

    public function test_delete_non_existing_area(): void {
        $bearer = $this->createAndLogin();

        $deleteResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer"
        ])->delete("/api/area/404");


        $deleteResponse->assertStatus(404)->assertJson(
            [
                "message" => "This area doesn't exist.",
            ]
        );
    }

    public function test_delete_wrong_id_area(): void {
        $bearer = $this->createAndLogin();

        $deleteResponse = $this->withHeaders([
            "Authorization" => "Bearer $bearer"
        ])->delete("/api/area/aaa");


        $deleteResponse->assertStatus(400)->assertJson(
            [
                "message" => "AreaId is not a number.",
            ]
        );
    }

    public function test_get_area_details(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/{$responseCreation["id"]}/data");

        $response->assertStatus(200)->assertJson([
            "reaction_name" => $reaction->name,
            "action_name" => $action->name,
            "id" => $responseCreation["id"],
            "action_icon" => "http://localhost/storage/icons/Test.svg",
            "reaction_icon" => "http://localhost/storage/icons/Test.svg",
            "public" => false,
            "refresh" => 1,
            "action_config" => $action->default_config,
            "reaction_config" => $reaction->default_config,
            "active" => true,
        ]);
    }

    public function test_get_non_existing_area_details(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/404/data");

        $response->assertStatus(404)->assertJson([
            "message" => "This area doesn't exist."
        ]);
    }

    public function test_get_wrong_id_area_details(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/hhh/data");

        $response->assertStatus(400)->assertJson([
            "message" => "AreaId is not a number."
        ]);
    }

    public function test_publish_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/{$responseCreation["id"]}/public");

        $response->assertStatus(200)->assertJson([
            "message" => "Area published successfully"
        ]);
    }

    public function test_already_published_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/{$responseCreation["id"]}/public");

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/{$responseCreation["id"]}/public");

        $response->assertStatus(409)->assertJson([
            "message" => "Area already published"
        ]);
    }

    public function test_get_public_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/{$responseCreation["id"]}/public");

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/{$responseCreation["id"]}/public");

        $response->assertStatus(200)->assertJson([
            "reaction_name" => $reaction->name,
            "action_name" => $action->name,
            "id" => $responseCreation["id"],
            "action_icon" => "http://localhost/storage/icons/Test.svg",
            "reaction_icon" => "http://localhost/storage/icons/Test.svg",
            "public" => true,
            "refresh" => 1,
            "action_config" => $action->default_config,
            "reaction_config" => $reaction->default_config,
        ]);
    }

    public function test_get_public_area_not_public(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/{$responseCreation["id"]}/public");

        $response->assertStatus(403)->assertJson([
            "message" => "This area is not public."
        ]);
    }

    public function test_get_wrong_id_public_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/aaa/public");

        $response->assertStatus(400)->assertJson([
            "message" => "AreaId is not a number."
        ]);
    }

    public function test_delete_public_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/{$responseCreation["id"]}/public");

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->delete("/api/area/{$responseCreation["id"]}/public");

        $response->assertStatus(200)->assertJson([
            "message" => "Public Area removed successfully"
        ]);
    }

    public function test_delete_non_existing_public_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->delete("/api/area/404/public");

        $response->assertStatus(404);
    }

    public function test_delete_wrong_id_public_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->delete("/api/area/aaa/public");

        $response->assertStatus(404);
    }

    public function test_get_public_areas(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/{$responseCreation["id"]}/public");

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->get("/api/area/public");

        $response->assertStatus(200)->assertJson([
            [
                "reaction_name" => $reaction->name,
                "action_name" => $action->name,
                "id" => $responseCreation["id"],
                "action_icon" => "http://localhost/storage/icons/Test.svg",
                "reaction_icon" => "http://localhost/storage/icons/Test.svg",
                "public" => true,
                "refresh" => 1,
                "user_id" => 1,
                "is_available" => false,
            ]
        ]);
    }

    public function test_copy_not_public_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $action = Action::first();
        $reaction = Reaction::first();

        $responseCreation = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->postJson('/api/area', [
            "refresh" => 1,
            "action_id" => $action->id,
            "reaction_id" => $reaction->id,
        ]);

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/{$responseCreation["id"]}/copy");

        $response->assertStatus(403)->assertJson([
            "message" => "This area is not public."
        ]);
    }

    public function test_copy_non_existing_area(): void {
        $bearer = $this->createAndLogin();
        $this->createBaseServices();

        $response = $this->withHeaders([
            "Authorization" => "Bearer $bearer",
        ])->post("/api/area/404/copy");

        $response->assertStatus(404)->assertJson([
            "message" => "This area doesn't exist."
        ]);
    }
}
