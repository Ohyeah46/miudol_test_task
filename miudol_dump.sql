-- MariaDB dump 10.19  Distrib 10.6.12-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: miudol
-- ------------------------------------------------------
-- Server version	10.6.12-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `news`
--
-- Удаляем таблицу `users`
DROP TABLE IF EXISTS users;

-- Удаляем таблицу `articles`
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS `news`;
USE miudol;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
-- Создание таблицы пользователей
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('visitor', 'moderator', 'admin') DEFAULT 'visitor'
);

-- Создание таблицы статей
CREATE TABLE articles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  author_id INT,
  FOREIGN KEY (author_id) REFERENCES users(id)
);


CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL COMMENT 'Название статьи',
  `text` longtext NOT NULL COMMENT 'Текст статьи',
  `author` varchar(100) NOT NULL COMMENT 'Автор статьи',
  `picture_id` int(11) NOT NULL COMMENT 'ID изображения к статье',
  PRIMARY KEY (`id`),
  KEY `news_FK` (`picture_id`),
  CONSTRAINT `news_FK` FOREIGN KEY (`picture_id`) REFERENCES `pictures` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,'Экономия энергии: простые советы для вашего дома','Экономия энергии - важный аспект заботы об окружающей среде и сохранения природных ресурсов. Вот несколько простых советов, которые помогут снизить энергопотребление в вашем доме:\n1.Используйте энергосберегающие приборы и лампы.\n2.Установите регуляторы температуры на комфортную для вас отметку.\n3.Устраните утечки тепла, утеплив окна и двери.\n4.Отключайте электронику и бытовую технику, когда она не используется.\n5.Используйте энергосберегающие режимы на бытовой технике.\nСледуя этим советам, вы сможете значительно снизить энергопотребление и сэкономить на коммунальных платежах.','Иван Иванов',1),(2,'Лучшие стратегии для успешной сдачи экзаменов','Хотите успешно сдать экзамены? Следуйте этим простым стратегиям:\n1.Изучайте материалы систематически и регулярно.\n2.Повторяйте материал через короткие промежутки времени для лучшего запоминания.\n3.Делайте перерывы во время учебы для улучшения концентрации.\n4.Практикуйте тестовые техники, такие как выделение ключевых идей и составление конспектов.\n5.Поддерживайте хороший сон и питание для оптимального уровня энергии и концентрации.','Сергей Сергеев',2),(3,'Топ-10 фильмов, которые стоит посмотреть на выходных','Устроить домашний кинотеатр проще, чем кажется. Вот список из 10 фильмов разных жанров, которые заслуживают вашего внимания:\n1.Интерстеллар (Sci-Fi)\n2.Побег из Шоушенка (Драма)\n3.Один дома (Комедия)\n4.Темный рыцарь (Боевик)\n5.Хатико: Самый верный друг (Драма)\n6.Матрица (Боевик, Научная фантастика)\n7.Жизнь прекрасна (Драма, Комедия)\n8.Бойцовский клуб (Драма, Триллер)\n9.Зеленая миля (Драма, Фэнтези)\n10.Форрест Гамп (Драма, Комедия)','Владимир Владимиров',3),(4,'Удивительные факты о нашей солнечном системе','Наша солнечная система состоит из 8 планет, каждая из которых уникальна и имеет свои особенности. Например, Юпитер - самая большая планета, а Венера - самая горячая. Сатурн славится своими великолепными кольцами, а Уран - лежит на боку из-за сильного ветра. Марс имеет два спутника, Фобос и Деймос, которые напоминают луну Земли. Меркурий - самая близкая к Солнцу планета, а Нептун - самая дальняя.','Алексей Алексеев',4),(5,'Как правильно питаться: основы здорового рациона','Правильное питание – основа здорового образа жизни и успешного снижения веса. Вот несколько простых правил, которые помогут вам составить полезный рацион:\n1.Разнообразие: включайте в меню продукты из всех пищевых групп.\n2.Сбалансированность: учитывайте калорийность и состав продуктов.\n3.Соблюдение режима: питайтесь регулярно, небольшими порциями.\n4.Питьевой режим: выпивайте не менее 1,5-2 литров воды в день.\n5.Контроль порций: избегайте переедания и чувства голода.\nСоблюдая эти несложные правила, вы сможете обеспечить организм всеми необходимыми питательными веществами и поддерживать здоровый вес.','Александр Александров',5);
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pictures`
--

DROP TABLE IF EXISTS `pictures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Имя изображения',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pictures`
--

LOCK TABLES `pictures` WRITE;
/*!40000 ALTER TABLE `pictures` DISABLE KEYS */;
INSERT INTO `pictures` VALUES (1,'first.jpg'),(2,'second.jpg'),(3,'third.jpg'),(4,'fourth.jpg'),(5,'fifth.jpg');
/*!40000 ALTER TABLE `pictures` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-03-13 21:32:19

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
--DROP PROCEDURE IF EXISTS GetArticleById;

SHOW TABLES;
SELECT * 
