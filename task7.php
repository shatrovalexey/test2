<?php
	$str = 'а1 а2 а3
b1 b2
c1 c2 c3
d1' ;

	$rows = array( ) ;
	$row_poses = array( ) ;
	$results = array( ) ;

	foreach ( preg_split( '{[\r\n]+}' , $str ) as $i => $row ) {
		$row = array_filter( preg_split( '{\s+}' , $row ) ) ;
		$rows[] = $row ;
		$row_poses[] = 0 ;
	}

	$pos = 0 ;

	while ( true ) {
		$break = false ;
		$result = array( ) ;

		foreach ( $rows as $i => &$row ) {
			$row_pos = &$row_poses[ $i ] ;

			if ( $break ) {
				$row_pos ++ ;
				$break = false ;
			}
			if ( $row_pos[ $i ] >= count( $row ) ) {
				$row_pos = 0 ;
				$break = true ;
			}

			$result[] = $row[ $row_pos[ $i ] ] ;
		}

		if ( $break ) {
			break ;
		}

		$results[] = $result ;
		$row_pos[ 0 ] ++ ;
		$pos ++ ;
	}

	return $results ;