#!/usr/bin/perl
# Script to verify that backups are OK (http://www.perlmonks.org/?node_id=619558).
use strict;
use warnings;
use File::Basename;
use Net::SSH qw(sshopen2);

#######################
# Configuration section

my $verbose = 0;

my $percentage = 0.0001;    # percentage of files to check
my %bak_dir    = (
    ## dir/ => bak_dir/ (local backup)
    #'/data/home/' => '/cloud_backup/hourly.0/localhost/',

    ## user@machine:/dir/ => bak_dir/ (remote backup)
    'jreisinger@10.160.76.131:/home/jreisinger/temp/' => '/data500/backup/',
);

######
# Main

for my $dir ( sort keys %bak_dir ) {
    my $backup_dir = $bak_dir{$dir};

    my @returned    = get_files( $dir, $percentage );
    my $total_files = shift @returned;
    my @files       = @returned;

    my $checked = 0;
    my $ok      = 0;
    my @not_ok;

    for my $file (@files) {
        print "Working on: '$file'\n" if $verbose;
        my ( $filename, $directories, $suffix ) =
          fileparse $file;    # $file has file with full path
        my $backup_directories = $directories;
        $backup_directories =~ s#^#$backup_dir#;

        if ( $dir =~ /\@/ ) {    # remote files
            my ( $user, $host, $dir ) = $dir =~ /^(.+)@([^:]+):(.+)$/;
            my $cmd = "md5sum \"$file\""
              ;                  # strange quoting to escape spaces in filenanes

            # SSH to remote host
            sshopen2( "$user\@$host", *READER, *WRITER, "$cmd" )
              || die "ssh: $!";
            while (<READER>) {
                my ( $orig_hash, $orig_file ) = split;  # split output of md5sum
                my $backup_hash = gen_md5sum("$backup_directories/$filename");
                if ($verbose) {
                    print "\tOriginal: $orig_hash $user\@$host:$orig_file\n";
                    print
"\tBackup:   $backup_hash $backup_directories/$filename\n";
                }
                if ( $orig_hash eq $backup_hash ) {
                    $ok++;
                } else {
                    push @not_ok, $file;
                }
                $checked++;
            }
            close(READER);
            close(WRITER);

        } else {    # local files

            if ( gen_md5sum("$directories/$filename") eq
                gen_md5sum("$backup_directories/$filename") )
            {
                $ok++;
            } else {
                push @not_ok, $file;
            }
            $checked++;
        }

    }

    # Statistics
    print "-" x 79, "\n";
    print "Checked $checked files out of $total_files total files for '$dir'\n";
    print "\tBacked up correctly:    $ok\n";
    print "\tBacked up in-correctly: ", scalar @not_ok, "\n";
}

###########
# Functions

use File::Find;                # core module
use Digest::MD5;               # core module
use List::Util qw(shuffle);    # core module - to randomize list

sub get_files {

    # return total number of files in $dir and the percentage of files
    my $dir        = shift;    # dir to search for files
    my $percentage = shift;    # percentage of files to return

    my @files;

    # get just files, not directories
    if ( $dir =~ /\@/ ) {      # remote files

        my ( $user, $host, $dir ) = $dir =~ /^(.+)@([^:]+):(.+)$/;
        my $cmd = "find $dir -type f";

        # SSH to remote host
        sshopen2( "$user\@$host", *READER, *WRITER, "$cmd" )
          || die "ssh: $!";
        while (<READER>) {
            chomp;
            push @files, $_;
        }
        close(READER);
        close(WRITER);

    } else {    # local files
        find( sub { push @files, $File::Find::name if -f; }, "$dir" );
    }

    # calculate the percentage
    my $total_files_number  = scalar @files;
    my $sample_files_number = $total_files_number * $percentage;

    # get the sample files
    my @sample_files;
    for ( shuffle @files ) {    # randomize order of files
        last
          if @sample_files >= $sample_files_number
              or $sample_files_number == 0;
        push @sample_files, $_;
    }

    return $total_files_number, @sample_files;
}

sub gen_md5sum {

    # Generate MD5 checksum
    my $file = shift;
    eval { open( FILE, "$file" ) or die "Can't open '$file': $!"; };
    return "file '$file' not backed up" if $@;
    binmode(FILE);

    my $md5 = Digest::MD5->new;
    while (<FILE>) {
        $md5->add($_);
    }
    close(FILE);
    return $md5->hexdigest;
}

