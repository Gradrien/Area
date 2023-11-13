import { createAction } from '@reduxjs/toolkit';
import { UserActions } from '../../types/reduxTypes';
import { User } from '../../types/types';

export const setUser = createAction<User | null>(UserActions.SET_USER);
