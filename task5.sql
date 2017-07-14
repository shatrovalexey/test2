/*
5) Из таблицы из задания 3 сделать выборку записей без потомков, но с 2-мя старшими родителями
*/

DROP TEMPORARY TABLE IF EXISTS `t_tree` ;

/*
Связывать три большие таблицы, да ещё, в одном случае, по LEFT, не хочется.
Поэтому, создаю временную таблицу.
*/
CREATE TEMPORARY TABLE IF NOT EXISTS `t_tree`(
	PRIMARY KEY( `node_id` )
) Engine = Memory
COMMENT 'узлы дерева, имеющие >=2х родителей'
AS
SELECT
	`t2`.`node_id`
FROM
	`tree` AS `t1`

	INNER JOIN `tree` AS `t2` ON
	( `t1`.`node_id` = `t2`.`parent_id` )
WHERE
	( `t1`.`parent_id` <> 0 )
GROUP BY
	1 ;

/*
Вывод результатов
*/
SELECT
	`t1`.`node_id`
FROM
	`t_tree` AS `t1`

	LEFT OUTER JOIN `tree` AS `t2` ON
	( `t1`.`node_id` = `t2`.`parent_id` )
WHERE
	( `t2`.`node_id` IS null ) ;

DROP TEMPORARY TABLE IF EXISTS `t_tree` ;