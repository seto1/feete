import { useEffect, useState } from 'react';

export default function posthook() {
  const [jwt, setJwt] = useState('');
  const [posts, setPost] = useState('');

  useEffect(() => {
      const localJwt: string = localStorage.getItem('jwt') as string;
      setJwt(localJwt);
  }, []);

  useEffect(() => {
    if (! jwt) return;

    const fetchData = async() => {
      console.log('fetch!');
      const res = await fetch('http://localhost:3100/posts', {
        headers: {
          'Authorization': 'Bearer ' + jwt,
        },
      });
      const data = await res.json();
      if (data.error) {
        alert(data.error);
        return;
      }
      setPost(data);
    }
    fetchData();
  }, [jwt]);

  return { posts, setJwt }
}
