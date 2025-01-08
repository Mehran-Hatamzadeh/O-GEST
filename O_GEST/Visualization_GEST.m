function [INFO_L,INFO_R] = Visualization_GEST (INFO_L,INFO_R)
% ========================================================================
% Description: This function plots each pair of landmarks that are fed into
%               the algorithm. red color is used for left foot landmarks
%               and the fitted model on the, blue color for the right foot.
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
for ii=1
          CPs_Cycles=INFO_L.CPs;
          for i=1:1:length(CPs_Cycles)
              CP=CPs_Cycles{1,i};
              
              SP=spmak(INFO_L.Knots,CP);
              fnplt(SP,'red')
              hold on
%               grid on
              raw_data=INFO_L.Sections{1,i};
              plot(raw_data(:,1),raw_data(:,2),'. red','MarkerSize',4)
              hold on; plot(CP(1,:),CP(2,:),'-o red','MarkerSize',5)   
          end
          hold on;
          CPs_Cycles=INFO_R.CPs;
          for i=1:1:length(CPs_Cycles)
              CP=CPs_Cycles{1,i};
              SP=spmak(INFO_R.Knots,CP);
              hold on
              fnplt(SP,'blue')
              hold on
%               grid on
              raw_data=INFO_R.Sections{1,i};
              plot(raw_data(:,1),raw_data(:,2),'. blue','MarkerSize',4)
              hold on; plot(CP(1,:),CP(2,:),'-o blue','MarkerSize',5)
          end
          
          hold on
          plot(INFO_L.Interests(1,:),INFO_L.Interests(2,:),'o black','MarkerSize',4,'LineWidth',1)
          hold on;
          plot(INFO_R.Interests(1,:),INFO_R.Interests(2,:),'o black','MarkerSize',4,'LineWidth',1)    

          xlabel('Time');
          ylabel('Depth (Horizontal)');
          title('O-GEST');
end

end