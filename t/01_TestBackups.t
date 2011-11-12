#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use_ok('Backup::Test');

my $dir = '/data/home';
my $num = 10;
is(Backup::Test::get_files($dir, $num), $num, 'Return expected number of files');

TODO: {
  local $TODO = 'lebo';
  #is(Math::Base4::add4(1,1), 2, '1+1 = 2');
  #is(Math::Base4::add4(2,2), 10, '2+2 = 10');
  #is(Math::Base4::add4(3,2), 10, '3+2 = 11');
}

done_testing();
