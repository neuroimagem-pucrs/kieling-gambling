function tau_outlier_onsetvectors(subj,visit)

%JB 7/1/14 correction is needed to calculate the overall RT score. It appears that the vector carrying the rt values was not zeroed out before moving onto the other conditions. See proposed correction below.

%Example: tau_outlier_onsetvectors('s16',1)

outdir = '/raid4/sdanny/workingdata/tau/behav_data/'
nruns=2;

command1=sprintf('rm ../behav_data/onsets/%s_visit%d*', subj, visit);
unix (command1);
command1=sprintf('rm ../behav_data/rt/%s_visit%d*', subj, visit);
unix (command1);
command1=sprintf('rm ../behav_data/summary/%s_visit%d*', subj, visit);
unix (command1);

%
subfile=strcat(outdir, 'orig/', subj, '_tau_visit', num2str(visit),'.dat');

[sdan, session, set, run, scanonset, trial, trialtype, faceonset, prbacc, prbrt] = textread(subfile, '%d %d %s %d %d %d %s %d %d %d', -1);

%Select trials with initial criteria and calculate the condition limits for each run separately.

for r=1:nruns
for i=1:size(scanonset,1)


timevec(i)=(faceonset(i)-scanonset(i))/1000;

if ((strcmp(trialtype(i), 'neutral')==1) & prbacc(i)==1 & prbrt(i)>=150 & prbrt(i)<=2000 & run(i)==r);
		condini(i)=3;
	elseif (strcmp(trialtype(i), 'incongruent')==1 & prbacc(i)==1 & prbrt(i)>=150 & prbrt(i)<=2000 & run(i)==r);
		condini(i)=2;
	elseif (strcmp(trialtype(i), 'congruent')==1 & prbacc(i)==1 & prbrt(i)>=150 & prbrt(i)<=2000 & run(i)==r);
		condini(i)=1;
	elseif ((strcmp(trialtype(i),'-99')==0) & (prbacc(i)==0 | prbrt(i)<150 | prbrt(i)>2000) & run(i)==r); 
	condini(i)=4;
	elseif (strcmp(trialtype(i),'-99')==1)
	condini(i)=5;
	
end  
end %loop

%determine outlier limits.
%if (sum(condini==1))==0
%	conguplimit=-99;
%	conglowlimit=-99;
%else
	conguplimit(1,r)=mean(prbrt(condini==1))+2.5*std(prbrt(condini==1));
	conglowlimit(1,r)=mean(prbrt(condini==1))-2.5*std(prbrt(condini==1));

	
%end

inconguplimit(1,r)=mean(prbrt(condini==2))+2.5*std(prbrt(condini==2));
inconglowlimit(1,r)=mean(prbrt(condini==2))-2.5*std(prbrt(condini==2));
neutraluplimit(1,r)=mean(prbrt(condini==3))+2.5*std(prbrt(condini==3));
neutrallowlimit(1,r)=mean(prbrt(condini==3))-2.5*std(prbrt(condini==3));
incorrect(1,r)=sum(condini==4);

clear condini

end %loop 



%Eliminate conditions outside cutoffs. 
numcutoff=0;

for i=1:size(scanonset,1)
	if (strcmp(trialtype(i),'-99')==1)
		cond(i)=5;
	elseif (strcmp(trialtype(i),'-99')==0 & (prbacc(i)==0 | prbrt(i)<150 | prbrt(i)>2000 | (strcmp(trialtype(i), 'congruent')==1 & (prbrt(i)<conglowlimit(1,run(i)) | prbrt(i)>conguplimit(1,run(i))))  | (strcmp(trialtype(i), 'incongruent')==1 & (prbrt(i)<inconglowlimit(1,run(i)) | prbrt(i)>inconguplimit(1,run(i)))) | (strcmp(trialtype(i), 'neutral')==1 & (prbrt(i)<neutrallowlimit(1,run(i)) | prbrt(i)>neutraluplimit(1,run(i)))))) ; 
		cond(i)=4;
		numcutoff=numcutoff+1;
	elseif (strcmp(trialtype(i), 'neutral')==1);
		cond(i)=3;
	elseif (strcmp(trialtype(i), 'incongruent')==1);
		cond(i)=2;
	elseif (strcmp(trialtype(i), 'congruent')==1);
		cond(i)=1;
	end
			

		
		
end	%end trial loop	


timevec=timevec';
cond=cond';

%find runonset 


condname={
'AC'
'AI'
'N'
'Incorrect'
};



for runloop=1:nruns
for condloop=1:length(condname)

l=0;
       for k=1:size(scanonset,1)
      	  if (cond(k,1)==condloop & run(k)==runloop);
	 	 l=l+1; 
       		condvec(1,l)=timevec(k);
		rtvec(1,l)=prbrt(k);
          end		
      end	
       
	if l==0
	condvec='*';
	rtvec=-99;
	elseif l==1
	condvec(1,2)=-99;
	rtvec(1,2)=-99;
	end	
	%Note need to correct files where this occurs later.
		


 	rt(condloop,runloop)=mean(rtvec);

	
	 outfile=strcat(outdir, 'onsets/', subj, '_visit', num2str(visit), '_', condname{condloop}, '_onsets.txt');
	 dlmwrite (outfile, condvec(1,:), '-append', 'delimiter', ' ', 'precision',7);
	 
	 outfile=strcat(outdir, 'rt/', subj, '_visit', num2str(visit), '_', condname{condloop}, '_rt.txt');
	 dlmwrite (outfile, rtvec(1,:), '-append', 'delimiter', ' ', 'precision',7);

	

	clear condvec
	clear rtvec	



end %end condition loop
end %end runloop

%Calculate average RT.
for condloop=1:length(condname)

l=0;
       for k=1:size(scanonset,1)
      	  if (cond(k,1)==condloop );
	 	 l=l+1; 
       		condvec2(1,l)=timevec(k);
		rtvec2(1,l)=prbrt(k);
          end		
      end

rt2(condloop)=mean(rtvec2);

%JB 7/1/14 Proposed solution for error - clear rtvec2 before moving to next condition.
clear rtvec2 

end


%Correction to replace -99 with asterisks.
unix('./tau_onset_correction.sh');

%Generate summary of behavioral data
text1=sprintf('Subject: %s, Visit, %s\n', subj, num2str(visit));

text2=sprintf('Corrected RT Averages: congruent, incongruent, neutral: %0.2f\t%0.2f\t%0.2f\n', rt2(1,1), rt2(1,2), rt2(1,3) );

text3=sprintf('Corrected RT: congruent run 1: %0.2f\n', rt(1,1));
text4=sprintf('Corrected RT: congruent run 2: %0.2f\n', rt(1,2));
text5=sprintf('Corrected RT: incongruent run 1: %0.2f\n', rt(2,1));
text6=sprintf('Corrected RT: incongruent run 2: %0.2f\n', rt(2,2));
text7=sprintf('Corrected RT: neutral run 1: %0.2f\n', rt(3,1));
text8=sprintf('Corrected RT: neutral run 2: %0.2f\n', rt(3,2));

text9=sprintf('\n\nCutoff: Cong low limit run 1, run 2, Cong up limit run 1, run 2, incong low limit run 1, run 2, incong up limit run 1, run 2, neutral low limit run 1, run 2, neutral up limit run 1, run 2\n');
text10=sprintf('%0.2f\t%0.2f\t%0.2f\t', conglowlimit, conguplimit, inconglowlimit, inconguplimit,neutrallowlimit, neutraluplimit);

text11=sprintf('\nNumber incorrect before SD criteria applied: %d\nNumber incorrect after SD criteria applied: %d\n', sum(incorrect), numcutoff);


text12=sprintf('\nSPSS: correct RT congruent, incongruent, neutral, number excluded before SD, number excluded after SD\n');
text13=sprintf('%s\t%d\t%0.2f\t%0.2f\t%0.2f\t%d\t%d\t', subj, visit, rt2(1,1), rt2(1,2),rt2(1,3), sum(incorrect), numcutoff);


sprintf('%s %s', text12, text13)


outfile=strcat(outdir, 'summary/', subj, '_visit', num2str(visit),'_tau_behav_summary.txt');
  fid=fopen(outfile,'a');
  fwrite(fid, char(text1), 'char');
  fwrite(fid, char(text2), 'char');
  fwrite(fid, char(text3), 'char');
  fwrite(fid, char(text4), 'char'); 
  fwrite(fid, char(text5), 'char'); 
  fwrite(fid, char(text6), 'char');
  fwrite(fid, char(text7), 'char');
  fwrite(fid, char(text8), 'char');
  fwrite(fid, char(text9), 'char');
  fwrite(fid, char(text10), 'char');
  fwrite(fid, char(text11), 'char');
  fwrite(fid, char(text12), 'char');
  fwrite(fid, char(text13), 'char');
  fclose(fid);








