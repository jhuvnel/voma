%%
% For GiGi
% path = 'R:\Morris, Brian\Papers\ECAP Paper\GiGi Data\ECAP Data\';
% name = 'GiGi Maestro 06-12-2019 13-29 - txt.mat'; %From 08-2016 to 12-2019
% name = 'Maestro Rhesus, GiGi - Exported 28-05-2020 14-01 - txt.mat' %From 04-2009 to 03-2015
% aLetter = 'G';

% % For DiDi
% path = 'R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\MAESTRO\';
% name = 'Maestro DiDi - Exported 03-06-2020 10-12 - txt.mat';
% aLetter = 'D';

% For Fred - Intra-Op Prerevision
% path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Intra-Op ECAP\';
% name = 'Maestro Rhesus 20100117, Fred -20200521-No ECAP Pre adjustment during surgery-txt.mat';
% aLetter = 'FPre';

% For Fred - Intra-Op Postrevision
 path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Intra-Op ECAP\';
 name = 'Maestro Rhesus 20100117, Fred -20200521-Good ECAP Post adjustment during surgery-txt.mat';
aLetter = 'FPost';

% For Fred - Post-Op Postrevision
% path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Post revision - Post surgery\';
% name = 'Maestro Rhesus 20100117, Fred - Post-revision 20200521 export - txt.mat';
% name = 'Maestro Rhesus, Fred - Post-revision 20200521 export - txt.mat';
% name = 'Maestro Rhesus,     Fred - Post-revision 20200521 export - txt.mat';
%aLetter = 'F';

load([path,name])
switch aLetter
    case 'G'
        add = [path,'GiGi'];
    case 'D'
        add = [path,'Didi'];
    case 'FPre'
        add = [path,'Fred20100117-Intra-op-Preadjustment-'];
    case 'FPost'
        add = [path,'Fred20100117-Intra-op-Postadjustment-'];
    case 'F'
        add = [path,'Fred-PostRevision-'];
end
%%
extractedData = struct();
extractedData.stim1ref2 = [];
extractedData.stim2ref1 = [];
extractedData.stim3ref2 = [];
extractedData.stim4ref5 = [];
extractedData.stim5ref4 = [];
extractedData.stim6ref5 = [];
extractedData.stim7ref8 = [];
extractedData.stim8ref7 = [];
extractedData.stim9ref8 = [];
combs = [1 2; 2 1; 3 2; 4 5; 5 4; 6 5; 7 8; 8 7; 9 8];
edFs = fields(extractedData);
for q = 1:length(edFs)
    extractedData.(edFs{q}).Animal = [];
    extractedData.(edFs{q}).Date = [];
    extractedData.(edFs{q}).Stim = [];
    extractedData.(edFs{q}).Ref = [];
    extractedData.(edFs{q}).Iterations = [];
    extractedData.(edFs{q}).Amp = [];
    extractedData.(edFs{q}).PhaseDuration = [];
    
    extractedData.(edFs{q}).ACX = [];
    extractedData.(edFs{q}).ACY = [];
    extractedData.(edFs{q}).ACzeroX = [];
    extractedData.(edFs{q}).ACzeroY = [];
    extractedData.(edFs{q}).ACNX = [];
    extractedData.(edFs{q}).ACNY = [];
    extractedData.(edFs{q}).ACNTrusted = [];
    extractedData.(edFs{q}).ACPX = [];
    extractedData.(edFs{q}).ACPY = [];
    extractedData.(edFs{q}).ACPTrusted = [];
    
    extractedData.(edFs{q}).CAX = [];
    extractedData.(edFs{q}).CAY = [];
    extractedData.(edFs{q}).CAzeroX = [];
    extractedData.(edFs{q}).CAzeroY = [];
    extractedData.(edFs{q}).CANX = [];
    extractedData.(edFs{q}).CANY = [];
    extractedData.(edFs{q}).CANTrusted = [];
    extractedData.(edFs{q}).CAPX = [];
    extractedData.(edFs{q}).CAPY = [];
    extractedData.(edFs{q}).CAPTrusted = [];
    
    extractedData.(edFs{q}).RawCalcX = [];
    extractedData.(edFs{q}).RawCalcY = [];
    extractedData.(edFs{q}).RawCalcNX = [];
    extractedData.(edFs{q}).RawCalcNY = [];
    extractedData.(edFs{q}).RawCalcPX = [];
    extractedData.(edFs{q}).RawCalcPY = [];
    extractedData.(edFs{q}).RawCalcECAP = [];
    extractedData.(edFs{q}).RawExtractNX = [];
    extractedData.(edFs{q}).RawExtractNY = [];
    extractedData.(edFs{q}).RawExtractNIND = [];
    extractedData.(edFs{q}).RawExtractPX = [];
    extractedData.(edFs{q}).RawExtractPY = [];
    extractedData.(edFs{q}).RawExtractPIND = [];
    extractedData.(edFs{q}).RawExtractECAP = [];
    extractedData.(edFs{q}).RawExtractECAPTrusted = [];
    
    extractedData.(edFs{q}).PX = [];
    extractedData.(edFs{q}).PY = [];
    extractedData.(edFs{q}).PzeroX = [];
    extractedData.(edFs{q}).PzeroY = [];
    extractedData.(edFs{q}).PNX = [];
    extractedData.(edFs{q}).PNY = [];
    extractedData.(edFs{q}).PNTrusted = [];
    extractedData.(edFs{q}).PPX = [];
    extractedData.(edFs{q}).PPY = [];
    extractedData.(edFs{q}).PPTrusted = [];
    
    extractedData.(edFs{q}).PCalcX = [];
    extractedData.(edFs{q}).PCalcY = [];
    extractedData.(edFs{q}).PCalcNX = [];
    extractedData.(edFs{q}).PCalcNY = [];
    extractedData.(edFs{q}).PCalcPX = [];
    extractedData.(edFs{q}).PCalcPY = [];
    extractedData.(edFs{q}).PCalcECAP = [];
    extractedData.(edFs{q}).PExtractNX = [];
    extractedData.(edFs{q}).PExtractNY = [];
    extractedData.(edFs{q}).PExtractNIND = [];
    extractedData.(edFs{q}).PExtractPX = [];
    extractedData.(edFs{q}).PExtractPY = [];
    extractedData.(edFs{q}).PExtractPIND = [];
    extractedData.(edFs{q}).PExtractECAP = [];
    extractedData.(edFs{q}).PExtractECAPTrusted = [];
    
    
    extractedData.(edFs{q}).ASlopeU = [];
    extractedData.(edFs{q}).ASlope = [];
    extractedData.(edFs{q}).AECAPX = [];
    extractedData.(edFs{q}).AECAPY = [];
    
end
%%
combs = [1 2; 2 1; 3 2; 4 5; 5 4; 6 5; 7 8; 8 7; 9 8];
edFs = fields(extractedData);
for h = 2%1:length(data.params)
    eCAPVal = h;
    if contains(data.params(eCAPVal).FunctionType,{'AmplitudeGrowth'})
        for i = 1:length(data.params(eCAPVal).Measurements.Data)
            
            currComb = [data.params(eCAPVal).Measurements.Data(i).StimulatingElectrode data.params(eCAPVal).Measurements.Data(i).RecordingElectrode];
            if any(ismember(combs(1,:),currComb,'rows'))%change back to do all
                ftu = edFs{ismember(combs,currComb,'rows')};
                id = length({extractedData.(ftu).Animal});
                if length(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve) == 10
                for j = 1:length(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve)
                    id = length(extractedData.(ftu));
                    if id == 1
                        if isempty(getfield(extractedData,ftu,{1},'Animal'))
                            id = 0;
                        end
                    end
                    if j == 1
                        pickedECAPRaw = struct();
                        pickedECAPRaw.d = {};
                        pickedECAPP = struct();
                        pickedECAPP.d = {};
                    end
                    extractedData = setfield(extractedData,ftu,{id+1},'Animal', data.params(1).FirstName);
                    extractedData = setfield(extractedData,ftu,{id+1},'Date',{data.params(eCAPVal).CreateDate});
                    extractedData = setfield(extractedData,ftu,{id+1},'Stim', currComb(1));
                    extractedData = setfield(extractedData,ftu,{id+1},'Ref', currComb(2));
                    extractedData = setfield(extractedData,ftu,{id+1},'Iterations', data.params(eCAPVal).Iterations.Value);
                    extractedData = setfield(extractedData,ftu,{id+1},'Amp', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).Amp);
                    extractedData = setfield(extractedData,ftu,{id+1},'PhaseDuration', data.params(eCAPVal).PhaseDuration.Value*10^6);
                    
                    ACX = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.X;
                    ACY = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).Y;
                    ACzeroX = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.Zerotemplates.X;
                    ACzeroY = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.Zerotemplate.Y;
                    ACNX = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).N.X;
                    ACNY = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).N.Y;
                    ACPX = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).P.X;
                    ACPY = data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).P.Y;
                    
                    CAX = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.X;
                    CAY = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).Y;
                    CAzeroX = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.Zerotemplates.X;
                    CAzeroY = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.Zerotemplate.Y;
                    CANX = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).N.X;
                    CANY = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).N.Y;
                    CAPX = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).P.X;
                    CAPY = data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).P.Y;
                    
                    extractedData = setfield(extractedData,ftu,{id+1},'ACX', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACY', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACzeroX', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.Zerotemplates.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACzeroY', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.Zerotemplate.Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACNX', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).N.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACNY', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).N.Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACNTrusted', contains(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).N.Trusted,'true'));
                    extractedData = setfield(extractedData,ftu,{id+1},'ACPX', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).P.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACPY', data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).P.Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'ACPTrusted', contains(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).P.Trusted,'true'));
                    
                    extractedData = setfield(extractedData,ftu,{id+1},'CAX', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'CAY', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'CAzeroX', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.Zerotemplates.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'CAzeroY', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.Zerotemplate.Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'CANX', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).N.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'CANY', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).N.Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'CANTrusted', contains(data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).N.Trusted,'true'));
                    extractedData = setfield(extractedData,ftu,{id+1},'CAPX', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).P.X);
                    extractedData = setfield(extractedData,ftu,{id+1},'CAPY', data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).P.Y);
                    extractedData = setfield(extractedData,ftu,{id+1},'CAPTrusted', contains(data.params(eCAPVal).Measurements.Data(i).RawData.CathodicAnodic.ArtCurves.ArtCurve(j).P.Trusted,'true'));
                    
                    extractedData = setfield(extractedData,ftu,{id+1},'RawCalcX', ACX);
                    extractedData = setfield(extractedData,ftu,{id+1},'RawCalcY', (ACY-ACzeroY+CAY-CAzeroY)/2);
                    %extractedData = setfield(extractedData,ftu,{id+1},'RawCalcNX', );
                    %extractedData = setfield(extractedData,ftu,{id+1},'RawCalcNY', );
                    %extractedData = setfield(extractedData,ftu,{id+1},'RawCalcPX', );
                    %extractedData = setfield(extractedData,ftu,{id+1},'RawCalcPY', );
                    %extractedData = setfield(extractedData,ftu,{id+1},'RawCalcECAP', );
%                     f = figure('WindowButtonDownFcn',@mouseDownCallback,'WindowKeyPressFcn', @confirmButton);
%                     handles = struct();
%                     handles.f = f;
%                     handles.f.Position = [1 41 1920 963];
%                     handles.addP = uicontrol('style','pushbutton','Callback',@(src,event) addPPoint(handles));
%                     handles.addP.FontSize = 15;
%                     handles.addP.String = 'Click (or click Z) to add a new Positive Point';
%                     handles.addP.Position = [20 20 400 50];
%                     handles.addN = uicontrol('style','pushbutton','Callback',@(src,event) addNPoint(handles));
%                     handles.addN.FontSize = 15;
%                     handles.addN.String = 'Click (or click X) to add a new Negative Point';
%                     handles.addN.Position = [20 910 400 50];
%                     handles.f.Name = [data.params(eCAPVal).CreateDate,...
%                         ', Stim: ',num2str(data.params(eCAPVal).StimulatingElectrode(i)),' Ref: ',num2str(data.params(eCAPVal).RecordingElectrode(i)),', ',...
%                         num2str(j),' of ',num2str(length(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve)),' Current Levels'];
%                     
%                     [handles.pPks handles.pLocs] = findpeaks((ACY-ACzeroY+CAY-CAzeroY)/2,ACX);
%                     [handles.nPks handles.nLocs] = findpeaks(-(ACY-ACzeroY+CAY-CAzeroY)/2,ACX);
%                     handles.pos = plot(ACX,(ACY-ACzeroY+CAY-CAzeroY)/2);
%                     handles.ax = handles.f.Children(3);
%                     handles.ax.Title.String = handles.f.Name;
%                     handles.trust = uicontrol('style','pushbutton','Callback',@(src,event) trust(handles));
%                     handles.trust.FontSize = 15;
%                     handles.trust.String = 'Trusted';
%                     handles.trust.Position = [5 500 150 50];
%                     handles.trust.BackgroundColor = 'g';
%                     hold on
%                     handles.nPks = handles.pos.YData(ismember(handles.pos.XData,handles.nLocs));
%                     %plot(ACX,-(ACY-ACzeroY+CAY-CAzeroY)/2)
%                     handles.pcolor = repmat([0 0.4470 0.7410],length(handles.pPks),1);
%                     handles.ncolor = repmat([0.8500 0.3250 0.0980],length(handles.nPks),1);
%                     handles.pPts = scatter(handles.pLocs,handles.pPks,50,handles.pcolor,'filled','v');
%                     handles.nPts = scatter(handles.nLocs,handles.nPks,50,handles.ncolor,'filled','v');
%                     handles.currNLine.YData = handles.ax.YLim;
%                     handles.currPLine.YData = handles.ax.YLim;
%                     handles.ax.FontSize = 20;
%                     handles.ax.XLabel.String = ['ECAP Value: ________ uV'];
%                     
%                     legend([handles.pPts,handles.nPts],{'Peak Points','Valley Points'})
%                     hold off
%                     handles.allData = uicontrol('style','listbox');
%                     handles.allData.Units = 'normalized';
%                     handles.allData.Position = [.91 .11 .09 .815];
%                     handles.allData.FontSize = 10;
%                     if ~isempty([pickedECAPRaw.d])
%                     handles.allData.String = [pickedECAPRaw.d];
%                     end
%                     guidata(handles.f,handles)
%                     uiwait
%                     handles = guidata(handles.f);
%                     pI = find(ismember(handles.pcolor,[0 1 0],'rows'));
%                     nI = find(ismember(handles.ncolor,[0 1 0],'rows'));
% 
% 
%                     extractedData = setfield(extractedData,ftu,{id+1},'RawExtractNX', handles.nPts.XData(nI));
%                     extractedData = setfield(extractedData,ftu,{id+1},'RawExtractNY', handles.nPts.YData(nI));
%                     extractedData = setfield(extractedData,ftu,{id+1},'RawExtractNIND', find([handles.pos.XData]==handles.nPts.XData(nI)));
%                     extractedData = setfield(extractedData,ftu,{id+1},'RawExtractPX', handles.pPts.XData(pI));
%                     extractedData = setfield(extractedData,ftu,{id+1},'RawExtractPY', handles.pPts.YData(pI));
%                     extractedData = setfield(extractedData,ftu,{id+1},'RawExtractPIND', find([handles.pos.XData]==handles.pPts.XData(pI)));
%                     if handles.ax.XLabel.UserData ~= handles.pPts.YData(pI)-handles.nPts.YData(nI)
%                         here = 1;
%                     end
%                     extractedData = setfield(extractedData,ftu,{id+1},'RawExtractECAP', handles.pPts.YData(pI)-handles.nPts.YData(nI));
%                     if ismember(handles.trust.BackgroundColor,[0 1 0],'rows')
%                          extractedData = setfield(extractedData,ftu,{id+1},'RawExtractECAPTrusted', 1);
%                     else
%                         extractedData = setfield(extractedData,ftu,{id+1},'RawExtractECAPTrusted', 0);
%                     end
%                     pickedECAPRaw(j).d = {[num2str(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).Amp),'uA ECAP: ',num2str((handles.pPts.YData(pI)-handles.nPts.YData(nI))*10^6)]};
%                     
%                     close(f)
                    
                    PX = data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.X;
                    PY = data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.ArtCurve(j).Y;
                    PzeroX = data.params(eCAPVal).Measurements.Data(i).ProcessedData.Zerotemplates.X;
                    PzeroY = data.params(eCAPVal).Measurements.Data(i).ProcessedData.Zerotemplate.Y;
                    PNX = data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.ArtCurve(j).N.X;
                    PNY = data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.ArtCurve(j).N.Y;
                    PNTrusted = contains(data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.ArtCurve(j).N.Trusted,'true');
                    PPX = data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.ArtCurve(j).P.X;
                    PPY = data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.ArtCurve(j).P.Y;
                    PPTrusted = contains(data.params(eCAPVal).Measurements.Data(i).ProcessedData.ArtCurves.ArtCurve(j).P.Trusted,'true');
                    
                    extractedData = setfield(extractedData,ftu,{id+1},'PX', PX);
                    extractedData = setfield(extractedData,ftu,{id+1},'PY', PY);
                    extractedData = setfield(extractedData,ftu,{id+1},'PzeroX', PzeroX);
                    extractedData = setfield(extractedData,ftu,{id+1},'PzeroY', PzeroY);
                    extractedData = setfield(extractedData,ftu,{id+1},'PNX', PNX);
                    extractedData = setfield(extractedData,ftu,{id+1},'PNY', PNY);
                    extractedData = setfield(extractedData,ftu,{id+1},'PNTrusted', PNTrusted);
                    extractedData = setfield(extractedData,ftu,{id+1},'PPX', PPX);
                    extractedData = setfield(extractedData,ftu,{id+1},'PPY', PPY);
                    extractedData = setfield(extractedData,ftu,{id+1},'PPTrusted', PPTrusted);
                    
%                     extractedData = setfield(extractedData,ftu,{id+1},'PCalcX', );
%                     extractedData = setfield(extractedData,ftu,{id+1},'PCalcY', );
                    
                    f = figure('WindowButtonDownFcn',@mouseDownCallback,'WindowKeyPressFcn', @confirmButton);
                    handles = struct();
                    handles.f = f;
                    handles.f.Position = [1 41 1920 963];
                    handles.addP = uicontrol('style','pushbutton','Callback',@(src,event) addPPoint(handles));
                    handles.addP.FontSize = 15;
                    handles.addP.String = 'Click (or click Z) to add a new Positive Point';
                    handles.addP.Position = [20 20 400 50];
                    handles.addN = uicontrol('style','pushbutton','Callback',@(src,event) addNPoint(handles));
                    handles.addN.FontSize = 15;
                    handles.addN.String = 'Click (or click X) to add a new Negative Point';
                    handles.addN.Position = [20 910 400 50];
                    handles.f.Name = [data.params(eCAPVal).CreateDate,...
                        ', Stim: ',num2str(data.params(eCAPVal).StimulatingElectrode(i)),' Ref: ',num2str(data.params(eCAPVal).RecordingElectrode(i)),', ',...
                        num2str(j),' of ',num2str(length(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve)),' Current Levels'];
                    
                    [handles.pPks handles.pLocs] = findpeaks((PY),PX);
                    [handles.nPks handles.nLocs] = findpeaks(-(PY),PX);
                    handles.pos = plot(PX,(PY));
                    handles.ax = handles.f.Children(3);
                    handles.ax.Title.String = handles.f.Name;
                    handles.trust = uicontrol('style','pushbutton','Callback',@(src,event) trust(handles));
                    handles.trust.FontSize = 15;
                    handles.trust.String = 'Trusted';
                    handles.trust.Position = [5 500 150 50];
                    handles.trust.BackgroundColor = 'g';
                    hold on
                    handles.nPks = handles.pos.YData(ismember(handles.pos.XData,handles.nLocs));
                    plot(PNX,PNY,'rv','MarkerSize',10)
                    handles.currNLine = plot([PNX PNX],[handles.ax.YLim(1) handles.ax.YLim(2)],'k','LineWidth',1.5);
                    plot(PPX,PPY,'rv','MarkerSize',10)
                    handles.currPLine = plot([PPX PPX],[handles.ax.YLim(1) handles.ax.YLim(2)],'k','LineWidth',1.5);
                    handles.pcolor = repmat([0 0.4470 0.7410],length(handles.pPks),1);
                    handles.ncolor = repmat([0.8500 0.3250 0.0980],length(handles.nPks),1);
                    handles.pPts = scatter(handles.pLocs,handles.pPks,50,handles.pcolor,'filled','v');
                    handles.nPts = scatter(handles.nLocs,handles.nPks,50,handles.ncolor,'filled','v');
                    handles.currNLine.YData = handles.ax.YLim;
                    handles.currPLine.YData = handles.ax.YLim;
                    handles.ax.FontSize = 20;
                    handles.ax.XLabel.String = ['ECAP Value: ________ uV'];
                    
                    legend([handles.pPts,handles.nPts],{'Peak Points','Valley Points'})
                    handles.allData = uicontrol('style','listbox');
                    handles.allData.Units = 'normalized';
                    handles.allData.Position = [.91 .11 .09 .815];
                    handles.allData.FontSize = 10;
                    if ~isempty([pickedECAPP.d])
                    handles.allData.String = [pickedECAPP.d];
                    end

                    hold off
                    guidata(handles.f,handles)
                    uiwait
                    handles = guidata(handles.f);
                    if ismember(handles.trust.BackgroundColor,[0 1 0],'rows')
                        pI = find(ismember(handles.pcolor,[0 1 0],'rows'));
                        nI = find(ismember(handles.ncolor,[0 1 0],'rows'));
                        
                        
                        %                     extractedData = setfield(extractedData,ftu,{id+1},'PCalcNX', );
                        %                     extractedData = setfield(extractedData,ftu,{id+1},'PCalcNY', );
                        %                     extractedData = setfield(extractedData,ftu,{id+1},'PCalcPX', );
                        %                     extractedData = setfield(extractedData,ftu,{id+1},'PCalcPY', );
                        extractedData = setfield(extractedData,ftu,{id+1},'PCalcECAP', PPY-PNY);
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractNX', handles.nPts.XData(nI));
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractNY', handles.nPts.YData(nI));
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractNIND', find([handles.pos.XData]==handles.nPts.XData(nI)));
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractPX', handles.pPts.XData(pI));
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractPY', handles.pPts.YData(pI));
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractPIND', find([handles.pos.XData]==handles.pPts.XData(pI)));
                        if handles.ax.XLabel.UserData ~= handles.pPts.YData(pI)-handles.nPts.YData(nI)
                            here = 1;
                        end
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractECAP', handles.pPts.YData(pI)-handles.nPts.YData(nI));
                        if ismember(handles.trust.BackgroundColor,[0 1 0],'rows')
                            extractedData = setfield(extractedData,ftu,{id+1},'PExtractECAPTrusted', 1);
                        else
                            extractedData = setfield(extractedData,ftu,{id+1},'PExtractECAPTrusted', 0);
                        end
                        pickedECAPP(j).d = {[num2str(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).Amp),'uA ECAP: ',num2str((handles.pPts.YData(pI)-handles.nPts.YData(nI))*10^6)]};
                    else
                        extractedData = setfield(extractedData,ftu,{id+1},'PCalcECAP', PPY-PNY);
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractECAP', NaN);
                        
                        extractedData = setfield(extractedData,ftu,{id+1},'PExtractECAPTrusted', 0);
                        
                        pickedECAPP(j).d = {[num2str(data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).Amp),'uA ECAP: NaN']};
                    end
                    close(f)
                    
                    extractedData = setfield(extractedData,ftu,{id+1},'ASlopeU', data.params(eCAPVal).Measurements.Data(i).Analysis.AmplitudeGrowthFunction.SlopeUnit);
                    extractedData = setfield(extractedData,ftu,{id+1},'ASlope', data.params(eCAPVal).Measurements.Data(i).Analysis.AmplitudeGrowthFunction.SlopeValue);
                    if data.params(eCAPVal).Measurements.Data(i).Analysis.AmplitudeGrowthFunction.DataPoints.Count > 0
                    toUse = find([data.params(eCAPVal).Measurements.Data(i).Analysis.AmplitudeGrowthFunction.DataPoints.X] == data.params(eCAPVal).Measurements.Data(i).RawData.AnodicCathodic.ArtCurves.ArtCurve(j).Amp);
                    if ~isempty(toUse)
                        extractedData = setfield(extractedData,ftu,{id+1},'AECAPX', data.params(eCAPVal).Measurements.Data(i).Analysis.AmplitudeGrowthFunction.DataPoints.X(toUse));
                        extractedData = setfield(extractedData,ftu,{id+1},'AECAPY', data.params(eCAPVal).Measurements.Data(i).Analysis.AmplitudeGrowthFunction.DataPoints.Y(toUse));
                    end
                    end
                end
                end
            end
            
        end
    end
    save([add,'CondensedECAPData.mat'],'extractedData')
end

function mouseDownCallback(figHandle,varargin)
% get the handles structure
handles = guidata(figHandle);
handles.f.Units = 'normalized';
% get the position where the mouse button was pressed (not released)
% within the GUI
if contains(figHandle.SelectionType,'normal')
    
    currentPoint = get(figHandle, 'CurrentPoint');
    x            = currentPoint(1,1);
    y            = currentPoint(1,2);
    % get the position of the axes within the GUI
    axesPos = get(handles.ax,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    % is the mouse down event within the axes?
    if x>=minx && x<=maxx && y>=miny && y<=maxy
        % do we have graphics objects?
            % get the position of the mouse down event within the axes
            currentPoint = get(handles.ax, 'CurrentPoint');
            x            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            
            %handles.pcolor = [0 0.4470 0.7410]
            %handles.ncolor = [0.8500 0.3250 0.0980]
            if all(handles.addP.BackgroundColor == [1 1 0])
                xDataP = handles.pos.XData;
                yDataP = handles.pos.YData;
                [distP, indP]  = min((xDataP-x).^2+(yDataP-y).^2);
                handles.pPts.XData = [handles.pPts.XData xDataP(indP)];
                handles.pPts.YData = [handles.pPts.YData yDataP(indP)];
                if ~any(ismember(handles.pcolor,[0 1 0],'row'))
                        handles.pcolor = [handles.pcolor; [0 1 0]];
                        handles.pPts.CData = handles.pcolor;
                else
                    handles.pcolor = [handles.pcolor;[0 0.4470 0.7410]];
                    handles.pPts.CData = handles.pcolor;
                end
            elseif all(handles.addN.BackgroundColor == [1 1 0])
                xDataN = handles.pos.XData;
                yDataN = handles.pos.YData;
                [distN, indN]  = min((xDataN-x).^2+(yDataN-y).^2);
                handles.nPts.XData = [handles.nPts.XData xDataN(indN)];
                handles.nPts.YData = [handles.nPts.YData yDataN(indN)];
                if ~any(ismember(handles.ncolor,[0 1 0],'row'))
                        handles.ncolor = [handles.ncolor; [0 1 0]];
                        handles.nPts.CData = handles.ncolor;
                else
                    handles.ncolor = [handles.ncolor; [0.8500 0.3250 0.0980]];
                        handles.nPts.CData = handles.ncolor;
                end
            else
                xDataP = handles.pPts.XData;
                yDataP = handles.pPts.YData;
                [distP, indP]  = min((xDataP-x).^2+(yDataP-y).^2);
                xDataN = handles.nPts.XData;
                yDataN = handles.nPts.YData;
                [distN, indN]  = min((xDataN-x).^2+(yDataN-y).^2);
                if distP<distN
                    if ~any(ismember(handles.pcolor,[0 1 0],'row'))
                        handles.pcolor(indP,:) = [0 1 0];
                        handles.pPts.CData = handles.pcolor;
                    end
                else
                    if ~any(ismember(handles.ncolor,[0 1 0],'row'))
                        handles.ncolor(indN,:) = [0 1 0];
                        handles.nPts.CData = handles.ncolor;
                    end
                end
            end
            guidata(figHandle,handles);
    end
elseif contains(figHandle.SelectionType,'extend')
    guidata(figHandle,handles);
    uiresume
elseif contains(figHandle.SelectionType,'alt')
    currentPoint = get(figHandle, 'CurrentPoint');
    x            = currentPoint(1,1);
    y            = currentPoint(1,2);
    % get the position of the axes within the GUI
    axesPos = get(handles.ax,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    % is the mouse down event within the axes?
    if x>=minx && x<=maxx && y>=miny && y<=maxy
        % do we have graphics objects?
            % get the position of the mouse down event within the axes
            currentPoint = get(handles.ax, 'CurrentPoint');
            x            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            
                xDataP = handles.pPts.XData;
                yDataP = handles.pPts.YData;
                [distP, indP]  = min((xDataP-x).^2+(yDataP-y).^2);
                xDataN = handles.nPts.XData;
                yDataN = handles.nPts.YData;
                [distN, indN]  = min((xDataN-x).^2+(yDataN-y).^2);
                if distP<distN
                    if all(handles.pcolor(indP,:)==[0 1 0])
                        handles.pcolor(indP,:) = [0    0.4470    0.7410];
                        handles.pPts.CData = handles.pcolor;
                    end
                else
                    if all(handles.ncolor(indN,:)==[0 1 0])
                        handles.ncolor(indN,:) = [0.8500    0.3250    0.0980];
                        handles.nPts.CData = handles.ncolor;
                    end
                end
                guidata(figHandle,handles);
    end
    guidata(figHandle,handles);
end
if any(ismember(handles.pcolor,[0 1 0],'rows')) && any(ismember(handles.ncolor,[0 1 0],'rows'))
    pI = find(ismember(handles.pcolor,[0 1 0],'rows'));
    nI = find(ismember(handles.ncolor,[0 1 0],'rows'));
    ecap = handles.pPts.YData(pI)-handles.nPts.YData(nI);
    handles.ax.XLabel.UserData = ecap;
    handles.ax.XLabel.String = ['ECAP Value: ',num2str(ecap*10^6),'uV'];
end

end

function confirmButton(figHandle,varargin)
handles = guidata(figHandle);
if contains(varargin{1}.Key,'z')
    if all(handles.addN.BackgroundColor == [0.94 0.94 0.94])
        if all(handles.addP.BackgroundColor == [0.94 0.94 0.94])
            handles.addP.BackgroundColor = 'y';
        else
            handles.addP.BackgroundColor = [0.94 0.94 0.94];
        end
    end
    guidata(figHandle,handles);
elseif contains(varargin{1}.Key,'x')
    if all(handles.addP.BackgroundColor == [0.94 0.94 0.94])
        if all(handles.addN.BackgroundColor == [0.94 0.94 0.94])
            handles.addN.BackgroundColor = 'y';
        else
            handles.addN.BackgroundColor = [0.94 0.94 0.94];
        end
    end
    guidata(figHandle,handles);
elseif contains(varargin{1}.Key,'t')
    if all(handles.trust.BackgroundColor == [0 1 0])
        handles.trust.BackgroundColor = [1 0 0];
        handles.trust.String = 'Not Trusted';
            guidata(figHandle,handles);
    uiresume
    else
        handles.trust.BackgroundColor = [0 1 0];
        handles.trust.String = 'Trusted';
    
    end
guidata(figHandle,handles);
end
end

function addPPoint(handles)
handles = guidata(handles.f);
if all(handles.addN.BackgroundColor == [0.94 0.94 0.94])
    if all(handles.addP.BackgroundColor == [0.94 0.94 0.94])
        handles.addP.BackgroundColor = 'y';
    else
        handles.addP.BackgroundColor = [0.94 0.94 0.94];
    end
end
guidata(handles.f,handles);
end

function addNPoint(handles)
handles = guidata(handles.f);
if all(handles.addP.BackgroundColor == [0.94 0.94 0.94])
    if all(handles.addN.BackgroundColor == [0.94 0.94 0.94])
        handles.addN.BackgroundColor = 'y';
    else
        handles.addN.BackgroundColor = [0.94 0.94 0.94];
    end
end
guidata(handles.f,handles);
end

function trust(handles)
handles = guidata(handles.f);
if all(handles.trust.BackgroundColor == [0 1 0])
    handles.trust.BackgroundColor = [1 0 0];
    handles.trust.String = 'Not Trusted';
        guidata(figHandle,handles);
    uiresume
else
    handles.trust.BackgroundColor = [0 1 0];
    handles.trust.String = 'Trusted';
    
end
guidata(handles.f,handles);
end