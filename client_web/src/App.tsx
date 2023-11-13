import './styles/reset.css';
import './styles/root.css';
import { Outlet } from 'react-router-dom';
import NavBar from './components/ux/NavBar';

function App() {
  return (
    <>
      <NavBar />
      <Outlet />
    </>
  );
}

export default App;
