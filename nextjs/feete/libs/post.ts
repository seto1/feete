export async function fetchPosts(key: string, setPost: any) {
  if (!key) return;

  const res = await fetch('http://localhost:3100/posts', {
    headers: {
      'Authorization': 'Bearer ' + key,
    },
  });
  const data = await res.json();
  if (data.error) {
    alert(data.error);
    return;
  }
  setPost(data.posts);
}

export async function deletePost(postId: number, key: string) {
  if (!key) return;

  const res = await fetch('http://localhost:3100/posts/' + String(postId), {
    headers: {
      'Authorization': 'Bearer ' + key,
    },
    method: 'DELETE'
  });
  const data = await res.json();
  if (data.error) {
    alert(data.error);
    return;
  }
}
