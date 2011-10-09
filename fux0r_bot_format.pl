use strict;
use warnings;
use vars qw($VERSION %IRSSI);
use Irssi;

#### How To Use ####
# to show the original bot announcement change $print_orig to "0" line 62
# 
#### Explanation of @arrays ####
# 1 = true, do print the item; 0 = false, don't print the item
# @title_config: header format | do/don't use | print header | print title | print subtitle | print date
# @info_config:  header format | do/don't use | print header | print container | print codec | print source | print scene/hd
# @url_config:   header format | do/don't use | print header | print http link | print https link
# @tid_config:   header format | do/don't use | print header | print tid#
# @delimters:    first delimeter | middle delimeter | end delimeter
#
#### colors and bold text ####
# to print bold text prepend the text with "/002"
# ex: "/002New Porn" will print "New Porn" and everything after it in bold text. to stop bold text put "\002" where you want bold text to stop
#
# to print colored text prepend the text with "/003" followed by a number
# ex: "/0034New Porn" will print "New Porn" and everything following in the color red. Same rules apply as bold text
# to print colored text with a colored background do the same as before but add ",#"
# ex: "/0034,10New Porn/003" will print "New Porn" in red text with a yellow background. The trailing "/003" will end the color formatting
#
# for a listing of the color numbers please see https://github.com/shabble/irssi-docs/wiki/Formats
#
#### Final output
# You may change the order in which the items are displayed
# At the bottom of this script is the print command. Just add/remove/rearrange the order in which you wish the items to be printed
#
#### caveats ####
# if you have the option to print a header turned on, you must set the header in the corresponding array
# for colored and bold delimeters, they must be set in the @delimeters array
#

$VERSION = '2.10';
%IRSSI = (
    authors     => 'R1cochet',
    contact     => '#fux0r',
    name        => 'Bot Print Format',
    description	=> 'Reformat a msg by a bot and whether to print original',
    license     => 'GNU General Public License v3.0',
    changed     => 'Sat Oct  8 17:02:18 PDT 2011',
);

sub message_public {
    my ($server, $msg, $nick, $nick_addr, $target) = @_;

    return if ( $nick !~ m/(?:XXX|yournick)/ );        # limit who your listing to
    return if ( $target  !~ m/#(?:fux0r|testbed)/ );   # limit channels


    if ($msg =~ /New\sFilth/ ) {                       # listen for msg containing "New Filth"


        my $text = Irssi::strip_codes($msg);           # strip color codes from text

     #### initialize variables ####
        my ($title_string, $info_string, $url_string, $tid_string);    # initialize print string variables
        my $print_orig = 1;                                            # dont print original message 1=true (use for debugging)
        my @title_config = ("\002\00312New Porn\002\003", 1, 1, 1, 1, 1,);               # use custom title line 1=true, {use, print header, print title, print subtitle, print date}
        my @info_config = ("\002\00312Rip Info\002\003", 1, 1, 1, 1, 1, 1);              # use custom details line 1=true {use, print header, print container, print codec, print source, print scene/hd}
        my @url_config = ("\002\00312URL\002\003", 1, 1, 0, 1);                          # use custom url line 1=true {use, print header, print http, print https}
        my @tid_config = ("\002\00312Torrent ID\002\003", 0, 1, 1);                      # use custom tid line 1=true {use, print header, print number}
        my @delimeters = ("\002\0036{\002\003", "\002\00312-\002\003", "\002\0036}\002\003");  # set custom delimeters
        my $final_format = "";                                         # set format of final print


        Irssi::signal_stop() if ( $print_orig =~ /1/ );                # stop original output from displaying

    #### split incoming text into title, info, url, and tid
        my ($title, $info, $url, $tid) = split(/\s\)/, $text);           # original split method
#        my ($title, $info, $url, $tid) = split(/New\sTorrent\s\(\s|\s\)\sFormats\s\(\s|\s\)\sURL\s\)\s|\s\)\sTID\s\(\s/, $text);

        my @title_line = split /\s+[(-]\s+/, $title;
        foreach my $line (@title_line) {
            $line =~ s/^\s+|\s+$//g;
        }

        my @info_line = split /\s+[(\/]\s+/, $info;
        foreach my $line (@info_line) {
            $line =~ s/^\s+|\s+$//g;
            $line =~ s/\/\s|\s\///g;
        }

        my @url_line = split /\s+[(\/]\s+/, $url;
        foreach my $line (@url_line) {
            $line =~ s/^\s+|\s+$//g;
        }

        my @tid_line = split /\s+[(\/]\s+/, $tid;
        foreach my $line (@tid_line) {
            $line =~ s/^\s+|\s+$//g;
        }

    #### build title line
        if ( $title_config[1] == 1 ) {                   # check if replacing title
            if ( $title_config[2] == 1 ) {               # check if using header
                $title_string = "$title_config[0] " if defined $title_config[0];
            }

            $title_string = $title_string . $delimeters[0];

            if ( $title_config[3] == 1 ) {               # check if using title
                $title_string = $title_string . " $title_line[1]" if defined $title_line[1];
            }

            if ( $title_config[4] == 1 ) {                          # check if using subtitle
                if ( $title_config[3] == 1 && $title_line[1] ) {    # check if using title and title is defined
                    $title_string = $title_string . " $delimeters[1] $title_line[2]" if defined $title_line[2];
                }
                else {
                    $title_string = $title_string . " $title_line[2]" if defined $title_line[2];
                }
            }

            if ( $title_config[5] == 1 ) {                                # check if using date
                if ( $title_config[3] == 1 || $title_config[4] == 1 ) {   # check if using title or subtitle
                    if ( $title_line[3] || $title_line[4] ) {             # check if title or sub are defined
                        $title_string = $title_string . " $delimeters[1] $title_line[3]" if defined $title_line[3];
                    }
                    else {
                        $title_string = $title_string . " $title_line[3]" if defined $title_line[3];
                    }

                }
                else {
                    $title_string = $title_string . " $title_line[3]" if defined $title_line[3];
                }
            }
            $title_string = $title_string . " $delimeters[2]";
        }

    #### build info line
        if ( $info_config[1] == 1 ) {                             # check if replacing info
            if ( $info_config[2] == 1 ) {                         # check if using header
                $info_string = "$info_config[0] ";
            }
            $info_string = $info_string . $delimeters[0];
            if ( $info_config[3] == 1 ) {                         # check if using container
                $info_string = $info_string . " $info_line[1]" if defined $info_line[1];
            }
            if ( $info_config[4] == 1 ) {                         # check if using codec
                if ( $info_config[3] == 1 && $info_line[1] ) {    # if using container and container is defined
                    $info_string = $info_string . " $delimeters[1] $info_line[2]" if ($info_line[2] && $info_line[2] !~ /\//);
                }
                else {
                    $info_string = $info_string . " $info_line[2]" if defined $info_line[2];
                }
            }
            if ( $info_config[5] == 1 ) {                               # check if using source
                if ( $info_config[3] == 1 || $info_config[4] == 1 ) {   # check if using container or codec
                    if ( $info_line[1] || $info_line[2] ) {             # check if container or codec defined
                        $info_string = $info_string . " $delimeters[1] $info_line[3]" if ($info_line[3] && $info_line[3] !~ /\//);
                    }
                    else {
                        $info_string = $info_string . " $info_line[3]" if defined $info_line[3];
                    }
                }
                else {
                    $info_string = $info_string . " $info_line[3]" if defined $info_line[3];
                }
            }
            if ( $info_config[6] == 1 ) {                                                      # check is using scene/hd
                if ( $info_config[3] == 1 || $info_config[4] == 1 || $info_config[5] == 1 ) {  # check if using container, codec, or source
                    if ( $info_line[1] || $info_line[2] || $info_line[3] ) {
                        $info_string = $info_string . " $delimeters[1] $info_line[4]" if defined $info_line[4];
                    }
                    else {
                        $info_string = $info_string . " $info_line[4]" if defined $info_line[4];
                    }
                }
                else {
                    $info_string = $info_string . " $info_line[4]" if defined $info_line[4];
                }
            }
        $info_string = $info_string . " $delimeters[2]";
        }

    #### build URL line
        if ( $url_config[1] == 1 ) {                             # check if replacing url
            if ( $url_config[2] == 1 ) {                         # check if using header
                $url_string = "$url_config[0] ";
            }
            $url_string = $url_string . $delimeters[0];
            if ( $url_config[3] == 1 ) {                         # check if using http
                $url_string = $url_string . " $url_line[1]" if defined $url_line[1];
            }
            if ( $url_config[4] == 1 ) {                         # check if using https
                if ( $url_config[3] == 1 && $url_line[1] ) {     # check if using http and http is defined
                    $url_string = $url_string . " $delimeters[1] $url_line[2]" if defined $url_line[2];
                }
                else {
                    $url_string = $url_string . " $url_line[2]" if defined $url_line[2];
                }
            }
            $url_string = $url_string . " $delimeters[2]";
        }

    #### build TID line
        if ( $tid_config[1] == 1 ) {                             # check if replacing url
            if ( $tid_config[2] == 1 ) {                         # check if using header
                $tid_string = "$tid_config[0] ";
            }
            $tid_string = $tid_string . $delimeters[0];
            if ( $tid_config[3] == 1 ) {                         # check if using id number
                $tid_string = $tid_string . " $tid_line[1]" if defined $tid_line[1];
            }
            $tid_string = $tid_string . " $delimeters[2]";
        }

    #### print final output
        $server->print($target, "\00314<\0037 $nick\00314>\003 \002$title_string", MSGLEVEL_CLIENTCRAP);
        $server->print($target, "       \002$info_string $url_string", MSGLEVEL_CLIENTCRAP);
    }
}

Irssi::signal_add('message public', 'message_public');
