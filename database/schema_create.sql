-- MySQL script to create Friend’s Pet List database schema
-- Generated on 2025-05-23

-- 1. Create database
DROP DATABASE IF EXISTS `friend_pet_app`;
CREATE DATABASE IF NOT EXISTS `friend_pet_app`
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_unicode_ci;
USE `friend_pet_app`;

-- 2. Core tables

-- 2.1 Users
CREATE TABLE `users` (
  `user_id`       CHAR(36)      NOT NULL,
  `username`      VARCHAR(100)  NOT NULL,
  `password_hash` VARCHAR(255)  NOT NULL,
  `created_at`    DATETIME      NOT NULL,
  `updated_at`    DATETIME      NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.2 Friends
CREATE TABLE `friends` (
  `friend_id`      CHAR(36)                                         NOT NULL,
  `user_id`        CHAR(36)                                         NOT NULL,
  `first_name`     VARCHAR(100)                                     NOT NULL,
  `last_name`      VARCHAR(100)                                     NOT NULL,
  `gender`         ENUM('Male','Female','Other')                    DEFAULT NULL,
  `dob`            DATE                                           DEFAULT NULL,
  `description`    TEXT                                           DEFAULT NULL,
  `audit_user_id`  CHAR(36)                                         NOT NULL,
  `audit_timestamp` DATETIME                                       NOT NULL,
  `audit_action`   ENUM('CREATE','UPDATE','DELETE')                NOT NULL,
  PRIMARY KEY (`friend_id`),
  KEY `fk_friends_user` (`user_id`),
  CONSTRAINT `fk_friends_user` FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.3 Pets
CREATE TABLE `pets` (
  `pet_id`         CHAR(36)                                         NOT NULL,
  `friend_id`      CHAR(36)                                         NOT NULL,
  `pet_type`       VARCHAR(100)                                     NOT NULL,
  `breed`          VARCHAR(100)                                   DEFAULT NULL,
  `name`           VARCHAR(100)                                     NOT NULL,
  `dob`            DATE                                           DEFAULT NULL,
  `description`    TEXT                                           DEFAULT NULL,
  `audit_user_id`  CHAR(36)                                         NOT NULL,
  `audit_timestamp` DATETIME                                       NOT NULL,
  `audit_action`   ENUM('CREATE','UPDATE','DELETE')                NOT NULL,
  PRIMARY KEY (`pet_id`),
  KEY `fk_pets_friend` (`friend_id`),
  CONSTRAINT `fk_pets_friend` FOREIGN KEY (`friend_id`)
    REFERENCES `friends` (`friend_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. History tables

-- 3.1 Friends history
CREATE TABLE `friends_history` (
  `history_id`      BIGINT      NOT NULL AUTO_INCREMENT,
  `friend_id`       CHAR(36)    NOT NULL,
  `user_id`         CHAR(36)    NOT NULL,
  `first_name`      VARCHAR(100) NOT NULL,
  `last_name`       VARCHAR(100) NOT NULL,
  `gender`          ENUM('Male','Female','Other') DEFAULT NULL,
  `dob`             DATE       DEFAULT NULL,
  `description`     TEXT       DEFAULT NULL,
  `audit_user_id`   CHAR(36)    NOT NULL,
  `audit_timestamp` DATETIME    NOT NULL,
  `audit_action`    ENUM('CREATE','UPDATE','DELETE') NOT NULL,
  `operation_by`    CHAR(36)    NOT NULL,
  `operation_ts`    DATETIME    NOT NULL,
  `operation_type`  ENUM('CREATE','UPDATE','DELETE') NOT NULL,
  PRIMARY KEY (`history_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3.2 Pets history
CREATE TABLE `pets_history` (
  `history_id`      BIGINT      NOT NULL AUTO_INCREMENT,
  `pet_id`          CHAR(36)    NOT NULL,
  `friend_id`       CHAR(36)    NOT NULL,
  `pet_type`        VARCHAR(100) NOT NULL,
  `breed`           VARCHAR(100) DEFAULT NULL,
  `name`            VARCHAR(100) NOT NULL,
  `dob`             DATE       DEFAULT NULL,
  `description`     TEXT       DEFAULT NULL,
  `audit_user_id`   CHAR(36)    NOT NULL,
  `audit_timestamp` DATETIME    NOT NULL,
  `audit_action`    ENUM('CREATE','UPDATE','DELETE') NOT NULL,
  `operation_by`    CHAR(36)    NOT NULL,
  `operation_ts`    DATETIME    NOT NULL,
  `operation_type`  ENUM('CREATE','UPDATE','DELETE') NOT NULL,
  PRIMARY KEY (`history_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Triggers to populate history tables
DELIMITER //
-- Friends INSERT
CREATE TRIGGER `trg_friends_after_insert`
AFTER INSERT ON `friends`
FOR EACH ROW
BEGIN
  INSERT INTO `friends_history` (
    friend_id, user_id, first_name, last_name, gender, dob, description,
    audit_user_id, audit_timestamp, audit_action,
    operation_by, operation_ts, operation_type
  ) VALUES (
    NEW.friend_id, NEW.user_id, NEW.first_name, NEW.last_name, NEW.gender, NEW.dob, NEW.description,
    NEW.audit_user_id, NEW.audit_timestamp, NEW.audit_action,
    NEW.audit_user_id, NEW.audit_timestamp, 'CREATE'
  );
END;
//

-- Friends UPDATE
CREATE TRIGGER `trg_friends_after_update`
AFTER UPDATE ON `friends`
FOR EACH ROW
BEGIN
  INSERT INTO `friends_history` (
    friend_id, user_id, first_name, last_name, gender, dob, description,
    audit_user_id, audit_timestamp, audit_action,
    operation_by, operation_ts, operation_type
  ) VALUES (
    NEW.friend_id, NEW.user_id, NEW.first_name, NEW.last_name, NEW.gender, NEW.dob, NEW.description,
    NEW.audit_user_id, NEW.audit_timestamp, NEW.audit_action,
    NEW.audit_user_id, NEW.audit_timestamp, 'UPDATE'
  );
END;
//

-- Friends DELETE
CREATE TRIGGER `trg_friends_after_delete`
AFTER DELETE ON `friends`
FOR EACH ROW
BEGIN
  INSERT INTO `friends_history` (
    friend_id, user_id, first_name, last_name, gender, dob, description,
    audit_user_id, audit_timestamp, audit_action,
    operation_by, operation_ts, operation_type
  ) VALUES (
    OLD.friend_id, OLD.user_id, OLD.first_name, OLD.last_name, OLD.gender, OLD.dob, OLD.description,
    OLD.audit_user_id, OLD.audit_timestamp, OLD.audit_action,
    OLD.audit_user_id, OLD.audit_timestamp, 'DELETE'
  );
END;
//

-- Pets INSERT
CREATE TRIGGER `trg_pets_after_insert`
AFTER INSERT ON `pets`
FOR EACH ROW
BEGIN
  INSERT INTO `pets_history` (
    pet_id, friend_id, pet_type, breed, name, dob, description,
    audit_user_id, audit_timestamp, audit_action,
    operation_by, operation_ts, operation_type
  ) VALUES (
    NEW.pet_id, NEW.friend_id, NEW.pet_type, NEW.breed, NEW.name, NEW.dob, NEW.description,
    NEW.audit_user_id, NEW.audit_timestamp, NEW.audit_action,
    NEW.audit_user_id, NEW.audit_timestamp, 'CREATE'
  );
END;
//

-- Pets UPDATE
CREATE TRIGGER `trg_pets_after_update`
AFTER UPDATE ON `pets`
FOR EACH ROW
BEGIN
  INSERT INTO `pets_history` (
    pet_id, friend_id, pet_type, breed, name, dob, description,
    audit_user_id, audit_timestamp, audit_action,
    operation_by, operation_ts, operation_type
  ) VALUES (
    NEW.pet_id, NEW.friend_id, NEW.pet_type, NEW.breed, NEW.name, NEW.dob, NEW.description,
    NEW.audit_user_id, NEW.audit_timestamp, NEW.audit_action,
    NEW.audit_user_id, NEW.audit_timestamp, 'UPDATE'
  );
END;
//

-- Pets DELETE
CREATE TRIGGER `trg_pets_after_delete`
AFTER DELETE ON `pets`
FOR EACH ROW
BEGIN
  INSERT INTO `pets_history` (
    pet_id, friend_id, pet_type, breed, name, dob, description,
    audit_user_id, audit_timestamp, audit_action,
    operation_by, operation_ts, operation_type
  ) VALUES (
    OLD.pet_id, OLD.friend_id, OLD.pet_type, OLD.breed, OLD.name, OLD.dob, OLD.description,
    OLD.audit_user_id, OLD.audit_timestamp, OLD.audit_action,
    OLD.audit_user_id, OLD.audit_timestamp, 'DELETE'
  );
END;
//
DELIMITER ;
