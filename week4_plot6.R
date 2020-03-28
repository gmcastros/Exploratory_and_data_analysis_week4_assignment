#Read the file
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Question:
#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"\color{red}{\verb|fips == "06037"|}fips=="06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?


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
plot6 <- ggplot(emissions_per_year, aes(year, Emissions, color=fips))
plot6 <- plot6 + geom_line() + xlab("Year") + ylab("Total Emissions")
png("plot6.png", width=480, height = 480)
print(plot6)
dev.off()

emissions_2008_baltimore <- emissions_per_year_baltimore[emissions_per_year_baltimore$year ==2008,3]
emissions_1999_baltimore <- emissions_per_year_baltimore[emissions_per_year_baltimore$year ==1999,3]

emissions_2008_california <- emissions_per_year_california[emissions_per_year_california$year ==2008,3]
emissions_1999_california <- emissions_per_year_california[emissions_per_year_california$year ==1999,3]

california_delta <- emissions_2008_california - emissions_1999_california
baltimore_delta <- emissions_2008_baltimore - emissions_1999_baltimore

#california delta: 163.44
#baltimore delta: -258.5445
#Baltimore city experienced the biggest change. it decreased -258.5445
