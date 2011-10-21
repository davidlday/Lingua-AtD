package Lingua::AtD;
# ABSTRACT: Provides an OO wrapper for After the Deadline grammar and spelling service.
use strict;
use warnings;
use Carp;
use Class::Std;
use LWP::UserAgent;
use Lingua::AtD::Results;
use Lingua::AtD::Scores;

{

    # TODO - add host / port options, and options based on language (i.e. en, fr, etc).
    my %api_key_of      :ATTR( :init_arg<api_key> :get<api_key> :default<'Lingua-AtD'> );
    my %service_host_of :ATTR( :init_arg<host> :get<service_host> :default<'service.afterthedeadline.com'> );
    my %service_port_of :ATTR( :init_arg<port> :get<service_port> :default<80> );
    my %service_url_of  :ATTR( :get<service_url> );

    sub START {
        my ($self, $ident, $arg_ref) = @_;

        # Construct the URL
        $service_url_of{$ident} = 'http://' . $service_host_of{$ident} . ':' . $service_port_of{$ident} . '/';

        return;
    }

    sub _atd : PRIVATE {
        my ( $self, $verb, $arg_ref ) = @_;
        my $ident = ident($self);
        my $url   = $service_url_of{$ident} . $verb;
        my $ua    = LWP::UserAgent->new();
        $ua->agent( 'AtD Perl Module/' . $Lingua::AtD::VERSION );

        my $response = $ua->post( $url, Content => [ %{$arg_ref} ] );

        #TODO - Add some error checking for the response and throw exceptions.
        return $response->content;
    }

    sub check_document {
        my ( $self, $text ) = @_;
        my $ident = ident($self);
        my $raw_response =
          $self->_atd( 'checkDocument',
            { key => $api_key_of{$ident}, data => $text } );
        return Lingua::AtD::Results->new( { xml => $raw_response } );
    }

    sub check_grammar {
        my ( $self, $text ) = @_;
        my $ident = ident($self);
        my $raw_response =
          $self->_atd( 'checkGrammar',
            { key => $api_key_of{$ident}, data => $text } );
        return Lingua::AtD::Results->new( { xml => $raw_response } );
    }

    sub stats {
        my ( $self, $text ) = @_;
        my $ident = ident($self);
        my $raw_response =
          $self->_atd( 'stats', { key => $api_key_of{$ident}, data => $text } );
        return Lingua::AtD::Scores->new( { xml => $raw_response } );
    }

    #	TODO - Not sure it's useful since all errors carry their own URL.
    #    sub get_info {
    #    }

}

1;
