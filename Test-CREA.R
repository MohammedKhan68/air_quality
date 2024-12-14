#Input the STATION FILE

#Create a temp geojson file and download the file from the url

tmp_geojson <- tempfile(fileext = ".geojson")
download.file(
  "https://api.energyandcleanair.org/stations?country=GB,US,TR,PH,IN,TH&format=geojson",
  tmp_geojson
)

# Read the downloaded geoJson file with the sf library:
library(sf)
my_stations <- read_sf(tmp_geojson)


#Input the Countries

tmp_geojson_countries <- tempfile(fileext = ".geojson")

download.file("https://r2.datahub.io/clvyjaryy0000la0cxieg4o8o/main/raw/data/countries.geojson",
              tmp_geojson_countries)


my_countries <- read_sf(tmp_geojson_countries)

#Renamed the countries column for country id
colnames(my_countries)[3] <- "country_id"

#Code to check the country code
my_countries[my_countries$ADMIN == "India",]

#code to count the number of station for the specific country
#United States = US
US_station <- my_stations$country_id == "US"
Count_USA_Station <- nrow(my_stations[US_station,])
Count_USA_Station

#United Kingdom = GB
GB_station <- my_stations$country_id == "GB"
Count_GB_Station <- nrow(my_stations[GB_station,])
Count_GB_Station

#Turkey = TR
TR_station <- my_stations$country_id == "TR"
Count_TR_Station <- nrow(my_stations[TR_station,])
Count_TR_Station

#Thailand = TH
TH_station <- my_stations$country_id == "TH"
Count_TH_Station <- nrow(my_stations[TH_station,])
Count_TH_Station

#Philippines = PH
PH_station <- my_stations$country_id == "PH"
Count_PH_Station <- nrow(my_stations[PH_station,])
Count_PH_Station

#India = IN
IN_station <- my_stations$country_id == "IN"
Count_IN_Station <- nrow(my_stations[IN_station,])
Count_IN_Station

#Understand the type of CRS 
st_crs(my_countries) #It is WGS 84 (represents geographic coordinates on a spherical model of the Earth)

#Transform this CRS to EPSG:32643" (UTM Zone 43N (WGS 84)) ;  
#Projected CRS translates the curved Earth into a flat map, enabling accurate calculations

my_countries_projected <- st_transform(my_countries, crs = 32643)

#Disable s2 for planar calculations
sf_use_s2(FALSE)


#Geometries of the respective countries

#United States
US_geo <- my_countries_projected[my_countries_projected$ADMIN=="United States of America",4]
plot(st_geometry(US_geo), col = "lightblue", border = "black", lwd = 1.2, main = "United States")
Area_US <- st_area(US_geo)
Area_US_sqkm <- as.numeric(Area_US)/(1000000)

#United Kingdom
GB_geo <- my_countries_projected[my_countries_projected$ADMIN=="United Kingdom",4]
plot(st_geometry(GB_geo), col = "lightblue", border = "black", lwd = 2.5, main = "United Kingdom")
Area_GB <- st_area(GB_geo)
Area_GB_sqkm <- as.numeric(Area_GB)/(1000000)

#Turkey
TR_geo <- my_countries_projected[my_countries_projected$ADMIN=="Turkey",4]
plot(st_geometry(TR_geo), col = "lightblue", border = "black", lwd = 2.5, main = "Turkey")
Area_TR <- st_area(TR_geo)
Area_TR_sqkm <- as.numeric(Area_TR)/(1000000)

#Thailand
TH_geo <- my_countries_projected[my_countries_projected$ADMIN=="Thailand",4]
plot(st_geometry(TH_geo), col = "lightblue", border = "black", lwd = 2.5, main = "Thailand")
Area_TH <- st_area(TH_geo)
Area_TH_sqkm <- as.numeric(Area_TH)/(1000000)

#Philippines
PH_geo <- my_countries_projected[my_countries_projected$ADMIN=="Philippines",4]
plot(st_geometry(PH_geo), col = "lightblue", border = "black", lwd = 2.5, main = "Philippines")
Area_PH <- st_area(PH_geo)
Area_PH_sqkm <- as.numeric(Area_PH)/(1000000)

#India
IN_geo <- my_countries_projected[my_countries_projected$ADMIN=="India",4]
plot(st_geometry(IN_geo), col = "lightblue", border = "black", lwd = 2.5, main = "India")
Area_IN <- st_area(IN_geo)
Area_IN_sqkm <- as.numeric(Area_IN)/(1000000)

#Country Names

Country <- c('US', 'UK', 'Turkey', 'Thailand', 'Philippines', 'India')


#Create lists for No. of PM10 Stations and Area (Sqkm)
No_of_PM10_stations <- c(Count_USA_Station, Count_GB_Station, Count_TR_Station, Count_TH_Station, Count_PH_Station, Count_IN_Station)
Area_in_sq_km <- c(Area_US_sqkm, Area_GB_sqkm, Area_TR_sqkm, Area_TH_sqkm, Area_PH_sqkm, Area_IN_sqkm)

#Create a Matrix using Column Bind Function
table = cbind(Country, No_of_PM10_stations, Area_in_sq_km)

#Convert matrix to data frame
final_table <- as.data.frame(table)
final_table


#Add a density column to the data frame
final_table$Density_PM10_1000km <- (as.numeric(final_table$No_of_PM10_stations)*1000)/(as.numeric(final_table$Area_in_sq_km))


#Round the density
final_table$Density_PM10_1000km<- round(final_table$Density_PM10_1000km,3)

#Print final table
final_table


#Sorted table based on Descending Order for the Density Column
Sorted_table <- final_table[order(final_table$Density_PM10_1000km, decreasing = TRUE),]

Sorted_table

#The analysis reveals that UK has the highest number of stations for every 1000 km
#Philippines stands the lowest and India stands the second lowest

#Write the file to CSV
write.csv(final_table, "C:\\Farhan\\CREA-Test\\table.csv")

#Create graphical visualisation of the data
library(ggplot2)


#Bar Chart showing the Country Vs. Number of PM 10 Stations
ggplot(final_table, aes(x=reorder(Country, No_of_PM10_stations), y = No_of_PM10_stations)) + 
  geom_bar(color='blue',fill='black' ,stat = "identity") + 
  labs(title = "Number of PM10 Stations by Country",
       x = "Country",
       y = "Number of PM10 Stations") +
  theme_minimal()+
  theme(plot.title = element_text(hjust=0.5))
  

#Scatter Plot

ggplot(final_table, aes(x=Area_in_sq_km, y =Density_PM10_1000km)) +
  geom_point(size=5, color='steelblue') +
  labs(title = "Area Vs. PM10 Station Density ",
       x = "Area",
       y = "Density") +
  theme_minimal()+
  theme(plot.title = element_text(hjust=0.5))

#BubbleChart

ggplot(final_table, aes(x=Area_in_sq_km, y= No_of_PM10_stations, size=Density_PM10_1000km, color= Country )) +
  geom_point(alpha = 0.7) +
  labs(title = "Area vs Number of PM10 Stations (Bubble Size = Density)",
       x = "Area (sq. km)",
       y = "Number of PM10 Stations",
       size = "Density (per 1000 sq. km)") +
  theme_minimal()














