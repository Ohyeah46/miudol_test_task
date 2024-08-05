Установка всех зависимостей
включая Database, MySQL, React и тому подобное.

в vscode для подключения базы данных испльзовал раширение Database. установил db внтури ввел данные пользователя указанные в connection.js

_____________________________________________________Реализовать SQL-запрос на получение статьи по её уникальному идентификатору.


------Создание страниц
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('visitor', 'moderator', 'admin') DEFAULT 'visitor'
);

CREATE TABLE articles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  author_id INT,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- Здесь мы получаем статью по уникальному идентификатору, а именно его id.
SELECT * FROM news
WHERE id =2;

--Хранимая процедуры которая будет получать статью по id.
DELIMITER //

CREATE PROCEDURE GetArticleById(IN articleId INT)
BEGIN
    SELECT * FROM news WHERE id = articleId;
END //
DELIMITER ;

--Запрос по id.
CALL GetArticleById(3);

--Сброс хранимой процедуры.
DROP PROCEDURE IF EXISTS GetArticleById;





_________________________________Реализовать функционал получения статьи с помощью написанной ранее SQLфункции на Backend-части приложения. Необходимо также обрабатывать
ситуации, когда может возникнуть ошибка

--Получаем статью по идентификатору в index.js
const getArticleByIdQuery = "CALL GetArticleById(?)";

--Функция
app.get("/article/:id", (req, res) => {
  const articleId = parseInt(req.params.id);

  if (isNaN(articleId)) {
    return res.status(400).json({ error: "Invalid article ID" });
  }

  connection.query(getArticleByIdQuery, [articleId], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database query error" });
    }

    if (results[0].length === 0) {
      return res.status(404).json({ error: "Article not found" });
    }

    res.json(results[0][0]); // Возвращаем первую статью из результата
  });
});

Для проверки правильности отображения я использовал Postman
--Для вывода новостей (news) http://localhost:3010/get_news
--Для вывода идетификатора (id) http://localhost:3010/article/1
_________________________________________________________________________________________________
Была поставлена задача по реализации небольшого портала для просмотра статей.
Заказчик попросил реализовать следующий функционал:
детальный просмотр статей;
аутентификация и авторизация пользователей;
просмотр списка статей с возможностью перехода к детальному просмотру;
редактирование статей;
удаление статей;
просмотр списка пользователей;


1---------------------Создаем базу данных в дополнении к предыдущей
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('visitor', 'moderator', 'admin') DEFAULT 'visitor'
);

CREATE TABLE articles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  author_id INT,
  FOREIGN KEY (author_id) REFERENCES users(id)
);


2----------------------Код в index.js (сюда не буду добавлять он большой

				Postman

3--------------------Регистрации пользователя: http://localhost:3010/register
4--------------------Ввод логина и пароля из connection.js
5--------------------Получение токена "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsInJvbGUiOiJ2aXNpdG9yIiwiaWF0IjoxNzIyODkyMzQ1LCJleHAiOjE3MjI4OTU5NDV9.GdERHUmJ9liMIDG1kGZPjOPe7-H3u4XgNAb9pjj_Wj0"
}
6--------------------Получить статью http://localhost:3010/articles
7--------------------Получить статью по ID http://localhost:3010/article/1
8--------------------Редактирование статьи
9--------------------Удаление статьи
10-------------------Список пользователей (для админа)  http://localhost:3010/users  нужно добаить токен админа
11-------------------Роль пользователя (для администратора) http://localhost:3010/user/2/role тоже с токеном
