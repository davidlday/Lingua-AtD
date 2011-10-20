package Lingua::AtD;
use strict;
use warnings;
use Carp;
use Class::Std::Utils;
use LWP::UserAgent;
use Lingua::AtD::Results;
use Lingua::AtD::Scores;

# ABSTRACT: Provides an OO wrapper for After the Deadline grammar and spelling service.
our $VERSION = '0.01';

{

   # In this module, error refers to an AtD error (i.e. spelling, grammar, etc).
   # and a problem in the program is an exception.

    # Result objects have the following attributes
    my %api_key_of;        # Raw XML, only set at creation
    my %service_url_of;    # Error message from the AtD service

    #    my %errors_of;     # AtD spelling/grammar/style errors
    my $DEFAULT_API_KEY = 'Lingua-AtD-v' . $VERSION;   # Add version number here
    my $DEFAULT_SERVICE_URL = 'http://service.afterthedeadline.com/';

    sub new {
        my ( $class, $args_ref ) = @_;

        # Bless a scalar to instantiate the new object...
        my $new_object = bless( anon_scalar(), $class );
        my $ident = ident($new_object);

        $api_key_of{$ident} =
          defined( $args_ref->{api_key} )
          ? $args_ref->{api_key}
          : $DEFAULT_API_KEY;
        $service_url_of{$ident} =
          defined( $args_ref->{service_url} )
          ? $args_ref->{service_url}
          : $DEFAULT_SERVICE_URL;

        return $new_object;
    }

    sub get_api_key {
        my $self = shift;
        return $api_key_of{ ident($self) };
    }

    sub get_service_url {
        my $self = shift;
        return $service_url_of{ ident($self) };
    }

    sub _atd {
        my ( $self, $verb, $args_ref ) = @_;
        my $ident = ident($self);
        my $url   = $service_url_of{$ident} . $verb;
        my $ua    = LWP::UserAgent->new();
        $ua->agent("AtD Perl Module/$VERSION");

        my $response = $ua->post( $url, Content => [ %{$args_ref} ] );

        #TODO - Add some error checking for the response and throw exceptions.
        return $response->content;
    }

    sub check_document {
        my ( $self, $text ) = @_;
        my $ident = ident($self);
        my $raw_response =
          $self->_atd( 'checkDocument',
            { key => $api_key_of{$ident}, data => $text } );
        return Lingua::AtD::Results->new($raw_response);
    }

    sub check_grammar {
        my ( $self, $text ) = @_;
        my $ident = ident($self);
        my $raw_response =
          $self->_atd( 'checkGrammar',
            { key => $api_key_of{$ident}, data => $text } );
        return Lingua::AtD::Results->new($raw_response);
    }

    sub stats {
        my ( $self, $text ) = @_;
        my $ident = ident($self);
        my $raw_response =
          $self->_atd( 'stats', { key => $api_key_of{$ident}, data => $text } );
        return Lingua::AtD::Scores->new($raw_response);
    }

#	TODO - Not sure it's useful since all errors carry their own URL.
#    sub get_info {
#    }

}

1;
