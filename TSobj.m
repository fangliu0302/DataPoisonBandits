function [ y,grady ] = TSobj( x )
%UNTITLED21 Summary of this function goes here
%   Detailed explanation goes here

y = x'*x;
if nargout>1
    grady = 2*x;

end

