#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Backup::Verify;

do "main.cfg";

for my $dir ( sort keys %bak_dir ) {
  &verify_backups( $dir, $bak_dir{$dir}, $percentage );
}

sub verify_backups {
  my $dir = shift;
  my $backup_dir = shift;
  my $percentage = shift;

  my @returned = Backup::Verify::get_files($dir, $percentage);
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
    if ( Backup::Verify::gen_md5sum("$directories/$filename") eq Backup::Verify::gen_md5sum("$backup_directories/$filename") ) {
      $ok++;
    } else {
      push @not_ok, $file;
    }
    $checked++;
  }

  # Statistics
  print "-" x 70, "\n";
  print "Checked $checked files out of $total_files total files for '$dir'\n";
  print "Backed up correctly: $ok\n";
  print "Backed up in-correctly: ", scalar @not_ok, "\n";
  print map { "  $_\n" } @not_ok;
}
