function    [CPs_Cycles,Step] = Solution_Completion_and_CPs_Update_QP (x0,INFO,INFO_Optimization)
% ========================================================================
% Description: This function applies a damping on the newly obtained poisition
%              of control points and updates the previous control points.
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
Dim=2;
Ncp=INFO.Ncp;
CPs_Cycles=INFO.CPs;
Weight=INFO_Optimization.Damping_Weight;

N_Cycle=length(CPs_Cycles);
Old_Cps=cell2mat(CPs_Cycles);
x0 = reshape(x0(:,1),[Dim,Ncp*N_Cycle]);
Step=x0-Old_Cps;
for i=1:1:N_Cycle
    CPs=CPs_Cycles{1,i};
    xx=x0(:, ((i-1)*Ncp +1):(i*Ncp));
    CPs_new=(Weight.*(xx-CPs))+CPs;
    CPs_Cycles{1,i}=CPs_new;
end
end
