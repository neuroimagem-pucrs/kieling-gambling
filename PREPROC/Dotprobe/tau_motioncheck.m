function tau_motioncheck(subj, mm)

%Example: tau_motioncheck('s16', 3)
%Creates .1D file with indexes that would be censored if using these limits (0=censored, 1=included)
%Creates file to indicate how many indexes outside bounds

nruns=2;
motionmax=mm;
totalnumcens=0;

outdir = '/raid4/sdanny/workingdata/tau/';

for run=1:nruns
subfile=strcat(outdir, '/subjects/', subj, '/afni/3dmotion', num2str(run), '.1D');

[index, roll, pitch, yaw, zdir, xdir, ydir, dummy1, dummy2] = textread (subfile, '%d %f %f %f %f %f %f %f %f', -1);

numcens=0;
for i=1:size(index,1)
    if abs(roll(i)) > motionmax; 
		censvec(i)=0;
		numcens=numcens+1;
    elseif abs(pitch(i)) > motionmax; 
		censvec(i)=0;
		numcens=numcens+1;
    elseif abs(yaw(i)) > motionmax; 
		censvec(i)=0;
		numcens=numcens+1;
    elseif abs(zdir(i)) > motionmax; 
		censvec(i)=0;
		numcens=numcens+1;
    elseif abs(xdir(i)) > motionmax; 
		censvec(i)=0;
		numcens=numcens+1;
    elseif abs(ydir(i)) > motionmax; 
		censvec(i)=0;
		numcens=numcens+1;
    else 
    	censvec(i)=1; 
    end
end

sprintf('Subject: %s, Run: %d, The number of censored indexes: %d', subj, run, numcens)
totalnumcens=totalnumcens+numcens;
runnumcens(run)=numcens; 

end %end runloop

censvec=censvec';

sprintf('Subject: %s, The total number of censored indexes: %d', subj, totalnumcens)

%find runonset 


 outfile=strcat(outdir, '/subjects/', subj, '/afni/motion_indexes.1D');
 dlmwrite (outfile, censvec, 'delimiter', ' ');
 
 txt=sprintf('Subject: %s, The number of indexes that would be censored: %d using %d (mm or degrees) motion criteria', subj, numcens, motionmax);
 txt2=sprintf('%d\n', runnumcens); 
  outfile=strcat(outdir, '/subjects/', subj, '/afni/motioncheck.1D');
  fid=fopen(outfile,'wt');
  fwrite(fid, char(txt), 'char');
  fwrite(fid, char(txt2), 'char');
  fclose(fid);

%clear censvec numcens




				

