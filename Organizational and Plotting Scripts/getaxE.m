function handles = getaxE(handles,i,j)
handles.axE = [];
handles.plottedInds = [];
if handles.stimulatingE.Value
    currfigE = handles.figE(j);
    curraxE = handles.allCombs(handles.allCombs(:,1)==currfigE,2);
    if handles.distantstim.Value
        handles.axE = [handles.axE handles.distant.Value(ismember(handles.distant.Value,curraxE))];
    end
    if handles.ccstim.Value
        handles.axE = [handles.axE handles.commoncrus.Value(ismember(handles.commoncrus.Value,curraxE))];
    end
    if handles.bipolarstim.Value
        switch handles.directions(i)
            case 1
                handles.axE = [handles.axE handles.larpelectrodes.Value(ismember(handles.larpelectrodes.Value,curraxE))];
            case 2
                handles.axE = [handles.axE handles.ralpelectrodes.Value(ismember(handles.ralpelectrodes.Value,curraxE))];
            case 3
                handles.axE = [handles.axE handles.lhrhelectrodes.Value(ismember(handles.lhrhelectrodes.Value,curraxE))];
        end
    end
    
elseif handles.referenceE.Value
    currfigE = handles.figE(j);
    curraxE = handles.allCombs(handles.allCombs(:,2)==currfigE,1);
    switch handles.directions(i)
        case 1
            handles.axE = [handles.axE handles.larpelectrodes.Value(ismember(handles.larpelectrodes.Value,curraxE))];
        case 2
            handles.axE = [handles.axE handles.ralpelectrodes.Value(ismember(handles.ralpelectrodes.Value,curraxE))];
        case 3
            handles.axE = [handles.axE handles.lhrhelectrodes.Value(ismember(handles.lhrhelectrodes.Value,curraxE))];
    end
end