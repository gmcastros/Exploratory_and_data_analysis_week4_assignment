#Read the file
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Question:
#Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

#Get the coal sources, the column EI.Sector has the information to filter
coal <- SCC[grep("Coal", SCC$EI.Sector),] 

#need to join SCC and NEI, use SCC as join condition
coal_nei <- subset( NEI, NEI$SCC %in% coal$SCC)
coal_nei2 <- merge(x = coal_nei, y = SCC, by.x="SCC", by.y="SCC")

#We need to group the data at year level. SUM it. 
# The columns we need are Emissions and year 
emissions_per_year <- aggregate(Emissions ~ year, coal_nei2, sum)

#Use ggplot
library(ggplot2)
#draw emissions per year, over year, emissions and color by type, each color line.
plot4 <- ggplot(emissions_per_year, aes(year, Emissions))
plot4 <- plot4 + geom_line() + xlab("Year") + ylab("Total Emissions")
png("plot4.png", width=480, height = 480)
print(plot4)
dev.off()

emissions_2008 <- emissions_per_year[emissions_per_year$year ==2008,2]
emissions_1999 <- emissions_per_year[emissions_per_year$year ==1999,2]
emissions_delta_2008_1999 <- emissions_2008 - emissions_1999
#answer: -228694.3 decreased


#answer: All 99 to 2008 in Baltimore, except the “POINT” type source
