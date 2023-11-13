import React, { FunctionComponent } from 'react';
import './infoModale.css';
import exitSvg from '../../../assets/svg/exit.svg';
import { Action } from '../../../types/types';

type modaleProps = {
  setState: React.Dispatch<React.SetStateAction<boolean>>;
  action: Action | null;
};
const InfoModale: FunctionComponent<modaleProps> = ({ setState, action }) => {
  return (
    <div className={'info-modale glass'}>
      <img src={exitSvg} className={'info-modale__exit'} onClick={() => setState(false)} alt='exit-btn' />
      <h4>Informations</h4>
      <ul className='info-modale-ul'>
        {action?.return_params.map((el, index) => (
          <li className={'info-modale-ul__element'} key={index}>
            <p className={'info-modale-ul__element--variable'}>{el.name}</p>
            <p className={'info-modale-ul__element--description'}>{el.help}</p>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default InfoModale;
