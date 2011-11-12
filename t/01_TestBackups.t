#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(ceil);  # core module, for numbers rounding
use Test::More;

# Test and load module
use_ok('Backup::Test');

# Original dir
my $dir = '/var/tmp/x';

# Test number of returned files
for my $percentage ( 0, 0.1, 0.3 ) {
  my @returned = Backup::Test::get_files($dir, $percentage);
  my $total_files_number = shift @returned;
  my @sample_files = @returned;
  is(scalar @sample_files, ceil($percentage * $total_files_number), 'Return expected number of files');
}

# Test MD5 message digest (checksum)
for my $file ( qw( /etc/passwd /etc/hosts /etc/group ) ) {
  my $md5sum = `/usr/bin/md5sum $file`;
  chomp $md5sum;
  $md5sum =~ s/\s+.*$//;  # remove file name
  is(Backup::Test::gen_md5sum($file), $md5sum, "MD5 checksum of '$file'");
}

done_testing();
