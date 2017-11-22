library(cluster)
library(Rmixmod)

#Carganis y preparamos los datos, solo nos quedamos con 100 datos 
# para visualizar mejor los restultados.
iris2=iris
idx=sample(1:dim(iris2)[1],100)
idx
iris3=iris2[idx,]
iris3
iris3$Species=NULL
iris3

# Calculamos el cluster jeraquico por el metodo de Ward, distancia euclidea
hc=hclust(dist(iris3),method="ward.D2")
hc

# Dibujamos el dendrograma y donde cortamos por tres
plot(hc,labels=iris2$Species[idx])
rect.hclust(hc,k=3)

# Generamos la variable de agrupamiento
group=cutree(hc,k=3)
group

# Medidas de bondad de agrupamiento: coeficiente de silueta
plotcluster(iris3,group)
shi = silhouette(group,dist(iris3))
plot(shi,col=1:3)

# Calculamos algunas otras medidas de bondad del agrupamiento
# (Ver descripcion de la funcion)
cluster.stats(dist(iris3),group,alt.clustering=as.integer(iris$Species[idx]))
