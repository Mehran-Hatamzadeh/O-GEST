function [Error]=Geometric_Error_calculator (INFO)
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
Cycles_Data=INFO.Sections;
CPs_Cycles=INFO.CPs;
N_Cycle=length(Cycles_Data);
E_All=zeros(1,N_Cycle);
for i=1:1:N_Cycle
    Controls=CPs_Cycles{1,i}; 
    raw_data=Cycles_Data{1,i};
    Data=[raw_data(:,1),raw_data(:,2)]';
    Data_Line1=Data(:,Data(1,:)<Controls(1,1));
    Data_Line2=Data(:,Data(1,:)>Controls(1,end));
    Data_Bspline=Data;
    Data_Bspline(:,1:1:width(Data_Line1))=[];
    Data_Bspline(:,end-width(Data_Line2)+1:1:end)=[];
    %---------------Inside Line1 and Line2---------------------
    E_Line1=abs(Data_Line1(2,:)-Controls(2,1));
    E_Line2=abs(Data_Line2(2,:)-Controls(2,end));
    %---------------Inside Cubic B-Spline----------------------
    [~,~,Distances] = Find_Projection_On_Cubic_Bspline (Controls,Data_Bspline);
    E_BSpline = Distances;
    %----------------------------------------------------------
    E_All(1,i)=sum(E_Line1)+sum(E_Line2)+sum(E_BSpline);
end
Error=sum(E_All);
end