#Read the file
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Question:
#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

baltimore_data <- NEI[NEI$fips=="24510", ]

#Get the coal sources, the column EI.Sector has the information to filter
vehicles <- SCC[grep("Veh", SCC$Short.Name),] 

baltimore_1 <- subset( NEI, NEI$SCC %in% vehicles$SCC)
vehicles_baltimore <- merge(x = baltimore_1, y = SCC, by.x="SCC", by.y="SCC")


#We need to group the data at year level. SUM it. 
# The columns we need are Emissions and year 
emissions_per_year <- aggregate(Emissions ~ year, vehicles_baltimore, sum)

#Use ggplot
library(ggplot2)
#draw emissions per year, over year, emissions and color by type, each color line.
plot5 <- ggplot(emissions_per_year, aes(year, Emissions))
plot5 <- plot5 + geom_line() + xlab("Year") + ylab("Total Emissions")
png("plot5.png", width=480, height = 480)
print(plot5)
dev.off()

emissions_2008 <- emissions_per_year[emissions_per_year$year ==2008,2]
emissions_1999 <- emissions_per_year[emissions_per_year$year ==1999,2]
emissions_delta_2008_1999 <- emissions_2008 - emissions_1999
#answer: -71953.21 decreased
