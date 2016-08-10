# --
# Kernel/Language/de_TicketPrintRichtext.pm - provides german language translation for TicketPrintRichtext package
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Mario(dot)Illinger(at)cape(dash)it(dot)de

# --
# $Id$
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de_TicketPrintRichtext;
use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # $$START$$

    $Lang->{'Please select the type of printout'} = 'Bitte den Typ des Ausdrucks auswählen';

    $Lang->{'Print Richtext'} = 'Richtextausdruck';
    $Lang->{'Print Standard'} = 'Standardausdruck';

    $Lang->{'Ask every time'} = 'Immer nachfragen';
    $Lang->{'Print richtext'} = 'Richtextausdruck';
    $Lang->{'Print standard'} = 'Standardausdruck';

    #$Lang->{''} = '';

    return 0;

    # $$STOP$$
}
1;
