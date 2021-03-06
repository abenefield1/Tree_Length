#' ---
#' output: github_document
#' ---

library(ape)
library(phytools)
library(ggplot2)
library(reshape2)

###################################################################
#ompA
ompA_trees<-read.nexus(file="One_outgroup/ompA.nex.run1.t")
#View(ompA_trees)
ompA_treelength<-numeric()
for (i in 1:length(ompA_trees)){
  ompA_treelength[i]<-sum(ompA_trees[[i]]$edge.length)
}

ompA_trees2<-read.nexus(file="One_outgroup/ompA.nex.run2.t")
ompA_treelength2<-numeric()
for (i in 1:length(ompA_trees2)){
  ompA_treelength2[i]<-sum(ompA_trees2[[i]]$edge.length)
}
#sanity check for expected differences
mean(ompA_treelength2)
mean(ompA_treelength)

#Concatenate lengths from the two runs
ompA<-c(ompA_treelength,ompA_treelength2)
#View(ompA)

###################################################################
#CP
CP_trees<-read.nexus(file="One_outgroup/CP_MAFFT.nex.run1.t")
CP_treelength<-numeric()
for (i in 1:length(CP_trees)){
  CP_treelength[i]<-sum(CP_trees[[i]]$edge.length)
}

CP_trees2<-read.nexus(file="One_outgroup/CP_MAFFT.nex.run2.t")
CP_treelength2<-numeric()
for (i in 1:length(CP_trees2)){
  CP_treelength2[i]<-sum(CP_trees2[[i]]$edge.length)
}
#sanity check for expected differences
mean(CP_treelength2)
mean(CP_treelength)

# Concatenate lengths from the two runs
CP<-c(CP_treelength,CP_treelength2)
#View(CP)


######################################################################
#Analysis:
Rates<-data.frame(ompA, CP)
head(Rates)
data<-melt(Rates)
head(data)
ggplot(data,aes(x=value, fill=variable)) + 
  geom_density(alpha=0.25) +
  xlab("Substitutions Per Site")+
  ylab("Density of Trees")+
  xlim(0,1.5)

hist(CP)
mean(CP,na.rm=TRUE)
mean(ompA)
hist(ompA)

densityCP<-density(CP)
xx <- densityCP$x
dx <- xx[2L] - xx[1L]  ## spacing / bin size
yy <- densityCP$y
C <- sum(yy) * dx  ## sum(yy * dx)
C

densityompA<-density(ompA)
xx <- densityompA$x
dx <- xx[2L] - xx[1L]  ## spacing / bin size
yy <- densityompA$y
C <- sum(yy) * dx  ## sum(yy * dx)
C

plot(densityCP)
polygon(densityompA, col="green", border="black")

t.test(ompA, CP, paired=TRUE, conf.level=0.98)
