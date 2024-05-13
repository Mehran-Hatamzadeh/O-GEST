function [INFO_L,INFO_R] = Visualization_GEST (INFO_L,INFO_R)
% ========================================================================
% Description: This function plots each pair of landmarks that are fed into
%               the algorithm. red color is used for left foot landmarks
%               and the fitted model on the, blue color for the right foot.
% ========================================================================

for ii=1
          CPs_Cycles=INFO_L.CPs;
          for i=1:1:length(CPs_Cycles)
              CP=CPs_Cycles{1,i};
              
              SP=spmak(INFO_L.Knots,CP);
              fnplt(SP,'red')
              hold on
              grid on
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
              grid on
              raw_data=INFO_R.Sections{1,i};
              plot(raw_data(:,1),raw_data(:,2),'. blue','MarkerSize',4)
              hold on; plot(CP(1,:),CP(2,:),'-o blue','MarkerSize',5)
          end
          
          hold on
          plot(INFO_L.Interests(1,:),INFO_L.Interests(2,:),'o black','MarkerSize',4,'LineWidth',1)
          hold on;
          plot(INFO_R.Interests(1,:),INFO_R.Interests(2,:),'o black','MarkerSize',4,'LineWidth',1)    

          xlabel('Time');
          ylabel('Depth');
          title('Gait GEST');
end

end