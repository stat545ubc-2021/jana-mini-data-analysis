# LOAD DATA
# count number of amenities by splitting words
no_of_amenities <- rep(0, nrow(apt_buildings))
for(i in 1:nrow(apt_buildings)) {
  amenities = apt_buildings$amenities[i]
  if(!is.na(amenities)) {
    no_of_amenities[i] = length(str_split(amenities, " ,")[[1]])
  }
}

# determine outliers
outliers <- boxplot.stats(apt_buildings$no_of_units)$out 


# bind the number of amenities as a new column in the apt_buildings tibble df
cbind(apt_buildings, no_of_amenities) -> apt_buildings

apt_buildings %>%
  select(id,
         no_of_amenities,
         property_type,
         visitor_parking,
         ward,
         year_built,
         `non-smoking_building`,
         no_of_units,
         pets_allowed,
         heating_type,
         balconies,
         air_conditioning
  ) %>%
  filter(!no_of_units %in% outliers) %>%
  mutate(year_built = year(as_date(year_built)))-> apt_buildings


View(apt_buildings)

# TASK 1
apt_buildings %>%
  group_by(ward) %>%
  summarise(no_of_amenities = sum(no_of_amenities)) %>%
  mutate(ward = fct_reorder(ward, no_of_amenities)) %>%
  ggplot(aes(x=ward, y=no_of_amenities, color=ward, fill=ward)) + 
  geom_bar(stat="identity", alpha=0.2) + 
  ggtitle("Number of Amenities by Ward")

# TASK 2
apt_buildings$visitor_parking  <- fct_collapse(addNA(apt_buildings$visitor_parking),
                                               UNAVAILABLE = c("UNAVAILABLE", NA))
apt_buildings %>%
  group_by(ward, visitor_parking) %>%
  summarise(no_of_amenities = sum(no_of_amenities), 
            no_of_unit = sum(no_of_units)) %>%
  mutate(visitor_parking = fct_reorder(visitor_parking, no_of_amenities)) %>%
  ggplot(aes(x=ward, y=no_of_amenities, fill=visitor_parking, color=visitor_parking)) +
  geom_bar(stat="identity", alpha=0.2) +
  ggtitle("Number of Amenities by Ward and by Visitor Parking")


