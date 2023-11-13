import { FunctionComponent } from 'react';
import { GoogleAuthOpt } from '../../types/googleBtnTypes';
import GoogleIcon from '../../assets/svg/googleIcon.svg';
import './GoogleOauthBtn.css';

const GoogleOauthBtn: FunctionComponent<GoogleAuthOpt> = ({ action }) => {
  const clientId = '633240126918-1g23ud90tqdmvhq5n2nphs6dlgakg1h3.apps.googleusercontent.com';
  const scopes = 'email profile https://www.googleapis.com/auth/gmail.modify https://www.googleapis.com/auth/drive';
  const url =
    action === 'login' ? 'http://localhost:8081/oauth/google/login' : 'http://localhost:8081/oauth/google/register';

  return (
    <a
      className='google__oauth-btn glass'
      href={`https://accounts.google.com/o/oauth2/v2/auth?scope=${scopes}&include_granted_scopes=true&access_type=offline&response_type=code&redirect_uri=${url}&client_id=${clientId}`}
    >
      <img src={GoogleIcon} alt='google icon' />
      <span>Continuer avec Google</span>
    </a>
  );
};

export default GoogleOauthBtn;
