#! /usr/bin/env perl

use strict;
use warnings;

use IPC::Cmd;

print "Search for IP: ";
chomp( my $lookupip = <> );

my $look_cmd = "/sbin/iptables --line-numbers -nvL INPUT";

my ( $look_success, $look_error, $look_full, $look_stdout, $look_stderr ) =
    IPC::Cmd::run( command => $look_cmd );

foreach ( @$look_full ) {
    if ( $_ !~ quotemeta( $lookupip ) ) {
        print "No IPs found matching your search.\n";
        exit 0;
    }
}

my @split_lines = map { split( /\n/, $_ ) } @$look_stdout;
my @matchip = grep { /num|$lookupip/ } @split_lines;
foreach my $matchip ( @matchip ) {
    print "$matchip\n";
}

print "\nID to delist [default = 0 (none)]: ";
chomp( my $delid = <> );

if ( $delid eq "" || $delid == 0 ) {
    print "No changes made.\n";
    exit 0;
}
else {
    my $del_cmd = "/sbin/iptables -D INPUT $delid";

    my ( $del_success, $del_error, $del_full, $del_stdout, $del_stderr ) =
        IPC::Cmd::run( command => $del_cmd );

    if ( !$del_success ) {
        print "Could not drop ID $delid: ";
        print @$del_stderr;
    }
    else {
        system( "/sbin/service iptables save 1> /dev/null" );
        print "Successfully dropped ID $delid\n";
    }
}
