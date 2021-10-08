import { useEffect, useState } from 'react';
import Login from '../components/login'
import Posts from '../components/posts'

export default function Index() {

  const [jwt, setJwt] = useState('');

  useEffect(() => {
    (async() => {
      const localJwt: string = localStorage.getItem('jwt') as string;
      setJwt(localJwt);
      if (localJwt) {
        const res = await fetch('http://localhost:3100/posts', {
          headers: {
            'Authorization': 'Bearer ' + localJwt,
          },
        });
        const data = await res.json();
        if (data.error) {
          alert(data.error);
          return;
        }
        console.log(data);
      }
    })();
  });

  if (jwt) return <Posts />
  else return <Login />
}
