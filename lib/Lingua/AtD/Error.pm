package Lingua::AtD::Error;
use strict;
use warnings;
use Carp;
use Class::Std;

# ABSTRACT: Encapsulates the Errors contained in Results.

{

    # Attributes
    my %string_of : ATTR( :init_arg<string> :get<string>  );
    my %description_of : ATTR( :init_arg<description> :get<description>  );
    my %precontext_of : ATTR( :init_arg<precontext> :get<precontext> );
    my %suggestions_of : ATTR();
    my %type_of : ATTR( :init_arg<type> :get<type> );
    my %url_of : ATTR( :get<url> );

    sub BUILD {
        my ( $self, $ident, $arg_ref ) = @_;

        # Special cases. Both are optional, suggestions is an array.
        $suggestions_of{$ident} = $arg_ref->{suggestions}
          if ( defined( $arg_ref->{suggestions} ) );
        $url_of{$ident} = $arg_ref->{url}
          if ( defined( $arg_ref->{url} ) && length( $arg_ref->{url} ) > 0  );

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
    my $atd_response = $atd->check_document('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_error ($atd_response->get_errors()) {
        # Do something with...
        print "Error string: ", $atd_error->get_string(), "\n";
    }
    
    # Run only grammar checks. Essentially the same as 
    # check_document(), sans spell-check.
    my $atd_response = $atd->check_grammar('Text to check.');
    # Loop through reported document errors.
    foreach my $atd_error ($atd_response->get_errors()) {
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

<description>

=head1 METHODS
