package Lingua::AtD::Metric;
# ABSTRACT: Encapsulates the Metrics contained in Scores.
use strict;
use warnings;
use Carp;
use Class::Std;

{

    # Attributes
    my %type_of     :ATTR( :init_arg<type>  :get<type> );
    my %key_of      :ATTR( :init_arg<key>   :get<key> );
    my %value_of    :ATTR( :init_arg<value> :get<value>);

}

1; # Magic true value required at end of module
__END__


=head1 SYNOPSIS

    use Lingua::AtD;
    
    # Create a new service proxy
    my $atd = Lingua::AtD->new( {
        host => 'service.afterthedeadline.com',
        port => 80
    });

    # Run spelling and grammar checks. Returns a Lingua::AtD::Response object.
    my $response = $atd->check_document('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_error ($response->get_errors()) {
        # Do something with...
        print "Error string: ", $atd_error->get_string(), "\n";
    }
    
    # Run only grammar checks. Essentially the same as 
    # check_document(), sans spell-check.
    my $response = $atd->check_grammar('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_error ($response->get_errors()) {
        # Do something with...
        print "Error string: ", $atd_error->get_string(), "\n";
    }
    
    # Get statistics on a document. Returns a Lingua::AtD::Scores object.
    my $scores = $atd->stats('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_metric ($response->get_metrics()) {
        # Do something with...
        print $atd_metric->get_type(), "/", $atd_metric->get_key(), 
            " = ", $atd_metric->get_value(), "\n";
    }
    
=head1 DESCRIPTION

<description>

=head1 METHODS
