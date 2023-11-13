import { FunctionComponent } from 'react';
import { PrimaryBtnProps } from '../../types/types';
import './button.css';

const SecondaryButton: FunctionComponent<PrimaryBtnProps> = ({ title, action }) => {
  return (
    <button
      className='button-secondary'
      onClick={ev => {
        ev.preventDefault();
        action();
      }}
    >
      {title}
    </button>
  );
};

export default SecondaryButton;
