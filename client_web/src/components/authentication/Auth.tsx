import { ChangeEvent, FormEvent, FunctionComponent, useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import GoogleOauthBtn from './GoogleOauthBtn';
import { useDispatch, useSelector } from 'react-redux';
import { getUser } from '../../redux/selector';
import { User } from '../../types/types';
import apiService from '../../services/api/ApiService';
import authHeader from '../../assets/svg/authHeader.svg';
import './Auth.css';
import { setUser } from '../../redux/actions/userAction';

export type AuthProps = {
  type: 'login' | 'register';
};

const Auth: FunctionComponent<AuthProps> = ({ type }) => {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const [formDatas, setFormDatas] = useState({
    email: '',
    name: '',
    password: '',
    confirm_password: '',
  });
  const currentUser = useSelector(getUser);
  const [isError, setError] = useState<string>('');
  const handleChange = (e: ChangeEvent<HTMLInputElement>): void => {
    const { id, value } = e.target;
    setFormDatas({
      ...formDatas,
      [id]: value,
    });
  };

  const handleSubmit = async (form: FormEvent, type: string): Promise<void> => {
    form.preventDefault();

    let user: User | string;
    if (type === 'login') {
      user = await apiService.login(formDatas.email, formDatas.password);
    } else {
      user = await apiService.register(formDatas.name, formDatas.email, formDatas.password, formDatas.confirm_password);
    }
    console.log(user);
    if (typeof user === 'string') {
      setError(user);
      return;
    }
    if (user) {
      localStorage.setItem('token', user.token);
      dispatch(setUser(user));
      console.log('user dispatched');
    }
  };

  useEffect(() => {
    if (currentUser?.token) {
      navigate('/');
    }
  }, [currentUser, navigate]);

  return (
    <div className={'container-auth-page'}>
      <div className={'header-auth-page'}>
        <img src={authHeader} alt={'Auth Header'}></img>
        <p className={'app-name-auth-page'}>Mingle</p>
      </div>
      <form onSubmit={form => handleSubmit(form, type)} className={'container-form-auth-page'}>
        <input
          className={'input-auth-page glass'}
          type={'email'}
          id={'email'}
          placeholder={'Adresse mail'}
          maxLength={320}
          autoComplete={'email'}
          onChange={handleChange}
          required
        />
        {type === 'register' && (
          <input
            className={'input-auth-page glass'}
            type={'text'}
            id={'name'}
            placeholder={'Nom'}
            maxLength={128}
            autoComplete={'name'}
            onChange={handleChange}
            required
          />
        )}
        <input
          className={'input-auth-page glass'}
          type={'password'}
          id={'password'}
          placeholder={'Mot de passe'}
          maxLength={128}
          autoComplete={'password'}
          onChange={handleChange}
          required
        />
        {type === 'register' && (
          <input
            className={'input-auth-page glass'}
            type={'password'}
            id={'confirm_password'}
            placeholder={'Confirmez votre mot de passe'}
            maxLength={128}
            autoComplete={'password'}
            onChange={handleChange}
            required
          />
        )}
        <button className={'send-form-auth-page send-form-glass-auth-page'} type={'submit'}>
          Continuer
        </button>
      </form>
      {isError !== '' && <span className={'auth-error'}>{isError}</span>}
      <p className={'no-account-auth-page'}>
        <span>{type === 'login' ? `Vous n'avez pas de compte ? ` : `Vous avez dejà un compte ? `}</span>
        <Link
          style={{
            textDecoration: 'none',
            display: 'block',
            marginLeft: '.25rem',
          }}
          className={'sign-up-auth-page'}
          to={type === 'login' ? '/register' : '/login'}
        >
          {' '}
          {type === 'login' ? ` Créer un compte` : ` Se connecter`}
        </Link>
      </p>
      <div className={'or-divider-auth-page'}>OU</div>
      <div className={'services-list-auth-page'}>
        <GoogleOauthBtn action={type} />
      </div>
    </div>
  );
};

export default Auth;
