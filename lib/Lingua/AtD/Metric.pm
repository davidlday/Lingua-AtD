package Lingua::AtD::Metric;
use strict;
use warnings;
use Carp;
use Class::Std::Utils;

# ABSTRACT: Encapsulates the Metrics contained in Scores.

{

    # Metric objects have the following attributes
    my %hashref_of;    # Original hash
    my %type_of;       # String in error
    my %key_of;        # Description of error
    my %value_of;      # What immediately precedes the error

    sub new {
        my ( $class, $metrics_hash_ref ) = @_;

        # Bless a scalar to instantiate the new object...
        my $new_object = bless( anon_scalar(), $class );
        my $ident = ident($new_object);

        # TODO - Check $metrics_hash_ref and throw exception if empty or undefined.

        $hashref_of{$ident} = $metrics_hash_ref;
        $type_of{$ident}    = $metrics_hash_ref->{type};
        $key_of{$ident}     = $metrics_hash_ref->{key};
        $value_of{$ident}   = $metrics_hash_ref->{value};

        return $new_object;
    }

    sub get_type {
        my $self = shift;
        return $type_of{ ident($self) };
    }

    sub get_key {
        my $self = shift;
        return $key_of{ ident($self) };
    }

    sub get_value {
        my $self = shift;
        return $value_of{ ident($self) };
    }
}

1;
