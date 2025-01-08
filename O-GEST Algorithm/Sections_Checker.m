function [INFO_L1,INFO_L2,INFO_L3]=Sections_Checker(JointsDepth_L,Time,INFO_L1,INFO_L2,INFO_L3)
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
if isempty(INFO_L1)~=1 && isempty(INFO_L2)~=1 && isempty(INFO_L3)~=1   
   [NC,Pos]=max([INFO_L1.N_Cycle,INFO_L2.N_Cycle,INFO_L3.N_Cycle]);
   if Pos==1
       SE=INFO_L1.SEsamples;
       Secs=INFO_L1.Sections;
   elseif Pos==2
       SE=INFO_L2.SEsamples;
       Secs=INFO_L2.Sections;
   elseif Pos==3
       SE=INFO_L3.SEsamples;
       Secs=INFO_L3.Sections;
   end
   if INFO_L1.N_Cycle~=NC
       INFO_L1.N_Cycle=NC;
       INFO_L1.SEsamples=SE;
       INFO_L1.Time=Time(SE(1,1):SE(1,2),1);
       INFO_L1.Data=JointsDepth_L(SE(1,1):SE(1,2),1);
       Sections=cell(1,NC);
       for i=1:1:NC
           sec_main=Secs{1,i};
           sec_t1=sec_main(1,1);
           sec_t2=sec_main(end,1);
           Sample1=height(Time(Time<sec_t1));
           Sample2=height(Time(Time<=sec_t2));
           Sections{1,i}=[Time(Sample1:Sample2,1),JointsDepth_L(Sample1:Sample2,1)];
       end
       INFO_L1.Sections=Sections;
       INFO_L1.Intersections_Info="Duplicated_Due_to_Inequal_Sections";
   end
   %-------------------------------------------------------------------------    
   if INFO_L2.N_Cycle~=NC
       INFO_L2.N_Cycle=NC;
       INFO_L2.SEsamples=SE;
       INFO_L2.Time=Time(SE(1,1):SE(1,2),1);
       INFO_L2.Data=JointsDepth_L(SE(1,1):SE(1,2),2);
       Sections=cell(1,NC);
       for i=1:1:NC
           sec_main=Secs{1,i};
           sec_t1=sec_main(1,1);
           sec_t2=sec_main(end,1);
           Sample1=height(Time(Time<sec_t1));
           Sample2=height(Time(Time<=sec_t2));
           Sections{1,i}=[Time(Sample1:Sample2,1),JointsDepth_L(Sample1:Sample2,2)];
       end
       INFO_L2.Sections=Sections;
       INFO_L2.Intersections_Info="Duplicated_Due_to_Inequal_Sections";
   end  
   %-------------------------------------------------------------------------
   if INFO_L3.N_Cycle~=NC
       INFO_L3.N_Cycle=NC;
       INFO_L3.SEsamples=SE;
       INFO_L3.Time=Time(SE(1,1):SE(1,2),1);
       INFO_L3.Data=JointsDepth_L(SE(1,1):SE(1,2),3);
       Sections=cell(1,NC);
       for i=1:1:NC
           sec_main=Secs{1,i};
           sec_t1=sec_main(1,1);
           sec_t2=sec_main(end,1);
           Sample1=height(Time(Time<sec_t1));
           Sample2=height(Time(Time<=sec_t2));
           Sections{1,i}=[Time(Sample1:Sample2,1),JointsDepth_L(Sample1:Sample2,3)];
       end
       INFO_L3.Sections=Sections;
       INFO_L3.Intersections_Info="Duplicated_Due_to_Inequal_Sections";
   end


elseif isempty(INFO_L1)~=1 && isempty(INFO_L2)~=1 && isempty(INFO_L3)==1  
     [NC,Pos]=max([INFO_L1.N_Cycle,INFO_L2.N_Cycle]);
   if Pos==1
       SE=INFO_L1.SEsamples;
       Secs=INFO_L1.Sections;
   elseif Pos==2
       SE=INFO_L2.SEsamples;
       Secs=INFO_L2.Sections;
   end
   if INFO_L1.N_Cycle~=NC
       INFO_L1.N_Cycle=NC;
       INFO_L1.SEsamples=SE;
       INFO_L1.Time=Time(SE(1,1):SE(1,2),1);
       INFO_L1.Data=JointsDepth_L(SE(1,1):SE(1,2),1);
       Sections=cell(1,NC);
       for i=1:1:NC
           sec_main=Secs{1,i};
           sec_t1=sec_main(1,1);
           sec_t2=sec_main(end,1);
           Sample1=height(Time(Time<sec_t1));
           Sample2=height(Time(Time<=sec_t2));
           Sections{1,i}=[Time(Sample1:Sample2,1),JointsDepth_L(Sample1:Sample2,1)];
       end
       INFO_L1.Sections=Sections;
       INFO_L1.Intersections_Info="Duplicated_Due_to_Inequal_Sections";
   end
   %-------------------------------------------------------------------------    
   if INFO_L2.N_Cycle~=NC
       INFO_L2.N_Cycle=NC;
       INFO_L2.SEsamples=SE;
       INFO_L2.Time=Time(SE(1,1):SE(1,2),1);
       INFO_L2.Data=JointsDepth_L(SE(1,1):SE(1,2),2);
       Sections=cell(1,NC);
       for i=1:1:NC
           sec_main=Secs{1,i};
           sec_t1=sec_main(1,1);
           sec_t2=sec_main(end,1);
           Sample1=height(Time(Time<sec_t1));
           Sample2=height(Time(Time<=sec_t2));
           Sections{1,i}=[Time(Sample1:Sample2,1),JointsDepth_L(Sample1:Sample2,2)];
       end
       INFO_L2.Sections=Sections;
       INFO_L2.Intersections_Info="Duplicated_Due_to_Inequal_Sections";
   end
elseif isempty(INFO_L1)~=1 && isempty(INFO_L2)==1 && isempty(INFO_L3)==1 
   %ded
end
end

       
