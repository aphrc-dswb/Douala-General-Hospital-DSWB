# Install and Load necessary packages and libraries
install.packages("readxl")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("summarytools")

library(readxl)
library(dplyr)
library (ggplot2)
library(summarytools)

DGH <- read_excel("C:/Users/Brenda/Desktop/DGH-DSWB Manuscripts/References- DGH-DSWB/DGH_Desk_Review_-_all_versions_-_English_en_-_2025-05-07-12-48-34.xlsx")
View(DGH)

# Create binary variable: 1 = Paper-only, 0 = paper/Electronic
DGH <- DGH %>%
  mutate(over_reliance_paper = ifelse(`Q4. What type of data system is used in the department/unit?` == "Paper-based", 1, 0))

# Summary of data
summary(DGH)

# Frequency tables for specific variables
table(DGH$`Q1. Service/Department/Unit`)
table(DGH$`Q2. Position of staff in the hospital/department`)
table(DGH$`Q3. Years in service`)
table(DGH$over_reliance_paper) # View distribution

DGH %>%
  summarise(
    mean_years = mean(`Q3. Years in service`, na.rm = TRUE),
    median_years = median(`Q3. Years in service`, na.rm = TRUE),
    sd_years = sd(`Q3. Years in service`, na.rm = TRUE),
    min_years = min(`Q3. Years in service`, na.rm = TRUE),
    max_years = max(`Q3. Years in service`, na.rm = TRUE)
  )


# performing simple logistic regression to test whether Years in service predicts reliance on paper

DGH$`Q3. Years in service` <- as.numeric(DGH $`Q3. Years in service`)  # ensure it's numeric

model <- glm(over_reliance_paper ~ `Q3. Years in service`, 
             data = DGH, 
             family = binomial)

summary(model)

exp(coef(model))

