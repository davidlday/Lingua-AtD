#!/usr/bin/perl -w
use Test::More;
use Test::Exception;

plan tests => 5;

use_ok( 'Lingua::AtD' );
my $atd = Lingua::AtD->new();
isa_ok( $atd, 'Lingua::AtD' );
is( $atd->get_service_host, 'service.afterthedeadline.com', ' get_service_host()');
is( $atd->get_service_port, 80, ' get_service_port()');
is( $atd->get_service_url, 'http://service.afterthedeadline.com:80/', ' get_service_url()');

done_testing;
