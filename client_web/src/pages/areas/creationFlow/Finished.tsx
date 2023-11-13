import { FunctionComponent, useEffect } from 'react';
import checked from '../../../assets/svg/checked.svg';
import nextIcon from '../../../assets/svg/next.svg';
import { useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { setCurrentAction, setCurrentArea } from '../../../redux/actions/areaAction';
import { setUser } from '../../../redux/actions/userAction';
import { getUser } from '../../../redux/selector';

const Finished: FunctionComponent = () => {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const user = useSelector(getUser);

  useEffect(() => {
    dispatch(setCurrentArea(null));
    dispatch(setCurrentAction(null));
    if (user !== null) dispatch(setUser({ ...user, first_area: false }));
  }, []);

  return (
    <>
      <div className='success-container'>
        <img src={checked} alt='success' />
      </div>
      <img
        className={'next-step-icon'}
        src={nextIcon}
        alt='Go next step'
        onClick={async () => {
          navigate('/');
        }}
      />
    </>
  );
};

export default Finished;
