function    [CPs_Cycles] = Solution_Completion_and_CPs_Update (x0,Dim,INFO)
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
Ncp=INFO.Ncp;
CPs_Cycles=INFO.CPs;
N_Cycle=length(CPs_Cycles);
x0 = reshape(x0(:,1),[Dim,Ncp*N_Cycle]);
for i=1:1:N_Cycle    
    xx=x0(:, ((i-1)*Ncp +1):(i*Ncp));
    CPs_Cycles{1,i}=xx;
end
end
