require 5.6.0;

use strict;
use ExtUtils::MakeMaker;

my %preq = ('Tk' => "800.022");
$preq{"Win32::API"} = "0.20" if $^O =~ /Win32/;

WriteMakefile(
    'NAME'          => 'Tk::StayOnTop',
    'VERSION_FROM'  => 'StayOnTop.pm',
    'PREREQ_PM'     => \%preq,
    'ABSTRACT'      => 'Keep your Tk window in the foreground',
    'AUTHOR'        => 'Gavin Brock <gbrock@cpan.org>',
    'dist'          => { COMPRESS=>'gzip', SUFFIX=>'gz' },
);
