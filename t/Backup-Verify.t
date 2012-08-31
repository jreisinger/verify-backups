use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok( 'Backup::Verify' ) || print "Bail out!\n";
}
diag( "Testing Backup::Verify $Backup::Verify::VERSION, Perl $], $^X" );

# they have to be defined in Animal.pm
ok( defined &Backup::Verify::get_files, 'get_files is defined' );
ok( defined &Backup::Verify::gen_md5sum, 'gen_md5sum is defined' );

################
# test get_files
my $dir = '/blah';
my $percentage = 0.1;
is( &Backup::Verify::get_files( $dir, $percentage ), 0, "get_files($dir, $percentage)" );


done_testing;
