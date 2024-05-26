function [Basis_Fun] = Cubic_Bspline_Basis_Function (Ncp)
% ========================================================================
% Description: This function provides the basis function of a Cubic B-Spline
%              by defining the number of control points (Ncp) and using
%              open uniform knot vectors with multiplicity.
%              In the function of spmak, utilizing [1,0,0,0 ...] will give first base (N0),
%              [0,1,0,0 ...] will give second base (N1),
%              [0,0,1,0 ...] will give second base (N2),
%              and etc.
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
Knots = [ zeros(1,4) , 1:1:Ncp-4 , zeros(1,4)+(Ncp-3)];
for i=0:1:Ncp-1
    CP_V = zeros(1,Ncp);
    CP_V(1,i+1)=1;
    Basis_Fun(1,i+1)=spmak(Knots,CP_V);
end
end
