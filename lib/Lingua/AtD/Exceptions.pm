package Lingua::AtD::Exceptions;
use Exception::Class (
    Lingua::AtD::URLException => {
        fields      => [ 'url', 'host', 'port' ],
        description => 'Indicates a malformed URL.',
    },
    Lingua::AtD::HTTPException => {
        fields => [ 'http_status', 'service_url' ],
        description => 'Indicates a problem connecting to the AtD service.',
    },
    Lingua::AtD::ServiceException => {
        fields      => [ 'service_message' ],
        description => 'Indicates the AtD service returned an error message.',
    },
);

# ABSTRACT: Exception classes for Lingua::AtD

1;    # Magic true value required at end of module
__END__
