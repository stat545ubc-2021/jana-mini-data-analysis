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
ggplot(data=apt_buildings, aes(x=no_of_units)) +  
  geom_density(alpha=.2, fill="#FF6666")

outliers <- boxplot.stats(apt_buildings$no_of_units)$out
apt_buildings1 <- apt_buildings %>%
  filter(!no_of_units %in% outliers)

ggplot(data=apt_buildings1, aes(x=no_of_units)) +  
  geom_density(alpha=.2, fill="#FF6666")


# Explore the relationship between 2 variables in a plot.
ggplot(data=apt_buildings1, aes(x=year_built, y=no_of_units)) + geom_line()

# Filter observations in your data according to your own criteria. Think of what you’d like to explore - again, if this was the titanic dataset, I may want to narrow my search down to passengers born in a particular year…

#Use a boxplot to look at the frequency of different observations within a single variable. You can do this for more than one variable if you wish!

ggplot(data=apt_buildings1, aes(x=no_of_units)) +
  geom_boxplot()

ggplot(data=apt_buildings1, aes(x=no_of_storeys)) +
  geom_boxplot()

ggplot(data=apt_buildings1, aes(x=no_of_elevators)) +
  geom_boxplot()


# Make a new tibble with a subset of your data, with variables and observations that you are interested in exploring.