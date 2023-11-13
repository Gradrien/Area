import { createAction } from '@reduxjs/toolkit';
import { Action, AreaData, AreaPayload } from '../../types/types';
import { AreaActions } from '../../types/reduxTypes';

export const setCurrentArea = createAction<AreaData | null>(AreaActions.SET_CURRENT_AREA);

export const setCreatedArea = createAction<AreaPayload | null>(AreaActions.SET_CREATE_AREA);

export const setCurrentAction = createAction<Action | null>(AreaActions.SET_CURRENT_ACTION);
