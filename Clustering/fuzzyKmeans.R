# Cargamos y normalizamos los datos
iris2=iris
iris2$Species=NULL
for (j in 1:4) {x=iris2[,j] ; v=(x-mean(x))/sqrt(var(x)); iris2[,j]=v}

# Ejecutamos el algoritmo de clustering difuso
fuzzy.result=fanny(iris2,3)
str(fuzzy.result)
fuzzy.result$membership
table(fuzzy.result$clustering,iris$Species)
plot(fuzzy.result)

# (Ver descripcion de la funcion)
cluster.stats(dist(iris2),fuzzy.result$clustering,alt.clustering=as.integer(iris$Species))