# Mingle App (Using Flutter)

This mobile app is part of the Action REAction project, which allows users to create and manage automation sequences for their digital life.

## Getting Started

These instructions will help you set up and run the mobile app on your local development environment.

### Prerequisites

- Flutter installed on your development machine.
- A working Flutter development environment set up.

### Environment Variables

Before you start, make sure to configure the following environment variables in your app's environment:

- `GOOGLE_CLIENT_ID`: Your Google OAuth client ID.
- `CALLBACK_URL_SCHEME_GOOGLE`: Your Google OAuth callback URL scheme.
- `MICROSOFT_CLIENT_ID`: Your Microsoft OAuth client ID.
- `CALLBACK_URL_SCHEME_MICROSOFT`: Your Microsoft OAuth callback URL scheme.
- `SPOTIFY_CLIENT_ID`: Your Spotify OAuth client ID.
- `CALLBACK_URL_SCHEME_SPOTIFY`: Your Spotify OAuth callback URL scheme.
- `GITLAB_CLIENT_ID`: Your GitLab OAuth client ID.
- `CALLBACK_URL_SCHEME_GITLAB`: Your GitLab OAuth callback URL scheme.
- `LOGIN_KEY`: A secret key for authentication and security purposes.

### Usage

1. Start the Application:
    ```bash
    flutter run
    ```

2. The app should open in your emulator or connected device.

3. To configure the network location of the application server, you'll need to know your device's IP address. You can obtain it using the following commands in your terminal:

   - For Linux:
     ```bash
     ip addr
     ```
   - For macOS and Linux:
     ```bash
     ifconfig
     ```

   Look for your network interface (e.g., eth0, en0, wlan0) and find the value associated with it.

4. On the login screen or on register screen, click the "Configure" button and enter the obtained IP address. The port should be set to 8080.

#### Configuring Custom Schemes

For services like Google, Microsoft, Spotify, and GitLab, you need to configure custom URL schemes. Here's how to do it:

- **Google**:
  - Visit the [Google Developer Console](https://console.developers.google.com/).
  - Create a project if you haven't already and configure your OAuth consent screen.
  - Under "Credentials," create a new OAuth 2.0 Client ID and set the correct redirect URL with your custom scheme, e.g., `yourapp://auth`.

- **Microsoft**:
  - Visit the [Azure Portal](https://portal.azure.com/).
  - Set up an Azure AD App Registration and configure the redirect URL with your custom scheme, e.g., `yourapp://auth`.

- **Spotify**:
  - Go to the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications).
  - Create a new app and specify the redirect URI with your custom scheme, e.g., `yourapp://auth`.

- **GitLab**:
  - Navigate to your GitLab account settings.
  - Create a new OAuth application and set the redirect URL to use your custom scheme, e.g., `yourapp://auth`.

### Testing

  - To run tests for the mobile app, you can use the following command:
    ```bash
     flutter test
    ```
### Building for Production

  - To build the app for production, use the following command:
    ```bash
     flutter build apk
    ```
The built APK file can be found in the `build/app/outputs/flutter-apk` directory.

## Important Notes

- This mobile app is designed to work in conjunction with the application server. Ensure that the server is up and running.

## Learn More

You can learn more about Flutter and its documentation on the [Flutter website](https://flutter.dev/).

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
