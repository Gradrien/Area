import { RootType } from '../types/reduxTypes';

export const getUser = (store: RootType) => {
  return store.userReducer.user;
};

export const getCurrentArea = (store: RootType) => {
  return store.areaReducer.currentArea;
};

export const getCreatedArea = (store: RootType) => {
  return store.areaReducer.createdArea;
};

export const getCurrentAction = (store: RootType) => {
  return store.areaReducer.currentAction;
};
