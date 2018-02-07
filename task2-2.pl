=end
2) Дан текст в который включены ключи raz: dva: tri:
текст может располагаться как перед ключами так и после
 
На выходе нужно получить массив, 
где ключ это raz , dva , tri, а ДАННЫЕ - текст раполагающийся после ключа до следующего ключа или до конца текста, если не встретился ключ. 
Очередность ключей может быть – произвльная. Если в тексте ключ встречается второй раз - в массиве он должен быть переписан.
В решении должны использоваться регулярки.
=cut

use strict ;
use warnings ;
use locale ;
use utf8 ;
use Data::Dumper ;

# настройка ввода\вывода
( $\ , $/ ) = "\n" ;

# возможные ключи
my $keys = qr{(?:raz|dva|tri)\:}os ;

# заполнение результата
my %result = map {
	my $result = $_ ;

	map {
		substr( $_ , 0 , -1 ) => $result->{ $_ } ;
	} keys( %$result ) ;
} + {
	<DATA> =~ m{
		(
			$keys # тег
		) (
			.+? # данные
		) (?=
			$keys # следующий тег
			|
			$ # или конец строки
		)
	}gusix
} ;

# вывод результата
print( &Dumper( \%result ) ) ;

__DATA__
dsfsdfee
wrwerewrdraz:dsfsd feewrw
erewrddva:dsfsdf eewrwe rewrddva:dsfsdfe ew^*(rwerew
rdraz:dsfs df%^&*9eewrwerew rdtri:ds **((fsdfeewrwerewrd
