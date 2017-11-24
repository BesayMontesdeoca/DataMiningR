###########################################################################
# UNIVARIATE STATISTICAL OUTLIERS -> 1-variate Normal Distribution

# Grubbs' test. Normal 1-dim. 1 único outlier
# grubbs.test {outliers}

# Rosner's test. Normal 1-dim. <= k outliers.
# rosnerTest {EnvStats}
###########################################################################



###########################################################################
# Conjuntos de datos 
###########################################################################


datos.con.un.outlier           = c(45,56,54,34,32,45,67,45,67,140,65)
datos.con.dos.outliers.masking = c(45,56,54,34,32,45,67,45,67,154,125,65)
datos.con.varios.outliers = c(-0.25,0.68,0.94,1.15,1.20,1.26,1.26,1.34,1.38,1.43,1.49,1.49,1.55,1.56,
                              1.58,1.65,1.69,1.70,1.76,1.77,1.81,
                              1.91,1.94,1.96,1.99,2.06,2.09,2.10,
                              2.14,2.15,2.23,2.24,2.26,2.35,2.37,
                              2.40,2.47,2.54,2.62,2.64,2.90,2.92,
                              2.92,2.93,3.21,3.26,3.30,3.59,3.68,
                              4.30,4.64,5.34,5.42,6.01)

mydata.numeric = datos.con.un.outlier


###########################################################################
# Test de Grubbs
###########################################################################

# Llamamos a la función MiPlot_resultados_TestGrubbs
# MiPlot_resultados_TestGrubbs = function(datos)
# Esta función realiza todo el proceso de aplicar el test de Grubbs
# También muestra los resultados: para ello, la función llama directamente a MiPlot_Univariate_Outliers
# El parámetro a pasar a la función MiPlot_resultados_TestGrubbs es el conjunto de datos
# 
# p.value: 0.001126431
# Índice de outlier: 10
# Valor del outlier: 140
# Número de datos: 11

MiPlot_resultados_TestGrubbs(mydata.numeric)


###########################################################################
# Volvemos a aplicar el mismo proceso con los otros conjuntos de datos
###########################################################################

# Aplicamos el test de Grubbs sobre datos.con.dos.outliers.masking

mydata.numeric = datos.con.dos.outliers.masking
plot(mydata.numeric)

test.de.Grubbs = grubbs.test(mydata.numeric, two.sided = TRUE)
test.de.Grubbs$p.value

MiPlot_resultados_TestGrubbs(mydata.numeric)



###########################################################################
# Test de Rosner
###########################################################################



# Hay tests para detectar un número exacto de k outliers, pero no son muy útiles
# Mejor usamos un test para detectar un número menor o igual que k outliers (Rosner)



# Aplicamos el Test de Rosner (rosnerTest) con k=4 sobre datos.con.dos.outliers.masking

mydata.numeric = datos.con.dos.outliers.masking
test.de.rosner = rosnerTest(mydata.numeric, k=4)

is.outlier.rosner = test.de.rosner$all.stats$Outlier
k.mayores.desviaciones.de.la.media = test.de.rosner$all.stats$Obs.Num
indices.de.outliers.rosner = k.mayores.desviaciones.de.la.media[is.outlier.rosner]
valores.de.outliers.rosner = mydata.numeric[indices.de.outliers.rosner]

print("Índices de las k-mayores desviaciones de la media")
k.mayores.desviaciones.de.la.media
print("De los k valores fijados, ¿Quién es outlier?")
is.outlier.rosner 
print("Los índices de los outliers son:")
indices.de.outliers.rosner
print("Los valores de los outliers son:")
valores.de.outliers.rosner

MiPlot_Univariate_Outliers (mydata.numeric, indices.de.outliers.rosner, "Test de Rosner")

mydata.numeric = datos.con.dos.outliers.masking
MiPlot_resultados_TestRosner(mydata.numeric)

#######################################################################

# Para ver el comportamiento del Test de Rosner con el conjunto de datos inicial 
# lanzamos la función MiPlot_resultados_TestRosner con k=4 sobre datos.con.un.outlier

# Test de Rosner
# Índices de las k-mayores desviaciones de la media: 10 5 4 7
# De las k mayores desviaciones, ¿Quién es outlier? TRUE FALSE FALSE FALSE
# Los índices de los outliers son: 10
# Los valores de los outliers son: 140
# Número de datos: 11

mydata.numeric = datos.con.un.outlier
MiPlot_resultados_TestRosner(mydata.numeric)


#######################################################################
# Lanzamos también el test de Rosner con k=4 sobre datos.con.varios.outliers

# Mostamos el plot de datos.con.varios.outliers
# Aplicamos el Test de Rosner (rosnerTest) con k=4 sobre datos.con.varios.outliers
# [1]  TRUE  TRUE  TRUE FALSE
# [1] 54 53 52 51

mydata.numeric = datos.con.varios.outliers
MiPlot_resultados_TestRosner(mydata.numeric)
