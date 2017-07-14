<?php
	// данные
	$str = 'dsfsdfee
wrwerewrdraz:dsfsd feewrw
erewrddva:dsfsdf eewrwe rewrddva:dsfsdfe ew^*(rwerew
rdraz:dsfs df%^&*9eewrwerew rdtri:ds **((fsdfeewrwerewrd' ;

	// рег. выр.
	$rx = '{(raz|dva|tri)\:}uis' ;

	// разбираю строку по рег.выр. на массив
	$array = preg_split( $rx , $str ) ;
	array_shift( $array ) ;

	// результирующий массив
	$result = array( ) ;

	// заполняю результирующий массив
	preg_replace_callback( $rx , function( $matches ) use( &$result , &$array ) {
		$result[ $matches[ 1 ] ] = array_shift( $array ) ;

		return null ;
	} ,$str ) ;

	// вывод результата
	print_r( $result ) ;