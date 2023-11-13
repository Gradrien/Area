import { FunctionComponent, useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import './navbar.css';

function sleep(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

const NavbarDesktop: FunctionComponent = () => {
  const location = useLocation();
  const [active, setActive] = useState('/');

  useEffect(() => {
    setActive(location.pathname);
  }, [location]);

  return (
    <nav className={`app-navbar`}>
      <div className='navbar-container'>
        <div className='app-navbar-nav'>
          <Link to='/' className='nav-link logo'>
            Mingle
          </Link>
        </div>
        <ul className={'app-navbar__ul'}>
          <li className={`app-navbar__li ${active === '/' ? 'active' : ''}`}>
            <Link to='/' className=''>
              Accueil
            </Link>
          </li>
          <li className={'app-navbar__separator'}></li>
          <li className={`app-navbar__li ${active === '/areas/create' ? 'active' : ''}`}>
            <Link to='/areas/create' className=''>
              Créer une Area
            </Link>
          </li>
          <li className={'app-navbar__separator'}></li>
          <li className={`app-navbar__li ${active === '/areas/public' ? 'active' : ''}`}>
            <Link to='/areas/public' className=''>
              MingleShare
            </Link>
          </li>
        </ul>
        <Link to='/profile'>
          <svg width='24' height='24' fill='#040416' viewBox='0 0 24 24' xmlns='http://www.w3.org/2000/svg'>
            <path d='M6 19.2s-1.2 0-1.2-1.2S6 13.2 12 13.2s7.2 3.6 7.2 4.8c0 1.2-1.2 1.2-1.2 1.2H6Zm6-7.2a3.6 3.6 0 1 0 0-7.2 3.6 3.6 0 0 0 0 7.2Z'></path>
          </svg>
        </Link>
      </div>
    </nav>
  );
};

const NavBarMobile: FunctionComponent = () => {
  const [show, setShow] = useState<boolean>(false);
  const [animate, setAnimate] = useState<boolean>(false);

  useEffect(() => {
    if (!show) {
      setAnimate(false);
      return;
    }
    sleep(200).then(() => {
      if (show) setAnimate(true);
    });
  }, [show]);

  return (
    <nav className={`app-navbar ${show ? 'active' : ''}`}>
      <div className='app-navbar-nav'>
        <Link to='/' className='nav-link logo' onClick={() => setShow(false)}>
          Mingle
        </Link>
        <div className={`burger ${show ? 'active' : ''}`} onClick={() => setShow(!show)}>
          <span></span>
        </div>
      </div>
      <div className={`app-navbar-container ${animate ? 'animate' : ''}`}>
        <ul>
          <li>
            <Link to='/' className='nav-link nav-item' onClick={() => setShow(false)}>
              Accueil
            </Link>
          </li>
          <li>
            <Link to='/areas/create' className='nav-link nav-item' onClick={() => setShow(false)}>
              Créer une Area
            </Link>
          </li>
          <li>
            <Link to='/areas/public' className='nav-link nav-item' onClick={() => setShow(false)}>
              MingleShare
            </Link>
          </li>
          <li>
            <Link to='/profile' className='nav-link nav-item' onClick={() => setShow(false)}>
              Profil
            </Link>
          </li>
        </ul>
      </div>
    </nav>
  );
};

const NavBar: FunctionComponent = () => {
  const [width, setWidth] = useState<number>(window.innerWidth);

  const windowSizeHandler = (_ev: UIEvent) => {
    setWidth(window.innerWidth);
  };

  window.addEventListener('resize', windowSizeHandler);

  return <>{width < 950 ? <NavBarMobile /> : <NavbarDesktop />}</>;
};

export default NavBar;
