#!/usr/bin/perl 
#===============================================================================
#         FILE:  radioPlayer.pl
#
#       AUTHOR:  EEBR ()
#      VERSION:  1.0
#      CREATED:  03/29/2011 08:58:41 AM
#===============================================================================

use strict;
use warnings;
use Carp;
use Data::Dumper;
use File::Basename;
use Getopt::Long;

chomp(my $MPLAYER = `which mplayer`);
chomp(my $CVLC = `which cvlc`);

my $stations = {
    MOS => 'http://89.238.166.195:9162/listen.pls',
    BBC1 => 'http://bbc.co.uk/radio/listen/live/r1.asx',
    BBC2 => 'http://bbc.co.uk/radio/listen/live/r2.asx',
    BBC3 => 'http://bbc.co.uk/radio/listen/live/r3.asx',
    BBC4 => 'http://bbc.co.uk/radio/listen/live/r4.asx',
    BBC5 => 'http://bbc.co.uk/radio/listen/live/r5l.asx',
    BBC6 => 'http://bbc.co.uk/radio/listen/live/r6.asx',
    BBCWorld => 'http://www.bbc.co.uk/worldservice/meta/tx/nb/live/eneuk.pls',
    #BBCWorldNews => 'http://www.bbc.co.uk/worldservice/meta/tx/nb/live/ennws.pls',
    BBCScotland => 'http://wmlive.bbc.co.uk/wms/nations/scotland',
    AR => 'http://ogg2.as34763.net/vr160.ogg.m3u',
    AR80 => 'http://ogg2.as34763.net/a8160.ogg.m3u',
    AR90 => 'http://mp3-a9-128.as34763.net/listen.pls',
    AR00 => 'http://mp3-a0-128.as34763.net/listen.pls',
};

my $players = {
    pls => $MPLAYER,
    asx => $CVLC,
    m3u => $CVLC,
};


sub play {
    my ($station) = @_;

    croak "Station not found! -> $station" unless $stations->{$station};
    my $url = $stations->{$station};

    my $player;
    if (my ($extension) = $url =~ /\.([\w\d]+)$/) {
        $player = $players->{lc $extension};
    }
    $player = $MPLAYER unless $player;
    croak "Suitable player not found!" unless $player;

    exec ($player, $url); # I don't want to come back! 
}


######################### MAIN ########################################
sub help {
    print "\n./", basename($0), " -s <station>", "\n\n";
    
    print "Allowed stations:\n\t";
    {
        local $, = "\n\t";
        print sort keys %{$stations};
    }
    print "\n";
    exit;
}

sub main {
    GetOptions(
        'radio|r|station|s=s' => \( my $station = undef ),
        'help|h'    => \( my $printHelp = undef ),
    );

    help() if $printHelp;
    help() unless $station;

    play($station);
}

main();

