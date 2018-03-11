subj=2;
N=size(data(subj).cross.FLAG,2)

figure;
hold on;
for stim=1:N
  fpos1=data(subj).cross.FLAG{stim}(1,:); %flagtop?
  fpos2=data(subj).cross.FLAG{stim}(2,:); %flagtop?
  plot3(fpos1(1),fpos1(2),fpos1(3),'bo');
  plot3(fpos2(1),fpos2(2),fpos2(3),'ro');
end