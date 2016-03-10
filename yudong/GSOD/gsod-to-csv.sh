#! /bin/bash

# convert GSOD native format to csv format. 
#STN--- WBAN   YEARMODA    TEMP       DEWP      SLP        STP       VISIB      WDSP     MXSPD   GUST    MAX     MIN   PRCP   SNDP   FRSHTT
#476790 43319  20160101    44.8 24    24.3 24  9999.9  0  9999.9  0    6.2 24    6.0 24    8.9  999.9    53.6*   35.6*  0.00I 999.9  000000


if [ "$1" == "" ]; then 
  echo  Usage: ./gsod-to-csv.sh gsod_raw_file 
  exit 1 
fi
  
ifile=$1
# create header  
echo usaf_id,wban_num,event_time,temp,temp_count,dewp,dewp_count,slp,slp_count,stp,stp_count,visib,visib_count,wdsp,wdsp_count,mxspd,gust,max,max_flag,min,min_flag,prcp,prcp_flag,sndp,frshtt

tail -n +2 $ifile | \
cut   --output-delimiter=', ' \
 -c 1-6,8-12,15-18,19-20,21-22,25-30,32-33,36-41,43-44,47-52,54-55,58-63,65-66,69-73,75-76,79-83,85-86,89-93,96-100,103-108,109,111-116,117,119-123,124,126-130,133-138  | \
 awk 'BEGIN {FS=", "; OFS=","}; {print $1, $2, $3"-"$4"-"$5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27}' 

exit 0 

STN---  1-6       Int.   Station number (WMO/DATSAV3 number) for the location.
WBAN    8-12      Int.   WBAN number where applicable--this is the historical "Weather Bureau Air Force Navy" number - with WBAN being the acronym.
YEAR    15-18     Int.   The year.  
MODA    19-22     Int.   The month and day.
TEMP    25-30     Real   Mean temperature for the day in degrees Fahrenheit to tenths.  Missing = 9999.9
Count   32-33     Int.   Number of observations used in calculating mean temperature.
DEWP    36-41     Real   Mean dew point for the day in degrees Fahrenheit to tenths.  Missing = 9999.9
Count   43-44     Int.   Number of observations used in calculating mean dew point.
SLP     47-52     Real   Mean sea level pressure for the day in millibars to tenths.  Missing = 9999.9
Count   54-55     Int.   Number of observations used in calculating mean sea level pressure.
STP     58-63     Real   Mean station pressure for the day in millibars to tenths.  Missing = 9999.9
Count   65-66     Int.   Number of observations used in calculating mean station pressure.
VISIB   69-73     Real   Mean visibility for the day in miles to tenths.  Missing = 999.9
Count   75-76     Int.   Number of observations used in calculating mean visibility.
WDSP    79-83     Real   Mean wind speed for the day in knots to tenths.  Missing = 999.9
Count   85-86     Int.   Number of observations used in calculating mean wind speed.
MXSPD   89-93     Real   Maximum sustained wind speed reported for the day in knots to tenths.  Missing = 999.9
GUST    96-100    Real   Maximum wind gust reported for the day in knots to tenths.  Missing = 999.9
MAX     103-108   Real   Maximum temperature reported during the day in Fahrenheit to tenths--time of max temp report varies by country and region, so this will sometimes not be the max for the calendar day.  Missing = 9999.9
Flag    109-109   Char   Blank indicates max temp was taken from the explicit max temp report and not from the 'hourly' data.  * indicates max temp was derived from the hourly data (i.e., highest hourly or synoptic-reported temperature).
MIN     111-116   Real   Minimum temperature reported during the day in Fahrenheit to tenths--time of min temp report varies by country and region, so this will sometimes not be the min for the calendar day.  Missing = 9999.9
Flag    117-117   Char   Blank indicates min temp was taken from the explicit min temp report and not from the 'hourly' data.  * indicates min temp was derived from the hourly data (i.e., lowest hourly or synoptic-reported temperature).
PRCP    119-123   Real   Total precipitation (rain and/or melted snow) reported during the day in inches and hundredths; will usually not end with the midnight observation--i.e., may include latter part of previous day.  .00 indicates no measurable precipitation (includes a trace).  Missing = 99.99 Note:  Many stations do not report '0' on days with no precipitation--therefore, '99.99' will often appear on these days.  Also, for example, a station may only report a 6-hour amount for the period during which rain fell.  See Flag field for source of data.
Flag    124-124   Char   A = 1 report of 6-hour precipitation
                             amount.
                         B = Summation of 2 reports of 6-hour
                             precipitation amount.
                         C = Summation of 3 reports of 6-hour
                             precipitation amount.
                         D = Summation of 4 reports of 6-hour
                             precipitation amount.
                         E = 1 report of 12-hour precipitation
                             amount.
                         F = Summation of 2 reports of 12-hour
                             precipitation amount.
                         G = 1 report of 24-hour precipitation
                             amount.
                         H = Station reported '0' as the amount
                             for the day (eg, from 6-hour reports),
                             but also reported at least one
                             occurrence of precipitation in hourly
                             observations--this could indicate a
                             trace occurred, but should be considered
                             as incomplete data for the day.
                         I = Station did not report any precip data
                             for the day and did not report any
                             occurrences of precipitation in its hourly
                             observations--it's still possible that
                             precip occurred but was not reported.

SNDP    126-130   Real   Snow depth in inches to tenths--last
                         report for the day if reported more than
                         once.  Missing = 999.9
                         Note:  Most stations do not report '0' on
                         days with no snow on the ground--therefore,
                         '999.9' will often appear on these days.

FRSHTT  133-138   Int.   Indicators (1 = yes, 0 = no/not
                         reported) for the occurrence during the
                         day of:
                         Fog ('F' - 1st digit).
                         Rain or Drizzle ('R' - 2nd digit).
                         Snow or Ice Pellets ('S' - 3rd digit).
                         Hail ('H' - 4th digit).
                         Thunder ('T' - 5th digit).
                         Tornado or Funnel Cloud ('T' - 6th
                         digit).


