## Clustering en R/RStudio
En R el clustering o agrupamiento es uno de los problemas más estudiados. Si revisamos el resumen RDataMining-reference-card puede observarse que se recogen todos los enfoques del agrupamiento así como numerosas variantes distintas técnicas.
En comparación con otros problemas no supervisados como reglas de asociación, o supervisados como clasificación, es con mucho el enfoque más elaborado.
También en RDataMining-reference-card se referencian las librerías de R dedicadas al agrupamiento (más de 20). Por nuestra parte nos centraremos en las más utilizadas que son las que proporcionan los métodos más conocidos estas librerías son:

* **stats** que recoge técnicas de cluster jerárquico (calculo, análisis del dendrograma, etc..), y de las k-medias, junto con funciones para el calculo de distancias.
* **cluster** que recoge los enfoques de L. Kaufman, P, J. Rousseeuw incluyendo métodos como DIANA, AGNES, K-medias difusas, CLARA etc. También permite obtener y representar el coeficiente de silueta.
* **fpc** donde se encuentra el dbscan junto con algunas interesantes métodos para el cálculo de la bondad.

Las técnicas que utilizaremos son las siguientes:
* K-means.
* Fuzzy-K-Means.
* K-medoide.
* DBSCAN.
* Método de Ward.

Los Scripts están orientados a trabajar con distancia euclídea y los datos de Iris. El esquema general de estos scritps es:
1. Normalizar previamente los datos.
1. Aplicar la técnica correspondiente.
1. Analizar la bondad del resultado mediante gráficas, el coeficiente de silueta y algunas medidas estadísticas adicionales.
