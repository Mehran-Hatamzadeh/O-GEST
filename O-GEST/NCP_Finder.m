function [NCP,Intensity]=NCP_Finder(INFO)
% ========================================================================
% Description: This function findes the suitable number of controls points,
%              (i.e. the model) according to horizontal trajectory of a landmark.
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
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