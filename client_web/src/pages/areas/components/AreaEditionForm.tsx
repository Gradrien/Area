import { FunctionComponent, useEffect, useRef, useState } from 'react';
import { AreaEditionProps, ConfigurationField } from '../../../types/types';
import './areaEditionForm.css';
import { useDispatch, useSelector } from 'react-redux';
import { getCurrentAction, getCurrentArea } from '../../../redux/selector';
import { setCurrentArea } from '../../../redux/actions/areaAction';
import InfoModale from './InfoModale';
import infoSvg from './../../../assets/svg/info.svg';
import CopyModale from './CopyModale';
import DropDown from '../../../components/ux/DropDown';

const FormVariableHeader: FunctionComponent<{
  hasChild: boolean;
}> = ({ hasChild }) => {
  const currentAction = useSelector(getCurrentAction);
  const [showModale, setShowModale] = useState<boolean>(false);
  const [showCopyModale, setShowCopyModale] = useState<boolean>(false);
  if (!hasChild) return null;

  return (
    <>
      {showModale === true ? <InfoModale setState={setShowModale} action={currentAction} /> : null}
      <div className={'actions-variable-header-container'}>
        <p className='actions-variable-header'>Les différentes variables disponibles sont:</p>
        <img className={'actions-variable-helper'} src={infoSvg} onClick={() => setShowModale(true)} alt={'Info'} />
      </div>
      <ul className='ul-actions-variable'>
        <CopyModale show={showCopyModale} />
        {currentAction ? (
          currentAction.return_params.map((el, index) => (
            <li
              key={index}
              onClick={() => {
                navigator.clipboard.writeText(`{{${el.name}}}`);
                setShowCopyModale(true);
                setTimeout(() => setShowCopyModale(false), 1500);
              }}
            >
              {el.name}
            </li>
          ))
        ) : (
          <p>Aucune variable disponible</p>
        )}
      </ul>
    </>
  );
};

const FormField: FunctionComponent<{
  config: ConfigurationField;
  onEdit: (conf: ConfigurationField) => void;
  editable?: boolean;
}> = ({ config, onEdit, editable = true }) => {
  const taRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!taRef.current) return;
    taRef.current.textContent = config.value;
  }, []);

  useEffect(() => {}, [config]);

  if (config.htmlFormType.includes('select')) {
    return (
      <div className='config-form-field'>
        <label>
          {config.display}
          {config.mandatory && <span className='mandatory'>*</span>}
        </label>
        <DropDown config={config} onEdit={onEdit} editable={editable} />
      </div>
    );
  }

  return (
    <div className='config-form-field'>
      {config.htmlFormType === 'textarea' ? (
        <>
          <label>
            {config.display}
            {config.mandatory && <span className='mandatory'>*</span>}
          </label>
          <div
            ref={taRef}
            className='textArea glass'
            contentEditable={editable}
            content={config.value}
            onInput={ev => {
              onEdit({
                ...config,
                value: ev.currentTarget.innerText,
              });
            }}
          ></div>
        </>
      ) : (
        <>
          <label>
            {config.display}
            {config.mandatory && <span className='mandatory'>*</span>}
          </label>
          <input
            className='glass'
            type={config.htmlFormType}
            value={config.value}
            readOnly={!editable}
            disabled={!editable}
            onChange={ev =>
              onEdit({
                ...config,
                value: ev.currentTarget.value,
              })
            }
          />
        </>
      )}
    </div>
  );
};

const AreaEditionForm: FunctionComponent<AreaEditionProps> = ({ type, editable = true }) => {
  const currentArea = useSelector(getCurrentArea);
  const dispatch = useDispatch();
  const [hasChild, setHasChild] = useState<boolean>(false);

  useEffect(() => {
    if (!currentArea) return;
    if (type === 'Action') {
      setHasChild(currentArea.action_config.length !== 0);
    } else {
      setHasChild(currentArea.reaction_config.length !== 0);
    }
  }, [currentArea]);

  const onEditAction = (conf: ConfigurationField) => {
    if (!currentArea) return;
    dispatch(
      setCurrentArea({
        ...currentArea,
        action_config: [...currentArea.action_config].map(el => {
          if (el.name !== conf.name) return el;
          return conf;
        }),
      }),
    );
  };

  const onEditReaction = (conf: ConfigurationField) => {
    if (!currentArea) return;
    dispatch(
      setCurrentArea({
        ...currentArea,
        reaction_config: [...currentArea.reaction_config].map(el => {
          if (el.name !== conf.name) return el;
          return conf;
        }),
      }),
    );
  };

  return (
    <>
      {type === 'Action' ? (
        currentArea?.action_config.map((field, index) => {
          return <FormField key={`action_${index}`} config={field} onEdit={onEditAction} editable={editable} />;
        })
      ) : (
        <>
          <FormVariableHeader hasChild={hasChild} />
          {currentArea?.reaction_config.map((field, index) => {
            return <FormField key={`reaction_${index}`} config={field} onEdit={onEditReaction} editable={editable} />;
          })}
        </>
      )}
      {!hasChild && <p className='edit-area-infos'>Pas de configuration supplémentaire</p>}
    </>
  );
};

export default AreaEditionForm;
