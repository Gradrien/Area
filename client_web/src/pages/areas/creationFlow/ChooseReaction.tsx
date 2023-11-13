import { FunctionComponent, useState } from 'react';
import { ServiceDetail } from '../../../types/types';
import ActionList from '../components/ActionList';
import nextIcon from '../../../assets/svg/next.svg';
import { useSelector } from 'react-redux';
import { getCreatedArea } from '../../../redux/selector';
import infoIcon from '../../../assets/svg/info.svg';
import HelperModale from '../components/HelperModale';

const ChooseReaction: FunctionComponent<{
  services: ServiceDetail[];
  next: () => void;
  firstArea: boolean;
  onDeny: () => void;
}> = ({ services, next, firstArea, onDeny }) => {
  const createdArea = useSelector(getCreatedArea);
  const [isError, setError] = useState<boolean>(false);
  const [serviceSelected, setServiceSelected] = useState<number>(-1);
  const [showHelp, setShowHelp] = useState<boolean>(firstArea);

  return (
    <>
      <h3 className='h3'>Choisir une reaction</h3>
      <img src={infoIcon} alt={'info'} className={`info-icon`} onClick={() => setShowHelp(!showHelp)}></img>
      {showHelp && (
        <HelperModale onClick={() => setShowHelp(false)} onDeny={onDeny}>
          <p>
            Ici vous pouvez choisir la seconde partie de votre Area : la réaction.
            <br />
            La réaction est exécutée quand l'action est considérée comme remplie.
            <br />
            Les réactions qui vous sont proposées sont uniquement celles liées aux services pour lesquels vous êtes
            authentifiés.
          </p>
        </HelperModale>
      )}
      <div className='service-container'>
        {services.map((service, index) => {
          if (!service.reactions.length || service.is_enabled === false) return null;
          return (
            <ActionList
              key={`react_${index}`}
              service={service}
              type='reactions'
              canSelect={serviceSelected === service.id}
              onClick={() => setServiceSelected(service.id)}
            />
          );
        })}
      </div>
      {isError && <span className={'error-message'}>Veuillez choisir une réaction</span>}
      <img
        className={'next-step-icon'}
        src={nextIcon}
        alt='Go next step'
        onClick={() => {
          if (createdArea?.reaction_id === -1) {
            setError(true);
            return;
          }
          next();
        }}
      />
    </>
  );
};

export default ChooseReaction;
