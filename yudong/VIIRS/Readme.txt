
Lights data are contained in two EDRs: 
  1. VNCC EDR: reflectance 
  2. GNCC EDR: geolocation 

For more information about NPP in general:
  http://www.class.ngdc.noaa.gov/release/data_available/npp/index.htm
  http://www.class.ngdc.noaa.gov/notification/faq_npp.htm


Sample dump: 

 h5dump -d /All_Data/VIIRS-NCC-EDR_All/Albedo VNCCO_npp_d20160407_t0123274_e0129392_b23022_c20160407072925744724_noaa_ops.h5


Real-time visualization: 

http://weather.msfc.nasa.gov/cgi-bin/sportPublishData.pl?dataset=viirsconusa&product=region_dnbrgbref&stamp=20160412_0704&loc=seregion#image




http://rammb.cira.colostate.edu/projects/npp/Beginner_Guide_to_VIIRS_Imagery_Data.pdf


The Day/Night Band EDR is called the Near-Constant Contrast (NCC) product
–
VNCCO
–
The NCC product is the DNB SDR data (which is radiance only) converted to a “reflectance” value and remapped to the ground-track Mercator projection. As a result, NCC data is reflectance-only. 


EDR geolocation files (use ground-track Mercator projection)
–
GIGTO: I-band EDR geolocation
–
GMGTO: M-band EDR geolocation
–
GNCCO: Day/Night Band EDR (NCC) geolocation
