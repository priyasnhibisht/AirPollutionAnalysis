library(ggplot2)
library(corrplot)
library(dplyr)

# 1. Histogram
ggplot(geo_data_clean, aes(x = AQI.Value)) +
  geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
  labs(title = "Distribution of AQI Values", x = "AQI Value", y = "Count")

# 2. Correlation plot
numeric_data <- geo_data_clean %>%
  select(where(is.numeric)) %>%
  na.omit()

cor_mat <- cor(numeric_data)

corrplot(cor_mat, method = "color", type = "upper", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black")

# 3. Feature selection
geo_data_filtered <- geo_data_clean %>%
  select(City, Latitude, Longitude, AQI.Value, 
         `PM2.5.AQI.Value`, `NO2.AQI.Value`, `CO.AQI.Value`, `Ozone.AQI.Value`)

# 4. Feature engineering
geo_data_filtered <- geo_data_filtered %>%
  mutate(
    AQI_Category = case_when(
      AQI.Value <= 50 ~ "Good",
      AQI.Value <= 100 ~ "Moderate",
      AQI.Value <= 150 ~ "Unhealthy for Sensitive Groups",
      AQI.Value <= 200 ~ "Unhealthy",
      AQI.Value <= 300 ~ "Very Unhealthy",
      TRUE ~ "Hazardous"
    )
  )
