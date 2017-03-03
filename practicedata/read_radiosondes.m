function read_radiosondes(outdir)

% Script to read in radiosonde data files from 
% ftp://ftp.ncdc.noaa.gov/pub/data/igra/data-derived-v2/data-por
% 
% Inputs
% indir = string containing folder directory path containing .dat files
% yearstart = first year of data to save
% yearstop = last year of data to save

indir = '/nfs/a161/earceb/students/Ailish/radiosondes/IGRA_derived_dat';
yearstart = 1998;
yearstop = 2014;

%
% Outputs
% outdir = string containing folder directory path to save .mat files
%
% Instructions
%
% 1. Run read_radiosonde_station_locations.m on a .txt file containing sonde
% station locations
%
% 2. Save .dat files for all stations of interest into a folder (indir)
%
% 3. In outdir create a folder for each sonde station, named by the sonde
% ID's
%
% 4. Run this script as
% read_radiosondes('/folder_path/output_folder')
% This will convert the .dat text files (one per station) into .mat files 
% for each individual sonde, one folder for each sonde station
%
% 5. Then run join_radiosondes.m to concatenate the .mat files into one .mat data structure per
% sonde station and interpolate the data onto a standard set of pressure levels
% 
% CEB Oct 2015

% Create data structure containing .dat file names
filenames = dir([indir,'/*.dat']);

for ff=1:length(filenames) % For each file name (i.e. sonde station)
    
  % Open file
  fd = fopen([indir,'/',filenames(ff).name]);  
  if fd<0
    error('Could not open file'); % Error check
  end

  stationID = filenames(ff).name(1:5);
  disp(['Reading station ID: ',stationID])

  % Locate first sonde in yearstart and when located move into next 
  % loop to read data 
  alldone1 = 0;
  while alldone1==0 
    nextline=fgetl(fd); % Read in first line of data
    if nextline(7:10)==num2str(yearstart)
      alldone1=1;
    end
  end  
  
  alldone = 0;
  while alldone==0 
    
    % Read single level variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Get time stamp
    year = str2num(nextline(7:10));
    month = str2num(nextline(11:12));
    day = str2num(nextline(13:14));
    hour = str2num(nextline(15:16));
    
    RS_data.time = datenum([year month day hour 0 0]);

    % Get derived single level values
    RS_data.numlev = str2num(nextline(21:24));
    RS_data.pw = str2num(nextline(25:30));
    RS_data.invpress = str2num(nextline(31:36));
    RS_data.invhgt = str2num(nextline(37:42));
    RS_data.invtempdif = str2num(nextline(43:48));
    RS_data.mixpress = str2num(nextline(49:54));   
    RS_data.mixhgt = str2num(nextline(55:60));
    RS_data.frzpress = str2num(nextline(61:66));
    RS_data.frzhgt = str2num(nextline(67:72));
    RS_data.lclpress = str2num(nextline(73:78));
    RS_data.lclhgt = str2num(nextline(79:84));
    RS_data.lfcpress = str2num(nextline(85:90));
    RS_data.lfchgt = str2num(nextline(91:96));
    RS_data.lnbpress = str2num(nextline(97:102));    
    RS_data.lnbhgt = str2num(nextline(103:108));
    RS_data.li = str2num(nextline(109:114));     
    RS_data.si = str2num(nextline(115:120));
    RS_data.ki = str2num(nextline(121:126));
    RS_data.tti = str2num(nextline(127:132));
    RS_data.cape = str2num(nextline(133:138));
    RS_data.cin = str2num(nextline(139:144));  
  
    % Change -9999 values to NaN
    RS_fieldnames = fieldnames(RS_data);
    for nn=3:length(RS_fieldnames) % (1 and 2 are time and number of levels)
      ii = find(RS_data.(RS_fieldnames{nn})<-9999); 
      RS_data.(RS_fieldnames{nn})(ii) = NaN;  
    end    

    % Sort out units
    RS_data.pw = RS_data.pw./100;
    RS_data.invpress = RS_data.invpress./100;    
    RS_data.invtempdif = RS_data.invtempdif./10; 
    RS_data.mixpress = RS_data.mixpress./100; 
    RS_data.frzpress = RS_data.frzpress./100;  
    RS_data.lclpress = RS_data.lclpress./100;  
    RS_data.lfcpress = RS_data.lfcpress./100; 
    RS_data.lnbpress = RS_data.lnbpress./100;     

    
    % Read multi-level variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Intialise variables multilevel variables
    no_recs = RS_data.numlev; % Work out how big variables will be
    
    RS_data.press = zeros(no_recs,1);
    RS_data.obsgph = zeros(no_recs,1);
    RS_data.calcgph = zeros(no_recs,1);
    RS_data.temp = zeros(no_recs,1);
    RS_data.tempgrad = zeros(no_recs,1);
    RS_data.ptemp = zeros(no_recs,1);
    RS_data.ptempgrad = zeros(no_recs,1);
    RS_data.vtemp = zeros(no_recs,1);
    RS_data.vptemp = zeros(no_recs,1);
    RS_data.vappress = zeros(no_recs,1);
    RS_data.satvap = zeros(no_recs,1);
    RS_data.rh = zeros(no_recs,1);   
    RS_data.rhgrad = zeros(no_recs,1); 
    RS_data.U = zeros(no_recs,1);
    RS_data.Ugrad = zeros(no_recs,1);
    RS_data.V = zeros(no_recs,1);
    RS_data.Vgrad = zeros(no_recs,1);   
    RS_data.n = zeros(no_recs,1);     
    
    % Read in data line by line
    for rr=1:no_recs
      nextline = fgetl(fd);
    
      RS_data.press(rr) = str2num(nextline(1:7));
      RS_data.obsgph(rr) = str2num(nextline(9:15));
      RS_data.calcgph(rr) = str2num(nextline(17:23));
      RS_data.temp(rr) = str2num(nextline(25:31));
      RS_data.tempgrad(rr) = str2num(nextline(33:39));
      RS_data.ptemp(rr) = str2num(nextline(41:47));
      RS_data.ptempgrad(rr) = str2num(nextline(49:55));
      RS_data.vtemp(rr) = str2num(nextline(57:63));
      RS_data.vptemp(rr) = str2num(nextline(65:71));
      RS_data.vappress(rr) = str2num(nextline(73:79));
      RS_data.satvap(rr) = str2num(nextline(81:87));
      RS_data.rh(rr) = str2num(nextline(89:95));
      RS_data.rhgrad(rr) = str2num(nextline(97:103));
      RS_data.U(rr) = str2num(nextline(105:111));
      RS_data.Ugrad(rr) = str2num(nextline(113:119));
      RS_data.V(rr) = str2num(nextline(121:127));
      RS_data.Vgrad(rr) = str2num(nextline(129:135));
      RS_data.n(rr) = str2num(nextline(137:143));
    end
  
    % Change -9999 values to NaNs
    RS_fieldnames = fieldnames(RS_data);
    for nn=23:length(RS_fieldnames) % (1 and 2 are time and number of levels)
      ii = find(RS_data.(RS_fieldnames{nn})<-9999); 
      RS_data.(RS_fieldnames{nn})(ii) = NaN;  
    end 
  
    % Sort out units 
    RS_data.press = RS_data.press./100;
    RS_data.temp = RS_data.temp./10;
    RS_data.tempgrad = RS_data.tempgrad./10;
    RS_data.ptemp = RS_data.ptemp./10;
    RS_data.ptempgrad = RS_data.ptempgrad./10;
    RS_data.vtemp = RS_data.vtemp./10;
    RS_data.vptemp = RS_data.vptemp./10;
    RS_data.vappress = RS_data.vappress./1000;    
    RS_data.satvap = RS_data.satvap./1000; 
    RS_data.rh = RS_data.rh./10;   
    RS_data.rhgrad = RS_data.rhgrad./10;
    RS_data.U = RS_data.U./10;
    RS_data.Ugrad = RS_data.Ugrad./10;
    RS_data.V = RS_data.V./10;
    RS_data.Vgrad = RS_data.Vgrad./10;    

    % Make a plot to check data looks correct
    %figure
    %plot(RS_data.temp,RS_data.press,'b-x'); set(gca,'YDir','reverse')
    %pause
    %close
  
    % Save data 
    savelist = ['RS_data'];
    filename = [stationID,'_RS_',datestr(RS_data.time,30),'.mat'];
    eval(['save ',[outdir,'/',stationID],'/',filename,' ',savelist]);
    
    % Read in the first line of the next sonde and if it is of a year after
    % yearstop, exit script
    nextline = fgetl(fd);
    if str2num(nextline(7:10))>yearstop
      alldone=1;
    end 
  
  end
end



