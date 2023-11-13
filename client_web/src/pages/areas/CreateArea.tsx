import { FunctionComponent, useEffect, useState } from 'react';
import DotMarker from './components/DotMarker';
import './createAreas.css';
import ChooseAction from './creationFlow/ChooseAction';
import ChooseReaction from './creationFlow/ChooseReaction';
import { ServiceDetail } from '../../types/types';
import apiService from '../../services/api/ApiService';
import Loading from '../../components/utils/Loading';
import { useSelector } from 'react-redux';
import { getCreatedArea, getUser } from '../../redux/selector';
import ConfigureArea from './creationFlow/ConfigureArea';
import Finished from './creationFlow/Finished';

const CreateArea: FunctionComponent = () => {
  const [steps, setSteps] = useState<number>(0);
  const [services, setServices] = useState<ServiceDetail[]>([]);
  const [loaded, setLoaded] = useState<boolean>(false);
  const createdArea = useSelector(getCreatedArea);
  const [firstArea, setFirstArea] = useState<boolean>(false);
  const user = useSelector(getUser);

  useEffect(() => {
    console.log(createdArea);
  }, [createdArea]);

  useEffect(() => {
    if (user?.first_area === true) {
      setFirstArea(true);
    }
  }, []);

  const goNextStep = () => {
    setSteps(steps + 1);
  };

  const flows = [
    <ChooseAction services={services} next={goNextStep} firstArea={firstArea} onDeny={() => setFirstArea(false)} />,
    <ChooseReaction services={services} next={goNextStep} firstArea={firstArea} onDeny={() => setFirstArea(false)} />,
    // <ChooseName next={goNextStep} />,
    <ConfigureArea next={goNextStep} firstArea={firstArea} onDeny={() => setFirstArea(false)} />,
    <Finished />,
  ];

  useEffect(() => {
    apiService.getAllUserServices().then(data => {
      if (!data) return;
      console.log(data);
      setServices(data);
      setLoaded(true);
    });
  }, []);

  if (!loaded) return <Loading />;

  return (
    <main className='main-app creation-container'>
      <h1 className='h1'>Nouvelle Area</h1>
      <div className='creation-flow-container glass'>{flows[steps]}</div>
      <div className='dot-markers'>
        {[...Array(4)].map((_, index) => {
          return <DotMarker key={`dot_${index}`} isFilled={index <= steps} />;
        })}
      </div>
    </main>
  );
};

export default CreateArea;
