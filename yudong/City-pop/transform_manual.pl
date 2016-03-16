#! /usr/bin/perl 
# cleanup transform manually downloaded data, which broken one row into three lines 

use Time::Piece;

$infile="manual-download.txt"; 
$outfile="city_pop.csv"; 
# read in the list
open(LIST, "<$infile") or die "Can not open list file: $!";
@list=<LIST>;
close(LIST);

# skip header 
shift @list; 

my @newlines; 

$line3=''; 
$i=0; 

foreach $line (@list) {
  chomp $line;
  $line3="$line3\t$line"; 
  $i++; 
  if ($i == 3) { 
   #clean up footnotes and comma 
   $line3 =~ s/\[\d+\]//g; 
   $line3 =~ s/,//g; 
   #print "==>$line3\n"; 
   ($empty, $rank, $city, $state, $pop_2014, $pop_2010, $change, $land_area, $land_area_km, 
      $density, $density_km, $latlon) = split (/\t/, $line3); 
 
   # +6.63% -> +6.63
   $change =~ s/\%//g; 
   $land_area =~ s/sq mi//g; 
   $density =~ s/per sq mi//g; 
   ($lat, $lon) = ($latlon =~ /(\d+\.?\d+)°[S|N] (\d+\.?\d+)°[W|E]/); 
   if ($latlon =~ /°S/) { $lat = -$lat; }; 
   if ($latlon =~ /°W/) { $lon = -$lon; }; 

   push @newlines, "$rank, $city, $state, $pop_2014, $pop_2010, $change, $land_area, $density, $lat, $lon\n"; 
   $i=0;
   $line3=''; 
  } 
} 
  
open(OUTF, ">$outfile") or die "Can not open list file: $!";
print OUTF "rank, city, state, pop_2014, pop_2010, change, land_area, density, lat, lon\n"; 
print OUTF @newlines; 
close(OUTF); 
  
exit(0); 

