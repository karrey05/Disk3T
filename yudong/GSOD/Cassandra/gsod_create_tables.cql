
//CREATE KEYSPACE time_series 
//WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1};

use time_series; 

CREATE TABLE GSOD (
 usaf_id	ascii,
 wban_num 	ascii,
 event_time 	timestamp,
 temp 		ascii,
 temp_count 	ascii,
 dewp 		ascii,
 dewp_count 	ascii,
 slp 		ascii,
 slp_count 	ascii,
 stp 		ascii,
 stp_count 	ascii,
 visib		ascii,
 visib_count 	ascii,
 wdsp		ascii,
 wdsp_count 	ascii,
 mxspd	 	ascii,
 gust 	 	ascii,
 max  	 	ascii,
 max_flag 	ascii,
 min  	 	ascii,
 min_flag 	ascii,
 prcp 	 	ascii,
 prcp_flag 	ascii,
 sndp 	 	ascii,
 frshtt	 	ascii,
PRIMARY KEY ((usaf_id, wban_num), event_time)
);
