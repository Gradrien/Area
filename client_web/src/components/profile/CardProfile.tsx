import { ChangeEvent, FunctionComponent, useState } from 'react';
import { CardProfileProps } from '../../types/cardTypes';
import editIcon from '../../assets/svg/edit.svg';
import saveIcon from '../../assets/svg/save.svg';
import './cardProfile.css';
import { useDispatch, useSelector } from 'react-redux';
import { getUser } from '../../redux/selector';
import { User } from '../../types/types';
import apiService from '../../services/api/ApiService';

const CardProfile: FunctionComponent<CardProfileProps> = ({ name, email }) => {
  const dispatch = useDispatch();
  const currentUser = useSelector(getUser);
  const [editing, setEditing] = useState<boolean>(false);
  const [dataRows, setDataRows] = useState([
    {
      title: 'Nom',
      type: 'text',
      value: name,
      icon: editIcon,
      autoComplete: 'name',
      editReady: true,
    },
    {
      title: 'Email',
      type: 'email',
      value: email,
      icon: null,
      autoComplete: 'email',
      editReady: false,
    },
    {
      title: 'Mot de passe',
      type: 'password',
      value: '********',
      icon: null,
      autoComplete: 'password',
      editReady: false,
    },
  ]);

  const handleChange = (e: ChangeEvent<HTMLInputElement>): void => {
    const { id, value } = e.target;
    console.log(id, value);
    setDataRows(
      dataRows.map(row => {
        if (row.title === id) {
          return {
            ...row,
            value: value,
          };
        }
        return row;
      }),
    );
  };

  const editProfile = () => {
    setEditing(!editing);
    setDataRows(
      dataRows.map(row => {
        if (row.title === 'Nom') {
          return {
            ...row,
            icon: editing ? editIcon : saveIcon,
          };
        }
        return row;
      }),
    );
    if (editing) {
      console.log('save profile');
      if (currentUser === null) return;
      const newUser: User = {
        ...currentUser,
        name: dataRows[0].value,
      };
      console.log(newUser);
      apiService.editUser(newUser).then(res => {
        if (res) {
          dispatch({
            type: 'SET_USER',
            payload: newUser,
          });
        } else {
          // Display error message to user
        }
      });
    }
  };

  if (editing) {
    return (
      <div className='card-profile-container glass'>
        {dataRows.map((row, index) => (
          <div key={`card_profile_${index}`} className='card-profile'>
            <div className={'card-profile-title-container'}>
              <p className={'card-profile-title'}>{row.title}</p>
              {row.icon && <img src={row.icon} alt={row.icon} onClick={editProfile} className='card-profile-save' />}
            </div>
            {row.editReady ? (
              <input
                className={'input-auth-page glass profile'}
                type={row.type}
                id={row.title}
                maxLength={320}
                autoComplete={row.autoComplete}
                value={row.value}
                onChange={handleChange}
                required
              />
            ) : (
              <p className={'card-profile-value'}>{row.value}</p>
            )}
          </div>
        ))}
      </div>
    );
  }

  return (
    <div className='card-profile-container glass'>
      {dataRows.map((row, index) => (
        <div key={`card_profile_${index}`} className='card-profile'>
          <div className={'card-profile-title-container'}>
            <p className={'card-profile-title'}>{row.title}</p>
            {row.icon && <img className={'card-profile-icon'} src={row.icon} alt={row.icon} onClick={editProfile} />}
          </div>
          <p className={'card-profile-value'}>{row.value}</p>
        </div>
      ))}
    </div>
  );
};

export default CardProfile;
