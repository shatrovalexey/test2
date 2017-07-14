/*
3) Дана таблица в базе MySQL с полями:
    id  - ключ
    name  имя,
    parent ссылка на id родителя,

Данную таблицу нужно заполнить рандомными значениями, но так что бы получилось дерево с несколькими (от 0 до 5) уровнями вложенности

Реализовать алгоритм выводящий это дерево, вида:
EEE
  ->KK
  ->LK
RE
LO
  ->EW

*/

DROP TABLE IF EXISTS `tree` ;

/*
Создаю таблицу и заполняю произвольными данными
*/
CREATE TABLE IF NOT EXISTS `tree` (
	`node_id` INT( 11 ) UNSIGNED NOT null AUTO_INCREMENT
		COMMENT 'идентификатор' ,
	`parent_id` INT( 11 ) UNSIGNED NOT null DEFAULT 0
		COMMENT 'родительский элемент'  ,
	`name` VARCHAR( 3 ) NOT null
		COMMENT 'название' ,

	PRIMARY KEY( `node_id` )
) ENGINE=InnoDB
COMMENT 'дерево'
AS
SELECT
	md5( uuid( ) ) AS `name`
FROM
	/*
		`mysql`.`proc` - количество таблиц может варьироваться, в зависимости от нужного количества записей.
	*/
	`mysql`.`proc` AS `p1` ,
	`mysql`.`proc` AS `p2` ,
	`mysql`.`proc` AS `p3` ,
	`mysql`.`proc` AS `p4`
LIMIT 100000 ; -- допустим, максимальное требуемое количество записей = 1e5

-- реальное количество записей в таблице дерева
SET @`g_count` := (
	SELECT
		count( * ) AS `count`
	FROM
		`tree` AS `t1`
) ;

-- произвольно размещаю узлы в дереве
UPDATE
	`tree` AS `t1`
SET
	`parent_id` := floor( rand( ) * @`g_count` ) ;

-- добавляю индексы, которые понадобятся для работы
ALTER TABLE `tree`
	ADD `parents` TEXT NOT null COMMENT 'путь к узлу' ,

	ADD INDEX( `parent_id` ) COMMENT 'родитель' ,
    ADD FULLTEXT INDEX( `parents` ) COMMENT 'путь по дереву' ;

-- если узел - родитель сам себя, то считать, что у узла нет родителя
UPDATE
	`tree` AS `t1`
SET
	`t1`.`parent_id` := 0
WHERE
	( `t1`.`parent_id` = `t1`.`node_id` ) ;

-- если у узла нет родителя, то в поле parent_id должно быть указано 0
UPDATE
	`tree` AS `t1`

	LEFT OUTER JOIN `tree` AS `t2` ON
    ( `t1`.`parent_id` = `t2`.`node_id` )
SET
	`t1`.`parent_id` := 0
WHERE
	( `t2`.`node_id` IS null ) ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `pu_tree_parents` $$

/*
Создаю процедуру, чтобы заполнить пути в поле `parents`
*/
CREATE PROCEDURE `pu_tree_parents`( )
BEGIN
	DECLARE `v_i` INT( 11 ) UNSIGNED DEFAULT 100 ;
	DECLARE `v_parent_id` INT( 11 ) UNSIGNED DEFAULT 0 ;

	/*
		вот такая проблема, приходится переливать из одной таблицы в другую данные
	*/
	DROP TEMPORARY TABLE IF EXISTS `t_tree1` ;
	DROP TEMPORARY TABLE IF EXISTS `t_tree2` ;

	CREATE TEMPORARY TABLE IF NOT EXISTS `t_tree1`(
		`node_id` INT( 11 ) UNSIGNED NOT null ,
		PRIMARY KEY( `node_id` )
	) Engine = Memory
	AS
	SELECT
		`t1`.`node_id`
    FROM
		`tree` AS `t1`
	WHERE
		( `t1`.`parent_id` = `v_parent_id` ) ;

	UPDATE
		`tree` AS `t1`
	SET
		`t1`.`parents` := `t1`.`node_id`
	WHERE
		( `t1`.`parent_id` = `v_parent_id` ) ;

	CREATE TEMPORARY TABLE IF NOT EXISTS `t_tree2` LIKE `t_tree1` ;

	l1: LOOP
		UPDATE
			`tree` AS `t1`

			INNER JOIN `tree` AS `t2` ON
            ( `t1`.`parent_id` = `t2`.`node_id` )

			INNER JOIN `t_tree1` AS `tt1` ON
			( `t2`.`node_id` = `tt1`.`node_id` )
		SET
			`t1`.`parents` := concat_ws( ',' , `t2`.`parents` , `t1`.`node_id` ) ;

		IF ( row_count( ) <= 0 ) THEN
			LEAVE l1 ;
		END IF ;

		SET `v_i` := `v_i` - 1 ;

		IF ( NOT `v_i` ) THEN
			LEAVE l1 ;
		END IF ;

		INSERT INTO
			`t_tree2`(
				`node_id`
			)
		SELECT
			`t1`.`node_id`
		FROM
			`tree` AS `t1`

			INNER JOIN `t_tree1` AS `tt1` ON
			( `t1`.`parent_id` = `tt1`.`node_id` ) ;

		DELETE
			`tt1`.*
		FROM
			`t_tree1` AS `tt1` ;

		INSERT INTO
			`t_tree1`(
				`node_id`
			)
		SELECT
			`tt1`.`node_id`
		FROM
			`t_tree2` AS `tt1` ;

		DELETE
			`tt1`.*
		FROM
			`t_tree2` AS `tt1` ;
	END LOOP ;

	DROP TEMPORARY TABLE IF EXISTS `t_tree1` ;
	DROP TEMPORARY TABLE IF EXISTS `t_tree2` ;

	UPDATE
		`tree` AS `t1`
	SET
		`t1`.`parents` := substring( `t1`.`parents` FROM 2 ) ;
END $$

DELIMITER ;

-- вызываю процедуру
CALL `pu_tree_parents`( ) ;

-- инициализация данных окончена, дальше - PHP-код