library(party)
library(rpart)
library(caret)
library(e1071)
library(randomForest)
library(adabag)
library(unbalanced)
library(discretization)
library(FSelector)
library(mlbench)
library(pROC)

# Función que agrupa los tres métodos de balandeado que se analizarán en esta práctica
dataBalancer = function(dataBase, method){
  n<-ncol(dataBase)
  output<-dataBase[,n]
  input<-dataBase[ ,-n]
  
  if(method == "SMOTE"){
    data<-ubBalance(X= input, Y=output, type="ubSMOTE", percOver=300, percUnder=150, verbose=TRUE)
    balancedData<-cbind(data$X,data$Y)
    colnames(balancedData)[23] = "Class"
  }else if(method == "TomekLink"){
    data<-ubTomek(X= input, Y=output, verbose=TRUE)
    balancedData<-cbind(data$X,data$Y)
    colnames(balancedData)[23] = "Class"
  }else if(method == "ENN"){
    data<-ubENN(X=input, Y= output, verbose = TRUE)
    balancedData<-cbind(data$X,data$Y)
    colnames(balancedData)[23] = "Class"
  }
  
  # Ajustamos el tipo de algunos atributos que se han modificado ligeramente después de realizar el balanceo
  cols = c(1, 2, 3, 4, 5, 6, 8)
  balancedData[,cols] = apply(balancedData[,cols], 2, function(x) as.integer(x))
  
  return(balancedData)
}

# Función que simplifica el uso del paquete FSelector para la extracción de características
featureSelector = function(dataBase, n){
  weights <- FSelector::chi.squared(Class~.,dataBase)
  sub = FSelector::cutoff.k(weights, n)
  f = as.simple.formula(sub, "Class")
  print(f)
  return(f)
}


# Función automarizada para realizar la prediccióny generar el fichero con el formato específico de kaggle
savePrediction = function(model, datTest, fileName){
  if(class(model)[1] == "BinaryTree"){
    testPred = predict(model, newdata = datTest, type = "prob")
    testPred = sapply(1:length(testPred), function(n){testPred[[n]][1]})
  }else if(class(model)[1] == "randomForest.formula"){
    testPred = predict(model, newdata = datTest, type = "prob")[,2]
  }else if(class(model)[1] == "svm.formula"){
    testPred = predict(model, newdata = datTest, probability = T)
    testPred = attr(testPred,"probabilities")[,1]
  }else{
    testPred = predict(model, newdata = datTest)$prob[,1]
  }
  
  write.csv(as.vector(testPred), file = paste(fileName,".csv",sep = ""), quote = FALSE)
  
  ln = readLines(paste(fileName,".csv",sep = ""),-1)
  ln[1]="Id,Prediction"
  writeLines(ln,paste(fileName,".csv",sep = ""))
}

