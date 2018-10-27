#!/usr/bin/perl -w
#
# Usage: perl hash2phrase8.pl <2-digit hex number>
#

use 5.010;
use strict;
use warnings;

my $proverbs1 = {
	template => '%s %s %s – %s %s %s.',
	vars => [[
		[qw/Раз Если Коль/],
		[qw/Когда/],
	], [
		[qw/камень гром ветер/],
		[qw/человек воин гончар кузнец/],
	], [
		[qw/мил крепок ладен/],
		[qw/молчит спит куролесит бдит/],
	], [
		[qw/волна буря вода хурма весна зима/],
		[qw/жена тёща сватья кума/],
	], [
		[''],
		[qw/не/],
	], [
		[qw/сурова могуча обильна/],
		[qw/шумит крепчает смурнеет/],
	]],
};

my $proverbs2 = {
	template => '%s %s и %s %s %s %s.',
	vars => [[
		[qw/Хорошему Доброму Смелому/],
		[qw/Трусливому Плохому Злому/],
	], [
		[qw/змею волку барану козлу/],
		[qw/судье дьяку стряпчему/],
	], [
		[qw/старый ветхий утлый/],
		[qw/новый свежий/],
	], [
		[qw/плот корабль чёлн/],
		[qw/тарантас кабриолет/],
	], [
		[qw//],
		[qw/не/],
	], [
		[qw/впрок лаком/],
		[qw/лишний зря/],
	]],
};

my $proclamation = {
	template => 'О %s %s, да %s %s! %s %s.',
	vars => [[
		[qw/друзья братья люди/],
		[qw/родные ближние/],
	], [
		[qw/мои истинные/],
		[qw/ненавистные завистливые неискренние лживые/],
	], [
		[''],
		[qw/не/],
	], [
		[qw/возгордимся восхитимся возмечатем воспарим/],
		[qw/помиримся успокоимся сроднимся/],
	], [
		[qw/Ведь Ибо/],
		[qw/Иначе/],
	], [
		[qw/неестественно больно страшно умилительно/],
		[qw/смерть счастье радость/],
	]],
};

my $lyrics = {
	template => '%s %s похож на %s: %s %s %s...',
	vars => [[
		[qw/Сон Полёт Шум Хайп/],
		[qw/Сокол Орёл Лев/],
	], [
		[''],
		[qw/не/],
	], [
		[qw/омелу боярышник черемшу кинзу/],
		[qw/выдру осла человека лесничего/],
	], [
		[qw/дарит преподносит/],
		[qw/крадёт забирает отнимает/],
	], [
		[qw/лишь только/],
		[qw/даже/],
	], [
		[qw/миг мгновение минуту/],
		[qw/час век столетие/],
	]],
};

sub generate_pharse
{
	my $hash_num = shift;
	my $genre = shift;
	my $vars = $genre->{vars};
	my @terms;

	for my $i (0 .. 5) {
		my $category = ($hash_num & (1 << $i)) ? 1 : 0;
		my $terms = $vars->[$i][$category];
		my $index = @$terms > 1 ? int(rand(@$terms - 1)) : 0;
		push @terms, $terms->[$index];
	}

	return sprintf $genre->{template}, @terms;
}

my @genres = (
	$proverbs1,
	$proverbs2,
	$proclamation,
	$lyrics,
);
my $hash_str = lc($ARGV[0] // '');

unless ($hash_str =~ /^[0-9a-f]{2}$/) {
	die 'Please specify a 2-digit hex number as input';
}

my $hash_num = hex($hash_str);
my $genre = $genres[($hash_num & 0xC0) >> 6];
my $phrase = generate_pharse($hash_num, $genre);

$phrase =~ s/\s{2,}/ /g;
say $phrase;

exit;
