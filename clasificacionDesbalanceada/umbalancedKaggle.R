rm(list = ls())
source("utils.R")

# Carga y modificación de algunos atributos de las bases de datos para mejor entendimiento
dataTrain = read.csv("train.csv", header = TRUE)
dataTest = read.csv("test.csv", header = TRUE)
dataTest[["ID"]] = NULL
colnames(dataTrain) = sapply(1:22, function(n){paste("A", n, sep = "")})
colnames(dataTest) = sapply(1:22, function(n){paste("A", n, sep = "")})
colnames(dataTrain)[23] = "Class"
dataTrain[[23]] = factor(dataTrain[[23]])

# Balanceamos los datos seleccionando el método(SMOTE, TomekLink o ENN)
balancedData = dataBalancer(dataTrain, "TomekLink")

# Generamos la fórmula realizando una selección de características 
f = featureSelector(balancedData, 10)

# Parámetros
k.cv = 10
dataBase = balancedData
classPosition = 23
classFormula = formula(Class ~ .)
classFormula = f

# Se crean las particiones del conjunto de datos
ind = seq(1,nrow(dataBase),by=1)
trainPartitions = createFolds(ind, k = k.cv, returnTrain = TRUE)

# Generamos de la misma forma las particiones de test
testPartitions = list()
for(i in 1:k.cv){
  testPartitions[[i]] = ind[-trainPartitions[[i]]]
}

measure = c()
# Bucle de generacion de modelos
for(i in 1:k.cv){
  cat("k =", i, "\n")
  
  # Modelos
  
  # model = ctree(classFormula, dataBase[trainPartitions[[i]], ])
  # testPred = predict(model, newdata = dataBase[testPartitions[[i]], ], type = "prob")
  # testPred = sapply(1:length(testPred), function(n){testPred[[n]][1]})
  
  model = svm(classFormula, data = dataBase[trainPartitions[[i]], ], cost = 3, gamma = 0.001, probability = T)
  testPred = predict(model, newdata = dataBase[testPartitisons[[i]], ], probability = T)
  testPred = attr(testPred,"probabilities")[,1]
  
  # model = randomForest(classFormula, dataBase[trainPartitions[[i]], ], ntree = 150)
  # testPred = predict(model, newdata = dataBase[testPartitions[[i]], ], probability = T)
  # testPred = predict(model, newdata = dataBase[testPartitions[[i]], ], type = "prob")[,2]
  # 
  # model = adabag::boosting(classFormula, data = dataBase[trainPartitions[[i]], ],
  #                             mfinal = 20,
  #                             control = rpart::rpart.control(maxdepth = 5, minsplit = 5))
  # testPred = predict(model, newdata = dataBase[testPartitions[[i]], ])$prob[,1]
  
  # model = adabag::bagging(classFormula, data = dataBase[trainPartitions[[i]], ],
  #                           mfinal = 20,
  #                           control=rpart::rpart.control(maxdepth= 5, minsplit= 5))
  # testPred = predict(model, newdata = dataBase[testPartitions[[i]], ])$prob[,1]

  # Calculamos el área bajo la curva ROC (AUC)
  aucM = auc(dataBase[testPartitions[[i]], classPosition], testPred)[1]
  cat("AUC =", aucM, "\n\n")
  measure = cbind(measure, aucM)
}  

finalMeasures = apply(measure, 1, function(n){sum(n)/k.cv})
cat("\n\nAverage AUC Measures\n")
print(finalMeasures)

# Generamos la predicción con el modelo y creamos el archivo csv 
savePrediction(model, datTest = dataTest, fileName = "kaggleRP/PrfSUlt2")
