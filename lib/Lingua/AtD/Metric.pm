package Lingua::AtD::Metric;
use strict;
use warnings;
use Carp;
use Class::Std;

# ABSTRACT: Encapsulates the grammar/spelling/style/statistical Metrics contained in Scores.

{

    # Attributes
    my %type_of : ATTR( :init_arg<type>  :get<type> );
    my %key_of : ATTR( :init_arg<key>   :get<key> );
    my %value_of : ATTR( :init_arg<value> :get<value>);

}

1;    # Magic true value required at end of module
__END__

=head1 SYNOPSIS

    use Lingua::AtD;

    # Create a new service proxy
    my $atd = Lingua::AtD->new( {
        host => 'service.afterthedeadline.com',
        port => 80
    });

    # Run spelling and grammar checks. Returns a Lingua::AtD::Response object.
    my $doc_check = $atd->check_document('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_error ($doc_check->get_errors()) {
        # Do something with...
        print "Error string: ", $atd_error->get_string(), "\n";
    }

    # Run only grammar checks. Essentially the same as
    # check_document(), sans spell-check.
    my $grmr_check = $atd->check_grammar('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_error ($grmr_check->get_errors()) {
        # Do something with...
        print "Error string: ", $atd_error->get_string(), "\n";
    }

    # Get statistics on a document. Returns a Lingua::AtD::Scores object.
    my $atd_scores = $atd->stats('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_metric ($atd_scores->get_metrics()) {
        # Do something with...
        print $atd_metric->get_type(), "/", $atd_metric->get_key(),
            " = ", $atd_metric->get_value(), "\n";
    }

=head1 DESCRIPTION

Encapsulates the grammar/spelling/style/statistical Metrics contained in Scores.

=head1 METHODS

=method get_type

    $atd_metric->get_type();

Returns a string indicating the type of metric. One of I<grammar>, I<spell>, I<style>, or I<stats>.

=method get_key

    $atd_metric->get_key();

Returns a string indicating the metric key. From the L<API Documentation|http://www.afterthedeadline.com/api.slp>: I<The type is a category to add some organization to the information.>

=method get_value

    $atd_metric-The type is a category to add some organization to the information.>get_value();

Returns the numeric value of the metric.

=head1 SEE ALSO

See the L<API Documentation|http://www.afterthedeadline.com/api.slp> at After the Deadline's website.
