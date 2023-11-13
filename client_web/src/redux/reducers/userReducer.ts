import { createReducer } from '@reduxjs/toolkit';
import { initialStateUser } from '../../types/types';
import { setUser } from '../actions/userAction';

const initialState: initialStateUser = { user: null };
export const userReducer = createReducer(initialState, builder => {
  builder.addCase(setUser, (state, action) => {
    return { ...state, user: action.payload };
  });
});
