
# RESEARCH QUESTION 1

# determine outliers in no_of_units
outliers <- boxplot.stats(apt_buildings$no_of_units)$out 

# show the summary statistics
apt_buildings %>% 
  filter(!no_of_units %in% outliers) %>% # get rid of outliers
  group_by(property_type) %>%
  summarise(
    count = n(),
    range = range(no_of_units),
    mean = mean(no_of_units),
    sum = sum(no_of_units),
  )

apt_buildings %>% 
  filter(!no_of_units %in% outliers) %>% # get rid of outliers
  group_by(property_type) %>%
  ggplot(aes(x=property_type, y=no_of_units, color=property_type)) +
  geom_violin()+ 
  geom_boxplot(width=0.1)
  
apt_buildings1
apt_buildings1 %>% 
  ggplot(aes(x=property_type, y=mean, group=1)) +
  geom_line() +
  geom_point()+ 
  ggtitle("Mean of Number of Units")

apt_buildings1 %>% 
  ggplot(aes(x=property_type, y=sum, group=1)) +
  geom_line() +
  geom_point() + 
  ggtitle("Sum of Number of Units")

# RESEARCH QUESTION 2

# task 3
apt_buildings %>%
  filter(!is.na(`non-smoking_building`)) %>%
  filter(!no_of_units %in% outliers) %>%
  mutate(year = as.Date(as.character(year_built), format="%Y")) %>%
  filter(year > as.Date("1910", format="%Y")) %>%
  mutate(year_category=cut(year_built, breaks=c(-Inf,seq(1910, 2020, 10)), labels=paste(c(seq(1900, 2010, 10)), c(seq(1909, 2009, 10), 2020), sep="-"))) %>%
  group_by(year_category, property_type) %>%
  count(`non-smoking_building`) -> apt_buildings2.1 # bin by 10

apt_buildings %>%
  filter(!is.na(`non-smoking_building`)) %>%
  filter(!no_of_units %in% outliers) %>%
  mutate(year = as.Date(as.character(year_built), format="%Y")) %>%
  filter(year > as.Date("1910", format="%Y")) %>%
  mutate(year_category=cut(year_built, breaks=c(-Inf, seq(1905, 2020, 5)), labels=paste(c(seq(1900, 2015, 5)), c(seq(1904, 2014, 5),2020), sep="-"))) %>%
  group_by(year_category, property_type) %>%
  count(`non-smoking_building`) -> apt_buildings2.2 # bin by 5


apt_buildings %>%
  filter(!is.na(`non-smoking_building`)) %>%
  filter(!no_of_units %in% outliers) %>%
  mutate(year = as.Date(as.character(year_built), format="%Y")) %>%
  filter(year > as.Date("1910", format="%Y")) %>%
  group_by(year_built, property_type) %>%
  count(`non-smoking_building`) -> apt_buildings2.3 # bin by 1

apt_buildings %>%
  filter(!is.na(`non-smoking_building`)) %>%
  filter(!no_of_units %in% outliers) %>%
  mutate(year = as.Date(as.character(year_built), format="%Y")) %>%
  filter(year > as.Date("1910", format="%Y")) %>%
  group_by(year_built, property_type) %>%
  count(`non-smoking_building`)

# task 8
apt_buildings2.1 %>%
  ggplot(aes(x=year_category, y=n, fill=`non-smoking_building`)) +  
  geom_bar(stat="identity")

apt_buildings2.2 %>%
  ggplot(aes(x=year_category, y=n, fill=`non-smoking_building`)) +  
  geom_bar(stat="identity")

apt_buildings2.3 %>%
  ggplot(aes(x=year_built, y=n, fill=`non-smoking_building`)) +  
  geom_bar(stat="identity")


apt_buildings2.3 %>%
  ggplot(aes(x=year_built, y=n, fill=`non-smoking_building`)) +
  geom_histogram(stat="identity")

# RESEARCH QUESTION 3

# task 2
apt_buildings %>%
  filter(!is.na(visitor_parking)) %>%
  filter(!is.na(property_type)) %>%
  filter(!visitor_parking == "UNAVAILABLE") %>% 
  group_by(property_type, visitor_parking) %>%
  summarise(no_of_units_sum=sum(no_of_units)) %>%
  mutate(no_of_units_sum_log = log(no_of_units_sum))-> apt_buildings3
apt_buildings3
  
# task 5
apt_buildings3 %>% 
  ggplot(aes(x=property_type, y=no_of_units_sum, colour=visitor_parking, group=visitor_parking)) +
  geom_line() +
  geom_point()

apt_buildings3 %>% 
  ggplot(aes(x=property_type, y=no_of_units_sum_log, colour=visitor_parking, group=visitor_parking)) +
  geom_line() +
  geom_point()

# RESEARCH QUESTION 4
# For apartments with indoor pools, does the total number of units change according to ward?
# task 4

apt_buildings %>%
  filter(amenities %in% "Indoor pool") %>%
  group_by(ward) %>%
  summarise(total_no_units = sum(no_of_units)) %>%
  mutate(ammenity=factor("Pool")) -> apt_buildings4.1

apt_buildings %>%
  filter(amenities %in% "Child play area") %>%
  group_by(ward) %>%
  summarise(total_no_units = sum(no_of_units)) %>%
  mutate(ammenity=factor("Play Room")) -> apt_buildings4.2

apt_buildings %>%
  filter(amenities %in% "Indoor exercise room") %>%
  group_by(ward) %>%
  summarise(total_no_units = sum(no_of_units)) %>%
  mutate(ammenity=factor("Gym"))-> apt_buildings4.3

apt_buildings4.1 %>% 
  rbind(apt_buildings4.2) %>%
  rbind(apt_buildings4.3) -> apt_buildings4


# task 2
# count number of amenities by splitting words
no_of_amenities <- rep(0, nrow(apt_buildings))
for(i in 1:nrow(apt_buildings)) {
  amenities = apt_buildings$amenities[i]
  if(!is.na(amenities)) {
    no_of_amenities[i] = length(str_split(amenities, " ,")[[1]])
  }
}

apt_buildings %>%
  cbind(no_of_amenities) %>%
  na.omit() %>%
  group_by(ward, `non-smoking_building`) %>%
  summarise(no_of_amenities_sum=sum(no_of_amenities)) -> apt_buildings4
apt_buildings4

# task 5
apt_buildings4  %>%
  ggplot(aes(x=ward, y=no_of_amenities_sum, fill=`non-smoking_building`)) +
  geom_bar(stat="identity") +
  facet_wrap(~`non-smoking_building`)

