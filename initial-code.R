library(datateachr)
library(tidyverse)
library(dplyr)
library(ggridges)
library(ggplot2)

str(building_permits)
table(building_permits$type_of_work)
summary(building_permits$project_value)

str(apt_buildings) ## I LIKE
table(apt_buildings$amenities)
summary(apt_buildings$no_of_units)

str(vancouver_trees)
table(vancouver_trees$common_name)
summary(vancouver_trees$diameter)
table(vancouver_trees$height_range_id)

str(parking_meters)
table(parking_meters$r_mf_9a_6p)

# Plot the distribution of a numeric variable.
outliers <- boxplot.stats(apt_buildings$no_of_units)$out

apt_buildings %>%
  filter(!no_of_units %in% outliers) %>%
  ggplot(aes(x=no_of_units, fill=property_type)) +  
  geom_density(alpha=.2)

apt_buildings %>%
  filter(!no_of_units %in% outliers) %>%
  ggplot(aes(x=no_of_units, y=property_type)) +  
  geom_density_ridges(alpha=0.2, aes(fill=property_type)) 


# Explore the relationship between 2 variables in a plot.
apt_buildings %>%
  filter(!is.na(`non-smoking_building`)) %>%
  mutate(year = as.Date(as.character(year_built), format="%Y")) %>%
  filter(year > as.Date("1910", format="%Y")) %>%
  ggplot(aes(x=year, y=no_of_units)) + 
  geom_bar(stat="identity", position="stack", alpha = 0.8, aes(fill=as.factor(`non-smoking_building`)))


apt_buildings %>%
  filter(!is.na(`non-smoking_building`)) %>%
  mutate(year = as.Date(as.character(year_built), format="%Y")) %>%
  filter(year > as.Date("1910", format="%Y")) %>%
  ggplot(aes(x=year, y=no_of_units)) + 
  geom_bar(stat="identity", position="fill", alpha = 0.8,aes(fill=`non-smoking_building`))

#Use a boxplot to look at the frequency of different observations within a single variable. You can do this for more than one variable if you wish!

apt_buildings %>%
  filter(!is.na(visitor_parking)) %>%
  filter(!is.na(property_type)) %>%
  filter(!visitor_parking == "UNAVAILABLE") %>%
  ggplot(aes(x=visitor_parking,y=no_of_units, fill=property_type)) +
  geom_boxplot(alpha=0.2) + 
  facet_wrap(~visitor_parking, scale="free")

# Make a new tibble with a subset of your data, with variables and observations that you are interested in exploring.
apt_buildings %>%
  filter("Indoor pool" %in% amenities) %>%
  group_by(ward, property_type) %>%
  summarise(total_units = sum(no_of_units))

  