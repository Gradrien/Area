import { FunctionComponent, useEffect, useState } from 'react';
import nextIcon from '../../../assets/svg/next.svg';
import { useDispatch, useSelector } from 'react-redux';
import { getCreatedArea } from '../../../redux/selector';
import { setCreatedArea } from '../../../redux/actions/areaAction';

const ChooseName: FunctionComponent<{ next: () => void }> = ({ next }) => {
  const [name, setName] = useState<string>('');
  const createdArea = useSelector(getCreatedArea);
  const dispatch = useDispatch();
  const [isError, setError] = useState<boolean>(false);

  useEffect(() => {
    if (!createdArea) return;
    dispatch(
      setCreatedArea({
        ...createdArea,
        name: name,
      }),
    );
  }, [name]);

  return (
    <>
      <h3 className='h3' style={{ marginBottom: '1rem' }}>
        Choisir un nom
      </h3>
      <div className='config-form-field'>
        <label>Nom</label>
        <input
          className='glass'
          type='text'
          max={200}
          value={name}
          onChange={ev => setName(ev.currentTarget.value)}
          placeholder="Nom de l'area"
        />
      </div>
      {isError && <span className={'error-message'}>Veuillez choisir un nom pour votre Area</span>}
      <img
        className={'next-step-icon'}
        src={nextIcon}
        alt='Go next step'
        onClick={() => {
          if (createdArea?.name === '') {
            setError(true);
            return;
          }
          next();
        }}
      />
    </>
  );
};

export default ChooseName;
