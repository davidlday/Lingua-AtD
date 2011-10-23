#!/usr/bin/perl -w
#
# This file is part of Lingua-AtD
#
# This software is copyright (c) 2011 by David L. Day.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use Test::More;
use Lingua::AtD;

plan tests => 5;

my $atd = Lingua::AtD->new();
ok( defined $atd,             'new()' );
ok( $atd->isa('Lingua::AtD'), 'isa()' );
is(
    $atd->get_service_host,
    'service.afterthedeadline.com',
    ' get_service_host()'
);
is( $atd->get_service_port, 80, ' get_service_port()' );
is(
    $atd->get_service_url,
    'http://service.afterthedeadline.com:80/',
    ' get_service_url()'
);

done_testing;
