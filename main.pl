#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Backup::Test;

my $dir = '/var/tmp/x';
my $backup_dir = '/tmp/backup/x';
my @returned = Backup::Test::get_files($dir, 0.1);
my $total_files = shift @returned;
my @files = @returned;

for my $file ( @files ) {
  my $backup_file = basename $file;
  unless ( Backup::Test::gen_md5sum($file) eq Backup::Test::gen_md5sum("$backup_dir/$backup_file") ) {
    print "File '$file' not backed up properly\n";
  }
}

print "Total files: $total_files\n";

print "$_ ", Backup::Test::gen_md5sum($_), "\n" for @files;
