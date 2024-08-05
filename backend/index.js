const mysql = require("mysql2");
const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");

const connectionParams = require("./connection.js");

// Конфигурация
const JWT_SECRET = "your_jwt_secret"; // Замените на ваш секретный ключ для JWT
const PORT = process.env.PORT || 3010;
const app = express();
app.use(bodyParser.json()); // Для парсинга JSON

const connectionParam = connectionParams();
const connection = mysql.createConnection(connectionParam);

// Запросы к базе данных
const getArticleByIdQuery = "CALL GetArticleById(?)";
const getAllNews = "SELECT * FROM news";

// Регистрация
app.post("/register", async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: "Username and password required" });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    await connection.promise().query(
      "INSERT INTO users (username, password) VALUES (?, ?)",
      [username, hashedPassword]
    );
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Вход
app.post("/login", async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: "Username and password required" });
  }

  try {
    const [rows] = await connection.promise().query(
      "SELECT * FROM users WHERE username = ?",
      [username]
    );

    if (rows.length === 0) {
      return res.status(401).json({ error: "Invalid username or password" });
    }

    const user = rows[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({ error: "Invalid username or password" });
    }

    const token = jwt.sign({ userId: user.id, role: user.role }, JWT_SECRET, { expiresIn: '1h' });
    res.json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Middleware для проверки токена
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) return res.sendStatus(401);

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);

    req.user = user;
    next();
  });
}

// Получение всех статей
app.get("/articles", async (req, res) => {
  try {
    const [rows] = await connection.promise().query(getAllNews);
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Получение статьи по идентификатору
app.get("/article/:id", authenticateToken, (req, res) => {
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

    res.json(results[0][0]);
  });
});

// Редактирование статьи
app.put("/article/:id", authenticateToken, async (req, res) => {
  const articleId = parseInt(req.params.id);
  const { title, content } = req.body;

  if (isNaN(articleId)) {
    return res.status(400).json({ error: "Invalid article ID" });
  }

  try {
    const [articleRows] = await connection.promise().query(
      "SELECT * FROM articles WHERE id = ?",
      [articleId]
    );

    if (articleRows.length === 0) {
      return res.status(404).json({ error: "Article not found" });
    }

    const article = articleRows[0];
    
    if (req.user.role !== 'admin' && req.user.role !== 'moderator' || article.author_id !== req.user.userId) {
      return res.status(403).json({ error: "Permission denied" });
    }

    await connection.promise().query(
      "UPDATE articles SET title = ?, content = ? WHERE id = ?",
      [title, content, articleId]
    );

    res.json({ message: "Article updated successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Удаление статьи
app.delete("/article/:id", authenticateToken, async (req, res) => {
  const articleId = parseInt(req.params.id);

  if (isNaN(articleId)) {
    return res.status(400).json({ error: "Invalid article ID" });
  }

  try {
    const [articleRows] = await connection.promise().query(
      "SELECT * FROM articles WHERE id = ?",
      [articleId]
    );

    if (articleRows.length === 0) {
      return res.status(404).json({ error: "Article not found" });
    }

    const article = articleRows[0];
    
    if (req.user.role !== 'admin' && req.user.role !== 'moderator' || article.author_id !== req.user.userId) {
      return res.status(403).json({ error: "Permission denied" });
    }

    await connection.promise().query(
      "DELETE FROM articles WHERE id = ?",
      [articleId]
    );

    res.json({ message: "Article deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Просмотр списка пользователей
app.get("/users", authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: "Permission denied" });
  }

  connection.query("SELECT id, username, role FROM users", (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database query error" });
    }

    res.json(results);
  });
});

// Изменение роли пользователя
app.put("/user/:id/role", authenticateToken, async (req, res) => {
  const userId = parseInt(req.params.id);
  const { role } = req.body;

  if (isNaN(userId) || !['visitor', 'moderator', 'admin'].includes(role)) {
    return res.status(400).json({ error: "Invalid user ID or role" });
  }

  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: "Permission denied" });
  }

  try {
    await connection.promise().query(
      "UPDATE users SET role = ? WHERE id = ?",
      [role, userId]
    );

    res.json({ message: "User role updated successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Запуск сервера
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));