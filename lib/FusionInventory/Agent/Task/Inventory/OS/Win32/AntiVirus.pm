package FusionInventory::Agent::Task::Inventory::OS::Win32::AntiVirus;

use strict;
use warnings;

use Config;
use Win32;
use Win32::OLE qw(in CP_UTF8);
use Win32::OLE::Variant;

use FusionInventory::Agent::Tools::Win32;

sub isInventoryEnabled {
    return 1;
}

sub doInventory {
    my ($params) = @_;

    my $inventory = $params->{inventory};
    my $logger    = $params->{logger};

    # Doesn't works on Win2003 Server
    # On Win7, we need to use SecurityCenter2
    foreach my $instance (qw/SecurityCenter SecurityCenter2/) {
        my $WMIServices = Win32::OLE->GetObject(
            "winmgmts:{impersonationLevel=impersonate,(security)}!//./root/$instance"
        );

        if (!$WMIServices) {
            $logger->error(Win32::OLE->LastError());
            return;
        }

        foreach my $properties (Win32::OLE::in($WMIServices->InstancesOf(
                "AntiVirusProduct"))) {
            $inventory->addAntiVirus({
                COMPANY  => $properties->{companyName},
                NAME     => $properties->{displayName},
                GUID     => $properties->{instanceGuid},
                ENABLED  => $properties->{onAccessScanningEnabled},
                UPTODATE => $properties->{productUptoDate},
                VERSION  => $properties->{versionNumber}
            });
        }
    }
}

1;
