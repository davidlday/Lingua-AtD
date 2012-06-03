#!/usr/bin/perl -w
use Test::More;
use Test::Exception;

plan tests => 20;

my $bad_string = "I can has cheezburger?";
my $good_string = "May I have a cheeseburger?";

use_ok('Lingua::AtD');
my $atd = Lingua::AtD->new();
isa_ok( $atd, 'Lingua::AtD' );

# Check dying
# Remove throttle
is( $atd->set_throttle(0), 1, ' get_throttle()' );
is( $atd->get_throttle(0), 0, ' get_throttle() [validate removed]' );
lives_ok(
    sub { $atd->check_document($bad_string) },
    ' expecting to live.',
);
dies_ok(
    sub { $atd->check_document($bad_string) },
    ' expecting to die.',
);
# Restore throttle
is( $atd->set_throttle(1), 0, ' get_throttle()' );
is( $atd->get_throttle(0), 1, ' get_throttle() [validate restored]' );

# Verify Throttle
lives_ok(
    sub { $atd->check_document($bad_string) },
    ' expecting to live.',
);
lives_ok(
    sub { $atd->check_document($bad_string) },
    ' expecting to live.',
);

# Verify check_document returns 2 errors for $bad_string
my $doc_check_b = $atd->check_document($bad_string);
is( $doc_check_b->has_errors(), 1, ' has_errors() [bad text]' );
is( $doc_check_b->get_error_count(), 2, ' get_error_count() [bad text]' );

# Verify check_document returns 0 errors for $good_string
my $doc_check_g = $atd->check_document($good_string);
is( $doc_check_g->has_errors(), 0, ' has_errors() [good text]' );
is( $doc_check_g->get_error_count(), 0, ' get_error_count() [good text]' );

# Verify check_grammar returns 1 errors for $bad_string
my $grammar_check_b = $atd->check_grammar($bad_string);
is( $grammar_check_b->has_errors(), 1, ' has_errors() [bad grammar]' );
is( $grammar_check_b->get_error_count(), 1, ' get_error_count() [bad grammar]' );

# Verify check_grammar returns 1 errors for $good_string
my $grammar_check_g = $atd->check_grammar($good_string);
is( $grammar_check_g->has_errors(), 0, ' has_errors() [good grammar]' );
is( $grammar_check_g->get_error_count(), 0, ' get_error_count() [good grammar]' );

# Verify stats returned
my $scores = $atd->stats($bad_string);
is( $scores->has_metrics(), 1, ' has_metrics()');
is( $scores->get_metric_count(), 4, ' get_metric_count()' );

done_testing;
