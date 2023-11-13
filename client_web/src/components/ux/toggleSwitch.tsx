import { FunctionComponent, useRef } from 'react';
import './toggleSwitch.css';
import { ToggleSwitchProps } from '../../types/types';

const ToggleSwitch: FunctionComponent<ToggleSwitchProps> = ({ data, dataFiler, id }) => {
  const input = useRef<HTMLInputElement>(null);

  return (
    <>
      <input className='toggle-input' type='checkbox' id={id} ref={input} checked={data} onChange={dataFiler} />
      <label className='toggle-label' htmlFor={id}>
        Toggle
      </label>
    </>
  );
};

export default ToggleSwitch;
