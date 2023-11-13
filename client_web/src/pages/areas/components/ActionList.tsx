import { FunctionComponent, useEffect, useState } from 'react';
import { Action, Reaction, ServiceDetail } from '../../../types/types';
import './actionList.css';
import { useDispatch, useSelector } from 'react-redux';
import { getCreatedArea } from '../../../redux/selector';
import { setCreatedArea, setCurrentAction } from '../../../redux/actions/areaAction';

const ActionReactionCard: FunctionComponent<{
  data: Action | Reaction;
  icon: string;
  onClick: () => void;
  selected: boolean;
}> = ({ data, icon, onClick, selected }) => {
  return (
    <div className={`service-card ${selected ? 'selected' : ''}`} onClick={onClick}>
      <img src={icon} alt='service icon' className={'service-icon'} />
      <h5>{data.name}</h5>
    </div>
  );
};

const ActionReactionList: FunctionComponent<{
  service: ServiceDetail;
  type: 'actions' | 'reactions';
  canSelect: boolean;
  onClick: () => void;
}> = ({ service, type, canSelect, onClick }) => {
  const [selected, setSelected] = useState<number>(-1);
  const dispatch = useDispatch();
  const createdArea = useSelector(getCreatedArea);

  const updateCreatedArea = () => {
    if (type === 'actions') {
      dispatch(
        setCreatedArea({
          name: '',
          action_id: selected,
          reaction_id: -1,
          refresh: 1,
        }),
      );
      return;
    }
    if (!createdArea) return;
    dispatch(
      setCreatedArea({
        ...createdArea,
        reaction_id: selected,
      }),
    );
  };

  useEffect(() => {
    updateCreatedArea();
  }, [selected]);

  return (
    <>
      <h4 className={'h4'}>{service.name}</h4>
      <div className='service-card-list' onClick={onClick}>
        {service[type].map((el, index) => {
          return (
            <ActionReactionCard
              key={`card_${index}`}
              data={el}
              icon={service.service_icon}
              onClick={() => {
                if (type === 'actions') dispatch(setCurrentAction(el as Action));
                setSelected(el.id);
              }}
              selected={canSelect && selected === el.id}
            />
          );
        })}
      </div>
    </>
  );
};

export default ActionReactionList;
