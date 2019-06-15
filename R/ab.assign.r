ab.assign<-function(comm.b,samp.ab,prob.ab)
{
  # assign individuals into species according to probability
  # comm.b matrix, binary comm file (randomized or observed)
  # samp.ab vector, observed abundance in each sample
  # prob.ab matrix, probability of individuals draw into each species in each sample. 
  comm.b[comm.b>0]=1 # force comm.b to be binary
  samp.rich<-rowSums(comm.b)
  size.rand=samp.ab-samp.rich
  sp.id<-lapply(1:nrow(comm.b),function(i){which(comm.b[i,]>0)})
  out<-matrix(sapply(1:nrow(comm.b),
              function(i)
              {
                res=rep(0,ncol(comm.b))
                if(length(sp.id[[i]])!=0)
                {
                  if(length(sp.id[[i]])==1){ab.id=rep(sp.id[[i]],size.rand[i])}else{
                    ab.id=sample(sp.id[[i]],size.rand[i],replace = TRUE,prob = prob.ab[i,sp.id[[i]]])
                  }
                  ab.table=table(ab.id)
                  res[as.numeric(names(ab.table))]=as.vector(ab.table)
                  res[sp.id[[i]]]=res[sp.id[[i]]]+1
                }
                res
              }),ncol=nrow(comm.b))
  rownames(out)<-colnames(comm.b)
  colnames(out)<-rownames(comm.b)
  t(out)
}