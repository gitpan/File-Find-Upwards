#!/usr/bin/env perl
use warnings;
use strict;
use File::Find::Upwards;
use FindBin '$Bin';
use Test::More tests => 4;
chdir $Bin;
my $makefile = file_find_upwards('Makefile.PL');
ok(file_find_upwards('01_misc.t'), 'this test file exists');
ok($makefile,                      'Makefile.PL exists above this');
ok( !file_find_upwards(
        'some_random_name_if_you_have_this_it_is_your_own_fault.txt'),
    'weirdly named file does not exist upwards'
);
my $dir = find_containing_dir_upwards('Makefile.PL');
is("$dir/Makefile.PL", $makefile, 'find_containing_dir_upwards');
