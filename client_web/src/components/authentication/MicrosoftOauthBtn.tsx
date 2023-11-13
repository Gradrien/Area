import { FunctionComponent } from 'react';
import MicrosoftIcon from '../../assets/svg/microsoftIcon.svg';
import './MicrosoftOauthBtn.css';

const MicrosoftOauthBtn: FunctionComponent = () => {
  const clientId = '9af776cf-eb46-482b-9d05-c9b0abce9488';
  const scopes = 'offline_access user.read Mail.Send Calendars.Read Notes.Create';
  const url = 'http://localhost:8081/oauth/microsoft/login';
  return (
    <a
      className={'card-service-container service-glass'}
      href={`https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=${clientId}&response_type=code&scope=${scopes}&response_mode=query&redirect_uri=${url}`}
    >
      <div className={'card-service'}>
        <div className={'card-service-name'}>
          <img className={'card-service-icon'} src={MicrosoftIcon} alt={'Microsoft icon'} />
          <p>Se connecter à Microsoft</p>
        </div>
      </div>
    </a>
  );
};

export default MicrosoftOauthBtn;
