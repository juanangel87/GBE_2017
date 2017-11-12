library('phangorn')
library('ape')
arbol<-read.table("AAA.tre", header=FALSE, sep="\n"); #REPLACE "AAA.tre" by the file with tree topologies from states derived from RNA model
caso<-arbol[1,];
paso1<-gsub(")", "", caso);
paso2<-gsub("[(]", "", caso);
paso3<-gsub(";", "", caso);
tx<-strsplit(paso3, ",");
matriz<-matrix(unlist(tx), ncol=1);
taxa<-length(matriz);

									divisor=(2*taxa)-6;## value for doing the normalization. 2n-6 for unrooted trees; 2n-4 for rooted trees (according to raxml)
									
tree_set1<-read.tree("BBB.tre");					#REPLACE "BBB.tre" by the file with tree topologies from states  derived from DNA model
tree_set2<-read.tree("AAA.tre");					#REPLACE "AAA.tre" by the file with tree topologies from states  derived from RNA model

#DNA vs RNA
r1<-sample(tree_set1,XX,replace=TRUE); #REPLACE "XX" by the number of states to sample.
r2<-sample(tree_set2,XX,replace=TRUE); #REPLACE "XX" by the number of states to sample.
lista0<-c();
long0<-1:length(r1);

#DNA vs DNA
resampled_DNA<-sample(tree_set1,XX,replace=FALSE);  #REPLACE "XX" by the number of states to sample.
pz1<-XX/2;											#REPLACE "XX" by the number of states to sample.
dna1<-resampled_DNA[1:pz1];   
dna2<-resampled_DNA[(pz1+1):XX];					#REPLACE "XX" by the number of states to sample.
lista1<-c();
long1<-1:length(dna1);

#RNA vs RNA
resampled_RNA<-sample(tree_set2,XX,replace=FALSE);  #REPLACE "XX" by the number of states to sample.
pz2<-XX/2;										#REPLACE "XX" by the number of states to sample.
rna1<-resampled_RNA[1:pz2]; 
rna2<-resampled_RNA[(pz2+1):XX];					#REPLACE "XX" by the number of states to sample.
lista2<-c();
long2<-1:length(rna1);


## rf distances of DNA vs DNA
for (i in seq(along=long0-1)) {

  RF<-RF.dist(r1[[i]],r2[[i]]);
  lista0<-c(RF,lista0);
write.table(RF, append=TRUE, file="RF_distances_DNA_VS_RNA.txt",sep=";");

}
normalized_DNA_RNA<-lista0/divisor

for (i in seq(along=long1-1)) {

  RF1<-RF.dist(dna1[[i]],dna2[[i]]);
  lista1<-c(RF1,lista1);
write.table(RF1, append=TRUE, file="RF_distances_DNA_VS_DNA.txt",sep=";");#write in a table the raw RF dists, before being normalizing

}
normalized_DNA<-lista1/divisor
## rf distances of RNA vs RNA

for (i in seq(along=long2-1)) {

  RF2<-RF.dist(rna1[[i]],rna2[[i]]);
  lista2<-c(RF2,lista2);
write.table(RF2, append=TRUE, file="RF_distances_RNA_VS_RNA.txt",sep=";");

}
normalized_RNA<-lista2/divisor;

random_norm_mix<-sample(normalized_DNA_RNA,YY,replace=TRUE); #replace "YY" by the number of pairwise comparisons to perform
random_norm_dna<-sample(normalized_DNA,YY,replace=TRUE);
random_norm_rna<-sample(normalized_RNA,YY,replace=TRUE);

result_DNA_DNA_vs_DNA_RNA<-sort(random_norm_mix-random_norm_dna)
result_RNA_RNA_vs_DNA_RNA<-sort(random_norm_mix-random_norm_rna)


###and finally, check the proportion of comparisons where DNAvsRNA > DNAvsDNA, and DNAvsRNA > RNAvsRNA
write.table(result_DNA_DNA_vs_DNA_RNA,sep=",",file="RF_DNA_vsDNAvsRNA.csv")
write.table(result_RNA_RNA_vs_DNA_RNA,sep=",",file="RF_RNA_vsDNAvsRNA.csv")

