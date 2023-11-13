import { FunctionComponent } from 'react';
import SpotifyIcon from '../../assets/svg/spotifyIcon.svg';
import './MicrosoftOauthBtn.css';

const SpotifyOauthBtn: FunctionComponent = () => {
  const clientId = '5969846fad854c389a5dacf14cdc5893';
  const scopes = 'user-read-private user-follow-modify user-modify-playback-state user-read-playback-state';
  const url = 'http://localhost:8081/oauth/spotify/login';
  return (
    <a
      className={'card-service-container service-glass'}
      href={`https://accounts.spotify.com/authorize?response_type=code&client_id=${clientId}&scope=${scopes}&redirect_uri=${url}`}
    >
      <div className={'card-service'}>
        <div className={'card-service-name'}>
          <img className={'card-service-icon'} src={SpotifyIcon} alt={'Spotify icon'} />
          <p>Se connecter à Spotify</p>
        </div>
      </div>
    </a>
  );
};

export default SpotifyOauthBtn;
