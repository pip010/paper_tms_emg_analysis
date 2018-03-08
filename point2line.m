function dist = point2line(A, B, P)
%shortest distance between point P and line through A and B, in 3D
%euclidian space. A and B are each a 3 element row vector, P can be a N*3
%matrix of row vectors for computation of distance to line for multiple points

  n=(B-A)/sqrt(sum( (B-A).^2) );
  N = ones(size(P,1),1)*n;
  
  distvec = ones(size(P,1),1)*A - P - (sum( ((ones(size(P,1),1)*A-P).*N),2)*[1 1 1] ).*N;
  dist=sqrt(sum(distvec.*distvec,2));
end
