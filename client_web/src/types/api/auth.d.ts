export type LoginRequest = {
  user: {
    id: number;
    name: string;
    email: string;
    email_verified_at: string;
    created_at: string;
    updated_at: string;
    first_area: boolean;
  };
  authorization: {
    token: string;
    type: string;
  };
  message: string;
};

export type RefreshRequest = {
  user: {
    id: number;
    name: string;
    email: string;
    email_verified_at: string;
    created_at: string;
    updated_at: string;
    first_area: boolean;
  };
  authorization: {
    token: string;
    type: string;
  };
  message: string;
};
