import Login from '../components/login'
import Posts from '../components/posts'
import posthook from '../hooks/posthook'

export default function Index() {
  const { posts, setJwt, jwt } = posthook();

  if (posts) return <Posts jwt={jwt} />
  else return <Login setJwt={setJwt} />
}
