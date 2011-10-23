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
use Try::Tiny;

plan tests => 9;

my $xml_good = '<?xml version="1.0"?>
<results>
  <error>
    <string>to be</string>
    <description>Passive voice</description>
    <precontext>want</precontext>
    <type>grammar</type>
    <url>http://service.afterthedeadline.com/info.slp?text=to+be</url>
  </error>
  <error>
    <string>wether</string>
    <description>Did you mean...</description>
    <precontext>determine</precontext>
    <suggestions>
        <option>whether</option>
        <option>weather</option>
    </suggestions>
    <type>spelling</type>
    <url>http://service.afterthedeadline.com/info.slp?text=wether</url>
  </error>
</results>';

my $xml_exception = '<?xml version="1.0"?>
<results>
  <message>This is a description of what went wrong</message>
</results>';

my $atd_results = Lingua::AtD::Results->new( { xml => $xml_good } );
ok( defined $atd_results,                      'new() [good]' );
ok( $atd_results->isa('Lingua::AtD::Results'), 'isa() [good]' );
is( $atd_results->get_xml, $xml_good, ' get_xml() [good]' );
is( $atd_results->get_server_exception,
    undef, ' get_service_exception() [good]' );
is( $atd_results->get_errors, 2, ' get_errors() [good]' );

eval {
    my $atd_results_exception =
      Lingua::AtD::Results->new( { xml => $xml_exception } );
};
my $atd_exception = Exception::Class->caught('Lingua::AtD::ServiceException');
ok( defined $atd_exception,                               'new() [exception]' );
ok( $atd_exception->isa('Lingua::AtD::ServiceException'), 'isa() [exception]' );
is(
    $atd_exception->description,
    'Indicates the AtD service returned an error message.',
    'description() [exception]'
);
is(
    $atd_exception->service_message,
    'This is a description of what went wrong',
    'service_message() [exception]'
);

done_testing;
