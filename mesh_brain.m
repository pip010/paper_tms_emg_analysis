% fname_gm='D:\DATA\test_segment_spm12\c1bijl120508_3_1-0001.nii';
% fname_wm='D:\DATA\test_segment_spm12\c2bijl120508_3_1-0001.nii';
% V_gm=spm_vol(fname_gm);
% V_wm=spm_vol(fname_wm);
% Data_gm=spm_read_vols(V_gm);
% Data_wm=spm_read_vols(V_wm);
% opt=5;thr=0.5;
% Datain=zeros(size(Data_gm));
% Datain(Data_gm>Data_wm)=1;
% Datain(Data_wm>Data_gm)=2;
% %Datain=Data;

addpath('D:\DATA\spm12');
addpath('D:\DATA\dropbox\Dropbox\matlab\iso2mesh');
fname='D:\DATA\test_segment_spm12\S1\indexmap_artgm_cleaned_rounded_t60_despeckled_toppart.nii';
V=spm_vol(fname);
Datain=spm_read_vols(V);

opt=200; % head surface element size bound

%Datain(Datain>1)=0;
Datain_uint8 = uint8(Datain);
[node,elem,face]=vol2mesh(Datain_uint8,1:size(Datain,1),1:size(Datain,2),1:size(Datain,3),opt,100,1,'cgalmesh',[1 2 3 4 5 0]);

% figure(1);
% m1=plotmesh(node,face);axis equal;view(90,60);
% cl=camlight(20, 10);
% lighting phong
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% view(162,-46);

figure(2);

m2=plotmesh(node,face,elem,'x<140 & x>100');axis equal;
cl=camlight(20, 10);
campos=[300,200,100];
camtar=[0,200,100];
camup=[0 1 0];
set(cl,'position',campos);
set(gca,'CameraPosition', campos);
set(gca,'CameraTarget', camtar);
set(gca,'CameraUpVector', camup);
set(gca,'CameraViewAngle',40);
 
lighting flat
xlabel('X')
ylabel('Y')
zlabel('Z')

figure(3);

subplot(1,4,1);
i=find(face(:,4)==2);
%m2=plotmesh(node,face(i,:));axis equal;
FV.vertices=node(:,1:3);
FV.faces=face(i,1:3);
p_brain  = patch(FV, 'FaceColor', [0.8 0.8 1], 'FaceVertexCData', [],...
        'EdgeColor', 'none',...
        'FaceAlpha',1);

view(-174,-12);%
cl=camlight;

% campos=[100,500,100];
% camtar=[0,0,0];
% camup=[0 1 0];
% set(cl,'position',campos);
% set(gca,'CameraPosition', campos);
% set(gca,'CameraTarget', camtar);
% set(gca,'CameraUpVector', camup);
% set(gca,'CameraViewAngle',40);
 
lighting flat

xlabel('X')
ylabel('Y')
zlabel('Z')
title('Gray matter');

subplot(1,4,2);
i=find(face(:,4)==1);
%m2=plotmesh(node,face(i,:));axis equal;
FV.vertices=node(:,1:3);
FV.faces=face(i,1:3);
p_brain  = patch(FV, 'FaceColor', [0.8 0.8 1], 'FaceVertexCData', [],...
        'EdgeColor', 'none',...
        'FaceAlpha',1);

view(-174,-12);%
cl=camlight;
lighting flat
xlabel('X')
ylabel('Y')
zlabel('Z')
title('White matter');

subplot(1,4,3);
i=find(face(:,4)==3);
%m2=plotmesh(node,face(i,:));axis equal;
FV.vertices=node(:,1:3);
FV.faces=face(i,1:3);
p_brain  = patch(FV, 'FaceColor', [0.8 0.8 1], 'FaceVertexCData', [],...
        'EdgeColor', 'none',...
        'FaceAlpha',1);

view(-174,-12);%
cl=camlight;
lighting flat
xlabel('X')
ylabel('Y')
zlabel('Z')
title('CSF');

subplot(1,4,4);
i=find(face(:,4)==4);
%m2=plotmesh(node,face(i,:));axis equal;
FV.vertices=node(:,1:3);
FV.faces=face(i,1:3);
p_brain  = patch(FV, 'FaceColor', [0.8 0.8 1], 'FaceVertexCData', [],...
        'EdgeColor', 'none',...
        'FaceAlpha',1);

view(-174,-12);%
cl=camlight;
lighting flat
xlabel('X')
ylabel('Y')
zlabel('Z')
title('Skin');

%view(90,0);

% % mesh with denser surface    |----> surface triangle size is now 2
% [node,elem,face]=v2m(Data,0.3,2,40);
% 
% figure;
% subplot(211);
% plotmesh(node,face);axis equal;view(90,60);
% subplot(212);
% plotmesh(node,elem);axis equal;view(90,60);