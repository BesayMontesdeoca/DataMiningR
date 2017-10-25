# Besay Montesdeoca Santana 45334027S
# besayms.39@gmail.com
# Ejercicio de trabajo autónomo. Series temporales. Curso 2016-2017.

rm(list =ls()) # Eliminamos lo que haya en el espacio de trabajo

library("tseries")

NPred = 6 # Valores a predecir
NTest = 6 # Valores que vamos a dejar para test

# Cargamos serie y datos reales a predecir 
serie = scan("SerieTrabajoPractico.dat")

# Para averiguar la posible frecuencia de estacionalidad podríamos apoyarnos en la medida AFC
acf(serie)
# Observamos que la serie temporal posee un periodo de estacionalidad de 6 meses
serie.ts = ts(serie, frequency = 6)

# Visualizamos la descomposición
plot(decompose(serie.ts))

# Observamos que no presenta ninguna tendencia, pero si una estacionalidad. También queda patente que la serie
# no precisa de ningún preprocesamiento puesto que no existe una excesiva variación en la varianza en la parte
# irregular de la serie

# Dividimos la serie en training y test (nos quedamos con los NTest últimos para el test)
serieTr = serie[1:(length(serie)-NTest)]
tiempoTr = 1:length(serieTr)
serieTs = serie[(length(serie)-NTest+1):length(serie)]
tiempoTs = (tiempoTr[length(tiempoTr)]+1):(tiempoTr[length(tiempoTr)]+NTest)

plot.ts(serieTr, xlim=c(1, tiempoTs[length(tiempoTs)]))
lines(tiempoTs, serieTs, col = "red")

# Calculamos y eliminamos la estacionalidad
k = 6 # Periodo de estacionalidad = 6
estacionalidad =rep(0, k)
for (i in 1:k) {
  secuencia =seq(i, length(serieTr), by =k)
  for (j in secuencia) {
    estacionalidad[i]= estacionalidad[i] + serieTr[j]
  }
  estacionalidad[i]=estacionalidad[i]/length(secuencia)
}

# Eliminamos estacionalidad
aux = rep(estacionalidad, length(serieTr)/length(estacionalidad))
serieTr.SinEst = serieTr-aux
serieTs.SinEst = serieTs-estacionalidad

# Una vez eliminado la estacionalidad comprobamos las gráficas de autocorrelación (ACF) y autocorrelación parcial (PACF)
acf(serieTr.SinEst)
pacf(serieTr.SinEst)

# Realizamos el test ADF
adftest = adf.test(serieTr.SinEst)
print(adftest)

# Observamos que supera el test y por tanto es estacionario y no es necesario diferenciar.

# Función que realiza distintos procedimientos para evaluar la precisión de una serie. Se calculan 
# los errores cuadráticos de ajuste y test seguido de una comprobación de la bondad del ajuste mediante 
# el tests de aleatoriedad y normalidad.
testSeries = function(modelo, Npred){
  # Cogemos los valores que se han ajustado de la serie 
  valoresAjustados = serieTr.SinEst + modelo$residuals 
  
  # Calculamos las predicciones 
  Predicciones = predict(modelo, n.ahead = NPred) 
  valoresPredichos = Predicciones$pred # Cogemos las predicciones
  
  # Calculamos el error cuadrático acumulado del ajuste, en ajuste y en test
  errorTr = sum((modelo$residuals)^2)
  errorTs = sum((valoresPredichos-serieTs.SinEst)^2)
  
  par(mfrow=c(2,2))
  
  # Mostramos las gráficas del ajuste y predicción en test
  plot.ts(serieTr.SinEst, xlim=c(1, tiempoTs[length(tiempoTs)]))
  lines(valoresAjustados, col = "blue")
  lines(tiempoTs, serieTs.SinEst, col = "red")
  lines(tiempoTs, valoresPredichos, col = "blue")
  
  valoresAjustados = valoresAjustados+aux # Estacionalidad
  valoresPredichos = valoresPredichos+estacionalidad
  
  plot.ts(serie)
  lines(valoresAjustados, col = "blue")
  lines(valoresPredichos, col = "red")
  
  # Tests para la selección del modelo y su validación
  boxtestM1 = Box.test(modelo$residuals) # Test de aleatoriedad de Box-Pierce
  JB = jarque.bera.test(modelo$residuals) # Test de normalidad de Jarque Bera
  SW = shapiro.test(modelo$residuals) # Test de normalidad de Shapiro-Wilk
  
  # Mostramos histograma de residuos 
  hist(modelo$residuals, col = "blue", prob=T,ylim=c(0,8),xlim=c(-0.5,0.5))
  lines(density(modelo$residuals))
  par(mfrow=c(1,1))
  
  cat("\n.........................................................\n","Tabla resumen\n.........................................................\n", "Errores Cuadráticos(ajuste, test) = ", c(errorTr, errorTs),
      "\n\n Resultados test de aleatoriedad y normalidad\n", c(" Test de Box-Pierce: ", boxtestM1$p.value, 
                                                               "\n  Test de Jarque Bera: ", JB$p.value, "\n  Test de Shapiro-Wilk: ", SW$p.value), 
      "\n.........................................................\n")
}


# Observando las gráficas ACF y PACF parece ser que se trata de un modelo autorregresivo
# de grado 1 u 13 según se quiera despreciar los los valores cercanos al umbral de error. 
# Mirándolo de otro modo, también se podría interpretar como un modelo de medias móviles
# grado 1 u 14 Por ello se probaron los siguientes modelos.
modeloAR_1 = arima(serieTr.SinEst, order = c(1, 0, 0))
testSeries(modeloAR_1, NPred)

modeloAR_13 = arima(serieTr.SinEst, order = c(13, 0, 0))
testSeries(modeloAR_13, NPred)

modeloMA_1 = arima(serieTr.SinEst, order = c(0, 0, 1))
testSeries(modeloMA_1, NPred)

modeloMA_14 = arima(serieTr.SinEst, order = c(0, 0, 14))
testSeries(modeloMA_14, NPred)

# Para comparar los modelos utilizaremos el criterio de Akaike, donde sabemos que no sólo considera la
# bondad del ajuste, sino también la complejidad de los modelos.
AIC(modeloAR_1, modeloAR_13, modeloMA_1, modeloMA_14)


rm(list =ls()) # Eliminamos lo que haya en el espacio de trabajo

# Calibrar mejor modelo con la serie completa
prediccionSerie = function(serie, NPred, orden) {
  serieFull = serie 
  tiempo = 1:length(serieFull)
  parametros = lm (serieFull ~ tiempo  )
  
  # Calculamos estacionalidad
  k = 6
  estacionalidad =rep(0, k)
  for (i in 1:k) {
    secuencia =seq(i, length(serieFull), by =k)
    for (j in secuencia) {
      estacionalidad[i]= estacionalidad[i] + serieFull[j]
    }
    
    estacionalidad[i]=estacionalidad[i]/length(secuencia)
  }
  aux = rep(estacionalidad, length(serieFull)/length(estacionalidad))
  
  #Eliminamos estacionalidad
  serieFullSinEst = serieFull-aux
  
  # Ajustamos el modelo que hemos seleccionado
  modelo = arima(serieFullSinEst, order = orden)
  
  # Obtenemos ajuste y predicción
  valoresAjustados = serieFullSinEst+modelo$residuals
  Predicciones = predict(modelo, n.ahead = NPred) 
  valoresPredichos = Predicciones$pred # Cogemos las predicciones
  
  # Por último, deshacemos cambios
  valoresAjustados = valoresAjustados+aux # Estacionalidad
  valoresPredichos = valoresPredichos+estacionalidad
  tiempoPred = (tiempo[length(tiempo)]+(1:NPred))
  
  plot.ts(serie, xlim=c(1, max(tiempoPred)))
  lines(valoresAjustados, col = "blue")
  lines(valoresPredichos, col = "red")
  
  # Devolvemos la predicción
  return(valoresPredichos)
}

# Cargamos nuevamente la serie y comprobamos el resultado de función
serieFull = scan("SerieTrabajoPractico.dat")
prediccionSerie(serieFull, 6, c(13, 0, 0))
