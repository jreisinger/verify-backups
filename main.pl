#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Backup::Test;

my $verbose = 0;  # FIXME - make verbose command line option

my $dir = '/data/home/';
my $backup_dir = '/cloud_backup/hourly.0/localhost/';
my @returned = Backup::Test::get_files($dir, 0.01);
my $total_files = shift @returned;
my @files = @returned;

my $checked = 0;
my $ok = 0;
my @not_ok;
for my $file ( @files ) {
  print "Working on: $file\n" if $verbose;
  my($filename, $directories, $suffix) = fileparse $file; # $file has file with full path
  my $backup_directories = $directories;
  $backup_directories =~ s#^#$backup_dir#;
  # FIXME: make '/' more portable
  if ( Backup::Test::gen_md5sum("$directories/$filename") eq Backup::Test::gen_md5sum("$backup_directories/$filename") ) {
    $ok++;
  } else {
    push @not_ok, $file;
  }
  $checked++;
}

# Statistics
print "-" x 70, "\n";
print "Checked $checked files out of $total_files total files\n";
print "Backed up correctly: $ok\n";
print "Backed up in-correctly: ", scalar @not_ok, "\n";
print map { "  $_\n" } @not_ok;
