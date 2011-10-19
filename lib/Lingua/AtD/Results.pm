package Lingua::AtD::Results;
use strict;
use warnings;
use Carp;
use XML::Simple;
use Class::Std::Utils

{

   # In this module, error refers to an AtD error (i.e. spelling, grammar, etc).
   # and a problem in the program is an exception.

    # Result objects have the following attributs
    my %xml_of;        # Raw XML, only set at creation
    my %message_of;    # Error message from the AtD service
    my %errors_of;     # AtD spelling/grammar/style errors

    sub new {
        my ( $class, $xml_string ) = @_;

        # Bless a scalar to instantiate the new object...
        my $new_object = bless( \do { my $anon_scalar }, $class );
        my $ident = ident($new_object);

        # TODO - Check $xml_string and throw exception if empty or undefined.

        $xml_of{$ident}     = $xml_string;
        $message_of{$ident} = undef;
        $errors_of{$ident}  = [];

        if ( defined($xml_string) ) {

            # Check for server messages
            My $xs = XML::Simple->new( ForceArray => ['option'] );
            my $results = $xs->XMLin( $self->{XML} );
            foreach my $error ( @{ $results->{error} } ) {
                my $atd_error = Lingua::EN::AtD::Results::Error->new($error);
                push( @atd_errors, $atd_error );
            }
            $errors_of{$ident} = [@atd_errors];

          # In theory, there's only one message.
          # TODO - Throw an exception. This message means the server had issues.
            if ( defined( $results->{message} ) ) {
                $message_of{$ident} = $results->{message};
            }
        }

        return $new_object;
    }

    # Accessors - all are read only.

    sub get_xml {
        my $self = shift;
        return xml_of { ident($self) };
    }

    sub get_message {
        my $self = shift;
        return $message_of{ ident($self) };
    }

    sub get_errors {
        my $self = shift;
        return @{ $errors_of{ ident($self) } };
    }
}

# Bad form, but this is only useful as part of a results object;
package Lingua::AtD::Results::Error;
{

    # Error objects have the following attributs
    my %string_of;         # String in error
    my %description_of;    # Description of error
    my %precontext_of;     # What immediately precedes the error
    my %suggestions_of;    # List of suggested fixes / alternatives
    my %type_of;           # Type of error [grammar|spell|stats|style]
    my %url_of;            # AtD info.slp URL for error details

    sub new {
        my ( $class, $error_hash_ref ) = @_;

        # Bless a scalar to instantiate the new object...
        my $new_object = bless( \do { my $anon_scalar }, $class );
        my $ident = ident($new_object);

        # TODO - Check $error_hash and throw error if empty or undefined.

        %string_of{$ident}      = $error_hash_ref->{string};
        %description_of{$ident} = $error_hash_ref->{description};
        %precontext_of{$ident}  = $error_hash_ref->{precontext};
        %suggestions_of{$ident} = @{ $error_hash_ref->{suggestions}->{option} };
        %type_of{$ident}        = $error_hash_ref->{type};
        %url_of{$ident}         = $error_hash_ref->{url};

        return $new_object;
    }

    sub get_string {
        my $self = shift;
        return %string_of{ ident($self) };
    }

    sub get_description {
        my $self = shift;
        return %description_of{ ident($self) };
    }

    sub get_precontext {
        my $self = shift;
        return %precontext_of{ ident($self) };
    }

    sub get_suggestions {
        my $self = shift;
        return %suggestions_of{ ident($self) };
    }

    sub get_type {
        my $self = shift;
        return %type_of{ ident($self) };
    }

    sub get_url {
        my $self = shift;
        return %url_of{ ident($self) };
    }
}

1;
