/*
README
1.版本顺序需要从小到大排列
2.默认产品名称为当前
*/

DELIMITER $$$$$$
/*
* 创建数据库配置表
* db_conf表结构：
* id --- version --- feature --- product --- remark---update_time
* 主键   版本         功能        产品       备注      更新时间
*/
 CREATE TABLE IF NOT EXISTS db_conf  (
		`id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
		`version` float(8) NULL COMMENT '版本',
		`feature` varchar(16) NULL COMMENT '功能',
		`product` varchar(32) NULL COMMENT '产品',
		`remark` varchar(255) NULL COMMENT '备注',
		`update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`id`)
 );

/*
*创建函数
*判断数据表名是否存在的函数
*/
DROP FUNCTION IF EXISTS TABLE_EXISTS;
CREATE  FUNCTION  TABLE_EXISTS(table_name text) RETURNS boolean 
BEGIN
    IF EXISTS(
        SELECT 1 FROM information_schema.TABLES 
            WHERE TABLE_SCHEMA = (SELECT DATABASE()) AND TABLE_NAME = table_name
        ) THEN RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

/*
* 获取数据库版本的函数
*
*/
DROP FUNCTION IF EXISTS GET_DB_VERSION;
CREATE  FUNCTION  GET_DB_VERSION () RETURNS float  
BEGIN
    DECLARE current_version float DEFAULT 0;
    IF (SELECT TABLE_EXISTS('db_conf') IS FALSE) THEN
        RETURN current_version;
    ELSEIF EXISTS(SELECT 1 FROM db_conf) THEN
				SELECT version INTO current_version FROM db_conf WHERE feature = 'db_version';
				RETURN current_version;
		ELSE
			  RETURN current_version;       
    END IF;
END;


/*
* 更新数据库版本
*/
DROP   PROCEDURE   IF  EXISTS  UPDATE_DB_VERSION;
CREATE  PROCEDURE UPDATE_DB_VERSION(version float) 
BEGIN
    IF EXISTS(SELECT 1 FROM db_conf WHERE feature='db_version') THEN
        UPDATE db_conf SET version=version,update_time=now()  WHERE feature='db_version';
    ELSE
        INSERT INTO db_conf (version,feature,remark) VALUES(version,'db_version','脚本升级');
    END IF;
END;

-- ------------------------------数据库每个版本按从小到大排列------------------------------------------------
/*
* 版本初始模板
↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
-- 1.0开始
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
CREATE  PROCEDURE DB_UPGRADE(version float) 
BEGIN
    IF( GET_DB_VERSION() < version) THEN
-- ------------SQL语句起始线---------------
        

-- ------------SQL语句结束线-------------------
        CALL UPDATE_DB_VERSION(version);
    END IF;
END;
CALL DB_UPGRADE(1);
-- 1.0结束
↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
*
*/

-- 1.0开始
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
CREATE  PROCEDURE DB_UPGRADE(version float) 
BEGIN
    IF( GET_DB_VERSION() < version) THEN
-- ------------SQL语句起始线---------------
        CREATE TABLE user  (
            `id` int NOT NULL,
            `v` varchar(255) NULL,
            `va` varchar(255) NULL,
            `vcasd` varchar(255) NULL,
            `dsdsa` varchar(255) NULL,
            PRIMARY KEY (`id`)
            );
        
        CREATE TABLE users  (
            `id` int NOT NULL,
            `v` varchar(255) NULL,
            `va` varchar(255) NULL,
            `vcasd` varchar(255) NULL,
            `dsdsa` varchar(255) NULL,
            PRIMARY KEY (`id`)
            );

        CREATE TABLE usersss  (
            `id` int NOT NULL,
            `v` varchar(255) NULL,
            `va` varchar(255) NULL,
            `vcasd` varchar(255) NULL,
            `dsdsa` varchar(255) NULL,
            PRIMARY KEY (`id`)
            );

-- ------------SQL语句结束线-------------------
        CALL UPDATE_DB_VERSION(version);
    END IF;
END;
CALL DB_UPGRADE(1);
-- 1.0结束


-- 1.1开始
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
CREATE  PROCEDURE DB_UPGRADE(version float) 
BEGIN
    IF( GET_DB_VERSION() < version) THEN
-- ------------SQL语句起始线---------------
        CREATE TABLE usersss_ss (
            `id` int NOT NULL,
            `v` varchar(255) NULL,
            `va` varchar(255) NULL,
            `vcasd` varchar(255) NULL,
            `dsdsa` varchar(255) NULL,
            PRIMARY KEY (`id`)
            );
        ALTER TABLE usersss
        CHANGE COLUMN `va` `vasa` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `v`,
        CHANGE COLUMN `dsdsa` `dsdsaa` time NULL DEFAULT NULL AFTER `vcasd`;


-- ------------SQL语句结束线-------------------
        CALL UPDATE_DB_VERSION(version);
    END IF;
END;
CALL DB_UPGRADE(1.1);
-- 1.1结束


-- ---------------------------------脚本结束区域------------------------------------------------------

-- ------------固定->清除过程和函数-----------------
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
DROP  PROCEDURE  IF  EXISTS  UPDATE_DB_VERSION;
DROP FUNCTION IF EXISTS GET_DB_VERSION;
DROP FUNCTION IF EXISTS TABLE_EXISTS;
$$$$$$;