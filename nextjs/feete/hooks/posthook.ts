import { useEffect, useState } from 'react';
import { fetchPosts }  from '../libs/post';

export default function posthook() {
  const [jwt, setJwt] = useState('');
  const [posts, setPost] = useState('');

  useEffect(() => {
      const localJwt: string = localStorage.getItem('jwt') as string;
      setJwt(localJwt);
  }, []);

  useEffect(() => {
    if (! jwt) return;
    fetchPosts(jwt, setPost)
  }, [jwt]);

  return { posts, setJwt, jwt }
}
