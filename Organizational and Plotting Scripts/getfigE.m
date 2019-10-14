function handles = getfigE(handles,i)
if handles.stimulatingE.Value
    switch handles.directions(i)
        case 1
            handles.figE = handles.larpelectrodes.Value(ismember(handles.larpelectrodes.Value,handles.allStim));
            handles.figdir = 'LARP';
            handles.pureRot = [1 0 0];
        case 2
            handles.figE = handles.ralpelectrodes.Value(ismember(handles.ralpelectrodes.Value,handles.allStim));
            handles.figdir = 'RALP';
            handles.pureRot = [0 1 0];
        case 3
            handles.figE = handles.lhrhelectrodes.Value(ismember(handles.lhrhelectrodes.Value,handles.allStim));
            handles.figdir = 'LHRH';
            handles.pureRot = [0 0 1];
    end
    handles.axName = 'Stim ';
    handles.ldgName = 'Return ';
elseif handles.referenceE.Value
    
    switch handles.directions(i)
        case 1
            if handles.bipolarstim.Value
            handles.figE = handles.larpelectrodes.Value(ismember(handles.larpelectrodes.Value,handles.allRef));
            end
            handles.figdir = 'LARP';
            handles.pureRot = [1 0 0];
        case 2
            if handles.bipolarstim.Value
            handles.figE = handles.ralpelectrodes.Value(ismember(handles.ralpelectrodes.Value,handles.allRef));
            end
            handles.figdir = 'RALP';
            handles.pureRot = [0 1 0];
        case 3
            if handles.bipolarstim.Value
            handles.figE = handles.lhrhelectrodes.Value(ismember(handles.lhrhelectrodes.Value,handles.allRef));
            end
            handles.figdir = 'LHRH';
            handles.pureRot = [0 0 1];
            end
    if handles.distantstim.Value
        handles.figE = [handles.figE handles.distant.Value];
    end
    if handles.ccstim.Value
        handles.figE = [handles.figE handles.commoncrus.Value];
    end
    handles.axName = 'Retunrn ';
    handles.ldgName = 'Stim ';
end
