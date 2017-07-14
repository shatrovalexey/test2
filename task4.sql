/*
4) Из таблицы из задания 3 сделать выборку записей без родителей, с тремя и более потомками
*/

SET @`min_children_count` := 3 ;

SELECT
	`t1`.`node_id`
FROM
	`tree` AS `t1`

    INNER JOIN `tree` AS `t2` ON
    ( `t2`.`parent_id` = `t1`.`node_id` )
WHERE
	( `t1`.`parent_id` = 0 )
GROUP BY
	1
HAVING
	( count( * ) >= @`min_children_count` ) ;