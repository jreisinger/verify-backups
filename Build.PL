use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Backup::Test',
    license             => 'GPLv3',
    dist_author         => 'Jozef Reisinger <jozef.reisinger@gmail.com>',
    dist_version_from   => 'lib/Backup/Test.pm',
    requires => {
        #'File::Spec' => 0,
    },
    build_requires => {
        #'Test::More' => 0,
    },
    #add_to_cleanup      => [ 'Math-Base4-*' ],
    create_readme       => 1,
    meta_merge => {
        resources => {
            repository => 'https://github.com/jreisinger/verify-backups',
            bugtracker => 'https://github.com/jreisinger/verify-backups/issues',
        },
        keywords => [ qw/ backup verify test / ],
    },
);

$builder->create_build_script();
