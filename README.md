# **Regression Analysis on MPG Dataset**

This repository contains an R script that performs a regression analysis on the mpg dataset from the ggplot2 package. The script demonstrates data preprocessing, feature selection using Variance Inflation Factor (VIF), fitting a Generalized Linear Model (GLM), evaluating the model's performance, and visualizing the results.

## **Table of Contents**

* [Project Description](#bookmark=id.dvxia9ktq8e0)  
* [Dataset](#bookmark=id.nbd8eaagxsh2)  
* [Methodology](#bookmark=id.84fuv0z0gtgi)  
* [Prerequisites](#bookmark=id.u6ucacy31e0d)  
* [How to Run](#bookmark=id.9ok0aiiqlyi5)  
* [Key Steps in the Code](#bookmark=id.j1bhbyy0wo29)  
* [Results](#bookmark=id.vhh8t1qsp6be)  
* [Visualizations](#bookmark=id.qotu2atoe0az)  
* [Future Improvements](#bookmark=id.g1tctsj7r9f6)

## **Project Description**

This project analyzes the factors influencing city fuel efficiency (cty) using the mpg dataset. A linear regression model is built to understand the relationship between various vehicle attributes and city fuel consumption. The analysis includes handling categorical variables, scaling numeric features, and using VIF to address multicollinearity before fitting the model and evaluating its predictive power.

## **Dataset**

The project uses the built-in mpg dataset from the ggplot2 R package. This dataset contains information on fuel economy for 38 popular models of cars, including variables like manufacturer, model, engine size, number of cylinders, transmission type, drive type, city and highway fuel efficiency, and vehicle class.

The target variable for the regression is cty (city miles per gallon).

## **Methodology**

The analysis follows these main steps:

1. **Load Libraries:** Import necessary R packages for data manipulation, visualization, and modeling.  
2. **Load Data:** Load the mpg dataset.  
3. **Data Inspection:** Perform initial checks for missing values (inspect\_na).  
4. **Data Preprocessing:**  
   * Separate numeric and character (categorical) features.  
   * Convert character features to integers using factor levels.  
   * Combine the processed numeric and character dataframes.  
   * Scale all features (excluding the target variable) to have zero mean and unit variance.  
5. **Feature Selection (VIF):**  
   * Fit an initial GLM model with all features.  
   * Iteratively remove features with a Variance Inflation Factor (VIF) greater than 1.5 to reduce multicollinearity.  
   * Refit the GLM model with the remaining features.  
6. **Model Training:**  
   * Initialize h2o for distributed computing.  
   * Convert the preprocessed data to an h2o frame.  
   * Split the data into training and testing sets (80/20 split).  
   * Train a GLM model using h2o.glm on the training data, with the test set used for validation and 10-fold cross-validation.  
7. **Model Evaluation:**  
   * Predict on the test set using the trained h2o model.  
   * Calculate residuals (actual \- predicted).  
   * Compute the Root Mean Squared Error (RMSE) and R-squared (R2) for the test set.  
   * Calculate the Adjusted R-squared for the test set.  
8. **Training Set Evaluation:**  
   * Predict on the training set.  
   * Calculate RMSE, R2, and Adjusted R-squared for the training set.  
9. **Visualization:**  
   * Generate scatter plots comparing predicted vs. observed city fuel efficiency for both the test and training sets.  
   * Combine the plots for comparison.

## **Prerequisites**

Make sure you have R and RStudio installed. The following R packages are required:

library(tidyverse)  
library(data.table)  
library(rstudioapi)  
library(skimr)  
library(inspectdf)  
library(mice)  
library(plotly)  
library(highcharter)  
library(recipes)  
library(caret)  
library(purrr)  
library(graphics)  
library(Hmisc)  
library(glue)  
library(faraway) library(h2o)   

You can install these packages in R using the install.packages() function:

install.packages("tidyverse")  
install.packages("data.table")  
install.packages("rstudioapi")  
install.packages("skimr")  
install.packages("inspectdf")  
install.packages("mice")  
install.packages("plotly")  
install.packages("highcharter")  
install.packages("recipes")  
install.packages("caret")  
install.packages("purrr")  
install.packages("graphics")  
install.packages("Hmisc")  
install.packages("glue")  
install.packages("faraway")  
install.packages("h2o")

## **How to Run**

1. Save the provided R code as an .R file (e.g., regression\_analysis.R).  
2. Open the .R file in RStudio.  
3. Ensure all prerequisite packages are installed.  
4. Run the script directly in RStudio.

Alternatively, you can run the script from the R console:

source("regression\_analysis.R")

## **Key Steps in the Code**

This section outlines the main logical steps performed in the R script without including the code itself.

* Loading necessary libraries.  
* Loading the mpg dataset.  
* Initial data inspection, including checking for missing values.  
* Preprocessing the data by handling categorical variables, combining, and scaling features.  
* Performing feature selection based on Variance Inflation Factor (VIF) to address multicollinearity.  
* Splitting the data into training and testing sets.  
* Initializing h2o and training a Generalized Linear Model (GLM).  
* Evaluating the model's performance on both the test and training sets by calculating metrics like RMSE, R-squared, and Adjusted R-squared.  
* Generating plots to visualize predicted vs. observed values.

## **Results**

The script will output the following:

1. Inspection of missing values in the raw data.  
2. Summary of the initial GLM model.  
3. VIF values for the features in the final GLM model (all should be below 1.5).  
4. A table showing the coefficients and p-values for the final GLM model features.  
5. A tibble summarizing the RMSE, R-squared, and Adjusted R-squared for the test set.  
6. A tibble summarizing the RMSE and Adjusted R-squared for both the training and test sets.

## **Visualizations**

The script generates interactive scatter plots using plotly comparing the predicted cty values against the observed cty values for both the training and test datasets. These plots include a regression line to visualize the model's fit.

## **Future Improvements**

* Explore other regression algorithms (e.g., Random Forest, Gradient Boosting).  
* Perform more extensive feature engineering.  
* Implement cross-validation for more robust model evaluation.  
* Analyze residuals for model assumptions.  
* Add more detailed comments to the R script.

