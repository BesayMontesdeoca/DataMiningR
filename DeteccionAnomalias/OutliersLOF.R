###########################################################################
# MULTIVARIATE STATISTICAL OUTLIERS -> LOF 
###########################################################################

# Los outliers son respecto a un conjunto de variables.


#####################################################################
# Lectura de valores y Preprocesamiento
#####################################################################


# Tanto LOF como clustering usan distancias entre registros, por lo que habr�
# que trabajar sobre los datos previamente normalizados

# Construimos las siguientes variables:

# mis.datos.numericos -> Contendr� las columnas num�ricas de iris, es decir, iris [1:4]
# mis.datos.numericos.normalizados-> Contendr� los datos normalizados
# Asignamos como nombres de filas de mis.datos.numericos.normalizados los mismos nombres de filas que mis.datos.numericos

mis.datos.originales = iris
mis.datos.numericos  = mis.datos.originales[,1:4]
mis.datos.numericos  = mis.datos.originales[,sapply(mis.datos.originales, is.numeric)]
mis.datos.numericos.normalizados    = scale(mis.datos.numericos)
rownames(mis.datos.numericos.normalizados) = rownames(mis.datos.numericos)


X11()
corr.plot(mis.datos.numericos[,1], mis.datos.numericos[,3]) 

# El gr�fico nos muestra un gr�fico de dispersi�n al cruzar las variables 1 y 3.
# Vemos que hay dos grupos bien definidos de datos.
# Los puntos que hay entre ellos deber�an ser marcados como outliers
# Usando la distancia de Mahalanobis cl�sica (azul) el elipsoide
# contiene a ambos grupos por lo que los puntos que hubiese entre ellos no ser�an outliers
# Usando la distancia de Mahalanobis construida con la estimaci�n robusta de la matriz de covarianzas
# y las correspondientes medias, el elipsoide (rojo) se construye con el grupo de datos
# m�s numeroso y todos los datos del otro grupo se marcan como outliers :-(

# Tambi�n podemos mostrar un BiPlot llamando a la funci�n MiBiplot sobre mis.datos.numericos
# El gr�fico mostrado es una simplificaci�n ya que ahora estamos mostrando las cuatro variables conjuntamente 
# en un gr�fico 2 dimensional (Transparencia 72)
# Podemos apreciar que hay dos nubes de puntos bien separadas.

# As� pues, el m�todo de detecci�n de outliers usando la distancia de Mahalanobis no es adecuado


MiBiplot(mis.datos.numericos)



###########################################################################
# DISTANCE BASED OUTLIERS (LOF)
###########################################################################



numero.de.vecinos.lof = 5

# Establecemos el n�mero de vecinos a considerar numero.de.vecinos.lof = 5 y llamamos a la funci�n lofactor
# pas�ndole como primer par�metro el conjunto de datos normalizados y como par�metro k el valor de numero.de.vecinos.lof
# Esta funci�n devuelve un vector con los scores de LOF de todos los registros
# Lo llamamos lof.scores
# [1] 1.0036218 1.0244637 1.0198058 1.0394019 ......

# Hacemos un plot de los resultados (basta llamar a la funci�n plot sobre lof.scores) 
# para ver los scores obtenidos por LOF.
# Podemos apreciar que hay 4 valores de lof notablemente m�s altos que el resto
# As� pues, establecemos la variable siguiente:
# numero.de.outliers = 4

# Ordenamos los lof.scores y obtenemos los �ndices de los registros ordenados seg�n el lof.score
# indices.de.lof.outliers.ordenados
# [1]  42 118 132 110 107  16  61  23  ......

# Seleccionamos los 4 primeros y los almacenamos en indices.de.lof.top.outliers
# [1]  42 118 132 110 

# Construimos un vector is.lof.outlier de TRUE/FALSE que nos dice si cada registro de los datos
# originales es o no un outlier. Para ello, debemos usar la funci�n rownames sobre el dataset
# y el operador %in% sobre indices.de.lof.top.outliers
# is.lof.outlier
# [1] FALSE FALSE FALSE FALSE FALSE

# Mostramos un Biplot de los outliers llamando a la funci�n MiBiPlot_Multivariate_Outliers
# MiBiPlot_Multivariate_Outliers = function (datos, vectorTFoutliers, titulo)


lof.scores = lofactor(mis.datos.numericos.normalizados, k=numero.de.vecinos.lof)

plot(lof.scores)
numero.de.outliers = 4

indices.de.lof.outliers.ordenados = order(lof.scores, decreasing = TRUE)
indices.de.lof.outliers.ordenados
indices.de.lof.top.outliers       = indices.de.lof.outliers.ordenados[1:numero.de.outliers]   # Top outliers
indices.de.lof.top.outliers
is.lof.outlier = rownames(mis.datos.numericos) %in% indices.de.lof.top.outliers   #is.lof.outlier  = row(mis.datos.numericos)[,1] %in% indices.de.lof.top.outliers
is.lof.outlier
 
MiBiPlot_Multivariate_Outliers (mis.datos.numericos, is.lof.outlier, "LOF Outlier")



