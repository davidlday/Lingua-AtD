#!/usr/bin/perl -w
use Test::More;
use Test::Exception;

plan tests => 14;

use_ok( 'Lingua::AtD' );
my $atd = Lingua::AtD->new();
isa_ok( $atd, 'Lingua::AtD' );
is( $atd->get_service_host, 'service.afterthedeadline.com', ' get_service_host()');
is( $atd->get_service_port, 80, ' get_service_port()');
is( $atd->get_service_url, 'http://service.afterthedeadline.com:80/', ' get_service_url()');

my $atd_bogus = Lingua::AtD->new( { host => 'some.bogus.host', port => 200200 } );
isa_ok( $atd_bogus, 'Lingua::AtD' );
is( $atd_bogus->get_service_host, 'some.bogus.host', ' get_service_host() [bogus]');
is( $atd_bogus->get_service_port, 200200, ' get_service_port() [bogus]');
is( $atd_bogus->get_service_url, 'http://some.bogus.host:200200/', ' get_service_url() [bogus]');
throws_ok( sub{ $atd_bogus->stats( 'should throw an exception' ) }, 'Lingua::AtD::HTTPException', 'HTTP Exception thrown' );
my $atd_exception = Exception::Class->caught('Lingua::AtD::HTTPException');
isa_ok( $atd_exception, 'Lingua::AtD::HTTPException');
is( $atd_exception->description, 'Indicates a problem connecting to the AtD service.', 'description() [exception]');
is( $atd_exception->http_status, "500 Can't connect to some.bogus.host:200200 (Bad hostname)", 'http_status() [exception]');
is( $atd_exception->service_url, 'http://some.bogus.host:200200/stats', 'service_url() [exception]');



done_testing;
