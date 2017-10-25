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

