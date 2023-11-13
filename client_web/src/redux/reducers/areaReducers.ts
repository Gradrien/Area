import { initialAreaState } from '../../types/types';
import { createReducer } from '@reduxjs/toolkit';
import { setCreatedArea, setCurrentAction, setCurrentArea } from '../actions/areaAction';

const initialState: initialAreaState = {
  currentArea: null,
  createdArea: null,
  currentAction: null,
};

export const areaReducer = createReducer(initialState, builder => {
  builder.addCase(setCurrentArea, (state, action) => {
    return {
      ...state,
      currentArea: action.payload,
    };
  });
  builder.addCase(setCreatedArea, (state, action) => {
    return {
      ...state,
      createdArea: action.payload,
    };
  });
  builder.addCase(setCurrentAction, (state, action) => {
    return {
      ...state,
      currentAction: action.payload,
    };
  });
});
