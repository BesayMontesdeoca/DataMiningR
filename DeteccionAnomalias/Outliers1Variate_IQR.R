###########################################################################
# UNIVARIATE STATISTICAL OUTLIERS -> IQR 
###########################################################################


# mydata.numeric: frame de datos
# indice.columna: Índice de una columna de datos de mydata.numeric
# nombre.mydata:  Nombre del frame para que aparezca en los plots

# En este script los estableceremos a la base de datos mtcars, columna 1 y nombre "mtcars"

mydata.numeric  = mtcars[,-c(8:11)]  # mtcars[1:7]
indice.columna  = 1
nombre.mydata   = "mtcars"

# ------------------------------------------------------------------------

# Ahora creamos los siguientes objetos:

# mydata.numeric.scaled -> Contiene los valores normalizados demydata.numeric.
# columna -> Contendrá la columna de datos correspondiente a indice.columna. 
# nombre.columna -> Contiene el nombre de la columna.
# columna.scaled -> Contiene los valores normalizados de la anterior


mydata.numeric.scaled = scale(mydata.numeric)
columna         = mydata.numeric[, indice.columna]
nombre.columna  = names(mydata.numeric)[indice.columna]
columna.scaled  = mydata.numeric.scaled[, indice.columna]



###########################################################################
# Cómputo de los outliers IQR
###########################################################################

vector.es.outlier.normal  = vector_es_outlier_IQR(mydata.numeric, indice.columna)
vector.es.outlier.extremo = vector_es_outlier_IQR(mydata.numeric, indice.columna, 3)

valores.outliers.normales = columna[vector.es.outlier.normal]
valores.outliers.extremos = columna[vector.es.outlier.extremo]

claves.outliers.normales = vector_claves_outliers_IQR (mydata.numeric, indice.columna)
claves.outliers.extremos = vector_claves_outliers_IQR (mydata.numeric, indice.columna, 3)

claves.outliers.normales
valores.outliers.normales
claves.outliers.extremos
valores.outliers.extremos



###########################################################################
###########################################################################
# Ampliación

# Trabajamos con varias columnas simultáneamente
# Los outliers siguen siendo univariate, es decir, con respecto a una única columna
# Vamos a aplicar el proceso anterior de forma automática a todas las columnas
#
###########################################################################
###########################################################################



###########################################################################
# Índices y valores de los outliers
###########################################################################



# Obtenemos la siguiente matriz:
# frame.es.outlier -> matriz de T/F en la que por cada registro (fila), nos dice si
# es un outlier IQR en la columna correspondiente

# numero.total.outliers.por.columna -> Número de outliers que hay en cada variable (columna)
# indices.de.outliers.en.alguna.columna -> Contiene los índices de aquellos registros que tengan un valor anómalo en cualquiera de las columnas

frame.es.outlier = sapply(1:ncol(mydata.numeric), function(x) vector_es_outlier_IQR(mydata.numeric, x))
frame.es.outlier

numero.total.outliers.por.columna  = apply(frame.es.outlier, 2, sum)  
numero.total.outliers.por.columna 

indices.de.outliers.en.alguna.columna.como.una.lista = sapply(1:ncol(mydata.numeric), 
                                                              function(x) vector_claves_outliers_IQR(mydata.numeric, x)
                                                              )
indices.de.outliers.en.alguna.columna = unlist(indices.de.outliers.en.alguna.columna.como.una.lista)
indices.de.outliers.en.alguna.columna


###########################################################################
# Desviación de los outliers con respecto a la media de la columna
###########################################################################


# Mostramos los valores normalizados de los registros que tienen un valor anómalo en cualquier columna 
# Pero mostramos los valores de todas las columnas 
# (no sólo la columna con respecto a la cual cada registro era un valor anómalo)

#                       mpg       cyl       disp         hp       drat          wt        qsec
# Toyota Corolla       2.2912716 -1.224858 -1.2879099 -1.1914248  1.1660039 -1.41268280  1.14790999
# Maserati Bora       -0.8446439  1.014882  0.5670394  2.7465668 -0.1057878  0.36051645 -1.81804880
# Cadillac Fleetwood  -1.6078826  1.014882  1.9467538  0.8504968 -1.2466598  2.07750476  0.07344945
# Lincoln Continental -1.6078826  1.014882  1.8499318  0.9963483 -1.1157401  2.25533570 -0.01608893
# Chrysler Imperial   -0.8944204  1.014882  1.6885616  1.2151256 -0.6855752  2.17459637 -0.23993487
# Merc 230             0.4495434 -1.224858 -0.7255351 -0.7538702  0.6049193 -0.06873063  2.82675459

# Vemos, por ejemplo, que el Toyota se dispara (por arriba) en mpg pero no tanto en el resto de columnas
# El Maserati se dispara en hp (por arriba) y algo menos en qsec (por abajo)

mydata.numeric.scaled[indices.de.outliers.en.alguna.columna , ] 


###########################################################################
# BoxPlot
###########################################################################


# Mostramos los boxplots en un mismo gráfico.
# Tenemos que usar los datos normalizados, para que así sean comparables


# MiBoxPlot_juntos  = function (datos, vector_TF_datos_a_incluir)  
# Esta función normaliza los datos y muestra, de forma conjunta, los diagramas de cajas
# Así, podemos apreciar qué rango de valores toma cada outlier en las distintas columnas.

# Para etiquetar los outliers en el gráfico
# llamamos a la función MiBoxPlot_juntos_con_etiquetas 

windows()
boxplot(mydata.numeric.scaled , main=nombre.mydata) #, range = 3)
MiBoxPlot_juntos (mydata.numeric)
MiBoxPlot_juntos_con_etiquetas (mydata.numeric)

