%hvlab - issue 1.2 (30/07/10) - HVLab HRV Toolbox
%------------------------------------------------
%[] = hvlab()
%  Initialises the HRV toolbox by creating the global parameter structure 
%  HV. The values of the individual parameters are read from the parameter
%  file 'hvdefault.pas', if it exists, or initialised to default values if
%  the file does not exist
%--------------------------------------------------------------------------
%HRV TOOLBOX FUNCTIONS
%--------------------------------------------------------------------------
%DATA DISPLAY & VISUALISATION	
% hvgraph        graphical display of all channels in a workspace data structure array  
% hvlist         list details of data structure
% hvstats        sdev, r.m.s. average, maximum & minimum values
% hvxstats       sampling increment, origin & length of a data set
%-------------------------------------------------------------------------
%SIGNAL PROCESSING & ANALYSIS	
% hvcsd          CSD of two time histories
% hvdifferentiate differential of time history data
% hvdifferential single or double trapezoidal differentiator for time history data
% hvfilter       band-pass and zero-phase filters
% hvhibessel	 high pass Bessel (approximately linear phase) filter
% hvhibutter	 high pass Butterworth filter 
% hvintegral	 single or double integral of time history data
% hvintegrate	 cumulative integration (area under a curve), VDV, MSDV
% hvlobessel	 low pass Bessel (approximately linear phase) filter
% hvlobessel	 low pass Butterworth filter
% hvoct3spectrum third octave spectrum (r.m.s. within pass bands)
% hvpsd          PSD of time history data
% hvrunaverage   running average of successive points using a rectangular window
% hvrunrms       exponential running r.m.s. average & maximum transient value 
% hvstiffness    dynamic stiffness from indenter test data
% hvtransfer	 transfer function & coherency between two time histories
% hvwtgfilter	 filter by a combination of real or complex poles and zeroes
%--------------------------------------------------------------------------
%INPUT/OUTPUT	
% hvcalibrate    display calibration graphic interface
% hvcreate       creates a workspace data structure array from data in a MATLAB array
% hvdata         analogue data input and/or output using data structures
% hvdatawin      analogue data input and/or output using data files
% hvexport       export data to ascii (.CSV) & HVLab_DOS (.DAT) files
% hvexportsef	 export data to SERVOTEST (.SEF) data files
% hvimportdat	 import data from HVLab_DOS (.DAT) files
% hvimportsef	 import data from SERVOTEST (.SEF) data files
% hvimportwdc	 import data from DATAQ (.WDC) logger files
% hvread         read a multi-channel data file into a workspace data structure
% hvparameters   display and modify global parameters in a graphic interface
% hvwrite        writes a workspace data structure array to a multi-channel data file
%--------------------------------------------------------------------------
%SIGNAL GENERATION	
% hvrandom       generate a random time history
% hvsine         generate a sinusoidal time history
% hvsweep        generate a swept-sinusoidal time history (chirp)
% hvtransient    generate a transient sinusoidal test signal
% hvtestsignal	 generate test signals specified in seat & glove testing standards
% hvtestspectrum generate target PSD of test signals in seat & glove testing standards
%--------------------------------------------------------------------------
%EVALUATION VIBRATION ACORDING TO HRV STANDARDS	
% hvstats        return SD, r.m.s. average, maximum & minimum values
% hvdose         return VDV, MSDV or A(8) of an acceleration time history
% hvweight       filter a time history by a specified weighting function
% hvweighting	 generate standard frequency weighting function
% hvleq          equivalent continuous A or C weighted sound level
%--------------------------------------------------------------------------
%UTILITY & ARITHMETIC FUNCTIONS	
% hvaverage      performs averaging (mean, sdev, etc.) across several data structures
% hvcmplxtoreal	 split real & imaginary or modulus & phase parts of a data set into two separate data structures
% hvdiv          computes the quotient between two workspace data structures and/or constants
% hvextract      copy part of a data set to a new data structure
% hvinterpolate	 change the x-axis increment of a data set using linear interpolation
% hvpad          add zeroes to the beginning and/or end of a data set
% hvmerge        merge two or more data sets end-to-end
% hvmodphase	 convert complex data to modulus and phase format
% hvnormalise	 normalise data with respect to the mean or standard deviation
% hvpower        raise a data set to an arbitrary power
% hvprod         compute the product of two or more workspace data structures &/or constants
% hvrealtocmplx	 combine 2 data sets into real & imaginary or modulus & phase parts of a new data structure
% hvresample	 change the sampling increment of a time-history using zero-phase filtering & linear interpolation
% hvrunaverage 	 running average (mean, rms, etc) of successive points in a data set (with rectangular or exponential window)
% hvsub          compute the difference between two workspace data structures &/or constants
% hvsum          compute the sum of two or more workspace data structures &/or constants
% hvtaper        apply a cosine taper to the ends of a time history
%--------------------------------------------------------------------------
%GLOBAL PARAMETERS & INITIALISATION	
% hvlab          initialise the Human Response to Vibration toolbox
% hvgetpars      restore values of all global parameters from a parameter file
% hvsavepars	 save current values of all global parameters to a parameter file
%

% modified by TPG 29/7/2004 to add reference to HV.INCHANNEL(16).VOLTAGE
% modified CHL 02/02/2009 to bring HELP in line with technical manual
% modified CHL 27/01/2010 to display toolbox version no. 
% modified CHL 30/07/2010 to include new functions in header. 

global HV;
global HVKEY;

fprintf(1, '\n%s', '======================================================') 
fprintf(1, '\n%s', ' HVLab HUMAN RESPONSE TO VIBRATION TOOLBOX for MATLAB') 
fprintf(1, '\n%s', '       (c)2009, Human Factors Research Unit') 
fprintf(1, '\n%s', '     Institute of Sound & Vibration Research') 
fprintf(1, '\n%s', '          University of Southampton, U.K.')
fprintf(1, '\n%s', '======================================================') 
%fprintf(1, '\n%s')
fprintf(1, '\n%s', 'Version Number: 1.0');
%hvkey('hvlab.key');       % Loads the authorisation key file and checks the expiry data of the user license 
fprintf(1, '\n%s');
hvgetpars('hvdefault',1); % Loads parameter values from file 'hvdefault.pas', if it exists, or default values if the file does not exist.
