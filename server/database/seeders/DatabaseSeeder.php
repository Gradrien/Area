<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Library\BdxService;
use App\Library\FootLiveService;
use App\Models\Action;
use App\Models\Reaction;
use App\Models\Service;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {

        if (count(Service::where('name', '=', 'Google')->get()) === 0) {
            Service::create([
                'name' => 'Google',
                'api_endpoint' => 'https://www.googleapis.com/oauth2/v4/token'
            ]);
        }

        if (count(Service::where('name', '=', 'GitLab')->get()) === 0) {
            Service::create([
                'name' => 'GitLab',
                'api_endpoint' => 'https://gitlab.com/oauth/token'
            ]);
        }

        if (count(Service::where('name', '=', 'Microsoft')->get()) === 0) {
            Service::create([
                'name' => 'Microsoft',
                'api_endpoint' => 'https://login.microsoftonline.com/common/oauth2/v2.0/token'
            ]);
        }

        if (count(Service::where('name', '=', 'Spotify')->get()) === 0) {
            Service::create([
                'name' => 'Spotify',
                'api_endpoint' => 'https://accounts.spotify.com/api/token'
            ]);
        }

        if (count(Service::where('name', '=', 'Bordeaux Métropole')->get()) === 0) {
            Service::create([
                'name' => 'Bordeaux Métropole',
                'api_endpoint' => 'bdx.com',
                'no_auth' => true
            ]);
        }

        if (count(Service::where('name', '=', 'FootLive')->get()) === 0) {
            Service::create([
                'name' => 'FootLive',
                'api_endpoint' => 'footlive.com',
                'no_auth' => true
            ]);
        }

        if (count(Action::where('name', '=', 'Recevoir un mail')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'Google')->first()->actions()->create([
                'name' => 'Recevoir un mail',
                'description' => "L'utilisateur reçoit un nouveau mail envoyé par un utilisateur cible sur sa boîte mail",
                'api_endpoint' => 'google.com',
                'return_params' => '[{"name" : "email", "help" : "L\'adresse mail de la personne qui a envoyé le mail"}, {"name" : "email_content", "help" : "Le contenu du mail"}, {"name" : "email_object", "help" : "L\'objet du mail"}]',
                'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Email de l\'expéditeur"}]',
            ]);
        }

        if (count(Action::where('name', '=', 'Un fichier est uploadé sur Google Drive')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'Google')->first()->actions()->create([
                'name' => 'Un fichier est uploadé sur Google Drive',
                'description' => "Un nouveau fichier est créé ou uploadé sur Google Drive",
                'api_endpoint' => 'google.com',
                'return_params' => '[{"name" : "file_name", "help" : "Le nom du fichier uploadé"}, {"name" : "file_type", "help" : "Le type du fichier uploadé"}]',
                'default_config' => '[]',
            ]);
        }

        if (count(Action::where('name', '=', 'Un évènement est créé sur Outlook')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'Microsoft')->first()->actions()->create([
                'name' => 'Un évènement est créé sur Outlook',
                'description' => "Un nouvel évènement est créé sur le calendrier Outlook de l'utilisateur",
                'api_endpoint' => 'outlook.com',
                'return_params' => '[{"name" : "event_title", "help" : "Le titre de l\'évènement"}, {"name" : "event_description", "help" : "La description de l\'évènement"}, {"name" : "event_start", "help" : "La date de début de l\'évènement"}, {"name" : "event_end", "help" : "La date de fin de l\'évènement"}, {"name" : "event_location", "help" : "Le lieu de l\'évènement"}, {"name" : "organizer_name", "help" : "Le nom de l\'organisateur de l\'évènement"}, {"name" : "organizer_email", "help" : "L\'email de l\'organisateur de l\'évènement"}]',
                'default_config' => '[]',
            ]);
        }

        if (count(Action::where('name', '=', 'Une nouvelle issue est créée')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'GitLab')->first()->actions()->create([
                'name' => 'Une nouvelle issue est créée',
                'description' => "Une nouvelle issue est crée sur un des repositories accessibles par l'utilisateur",
                'api_endpoint' => 'gitlab.com',
                'return_params' => '[{"name" : "issue_title", "help" : "Le nom de l\'issue"}, {"name" : "issue_description", "help" : "La description de l\'issue"}, {"name" : "issue_author", "help" : "Le nom du créateur de l\'issue"}, {"name" : "issue_url", "help" : "L\'url de l\'issue"}, {"name" : "issue_due_date", "help" : "La date de fin de l\'issue"}]',
                'default_config' => '[{"name": "labels", "value": "", "mandatory": false, "htmlFormType": "text", "display" : "Labels (séparés par des virgules)"}]',
            ]);
        }

        if (count(Action::where('name', '=', 'Une nouvelle issue est créée sur un repository')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'GitLab')->first()->actions()->create([
                'name' => 'Une nouvelle issue est créée sur un repository',
                'description' => "Une nouvelle issue est crée sur le repository précisé par l'utilisateur",
                'api_endpoint' => 'gitlab.com',
                'return_params' => '[{"name" : "issue_title", "help" : "Le nom de l\'issue"}, {"name" : "issue_description", "help" : "La description de l\'issue"}, {"name" : "issue_author", "help" : "Le nom du créateur de l\'issue"}, {"name" : "issue_url", "help" : "L\'url de l\'issue"}, {"name" : "issue_due_date", "help" : "La date de fin de l\'issue"}]',
                'default_config' => '[{"name": "repo_url", "value": "", "mandatory": true, "htmlFormType": "text", "display" : "URL du repository ({namespace}/{nom du projet})"}, {"name": "labels", "value": "", "mandatory": false, "htmlFormType": "text", "display" : "Labels (séparés par des virgules)"}]',
            ]);
        }

        if (count(Action::where('name', '=', 'Un commit est push sur un repository')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'GitLab')->first()->actions()->create([
                'name' => 'Un commit est push sur un repository',
                'description' => "Un nouveau commit est créé sur le repository précisé par l'utilisateur",
                'api_endpoint' => 'gitlab.com',
                'return_params' => '[{"name" : "commit_title", "help" : "Le titre du commit"}, {"name" : "commit_author", "help" : "Le nom de l\'auteur du commit"}, {"name" : "commit_author_email", "help" : "L\'email de l\'auteur du commit"}, {"name" : "commit_url", "help" : "L\'url du commit"}, {"name" : "commit_message", "help" : "Le message du commit"}]',
                'default_config' => '[{"name": "repo_url", "value": "", "mandatory": true, "htmlFormType": "text", "display" : "URL du repository ({namespace}/{nom du projet})"}, {"name": "branch", "value": "", "mandatory": false, "htmlFormType": "text", "display" : "Nom de la branche cible (main par défaut)"}]',
            ]);
        }

        if (count(Reaction::where('name', '=', 'Envoyer un mail avec Gmail')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'Google')->first()->reactions()->create([
                'name' => 'Envoyer un mail avec Gmail',
                'description' => "Envoie un mail au destinataire donné par l'utilisateur avec le compte Gmail de l'utilisateur",
                'api_endpoint' => 'google.com',
                'params' => '{}',
                'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display" : "Destinataire"}, {"name": "email_object", "value": "", "mandatory": false, "htmlFormType": "text", "display" : "Objet du mail"}, {"name": "email_content", "value": "", "mandatory": false, "htmlFormType": "textarea", "display" : "Contenu du mail"}]',
            ]);
        }

        if (count(Reaction::where('name', '=', 'Envoyer un mail avec Outlook')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'Microsoft')->first()->reactions()->create([
                'name' => 'Envoyer un mail avec Outlook',
                'description' => "Envoie un mail au destinataire donné par l'utilisateur avec le compte Outlook de l'utilisateur",
                'api_endpoint' => 'outlook.com',
                'params' => '{}',
                'default_config' => '[{"name": "email", "value": "", "mandatory": true, "htmlFormType": "email", "display": "Destinataire"}, {"name": "email_object", "value": "", "mandatory": false, "htmlFormType": "text", "display" : "Objet du mail"}, {"name": "email_content", "value": "", "mandatory": false, "htmlFormType": "textarea", "display" : "Contenu du mail"}]',
            ]);
        }

        if (count(Reaction::where('name', '=', 'Musique suivante')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'Spotify')->first()->reactions()->create([
                'name' => 'Musique suivante',
                'description' => "Passe à la musique suivante sur le lecteur de l'utilisateur",
                'api_endpoint' => 'spotify.com',
                'params' => '{}',
                'default_config' => '[]',
            ]);
        }

        if (count(Reaction::where('name', '=', 'Mettre la musique sur pause')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'Spotify')->first()->reactions()->create([
                'name' => 'Mettre la musique sur pause',
                'description' => "Met la musique sur pause sur le lecteur de l'utilisateur",
                'api_endpoint' => 'spotify.com',
                'params' => '{}',
                'default_config' => '[]',
            ]);
        }

        if (count(Action::where('name', '=', "Une session d'écoute commence")->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'Spotify')->first()->actions()->create([
                'name' => "Une session d'écoute commence",
                'description' => "Détecte quand un utilisateur commence à écouter de la musique",
                'api_endpoint' => 'spotify.com',
                'return_params' => '[{"name" : "device_name", "help" : "Le nom de l\'appareil sur lequel la musique est jouée"}, {"name" : "device_type", "help" : "Le type de l\'appareil sur lequel la musique est jouée"}, {"name" : "device_volume", "help" : "Le volume de l\'appareil sur lequel la musique est jouée"}, {"name" : "track_image", "help" : "L\'image de la musique jouée"}, {"name" : "track_name", "help" : "Le nom de la musique jouée"}, {"name" : "track_release", "help" : "La date de sortie de la musique jouée"}, {"name" : "artist_name", "help" : "Le nom de l\'artiste de la musique jouée"}]',
                'default_config' => '[]',
            ]);
        }

//        if (count(Reaction::where('name', '=', 'Démarrer la musique')->get()) === 0) {
//            error_log("Reaction created");
//            Service::all()->where('name', '=', 'Spotify')->first()->reactions()->create([
//                'name' => 'Démarrer la musique',
//                'api_endpoint' => 'spotify.com',
//                'params' => '{}',
//                'default_config' => '[]',
//            ]);
//        }

        if (count(Reaction::where('name', '=', 'Musique précédente')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'Spotify')->first()->reactions()->create([
                'name' => 'Musique précédente',
                'description' => "Passe à la musique précédente sur le lecteur de l'utilisateur",
                'api_endpoint' => 'spotify.com',
                'params' => '{}',
                'default_config' => '[]',
            ]);
        }

        if (count(Reaction::where('name', '=', 'Créer une note sur OneNote')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'Microsoft')->first()->reactions()->create([
                'name' => 'Créer une note sur OneNote',
                'description' => "Crée une note sur OneNote avec les informations fournies par l'utilisateur",
                'api_endpoint' => 'outlook.com',
                'params' => '{}',
                'default_config' => '[{"name": "title", "value": "", "mandatory": false, "htmlFormType": "text", "display" : "Titre de la note"}, {"name": "body", "value": "", "mandatory": false, "htmlFormType": "textarea", "display" : "Contenu de la note"}]',
            ]);
        }

        if (count(Reaction::where('name', '=', 'Créer une issue')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'GitLab')->first()->reactions()->create([
                'name' => 'Créer une issue',
                'description' => "Crée une issue sur le repository précisé par l'utilisateur",
                'api_endpoint' => 'gitlab.com',
                'params' => '{}',
                'default_config' => '[{"name": "repo_url", "value": "", "mandatory": true, "htmlFormType": "text", "display" : "URL du repository ({namespace}/{nom du projet})"}, {"name": "title", "value": "", "mandatory": true, "htmlFormType": "text", "display" : "Titre de l\'issue"}, {"name": "description", "value": "", "mandatory": false, "htmlFormType": "textarea", "display" : "Contenu de l\'issue"}, {"name": "due_date", "value": "", "mandatory": false, "htmlFormType": "date", "display" : "Date limite"}, {"name": "labels", "value": "", "mandatory": false, "htmlFormType": "text", "display" : "Labels (séparés par des virgules)"}]',
            ]);
        }

        if (count(Reaction::where('name', '=', 'Créer une nouvelle branche')->get()) === 0) {
            error_log("Reaction created");
            Service::all()->where('name', '=', 'GitLab')->first()->reactions()->create([
                'name' => 'Créer une nouvelle branche',
                'description' => "Crée une nouvelle branche sur le repository précisé par l'utilisateur",
                'api_endpoint' => 'gitlab.com',
                'params' => '{}',
                'default_config' => '[{"name": "repo_url", "value": "", "mandatory": true, "htmlFormType": "text", "display" : "URL du repository ({namespace}/{nom du projet})"}, {"name": "branch_name", "value": "", "mandatory": true, "htmlFormType": "text", "display" : "Nom de la branche"}, {"name": "branch_ref", "value": "", "mandatory": true, "htmlFormType": "text", "display" : "Nom de la branche de référence"}]',
            ]);
        }

        $stationsList = 'select:';

        $response = (new BdxService())->getStationData();

        if ($response->ok()) {
            $response = $response->json();
            $response = $response["features"];
            foreach ($response as $station) {
                $stationsList .= $station["properties"]["nom"] . '|' . $station["properties"]["nom"] . ';';
            }
        }

        $stationsList = substr_replace($stationsList, "", -1);

        if (count(Action::where('name', '=', 'Le nombre de vélos disponible à une station dépasse X')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'Bordeaux Métropole')->first()->actions()->create([
                'name' => 'Le nombre de vélos disponible à une station dépasse X',
                'description' => "Détecte quand le nombre de vélos disponibles à une station dépasse un nombre donné par l'utilisateur",
                'api_endpoint' => 'bdx.com',
                'return_params' => '[{"name" : "station_name", "help" : "Le nom de la station"}, {"name" : "station_bikes", "help" : "Le nombre de vélos disponibles à la station"}, {"name" : "station_classic_bikes", "help" : "Le nombre de vélos classiques disponibles à la station"}, {"name" : "station_elec_bikes", "help" : "Le nombre de vélos électriques disponibles à la station"}, {"name" : "station_stands", "help" : "Le nombre de places totales de la station"}, {"name" : "station_nb_free", "help" : "Le nombre de places libres à la station"}]',
                'default_config' => '[{"name": "station_name", "value": "", "mandatory": true, "htmlFormType": "' . $stationsList . '", "display" : "Nom de la station"}, {"name": "nb_cible", "value": "", "mandatory": true, "htmlFormType": "number", "display" : "Nombre de vélos à dépasser"}]',
            ]);
        }

        if (count(Action::where('name', '=', 'Le nombre de vélos disponible à une station passe sous X')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'Bordeaux Métropole')->first()->actions()->create([
                'name' => 'Le nombre de vélos disponible à une station passe sous X',
                'description' => "Détecte quand le nombre de vélos disponibles à une station passe sous un nombre donné par l'utilisateur",
                'api_endpoint' => 'bdx.com',
                'return_params' => '[{"name" : "station_name", "help" : "Le nom de la station"}, {"name" : "station_bikes", "help" : "Le nombre de vélos disponibles à la station"}, {"name" : "station_classic_bikes", "help" : "Le nombre de vélos classiques disponibles à la station"}, {"name" : "station_elec_bikes", "help" : "Le nombre de vélos électriques disponibles à la station"}, {"name" : "station_stands", "help" : "Le nombre de places totales de la station"}, {"name" : "station_nb_free", "help" : "Le nombre de places libres à la station"}]',
                'default_config' => '[{"name": "station_name", "value": "", "mandatory": true, "htmlFormType": "' . $stationsList . '", "display" : "Nom de la station"}, {"name": "nb_cible", "value": "", "mandatory": true, "htmlFormType": "number", "display" : "Nombre de vélos à dépasser"}]',
            ]);
        }

        $teamList = 'select:';

        $response = (new FootLiveService())->getTeams();

        if ($response->ok()) {
            $response = $response->json();
            foreach ($response as $team) {
                $teamList .= $team["team_name"] . '|' . $team["team_key"] . ';';
            }
        }

        $teamList = substr_replace($teamList, "", -1);

        if (count(Action::where('name', '=', 'Mon équipe joue')->get()) === 0) {
            error_log("Action created");
            Service::all()->where('name', '=', 'FootLive')->first()->actions()->create([
                'name' => 'Mon équipe joue',
                'description' => "Detecte quand l'équipe sélectionnée joue et envoie les informations concernant le match",
                'api_endpoint' => 'footlive.com',
                'return_params' => '[{"name" : "home_team_name", "help" : "Le nom de l\'équipe à domicile"}, {"name" : "away_team_name", "help" : "Le nom de l\'équipe à l\'exterieur"}, {"name" : "hometeam_name", "help" : "Le nom de l\'équipe à domicile"}, {"name" : "stadium", "help" : "Le nom du stade"}, {"name" : "referee", "help" : "Le nom de l\'arbitre"}, {"name" : "score", "help" : "Le score en direct"}]',
                'default_config' => '[{"name": "team_id", "value": "", "mandatory": true, "htmlFormType": "' . $teamList . '", "display" : "Nom de l\'équipe"}]',
            ]);
        }

//        Service::all()->where('name', '=', 'Spotify')->first()->actions()->createMany([[
//            'name' => 'You liked a song',
//            'api_endpoint' => 'spotify.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'You liked a playlist',
//            'api_endpoint' => 'spotify.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ],[
//            'name' => 'You followed an artist',
//            'api_endpoint' => 'spotify.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ]]);
//        Service::all()->where('name', '=', 'Microsoft')->first()->actions()->createMany([[
//            'name' => 'Receive an email',
//            'api_endpoint' => 'office.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'Receive a Teams message',
//            'api_endpoint' => 'office.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ]]);
//        Service::all()->where('name', '=', 'The Movie DB')->first()->actions()->createMany([[
//            'name' => 'You added a film in favorite',
//            'api_endpoint' => 'moviedb.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'You added a film in the watchlist',
//            'api_endpoint' => 'moviedb.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ]]);
//        Service::all()->where('name', '=', 'Binance')->first()->actions()->createMany([[
//            'name' => 'A crypto surpasses a target',
//            'api_endpoint' => 'binance.com',
//            'return_params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ]]);
//
//        Service::all()->where('name', '=', 'Spotify')->first()->reactions()->createMany([[
//            'name' => 'Like a song',
//            'api_endpoint' => 'spotify.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'Follow an artist',
//            'api_endpoint' => 'spotify.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'Go to the next song',
//            'api_endpoint' => 'spotify.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'Go to the previous song',
//            'api_endpoint' => 'spotify.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ]]);
//
//        Service::all()->where('name', '=', 'Microsoft')->first()->reactions()->createMany([[
//            'name' => 'Send an email',
//            'api_endpoint' => 'office.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'Send a Teams message',
//            'api_endpoint' => 'office.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ]]);
//        Service::all()->where('name', '=', 'The Movie DB')->first()->reactions()->createMany([[
//            'name' => 'Add a film in favorite',
//            'api_endpoint' => 'moviedb.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ], [
//            'name' => 'Add a film in the watchlist',
//            'api_endpoint' => 'moviedb.com',
//            'params' => json_encode(''),
//            'default_config' => json_encode(''),
//        ]]);

//        if (count(User::all()->all()) === 0) {
//            \App\Models\User::insert([
//                [
//                        'name' => 'Nils',
//                        'email' => 'nils@gmail.com',
//                        'password' => '********'
//                ], [
//                        'name' => 'Kevin',
//                        'email' => 'kevin@gmail.com',
//                        'password' => '********'
//                ], [
//                        'name' => 'Adrien',
//                        'email' => 'adrien@gmail.com',
//                        'password' => '********'
//                ], [
//                        'name' => 'Elouan',
//                        'email' => 'elouan@gmail.com',
//                        'password' => '********'
//                ], [
//                        'name' => 'Hippolyte',
//                        'email' => 'hippolyte@gmail.com',
//                        'password' => '********'
//                ]]
//            );
//        }
    }
}
