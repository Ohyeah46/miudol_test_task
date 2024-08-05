import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import backendURL from '../backendURL';
import './styles/index.css';
import NotFoundPage from '../NotFoundPage';


const ArticlePage = () => {
  const { id } = useParams();
  const [article, setArticle] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
     fetch('http://localhost:3010/article/1')
      .then((response) => {
        if (!response.ok) {
          throw new Error('Статья не найдена');
        }
        return response.json();
      })
      .then((data) => {
        setArticle(data);
      })
      .catch((error) => {
        setError(error.message);
      });
  }, [id]);

  if (error) {
    return (
      <div className="error-page">
        <h1>Ошибка 404</h1>
        <p>{error}</p>
      </div>
    );
  }

  if (!article) {
    return <div>Загрузка...</div>;
  }

  return (
    <div className="article">
      <h1>{article.title}</h1>
      <p>{article.text}</p>
      <p>Автор: {article.author}</p>
    </div>
  );
};

export default ArticlePage;