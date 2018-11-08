DIO = digitalio('nidaq', 'Dev1'); % create digital IO object
addline(DIO, 0:3, 0, 'in');
%addline(DIO, 0:7, 'out')
val = getvalue(DIO)
%delete(DIO)