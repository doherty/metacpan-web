package MetaCPAN::Web::Controller::Requires;

use Moose;
use namespace::autoclean;

BEGIN { extends 'MetaCPAN::Web::Controller' }

# The order of the columns matters here. It aims to be compatible
# to jQuery tablesorter plugin.
__PACKAGE__->config(
    sort => {
        module => {
            columns => [qw(name abstract date)],
            default => [qw(date desc)],
        }
    }
);

sub index : Chained('/') : PathPart('requires') : CaptureArgs(0) {
}

sub module : Chained('index') : PathPart : Args(1) : Does('Sortable') {
    my ( $self, $c, $module, $sort ) = @_;
    my $cv = AE::cv();
    my $data
        = $c->model('API::Module')->requires( $module, $c->req->page, $sort )
        ->recv;
    $c->stash( { %{$data}, module => $module, template => 'requires.html' } );
}

1;
