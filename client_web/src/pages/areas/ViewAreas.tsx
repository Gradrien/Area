import { FunctionComponent, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import Loading from '../../components/utils/Loading';
import './editArea.css';
import { useDispatch, useSelector } from 'react-redux';
import { setCreatedArea, setCurrentAction, setCurrentArea } from '../../redux/actions/areaAction';
import { getCurrentArea } from '../../redux/selector';
import PrimaryButton from '../../components/ux/PrimaryButton';
import apiService from '../../services/api/ApiService';
import { ConfigurationForm } from './EditAreas';
import './viewAreas.css';

enum CopyState {
  NOT_AVAILABLE = 1,
  AVAILABLE,
  COPY_LOAD,
  COPIED,
}

const ViewAreas: FunctionComponent = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [load, setLoad] = useState<boolean>(true);
  const dispatch = useDispatch();
  const currentArea = useSelector(getCurrentArea);
  const [copyState, setCopyState] = useState<CopyState>(CopyState.NOT_AVAILABLE);

  useEffect(() => {
    if (!id || !/^[0-9]+$/.test(id)) {
      console.log('id pas conforme');
      navigate('/');
      return;
    }
    apiService.getPublicAreaDataById(Number(id)).then(data => {
      if (!data) {
        console.log('pas data');
        navigate('/');
        return;
      }
      console.log(data);
      setCopyState(CopyState.AVAILABLE);
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

  const renderCopyButton = () => {
    if (currentArea === null) return null;

    switch (copyState) {
      case CopyState.NOT_AVAILABLE:
        return null;
      case CopyState.AVAILABLE:
        return (
          <PrimaryButton
            title={'Copier cette Area'}
            action={() => {
              setCopyState(CopyState.COPY_LOAD);
              apiService.copyArea(currentArea.id).then(data => {
                if (data) {
                  setCopyState(CopyState.COPIED);
                }
              });
            }}
          />
        );
      case CopyState.COPY_LOAD:
        return (
          <div className='small-loader-container'>
            <span className='small loader'></span>
          </div>
        );
      case CopyState.COPIED:
        return <div className='area-copied'>Area copiée avec succès !</div>;
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
            <h3 className='h3' style={{ marginTop: 0 }}>
              {currentArea.name}
            </h3>
          </div>
          {renderCopyButton()}
        </div>
        <div className={'forms-container'}>
          <ConfigurationForm type='Action' editable={false} />
          <ConfigurationForm type='Reaction' editable={false} />
        </div>
      </div>
    </main>
  );
};

export default ViewAreas;
