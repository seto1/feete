import { useEffect, useState } from 'react';
import { fetchPosts }  from '../libs/post';

export default function posthook() {
  const [apiKey, setApiKey] = useState('');
  const [posts, setPost] = useState('');

  useEffect(() => {
    const localKey: string = localStorage.getItem('key') as string;
    setApiKey(localKey);
  }, []);

  useEffect(() => {
    if (! apiKey) return;
    fetchPosts(apiKey, setPost)
  }, [apiKey]);

  return { posts, setApiKey, apiKey }
}
