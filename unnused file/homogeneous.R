
#Main Modeling & Training and Validation

source("requried_functions_N_libraries.R")
source("Data_Processing.R")
dataset<- Data_Processing("/home/wut/Desktop/Link to Data/FYP Program/Raw Data/alldata.csv",3,"U.S. Dollar")
train_dataset <- dataset[[1]]
test_dataset <- dataset[[2]]
date <- dataset[[3]]
usd_non_normalize <- dataset[[4]]

## HOMOGENEOUS MODEL
## Train the network using neuralnet (First MLP)
set.seed(1)
weight_size =length(train_dataset[,1])
weight <- sample(1:1000,size = weight_size,replace = F)
weight = normalizeData(weight, type = "0_1")
exchange_model <- neuralnet(oneDayAhead ~ firstDay + secondDay + thirdDay,
                            data = train_dataset, hidden = 2 , learningrate = 0.1)

model_results <- neuralnet::compute(exchange_model, test_dataset[1:3])
predicted_oneDayhead <- model_results$net.result
predict_value <- denormalized(predicted_oneDayhead)
actual <- denormalized(test_dataset[,4])
error <- actual - predict_value
hist(actual - predict_value)
rmse(error)
mae(error)


## Second MLP
exchange_model2 <- neuralnet(oneDayAhead ~ firstDay + secondDay + thirdDay,
                            data = train_dataset, hidden = 2)

model_results2 <- neuralnet::compute(exchange_model2, test_dataset[1:3])
predicted_oneDayhead2 <- model_results2$net.result
predict_value2 <- denormalized(predicted_oneDayhead2)
actual <- denormalized(test_dataset[,4])
error2 <- actual - predict_value2
hist(actual - predict_value2)
rmse(error2)
mae(error2)
## Third MLP
exchange_model3 <- neuralnet(oneDayAhead ~ firstDay + secondDay + thirdDay,
                            data = train_dataset, hidden = 2)

model_results3 <- neuralnet::compute(exchange_model3, test_dataset[1:3])
predicted_oneDayhead3 <- model_results3$net.result
predict_value3 <- denormalized(predicted_oneDayhead3)
error3 <- actual - predict_value3


## Homogeneous predicted_data and errors
all_predicted <- c(predict_value,predict_value2,predict_value3)
all_predicted <-as.data.frame(all_predicted)
names(all_predicted)<- c("First MLP", "Second MLP", "Third MLP")

## Final Fusion Funtion
min_value <-apply(all_predicted,1, min)
max_value <- apply(all_predicted,1,max)
mean_value <- apply(all_predicted,1,mean)

error_min <- actual - min_value
error_max <- actual - max_value
error_mean <- actual - mean_value

error_all_after_fusion <- as.data.frame(cbind(error_min,error_max,error_mean))

## Denormalizeing process and error calculation (NeuralNet with 1 hidden node)
predict_value <- as.vector(denormalized(predicted_oneDayhead))
actual <- denormalized(test_dataset[,4])
error <- actual - predict_value
# Example of invocation of functions
rmse(error) 
mae(error) 



# Example of invocation of functions
rmse(error) 
mae(error) 


## Final reasult

data_result <- cbind(test_date[702:1168,5],actual,predict_value$V1,error)
names(data_result) <- c("Date","Actual_Value","Predicted_Value", "Error")
data_error_hidden2 <- cbind(error,error2,error3)
names(data_error_hidden2) <- c("MLP_One_Error","MLP_Two_Error","MLP_Three_Error")

# Writing to xlsx file
library(xlsx)
write.xlsx(data_result, "data_result.xlsx")
write.xlsx(error_all_after_fusion, "error_all_after_fusion.xlsx")

