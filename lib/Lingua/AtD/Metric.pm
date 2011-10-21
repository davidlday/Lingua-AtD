package Lingua::AtD::Metric;
# ABSTRACT: Encapsulates the Metrics contained in Scores.
use strict;
use warnings;
use Carp;
use Class::Std;

{

    # Attributes
    my %type_of     :ATTR( :init_arg<type>  :get<type> );
    my %key_of      :ATTR( :init_arg<key>   :get<key> );
    my %value_of    :ATTR( :init_arg<value> :get<value>);

}

1;
