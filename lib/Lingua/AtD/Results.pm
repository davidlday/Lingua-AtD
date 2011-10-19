package Lingua::AtD::Results;
use strict;
use warnings;
use Carp;
use XML::Simple;
use Class::Std::Utils

{

	# Result objects have the following attributs
	my %xml_of;		# Raw XML, only set at creation
	my %message_of;	# Error message from the AtD service
	my %errors_of;	# AtD spelling/grammar/style errors

	sub new {
		my $class = shift;
		my $xml = shift;
		my $self = {};

		$self->{XML} = $xml;
		$self->{MESSAGE} = undef;
		$self->{ERRORS} = [];

		$self->_parse_results();

		bless ($self, $class);
		return $self;
	}

	# Accessor Methods

	sub xml {
		my $self = shift;
		return $self->{XML};
	}

	sub message {
		my $self = shift;
		return $self->{MESSAGE};
	}

	sub errors {
		my $self = shift;
		return @{ $self->{ERRORS} };
	}

	# Process the results XML

	sub _parse_results {
		my $self = shift;
		my @atd_errors = [];
		if (defined($self->{XML})) {
			# Check for server messages
			My $xs = XML::Simple->new( ForceArray => [ 'option' ] );
			my $results = $xs->XMLin($self->{XML});
			foreach my $error ( @{ $results->{error} } ) {
				my $atd_error = Lingua::EN::AtD::Results::Error->new($error);
				push(@atd_errors, $atd_error);
			}
			$self->{ERRORS}= [ @atd_errors ];
			# In theory, there's only one message.
			# TODO - Should we throw an error here or higher?
			if (defined($results->{message}) {
				$self->{MESSAGE} = $results->{message};
			}
		}
	}
}

# Bad form, but this is only useful as part of a results;
package Lingua::AtD::Results::Error;
{
	# Error objects have the following attributs
	my %string_of;
	my %description_of;
	my %precontext_of;
	my %suggestions_of;
	my %type_of;
	my %url_of;

	sub new {
		my $class = shift;
		my $error_hash = shift;
		my $self = {};

		$self->{STRING} = undef;
		$self->{DESCRIPTION} = undef;
		$self->{PRECONTEXT} = undef;
		$self->{SUGGESTIONS} = [];
		$self->{TYPE} = undef;
		$self->{URL} = undef;

		if (defined($error_hash)) {
			$self->{STRING} = $error_hash->{string};
			$self->{DESCRIPTION} = $error_hash->{description};
			$self->{PRECONTEXT} = $error_hash->{precontext};
			$self->{SUGGESTIONS} = @{$error->{suggestions}->{option}};
			$self->{TYPE} = $error_hash->{type};
			$self->{URL} = $error_hash->{url};
		}

		bless ($self, $class);
		return $self;
	}

	sub string {
		return $self->{STRING};
	}

	sub description {
		return $self->{DESCRIPTION};
	}

	sub precontext {
		return $self->{PRECONTEXT};
	}

	sub suggestions {
		return $self->{SUGGESTIONS};
	}

	sub options {
		return $self->suggestions;
	}

	sub type {
		return $self->{TYPE};
	}
	sub url {
		return $self->{URL};
	}
}

1;
