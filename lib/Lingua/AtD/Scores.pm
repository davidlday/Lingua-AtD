package Lingua::AtD::Scores;
# ABSTRACT: Encapsulates the Scores response from a call to AtD.
use strict;
use warnings;
use Carp;
use XML::Simple;
use Lingua::AtD::Metric;
use Class::Std::Utils;

{

    # Scores objects have the following attributes
    my %xml_of;        # Raw XML, only set at creation
    my %message_of;    # Error message from the AtD service
    my %metrics_of;    # AtD spelling/grammar/style errors

    sub new {
        my ( $class, $xml_string ) = @_;

        # Bless a scalar to instantiate the new object...
        my $new_object = bless( anon_scalar(), $class );
        my $ident = ident($new_object);

        # TODO - Check $xml_string and throw exception if empty or undefined.

        $xml_of{$ident}     = $xml_string;
        $message_of{$ident} = undef;
        $metrics_of{$ident} = [];
        my @atd_metrics = ();

        if ( defined($xml_string) ) {

            # Check for server messages
            my $xs = XML::Simple->new( ForceArray => ['scores'] );
            my $results = $xs->XMLin($xml_string);

            # TODO - Why is XML Simple parsing this xml differently?
            foreach my $metric_key ( keys %{ $results->{metric} } ) {
                my $metric_type  = $results->{metric}->{$metric_key}->{type};
                my $metric_value = $results->{metric}->{$metric_key}->{value};
                my $atd_metric   = Lingua::AtD::Metric->new(
                    {
                        key   => $metric_key,
                        type  => $metric_type,
                        value => $metric_value
                    }
                );
                push( @atd_metrics, $atd_metric );
            }

            #foreach my $xml_metric ( @{ $results } ) {
            #my $atd_metric = Lingua::AtD::Metric->new($xml_metric);
            #push( @atd_metrics, $atd_metric );
            #}
            $metrics_of{$ident} = [@atd_metrics];

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

    sub has_metrics {
        my $self = shift;
        return defined( $metrics_of{ ident($self) } );
    }

    sub get_metrics {
        my $self = shift;
        return $self->has_metrics()
          ? @{ $metrics_of{ ident($self) } }
          : undef;
    }

    sub DESTROY {
        my $self = shift;
        my $ident = ident($self);
        
        delete $xml_of{$ident};
        delete $message_of{$ident};
        delete $metrics_of{$ident};
        
        return;
    }

}

1;
