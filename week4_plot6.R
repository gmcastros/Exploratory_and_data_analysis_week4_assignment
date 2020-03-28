#Read the file
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Question:
#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"\color{red}{\verb|fips == "06037"|}fips=="06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

california_data <- NEI[NEI$fips=="06037", ]
baltimore_data <- NEI[NEI$fips=="24510", ]

#Get the coal sources, the column EI.Sector has the information to filter
vehicles <- SCC[grep("Veh", SCC$Short.Name),] 

vehicles_1 <- subset( NEI, NEI$SCC %in% vehicles$SCC)
vehicles_all <- merge(x = vehicles_1, y = SCC, by.x="SCC", by.y="SCC")



#We need to group the data at year level. SUM it. 
# The columns we need are Emissions and year 
emissions_per_year_baltimore <- aggregate(Emissions ~ year+fips, vehicles_all[vehicles_all$fips=="24510",], sum)
emissions_per_year_california <- aggregate(Emissions ~ year+fips, vehicles_all[vehicles_all$fips=="06037",], sum)

#Do a union
emissions_per_year <- rbind(emissions_per_year_baltimore, emissions_per_year_california)

#Use ggplot
library(ggplot2)
#draw emissions per year, over year, emissions and color by type, each color line.
plot5 <- ggplot(emissions_per_year, aes(year, Emissions, color=fips))
plot5 <- plot5 + geom_line() + xlab("Year") + ylab("Total Emissions")
png("plot5.png", width=480, height = 480)
print(plot5)
dev.off()

emissions_2008 <- emissions_per_year[emissions_per_year$year ==2008,2]
emissions_1999 <- emissions_per_year[emissions_per_year$year ==1999,2]
emissions_delta_2008_1999 <- emissions_2008 - emissions_1999

