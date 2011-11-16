#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Backup::Test;

my $verbose = 1;  # FIXME - make verbose command line option

my $dir = '/var/tmp/x';
my $backup_dir = '/var/tmp/backup/x';
my @returned = Backup::Test::get_files($dir, 0.1);
my $total_files = shift @returned;
my @files = @returned;

my $checked = 0;
my $ok = 0;
my $not_ok = 0;
for my $file ( @files ) {
  print "Working on: $file\n" if $verbose;
  my($filename, $directories, $suffix) = fileparse $file; # $file has file with full path
  my $backup_directories = $directories;
  $backup_directories =~ s#$dir#$backup_dir#;
  # FIXME: make '/' more portable
  if ( Backup::Test::gen_md5sum("$directories/$filename") eq Backup::Test::gen_md5sum("$backup_directories/$filename") ) {
    $ok++;
  } else {
    print "File '$file' not backed up properly\n";
    $not_ok++;
  }
  $checked++;
}

print "-" x 70, "\n";
print "Checked $checked files out of $total_files total files\n";
print "Backed up correctly: $ok\n";
print "Backed up in-correctly: $not_ok\n";