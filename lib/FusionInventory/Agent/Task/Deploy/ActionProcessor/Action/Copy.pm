package FusionInventory::Agent::Task::Deploy::ActionProcessor::Action::Copy;

use strict;
use warnings;

$File::Copy::Recursive::CPRFComp = 1;
use File::Copy::Recursive qw(rcopy);


sub do {
    my ($params) = @_;

    my $log = [];
    my $status;
    $status = rcopy($params->{from}, $params->{to});
    if (!$status) {
        $log = [ "Failed to move file: '".$params->{from}."' to '".$params->{to}."'", $! ];
    }
    return {
    status => $status,
    log => $log,
    };
}

1;