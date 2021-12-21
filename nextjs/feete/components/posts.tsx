import { useEffect, useState } from 'react';
import { fetchPosts, deletePost }  from '../libs/post';
import styles from '../styles/posts.module.css';

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

  let del = async(event: React.MouseEvent<HTMLFormElement>) => {
    await deletePost(event.currentTarget.getAttribute('data-id'), props.apiKey);
    fetchPosts(props.apiKey, setPost)
  };

  useEffect(() => {
    fetchPosts(props.apiKey, setPost)
  }, []);

  return (
    <div className={styles.postsPage}>
      <form onSubmit={post}>
        <textarea name="key"></textarea>
        <button type="submit">post</button>
      </form>
      <div className={styles.posts}>
        {posts.length > 0 &&
          <>
            {posts.map((post: any) => {
              return (
                <div key={post.id} className={styles.post}>
                  {post.text}
                  <div className={styles.postDelete} onClick={del} data-id={post.id}>削除</div>
                </div>
              )
            })}
          </>
        }
      </div>
    </div>
  )
}
