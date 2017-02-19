rm(list = ls())
library(arules)
dat = read.table("student-mat.csv",sep=";",header=TRUE)

# Eliminamos los atributos redundantes y poco útiles
dat[["G1"]] = NULL
dat[["G2"]] = NULL
dat[["failures"]] = NULL
dat[["paid"]] = NULL
dat[["reason"]] = NULL
dat[["school"]] = NULL
# dat[["Pstatus"]] = NULL
# dat[["internet"]] = NULL
# dat[["nursery"]] = NULL
# dat[["schoolsup"]] = NULL


# Construimos los intervalos
dat[["age"]] = ordered(cut(dat[["age"]], c(14, 17, 23)), labels = c("younger", "adult"))

dat[["Medu"]] = factor(dat[["Medu"]], levels = c(1, 2, 3, 4), 
                       labels = c("primary-education", "5th-to-9th-grade", "secondary-education", "higher-education"))

dat[["Fedu"]] = factor(dat[["Fedu"]], levels = c(1, 2, 3, 4), 
                       labels = c("primary-education", "5th-to-9th-grade", "secondary-education", "higher-education"))

dat[["traveltime"]] = factor(dat[["traveltime"]], levels = c(1, 2, 3, 4), 
                             labels = c("<15 min", "15-to-30-min", "30-min-to-1-hour", ">1-hour"))

dat[["studytime"]] = factor(dat[["studytime"]], levels = c(1, 2, 3, 4), 
                             labels = c("<2 hours", "2-to-5-hours", "5 to 10 hours", ">10 hours"))

dat[["famrel"]] = factor(dat[["famrel"]], levels = c(1, 2, 3, 4, 5), 
                            labels = c("very-bad", "bad", "medium", "good", "excellent"))

dat[["freetime"]] = factor(dat[["freetime"]], levels = c(1, 2, 3, 4, 5), 
                         labels = c("very-low", "low", "medium", "high", "very-high"))

dat[["goout"]] = factor(dat[["goout"]], levels = c(1, 2, 3, 4, 5), 
                           labels = c("very-low", "low", "medium", "high", "very-high"))


dat[["Dalc"]] = factor(dat[["Dalc"]], levels = c(1, 2, 3, 4, 5), 
                        labels = c("very-low", "low", "medium", "high", "very-high"))

dat[["Walc"]] = factor(dat[["Walc"]], levels = c(1, 2, 3, 4, 5), 
                        labels = c("very-low", "low", "medium", "high", "very-high"))

dat[["health"]] = factor(dat[["health"]], levels = c(1, 2, 3, 4, 5), 
                         labels = c("very-bad", "bad", "medium", "good", "very-good"))

dat[["absences"]] = ordered(cut(dat[["absences"]], c(-1, 0, 10, 20, 75)), labels = c("never", "low", "enough", "many"))

dat[["G3"]] = ordered(cut(dat[["G3"]], c(-1, 9, 13, 17, 19, 20)), labels = c("fail", "pass", "outstanding", "excellent", "With honours/Distinction"))

# Añadimos los items negados
replaceData = function(d, strg){
  if(d == strg){
    return("TRUE")
  }else{
    return("FALSE")
  }
}

famrelVeryBad = sapply(dat[["famrel"]], replaceData, "very-bad")
famrelBad = sapply(dat[["famrel"]], replaceData, "bad")
famrelMedium = sapply(dat[["famrel"]], replaceData, "medium")
famrelGood = sapply(dat[["famrel"]], replaceData, "good")
famrelExcellent = sapply(dat[["famrel"]], replaceData, "excellent")
dat[["famrel"]] = NULL
dat = cbind(dat, famrelVeryBad, famrelBad, famrelMedium, famrelGood, famrelExcellent)

datT = dat[dat[,"G"] == "",]
datA = dat[dat[,"Pstatus"] == "A",]

dat = datT
nameFile = "reglasPstatus=T.csv"
sop = 0.5
con = 0.6

# Convertimos el data.frame en un conjunto de transacciones 
transDat = as(dat, "transactions")

# Items frecuentes
itemFrequencyPlot(transDat, support = 0.3, cex.names=1.5, col = "blue")

# Extraemos itemsets frecuentes
freqDat = apriori(transDat, parameter = list(support = 0.4, target="frequent"))
freqDat = sort(freqDat, by="support")   # Los ordenamos por el valor del soporte
inspect(head(freqDat, n=10))   # Inspeccionamos los 10 primeros

# Consultamos el tamaño de los itemsets frecuentes
barplot(table(size(freqDat)), xlab="itemset size", ylab="count")
inspect(freqDat[size(freqDat)==3])

# Extraemos itemsets frecuentes maximales y cerrados
maxiDat = freqDat[is.maximal(freqDat)]
inspect(head(sort(maxiDat, by="support")))

cloDat = freqDat[is.closed(freqDat)]
inspect(head(sort(cloDat, by="support")))

barplot(c(frequent=length(freqDat), closed=length(cloDat),
          maximal=length(maxiDat)), ylab="count", xlab="itemsets")

# Extraemos reglas: Aprior
rules = apriori(transDat, parameter = list(support = sop, confidence = con, minlen = 2))
inspect(head(rules))

# Ordenamos las reglas por Confianza
rulesSorted = sort(rules, by = "confidence")
inspect(head(rulesSorted))

# Seleccionamos un subconjunto de reglas que cumplan: lift > 1.2 y antecedente = {race = white}
rulesSelected <- subset(rulesSorted, subset = lhs %in% "Pstatus=A")
# inspect(head(rulesSorted))
# rulesSorted = rules

# Eliminamos reglas redundantes
subsetMatrix <- is.subset(rulesSelected, rulesSelected)
subsetMatrix[lower.tri(subsetMatrix, diag=T)] <- NA
redundant <- colSums(subsetMatrix, na.rm=T) >= 1
rulesPruned <- rulesSelected[!redundant] # remove redundant rules
inspect(head(rulesPruned))

# Calculamos medidas de interés adicionales
mInteres <- interestMeasure(rulesPruned, measure=c("hyperConfidence", "leverage", "phi", "gini"), transactions=freqDat)
quality(rulesPruned) <- cbind(quality(rulesPruned), mInteres)
inspect(head(sort(rulesPruned, by="phi")))

library (arulesViz)
plot(rulesPruned)

??plot # consultar las distintas opciones para la función plot
plot(rulesPruned[1:6], method="graph", control=list(type="items"))
try: plot(rulesPruned, method="grouped", interactive=TRUE)
plot(rulesPruned[1:6], , method="paracoord", control=list(reorder=TRUE))

write(rulesPruned, file=nameFile, sep = ",", col.names=NA)

