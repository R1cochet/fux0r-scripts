## Put me in ~/.irssi/scripts, and then execute the following in irssi:
## /script load fux0r.pl
##
## To autoload script on irssi start create a symlink in ~/.irssi/scripts/autorun
## eg. cd ~/.irssi/scripts/autorun/ ; ln -s ../fux0r.pl
##
use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = "2.01";
%IRSSI = (
    authors     => 'R1cochet, ogmios',
    contact     => '#fux0r',
    name        => 'fux0r_ssl_nonssl.pl',
    description => 'Turn ssl into non-ssl and vice versa.',
    license     => 'GNU General Public License',
    changed     => 'Sat Oct  8 16:58:22 PDT 2011',
);

sub print_text_transform_ssl {
    my ($server, $msg, $nick, $nick_addr, $target) = @_;
    return if ( $target  !~ m/#(?:fux0r|testbed)/ );    # limit channels
    return if ( $nick =~ m/(?:XXX|someasshole)/ );      # prevent who to listen to
    return if ( $msg !~ m/(ssl\.fux0r|hey\.fux0r)/ );   # stop script if no fux0r link
    my $text = Irssi::strip_codes($msg);
    my @setChoice = (1, 0);                             # (1 to not show original message, 0 for nonssl>ssl 1 for ssl->nonssl, )
    if ( $setChoice[0] == 1 ) {                         # stop original message from displaying
        Irssi::signal_stop();
    }
    if ( $setChoice[1] == 0 ) {
        $text=~s/http\:\/\/hey/https\:\/\/ssl/;
    }
    elsif ( $setChoice[1] == 1 ) {
        $text=~s/https\:\/\/ssl/http\:\/\/hey/;
    }
    $server->print($target, "\00314<\0038 $nick\00314>\003 $text", MSGLEVEL_CLIENTCRAP);
}
Irssi::signal_add('message public', 'print_text_transform_ssl');
