package Backup::Verify;

use 5.006;
use strict;
use warnings;
use File::Find;             # core module
use Digest::MD5;            # core module
use List::Util qw(shuffle); # core module - to randomize list

=head1 NAME

Animal - The great new Animal!

=head1 VERSION

Version 0.010

=cut

our $VERSION = '0.010';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Animal;

    my $foo = Animal->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=cut

use vars qw($VERSION @ISA @EXPORT_OK);
use Exporter 'import';
our @EXPORT_OK = qw(get_files gen_md5sum);

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub get_files {
  # return total number of files in $dir and the percentage of files
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
  for ( shuffle @files ) {  # randomize order of files
    last if @sample_files >= $sample_files_number or $sample_files_number == 0;
    push @sample_files, $_;
  }

  return $total_files_number, @sample_files;
}

sub gen_md5sum {
  # Generate MD5 checksum
  my $file = shift;
  eval { open(FILE, "$file") or die "Can't open '$file': $!"; };
  return "file '$file' not backed up" if $@;
  binmode(FILE);

  my $md5 = Digest::MD5->new;
  while (<FILE>) {
    $md5->add($_);
  }
  close(FILE);
  return $md5->hexdigest;
}

=head1 AUTHOR

Jozef Reisinger, C<< <jozef.reisinger at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-animal at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Animal>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Animal


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Animal>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Animal>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Animal>

=item * Search CPAN

L<http://search.cpan.org/dist/Animal/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Jozef Reisinger.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Backup::Verify
