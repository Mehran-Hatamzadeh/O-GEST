function [INFO_L,INFO_R]=Extremities_Finder_Varying(INFO_L,INFO_R)
% ========================================================================
% Description: This function finds extremities of B-Spline curves according
%              using the optimal thresholds.
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% ========================================================================
% License: GNU Affero General Public License (GNU AGPL V3.0)
% ========================================================================
%     Copyright (C) 2024  Mehran Hatamzadeh
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU Affero General Public License as
%     published by the Free Software Foundation, either version 3 of the
%     License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU Affero General Public License for more details.     
%     
%     You should have received a copy of the GNU Affero General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>
% ========================================================================
[INFO_L_FO,INFO_R_FO]=Extremities_Finder(INFO_L,INFO_R,"FO");

[INFO_L_FS,INFO_R_FS]=Extremities_Finder(INFO_L,INFO_R,"FS");


INTERESTS_FO=INFO_L_FO.Interests;
INTERESTS_FS=INFO_L_FS.Interests;
INTERESTS_L=INTERESTS_FO;
INTERESTS_L (:,3:4:width(INTERESTS_FS))= INTERESTS_FS(:,3:4:width(INTERESTS_FS));
for i=1:1:width(INFO_L_FO.Extremes_Tk)
    EXT_TK_FO=INFO_L_FO.Extremes_Tk{1,i};
    EXT_TK_FS=INFO_L_FS.Extremes_Tk{1,i};
    EXT_TK_FO(1,2)=EXT_TK_FS(1,2);
    INFO_L_FO.Extremes_Tk{1,i}=EXT_TK_FO;
    %------
    EXT_FO=INFO_L_FO.Extremes{1,i};
    EXT_FS=INFO_L_FS.Extremes{1,i};
    EXT_FO(:,2)=EXT_FS(:,2);
    INFO_L_FO.Extremes{1,i}=EXT_FO;
end
INFO_L.Interests=INTERESTS_L;
INFO_L.Extremes=INFO_L_FO.Extremes;
INFO_L.Extremes_Tk=INFO_L_FO.Extremes_Tk;

%=============================================

INTERESTS_FO=INFO_R_FO.Interests;
INTERESTS_FS=INFO_R_FS.Interests;
INTERESTS_R=INTERESTS_FO;
INTERESTS_R (:,3:4:width(INTERESTS_FS))= INTERESTS_FS(:,3:4:width(INTERESTS_FS));
for i=1:1:width(INFO_R_FO.Extremes_Tk)
    EXT_TK_FO=INFO_R_FO.Extremes_Tk{1,i};
    EXT_TK_FS=INFO_R_FS.Extremes_Tk{1,i};
    EXT_TK_FO(1,2)=EXT_TK_FS(1,2);
    INFO_R_FO.Extremes_Tk{1,i}=EXT_TK_FO;
    %------
    EXT_FO=INFO_R_FO.Extremes{1,i};
    EXT_FS=INFO_R_FS.Extremes{1,i};
    EXT_FO(:,2)=EXT_FS(:,2);
    INFO_R_FO.Extremes{1,i}=EXT_FO;
end
INFO_R.Interests=INTERESTS_R;
INFO_R.Extremes=INFO_R_FO.Extremes;
INFO_R.Extremes_Tk=INFO_R_FO.Extremes_Tk;


end