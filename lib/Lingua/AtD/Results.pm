package Lingua::AtD::Results;
# ABSTRACT: Encapsulates the Results response from a call to AtD.
use strict;
use warnings;
use Carp;
use XML::XPath;
use Lingua::AtD::Error;
use Class::Std;

{

    # Result objects have the following attributes
    my %xml_of             :ATTR( :init_arg<xml> :get<xml> );
    my %server_message_of  :ATTR( :get<server_message> );
    my %errors_of          :ATTR();

    sub BUILD {
        my ($self, $ident, $arg_ref) = @_;
        my @atd_errors = ();

        my $xp = XML::XPath->new( xml => $arg_ref->{xml} );
        my $nodeset = $xp->findnodes('//error');
        foreach my $node ( $nodeset->get_nodelist ) {
            my @options = ();
            my $option_nodeset = $node->findvalue('option');
            foreach my $option_node ( $option_nodeset->get_nodelist ) {
                push(@options, $option_node->string_value); # TODO - Get values!
            }
            my $atd_error   = Lingua::AtD::Error->new(
                {
                    string   => $node->findvalue('string'),
                    description  => $node->findvalue('description'),
                    precontext  => $node->findvalue('precontext'),
                    suggestions => [@options],
                    type  => $node->findvalue('type'),
                    url  => $node->findvalue('url')
                }
            );
            push( @atd_errors, $atd_error );
        }
        $errors_of{$ident} = [@atd_errors];

        # Check for server message.
        # TODO - Throw an exception. This message means the server had issues.
        # For now, tuck it away as an attribute. In theory, there's only one message.
        #~ if ( defined( $results->{message} ) ) {
            #~ $server_message_of{$ident} = $results->{message};
        #~ }
#~ 
        #~ foreach my $xml_error ( @{ $results->{error} } ) {
            #~ my $atd_error = Lingua::AtD::Error->new($xml_error);
            #~ push( @atd_errors, $atd_error );
        #~ }

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

1;
