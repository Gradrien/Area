## Mingle Back-End documentation for developers

### Server routes documentation

The Swagger documentation of the server is available at the following link: [http://localhost:8080/api/documentation/](http://localhost:8080/api/documentation/) as soon as the server is running (use the docker-compose at the root of the projet to run the server).

### Database structure

<a href="https://ibb.co/N6LyhZN"><img src="https://i.ibb.co/8Dj736x/public.png" alt="public" border="0"></a>

### Adding an action or a reaction to Mingle

In this part we won't talk about adding OAuth2 services, but only about adding actions and reactions to Mingle.\
To get more information about the OAuth2 protocol, please refer to the [OAuth2 documentation](https://oauth.net/2/). Or visit authentication documentation of the service you aim to implement.

#### Adding an action

To add an action to Mingle, you need to create a new function in the /app/Library/{your_service}Areas.php file.\

If the file doesn't exist, you need to create it and to require it in the /app/Library/AreaHandler.php.\

This function will be prototyped as follows:

```php
    function actionName(int $userId, $config, int $timeRefresh, $actionConfig): ?array
```

Where $userId is the id of the user who wants to perform the action, $config is the associative array of parameters of the action, $timeRefresh is the time in seconds between two refreshes of the action, and $actionConfig is the Eloquent instance of the action config in database.

If the action is triggered the function must return an array with the following structure:

```php
    return [
        'variable1' => 'value1',
        'variable2' => 'value2',
        'variableX' => 'valueX',
    ];
```

The variables are the ones that will be available in the reaction configuration form.\
Else, if the action is not triggered, the function must return null. And the reaction won't be called.

Once the function is created, you need to add it to the $actionsMap array in the /app/Library/AreaHandler.php file.\
The key of the array is the name of the action, and the value is the name of the function you created in the /app/Library/{your_service}Areas.php file.

#### Adding a reaction

To add a reaction to Mingle, you need to create a new function in the /app/Library/{your_service}Areas.php file.\
If the file doesn't exist, you need to create it and to require it in the /app/Library/AreaHandler.php.\
This function will be prototyped as follows:

```php
    function reactionName(int $userId, $config)
```

Where $userId is the id of the user who wants to perform the reaction and $config is the associative array of parameters of the reaction computed to replace the variables by the values returned by the action.

Once the function is created, you need to add it to the $reactionsMap array in the /app/Library/AreaHandler.php file.\
The key of the array is the name of the reaction, and the value is the name of the function you created in the /app/Library/{your_service}Areas.php file.
