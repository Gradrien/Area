import { FunctionComponent } from 'react';
import './dotMarker.css';

const DotMarker: FunctionComponent<{ isFilled: boolean }> = ({ isFilled }) => {
  return <div className={`dot-marker ${isFilled ? 'filled' : ''}`}></div>;
};

export default DotMarker;
