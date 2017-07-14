=end
1) Дан текст с включенными в него тегами следующего вида:
[НАИМЕНОВАНИЕ_ТЕГА:описание]данные[/НАИМЕНОВАНИЕ_ТЕГА]
На выходе нужно получить 2 массива:
Первый:
* Ключ - наименование тега
* Значение - данные 
Второй:
* Ключ - наименование тега
* Значение - описание

Вложенность тегов не допускается.
Описания может и не быть
Обезателен закрвающий тег
=cut

use strict ;
use warnings ;
use locale ;
use utf8 ;
use Perl::Critic ;
use Data::Dumper ;

# настройка ввода\вывода
( $\ , $/ ) = "\n" ;


# загрузка данных
my $str = <DATA> ;

# результирующие массивы
my ( %array1 , %array2 ) ;

( $array1{ $1 } , $array2{ $1 } ) = ( $3 , $2 ) while $str =~ m{
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
}cusgx ;

print( &Dumper( \%array1 , \%array2 ) ) ;

__DATA__
[tag1:comment1]da
ta1[/tag1]tex]t1
[tag2:comm

ent2]dat
a2[/tag2]text2
[tag3]data3[/tag3]text3 text4[
[тег-1:comm ent4data4[/tag4[tag4:comment4]data4[/тег-1]