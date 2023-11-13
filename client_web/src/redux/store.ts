import { combineReducers, configureStore } from '@reduxjs/toolkit';
import { userReducer } from './reducers/userReducer';
import { areaReducer } from './reducers/areaReducers';

export const rootReducer = combineReducers({
  userReducer,
  areaReducer,
});

export const store = configureStore({ reducer: rootReducer });
