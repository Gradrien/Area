import { getUser } from '../redux/selector';
import { Area, User } from '../types/types';
import { useSelector } from 'react-redux';
import Card from '../components/Card';
import { useEffect, useState } from 'react';
import apiService from '../services/api/ApiService';
import Loading from '../components/utils/Loading';
import './homePage.css';
import { useNavigate } from 'react-router-dom';

const HomePage = () => {
  const user: User | null = useSelector(getUser);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [areas, setAreas] = useState<Area[]>([]);
  const navigate = useNavigate();

  useEffect(() => {
    apiService.getAreas().then(data => {
      if (!data) {
        return;
      }
      setAreas(data);
      setIsLoading(false);
    });
  }, []);

  if (isLoading) {
    return <Loading />;
  }

  return (
    <main className='main-app'>
      <h1 className='h1'>{user ? `Bienvenue ${user.name}` : ''}</h1>
      <h2 className='h2'>Mes Areas</h2>
      <div className={'grid-container'}>
        <section className='card-container'>
          {areas.map((card, index) => (
            <div key={`card_${index}`} className='grid-item'>
              <Card
                title={card.name}
                active={card.active}
                id={card.id}
                actionName={card.action_name}
                reactionName={card.reaction_name}
                actionImg={card.action_icon}
                reactionImg={card.reaction_icon}
                mode={'private'}
              />
            </div>
          ))}
          <div className='card glass no-area' onClick={() => navigate('/areas/create')}>
            <span>{!areas.length ? 'Créer ma première area' : 'Créer une nouvelle area'}</span>
            <svg width='20' height='20' viewBox='0 0 20 20' fill='none' xmlns='http://www.w3.org/2000/svg'>
              <path
                d='M10 0C10.3315 0 10.6495 0.131696 10.8839 0.366117C11.1183 0.600537 11.25 0.918479 11.25 1.25V8.75H18.75C19.0815 8.75 19.3995 8.8817 19.6339 9.11612C19.8683 9.35054 20 9.66848 20 10C20 10.3315 19.8683 10.6495 19.6339 10.8839C19.3995 11.1183 19.0815 11.25 18.75 11.25H11.25V18.75C11.25 19.0815 11.1183 19.3995 10.8839 19.6339C10.6495 19.8683 10.3315 20 10 20C9.66848 20 9.35054 19.8683 9.11612 19.6339C8.8817 19.3995 8.75 19.0815 8.75 18.75V11.25H1.25C0.918479 11.25 0.600537 11.1183 0.366117 10.8839C0.131696 10.6495 0 10.3315 0 10C0 9.66848 0.131696 9.35054 0.366117 9.11612C0.600537 8.8817 0.918479 8.75 1.25 8.75H8.75V1.25C8.75 0.918479 8.8817 0.600537 9.11612 0.366117C9.35054 0.131696 9.66848 0 10 0Z'
                fill='#959595'
              />
            </svg>
          </div>
        </section>
      </div>
    </main>
  );
};

export default HomePage;
