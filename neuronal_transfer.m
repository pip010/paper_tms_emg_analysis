function out = neuronal_transfer(in,thr,rc)
%   out = neuronal_transfer(in) computes the neuronaal transfer function of 'in'
%   'in' can be a vector or scalar.
%   currently, the sigmoid function is used with a threshold value and a steepness

out = 1 ./ (1 + e.^-( (in-thr)*rc));

% =============================================================

end