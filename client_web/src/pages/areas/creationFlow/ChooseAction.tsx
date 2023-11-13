import { FunctionComponent, useState } from 'react';
import { ServiceDetail } from '../../../types/types';
import ActionList from '../components/ActionList';
import nextIcon from '../../../assets/svg/next.svg';
import { useSelector } from 'react-redux';
import { getCreatedArea } from '../../../redux/selector';
import infoIcon from '../../../assets/svg/info.svg';
import HelperModale from '../components/HelperModale';

const ChooseAction: FunctionComponent<{
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
      <h3 className='h3'>Choisir une action</h3>
      <img src={infoIcon} alt={'info'} className={`info-icon`} onClick={() => setShowHelp(!showHelp)}></img>
      {showHelp && (
        <HelperModale onClick={() => setShowHelp(false)} onDeny={onDeny}>
          <p>
            Ici vous pouvez choisir la première partie de votre Area : l'action.
            <br />
            L'action est l'élément déclencheur de votre Area.
            <br />
            Les actions qui vous sont proposées sont uniquement celles liées aux services pour lesquels vous êtes
            authentifiés.
          </p>
        </HelperModale>
      )}
      <div className='service-container'>
        {services.map((service, index) => {
          if (!service.actions.length || !service.is_enabled) return null;
          return (
            <ActionList
              key={`action_${index}`}
              service={service}
              type='actions'
              canSelect={serviceSelected === service.id}
              onClick={() => setServiceSelected(service.id)}
            />
          );
        })}
      </div>
      {isError && <span className={'error-message'}>Veuillez choisir une action</span>}
      <img
        className={'next-step-icon'}
        src={nextIcon}
        alt='Go next step'
        onClick={() => {
          if (createdArea?.action_id === -1) {
            setError(true);
            return;
          }
          next();
        }}
      />
    </>
  );
};

export default ChooseAction;
