function [Beziers_Inside] = Beziers_Inside_Bspline (Controls)
% ========================================================================
% Description: This function seperates a Cubic B-Spline identified by 2*N Control points
%              in which the first row represents X coordinate of control points (Time),              
%              and second row represents their Y coordinate (Horizontal Distance).
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
[Dim,Ncp]=size(Controls);
Num_Beziers=(Ncp-4)+1;
if Num_Beziers==1
   Beziers_Inside{1,1}=Controls;
else
    Knots = [ zeros(1,4) , 1:1:Ncp-4 , zeros(1,4)+(Ncp-3)];
    sp = spmak(Knots,Controls);
    Seperator_Knots=zeros(1,(Num_Beziers-1)*2);
    for i=1:1:Num_Beziers-1
     Seperator_Knots(1,(2*i)-1:2*i)=i;
    end
    spref = fnrfn(sp,Seperator_Knots);
    Beziers_Inside=cell(1,Num_Beziers);
    for j=1:1:Num_Beziers
        Beziers_Inside{1,j}=spref.coefs(1:Dim,(3*j)-2:(3*j)+1);
    end
end
end
