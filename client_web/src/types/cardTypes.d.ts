export type CardProp = {
  title: string;
  active: boolean;
  id: number;
  actionName: string;
  reactionName: string;
  actionImg: string;
  reactionImg: string;
  available?: boolean;
  mode: 'private' | 'public';
};

export type CardProfileProps = {
  name: string;
  email: string;
};
