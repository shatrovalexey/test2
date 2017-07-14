<?php
	// данные

	$str = '
[tag1:comment1]da
ta1[/tag1]tex]t1
[tag2:comm

ent2]dat
a2[/tag2]text2
[tag3]data3[/tag3]text3 text4[
[тег-1:comm ent4data4[/tag4[tag4:comment4]data4[/тег-1]
	' ;

	// результирующие массивы

	$result1 = $result2 = array( ) ;

	// поиск данных

	preg_replace_callback( '{
	\[
		( # имя тега
			[^\:]+
		)
		(?: # комментарий
			\:(.+?)
		)?
	\]
		( # данные
			.+?
		)
	\[/ # закрывающий тег
		\1
	\]
	}uxs' , function( $matches ) use( &$result1 , &$result2 ) {
		$result1[ $matches[ 1 ] ] = $matches[ 3 ] ;
		$result2[ $matches[ 1 ] ] = $matches[ 2 ] ;

		return null ;
	} , $str ) ;

	print_r( $result1 ) ;
	print_r( $result2 ) ;