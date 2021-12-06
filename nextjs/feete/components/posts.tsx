import { useEffect, useState } from 'react';
import { fetchPosts }  from '../libs/post';

type LoginProps = {
  apiKey: string;
}

export default function Posts(props: LoginProps) {
  const [posts, setPost] = useState([]);

  let post = async(event: React.MouseEvent<HTMLFormElement>) => {
    event.preventDefault();
    const res = await fetch('http://localhost:3100/posts', {
      method: 'POST',
      headers: new Headers({
        'Authorization': 'Bearer ' + props.apiKey,
      }),
      body: JSON.stringify({
        text: event.currentTarget.key.value,
      }),
    });
    const data = await res.json();
    if (data.error) {
      alert(data.error);
      return;
    }
    fetchPosts(props.apiKey, setPost)
  };

  useEffect(() => {
    fetchPosts(props.apiKey, setPost)
  }, []);

  return (
    <>
      <form onSubmit={post}>
        <textarea name="key"></textarea>
        <button type="submit">post</button>
      </form>
      <div>
        {posts.length > 0 &&
          <>
            {posts.map((post: any) => {
              return (
                <div key={post.id}>
                  {post.text}
                </div>
              )
            })}
          </>
        }
      </div>
    </>
  )
}
