library(mice)
library(party)
library(caret)
library(e1071)
library(mlbench)
library(randomForest)
library(mvoutlier)
library(FSelector)

# Transformamos la variable HORA y creamos intervalos{dat|tst}
transHora = function(dataBase){
  h = as.character(dataBase[["HORA"]])
  h = gsub(",", ".", h)
  h = as.numeric(h)
  dataBase[["HORA"]] = ordered(cut(h, c(-1, 6, 14, 20, 24)), labels = c("madrugada", "mañana", "tarde", "noche"))
  return(dataBase)
}

# Función que nos muestra la cantidad de valores perdidos por variable
showNA = function(dataBase){
  p = sapply(dataBase, function(x) sum(is.na(x)))
  p = p[p > 0]
  barplot(p, cex.names = 0.7, col = "blue", main = "Cantidad valores perdidos")
}

# Función que duelve los indices de las columnas don hay valores perdidos
detectNA = function(dataBase){
  p = sapply(dataBase, function(x) sum(is.na(x)))
  p[p > 0]
  nNA = sapply(names(p[p > 0]), function(x){return(which(colnames(dataBase) == x))})
  notNA = sapply(names(p[p == 0]), function(x){return(which(colnames(dataBase) == x))})
  names(p == 0)
  return(list(notNA,"", nNA))
}

# Función que utiliza el paquete Mice para realizar la imputación de una variable. El resultado
# se escribe en un fichero csv
imputationMice = function(dataBase, nameVar){
  init = mice(dataBase, maxit=0)  
  meth = init$method  
  predM = init$predictorMatrix 
  
  meth[c(nameVar)]="polyreg"
  
  set.seed(103)  
  imputed = mice(dataBase, method=meth, predictorMatrix=predM, m=5)
  imputed <- complete(imputed)  
  
  write.csv(imputed[nameVar], file = paste("dataImp/test/", nameVar, ".csv", sep = ""), row.names = FALSE)
  return(imputed[nameVar])
}

# Función encargada de recorrer e imputar todas las variables que posean valores perdidos
imputedAll = function(dataBase, path){
  notNA_NA = detectNA(dataBase)
  notNAvar = notNA_NA[[1]]
  NAvar = notNA_NA[[3]]
  imputedDataBase = dataBase
  
  for(i in 1:(length(NAvar))){
    cut = sort(c(notNAvar, NAvar[i]))
    dataBaseCut = dataBase[, cut]
    cat(names(NAvar)[i], NAvar[i], "\n")
    imp = imputationMice(dataBaseCut, names(NAvar)[i])
    write.csv(imp, file = paste(path, "/", names(NAvar)[i],".csv",sep = ""))
  }  
}

# Función que simplifica el uso del paquete FSelector para la extracción de características
featureSelector = function(dataBase, n){
  weights <- FSelector::chi.squared(TIPO_ACCIDENTE~.,dataBase)
  sub = FSelector::cutoff.k(weights, n)
  f = as.simple.formula(sub, "TIPO_ACCIDENTE")
  print(f)
  return(f)
}

# Función automarizada para realizar la predicción y generar el fichero kaggle
savePrediction = function(model, datTest, fileName, isBaggingBosting){
  if(missing(isBaggingBosting)) isBaggingBosting = FALSE
  
  p = predict(model, newdata = datTest)
  if(isBaggingBosting == TRUE){
    write.csv(p$class, file = paste(fileName,".csv",sep = ""), quote = FALSE)
  }else{
    write.csv(as.vector(p), file = paste(fileName,".csv",sep = ""), quote = FALSE)
  }
  
  ln = readLines(paste(fileName,".csv",sep = ""),-1)
  ln[1]="Id,Prediction"
  writeLines(ln,paste(fileName,".csv",sep = ""))
}