#!/usr/bin/perl

sub myshows_login {
	`wget --save-cookies=/tmp/myshowscookie.txt "http://api.myshows.me/profile/login?login=nightlord&password=f19d231b70f8ac7c495c9fcef80639ed" --keep-session-cookies --spider -qO-`
	}
sub ipt_login {
	`wget --save-cookies=/tmp/ipt.txt https://iptorrents.com --post-data 'username=nightbbs&password=Ossdb242' -qO-`
	}
myshows_login;
ipt_login;

my @titles=`wget --load-cookies=/tmp/myshowscookie.txt "api.myshows.me/profile/shows/" -qO- | json_reformat | grep title`;
my @episodes=`wget  --load-cookies=/tmp/myshowscookie.txt "api.myshows.me/profile/episodes/unwatched/" -qO- | json_reformat | grep -A2 episodeId`;
$n = 0;
foreach $episode (@episodes)
  	{
	if ($episode =~ /.*episodeId.*/) {
	$episodes[$n+1] =~ s/.*"title": (.*),/\1/;
	print "Episode name - @episodes[$n+1]\n"; 
	$episode_title=$episodes[$n+1];
	$episodes[$n+2] =~ s/.*"showId"(.*)\n/\1/;
	$rawtitle_of_show = 0;
	$COMMAND="wget --load-cookies=/tmp/myshowscookie.txt \"api.myshows.me/profile/shows/\" -qO- | json_reformat | grep -A 1 \"$episodes[$n+2]\"";
	print " теперь ищем название шоу - $episodes[$n+2] командой $COMMAND\n";
		my @rawtitle_of_show=`$COMMAND`;
		$title_of_show=$rawtitle_of_show[1];
		$title_of_show =~ s/.*"title": (.*),\n/\1/;
		print "Название шоу: $title_of_show\n";

		system("wget --load-cookies=/tmp/ipt.txt 'https://iptorrents.com/t?q=$title_of_show $episode_title 720p;o=seeders#torrents' -O /tmp/iptorrents.txt");
		if ( system("grep 'No torrents' /tmp/iptorrents.txt") eq 0) {
		    break;
		    }
		$torrent = `cat /tmp/iptorrents.txt | perl -pe 's|.*(download.php.*.torrent).*|https://iptorrents.com/\\1|'`;		
		print "\nDownloading $torrent...\n";
		system("wget --load-cookies=/tmp/ipt.txt \"$torrent\"");
		print "\n\n\nTorrent - $torrent\n\n\n\n";
 		
		}
	$n++;
	}


