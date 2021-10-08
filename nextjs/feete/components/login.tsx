import Head from 'next/head';

export default function Login() {
  let login = async (event: React.MouseEvent<HTMLFormElement>) => {
    event.preventDefault();

    const res = await fetch('http://localhost:3100/token/jwt', {
      method: 'POST',
      body: JSON.stringify({
        key: event.currentTarget.key.value,
      }),
    });
    const data = await res.json();
    if (data.error) {
      alert(data.error);
      return;
    }
    localStorage.setItem('jwt', data.jwt);
  }

  return (
    <>
      <Head>
        <title>login</title>
      </Head>
      <form onSubmit={login}>
        <input name="key" />
        <button type="submit">submit</button>
      </form>
    </>
  )
}
