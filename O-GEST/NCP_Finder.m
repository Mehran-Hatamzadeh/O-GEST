function [NCP,Intensity]=NCP_Finder(INFO)
% ========================================================================
% Description: This function findes the suitable number of controls points
%              of B-Splines according to horizontal trajectory of a landmark.
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
Percent=0.01;
NCP=[];
Intensity=[];
if isempty(INFO)==0
   ID=zeros(1,width(INFO.Sections));
   Ratio=zeros(1,width(INFO.Sections));
   for q=1:1:width(INFO.Sections)
       Sec=INFO.Sections{1,q};
       Baseline_Sample=floor(height(Sec).*0.04)+1;
       Baseline_End=height(Sec)-Baseline_Sample:height(Sec);
        Sec_D=sgolayfilt(Sec(:,2),2,7);
        TH=(abs(min(Sec_D)-max(Sec_D))) * Percent;
        Val=abs(min(Sec_D)-mean(Sec_D(Baseline_End,1)));%Sec_D(end,1));
        Ratio(1,q)=Val/TH;
        if Val>=TH
            ID(1,q)=1;
        else
            ID(1,q)=0;
        end
   end
   if max(Ratio)<1
      NCP=4;
      Intensity="Normal";
   elseif max(Ratio)>=1
       NCP=5;
       Intensity="Intense";
   end

end
end