# Air Quality Insights - R Shiny App


## Overview

**Air Quality Insights** is an interactive R Shiny web application that predicts the Air Quality Index (AQI) based on user-provided pollutant levels (PM2.5, CO, NO₂, and Ozone). The app leverages pre-trained machine learning models (Linear Regression and Random Forest) to forecast AQI and provides health-related messages according to the predicted air quality category.

---

## Features

- 🌍 **Interactive Sliders** for pollutant input values
- 🤖 **Model Selection:** Choose between Linear Regression and Random Forest models
- 📈 **Instant AQI Prediction** with health impact messages
- 📊 **Summary Table** of your inputs and results
- ⚠️ **Error Handling** with clear user feedback

---

## Technologies Used
- **Programming:** R
- **Libraries:** ggplot2, dplyr, randomForest, shiny
- **Concepts:** Data preprocessing, visualization, regression, ensemble learning

---

## Key Learnings & Insights
- PM2.5 has the strongest influence on AQI levels
- Ensemble models (Random Forest) provided more stable predictions than linear models
- Interactive dashboards significantly improve interpretability of analytical results

---

## Usage

1. Adjust the pollutant values using the sliders.
2. Select your preferred prediction model.
3. Click the **Submit** button to view the predicted AQI, its category, and the associated health message.

---

## Future Enhancements
- Add time-series forecasting for AQI trends
- Integrate real-time pollution data via APIs
- Deploy the app publicly for wider accessibility


*Happy coding and clean air for all!*
