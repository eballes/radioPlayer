#!/usr/bin/ruby1.9.1
#===============================================================================
#         FILE:  radioPlayer.rb
#
#       AUTHOR:  EEBR ()
#      VERSION:  1.0
#      CREATED:  04/13/2011 03:56:25 PM
#===============================================================================

include Process
require 'term/ansicolor'
include Term::ANSIColor
require 'getoptlong' 
$gVerbose = nil
$pid = nil

Signal.trap("INT") do
        puts "Exiting..."
        Process.kill("QUIT", $pid)
      end

(MPLAYER = `which mplayer`).chomp!
(CVLC = `which cvlc`).chomp!

Stations = {
    "MOS" => 'http://89.238.166.195:9162/listen.pls',
    "BBC1" => 'http://bbc.co.uk/radio/listen/live/r1.asx',
    "BBC2" => 'http://bbc.co.uk/radio/listen/live/r2.asx',
    "BBC3" => 'http://bbc.co.uk/radio/listen/live/r3.asx',
    "BBC4" => 'http://bbc.co.uk/radio/listen/live/r4.asx',
    "BBC5" => 'http://bbc.co.uk/radio/listen/live/r5l.asx',
    "BBC6" => 'http://bbc.co.uk/radio/listen/live/r6.asx',
    "BBCWorld" => 'http://www.bbc.co.uk/worldservice/meta/tx/nb/live/eneuk.pls',
    "BBCWorldNews"=>'http://www.bbc.co.uk/worldservice/meta/tx/nb/live/ennws.pls',
    "BBCScotland" => 'http://wmlive.bbc.co.uk/wms/nations/scotland',
    "AR" => 'http://ogg2.as34763.net/vr160.ogg.m3u',
    "AR80" => 'http://ogg2.as34763.net/a8160.ogg.m3u',
    "AR90" => 'http://mp3-a9-128.as34763.net/listen.pls',
    "AR00" => 'http://mp3-a0-128.as34763.net/listen.pls'
}

Players = {
    "pls" => CVLC,
    "asx" => CVLC,
    "m3u" => CVLC,
}

def play(station) 
    
    #Regexp.new(Regexp.escape('\.(?<extension>[\w\d]+)$')) =~ Stations[station]
    Stations[station] =~ /\.([\w\d]+)$/
    player = Players[$1]
    player = CVLC unless player 

    $pid = fork
    if $pid 
        print red, "Press Ctrl+C to stop execution...", reset, "\n"
        puts "Playing..."
        wait
    else
        sleep(1)
        #print "Player: ", player, " Station: ", Stations[station], "\n"
        
        $stdin.reopen('/dev/null', 'r')
        $stdout.reopen('/dev/null', 'w') unless $gVerbose
        $stderr.reopen('/dev/null', 'w') unless $gVerbose
        
        exec player, Stations[station]
    end

end

def help
    print "\n ", $0, " -s <station> [-v]\n\n"

    puts "Allowed stations:"
    Stations.each {|key, value| print "\t#{key}\n" }
    puts ""
    exit 0
end

def main()
    opts = GetoptLong.new(  
         [ "--radio", "-r", GetoptLong::REQUIRED_ARGUMENT ],  
         [ "--help", "-h", GetoptLong::NO_ARGUMENT ],  
         [ "--verbose", "-v", GetoptLong::NO_ARGUMENT ],  
        )  

    if ARGV.length == 0
      help
    end

    radio = nil
    opts.each do |opt, arg|
        case opt
            when '--help'
                help
            when '--radio'
                radio = arg
            when '--verbose'
                $gVerbose = 1
            end
    end
                   
    help unless Stations[radio]
     
    play(radio);
end

main()

