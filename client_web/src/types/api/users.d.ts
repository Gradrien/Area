export type AreasRequest = {
  id: number;
  name: string;
  refresh: number;
  user_id: number;
  action_name: string;
  reaction_name: string;
};

export type ServicesRequest = {
  name: string;
  email: string;
  services: [
    {
      id: number;
      name: string;
      is_enabled: boolean;
      service_icon: string;
      no_auth: boolean;
    },
  ];
};

export type ProfileRequest = {
  id: number;
  name: string;
  email: string;
  email_verified_at: string;
  created_at: string;
  updated_at: string;
  first_area: boolean;
};
