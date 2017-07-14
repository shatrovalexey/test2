<?php
	/*
	3) Дана таблица в базе MySQL с полями:
		id  - ключ
		name  имя,
		parent ссылка на id родителя,

	Данную таблицу нужно заполнить рандомными значениями, но так что бы получилось дерево с несколькими (от 0 до 5) уровнями вложенности

	Реализовать алгоритм выводящий это дерево, вида:
	...
	*/

	/*
	Перед выполнением скрипта необходимо выполнить task3.sql
	*/

	// подключение
	$dbh = new mysqli( 'localhost' , 'root' , 'passwd' , 'test' ) ;

	// запрашиваю упорядоченный список узлов
	$sth = $dbh->query( "
SELECT
	`t1`.`node_id` ,
	`t1`.`name` ,
	`t1`.`parents`
	-- для больших объёмов не перспективно
	-- , find_in_set( `t1`.`node_id` , `t1`.`parents` ) AS `index`
FROM
	`tree` AS `t1`
ORDER BY
	4 ASC ;
	" ) ;

	while ( $row = $sth->fetch_assoc( ) ) {
		$path = explode( ',' , $row[ 'parents' ] ) ;
		$index = array_search( $row[ 'node_id' ] , $path ) ;
		$tabs = str_repeat( "\t" , $index ) ;

		echo $tabs . $row[ 'name' ] . PHP_EOL ;
	}

	$sth->close( ) ;
	$dbh->close( ) ;