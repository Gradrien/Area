import { FunctionComponent } from 'react';
import { CardProp } from '../types/cardTypes';
import settingsIcon from '../assets/svg/settings.svg';
import './card.css';

const Card: FunctionComponent<CardProp> = ({
  id,
  active,
  actionName,
  reactionName,
  reactionImg,
  actionImg,
  title,
  available,
  mode,
}) => {
  return (
    <a
      className={'card-link'}
      href={mode === 'private' ? `http://localhost:8081/areas/edit/${id}` : `http://localhost:8081/areas/view/${id}`}
    >
      <div className='card glass'>
        <div className='card-header'>
          <div className='card-header-title'>
            <h3>{title}</h3>
            {mode === 'private' && <div className={active ? 'active' : 'inactive'}></div>}
          </div>
          {mode === 'private' ? <img className='card-icon-settings' src={settingsIcon} alt='settings' /> : null}
        </div>
        <div className='card-actions-container'>
          <div className={`card-action ${available === false ? 'not-available' : ''}`}>
            <img src={actionImg} alt={actionName} />
            <p>{actionName}</p>
          </div>
          <div className={`card-action ${available === false ? 'not-available' : ''}`}>
            <img src={reactionImg} alt={reactionName} />
            <p>{reactionName}</p>
          </div>
        </div>
      </div>
    </a>
  );
};

export default Card;
