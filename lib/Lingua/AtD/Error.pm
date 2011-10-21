package Lingua::AtD::Error;
# ABSTRACT: Encapsulates the Errors contained in Results.
use strict;
use warnings;
use Carp;
use Class::Std;

{

    # Attributes
    my %string_of       :ATTR( :init_arg<string> :get<string>  );
    my %description_of  :ATTR( :init_arg<description> :get<description>  );
    my %precontext_of   :ATTR( :init_arg<precontext> :get<precontext> );
    my %suggestions_of  :ATTR();
    my %type_of         :ATTR( :init_arg<type> :get<type> );
    my %url_of          :ATTR( :get<url> );

    sub BUILD {
        my ($self, $ident, $arg_ref) = @_;

        # Special cases. Both are optional, suggestions is an array.
        $suggestions_of{$ident} = $arg_ref->{suggestions} if ( defined($arg_ref->{suggestions}) );
        $url_of{$ident}         = $arg_ref->{url} if ( defined($arg_ref->{url}) && length($arg_ref->{url} > 0) );

        return;
    }

    # Convenience method
    sub has_suggestions {
        my $self = shift;
        return defined( $suggestions_of{ ident($self) } );
    }

    # Dereference array
    sub get_suggestions {
        my $self = shift;
        return $self->has_suggestions()
          ? @{ $suggestions_of{ ident($self) } }
          : undef;
    }

    # Convenience method
    sub has_url {
        my $self = shift;
        return defined( $url_of{ ident($self) } );
    }

}

1;
