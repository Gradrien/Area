import { FunctionComponent, useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { setUser } from '../../redux/actions/userAction';
import Loading from './Loading';
import { ProtectedRoutesProps, User } from '../../types/types';
import apiService from '../../services/api/ApiService';

const ProtectedRoutes: FunctionComponent<ProtectedRoutesProps> = ({ children }) => {
  const [loaded, setLoaded] = useState<boolean>(false);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const getProfile = async (): Promise<boolean> => {
      const myProfile: User | null = await apiService.getMyProfile();
      if (!myProfile) {
        dispatch(setUser(null));
        return false;
      }
      dispatch(setUser(myProfile));
      setLoaded(true);
      return true;
    };

    const decodeToken = async (token: string): Promise<void> => {
      try {
        const decodedToken = JSON.parse(atob(token.split('.')[1]));
        const date = new Date();
        date.setMinutes(date.getMinutes() - 20);
        console.log(date.getTime() / 1000);
        console.log(decodedToken.exp);
        if (decodedToken.exp < date.getTime() / 1000) {
          console.log('refresh user');
          const newProfile: User | null = await apiService.refreshToken();
          if (!newProfile) {
            dispatch(setUser(null));
            return;
          }
          dispatch(setUser(newProfile));
        }
      } catch (error) {
        console.error(error);
      }
    };

    const token: string | null = localStorage.getItem('token');

    if (!token) {
      navigate('/login');
      return;
    }
    decodeToken(token).then(() => {
      apiService.setAccessToken(token);
      getProfile().then(res => {
        if (!res) {
          navigate('/login');
          return;
        }
        setLoaded(true);
      });
    });
  }, [location]);

  if (!loaded) {
    return <Loading />;
  }
  return children;
};

export default ProtectedRoutes;
