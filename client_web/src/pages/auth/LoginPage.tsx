import { FunctionComponent } from 'react';
import Auth from '../../components/authentication/Auth';

const LoginPage: FunctionComponent = () => {
  return (
    <div className='auth-container'>
      <Auth type={'login'} />
    </div>
  );
};

export default LoginPage;
