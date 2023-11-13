import { Fragment, FunctionComponent, JSX, useEffect, useState } from 'react';
import Loading from '../utils/Loading';
import apiService from '../../services/api/ApiService';
import { Service } from '../../types/types';
import './cardService.css';
import connectedIcon from '../../assets/svg/connectedIcon.svg';
import MicrosoftOauthBtn from '../authentication/MicrosoftOauthBtn';
import SpotifyOauthBtn from '../authentication/SpotifyOauthBtn';
import GoogleServiceOauthBtn from '../authentication/GoogleServiceOauthBtn';
import GitLabOauthBtn from '../authentication/GitLabOauthBtn';

const CardService: FunctionComponent = () => {
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [servicesList, setServicesList] = useState<Service[]>([]);

  const authBtns = [
    {
      name: 'Microsoft',
      btn: <MicrosoftOauthBtn key={'microsoft_auth_bnt'} />,
    },
    { name: 'Spotify', btn: <SpotifyOauthBtn key={'spotify_auth_bnt'} /> },
    { name: 'Google', btn: <GoogleServiceOauthBtn key={'google_auth_bnt'} /> },
    { name: 'GitLab', btn: <GitLabOauthBtn key={'gitlab_auth_bnt'} /> },
    // {
    //   name: 'Bordeaux Métropole',
    //   btn: <BdxServiceBtn key={'gitlab_auth_bnt'} />,
    // },
  ];

  const getAuthBtn = (serviceName: string): JSX.Element => {
    let $btn:
      | {
          name: string;
          btn: JSX.Element;
        }
      | undefined = authBtns.find(authBtn => authBtn.name === serviceName);

    if ($btn === undefined) {
      return <></>;
    }
    return $btn.btn;
  };

  const deleteService = ($service: Service) => {
    apiService.deleteService($service.id);
    $service.is_enabled = false;
    setServicesList([...servicesList]);
  };

  useEffect(() => {
    apiService.getServicesForUser().then(res => {
      setServicesList(res);
      setIsLoading(true);
    });
  }, []);

  if (!isLoading) {
    return <Loading />;
  }
  return (
    <div className={'profile-service'}>
      <h2 className={'h2 service-title'}>Mes services</h2>
      <div className='card-profile-container glass'>
        {servicesList.map((service, index) => (
          <Fragment key={index}>
            {service.is_enabled ? (
              <div
                key={`card_service_${index}`}
                className={`${service.no_auth ? 'no-hover' : ''} card-service-container service-glass connected`}
              >
                <div className={'card-service'}>
                  <div className={'card-service-name'}>
                    <img className={'card-service-icon'} src={service.service_icon} alt={service.name} />
                    <p>Connecté</p>
                  </div>
                  <img src={connectedIcon} className={'connect-img'} alt={'Connected'} />
                  {service.no_auth ? (
                    <img src={connectedIcon} className={'disconnect-img'} alt={'Disconnect'} />
                  ) : (
                    <div
                      className={'disconnect-link'}
                      onClick={service.no_auth ? undefined : () => deleteService(service)}
                    >
                      Se déconnecter
                    </div>
                  )}
                </div>
              </div>
            ) : (
              getAuthBtn(service.name)
            )}
          </Fragment>
        ))}
        <span className='warning-text'>
          Attention ! Si vous vous déconnectez d'un service, cela supprimera l'ensemble des Areas liées à ce service.
        </span>
      </div>
    </div>
  );
};

export default CardService;
