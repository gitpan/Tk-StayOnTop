package Tk::StayOnTop;

our $VERSION = 0.03;

#==============================================================================#

=head1 NAME

Tk::StayOnTop - Keep your window in the foreground

=head1 SYNOPSIS

        use Tk::StayOnTop;
        $toplevel->stayOnTop;
        $toplevel->dontStayOnTop;

=head1 DESCRIPTION

Adds methods to the Tk::Toplevel base class so that a window can stay on top
off all other windows

=head2 METHODS

=over 4

=cut

#==============================================================================#

package Tk::Toplevel;

use strict;
use warnings;
use Carp;

my ($win32_winpos,$repeat_id);

if ($^O =~ /Win32/) {

	# Win32 implementation uses setwindowpos() function.
	# See http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/windowing/windows/windowreference/windowfunctions/setwindowpos.asp
	#define SWP_NOSIZE          0x0001
	#define SWP_NOMOVE          0x0002
	#define SWP_NOZORDER        0x0004
	#define SWP_NOREDRAW        0x0008
	#define SWP_NOACTIVATE      0x0010
	#define SWP_FRAMECHANGED    0x0020  
	#define SWP_SHOWWINDOW      0x0040
	#define SWP_HIDEWINDOW      0x0080
	#define SWP_NOCOPYBITS      0x0100
	#define SWP_NOOWNERZORDER   0x0200  
	#define SWP_NOSENDCHANGING  0x0400  
	#define SWP_DRAWFRAME       SWP_FRAMECHANGED
	#define SWP_NOREPOSITION    SWP_NOOWNERZORDER
	#if(WINVER >= 0x0400)
	#define SWP_DEFERERASE      0x2000
	#define SWP_ASYNCWINDOWPOS  0x4000
	#endif /* WINVER >= 0x0400 */
	#define HWND_TOP        ((HWND)0)
	#define HWND_BOTTOM     ((HWND)1)
	#define HWND_TOPMOST    ((HWND)-1)
	#define HWND_NOTOPMOST  ((HWND)-2)

	eval "use Win32::API"; croak $@ if $@;
	$win32_winpos = Win32::API->new(
			'user32', 'SetWindowPos',
			['N','N','N','N','N','N','N'], 'N'
	);
}

#==============================================================================#

=item $toplevel->stayOnTop();

Keep $toplevel in the foreground.

=cut

sub stayOnTop {
	my ($obj) = @_;
	if ($^O =~ /Win32/) {

		$obj->update;
		# HWND_TOPMOST (-1) and SWP_NOSIZE+SWP_NOMOVE (3)
		$win32_winpos->Call(hex($obj->frame()),-1,0,0,0,0,3);

	} else {

		# This is hard in non windows land. Any ideas?

		$obj->deiconify;
		$obj->raise;
	
		$repeat_id = $obj->repeat(250, sub {
			$obj->deiconify;
			$obj->raise;
		}) unless defined $repeat_id;

	}
}

#==============================================================================#

=item $toplevel->dontStayOnTop();

Return $toplevel to normal behaviour.

=cut

sub dontStayOnTop {
	my ($obj) = @_;

	if ($^O =~ /Win32/) {
		$obj->update;
		# HWND_NOTOPMOST (-2) and SWP_NOSIZE+SWP_NOMOVE (3)
		$win32_winpos->Call(hex($obj->frame()),-2,0,0,0,0,3);
	} else {
		$obj->afterCancel($repeat_id);
		$repeat_id = undef;
	}

}

#==============================================================================#

=back

=head1 BUGS

Under Win32, funtionality is implemented through Win32::API. Under 
X-windows, functianality is very crude. Any suggestions for Window Manager
support under X would be appreciated.

=head1 AUTHOR

This module is Copyright (c) 2002 Gavin Brock gbrock@cpan.org. All rights
reserved. This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Tk>

L<Win32::API>

=cut

# That's all folks..
#==============================================================================#
1;
