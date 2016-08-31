#!/usr/bin/perl -w

use common::sense;
use AnyEvent;

my $cv = AE::cv;
 $cv->begin;

my @array = 1..10;

my $i = 0;

my $next; $next = sub {
	my $cur = $i++;
	return if $cur > $#array;
	say "Process $array[$cur]";
	$cv->begin;
	async (sub {
		say "Processed $array[$cur]";
		$next->();
		$cv->end;
	});	
};

$next->() for 1..5;

$cv->end;
$cv->recv;


sub async {
	my $cb= pop;
	my $r = rand(0.1);
	my $w;
	$w = AE::timer $r,0, sub {
		undef $w;
		$cb->();
	};

	return $r;
}
