import React, { FunctionComponent } from 'react';
import './helperModale.css';

const HelperModale: FunctionComponent<{
  children: React.ReactNode;
  onClick: () => void;
  onDeny: () => void;
}> = ({ children, onClick, onDeny }) => {
  return (
    <div className={'helper-modale glass'}>
      <h4>Aide :</h4>
      {children}
      <button className={'button-primary'} onClick={onClick}>
        J'ai compris
      </button>
      <span
        onClick={() => {
          onDeny();
          onClick();
        }}
      >
        Ne plus afficher
      </span>
    </div>
  );
};

export default HelperModale;
