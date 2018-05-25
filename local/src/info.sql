CREATE DATABASE secret;
USE secret;

CREATE TABLE `info` (
  `id` CHAR(20) NOT NULL,
  `secret` CHAR(50) NOT NULL
);

INSERT INTO `info` VALUES ('0001','very very secret information!');
