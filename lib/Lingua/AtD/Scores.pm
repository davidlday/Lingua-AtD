package Lingua::AtD::Scores;
# ABSTRACT: Encapsulates the Scores response from a call to AtD.
use strict;
use warnings;
use Carp;
#use XML::LibXML;
use XML::XPath;
use Lingua::AtD::Metric;
use Class::Std;

{

    # Attributes
    my %xml_of             :ATTR( :init_arg<xml> :get<xml> );
    my %server_message_of  :ATTR( :get<server_message> );
    my %metrics_of         :ATTR();

    sub BUILD {
        my ($self, $ident, $arg_ref) = @_;
        my @atd_metrics = ();

        my $xp = XML::XPath->new( xml => $arg_ref->{xml} );
        my $nodeset = $xp->findnodes('//metric');
        foreach my $node ( $nodeset->get_nodelist ) {
            my $atd_metric   = Lingua::AtD::Metric->new(
                {
                    key   => $node->findvalue('key'),
                    type  => $node->findvalue('type'),
                    value => $node->findvalue('value')
                }
            );
            push( @atd_metrics, $atd_metric );
        }
        $metrics_of{$ident} = [@atd_metrics];

        return;
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
}

1;
