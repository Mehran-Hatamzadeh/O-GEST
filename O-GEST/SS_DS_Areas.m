function [INFO_L1,INFO_R1] = SS_DS_Areas (INFO_L1,INFO_R1,Events_Time,Setting)
% ========================================================================
% Description: This function plots swing areas of the left (red) and right 
%              foot (blue),and the double support areas (gray).
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------

if Setting.Direction=="Downward"
   MAXD=mean([INFO_L1.Data(1:3,1)',INFO_R1.Data(1:3,1)'])+2*std([INFO_L1.Data(1:3,1)',INFO_R1.Data(1:3,1)']);
   MIND=mean([INFO_L1.Data(end-3:end,1)',INFO_R1.Data(end-3:end,1)'])-2*std([INFO_L1.Data(end-3:end,1)',INFO_R1.Data(end-3:end,1)']);
else
   MIND=mean([INFO_L1.Data(1:3,1)',INFO_R1.Data(1:3,1)'])-2*std([INFO_L1.Data(1:3,1)',INFO_R1.Data(1:3,1)']);
   MAXD=mean([INFO_L1.Data(end-3:end,1)',INFO_R1.Data(end-3:end,1)'])+2*std([INFO_L1.Data(end-3:end,1)',INFO_R1.Data(end-3:end,1)']);
end 
%----------------------------
for i=1:1:width(Events_Time.Left_Foot_Off)
    FO=Events_Time.Left_Foot_Off(1,i);
    FS=Events_Time.Left_Foot_Strike(1,i);
    figure(123);hold on;
    patch('Faces',[1 2 3 4],'Vertices', [FO MIND;FO MAXD;FS MAXD;FS MIND], 'FaceColor','red','FaceAlpha',0.1,'EdgeColor','red','EdgeAlpha',0.1)
end
%----------------------------
for i=1:1:width(Events_Time.Right_Foot_Off)
    FO=Events_Time.Right_Foot_Off(1,i);
    FS=Events_Time.Right_Foot_Strike(1,i);
    figure(123);hold on;
    patch('Faces',[1 2 3 4],'Vertices', [FO MIND;FO MAXD;FS MAXD;FS MIND],  'FaceColor','blue','FaceAlpha',0.1,'EdgeColor','blue','EdgeAlpha',0.1)
end
%----------------------------
All_EV=[Events_Time.Left_Foot_Off , Events_Time.Right_Foot_Off, Events_Time.Left_Foot_Strike , Events_Time.Right_Foot_Strike];
All_EV=sort(All_EV,'ascend');
All_EV(:,1)=[];
All_EV(:,end)=[];
for i=1:1:floor(width(All_EV)/2)
    A=All_EV(1,i*2 -1);
    B=All_EV(1,i*2);
    figure(123);hold on;
    patch('Faces',[1 2 3 4],'Vertices', [A MIND;A MAXD;B MAXD;B MIND],  'FaceColor','black','FaceAlpha',0.05,'EdgeColor','black','EdgeAlpha',0.05)
end
%----------------------------
ylim([MIND MAXD])
MINT=min([INFO_L1.Time(1,1),INFO_R1.Time(1,1)])-0.5;
MAXT=max([INFO_L1.Time(end,1),INFO_R1.Time(end,1)])+0.5;
xlim([MINT,MAXT])
%----------------------------
if Setting.Direction=="Downward"
   figure(123);hold on;
   text((MINT+MAXT)/2,MAXD-0.2,'Blue Area: Right Foot in Swing','Color','blue');
   hold on;
   text((MINT+MAXT)/2,MAXD-0.45,'Red Area: Left Foot in Swing','Color','red');
   hold on;
   text((MINT+MAXT)/2,MAXD-0.7,'Gray Area: Double Support','Color',[0.25 0.25 0.25]);
else  
    figure(123);hold on;
    text((MINT+MAXT)/2,MIND+0.7,'Blue Area: Right Foot in Swing','Color','blue');
    hold on;
    text((MINT+MAXT)/2,MIND+0.45,'Red Area: Left Foot in Swing','Color','red');
    hold on;
    text((MINT+MAXT)/2,MIND+0.2,'Gray Area: Double Support','Color',[0.25 0.25 0.25]);
end

end