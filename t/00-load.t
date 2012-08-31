#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Backup::Verify' ) || print "Bail out!\n";
}

diag( "Testing Backup::Verify $Backup::Verify::VERSION, Perl $], $^X" );
