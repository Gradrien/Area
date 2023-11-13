import { FunctionComponent, useEffect, useState } from 'react';
import { PublicArea, ServiceDetail } from '../../types/types';
import apiService from '../../services/api/ApiService';
import Loading from '../../components/utils/Loading';
import Card from '../../components/Card';
import './publicAreas.css';

const PublicAreas: FunctionComponent = () => {
  const [isLoadingPublic, setIsLoadingPublic] = useState<boolean>(true);
  const [isLoadingService, setIsLoadingService] = useState<boolean>(true);
  const [areas, setAreas] = useState<PublicArea[]>([]);
  const [services, setServices] = useState<ServiceDetail[]>([]);

  const [areaSearch, setAreaSearch] = useState<string>('');
  const [searchByService, setSearchByService] = useState('');

  useEffect(() => {
    apiService.getAllUserServices().then(data => {
      if (!data) return;
      setServices(data);
      setIsLoadingService(false);
    });
    apiService.getPublicAreas().then(data => {
      if (!data) {
        return;
      }
      console.log(data);
      setAreas(data);
      setIsLoadingPublic(false);
    });
  }, []);

  const getLastedAdded = (): PublicArea[] => {
    return areas.slice(0, 3);
  };
  const filterAreas = (): PublicArea[] => {
    let result: PublicArea[] = [];
    if (searchByService === '') result = areas;
    else
      result = areas.filter(
        area => area.action_icon.includes(searchByService) || area.reaction_icon.includes(searchByService),
      );
    if (areaSearch.length === 0) {
      return result;
    }
    return result.filter(area => area.name.toLowerCase().includes(areaSearch.toLowerCase()));
  };

  if (isLoadingPublic || isLoadingService) {
    return <Loading />;
  }

  return (
    <main className='main-app marketplace'>
      <div className='marketplace-hero'>
        <h1 className='h1'>Areas de la communauté</h1>
        <h3>Découvrez les areas des utilisateurs</h3>
        <div className={'filter-container'}>
          <input
            className={'glass searchbar'}
            placeholder={'Recherchez une area'}
            onChange={ev => setAreaSearch(ev.target.value)}
          />
          <a href='#allAdded'>
            <svg width='24' height='24' fill='#fafafd' viewBox='0 0 24 24' xmlns='http://www.w3.org/2000/svg'>
              <path d='M16.97 14.332a7.8 7.8 0 1 0-1.676 1.678h-.001c.036.048.074.094.117.138l4.62 4.62a1.2 1.2 0 0 0 1.698-1.697l-4.62-4.62a1.201 1.201 0 0 0-.138-.12v.001Zm.31-4.612a6.6 6.6 0 1 1-13.2 0 6.6 6.6 0 0 1 13.2 0Z'></path>
            </svg>
          </a>
        </div>
        <ul className='marketplace-service-container'>
          {services.map((ser, index) => (
            <a href='#allAdded'>
              <li
                key={`serv_${index}`}
                onClick={() => {
                  if (searchByService === ser.name) {
                    setSearchByService('');
                    return;
                  }
                  setSearchByService(ser.name);
                }}
              >
                <div className={`marketplace-service ${searchByService === ser.name ? 'active' : ''}`}>
                  <img src={ser.service_icon} alt={`icon_${ser.name}`} />
                </div>
              </li>
            </a>
          ))}
        </ul>
      </div>
      <section className='last-added'>
        <div className='content-limiter'>
          <h2 className='marketplace-h2'>Derniers ajouts</h2>
          <div className='card-container marketplace last'>
            {getLastedAdded().length === 0 ? (
              <p>Aucune Area à afficher pour le moment</p>
            ) : (
              getLastedAdded().map((card, index) => (
                <div key={`card_lats_${index}`} className='grid-item'>
                  <Card
                    title={card.name}
                    active={card.active}
                    id={card.id}
                    actionName={card.action_name}
                    reactionName={card.reaction_name}
                    actionImg={card.action_icon}
                    reactionImg={card.reaction_icon}
                    available={card.is_available}
                    mode={'public'}
                  />
                </div>
              ))
            )}
          </div>
        </div>
      </section>
      <section id='allAdded' className='all-added'>
        <div className='content-limiter'>
          <h2 className='marketplace-h2'>Les Areas de la communauté</h2>
          <div className='card-container marketplace'>
            {filterAreas().length === 0 ? (
              <p>Aucune Area à afficher pour le moment</p>
            ) : (
              filterAreas().map((card, index) => (
                <div key={`card_${index}`} className='grid-item'>
                  <Card
                    title={card.name}
                    active={card.active}
                    id={card.id}
                    actionName={card.action_name}
                    reactionName={card.reaction_name}
                    actionImg={card.action_icon}
                    reactionImg={card.reaction_icon}
                    available={card.is_available}
                    mode={'public'}
                  />
                </div>
              ))
            )}
          </div>
        </div>
      </section>
    </main>
  );
};

export default PublicAreas;
