# --
# TicketPrintRichtext.pm - code run during package de-/installation
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by
# * Frank(dot)Oberender(at)cape(dash)it(dot)de
#
# --
# $Id$
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::TicketPrintRichtext;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision$) [1];

our @ObjectDependencies = (
    #'Kernel::Config',
    #'Kernel::System::SysConfig',
    #'Kernel::System::GenericAgent',
    #'Kernel::System::GenericInterface::Webservice',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );


    # create needed sysconfig object...

    $Self->{SysConfigObject} = $Kernel::OM->Get('Kernel::System::SysConfig');
    $Self->{SysConfigObject}->WriteDefault();

    my @ZZZFiles = ( 'ZZZAAuto.pm', 'ZZZAuto.pm', );

    # reload the ZZZ files (mod_perl workaround)
    for my $ZZZFile (@ZZZFiles) {
        PREFIX:
        for my $Prefix (@INC) {
            my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
            if ( !-f $File ) {
                next PREFIX;
            }
            do $File;
            last PREFIX;
        }
    }

    # always discard the config object before package code is executed,
    # to make sure that the config object will be created newly, so that it
    # will use the recently written new config from the package
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::Config'],
    );

    # create additional objects...
    $Self->{ConfigObject}       = $Kernel::OM->Get('Kernel::Config');

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;
    
    #$Self->_SetUserPreferences();
    
    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;
    
    #$Self->_SetUserPreferences();
    
    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;
    
    #$Self->_SetUserPreferences();
    
    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;
    
    $Self->_RemoveUserPreferences();
    
    return 1;
}

sub _SetUserPreferences {
    my ( $Self, %Param ) = @_;

    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('PreferencesTable')
        || 'user_preferences';
    $Self->{PreferencesTableKey} = $Self->{ConfigObject}->Get('PreferencesTableKey')
        || 'preferences_key';
    $Self->{PreferencesTableValue} = $Self->{ConfigObject}->Get('PreferencesTableValue')
        || 'preferences_value';
    $Self->{PreferencesTableUserID} = $Self->{ConfigObject}->Get('PreferencesTableUserID')
        || 'user_id';
    
    # get all users
    my %UserList        = $Self->{UserObject}->UserList();

    USER:
    for my $UserID ( keys %UserList ) {

        my $Prepare = $Self->{DBObject}->Prepare(
            SQL => "SELECT $Self->{PreferencesTableValue} FROM $Self->{PreferencesTable}
                WHERE $Self->{PreferencesTableUserID} = $UserID AND $Self->{PreferencesTableKey} like 'UserPrintBehaviour'",
        );

        if ( !$Prepare ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "packagesetup TicketprintRichtext: error in prepare SQL!"
            );
        }
        else {
            my @Row = $Self->{DBObject}->FetchrowArray();
            if (scalar(@Row) == 0) {
                # insert new data
                $Self->{DBObject}->Do(
                    SQL => "
                        INSERT INTO $Self->{PreferencesTable}
                        ($Self->{PreferencesTableUserID}, $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue})
                        VALUES (?, 'UserPrintBehaviour', 'ask')",
                    Bind => [ \$UserID, ],
                );
            }
        }
    }
}

sub _RemoveUserPreferences {
    my ( $Self, %Param ) = @_;

    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('PreferencesTable')
        || 'user_preferences';
    $Self->{PreferencesTableKey} = $Self->{ConfigObject}->Get('PreferencesTableKey')
        || 'preferences_key';
    
    $Self->{DBObject}->Do(
        SQL => "
            DELETE FROM $Self->{PreferencesTable} WHERE $Self->{PreferencesTableKey} LIKE 'UserPrintBehaviour' ",
    );
}


1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION
$Revision$ $Date$
=cut
