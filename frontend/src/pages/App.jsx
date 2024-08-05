import "../styles/index.css";
import { useEffect } from "react";
import backendURL from "../../backendURL";




export default function App() {
  useEffect(() => {
    fetch(`${backendURL}/get_news`, {
      method: "GET",
    })
      .then((response) => {
        return response.json();
      })
      .then((promiseJson) => {
        console.log(promiseJson);
      });
  }, []);
  return (
    <>
      <div className="text-3xl font-bold underline">Страница для новостей</div>
    </>
  );
}
