import Login from '../components/login'
import Posts from '../components/posts'
import posthook from '../hooks/posthook'

export default function Index() {
  const { posts, setJwt } = posthook();

  if (posts) return <Posts />
  else return <Login name="John" setJwt={setJwt} />
}
