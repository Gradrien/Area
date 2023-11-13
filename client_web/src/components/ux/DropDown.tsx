import { FunctionComponent, useEffect, useState } from 'react';
import './dropDown.css';
import { ConfigurationField } from '../../types/types';

const DropDown: FunctionComponent<{
  config: ConfigurationField;
  onEdit: (conf: ConfigurationField) => void;
  editable?: boolean;
}> = ({ config, onEdit, editable = true }) => {
  const [isExpanded, setIsExpanded] = useState<boolean>(false);
  const [value, setValue] = useState<string>(config.value);
  let options = config.htmlFormType.split(':')[1].split(';');
  let nb_items = options.length;

  useEffect(() => {
    const selected = options.find(el => el.includes(config.value));
    const key = selected?.split('|')[0];
    setValue(key ?? '');
    onEdit({
      ...config,
      value: selected?.split('|')[1],
    });
  }, []);

  console.log(config);
  return (
    <div className='dropdown'>
      <div
        className={`dropdown-header glass ${isExpanded ? 'expanded' : ''}`}
        onClick={editable ? () => setIsExpanded(!isExpanded) : undefined}
      >
        <span>{value}</span>
        <svg
          className='dropdown-arrow'
          width='16'
          height='16'
          fill='#2D2D2D'
          viewBox='0 0 24 24'
          xmlns='http://www.w3.org/2000/svg'
        >
          <path d='M16.488 13.383 9.91 19.138c-.776.68-1.99.128-1.99-.903V6.725a1.2 1.2 0 0 1 1.99-.904l6.577 5.755a1.2 1.2 0 0 1 0 1.807Z'></path>
        </svg>
      </div>
      {isExpanded && (
        <div className='dropdown-content glass'>
          {options.map((el, index) => {
            const key = el.split('|')[0];
            const objectValue = el.split('|')[1];
            return (
              <div
                className={`dropdown-item ${index === nb_items - 1 ? 'last' : null}`}
                key={index}
                onClick={ev => {
                  setValue(key);
                  setIsExpanded(false);
                  onEdit({
                    ...config,
                    value: objectValue,
                  });
                }}
              >
                <span>{key}</span>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};

export default DropDown;
