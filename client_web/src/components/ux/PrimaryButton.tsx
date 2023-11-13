import { FunctionComponent } from 'react';
import { PrimaryBtnProps } from '../../types/types';
import './button.css';

const PrimaryButton: FunctionComponent<PrimaryBtnProps> = ({ title, action }) => {
  return (
    <button
      className='button-primary'
      onClick={ev => {
        ev.preventDefault();
        action();
      }}
    >
      {title}
    </button>
  );
};

export default PrimaryButton;
