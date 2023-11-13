import { FunctionComponent, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const DlPage: FunctionComponent = () => {
  const navigate = useNavigate();

  useEffect(() => {
    fetch('/usr/app/public/client.apk').then(response => {
      response.blob().then(blob => {
        const fileURL = window.URL.createObjectURL(blob);

        let alink = document.createElement('a');
        alink.href = fileURL;
        alink.download = 'app.apk';
        alink.click();
        navigate('/home');
      });
    });
  }, []);

  return <></>;
};

export default DlPage;
