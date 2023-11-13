import {
  Area,
  AreaData,
  AreaPayload,
  AreaPublicData,
  PublicArea,
  Service,
  ServiceDetail,
  ServiceQueryResponse,
  User,
} from '../../types/types';
import { ProfileRequest, ServicesRequest } from '../../types/api/users';
import { LoginRequest, RefreshRequest } from '../../types/api/auth';
import { store } from '../../redux/store';
import { setCurrentArea } from '../../redux/actions/areaAction';

class ApiService {
  token: string | null = null;

  getAreas = async (): Promise<Area[] | null> => {
    if (!this.token) {
      return [];
    }
    const url: string = process.env.REACT_APP_API_URL + 'user/areas';
    const response: Response = await fetch(url, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    const data: Area[] = await response.json();
    if (response.status !== 200) {
      return null;
    }
    return data;
  };

  getMyProfile = async (): Promise<User | null> => {
    if (!this.token) return null;
    const url: string = process.env.REACT_APP_API_URL + 'user';
    const response: Response = await fetch(url, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    const data: ProfileRequest = await response.json();
    if (response.status !== 200) {
      return null;
    }
    return {
      id: data.id,
      token: this.token,
      name: data.name,
      email: data.email,
      first_area: data.first_area,
    };
  };

  login = async (email: string, password: string): Promise<User | string> => {
    const url: string = process.env.REACT_APP_API_URL + 'auth/login';
    const response: Response = await fetch(url, {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: email,
        password: password,
      }),
    });
    const data: LoginRequest = await response.json();
    if (response.status !== 200) {
      console.error('Error: ' + data.message);
      this.token = null;
      return data.message;
    }
    localStorage.setItem('token', data.authorization.token);
    return {
      id: data.user.id,
      token: data.authorization.token,
      name: data.user.name,
      email: data.user.email,
      first_area: data.user.first_area,
    };
  };

  register = async (
    name: string,
    email: string,
    password: string,
    confirm_password: string,
  ): Promise<User | string> => {
    try {
      const url: string = process.env.REACT_APP_API_URL + 'auth/register';
      const response: Response = await fetch(url, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: name,
          email: email,
          password: password,
          password_confirmation: confirm_password,
        }),
      });
      console.log('Status = ', response.status);
      const data: LoginRequest = await response.json();
      if (response.status !== 201) {
        console.error('Error: ' + data.message);
        return data.message;
      }
      return {
        id: data.user.id,
        token: data.authorization.token,
        name: data.user.name,
        email: data.user.email,
        first_area: data.user.first_area,
      };
    } catch (e) {
      console.log(e);
      return "Erreur lors de l'authentification";
    }
  };

  logout = async (): Promise<boolean> => {
    const url = process.env.REACT_APP_API_URL + 'auth/logout';
    const response: Response = await fetch(url, {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    if (response.status !== 200) {
      return false;
    }
    localStorage.removeItem('token');
    this.token = null;
    return true;
  };

  refreshToken = async (): Promise<User | null> => {
    const url: string = `${process.env.REACT_APP_API_URL}auth/refresh`;
    const response: Response = await fetch(url, {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    const data: RefreshRequest = await response.json();
    if (response.status !== 200) {
      localStorage.removeItem('token');
      this.token = null;
      return null;
    }
    localStorage.setItem('token', data.authorization.token);
    this.token = data.authorization.token;
    return {
      id: data.user.id,
      token: data.authorization.token,
      name: data.user.name,
      email: data.user.email,
      first_area: data.user.first_area,
    };
  };

  getServicesForUser = async (): Promise<Service[]> => {
    const url: string = process.env.REACT_APP_API_URL + 'user/services';
    const response: Response = await fetch(url, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    if (response.status !== 200) {
      return [];
    }
    const data: ServicesRequest = await response.json();
    console.log(data);
    return data.services.map(service => {
      return {
        id: service.id,
        name: service.name,
        is_enabled: service.is_enabled,
        service_icon: service.service_icon,
        no_auth: service.no_auth,
      };
    });
  };

  setAccessToken = (token: string) => {
    this.token = token;
  };

  getAreaDataById = async (id: number): Promise<AreaData | null> => {
    if (!this.token) {
      console.log('pas token');
      return null;
    }
    const url: string = `${process.env.REACT_APP_API_URL}area/${id}/data`;
    const response: Response = await fetch(url, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    if (!response.ok) {
      return null;
    }
    let result = await response.json();
    result.action_config = await JSON.parse(result.action_config);
    result.reaction_config = await JSON.parse(result.reaction_config);
    result.action_params = await JSON.parse(result.action_params);
    return result;
  };

  updateAreaById = async (data: AreaData, id: number) => {
    console.log(data);
    if (!this.token) {
      console.log('pas token');
      return null;
    }
    const url: string = `${process.env.REACT_APP_API_URL}area/${id}`;
    const body = JSON.stringify({
      refresh: data.refresh,
      name: data.name,
      active: data.active ? 1 : 0,
      reaction_config: JSON.stringify(data.reaction_config),
      action_config: JSON.stringify(data.action_config),
    });
    console.log(body);
    const response: Response = await fetch(url, {
      method: 'PUT',
      headers: {
        Accept: 'application/json',
        'Content-type': 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
      body: body,
    });
    if (response.ok) {
      store.dispatch(setCurrentArea(null));
      return true;
    }
    return response.json();
  };

  getAllUserServices = async (): Promise<null | ServiceDetail[]> => {
    try {
      if (!this.token) {
        console.log('pas token');
        return null;
      }
      const url: string = `${process.env.REACT_APP_API_URL}user/services`;
      const response: Response = await fetch(url, {
        method: 'GET',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
      });
      if (!response.ok) return null;
      let data = await response.json();
      data = data.services;
      data.map((service: ServiceQueryResponse) => {
        service.actions.map(action => {
          action.default_config = JSON.parse(action.default_config);
          action.return_params = JSON.parse(action.return_params);
          return action;
        });
        service.reactions.map(reaction => {
          reaction.default_config = JSON.parse(reaction.default_config);
          reaction.params = JSON.parse(reaction.params);
          return reaction;
        });
        return service;
      });
      return data;
    } catch (e) {
      console.log(e);
      return null;
    }
  };

  createArea = async (area: AreaPayload): Promise<AreaData | null> => {
    try {
      if (!this.token) {
        console.log('pas token');
        return null;
      }
      const url: string = `${process.env.REACT_APP_API_URL}area`;
      const response: Response = await fetch(url, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
        body: JSON.stringify(area),
      });
      if (!response.ok) return null;
      let data = await response.json();
      data.action_config = JSON.parse(data.action_config);
      data.reaction_config = JSON.parse(data.reaction_config);
      return data as AreaData;
    } catch (e) {
      console.log(e);
      return null;
    }
  };

  startArea = async (id: number): Promise<boolean> => {
    try {
      if (!this.token) {
        console.log('pas token');
        return false;
      }
      const url: string = `${process.env.REACT_APP_API_URL}area/${id}/start`;
      const response: Response = await fetch(url, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
      });
      return response.ok;
    } catch (e) {
      console.log(e);
      return false;
    }
  };

  deleteArea = async (id: number) => {
    try {
      if (!this.token) {
        console.log('pas token');
        return null;
      }
      const url: string = `${process.env.REACT_APP_API_URL}area/${id}`;
      await fetch(url, {
        method: 'DELETE',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
      });
    } catch (e) {
      console.log(e);
    }
  };

  editUser = async (user: User): Promise<boolean> => {
    try {
      if (!this.token) {
        console.log('No token');
        return false;
      }
      const url: string = `${process.env.REACT_APP_API_URL}user`;
      const response: Response = await fetch(url, {
        method: 'PUT',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
        body: JSON.stringify({
          name: user.name,
        }),
      });
      return response.ok;
    } catch (error) {
      console.log(error);
      return false;
    }
  };

  publishArea = async (id: number): Promise<boolean> => {
    try {
      if (!this.token) {
        console.log('No token');
        return false;
      }
      const url: string = `${process.env.REACT_APP_API_URL}area/${id}/public`;
      const response: Response = await fetch(url, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
      });
      return response.ok;
    } catch (e) {
      console.log(e);
      return false;
    }
  };

  unpublishArea = async (id: number): Promise<boolean> => {
    try {
      if (!this.token) {
        console.log('No token');
        return false;
      }
      const url: string = `${process.env.REACT_APP_API_URL}area/${id}/public`;
      const response: Response = await fetch(url, {
        method: 'DELETE',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
      });
      return response.ok;
    } catch (e) {
      console.log(e);
      return false;
    }
  };

  getPublicAreas = async (): Promise<PublicArea[] | null> => {
    if (!this.token) {
      return [];
    }
    const url: string = process.env.REACT_APP_API_URL + 'area/public';
    const response: Response = await fetch(url, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    const data: PublicArea[] = await response.json();
    if (response.status !== 200) {
      return null;
    }
    return data;
  };

  getPublicAreaDataById = async (id: number): Promise<AreaPublicData | null> => {
    if (!this.token) {
      console.log('pas token');
      return null;
    }
    const url: string = `${process.env.REACT_APP_API_URL}area/${id}/public`;
    const response: Response = await fetch(url, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer ' + this.token,
      },
    });
    if (!response.ok) {
      return null;
    }
    let result = await response.json();
    result.action_config = await JSON.parse(result.action_config);
    result.reaction_config = await JSON.parse(result.reaction_config);
    result.action_params = await JSON.parse(result.action_params);
    return result;
  };

  copyArea = async (id: number): Promise<boolean> => {
    try {
      if (!this.token) {
        console.log('No token');
        return false;
      }
      const url: string = `${process.env.REACT_APP_API_URL}area/${id}/copy`;
      const response: Response = await fetch(url, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
      });
      return response.ok;
    } catch (e) {
      console.log(e);
      return false;
    }
  };

  deleteService = async (id: number): Promise<boolean> => {
    try {
      if (!this.token) {
        console.log('No token');
        return false;
      }
      const url: string = `${process.env.REACT_APP_API_URL}services/${id}`;
      const response: Response = await fetch(url, {
        method: 'DELETE',
        headers: {
          Accept: 'application/json',
          'Content-type': 'application/json',
          Authorization: 'Bearer ' + this.token,
        },
      });
      return response.ok;
    } catch (e) {
      console.log(e);
      return false;
    }
  };
}

export default new ApiService();
