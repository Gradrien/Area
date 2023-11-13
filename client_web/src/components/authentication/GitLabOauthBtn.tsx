import { FunctionComponent } from 'react';
import GitLabIcon from '../../assets/svg/GitLab.svg';
import './MicrosoftOauthBtn.css';

const GitLabOauthBtn: FunctionComponent = () => {
  const clientId = '94fafb7cd60fe46cbd6770025faac5e67f220e38da5fd7bd33911e8abe514a02';
  const scopes = 'read_repository write_repository api';
  const url = 'http://localhost:8081/oauth/gitlab/login';
  return (
    <a
      className={'card-service-container service-glass'}
      href={`https://gitlab.com/oauth/authorize?response_type=code&client_id=${clientId}&scope=${scopes}&redirect_uri=${url}`}
    >
      <div className={'card-service'}>
        <div className={'card-service-name'}>
          <img className={'card-service-icon'} src={GitLabIcon} alt={'Gitlab icon'} />
          <p>Se connecter à GitLab</p>
        </div>
      </div>
    </a>
  );
};

export default GitLabOauthBtn;
