function mepmetric = patch_mepmetric(field, norms, metric, ntransfer)
  switch(metric)
    case 'C0' %simply the field magnitude summed over all faces in the patch, wighted for triangle size (length of normal)
       lengthnorm=(sqrt(sum( (norms.*norms)' ))');    
       if ntransfer
          mepmetric=sum( neuronal_transfer(sqrt(sum( (field.*field)' ))',35,0.2) .* lengthnorm); %metric C0
       else
          mepmetric=sum( sqrt(sum( (field.*field)' ))' .* lengthnorm); %metric C0
       end

    case 'CE' %simply the field magnitude summed over all faces in the patch, wighted for triangle size (length of normal)
       lengthnorm=(sqrt(sum( (norms.*norms)' ))');    
       if ntransfer
          mepmetric=sum( neuronal_transfer(sqrt(sum( (field.*field)' ))',35,0.2) .* lengthnorm); %metric C0
       else
          mepmetric=sum( sqrt(sum( (field.*field)' ))' .* lengthnorm); %metric C0
       end
    
    case 'C3' %the well known C3 metric
       mepmetric=sum(abs(sum(field.*norms,2)))/2; %metric C3 summed over all faces. As norms are not normalized to unit length, this also multiplies by triangle surface

    case 'C4' %like C3, but assymetric (strongest when field pointing OUTWARD)
       fieldmag=(sqrt(sum( (field.*field)' ))');   
       lengthnorm=(sqrt(sum( (norms.*norms)' ))');    
       if ntransfer
          mepmetric_all=lengthnorm.*neuronal_transfer(  (fieldmag+sum(field.*(norms./lengthnorm),2))/4,5,0.5); %metric C4 summed over all faces
       else
          mepmetric_all=(fieldmag.*lengthnorm+sum(field.*(norms),2))/4; %metric C4 summed over all faces
       end   
       mepmetric=sum(mepmetric_all);
       
   case 'C5' %like C3, but assymetric (strongest when field pointing INWARD)
       fieldmag=(sqrt(sum( (field.*field)' ))');       
       lengthnorm=(sqrt(sum( (norms.*norms)' ))');    

       if ntransfer
          mepmetric_all=lengthnorm.*neuronal_transfer(  (fieldmag+sum(field.*(-norms./(lengthnorm * [1 1 1]) ),2))/4,5,0.5); %metric C4 summed over all faces
       else
          mepmetric_all=(fieldmag.*lengthnorm+sum(field.*(-norms),2))/4; %metric C4 summed over all faces
       end
       mepmetric=sum(mepmetric_all);
    otherwise
       mepmetric=NaN;
    end
end
