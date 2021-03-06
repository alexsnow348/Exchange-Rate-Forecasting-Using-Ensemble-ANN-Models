#********************** RNN Network construction function *********************#

##Arguments
# train_dataset: the 60 % of the data to train the network
# validate_dataset: the 40 % of the data to test the network
# predictor_order: the no. of supplied past historical data (sample input range: 3 <-> 10)
# learning_rate : the learning rate to train the network (sample input range : 1 <-> 0.05)

# Return Values 
# Predicted Value and Error Results

RNN <- function(train_dataset, validate_dataset,non_normalize, predictor_order, learning_rate,activation_function){
        
        require("rnn")
       

## Training
        input_array_1 <- list()
        for (i in 1:predictor_order){
                input_day <- as.matrix(train_dataset[,i]) 
                input_array_1 <- c(input_array_1,input_day)
        }
        
        input_array_1 <- as.numeric(input_array_1)
        output_matrix <- as.matrix(train_dataset[,predictor_order+1])
        
        input_try <- array( input_array_1, dim=c(dim(input_day),predictor_order) )
        output_try <- array(output_matrix, dim=c(dim(output_matrix),1))
        
        model <- trainr(Y=output_matrix,
                        X=input_try,
                        learningrate   =  0.1,
                        sigmoid = activation_function,
                        hidden_dim  = ceiling((predictor_order+1)/2),
                        numepochs = 200
                        
        )
        
        ## Testing
        
        test_input_array_1 <- list()
        for (i in 1:predictor_order){
                input_day <- as.matrix(validate_dataset[,i]) 
                test_input_array_1 <- c(test_input_array_1,input_day)
        }
        
        test_input_array_1 <- as.numeric(test_input_array_1)
        
        
        test_input_try <- array( test_input_array_1, dim=c(dim(input_day),predictor_order) )
        
        test_result <- predictr(model, test_input_try )
        predict_value <- denormalized(test_result,non_normalize)
        actual <- denormalized(validate_dataset[,predictor_order+1],non_normalize)
        error <- actual - predict_value
        final_result <- list(predict_value,error,model)
        return(final_result)
        
}
