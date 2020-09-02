-- MySQL dump 10.13  Distrib 8.0.21, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: myflaskapp
-- ------------------------------------------------------
-- Server version	5.7.25-google

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `myflaskapp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `myflaskapp` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `myflaskapp`;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `author` varchar(100) DEFAULT NULL,
  `body` text,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (2,'PyZine','bradt','<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sit amet eros at nisi condimentum malesuada finibus ac lectus. Nullam congue accumsan ante nec consectetur. Aenean at sollicitudin enim. Nam sed turpis pellentesque metus ullamcorper semper nec non sem. Nulla hendrerit leo eget sapien mollis venenatis. Ut consectetur augue vel nulla faucibus rhoncus. Nullam mattis arcu hendrerit ex pretium, ac laoreet sem ultrices. Aliquam tellus mi, iaculis at elit id, eleifend consequat odio. Donec varius dui enim, at maximus eros sagittis ac. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean ullamcorper sodales eros, id laoreet metus scelerisque ut.</p>\r\n\r\n<p>Phasellus vel volutpat orci. Phasellus vitae vehicula mi. Interdum et malesuada fames ac ante ipsum primis in faucibus. Curabitur dignissim elit sed purus consequat tincidunt et ut nibh. Ut sit amet tellus elit. Nam consequat quam id enim sodales, ac bibendum neque rutrum. Aenean faucibus purus nec sodales efficitur. Maecenas dolor est, tincidunt sed auctor sit amet, bibendum sed orci. Aenean tempor vestibulum est nec egestas. Integer vitae ante tincidunt, aliquet odio ut, aliquet nisi. Praesent vel nulla vel elit vestibulum venenatis. Aenean sollicitudin augue et velit lacinia vestibulum. Integer eleifend metus et nisi consectetur, nec faucibus libero malesuada. Nullam vehicula, urna vel lacinia ullamcorper, felis nibh tempor lectus, quis gravida lorem dolor sit amet ante. Ut ac dapibus ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>\r\n\r\n<p>Donec pulvinar eu dui id luctus. Etiam viverra arcu et euismod rutrum. Etiam efficitur felis vel ligula tincidunt, et posuere risus ultrices. Praesent vehicula lacus ac purus bibendum, at semper urna vulputate. Nullam id dui risus. Donec eleifend nisl vel vehicula scelerisque. In consectetur felis vel orci posuere pellentesque. Nulla consectetur pellentesque metus quis convallis. Donec sed tempus felis, consectetur tincidunt sapien. Nullam fermentum sit amet magna a sagittis. Integer ullamcorper vehicula convallis. Pellentesque sit amet lorem id est sagittis varius ut vitae metus. Duis nunc erat, hendrerit in sem mollis, blandit molestie lorem.</p>\r\n','2020-08-31 12:03:10');
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `username` varchar(30) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `register_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Brad Traversy','brad@traversy.com','bradt','$5$rounds=535000$VcQrgJBGPWTT6gur$FkTO3g/tNiMjI7AaPujzspM12PY6gUyLVc4nKkJFphA','2020-09-01 01:58:01');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-09-01 10:10:38
