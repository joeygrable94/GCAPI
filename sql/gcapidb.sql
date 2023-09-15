-- MySQL Script generated by MySQL Workbench
-- Fri Sep 15 14:02:08 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema gcapidb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema gcapidb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `gcapidb` DEFAULT CHARACTER SET utf8mb4 ;
USE `gcapidb` ;

-- -----------------------------------------------------
-- Table `gcapidb`.`bdx_feed`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`bdx_feed` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `serverhost` VARCHAR(255) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`bdx_feed` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `username_UNIQUE` ON `gcapidb`.`bdx_feed` (`username` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`client` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `title` VARCHAR(96) NOT NULL,
  `content` VARCHAR(255) NULL,
  PRIMARY KEY (`title`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`client` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `title_UNIQUE` ON `gcapidb`.`client` (`title` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`client_bucket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`client_bucket` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `description` VARCHAR(255) NULL,
  `bucket_name` VARCHAR(100) NOT NULL,
  `object_key` VARCHAR(255) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`bucket_name`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`client_bucket` (`id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`client_bucket` (`client_id` ASC) VISIBLE;

CREATE UNIQUE INDEX `object_key_UNIQUE` ON `gcapidb`.`client_bucket` (`object_key` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`client_website`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`client_website` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `client_id` CHAR(32) NOT NULL,
  `website_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`client_website` (`id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`client_website` (`website_id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`client_website` (`client_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`file_asset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`file_asset` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `name` VARCHAR(96) NOT NULL,
  `extension` VARCHAR(255) NOT NULL,
  `size_kb` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` VARCHAR(500) NULL,
  `tags` BLOB NULL,
  `is_private` TINYINT(1) NOT NULL DEFAULT 0,
  `user_id` CHAR(32) NOT NULL,
  `bucket_id` CHAR(32) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  `geocoord_id` CHAR(32) NULL,
  `bdx_feed_id` CHAR(32) NULL,
  PRIMARY KEY (`name`),
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `gcapidb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `bucket_id`
    FOREIGN KEY (`bucket_id`)
    REFERENCES `gcapidb`.`client_bucket` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `geocoord_id`
    FOREIGN KEY (`geocoord_id`)
    REFERENCES `gcapidb`.`geocoord` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `bdx_feed_id`
    FOREIGN KEY (`bdx_feed_id`)
    REFERENCES `gcapidb`.`bdx_feed` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`file_asset` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `name_UNIQUE` ON `gcapidb`.`file_asset` (`name` ASC) VISIBLE;

CREATE INDEX `user_id_idx` ON `gcapidb`.`file_asset` (`user_id` ASC) VISIBLE;

CREATE INDEX `bucket_id_idx` ON `gcapidb`.`file_asset` (`bucket_id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`file_asset` (`client_id` ASC) VISIBLE;

CREATE INDEX `geocoord_id_idx` ON `gcapidb`.`file_asset` (`geocoord_id` ASC) VISIBLE;

CREATE INDEX `bdx_feed_id_idx` ON `gcapidb`.`file_asset` (`bdx_feed_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`gcft`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`gcft` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `group_name` VARCHAR(255) NOT NULL,
  `group_slug` VARCHAR(12) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`group_slug`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`gcft` (`id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`gcft` (`client_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`gcft_snap`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`gcft_snap` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `snap_name` VARCHAR(255) NOT NULL,
  `snap_slug` VARCHAR(12) NOT NULL,
  `altitude` INT NULL,
  `gcft_id` CHAR(32) NOT NULL,
  `image_id` CHAR(32) NOT NULL,
  `geocoord_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`snap_slug`),
  CONSTRAINT `gcft_id`
    FOREIGN KEY (`gcft_id`)
    REFERENCES `gcapidb`.`gcft` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `image_id`
    FOREIGN KEY (`image_id`)
    REFERENCES `gcapidb`.`file_asset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `geocoord_id`
    FOREIGN KEY (`geocoord_id`)
    REFERENCES `gcapidb`.`geocoord` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`gcft_snap` (`id` ASC) VISIBLE;

CREATE INDEX `gcft_id_idx` ON `gcapidb`.`gcft_snap` (`gcft_id` ASC) VISIBLE;

CREATE INDEX `image_id_idx` ON `gcapidb`.`gcft_snap` (`image_id` ASC) VISIBLE;

CREATE INDEX `geocoord_id_idx` ON `gcapidb`.`gcft_snap` (`geocoord_id` ASC) VISIBLE;

CREATE UNIQUE INDEX `snap_slug_UNIQUE` ON `gcapidb`.`gcft_snap` (`snap_slug` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`gcft_snap_activeduration`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`gcft_snap_activeduration` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `session_id` CHAR(32) NOT NULL,
  `active_seconds` INT NOT NULL,
  `visit_date` DATETIME NOT NULL,
  `gcft_id` CHAR(32) NOT NULL,
  `snap_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gcft_id`
    FOREIGN KEY (`gcft_id`)
    REFERENCES `gcapidb`.`gcft` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `snap_id`
    FOREIGN KEY (`snap_id`)
    REFERENCES `gcapidb`.`gcft_snap` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`gcft_snap_activeduration` (`id` ASC) VISIBLE;

CREATE INDEX `gcft_id_idx` ON `gcapidb`.`gcft_snap_activeduration` (`gcft_id` ASC) VISIBLE;

CREATE INDEX `snap_id_idx` ON `gcapidb`.`gcft_snap_activeduration` (`snap_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`gcft_snap_browserreport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`gcft_snap_browserreport` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `session_id` CHAR(32) NOT NULL,
  `browser` VARCHAR(255) NULL,
  `browser_version` VARCHAR(255) NULL,
  `platform` VARCHAR(255) NULL,
  `platform_version` VARCHAR(255) NULL,
  `desktop` TINYINT(1) NULL,
  `tablet` TINYINT(1) NULL,
  `mobile` TINYINT(1) NULL,
  `city` VARCHAR(255) NULL,
  `country` VARCHAR(255) NULL,
  `state` VARCHAR(255) NULL,
  `language` VARCHAR(255) NULL,
  `visit_date` DATETIME NOT NULL,
  `gcft_id` CHAR(32) NOT NULL,
  `snap_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gcft_id`
    FOREIGN KEY (`gcft_id`)
    REFERENCES `gcapidb`.`gcft` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `snap_id`
    FOREIGN KEY (`snap_id`)
    REFERENCES `gcapidb`.`gcft_snap` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`gcft_snap_browserreport` (`id` ASC) VISIBLE;

CREATE INDEX `gcft_id_idx` ON `gcapidb`.`gcft_snap_browserreport` (`gcft_id` ASC) VISIBLE;

CREATE INDEX `snap_id_idx` ON `gcapidb`.`gcft_snap_browserreport` (`snap_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`gcft_snap_hotspotclick`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`gcft_snap_hotspotclick` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `session_id` CHAR(32) NOT NULL,
  `reporting_id` CHAR(32) NULL,
  `hotspot_type_name` VARCHAR(32) NULL,
  `hotspot_content` LONGTEXT NULL,
  `hotspot_icon_name` VARCHAR(255) NULL,
  `hotspot_name` VARCHAR(255) NULL,
  `hotspot_user_icon_name` VARCHAR(255) NULL,
  `linked_snap_name` VARCHAR(255) NULL,
  `snap_file_name` VARCHAR(255) NULL,
  `icon_color` VARCHAR(32) NULL,
  `bg_color` VARCHAR(32) NULL,
  `text_color` VARCHAR(32) NULL,
  `hotspot_update_date` DATETIME NOT NULL,
  `click_date` DATETIME NOT NULL,
  `gcft_id` CHAR(32) NOT NULL,
  `snap_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gcft_id`
    FOREIGN KEY (`gcft_id`)
    REFERENCES `gcapidb`.`gcft` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `snap_id`
    FOREIGN KEY (`snap_id`)
    REFERENCES `gcapidb`.`gcft_snap` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`gcft_snap_hotspotclick` (`id` ASC) VISIBLE;

CREATE INDEX `gcft_id_idx` ON `gcapidb`.`gcft_snap_hotspotclick` (`gcft_id` ASC) VISIBLE;

CREATE INDEX `snap_id_idx` ON `gcapidb`.`gcft_snap_hotspotclick` (`snap_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`gcft_snap_trafficsource`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`gcft_snap_trafficsource` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `session_id` CHAR(32) NOT NULL,
  `referrer` LONGTEXT NOT NULL,
  `utm_campaign` VARCHAR(255) NULL,
  `utm_content` VARCHAR(255) NULL,
  `utm_medium` VARCHAR(255) NULL,
  `utm_source` VARCHAR(255) NULL,
  `utm_term` VARCHAR(255) NULL,
  `visit_date` DATETIME NOT NULL,
  `gcft_id` CHAR(32) NOT NULL,
  `snap_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gcft_id`
    FOREIGN KEY (`gcft_id`)
    REFERENCES `gcapidb`.`gcft` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `snap_id`
    FOREIGN KEY (`snap_id`)
    REFERENCES `gcapidb`.`gcft_snap` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`gcft_snap_trafficsource` (`id` ASC) VISIBLE;

CREATE INDEX `gcft_id_idx` ON `gcapidb`.`gcft_snap_trafficsource` (`gcft_id` ASC) VISIBLE;

CREATE INDEX `snap_id_idx` ON `gcapidb`.`gcft_snap_trafficsource` (`snap_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`gcft_snap_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`gcft_snap_view` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `session_id` CHAR(32) NOT NULL,
  `view_date` DATETIME NOT NULL,
  `gcft_id` CHAR(32) NOT NULL,
  `snap_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gcft_id`
    FOREIGN KEY (`gcft_id`)
    REFERENCES `gcapidb`.`gcft` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `snap_id`
    FOREIGN KEY (`snap_id`)
    REFERENCES `gcapidb`.`gcft_snap` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`gcft_snap_view` (`id` ASC) VISIBLE;

CREATE INDEX `gcft_id_idx` ON `gcapidb`.`gcft_snap_view` (`gcft_id` ASC) VISIBLE;

CREATE INDEX `snap_id_idx` ON `gcapidb`.`gcft_snap_view` (`snap_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`geocoord`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`geocoord` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `address` VARCHAR(255) NOT NULL,
  `latitude` FLOAT NOT NULL,
  `longitude` FLOAT NOT NULL,
  PRIMARY KEY (`address`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`geocoord` (`id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_a4`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_a4` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `title` VARCHAR(255) NOT NULL,
  `measurement_id` CHAR(16) NOT NULL,
  `property_id` CHAR(16) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  `website_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`measurement_id`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_a4` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `title_UNIQUE` ON `gcapidb`.`go_a4` (`title` ASC) VISIBLE;

CREATE UNIQUE INDEX `measurement_id_UNIQUE` ON `gcapidb`.`go_a4` (`measurement_id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`go_a4` (`client_id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`go_a4` (`website_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_a4_stream`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_a4_stream` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `title` VARCHAR(255) NOT NULL,
  `stream_id` CHAR(16) NOT NULL,
  `ga4_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`stream_id`),
  CONSTRAINT `ga4_id`
    FOREIGN KEY (`ga4_id`)
    REFERENCES `gcapidb`.`go_a4` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_a4_stream` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `title_UNIQUE` ON `gcapidb`.`go_a4_stream` (`title` ASC) VISIBLE;

CREATE UNIQUE INDEX `stream_id_UNIQUE` ON `gcapidb`.`go_a4_stream` (`stream_id` ASC) VISIBLE;

CREATE INDEX `ga4_id_idx` ON `gcapidb`.`go_a4_stream` (`ga4_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_cloud`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_cloud` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `project_name` VARCHAR(255) NOT NULL,
  `hashed_api_key` VARCHAR(64) NOT NULL,
  `hashed_project_id` VARCHAR(64) NOT NULL,
  `hashed_project_number` VARCHAR(64) NOT NULL,
  `hashed_service_account` VARCHAR(64) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`project_name`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_cloud` (`id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`go_cloud` (`client_id` ASC) VISIBLE;

CREATE UNIQUE INDEX `project_name_UNIQUE` ON `gcapidb`.`go_cloud` (`project_name` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_sc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_sc` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `title` VARCHAR(255) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  `website_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_sc` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `title_UNIQUE` ON `gcapidb`.`go_sc` (`title` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`go_sc` (`client_id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`go_sc` (`website_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_sc_country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_sc_country` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `keys` BLOB NOT NULL,
  `clicks` INT NOT NULL,
  `impressions` INT NOT NULL,
  `ctr` FLOAT NOT NULL,
  `position` FLOAT NOT NULL,
  `date_start` DATETIME NOT NULL,
  `date_end` DATETIME NOT NULL,
  `gsc_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gsc_id`
    FOREIGN KEY (`gsc_id`)
    REFERENCES `gcapidb`.`go_sc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_sc_country` (`id` ASC) VISIBLE;

CREATE INDEX `gsc_id_idx` ON `gcapidb`.`go_sc_country` (`gsc_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_sc_device`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_sc_device` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `keys` BLOB NOT NULL,
  `clicks` INT NOT NULL,
  `impressions` INT NOT NULL,
  `ctr` FLOAT NOT NULL,
  `position` FLOAT NOT NULL,
  `date_start` DATETIME NOT NULL,
  `date_end` DATETIME NOT NULL,
  `gsc_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gsc_id`
    FOREIGN KEY (`gsc_id`)
    REFERENCES `gcapidb`.`go_sc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_sc_device` (`id` ASC) VISIBLE;

CREATE INDEX `gsc_id_idx` ON `gcapidb`.`go_sc_device` (`gsc_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_sc_page`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_sc_page` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `keys` BLOB NOT NULL,
  `clicks` INT NOT NULL,
  `impressions` INT NOT NULL,
  `ctr` FLOAT NOT NULL,
  `position` FLOAT NOT NULL,
  `date_start` DATETIME NOT NULL,
  `date_end` DATETIME NOT NULL,
  `gsc_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gsc_id`
    FOREIGN KEY (`gsc_id`)
    REFERENCES `gcapidb`.`go_sc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_sc_page` (`id` ASC) VISIBLE;

CREATE INDEX `gsc_id_idx` ON `gcapidb`.`go_sc_page` (`gsc_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_sc_query`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_sc_query` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `keys` BLOB NOT NULL,
  `clicks` INT NOT NULL,
  `impressions` INT NOT NULL,
  `ctr` FLOAT NOT NULL,
  `position` FLOAT NOT NULL,
  `date_start` DATETIME NOT NULL,
  `date_end` DATETIME NOT NULL,
  `gsc_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gsc_id`
    FOREIGN KEY (`gsc_id`)
    REFERENCES `gcapidb`.`go_sc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_sc_query` (`id` ASC) VISIBLE;

CREATE INDEX `gsc_id_idx` ON `gcapidb`.`go_sc_query` (`gsc_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_sc_searchappearance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_sc_searchappearance` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `keys` BLOB NOT NULL,
  `clicks` INT NOT NULL,
  `impressions` INT NOT NULL,
  `ctr` FLOAT NOT NULL,
  `position` FLOAT NOT NULL,
  `date_start` DATETIME NOT NULL,
  `date_end` DATETIME NOT NULL,
  `gsc_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `gsc_id`
    FOREIGN KEY (`gsc_id`)
    REFERENCES `gcapidb`.`go_sc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_sc_searchappearance` (`id` ASC) VISIBLE;

CREATE INDEX `gsc_id_idx` ON `gcapidb`.`go_sc_searchappearance` (`gsc_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_ua`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_ua` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `title` VARCHAR(255) NOT NULL,
  `tracking_id` CHAR(16) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  `website_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`tracking_id`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_ua` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `title_UNIQUE` ON `gcapidb`.`go_ua` (`title` ASC) VISIBLE;

CREATE UNIQUE INDEX `tracking_id_UNIQUE` ON `gcapidb`.`go_ua` (`tracking_id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`go_ua` (`client_id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`go_ua` (`website_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`go_ua_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`go_ua_view` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `title` VARCHAR(255) NOT NULL,
  `view_id` CHAR(16) NOT NULL,
  `gua_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`view_id`),
  CONSTRAINT `gua_id`
    FOREIGN KEY (`gua_id`)
    REFERENCES `gcapidb`.`go_ua` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`go_ua_view` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `title_UNIQUE` ON `gcapidb`.`go_ua_view` (`title` ASC) VISIBLE;

CREATE UNIQUE INDEX `view_id_UNIQUE` ON `gcapidb`.`go_ua_view` (`view_id` ASC) VISIBLE;

CREATE INDEX `gua_id_idx` ON `gcapidb`.`go_ua_view` (`gua_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`ipaddress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`ipaddress` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `address` VARCHAR(40) NOT NULL,
  `isp` VARCHAR(255) NOT NULL DEFAULT 'unknown',
  `location` TEXT NOT NULL DEFAULT 'unknown',
  `geocoord_id` CHAR(32) NULL,
  PRIMARY KEY (`address`),
  CONSTRAINT `geocoord_id`
    FOREIGN KEY (`geocoord_id`)
    REFERENCES `gcapidb`.`geocoord` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`ipaddress` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `address_UNIQUE` ON `gcapidb`.`ipaddress` (`address` ASC) VISIBLE;

CREATE INDEX `geocoord_id_idx` ON `gcapidb`.`ipaddress` (`geocoord_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`note`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`note` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `title` VARCHAR(96) NOT NULL,
  `content` VARCHAR(255) NULL,
  `user_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`title`),
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `gcapidb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`note` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `title_UNIQUE` ON `gcapidb`.`note` (`title` ASC) VISIBLE;

CREATE INDEX `user_id_idx` ON `gcapidb`.`note` (`user_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`sharpspring`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`sharpspring` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `hashed_api_key` VARCHAR(64) NOT NULL,
  `hashed_secret_key` VARCHAR(64) NOT NULL,
  `client_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`sharpspring` (`id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`sharpspring` (`client_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`user` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `auth_id` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `is_verified` TINYINT(1) NOT NULL DEFAULT 0,
  `is_superuser` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`auth_id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`user` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `username_UNIQUE` ON `gcapidb`.`user` (`username` ASC) VISIBLE;

CREATE UNIQUE INDEX `oauth_key_UNIQUE` ON `gcapidb`.`user` (`auth_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`user_client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`user_client` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `client_id` CHAR(32) NOT NULL,
  `user_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `gcapidb`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `gcapidb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`user_client` (`id` ASC) VISIBLE;

CREATE INDEX `client_id_idx` ON `gcapidb`.`user_client` (`client_id` ASC) VISIBLE;

CREATE INDEX `user_id_idx` ON `gcapidb`.`user_client` (`user_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`user_ipaddress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`user_ipaddress` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `ipaddress_id` CHAR(32) NOT NULL,
  `user_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ipaddress_id`
    FOREIGN KEY (`ipaddress_id`)
    REFERENCES `gcapidb`.`ipaddress` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `gcapidb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`user_ipaddress` (`id` ASC) VISIBLE;

CREATE INDEX `user_id_idx` ON `gcapidb`.`user_ipaddress` (`user_id` ASC) VISIBLE;

CREATE INDEX `ipaddress_id_idx` ON `gcapidb`.`user_ipaddress` (`ipaddress_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`website`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`website` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `domain` VARCHAR(255) NOT NULL,
  `is_secure` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`domain`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`website` (`id` ASC) VISIBLE;

CREATE UNIQUE INDEX `domain_UNIQUE` ON `gcapidb`.`website` (`domain` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`website_keywordcorpus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`website_keywordcorpus` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `corpus` BLOB NOT NULL,
  `rawtext` BLOB NOT NULL,
  `website_id` CHAR(32) NOT NULL,
  `page_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `page_id`
    FOREIGN KEY (`page_id`)
    REFERENCES `gcapidb`.`website_page` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`website_keywordcorpus` (`id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`website_keywordcorpus` (`website_id` ASC) VISIBLE;

CREATE INDEX `page_id_idx` ON `gcapidb`.`website_keywordcorpus` (`page_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`website_map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`website_map` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `url` VARCHAR(2048) NOT NULL,
  `website_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`website_map` (`id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`website_map` (`website_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`website_page`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`website_page` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `url` VARCHAR(2048) NOT NULL,
  `status` INT NOT NULL,
  `priority` FLOAT NOT NULL,
  `last_modified` DATETIME NULL,
  `change_frequency` VARCHAR(64) NULL,
  `website_id` CHAR(32) NOT NULL,
  `sitemap_id` CHAR(32) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sitemap_id`
    FOREIGN KEY (`sitemap_id`)
    REFERENCES `gcapidb`.`website_map` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`website_page` (`id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`website_page` (`website_id` ASC) VISIBLE;

CREATE INDEX `sitemap_id_idx` ON `gcapidb`.`website_page` (`sitemap_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gcapidb`.`website_pagespeedinsights`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gcapidb`.`website_pagespeedinsights` (
  `id` CHAR(32) NOT NULL,
  `created_on` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP),
  `updated_on` DATETIME GENERATED ALWAYS AS (ON UPDATE CURRENT_TIMESTAMP),
  `strategy` VARCHAR(16) NOT NULL,
  `ps_weight` INT NOT NULL DEFAULT 100,
  `ps_grade` FLOAT NOT NULL DEFAULT 0.0,
  `ps_value` VARCHAR(4) NOT NULL DEFAULT '0%',
  `ps_unit` VARCHAR(16) NOT NULL DEFAULT 'percent',
  `fcp_weight` INT NOT NULL DEFAULT 10,
  `fcp_grade` FLOAT NOT NULL DEFAULT 0.0,
  `fcp_value` FLOAT NOT NULL DEFAULT 0.0,
  `fcp_unit` VARCHAR(16) NOT NULL DEFAULT 'miliseconds',
  `lcp_weight` INT NOT NULL DEFAULT 25,
  `lcp_grade` FLOAT NOT NULL DEFAULT 0.0,
  `lcp_value` FLOAT NOT NULL DEFAULT 0.0,
  `lcp_unit` VARCHAR(16) NOT NULL DEFAULT 'miliseconds',
  `cls_weight` INT NOT NULL DEFAULT 15,
  `cls_grade` FLOAT NOT NULL DEFAULT 0.0,
  `cls_value` FLOAT NOT NULL DEFAULT 0.0,
  `cls_unit` VARCHAR(16) NOT NULL DEFAULT 'unitless',
  `si_weight` INT NOT NULL DEFAULT 10,
  `si_grade` FLOAT NOT NULL DEFAULT 0.0,
  `si_value` FLOAT NOT NULL DEFAULT 0.0,
  `si_unit` VARCHAR(16) NOT NULL DEFAULT 'miliseconds',
  `tbt_weight` INT NOT NULL DEFAULT 30,
  `tbt_grade` FLOAT NOT NULL DEFAULT 0.0,
  `tbt_value` FLOAT NOT NULL DEFAULT 0.0,
  `tbt_unit` VARCHAR(16) NOT NULL DEFAULT 'miliseconds',
  `website_id` CHAR(32) NOT NULL,
  `page_id` CHAR(32) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `website_id`
    FOREIGN KEY (`website_id`)
    REFERENCES `gcapidb`.`website` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `page_id`
    FOREIGN KEY (`page_id`)
    REFERENCES `gcapidb`.`website_page` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_UNIQUE` ON `gcapidb`.`website_pagespeedinsights` (`id` ASC) VISIBLE;

CREATE INDEX `website_id_idx` ON `gcapidb`.`website_pagespeedinsights` (`website_id` ASC) VISIBLE;

CREATE INDEX `page_id_idx` ON `gcapidb`.`website_pagespeedinsights` (`page_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
