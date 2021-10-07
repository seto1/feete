import Head from 'next/head'

export default function Index() {
  let login = async (event: React.MouseEvent<HTMLFormElement>) => {
    event.preventDefault();

    const res = await fetch('http://localhost:3100/test');
    console.log(res);
    console.log(await res.json());
  }
  return (
    <div>
      <Head>
        <title>Create Next App</title>
      </Head>
      <form onSubmit={login}>
        <input name="key" />
        <button type="submit">submit</button>
      </form>
    </div>
  )
}
