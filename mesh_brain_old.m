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
fname='D:\DATA\test_segment_spm12\S1\indexmap_cleaned_rounded_t30_despeckled_toppart.nii';
V=spm_vol(fname);
Datain=spm_read_vols(V);

opt=40; % head surface element size bound

thr=0.5;
Datain(Datain>1)=0;
[node,elem,face]=vol2mesh(Datain,1:size(Datain,1),1:size(Datain,2),1:size(Datain,3),opt,20,1,'cgalmesh',[0.5]);

% figure(1);
% m1=plotmesh(node,face);axis equal;view(90,60);
% cl=camlight(20, 10);
% lighting phong
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% view(162,-46);

figure(2);
m2=plotmesh(node,elem);axis equal;
cl=camlight(20, 10);
set(cl,'position',[200,200,-400])
lighting phong
xlabel('X')
ylabel('Y')
zlabel('Z')
view(162,-46);

% % mesh with denser surface    |----> surface triangle size is now 2
% [node,elem,face]=v2m(Data,0.3,2,40);
% 
% figure;
% subplot(211);
% plotmesh(node,face);axis equal;view(90,60);
% subplot(212);
% plotmesh(node,elem);axis equal;view(90,60);