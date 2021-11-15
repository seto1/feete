export async function fetchPosts(jwt: string, setPost: any) {
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
    setPost(data.posts);
}
