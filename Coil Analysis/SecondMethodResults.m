function handles = SecondMethodResults(handles)
a = struct();
a = handles;
a.toUseLELARP = handles.corLELARPT;
a.toUseLERALP = handles.corLERALPT;
a.toUseLEZ = handles.corLEZT;
a.toUseLEX = handles.corLEXT;
a.toUseLEY = handles.corLEYT;
a.toUseRELARP = handles.corRELARPT;
a.toUseRERALP = handles.corRERALPT;
a.toUseREZ = handles.corREZT;
a.toUseREX = handles.corREXT;
a.toUseREY = handles.corREYT;
if contains(handles.vomaFile,'LARP')
    handles.pureRot = [1 0 0];
    handles.stimCanal = 1;
elseif contains(handles.vomaFile,'RALP')
    handles.pureRot = [0 1 0];
    handles.stimCanal = 2';
elseif contains(handles.vomaFile,'LHRH')
    handles.pureRot = [0 0 1];
    handles.stimCanal = 3;
end
if handles.LEye.Value
    a = MagThreshL(a,[]);
    handles.Results.SecondM.pullIndsL = a.segment(handles.segNum).pullIndsL;
    handles.Results.SecondM.maxMagL = a.segment(handles.segNum).maxMagL;
    handles.Results.SecondM.MisalignL = a.segment(handles.segNum).MisalignL;
    handles.Results.SecondM.Misalign3DL = a.segment(handles.segNum).Misalign3DL;
end
if handles.REye.Value
    a = MagThreshR(a,[]);
     handles.Results.SecondM.pullIndsR = a.segment(handles.segNum).pullIndsR;
    handles.Results.SecondM.maxMagR =  a.segment(handles.segNum).maxMagR;
    handles.Results.SecondM.MisalignR = a.segment(handles.segNum).MisalignR;
    handles.Results.SecondM.Misalign3DR = a.segment(handles.segNum).Misalign3DR;
end
   