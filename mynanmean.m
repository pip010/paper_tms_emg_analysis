function m=mynanmean(in)

i=find(~isnan(in));

m=mean(in(i));