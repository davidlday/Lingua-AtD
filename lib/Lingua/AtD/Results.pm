package Lingua::AtD::Results;
# ABSTRACT: Encapsulate conversion of XML from /checkDocument or /checkGrammar call to Error objects.
use strict;
use warnings;
use Carp;
use XML::LibXML;
use Lingua::AtD::Error;
use Class::Std;

{

    # Attributes
    my %xml_of             :ATTR( :init_arg<xml> :get<xml> );
    my %server_message_of  :ATTR( :get<server_message> );
    my %errors_of          :ATTR();

    sub START {
        my ($self, $ident, $arg_ref) = @_;
        my @atd_errors = ();

        my $parser = XML::LibXML->new();
        my $dom    = $parser->load_xml( string => $xml_of{$ident} );

        # Check for server message.
        # For now, tuck it away as an attribute. In theory, there's only one message.
        if ( $dom->exists('/results/message') ) {
            $server_message_of{$ident} = $dom->findvalue('/results/message');
            # TODO - Throw an exception. This message means the server had issues.
        }

        foreach my $error_node ($dom->findnodes('/results/error')) {
            my @options = ();
            foreach my $option_node ($error_node->findnodes('./suggestions/option')) {
                push(@options, $option_node->string_value);
            }
            my $url = ($error_node->exists('url')) ? $error_node->findvalue('url') : undef;
            my $atd_error   = Lingua::AtD::Error->new(
                {
                    string   => $error_node->findvalue('string'),
                    description  => $error_node->findvalue('description'),
                    precontext  => $error_node->findvalue('precontext'),
                    suggestions => [@options],
                    type  => $error_node->findvalue('type'),
                    url  => $url
                }
            );
            push( @atd_errors, $atd_error );
        }
        $errors_of{$ident} = [@atd_errors];

        return;
    }

    sub has_server_exception {
        my $self = shift;
        return defined( $server_message_of{ ident($self) } );
    }

    sub has_errors {
        my $self = shift;
        return defined( $errors_of{ ident($self) } );
    }

    sub get_errors {
        my $self = shift;
        return $self->has_errors()
          ? @{ $errors_of{ ident($self) } }
          : undef;
    }

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
