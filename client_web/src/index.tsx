import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';
import HomePage from './pages/HomePage';
import GoogleOAuth from './pages/oauth/GoogleSendAuth';
import { Provider } from 'react-redux';
import { store } from './redux/store';
import EditAreas from './pages/areas/EditAreas';
import ProtectedRoutes from './components/utils/ProtectedRoutes';
import ProfilePage from './pages/ProfilePage';
import CreateArea from './pages/areas/CreateArea';
import MicrosoftSendAuth from './pages/oauth/MicrosoftSendAuth';
import SpotifySendAuth from './pages/oauth/SpotifySendAuth';
import GoogleServiceSendAuth from './pages/oauth/GoogleServiceSendAuth';
import GitLabSendAuth from './pages/oauth/GitLabSendAuth';
import PublicAreas from './pages/areas/PublicAreas';
import ViewAreas from './pages/areas/ViewAreas';
import DlPage from './pages/DlApk';

const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      {
        path: '/',
        element: (
          <ProtectedRoutes>
            <HomePage />
          </ProtectedRoutes>
        ),
      },
      {
        path: '/oauth/google/register',
        element: <GoogleOAuth action='register' />,
      },
      {
        path: '/oauth/google/login',
        element: <GoogleOAuth action='login' />,
      },
      {
        path: '/oauth/microsoft/login',
        element: <MicrosoftSendAuth />,
      },
      {
        path: '/oauth/spotify/login',
        element: <SpotifySendAuth />,
      },
      {
        path: '/oauth/gitlab/login',
        element: <GitLabSendAuth />,
      },
      {
        path: '/oauth/google-service/login',
        element: <GoogleServiceSendAuth />,
      },
      {
        path: '/areas/edit/:id',
        element: (
          <ProtectedRoutes>
            <EditAreas />
          </ProtectedRoutes>
        ),
      },
      {
        path: '/areas/create',
        element: (
          <ProtectedRoutes>
            <CreateArea />
          </ProtectedRoutes>
        ),
      },
      {
        path: '/areas/public',
        element: (
          <ProtectedRoutes>
            <PublicAreas />
          </ProtectedRoutes>
        ),
      },
      {
        path: '/areas/view/:id',
        element: (
          <ProtectedRoutes>
            <ViewAreas />
          </ProtectedRoutes>
        ),
      },
      {
        path: 'profile',
        element: (
          <ProtectedRoutes>
            <ProfilePage />
          </ProtectedRoutes>
        ),
      },
    ],
  },
  { path: 'login', element: <LoginPage /> },
  { path: 'register', element: <RegisterPage /> },
  { path: '/client.apk', element: <DlPage /> },
]);

ReactDOM.createRoot(document.getElementById('root')!).render(
  // <React.StrictMode>
  <Provider store={store}>
    <RouterProvider router={router} />
  </Provider>,
  // </React.StrictMode>,
);
