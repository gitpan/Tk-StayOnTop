use strict;
use warnings;

use Test;

BEGIN { plan tests => 4 };

use Tk::StayOnTop;
use Tk;

ok(1); # If we made it this far, we're ok.

my $mw = MainWindow->new();
ok(2);

$mw->stayOnTop();
ok(3);

$mw->dontStayOnTop();
ok(4);

