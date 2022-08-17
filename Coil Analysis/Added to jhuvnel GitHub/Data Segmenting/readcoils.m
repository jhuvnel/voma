function coils = readcoils(directory, coilfile, chinchDate)

%{
Code to read in coil file using directory and file name

INPUT:
  directory - path to the location of the coil file
  coilfile - the name '.coil' of the file you are trying to open
  chinchData - the status of check box whether the date of chinch data
    collected was after 10/19/2016 since we added two columns for prosthesis
    sync signal, thus actual eye coil data columns are shifted.

OUTPUT:
  coils - matrix containing eye coil data as follows:

FOR BEFORE 10/19 and MONKEY SYSTEM
 Column 1:  FPGA Counter
 Column 2: Queue Index - mainly for debugging
 Column 3: SYNC bit
 Column 4:  Ch1 X
 Column 5:  Ch1 Y
 Column 6:  Ch1 Z
 Column 7:  Ch2 X
 Column 8:  Ch2 Y
 Column 9:  Ch2 Z
 Column 10: Ch3 X
 Column 11: Ch3 Y
 Column 12: Ch3 Z
 Column 13: Ch4 X
 Column 14: Ch4 Y
 Column 15: Ch4 Z


FOR AFTER 10/19 CHINCH DATA
 Column 1:  FPGA Counter (current sample number)
 Column 2: Queue Index (showall sample queue number (mostly for debugging showall)
 Column 3: SYNC bit
 Column 4: (NEW) Timestamp sample number
 Column 5: (NEW) Timestamp sub-sample counter
 Column 6-17:  XYZ for all 4 coils
%}

f2=fopen(char(strcat(directory,coilfile)), 'rb');



if f2 == -1
    coils = [];
else
    if (chinchDate==1) %this means the coil system update adding sync pulses was added so column length is now 17 not 15
        coils=fread(f2,[17,inf],'int32')';
    else %format from before and for monkey data
        coils=fread(f2,[15,inf],'int32')';
    end
    
    fclose(f2);
    coils = coils((1:length(coils)-2),:);
end


end