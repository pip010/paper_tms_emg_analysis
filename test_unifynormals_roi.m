load D:\DATA\dropbox\Dropbox\data\ppetrov_cross_results\data;  %load scirun export from Petar
 
subj=5;
FV.faces=roi_patch(subj).ROI2.face'; %put triangle faces in matlab patch object
FV.vertices=roi_patch(subj).ROI2.node'; %put triangle vertices in matlab patch object

%now do the magic: replace faces with a new set of faces with unified normals (pointing in same directions regionally
FV_fixed=unifyMeshNormals(FV,'alignTo','in');

%compute normals as outer products of 2 triangle sides
norms = cross(FV.vertices(FV.faces(:,3),:)-FV.vertices(FV.faces(:,1),:), FV.vertices(FV.faces(:,2),:)-FV.vertices(FV.faces(:,1),:));

clear normsn;
%normalize to unity length normals
normsn(:,1)=norms(:,1)./(sqrt(sum( (norms.*norms)' ))'); %yeah i know so cool this works
normsn(:,2)=norms(:,2)./(sqrt(sum( (norms.*norms)' ))'); %yeah i know so cool this works
normsn(:,3)=norms(:,3)./(sqrt(sum( (norms.*norms)' ))'); %yeah i know so cool this works

 %centroids per triangle
centerfaces=[FV.vertices(FV.faces(:,1),:) + FV.vertices(FV.faces(:,2),:) + FV.vertices(FV.faces(:,3),:)]/3;


%same for fixed patch

%compute normals as outer products of 2 triangle sides
norms_fixed = cross(FV_fixed.vertices(FV_fixed.faces(:,3),:)-FV_fixed.vertices(FV_fixed.faces(:,1),:), FV_fixed.vertices(FV_fixed.faces(:,2),:)-FV_fixed.vertices(FV_fixed.faces(:,1),:));

clear normsn_fixed;
%normalize to unity length normals
normsn_fixed(:,1)=norms_fixed(:,1)./(sqrt(sum( (norms_fixed.*norms_fixed)' ))'); %yeah i know so cool this works
normsn_fixed(:,2)=norms_fixed(:,2)./(sqrt(sum( (norms_fixed.*norms_fixed)' ))'); %yeah i know so cool this works
normsn_fixed(:,3)=norms_fixed(:,3)./(sqrt(sum( (norms_fixed.*norms_fixed)' ))'); %yeah i know so cool this works

 %centroids per triangle
centerfaces_fixed=[FV_fixed.vertices(FV_fixed.faces(:,1),:) + FV_fixed.vertices(FV_fixed.faces(:,2),:) + FV_fixed.vertices(FV_fixed.faces(:,3),:)]/3;
 

%plot the patch in left panel, fixed patch in right panel. I know Petar, computations and plotting in 1 script but see if I care ;-)
figure;
subplot(1,2,1);
patch(FV,'facecolor',[1 0 0]); % draw the patch
hold on;
quiver3(centerfaces(:,1),centerfaces(:,2),centerfaces(:,3),normsn(:,1),normsn(:,2),normsn(:,3));
view(30,30);
subplot(1,2,2);
patch(FV_fixed,'facecolor',[1 0 0]); % draw the patch
hold on;
quiver3(centerfaces_fixed(:,1),centerfaces_fixed(:,2),centerfaces_fixed(:,3),normsn_fixed(:,1),normsn_fixed(:,2),normsn_fixed(:,3));
view(30,30);