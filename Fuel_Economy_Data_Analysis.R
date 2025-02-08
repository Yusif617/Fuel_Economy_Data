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

raw <- ggplot2::mpg %>% view()
raw %>% inspect_na()

df.num <- raw %>% select_if(is.numeric)
df.chr <- raw %>%
  select_if(is.character) %>% 
  mutate(across(everything(), ~ as.integer(factor(.))))  

df <- cbind(df.chr,df.num) %>%
  select(cty,everything())
df <- scale(df) %>% as.data.frame()

target <- 'cty'
features <- df %>% select(-cty) %>% names()
f <- as.formula(paste(target, paste(features, collapse = " + "), sep = " ~ "))


glm <- glm(f, data = df)
glm %>% summary()

while(glm %>% faraway::vif() %>% sort(decreasing = T) %>% .[1] >= 1.5){
  afterVIF <- glm %>% faraway::vif() %>% sort(decreasing = T) %>% .[-1] %>% names()
  f <- as.formula(paste(target, paste(afterVIF, collapse = " + "), sep = " ~ "))
  glm <- glm(f, data = df)
}


glm %>% faraway::vif() %>% sort(decreasing = T) %>% names() -> features 

df <- df %>% select(target,features)
df[,-1] <- df[,-1] %>% scale() %>% as.data.frame()

library(h2o)
h2o.init()
h2o_data <- df %>% as.h2o()
h2o_data <- h2o_data %>% h2o.splitFrame(ratios = 0.2,seed=123)
train <- h2o_data[[1]]
test <- h2o_data[[2]]

model <- h2o.glm(
  x = features, y = target,
  training_frame = train,
  validation_frame = test,
  nfolds = 10, seed = 123,
  lambda = 0, compute_p_values = T)

model@model$coefficients_table %>%
  as.data.frame() %>%
  dplyr::select(names,p_value) %>%
  mutate(p_value = round(p_value,3)) %>%
  .[-1,] %>%
  arrange(desc(p_value))


y_pred <- model %>% h2o.predict(newdata = test) %>% as.data.frame()
test_set <- test %>% as.data.frame()
residuals=test_set$cty - y_pred$predict


RMSE = sqrt(mean(residuals^2))

y_test_mean = mean(test_set$cty)

tss = sum((test_set$cty - y_test_mean)^2) 
rss = sum(residuals^2)
R2 = 1 - (rss/tss); R2

n <- test_set %>% nrow() 
k <- features %>% length() #
Adjusted_R2 = 1-(1-R2)*((n-1)/(n-k-1))

tibble(RMSE = round(RMSE,1),
       R2, Adjusted_R2)


my_data <- cbind(predicted = y_pred$predict,
                 observed = test_set$cty) %>% 
  as.data.frame()

g <- my_data %>% 
  ggplot(aes(predicted, observed)) + 
  geom_point(color = "darkred") + 
  geom_smooth(method=lm) + 
  theme(plot.title = element_text(color="darkgreen",size=16,hjust=0.5),
        axis.text.y = element_text(size=12), 
        axis.text.x = element_text(size=12),
        axis.title.x = element_text(size=14), 
        axis.title.y = element_text(size=14))

g %>% ggplotly()



y_pred_train <- model %>% h2o.predict(newdata = train) %>% as.data.frame()

train_set <- train %>% as.data.frame()
residuals = train_set$cty - y_pred_train$predict

RMSE_train = sqrt(mean(residuals^2))
y_train_mean = mean(train_set$cty)

tss = sum((train_set$cty - y_train_mean)^2)
rss = sum(residuals^2)

R2_train = 1 - (rss/tss); R2_train

n <- train_set %>% nrow() 
k <- features %>% length()
Adjusted_R2_train = 1-(1-R2_train)*((n-1)/(n-k-1))


# Plotting actual & predicted
my_data_train <- cbind(predicted = y_pred_train$predict,
                       observed = train_set$cty) %>% 
  as.data.frame()

g_train <- my_data_train %>% 
  ggplot(aes(predicted, observed)) + 
  geom_point(color = "darkred") + 
  geom_smooth(method=lm) + 
  labs(x="Predecited Power Output", 
       y="Observed Power Output",
       title=glue('Train: Adjusted R2 = {round(enexpr(Adjusted_R2_train),2)}')) +
  theme(plot.title = element_text(color="darkgreen",size=16,hjust=0.5),
        axis.text.y = element_text(size=12), 
        axis.text.x = element_text(size=12),
        axis.title.x = element_text(size=14), 
        axis.title.y = element_text(size=14))

g_train %>% ggplotly()

library(patchwork)
g_train + g

tibble(RMSE_train = round(RMSE_train,1),
       RMSE_test = round(RMSE,1),
       
       Adjusted_R2_train,
       Adjusted_R2_test = Adjusted_R2)

