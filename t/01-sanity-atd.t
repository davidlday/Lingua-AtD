#!/usr/bin/perl -w
use Test::More;
use Lingua::AtD;

plan tests => 5;

my $atd = Lingua::AtD->new();
ok( defined $atd, 'new()');
ok( $atd->isa('Lingua::AtD'), 'isa()');
is( $atd->get_service_host, 'service.afterthedeadline.com', ' get_service_host()');
is( $atd->get_service_port, 80, ' get_service_port()');
is( $atd->get_service_url, 'http://service.afterthedeadline.com:80/', ' get_service_url()');

done_testing;
