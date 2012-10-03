use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok( 'Backup::Verify' ) || print "Bail out!\n";
}
diag( "Testing Backup::Verify $Backup::Verify::VERSION, Perl $], $^X" );

# they have to be defined in Backup/Verify.pm
ok( defined &Backup::Verify::get_files, 'get_files is defined' );
ok( defined &Backup::Verify::gen_md5sum, 'gen_md5sum is defined' );

################
# test get_files
my $dir = '/tmp/blah';
my $percentage = 0.1;

# 0 files
system "rm -rf $dir";
is( &Backup::Verify::get_files( $dir, $percentage ), 0, "get_files($dir, $percentage)" );

# 1 file
mkdir $dir;
system "touch $dir/file";
is( &Backup::Verify::get_files( $dir, $percentage ), 1, "get_files($dir, $percentage)" );

# 99 files
for my $n ( 1 .. 99 ) {
    system "touch $dir/file$n";
}
is( &Backup::Verify::get_files( $dir, $percentage ), 10, "get_files($dir, $percentage)" );

done_testing;
