import Login from '../components/login'
import Posts from '../components/posts'
import posthook from '../hooks/posthook'

export default function Index() {
  const { posts, setApiKey, apiKey } = posthook();

  if (posts) return <Posts apiKey={apiKey} />
  else return <Login setApiKey={setApiKey} />
}
