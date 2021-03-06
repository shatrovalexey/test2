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
use Perl::Critic ;
use Data::Dumper ;

# настройка ввода\вывода
( $\ , $/ ) = "\n" ;

# загрузка данных
my $str = <DATA> ;

# рег.выр. для поиска
my $rx = qr((raz|dva|tri)\:)uis ;

# результат
my %result ;

# разбираю строку по рег.выр. на массив
my ( undef( ) , @array ) = split( $rx , $str ) ;

# заполняю результирующий массив
$result{ $1 } = shift( @array ) while $str =~ m{$rx}gc ;

# вывод результата
print( &Dumper( \%result ) ) ;

__DATA__
dsfsdfee
wrwerewrdraz:dsfsd feewrw
erewrddva:dsfsdf eewrwe rewrddva:dsfsdfe ew^*(rwerew
rdraz:dsfs df%^&*9eewrwerew rdtri:ds **((fsdfeewrwerewrd