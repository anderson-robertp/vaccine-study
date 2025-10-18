# Overview

This project explores global childhood vaccination rates and their relationship to economic and health outcomes. As a software engineer, my goal is to strengthen my skills in data acquisition, transformation, visualization, and statistical analysis using R. By analyzing real-world data from the World Bank, I aimed to understand how vaccination trends relate to broader public health indicators such as GDP per capita and child mortality rates.

The dataset used in this project was obtained from the World Bank Open Data platform using the WDI (World Development Indicators) API in R. The data includes global vaccination rates (measles, polio, diphtheria, etc.) from 2000 to 2023, along with GDP per capita and child mortality data for the same period.

Data source: [World Bank Open Data](https://data.worldbank.org/)

The purpose of this project is to perform an exploratory data analysis that can reveal how vaccination coverage has evolved over time and how it correlates with countries’ income levels and child health outcomes.

[Software Demo Video](http://youtube.link.goes.here)

# Data Analysis Results

1) Did global vaccination coverage improve from 2000–2023?

    Yes. The data shows a general upward trend in vaccination rates across most vaccine types, indicating overall global improvement in immunization coverage.

2) Is there a relationship between a country’s income level and vaccination rate?

    Yes. A positive correlation was found between GDP per capita and vaccination rates—wealthier countries tend to have higher vaccination coverage.

3) Is there a relationship between vaccination coverage and child mortality?

    Yes. The analysis shows a strong negative correlation: as vaccination rates increase, child mortality rates decrease. This supports the importance of immunization programs in improving child health outcomes.

# Development Environment

    * Development Tools: Visual Studio Code, R, and GitHub
    * Programming Language: R
    * Libraries Used:
        * WDI — to retrieve data from the World Bank API
        * dplyr — for data cleaning and manipulation
        * tidyr — for reshaping data
        * ggplot2 — for data visualization

# Useful Websites

* [World Bank Open Data](https://data.worldbank.org/)
* [RStudio WDI Package Documentation](https://cran.r-project.org/web/packages/WDI/WDI.pdf)
* [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
* [dplyr Documentation](https://dplyr.tidyverse.org/)
* [VS Code R Extension Guide](https://marketplace.visualstudio.com/items?itemName=Ikuyadeu.r)

# Future Work

* Add regional and country-level breakdowns to identify areas with low vaccination rates.
* Include time-series forecasting to predict future vaccination coverage trends.
* Create an interactive Shiny dashboard for easier exploration of vaccination and health data.