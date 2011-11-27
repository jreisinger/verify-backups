#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(ceil);  # core module, for numbers rounding
use Test::More;

# Test and load module
use_ok('Backup::Test');

# Original dir
my $dir = '/data/home';

# Test number of returned files
for my $percentage ( 0, 0.1, 0.3 ) {
  my @returned = Backup::Test::get_files($dir, $percentage);
  my $total_files_number = shift @returned;
  my @sample_files = @returned;
  my $expected = ceil($percentage * $total_files_number);
  is(scalar @sample_files, $expected, "Return expected number of files - $expected (sample) out of $total_files_number (total files)");
}

# Test MD5 message digest (checksum)
{
  my @returned = Backup::Test::get_files($dir, 0.1);
  my $total_files_number = shift @returned;
  my @sample_files = @returned;
  for my $file ( @sample_files[0,1,2] ) {  # pick first 3 files
    last unless $file;                     # one or more of the 3 files may be undef
    
    # should be more portable FIXME
    my $md5sum = `/usr/bin/md5sum $file`;
    chomp $md5sum;
    $md5sum =~ s/\s+.*$//;                 # remove file name
    
    is(Backup::Test::gen_md5sum($file), $md5sum, "MD5 checksum of '$file'");
  }
}

done_testing();
