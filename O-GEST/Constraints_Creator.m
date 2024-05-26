function [A_Eq,b_Eq,A_InEq,b_InEq,Lb,Ub,x0,INFO_L,INFO_R]= Constraints_Creator(INFO_L,INFO_R)
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
       Dim=2;
       [A_InEq_L,b_InEq_L,A_Eq_L,b_Eq_L] = Constraints_Matrixes_All_Cycles (Dim,INFO_L);
       [A_InEq_R,b_InEq_R,A_Eq_R,b_Eq_R] = Constraints_Matrixes_All_Cycles (Dim,INFO_R);

       [Lb_L,Ub_L]=Bands_Lower_Upper(INFO_L);
       [Lb_R,Ub_R]=Bands_Lower_Upper(INFO_R);

       A_Eq=blkdiag(A_Eq_L,A_Eq_R);
       b_Eq=[b_Eq_L;b_Eq_R]; 

       A_InEq=blkdiag(A_InEq_L,A_InEq_R);
       b_InEq=[b_InEq_L;b_InEq_R];

       Lb=[Lb_L,Lb_R];
       Ub=[Ub_L,Ub_R];

       x0_L=reshape(cell2mat(INFO_L.CPs),[1,INFO_L.N_Cycle*INFO_L.Ncp*Dim])';
       x0_R=reshape(cell2mat(INFO_R.CPs),[1,INFO_R.N_Cycle*INFO_R.Ncp*Dim])';
       x0=[x0_L;x0_R];

       INFO_L.N_Param=height(x0_L);
       INFO_R.N_Param=height(x0_R);
end