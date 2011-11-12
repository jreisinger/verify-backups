package Backup::Test;

use warnings;
use strict;
use File::Find; # core module

our $VERSION = '0.010';

use Exporter 'import';
our @EXPORT_OK = qw(get_files);

sub get_files {
  my $dir = shift;
  my $num = shift;

  my @files;
  # get just files, not directories
  find(sub { push @files, $File::Find::name if -f; }, "$dir");
  
  my @sample_files;
  for ( @files ) {
    push @sample_files, $_;
    last if @sample_files >= $num;
  }

  return scalar(@sample_files);
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
