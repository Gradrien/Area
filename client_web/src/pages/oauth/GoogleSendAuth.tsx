import { FunctionComponent, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { GoogleAuthOpt } from '../../types/googleBtnTypes';
import { useDispatch } from 'react-redux';
import { LoginRequest } from '../../types/api/auth';
import { setUser } from '../../redux/actions/userAction';
import Loading from '../../components/utils/Loading';

const GoogleOAuth: FunctionComponent<GoogleAuthOpt> = ({ action }) => {
  const { search } = useLocation();
  const navigate = useNavigate();
  const url =
    action === 'login'
      ? 'http://localhost:8080/api/auth/google-signin'
      : 'http://localhost:8080/api/auth/google-signup';
  const redirectUrl =
    action === 'login' ? 'http://localhost:8081/oauth/google/login' : 'http://localhost:8081/oauth/google/register';
  const dispatch = useDispatch();

  const sendGoogleAuthCode = async (authCode: string) => {
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        mode: 'cors',
        body: JSON.stringify({
          code: authCode,
          redirect: redirectUrl,
          type: 'web',
        }),
      });

      if (!response.ok) {
        console.log(await response.json());
        return;
      }
      const user: LoginRequest = await response.json();
      console.log(user);
      if (!user) {
        navigate(action === 'login' ? '/login' : '/register');
        return;
      }
      dispatch(
        setUser({
          id: user.user.id,
          token: user.authorization.token,
          name: user.user.name,
          email: user.user.email,
          first_area: user.user.first_area,
        }),
      );
      localStorage.setItem('token', user.authorization.token);
      navigate('/');
    } catch (e) {
      console.log(e);
      dispatch(setUser(null));
      navigate(action === 'login' ? '/login' : '/register');
      return;
    }
  };

  useEffect(() => {
    const params = new URLSearchParams(search);
    const authCode = params.get('code');
    if (params.get('error') || !authCode) {
      navigate('/');
      return;
    }
    sendGoogleAuthCode(authCode);
  }, [search]);
  return <Loading />;
};

export default GoogleOAuth;
