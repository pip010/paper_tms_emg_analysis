defines;

load(fullfile(DataPath,'data'));  %load scirun export from Petar
load(fullfile(DataPath,'emg_traces'));  %load raw emg traces obtained from nnm files

compute_replace_MEPs; %add our own MEP amplitude computation from filtered EMG traces

eval(['cd ',DataPath]);   %folder to print results in
vis_on=0;

subsel=[1:7];
exptlist={'cross','grid_ort','grid_par'};

%parameters for analysis
metric='C5';
MEP_real_thr=0.00001; %thresholds for real MEPs (only values above will be included in analyses)
filterlowmeps=1; %switch off/on (0/1) removal of subthreshold MEPs
use_transfer=0; % use a neuronal transfer function or not (1/0)
primE=1;
secE=0;

for tsub=1:length(subsel),
    subj=subsel(tsub);
    %figure(subsel(tsub));
    
    for roi=1:2,
        
        switch(roi)
            case 1
                FV.faces=roi_patch(subj).ROI.face'; %put triangle faces in matlab patch object
                FV.vertices=roi_patch(subj).ROI.node'; %put triangle vertices in matlab patch object
            case 2
                FV.faces=roi_patch(subj).ROI2.face'; %put triangle faces in matlab patch object
                FV.vertices=roi_patch(subj).ROI2.node'; %put triangle vertices in matlab patch object
        end
        
        %now do the magic: replace faces with a new set of faces with unified normals (pointing in same directions regionally
        FV_fixed=unifyMeshNormals(FV,'alignTo','in');
        
        %compute normals as outer products of 2 triangle sides
        %normals have length of 2xsurface area of triangle (as constructed with outer product)
        norms = cross(FV.vertices(FV.faces(:,3),:)-FV.vertices(FV.faces(:,1),:), FV.vertices(FV.faces(:,2),:)-FV.vertices(FV.faces(:,1),:));
        
        %clear normsn;
        %normsn=rownorm(norms); %normalize to unity length normals
        
        %same for fixed patch
        
        %compute normals as outer products of 2 triangle sides
        %normals have length of 2xsurface area of triangle (as constructed with outer product)
        norms_fixed = cross(FV_fixed.vertices(FV_fixed.faces(:,3),:)-FV_fixed.vertices(FV_fixed.faces(:,1),:), FV_fixed.vertices(FV_fixed.faces(:,2),:)-FV_fixed.vertices(FV_fixed.faces(:,1),:));
        
        %clear normsn_fixed;
        %normalize to unity length normals
        %normsn_fixed=rownorm(norms_fixed);
        
        %compute face vertex centroids (needed below for distance computation)
        clear facecentroids;
        for ip=1:size(FV_fixed.faces,1)
           faceverts=FV_fixed.vertices(FV_fixed.faces(ip,:),:);
           facecentroids(ip,:)=mean(faceverts);
        end

        
        for texp=1:length(exptlist)    %check all the combinatorics
            if roi==1 && texp ==1
                N=length(data(subj).cross.ROI1PE);
            end
            if roi==2 && texp ==1
                N=length(data(subj).cross.ROI2PE);
            end
            if roi==1 && texp ==2
                N=length(data(subj).grid_ort.ROI1PE);
            end
            if roi==2 && texp ==2
                N=length(data(subj).grid_ort.ROI2PE);
            end
            if roi==1 && texp ==3
                N=length(data(subj).grid_par.ROI1PE);
            end
            if roi==2 && texp ==3
                N=length(data(subj).grid_par.ROI2PE);
            end
            
            clear MEP_comp;
            %loop over all stimulations
            for stim=1:N
                
                if roi==1 && texp ==1
                    Efield=data(subj).cross.ROI1PE{stim} + secE*data(subj).cross.ROI1SE{stim}; %total field in ROI1, 'cross' experiment
                    flagpos=data(subj).cross.FLAG{stim};
                end
                if roi==2 && texp ==1
                    Efield=primE*data(subj).cross.ROI2PE{stim} + secE*data(subj).cross.ROI2SE{stim}; %total field in ROI1, 'cross' experiment
                    flagpos=data(subj).cross.FLAG{stim};                    
                end
                if roi==1 && texp ==2
                    Efield=primE*data(subj).grid_ort.ROI1PE{stim} + secE*data(subj).grid_ort.ROI1SE{stim}; %total field in ROI1, 'cross' experiment
                    flagpos=data(subj).grid_ort.FLAG{stim};
                end
                if roi==2 && texp ==2
                    Efield=primE*data(subj).grid_ort.ROI2PE{stim} + secE*data(subj).grid_ort.ROI2SE{stim}; %total field in ROI1, 'cross' experiment
                    flagpos=data(subj).grid_ort.FLAG{stim};
                end
                if roi==1 && texp ==3
                    Efield=primE*data(subj).grid_par.ROI1PE{stim} + secE*data(subj).grid_par.ROI1SE{stim}; %total field in ROI1, 'cross' experiment
                    flagpos=data(subj).grid_par.FLAG{stim};
                end
                if roi==2 && texp ==3
                    Efield=primE*data(subj).grid_par.ROI2PE{stim} + secE*data(subj).grid_par.ROI2SE{stim}; %total field in ROI1, 'cross' experiment
                    flagpos=data(subj).grid_par.FLAG{stim};
                end

                %compute direction weighted distance field as H0 hypo
                
                Dist2face=point2line(flagpos(1,:),flagpos(2,:),facecentroids);

                epsilon=1/35; %chosen such that at distance 0, 'field' = 35 (similar magnitude as real field)
                FlagDir=(flagpos(3,:)-flagpos(2,:)); %orientation of flag
                FlagDirn=FlagDir/sqrt(sum(FlagDir.^2))'; %normalize
                DirectionDistField=ones(size(Efield,1),1)*FlagDirn .*  ( (1./(Dist2face+epsilon) * [1 1 1]));    
                
                switch metric
                    case 'C0'
                        MEP_comp(stim)=patch_mepmetric(DirectionDistField, norms_fixed,'C3',use_transfer); %metric computation                        
                    otherwise
                        MEP_comp(stim)=patch_mepmetric(Efield, norms_fixed,metric,use_transfer); %metric computation
                end
                %MEP_comp(stim)=sum(abs(sum(Efield.*normsn_fixed,2))); %metric C3 summed over all faces
            end
            switch (texp) %select real MEPs for the current experiment
                case 1
                    MEP_real=data(subj).cross.MEP_ours;  %change to .MEP for Neurosoft MEP amplitude
                    MEP_real_ns=data(subj).cross.MEP;  
                case 2
                    MEP_real=data(subj).grid_ort.MEP_ours;
                    MEP_real_ns=data(subj).grid_ort.MEP;
                case 3
                    MEP_real=data(subj).grid_par.MEP_ours;
                    MEP_real_ns=data(subj).grid_par.MEP;
            end
            
            %create panel with scatterplot for MEP ns vs MEP ours
            figure(3);
            subplot(length(subsel),length(exptlist)*2,length(exptlist)*2*(tsub-1)+2*(texp-1) + roi);
            plot(MEP_real_ns,MEP_real,'x');

            %create panel with scatterplot
            figure(4);
            
            subplot(length(subsel),length(exptlist)*2,length(exptlist)*2*(tsub-1)+2*(texp-1) + roi);
            plot(MEP_comp/1000,MEP_real,'x');   %plot modeled vs real MEP (modeled divided by 1000 for nicer axis labels)
            box on;
            if filterlowmeps
              i=find(MEP_real>MEP_real_thr);
            else 
              i=[1:length(MEP_real)]; %select all
            end
            if ~isempty(i)
                if thisismatlab  %correlation is different in matlab than octave
                    CC=corrcoef(MEP_comp(i)/1000,MEP_real(i));
                    VarExp(tsub,texp,roi)=CC(2,1);
                else %assume octave
                    VarExp(tsub,texp,roi)=corr(MEP_comp(i)/1000,MEP_real(i));
                end
            else
              VarExp(tsub,texp,roi)=NaN;
            end
            title(sprintf('ROI: %i, exp: %s, CC: %1.2f',roi,exptlist{texp}, VarExp(tsub,texp,roi)));

            %create panel with bars (< and > 50%)
            
            figure(2);
            subplot(length(subsel),length(exptlist)*2,length(exptlist)*2*(tsub-1)+2*(texp-1) + roi);

            if filterlowmeps
              %remove real small MEPs from lists
              i=find(MEP_real<MEP_real_thr);
              MEP_comp(i)=[];
              MEP_real(i)=[];
            end 
            
            [MEP_comp_sorted,is]=sort(MEP_comp); 
            MEP_real_sorted=MEP_real(is); % sort real MEPs in same way as computed meps to maintain datapairs
            lim=MEP_comp_sorted(floor(length(MEP_comp_sorted)/2)); % find value separating lower from higher 50% (round down for uneven nr of stims)

            %lim=median(MEP_comp_sorted); 

            lowhalf = find(MEP_comp_sorted<=lim);            
            highhalf = find(MEP_comp_sorted>lim);           
            lowMEP=mean(MEP_real_sorted(lowhalf)); 
            highMEP=mean(MEP_real_sorted(highhalf)); 
            bar([lowMEP,highMEP]);
            box on;
            title(sprintf('ROI: %i, exp: %s lim: %1.2f',roi,exptlist{texp},lim/1000));
            
        end
    end
end
%set paper size
h=gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);% print it to PNG
%eval(sprintf('print -dpng subj%i_metric_%s.png',subj,metric));
