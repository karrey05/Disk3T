#! /usr/bin/perl 
# transform original isd_history.csv file to new format for cql copy 

use Time::Piece;

$infile="isd-history.csv"; 
# read in the list
open(LIST, "<$infile") or die "Can not open list file: $!";
@list=<LIST>;
close(LIST);

# skip header 
shift @list; 

foreach $line (@list) {
  chomp $line;
  $line =~ s/"//g; 
  ($usaf_id, $wban_num, $station_name, $country, $state, $icao, $lat, $lon, $elev, $start_time, $end_time)
   = split(/,/, $line); 
  # filled missing values with -9999.9
  if (!$lat) { $lat = -9999.9; }  
  if (!$lon) { $lon = -9999.9; }  
  if (!$elev) { $elev = -9999.9; }  
  #my $t = Time::Piece->strptime($start_time, "%Y%m%d");
  #print "$start_time\n"; 
  my $t = Time::Piece->strptime($start_time, "%Y%m%d");
  $start_time = $t->strftime("%Y-%m-%d+0000\n");
  chomp($start_time); 
  my $t = Time::Piece->strptime($end_time, "%Y%m%d");
  $end_time = $t->strftime("%Y-%m-%d+0000\n");
  chomp($end_time); 
  print "$usaf_id,$wban_num,$station_name,$country,$state,$icao,$lat,$lon,$elev,$start_time,$end_time\n"; 

} 

