import { FunctionComponent } from 'react';
import Auth from '../../components/authentication/Auth';

const RegisterPage: FunctionComponent = () => {
  return (
    <div className='auth-container'>
      <Auth type={'register'} />
    </div>
  );
};

export default RegisterPage;
