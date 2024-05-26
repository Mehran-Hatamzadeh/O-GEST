function [INFO]=Type_INFO_Corrector(INFO,Setting)
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
INFO.Data=INFO.Data-Setting.Shift_Offset;
INFO.Intersections="Without_Intersections";
INFO.Line_Info="Without_Intersections_Line";
INFO.Interests(2,:)=INFO.Interests(2,:)-Setting.Shift_Offset;
for i=1:1:INFO.N_Sections
    SEC=INFO.Sections{1,i};
    SEC(:,2)=SEC(:,2)-Setting.Shift_Offset;
    INFO.Sections{1,i}=SEC;
    %---------------------
    CP=INFO.CPs{1,i};
    CP(2,:)=CP(2,:)-Setting.Shift_Offset;
    INFO.CPs{1,i}=CP;
    %---------------------
    Ext=INFO.Extremes{1,i};
    Ext(2,:)=Ext(2,:)-Setting.Shift_Offset;
    INFO.Extremes{1,i}=Ext;
end
end