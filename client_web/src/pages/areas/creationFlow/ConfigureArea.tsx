import { FunctionComponent, useEffect, useState } from 'react';
import apiService from '../../../services/api/ApiService';
import { useDispatch, useSelector } from 'react-redux';
import { getCreatedArea, getCurrentArea } from '../../../redux/selector';
import { setCurrentArea } from '../../../redux/actions/areaAction';
import Loading from '../../../components/utils/Loading';
import { ConfigurationForm } from '../EditAreas';
import nextIcon from '../../../assets/svg/next.svg';
import infoIcon from '../../../assets/svg/info.svg';
import HelperModale from '../components/HelperModale';

const ConfigureArea: FunctionComponent<{ next: () => void; firstArea: boolean; onDeny: () => void }> = ({
  next,
  firstArea,
  onDeny,
}) => {
  const [loaded, setLoaded] = useState<boolean>(false);
  const createdArea = useSelector(getCreatedArea);
  const dispatch = useDispatch();
  const currentArea = useSelector(getCurrentArea);
  const [isError, setError] = useState<string>('');
  const [showHelp, setShowHelp] = useState<boolean>(firstArea);

  useEffect(() => {
    if (!createdArea) return;
    apiService.createArea(createdArea).then(data => {
      if (!data) return;
      data.active = true;
      dispatch(setCurrentArea(data));
      setLoaded(true);
    });
  }, []);

  if (!loaded) return <Loading />;

  if (!currentArea) return null;

  return (
    <>
      <h3 className='h3'>Configurer son Area</h3>
      <img src={infoIcon} alt={'info'} className={`info-icon`} onClick={() => setShowHelp(!showHelp)}></img>
      {showHelp && (
        <HelperModale onClick={() => setShowHelp(false)} onDeny={onDeny}>
          <p>
            Ici vous pouvez choisir les paramètres de votre Area.
            <br />
            Dans un premier temps vous pouvez choisir le nom de votre Area ainsi que la fréquence à laquelle l'Area sera
            vérifiée.
            <br />
            Ensuite vous pouvez configurer plus spécifiquement votre action et votre réaction, pour votre réaction vous
            pouvez utiliser les variables disponibles selon l'action que vous avez sélectionné.
          </p>
        </HelperModale>
      )}
      <div className='creation-config-container'>
        <div className='area-edition-param-container'>
          <div className='config-form-field full-width'>
            <label>Nom de l'Area</label>
            <input
              className='glass'
              type='text'
              onChange={ev =>
                dispatch(
                  setCurrentArea({
                    ...currentArea,
                    name: ev.currentTarget.value,
                  }),
                )
              }
            />
          </div>
          <p className={'full-width'}>
            <span>Actualisation toutes les </span>
            <input
              className='number-input glass'
              type='number'
              value={currentArea.refresh}
              min={1}
              max={200}
              onChange={ev =>
                dispatch(
                  setCurrentArea({
                    ...currentArea,
                    refresh: Number(ev.currentTarget.value),
                  }),
                )
              }
            />
            <span> min</span>
          </p>
        </div>
        <ConfigurationForm type='Action' />
        <ConfigurationForm type='Reaction' />
      </div>
      {isError !== '' && <span className={'error-message'}>{isError}</span>}
      <img
        className={'next-step-icon'}
        src={nextIcon}
        alt='Go next step'
        onClick={async () => {
          if (!currentArea?.id) return;

          let res = await apiService.updateAreaById(currentArea, currentArea.id);
          if (res !== true) {
            setError(res.message);
            return;
          }
          await apiService.startArea(currentArea.id);
          dispatch(setCurrentArea(null));
          next();
        }}
      />
    </>
  );
};

export default ConfigureArea;
