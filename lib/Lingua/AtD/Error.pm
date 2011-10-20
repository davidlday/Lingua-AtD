package Lingua::AtD::Error;
# ABSTRACT: Encapsulates the Errors contained in Results.
use strict;
use warnings;
use Carp;
use Class::Std::Utils;

{

    # Error objects have the following attributes
    my %hashref_of;        # Original hash
    my %string_of;         # String in error
    my %description_of;    # Description of error
    my %precontext_of;     # What immediately precedes the error
    my %suggestions_of;    # List of suggested fixes / alternatives
    my %type_of;           # Type of error [grammar|spell|stats|style]
    my %url_of;            # AtD info.slp URL for error details

    sub new {
        my ( $class, $error_hash_ref ) = @_;

        # Bless a scalar to instantiate the new object...
        my $new_object = bless( anon_scalar(), $class );
        my $ident = ident($new_object);

       # TODO - Check $error_hash_ref and throw exception if empty or undefined.

        $hashref_of{$ident}     = $error_hash_ref;
        $string_of{$ident}      = $error_hash_ref->{string};
        $description_of{$ident} = $error_hash_ref->{description};
        $precontext_of{$ident}  = $error_hash_ref->{precontext};
        $suggestions_of{$ident} = $error_hash_ref->{suggestions}->{option};
        $type_of{$ident}        = $error_hash_ref->{type};
        $url_of{$ident}         = $error_hash_ref->{url};

        return $new_object;
    }

    sub get_string {
        my $self = shift;
        return $string_of{ ident($self) };
    }

    sub get_description {
        my $self = shift;
        return $description_of{ ident($self) };
    }

    sub get_precontext {
        my $self = shift;
        return $precontext_of{ ident($self) };
    }

    sub has_suggestions {
        my $self = shift;
        return defined( $suggestions_of{ ident($self) } );
    }

    sub get_suggestions {
        my $self = shift;
        return $self->has_suggestions()
          ? @{ $suggestions_of{ ident($self) } }
          : undef;
    }

    sub get_type {
        my $self = shift;
        return $type_of{ ident($self) };
    }

    sub has_url {
        my $self = shift;
        return defined( $url_of{ ident($self) } );
    }

    sub get_url {
        my ( $self, $theme ) = @_;
        my $info_url = $url_of{ ident($self) };
        if ( $self->has_url() && defined($theme) ) {
            $info_url .= '&theme=' . $theme;
        }
        return $info_url;
    }

    sub get_hashref {
        my $self = shift;
        return $hashref_of{ ident($self) };
    }
}

1;
