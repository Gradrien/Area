import { FunctionComponent, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { setUser } from '../../redux/actions/userAction';
import { LoginRequest } from '../../types/api/auth';
import Loading from '../../components/utils/Loading';

const GitLabSendAuth: FunctionComponent = () => {
  const { search } = useLocation();
  const navigate = useNavigate();
  const redirectUrl = 'http://localhost:8080/api/oauth/gitlab';
  const dispatch = useDispatch();

  const sendGitLabAuthCode = async (authCode: string) => {
    try {
      const response = await fetch(redirectUrl, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem('token')}`,
        },
        mode: 'cors',
        body: JSON.stringify({ code: authCode }),
      });
      if (!response.ok) {
        console.log(await response.json());
        return;
      }
      const user: LoginRequest = await response.json();
      if (!user) {
        navigate('/profile');
        return;
      }
      navigate('/profile');
    } catch (error) {
      console.log(error);
      dispatch(setUser(null));
      navigate('/profile');
      return;
    }
  };

  useEffect(() => {
    const params = new URLSearchParams(search);
    const authCode = params.get('code');
    if (params.get('error') || !authCode) {
      navigate('/profile');
      return;
    }
    console.log(authCode);
    sendGitLabAuthCode(authCode);
  }, [navigate, search]);

  return <Loading />;
};

export default GitLabSendAuth;
