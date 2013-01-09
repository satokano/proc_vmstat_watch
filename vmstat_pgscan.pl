#!/usr/bin/perl

use strict;
use warnings;
use utf8;

if (@ARGV != 1) {
    print "sleep時間(秒)を指定してください.\n";
    exit(1);
}

my $interval = $ARGV[0];
my %stat_previous;
my %stat;

print "pgscan_direct_dma,pgscan_direct_dma32,pgscan_direct_normal,pgscan_direct_movable\n";

while () {
    open(PROC, "</proc/vmstat") or die "$!";
    while (<PROC>) {
        if (/(\w+)\s(\d+)/) {
            $stat{$1} = $2;
        }
    }

    #map { print "$_,$stat{$_}\n" } keys %stat;

    if (%stat_previous) {
        my $dma = $stat{"pgscan_direct_dma"} - $stat_previous{"pgscan_direct_dma"};
        my $dma32 = $stat{"pgscan_direct_dma32"} - $stat_previous{"pgscan_direct_dma32"};
        my $normal = $stat{"pgscan_direct_normal"} - $stat_previous{"pgscan_direct_normal"};
        my $movable = $stat{"pgscan_direct_movable"} - $stat_previous{"pgscan_direct_movable"};

        print "$dma,$dma32,$normal,$movable\n";
    } else {
        # 初回はスキップ
    }

    %stat_previous = %stat;

    close(PROC);

    sleep($interval);
}

