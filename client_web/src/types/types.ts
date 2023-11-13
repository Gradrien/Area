import { ChangeEvent, ReactElement } from 'react';

export type ServiceLogin = {
  icon: string;
  name: string;
};

export type User = {
  id: number;
  token: string;
  name: string;
  email: string;
  first_area: boolean;
};

export type initialStateUser = {
  user: User | null;
};

export type AreaPayload = {
  name: string;
  action_id: number;
  reaction_id: number;
  refresh: number;
};

export type initialAreaState = {
  currentArea: AreaData | null;
  createdArea: AreaPayload | null;
  currentAction: Action | null;
};

export type Area = {
  id: number;
  name: string;
  refresh: number;
  action_name: string;
  action_config: object;
  reaction_name: string;
  reaction_config: object;
  action_icon: string;
  reaction_icon: string;
  active: boolean;
};

export type PublicArea = {
  id: number;
  name: string;
  refresh: number;
  action_name: string;
  action_config: object;
  reaction_name: string;
  reaction_config: object;
  action_icon: string;
  reaction_icon: string;
  active: boolean;
  is_available: boolean;
};

export type AreaCreateResponse = {
  id: number;
  name: string;
  refresh: number;
  action_name: string;
  action_config: string;
  reaction_name: string;
  reaction_config: string;
  action_icon: string;
  reaction_icon: string;
  active: boolean;
};

export type Service = {
  id: number;
  name: string;
  service_icon: string;
  is_enabled: boolean;
  no_auth: boolean;
};

export type ProtectedRoutesProps = {
  children: ReactElement;
};

export type AreaData = {
  name: string;
  active: boolean;
  action_name: string;
  action_config: Configuration;
  action_params: [{ name: string; help: string }];
  reaction_name: string;
  reaction_config: Configuration;
  id: number;
  refresh: number;
  action_icon: string;
  reaction_icon: string;
  public: boolean;
};

export type AreaPublicData = {
  name: string;
  active: boolean;
  action_name: string;
  action_config: Configuration;
  action_params: [{ name: string; help: string }];
  reaction_name: string;
  reaction_config: Configuration;
  id: number;
  refresh: number;
  action_icon: string;
  reaction_icon: string;
  public: boolean;
  is_available: boolean;
};

export type AreaEditionProps = {
  type: 'Action' | 'Reaction';
  editable?: boolean;
};

export type ToggleSwitchProps = {
  data: boolean;
  dataFiler: (ev: ChangeEvent<HTMLInputElement>) => void;
  id: string;
};

export type ConfigurationField = {
  name: string;
  mandatory: boolean;
  htmlFormType: string;
  value: any;
  display: string;
};

export type Configuration = ConfigurationField[];

export type PrimaryBtnProps = {
  title: string;
  action: () => void;
};

export type ActionQueryResponse = {
  id: number;
  name: string;
  api_endpoint: string;
  return_params: string;
  default_config: string;
  service_id: number;
};

export type ReactionQueryResponse = {
  id: number;
  name: string;
  api_endpoint: string;
  params: string;
  default_config: string;
  service_id: number;
};

export type Action = {
  id: number;
  name: string;
  api_endpoint: string;
  return_params: [{ name: string; help: string }];
  default_config: object;
  service_id: number;
};

export type Reaction = {
  id: number;
  name: string;
  api_endpoint: string;
  params: object;
  default_config: object;
  service_id: number;
};

export type ServiceDetail = {
  id: number;
  name: string;
  api_endpoint: string;
  actions: Action[];
  reactions: Reaction[];
  service_icon: string;
  is_enabled: boolean;
};

export type ServiceQueryResponse = {
  id: number;
  name: string;
  api_endpoint: string;
  actions: ActionQueryResponse[];
  reactions: ReactionQueryResponse[];
  service_icon: string;
  is_enabled: boolean;
};
