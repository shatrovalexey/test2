my @rows ;

while ( <DATA> ) {
	s{^\s+|\s+$}{}gos ;

	push( @rows , [
		keys( %{
			{
				map {
					$_ => undef( )
				} split( m{\s+}os , $_ )
			} # hash ref
		} ) # keys
	] ) ; #push
}

for ( my $i = 0 ; $i < @rows ; $i ++ ) {
	foreach my $val1 ( @{ $rows[ $i ] } ) {
		l1:for ( my $j = 0 ; $j < @rows ; $j ++ ) {
			next( ) if $i == $j ;

			print( $val1 , ' ' ) ;

			foreach my $val2 ( @{ $rows[ $j ] } ) {
				print( $val2 , ' ' ) ;
				last( ) ;
			}
		}
		print( "\n" ) ;
	}
}

__END__
а1 а2 а3
b1 b2
c1 c2 c3
d1