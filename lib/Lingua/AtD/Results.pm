package Lingua::AtD::Results;
# ABSTRACT: Encapsulates the Results response from a call to AtD.
use strict;
use warnings;
use Carp;
use XML::Simple;
use Lingua::AtD::Error;
use Class::Std::Utils;

{

    # Result objects have the following attributes
    my %xml_of;        # Raw XML, only set at creation
    my %message_of;    # Error message from the AtD service
    my %errors_of;     # AtD spelling/grammar/style errors

    sub new {
        my ( $class, $xml_string ) = @_;

        # Bless a scalar to instantiate the new object...
        my $new_object = bless( anon_scalar(), $class );
        my $ident = ident($new_object);

        # TODO - Check $xml_string and throw exception if empty or undefined.

        $xml_of{$ident}     = $xml_string;
        $message_of{$ident} = undef;
        $errors_of{$ident}  = [];
        my @atd_errors = ();

        if ( defined($xml_string) ) {

            # Check for server messages
            my $xs = XML::Simple->new( ForceArray => ['option'] );
            my $results = $xs->XMLin( $xml_of{$ident} );

            foreach my $xml_error ( @{ $results->{error} } ) {
                my $atd_error = Lingua::AtD::Error->new($xml_error);
                push( @atd_errors, $atd_error );
            }
            $errors_of{$ident} = [@atd_errors];

          # In theory, there's only one message.
          # TODO - Throw an exception. This message means the server had issues.
            if ( defined( $results->{message} ) ) {
                $message_of{$ident} = $results->{message};
            }
        }

        # TODO - Throw an exception if there's no xml_string.

        return $new_object;
    }

    # Accessors - all are read only.

    sub get_xml {
        my $self = shift;
        return $xml_of{ ident($self) };
    }

    sub get_message {
        my $self = shift;
        return $message_of{ ident($self) };
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

    sub DESTROY {
        my $self = shift;
        my $ident = ident($self);
        
        delete $xml_of{$ident};
        delete $message_of{$ident};
        delete $errors_of{$ident};
        
        return;
    }

}

1;
