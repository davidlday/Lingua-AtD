package Lingua::AtD::Scores;

# ABSTRACT: Encapsulate conversion of XML from /stats call to Metric objects.
use strict;
use warnings;
use Carp;
use XML::LibXML;
use Lingua::AtD::Metric;
use Class::Std;

{

    # Attributes
    my %xml_of : ATTR( :init_arg<xml> :get<xml> );
    my %server_message_of : ATTR( :get<server_exception> );
    my %metrics_of : ATTR();

    sub START {
        my ( $self, $ident, $arg_ref ) = @_;
        my @atd_metrics = ();

        my $parser = XML::LibXML->new();
        my $dom = $parser->load_xml( string => $xml_of{$ident} );

   # Check for server message. Not sure if stats will do this.
   # For now, tuck it away as an attribute. In theory, there's only one message.
        if ( $dom->exists('/scores/message') ) {
            $server_message_of{$ident} = $dom->findvalue('/scores/message');

          # TODO - Throw an exception. This message means the server had issues.
        }
        foreach my $metric_node ( $dom->findnodes('/scores/metric') ) {
            my $atd_metric = Lingua::AtD::Metric->new(
                {
                    key   => $metric_node->findvalue('key'),
                    type  => $metric_node->findvalue('type'),
                    value => $metric_node->findvalue('value')
                }
            );
            push( @atd_metrics, $atd_metric );
        }
        $metrics_of{$ident} = [@atd_metrics];

        return;
    }

    sub has_server_exception {
        my $self = shift;
        return defined( $server_message_of{ ident($self) } );
    }

    sub has_metrics {
        my $self = shift;
        return defined( $metrics_of{ ident($self) } );
    }

    sub get_metrics {
        my $self = shift;
        return $self->has_metrics()
          ? @{ $metrics_of{ ident($self) } }
          : undef;
    }
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

Encapsulates conversion of the XML response from the AtD server into a list of spelling/grammar/style metric objects (L<Lingua::AtD::Metric>).

=method new

    # Possible, but not likely
    my $atd_scores = Lingua::AtD::Scores->new($xml_response);
    foreach my $atd_metric ($atd_scores->get_metrics()) {
        # Do something really fun...
    }
    
Lingua::AtD::Scores objects should only ever be created from a method calls to L<Lingua::AtD>. However, if you have saved XML responses from prior calls to AtD, you can use this object to convert those responses into PERL objects. I won't stop you.

See the L<DESCRIPTION> for typical usage.

=method has_server_exception

Convenience method to see if the AtD server returned an error message.

=method get_server_exception

Exception message from the server.

=method has_metrics

Convenience method to see if the XML response from AtD actually contained any metrics.

=method get_errors

Returns a list of linguistic metrics as L<Lingua::AtD::Metric> objects. For details on what metrics are supplied, see the L<API Documentation|http://www.afterthedeadline.com/api.slp>.

=method get_xml

Returns a string containing the raw XML response from the AtD service call.

=head1 SEE ALSO

See the L<API Documentation|http://www.afterthedeadline.com/api.slp> at After the Deadline's website.
