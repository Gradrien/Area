import { ChangeEvent, FunctionComponent, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import Loading from '../../components/utils/Loading';
import AreaEditionForm from './components/AreaEditionForm';
import ToggleSwitch from '../../components/ux/toggleSwitch';
import './editArea.css';
import { useDispatch, useSelector } from 'react-redux';
import { setCreatedArea, setCurrentAction, setCurrentArea } from '../../redux/actions/areaAction';
import { getCurrentArea } from '../../redux/selector';
import { AreaEditionProps } from '../../types/types';
import PrimaryButton from '../../components/ux/PrimaryButton';
import SecondaryButton from '../../components/ux/SecondaryButton';
import apiService from '../../services/api/ApiService';

enum PublicationState {
  NOT_PUBLIC = 1,
  IN_PUBLICATION,
  PUBLISHED,
  PUBLIC,
}

export const ConfigurationForm: FunctionComponent<AreaEditionProps> = ({ type, editable = true }) => {
  const [visible, setVisible] = useState<boolean>(false);
  return (
    <div className={`glass configuration-form ${visible ? '' : 'hidden'} ${type === 'Action' ? 'action' : 'reaction'}`}>
      <div className='edition-form-header' onClick={() => setVisible(!visible)}>
        <h3 className='h3'>{type === 'Action' ? 'Action' : 'Réaction'}</h3>
        <svg
          className='edition-form-arrow'
          width='24'
          height='24'
          fill='#2D2D2D'
          viewBox='0 0 24 24'
          xmlns='http://www.w3.org/2000/svg'
        >
          <path d='M16.488 13.383 9.91 19.138c-.776.68-1.99.128-1.99-.903V6.725a1.2 1.2 0 0 1 1.99-.904l6.577 5.755a1.2 1.2 0 0 1 0 1.807Z'></path>
        </svg>
      </div>
      <div className='edition-form-container'>
        <AreaEditionForm type={type} editable={editable} />
      </div>
    </div>
  );
};

const EditAreas: FunctionComponent = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [load, setLoad] = useState<boolean>(true);
  const dispatch = useDispatch();
  const currentArea = useSelector(getCurrentArea);
  const [error, setError] = useState<string>('');
  const [publicationState, setPublicationState] = useState<PublicationState>(PublicationState.NOT_PUBLIC);
  const [showConfirmation, setShowConfirmation] = useState<boolean>(false);
  const [confirmationText, setConfirmationText] = useState<string>('');

  const onActiveChange = (ev: ChangeEvent<HTMLInputElement>) => {
    console.log('onActiveChange');
    if (!currentArea) return;
    dispatch(
      setCurrentArea({
        ...currentArea,
        active: ev.currentTarget.checked,
      }),
    );
  };

  useEffect(() => {
    if (!id || !/^[0-9]+$/.test(id)) {
      console.log('id pas conforme');
      navigate('/');
      return;
    }
    apiService.getAreaDataById(Number(id)).then(data => {
      if (!data) {
        console.log('pas data');
        navigate('/');
        return;
      }
      console.log(data);
      if (data.public) setPublicationState(PublicationState.PUBLIC);
      dispatch(setCurrentArea(data));
      dispatch(
        setCurrentAction({
          id: 0,
          return_params: data.action_params,
          name: data.name,
          service_id: 0,
          default_config: {},
          api_endpoint: '',
        }),
      );
      setLoad(false);
    });
    return () => {
      dispatch(setCreatedArea(null));
      dispatch(setCurrentAction(null));
    };
  }, [id]);

  const getPublicationButton = () => {
    if (currentArea === null) return null;

    switch (publicationState) {
      case PublicationState.NOT_PUBLIC:
        return (
          <PrimaryButton
            title={'Publier cette Area'}
            action={() => {
              setPublicationState(PublicationState.IN_PUBLICATION);
              apiService.publishArea(currentArea.id).then(data => {
                if (!data) {
                  setError('Une erreur est survenue lors de la publication de votre area');
                  dispatch(
                    setCurrentArea({
                      ...currentArea,
                      public: false,
                    }),
                  );
                  setPublicationState(PublicationState.NOT_PUBLIC);
                } else {
                  dispatch(
                    setCurrentArea({
                      ...currentArea,
                      public: true,
                    }),
                  );
                  setPublicationState(PublicationState.PUBLISHED);
                }
              });
            }}
          />
        );
      case PublicationState.IN_PUBLICATION:
        return (
          <div className='small-loader-container'>
            <span className='small loader'></span>
          </div>
        );
      case PublicationState.PUBLISHED:
        return <div className='area-copied'>Area publiée avec succès !</div>;
      case PublicationState.PUBLIC:
        return (
          <div
            className='area-public'
            onClick={() => {
              setPublicationState(PublicationState.IN_PUBLICATION);
              apiService.unpublishArea(currentArea.id).then(data => {
                if (!data) {
                  setError('Une erreur est survenue lors de la dépublication de votre area');
                  dispatch(
                    setCurrentArea({
                      ...currentArea,
                      public: true,
                    }),
                  );
                  setPublicationState(PublicationState.NOT_PUBLIC);
                } else {
                  dispatch(
                    setCurrentArea({
                      ...currentArea,
                      public: false,
                    }),
                  );
                  setPublicationState(PublicationState.NOT_PUBLIC);
                }
              });
            }}
          >
            Dépublier cette Area
          </div>
        );
    }
  };

  if (load) return <Loading />;

  if (!currentArea) {
    return (
      <>
        <p>Aucune area avec l'id {id} n'existe</p>
      </>
    );
  }

  return (
    <main className='main-app'>
      <h1 className='h1'>Edition de votre Area</h1>
      <div className={'area-edition'}>
        <div className='glass area-edition-container'>
          <div className='edition-form-header area-name'>
            <input
              className='glass area-name-edit'
              type={'text'}
              value={currentArea.name}
              // readOnly={!editable}
              onChange={ev => dispatch(setCurrentArea({ ...currentArea, name: ev.currentTarget.value }))}
            />
          </div>
          <div className='area-edition-param-container row'>
            <p>Activer/désactiver</p>
            <ToggleSwitch data={currentArea.active} dataFiler={onActiveChange} id={'active'} />
          </div>
          <div className='area-edition-param-container row'>
            <p>
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
                      refresh: Number(ev.currentTarget.value) > 1 ? Number(ev.currentTarget.value) : 1,
                    }),
                  )
                }
              />
              <span> min</span>
            </p>
          </div>
          <div className='area-edition-param-container row'>{getPublicationButton()}</div>
        </div>
        <div className={'forms-container'}>
          <ConfigurationForm type='Action' />
          <ConfigurationForm type='Reaction' />
        </div>
      </div>
      <p className='update-error-message'>{error}</p>
      <div className='validation-container'>
        <SecondaryButton title={'Annuler'} action={() => navigate('/')} />
        <PrimaryButton
          title={'Valider'}
          action={() =>
            apiService
              .updateAreaById(currentArea, Number(id))
              .then(data => (data === true ? navigate('/') : setError(data.message)))
          }
        />
      </div>
      <div className='danger-zone'>
        <h3>Zone de danger</h3>
        {showConfirmation && (
          <>
            <label>Pour confirmer la suppressions entrez le nom de votre Area :</label>
            <input className={'glass'} onChange={event => setConfirmationText(event.target.value)} />
          </>
        )}
        <button
          className='button-secondary red'
          onClick={async ev => {
            ev.preventDefault();
            if (!showConfirmation) setShowConfirmation(true);
            else if (currentArea.name === confirmationText) {
              await apiService.deleteArea(currentArea?.id);
              navigate('/');
            }
          }}
        >
          Supprimer
        </button>
      </div>
    </main>
  );
};

export default EditAreas;
