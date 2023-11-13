import { FunctionComponent } from 'react';
import './copyModale.css';

const CopyModale: FunctionComponent<{ show: boolean }> = ({ show }) => {
  return <div className={`copy-modale glass ${!show ? 'hide' : null}`}>Variable copiée dans le presse-papier</div>;
};

export default CopyModale;
