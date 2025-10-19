# Load Packages and Libriaries
if (!require(WDI)) install.packages("WDI")
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(tidyr)) install.packages("tidyr")
library(WDI)
library(dplyr)
library(ggplot2)
library(tidyr)

# Download Data from World Bank
vaccine_data <- WDI(
  country = "all",
  indicator = c(
    "SH.IMM.MEAS", # Measles
    "SH.IMM.IDPT", # DTP
    "SH.IMM.POL3" # Polio
  ),
  start = 2000, end = 2023, extra = TRUE
)
# Rename columns for clarity
vaccine_data <- vaccine_data %>%
  rename(
    measles_vaccination_rate = SH.IMM.MEAS,
    dtp_vaccination_rate    = SH.IMM.IDPT,
    polio_vaccination_rate  = SH.IMM.POL3
  )


# Data Cleaning and Transformation
vaccine_data_clean <- vaccine_data %>%
  filter(region != "Aggregates") %>%
  select(iso2c, country, year, measles_vaccination_rate, dtp_vaccination_rate,
         polio_vaccination_rate) %>%
  pivot_longer(cols = c(measles_vaccination_rate,
                        dtp_vaccination_rate,
                        polio_vaccination_rate),
               names_to = "vaccine_type", values_to = "vaccination_rate")

vaccine_data_clean <- vaccine_data_clean %>% drop_na(vaccination_rate)

# Data Visualization
# Compute yearly average vaccination rates
yearly_avg_vaccine <- vaccine_data_clean %>%
  group_by(year, vaccine_type) %>%
  summarize(avg_vaccination_rate = mean(vaccination_rate, na.rm = TRUE))

# Plotting the trends
ggplot(yearly_avg_vaccine, aes(
                               x = year,
                               y = avg_vaccination_rate,
                               color = vaccine_type)) +
  geom_line(size = 1) +
  geom_point() +
  labs(title = "Global Vaccination Rates Over Time",
       x = "Year",
       y = "Average Vaccination Rate (%)",
       color = "Vaccine Type") +
  theme_minimal()

# Save the plot
ggsave("global_vaccination_trends.png", width = 10, height = 6)

# Question 1 Did global vaccination coverage improve from 2000–2023?
improvement_trends <- yearly_avg_vaccine %>%
  filter(year %in% c(2000, 2023)) %>%
  pivot_wider(names_from = year, values_from = avg_vaccination_rate) %>%
  mutate(improvement = `2023` - `2000`)
print(" ")
print("Improvement in Vaccination Rates from 2000 to 2023:")
print(improvement_trends)

# Question 2 Is there a relationship between a
# country’s income level and vaccination rate?
# Download income level data
income_data <- WDI(
  country = "all",
  indicator = "NY.GDP.PCAP.CD",
  start = 2023, end = 2023, extra = TRUE
) %>% filter(region != "Aggregates")

# Merge income data with vaccination data for 2023
vaccine_income_2023 <- vaccine_data_clean %>%
  filter(year == 2023) %>%
  left_join(income_data %>% select(iso2c, NY.GDP.PCAP.CD), by = "iso2c") %>% # nolint
  rename(gdp_per_capita = NY.GDP.PCAP.CD)

# Clean data: remove rows with NA values
vaccine_income_2023 <- vaccine_income_2023 %>%
  filter(!is.na(vaccination_rate) & !is.na(gdp_per_capita))

# Plot relationship between GDP per capita and vaccination rate
ggplot(vaccine_income_2023, aes(x = gdp_per_capita, y = vaccination_rate)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Relationship Between GDP and Vaccination Rate (2023)",
       x = "GDP Per Capita (USD)",
       y = "Vaccination Rate (%)") +
  theme_minimal()
# Save the plot
ggsave("gdp_vs_vaccination_rate_2023.png", width = 10, height = 6)

# Correlation analysis
correlation_results <- vaccine_income_2023 %>%
  group_by(vaccine_type) %>%
  summarize(
    correlation = cor(
      gdp_per_capita,
      vaccination_rate,
      use = "complete.obs"
    )
  )
print(" ")
print("Correlation between GDP Per Capita and Vaccination Rate:")
print(correlation_results)

# Significant correlation can be interpreted from the results printed above.
income_model <- lm(
  vaccination_rate ~ gdp_per_capita,
  data = vaccine_income_2023
)
print(" ")
print("Linear Model Summary for GDP Per Capita vs Vaccination Rate:")
print(summary(income_model))

# Question 3 Is there a relationship between
# vaccination coverage and child mortality?

# Download child mortality data
child_mortality_data <- WDI(
  country = "all",
  indicator = "SP.DYN.IMRT.IN",
  start = 2023, end = 2023, extra = TRUE
) %>% filter(region != "Aggregates")

# Merge child mortality data with vaccination data for 2023
vaccine_mortality_2023 <- vaccine_data_clean %>%
  filter(year == 2023) %>%
  left_join(child_mortality_data %>% select(
    iso2c,
    SP.DYN.IMRT.IN
  ), by = "iso2c") %>%
  rename(child_mortality_rate = SP.DYN.IMRT.IN)

# Clean data: remove rows with NA values
vaccine_mortality_2023_clean <- vaccine_mortality_2023 %>%
  filter(!is.na(vaccination_rate) & !is.na(child_mortality_rate))

# Plot relationship between child mortality rate and vaccination rate
ggplot(vaccine_mortality_2023_clean, aes(x = child_mortality_rate
                                         , y = vaccination_rate)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(
       title = paste("Relationship Between Child Mortality",
                     "Rate and Vaccination Rate (2023)"),
       x = "Child Mortality Rate (per 1,000 live births)",
       y = "Vaccination Rate (%)") +
  theme_minimal()
# Save the plot
ggsave("child_mortality_vs_vaccination_rate_2023.png", width = 10, height = 6)

# Correlation analysis
mortality_correlation_results <- vaccine_mortality_2023_clean %>%
  group_by(vaccine_type) %>%
  summarize(correlation = cor(
    child_mortality_rate,
    vaccination_rate,
    use = "complete.obs"
  )
  )
print(" ")
print("Correlation between Child Mortality Rate and Vaccination Rate:")
print(mortality_correlation_results)

# Significant correlation can be interpreted from the results printed above.
mortality_model <- lm(vaccination_rate ~ child_mortality_rate,
                      data = vaccine_mortality_2023_clean)
print(" ")
print("Linear Model Summary for Child Mortality Rate vs Vaccination Rate:")
print(summary(mortality_model))

# End of Script