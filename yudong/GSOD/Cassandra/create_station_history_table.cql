
use time_series; 

drop table station_history;

CREATE TABLE station_history (
 usaf_id	ascii,
 wban_num 	ascii,
 station_name	ascii,
 country 	ascii,
 state		ascii,
 icao	 	ascii,
 lat 		decimal,
 lon       	decimal,
 elev		decimal,
 start_time 	timestamp,
 end_time 	timestamp,
PRIMARY KEY (usaf_id, wban_num, lat, lon, elev, start_time, end_time) 
);
