package Lingua::AtD::Error;
use strict;
use warnings;
use Carp;
use Class::Std;

# ABSTRACT: Encapsulates the grammar/spelling/style Errors contained in Results.

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
          if ( defined( $arg_ref->{url} ) && length( $arg_ref->{url} ) > 0 );

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

Encapsulates the grammar/spelling/style Errors contained in Results.

=head1 METHODS

=method get_string

    $atd_error->get_string();

Returns the string in error.

=method get_description

    $atd_error->get_description();

Returns a string description of the error.

=method get_precontext

    $atd_error->get_precontext();

Returns a string. Usually the word or words immediately preceding the word or phrase in error.

=method has_suggestions

    $atd_error->has_suggestions();

Returns a boolean (1|0) indicating if the AtD service provided suggestions for fixing the error.

=method get_suggestions

    my @suggestions = $atd_error->get_suggestions();

In some cases, such as spelling, the AtD service may suggest corrections in the form of an array of strings.

=method get_type

    $atd_error->get_type();

Returns a string indicating the type of error. One of I<grammar>, I<spelling>, or I<style>.

=method has_url

    $atd_error->has_url();

Returns a boolean (1|0) indicating if the AtD service provided a URL with more details on the error. This url is suitable for use in UIs.

=method get_url

    $atd_error->get_url();

Returns a url to the AtD service providing details on the error. This url is suitable for use in UIs.

=head1 SEE ALSO

See the L<API Documentation|http://www.afterthedeadline.com/api.slp> at After the Deadline's website.
