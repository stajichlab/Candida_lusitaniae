#!/usr/bin/perl -w
use strict;
use warnings;
use List::Util qw(shuffle);
my @newsnpcount;

my $head = <>;
my ($chrom,$pos,$ref,@samps) = split(/\s+/,$head);
my $n = 0;
my %order = map { $_ => $n++ } @samps;
my @reorder = shuffle @samps;
while(<>) {
    my ($chr,$p,$r,@alleles_orig) = split(/\s+/,$_);
    my @alleles = map { $alleles_orig[$order{$_}] } @reorder;
    my $i = 0;
    my $is_new = 1;
    my %u;
    my @f = grep { !/^\./ && ! $u{$_}++ } @alleles;
    if( @f == 1 && $u{$f[0]} == 1 ) { # singleton
	next;
    }
    for my $allele ( shuffle @alleles ) {
	my ($al) = split(/\//,$allele);
	if( $al ne '.' && $al ne $r ) {
	    if( $is_new ) {
		$newsnpcount[$i]++;
		$is_new = 0;
	    }
	}
#	$ct_obs[$i]++ if $is_new;
	$i++;
#	last if $i > 10;
    }
}
my $i = 0;
print join("\t",qw(INDIVIDUAL NEWSNPS)),"\n";
for my $n ( @newsnpcount ) {
    print join("\t", $i++,$n),"\n";
}
