#Read the file
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Question:
#Of the four types of sources indicated by the type\color{red}{\verb|type|}type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question

baltimore_data <- NEI[NEI$fips=="24510", ]

#We need to group the data at year level. SUM it. The columns we need are Emissions and year 
emissions_per_year <- aggregate(Emissions ~ year+type, baltimore_data, sum)

#Use ggplot
library(ggplot2)
#draw emissions per year, over year, emissions and color by type, each color line
plot3 <- ggplot(emissions_per_year, aes(year, Emissions, color=type))
plot3 <- plot3 + geom_line() + xlab("Year") + ylab("Total Emissions")
print(plot3)

#answer: All source types appear to have decreased from 1999 to 2008 in Baltimore, except the “POINT” type source