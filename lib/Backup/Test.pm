package Backup::Test;

use warnings;
use strict;
use File::Find;           # core module
use Digest::MD5 qw(md5_hex);  # core module

our $VERSION = '0.010';

use Exporter 'import';
our @EXPORT_OK = qw(get_files gen_md5sum);

sub get_files {
  # return total number of files in $dir  and the percentage of files
  my $dir = shift;        # dir to search for files
  my $percentage = shift; # percentage of files to return

  my @files;
  # get just files, not directories
  find(sub { push @files, $File::Find::name if -f; }, "$dir");

  # calculate the percentage
  my $total_files_number = scalar @files;
  my $sample_files_number = $total_files_number * $percentage;
  
  # get the sample files
  my @sample_files;
  for ( @files ) {
    last if @sample_files > $sample_files_number or $sample_files_number == 0;
    push @sample_files, $_;
  }

  return $total_files_number, @sample_files;
}

sub gen_md5sum {
  my $file = shift;
  open(FILE, $file) or die "Can't open '$file': $!";
  binmode(FILE);

  my $md5 = Digest::MD5->new;
  while (<FILE>) {
    $md5->add($_);
  }
  close(FILE);
  return $md5->hexdigest;
}

1;


__END__

=head1 NAME

Math::Base4 - Base 4 calculations

=head1 SYNOPSIS

  use Math::Base4 qw(add4);
  
  print add4(2,2);
  # 10

=head1 DESCRIPTION

FIXME please

=head1 AUTHOR

BA.pm

=cut
