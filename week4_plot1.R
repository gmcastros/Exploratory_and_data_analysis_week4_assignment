#Read the file
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Question:
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
head(NEI)

#We need to group the data at year level. SUM it. The columns we need are Emissions and year 
emissions_per_year <- aggregate(Emissions ~ year, NEI, sum)
png("plot1.png", width=480, height = 480)
with (emissions_per_year,plot( x = year, y = Emissions, xlab="Year",ylab="Total Emissions", pch = 19, lwd=3, col="blue"))
dev.off()

emissions_2008 <- emissions_per_year[emissions_per_year$year ==2008,2]
emissions_1999 <- emissions_per_year[emissions_per_year$year ==1999,2]
emissions_delta_2008_1999 <- emissions_2008 - emissions_1999
#result: -3868761
#Answer Total emissions have decreased from 1999 to 2008 by 3868761 tons





