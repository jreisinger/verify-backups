#!/usr/bin/perl

use strict;
use warnings;
use POSIX;  # core module, for numbers rounding

use Test::More;

use_ok('Backup::Test');

my $dir = '/data/home';
my $percentage = 0.1;
my @return = Backup::Test::get_files($dir, $percentage);
my $total_files_number = shift @return;
my @sample_files = @return;
is(scalar @sample_files, ceil($percentage * $total_files_number), 'Return expected number of files');

TODO: {
  local $TODO = 'lebo';
  #is(Math::Base4::add4(1,1), 2, '1+1 = 2');
  #is(Math::Base4::add4(2,2), 10, '2+2 = 10');
  #is(Math::Base4::add4(3,2), 10, '3+2 = 11');
}

done_testing();
