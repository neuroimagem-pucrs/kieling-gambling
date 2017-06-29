#!/bin/sh
#Script to correct for -99 in vol files.
#5/1/12 Updated directory to only look in onsets. 

cd /raid4/sdanny/workingdata/tau/behav_data/onsets/

for file in $(ls *.txt)	
do
	sed -e "s/-99/*/ig" $file > temp.txt
	mv temp.txt $file
done 

cd /raid4/sdanny/workingdata/tau/behav_data/rt/

for file in $(ls *.txt)	
do
	sed -e "s/-99/*/ig" $file > temp.txt
	mv temp.txt $file
done 
