import { rootReducer } from '../redux/store';

export enum UserActions {
  SET_USER = 'SET_USER',
}

export enum AreaActions {
  SET_CURRENT_AREA = 'SET_CURRENT_AREA',
  SET_CREATE_AREA = 'SET_CREATE_AREA',
  SET_CURRENT_ACTION = 'SET_CURRENT_ACTION',
}

export type RootType = ReturnType<typeof rootReducer>;
