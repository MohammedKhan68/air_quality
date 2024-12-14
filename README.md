The code describes the process of simplifying the geojson data and converting it into required table.

used the data from 
1: https://api.energyandcleanair.org/stations?country=GB,US,TR,PH,IN,TH&format=geojson
2: https://datahub.io/core/geo-countries#countries

Used R-Programming.

Extracted a final table that shows the following details:
Country	No_of_PM10_stations	Area_in_sq_km	Density_PM10_1000km
UK	424	363951.6246	1.165
Thailand	344	627689.5869	0.548
US	4382	9988745.318	0.439
Turkey	378	1042454.756	0.363
India	554	3194599.742	0.173
Philippines	22	627907.4591	0.035
![Uploading image.png…]()


Created following charts from the table:

![Bar_Chart](https://github.com/user-attachments/assets/e360fca1-8c4a-48fe-9cba-ff6f674aceb1)

![Bubble_Chart](https://github.com/user-attachments/assets/474f6c98-a2cf-4ad1-81be-6260cfdfecba)

![Scatter_Plot](https://github.com/user-attachments/assets/ad667cfb-c0c3-47db-883a-d1c9dec4fac4)


