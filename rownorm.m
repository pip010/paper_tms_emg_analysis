function normed_out =rownorm(mat_in)
%normed_out =rownorm(mat_in) normalizes matrix rows per row

n=(sqrt(sum( (mat_in.*mat_in)' ))'); %length of each row vector
for t=1:size(mat_in,2)
    normed_out(:,t)=mat_in(:,t)./n; %yeah i know so cool this works
end

