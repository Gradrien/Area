import { FunctionComponent, MouseEvent, useEffect, useState } from 'react';
import Loading from '../components/utils/Loading';
import { getUser } from '../redux/selector';
import { User } from '../types/types';
import { useDispatch, useSelector } from 'react-redux';
import './profilePage.css';
import disconnectIcon from '../assets/svg/disconnect.svg';
import CardProfile from '../components/profile/CardProfile';
import apiService from '../services/api/ApiService';
import { setUser } from '../redux/actions/userAction';
import { useNavigate } from 'react-router-dom';
import CardService from '../components/profile/CardService';

const ProfilePage: FunctionComponent = () => {
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const user: User | null = useSelector(getUser);

  const handleDisconnect = async (event: MouseEvent<HTMLElement>) => {
    event.preventDefault();
    console.log('disconnect me please :(');
    const disconnected: boolean = await apiService.logout();
    console.log('disconnected', disconnected);
    if (disconnected) {
      dispatch(setUser(null));
      navigate('/login');
    }
  };

  useEffect(() => {
    setIsLoading(true);
  }, []);

  if (!isLoading) {
    return <Loading />;
  }
  return (
    <main className='main-app'>
      <div className={'profile-container'}>
        <div className={'title-profile-container'}>
          <h1 className='h1'>Mon profil</h1>
          <img className={'disconnect-icon'} src={disconnectIcon} alt={disconnectIcon} onClick={handleDisconnect} />
        </div>
        <div className={'profile-data__container'}>
          <div className={'profile-data__container--personnal'}>
            <h2 className='h2'>Mes informations</h2>
            <CardProfile name={user ? user.name : ''} email={user ? user.email : ''} />
          </div>
          <CardService />
        </div>
      </div>
    </main>
  );
};

export default ProfilePage;
