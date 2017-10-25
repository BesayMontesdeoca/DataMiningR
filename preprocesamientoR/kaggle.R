rm(list = ls())
source('utils.R')

dataTrain <- read.csv("data/accidentes-kaggle.csv")
dataTest = read.csv("data/accidentes-kaggle-test.csv")

# Eliminamos las variables inutiles (ANIO, PROVINCIA, ISLA, CARRETERA, RED_CARRETERA, ACOND_CALZADA, PRIORIDAD, 
# VISIBILIDAD_RESTRINIDA, OTRA_CIRCUNSTANCIA, ACERAS, MEDIDAS_ESPECIALES)
dataTrain[, c(1, 5, 7, 15, 26, 29)] = NULL
dataTest[, c(1, 5, 7, 15, 26, 29)] = NULL

# Creamos los intervalos de la variable HORA
dataTrain = transHora(dataTrain)
dataTest = transHora(dataTest)

# Mostramos los valores perdidos de al base de datos
showNA(dataTrain)

# Generamos los valores perdidos de las bases de datos
imputedAll(dataTrain, "dataImp/train")
imputedAll(dataTest, "dataImp/test")

# Añadimos los valores sintéticos a las bases de datos
dataTrainImp = dataTrain
dataTrainImp["ACERAS"] = read.csv("dataImp/train/ACERAS.csv")
dataTrainImp["ACOND_CALZADA"] = read.csv("dataImp/train/ACOND_CALZADA.csv")
dataTrainImp["DENSIDAD_CIRCULACION"] = read.csv("dataImp/train/DENSIDAD_CIRCULACION.csv")
dataTrainImp["PRIORIDAD"] = read.csv("dataImp/train/PRIORIDAD.csv")
dataTrainImp["VISIBILIDAD_RESTRINGIDA"] = read.csv("dataImp/train/VISIBILIDAD_RESTRINGIDA.csv")

dataTestImp = dataTest
dataTestImp["ACERAS"] = read.csv("dataImp/test/ACERAS.csv")
dataTestImp["ACOND_CALZADA"] = read.csv("dataImp/test/ACOND_CALZADA.csv")
dataTestImp["DENSIDAD_CIRCULACION"] = read.csv("dataImp/test/DENSIDAD_CIRCULACION.csv")
dataTestImp["PRIORIDAD"] = read.csv("dataImp/test/PRIORIDAD.csv")
dataTestImp["VISIBILIDAD_RESTRINGIDA"] = read.csv("dataImp/test/VISIBILIDAD_RESTRINGIDA.csv")

# Realizamos una selección de las 14 mejores características
f = featureSelector(dataTrainImp, 14)

# Parametros
k.cv = 5
dataBase = dataTrainImp # Base da datos imputada
classPosition = length(names(dataBase))
# classFormula = formula(TIPO_ACCIDENTE ~ .)
classFormula = f # Entrenamiento con selección de características


# Se crean las particiones del conjunto de datos
ind = seq(1,nrow(dataBase),by=1)
trainPartitions = createFolds(ind, k = k.cv, returnTrain = TRUE)

# Generamos de la misma forma las particiones de test
testPartitions = list()
for(i in 1:k.cv){
  testPartitions[[i]] = ind[-trainPartitions[[i]]]
}

acc = 0
# Bucle de generación de modelos
for(i in 1:k.cv){
  cat("k =", i, "\n")
  # Modelos
  # model = ctree(classFormula, dataBase[trainPartitions[[i]], ])
  # model = svm(classFormula, data = dataBase[trainPartitions[[i]], ])
  model = randomForest(classFormula, dataBase[trainPartitions[[i]], ], ntree = 200)
  # model = adabag::bagging(classFormula, data = dataBase[trainPartitions[[i]], ])

  # Test
  testPred = predict(model, newdata = dataBase[testPartitions[[i]], ])
  
  # Cálculo de las medidas de precisión
  if(class(model) == "boosting" || class(model) == "bagging"){
    results = mean(testPred$class == dataBase[testPartitions[[i]], ]$TIPO_ACCIDENTE)
  }else{
    results = mean(testPred == dataBase[testPartitions[[i]], ]$TIPO_ACCIDENTE)
  }
  print(results)
  acc = acc + results
}  
print(acc/k.cv)

savePrediction(model, datTest = dataTestImp, fileName = "kaggleResults/rf", isBaggingBosting = F)
