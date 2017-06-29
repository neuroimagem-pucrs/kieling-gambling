#!/bin/tcsh
#script written for use with tau.
#Adapted from tau study.
# 8/29/12 created subj2 variable to account for visit 2 structure.
# 4/22/14 Added in 2mm censoring and some other stuff had it go to new results folder
#	-mask_dilate 1 \ DEFAULT
#	-scale_max_val 200 \ DEFAULT
#	-regress_basis GAM \ DEFAULT
#	-regress_censor_motion $motion_max \ 
# 4/22/14 Added "-regress_local_times" to afni_proc.py 
# 4/22/14 since I was reruning I added in the contrasts that have the equal weighting for comparing Neutral to angry
# changed -do_block align tlrc \ to -blocks tshift align tlrc volreg blur mask scale regress 	
# 9/11/2014 added in censor for outliers	-regress_censor_outliers 0.1 		\


#for testing 
#set subjects = (s1305)
#foreach subj ($subjects)

#for the real thing want to input list of subjects. 

if ( $#argv > 0 ) then
  set subj_list = $1
  set wc_output = `wc $subj_list | cut -f1`
  set num_lines = $wc_output[1]

  set line_no = 1
 while($line_no <= $num_lines)
    set subj = `head -$line_no $subj_list | tail -1`    
    echo $subj $subj_list $line_no $num_lines

set visit=$2
set subj2 = `echo $subj | sed 's/_2//g'`

cd /raid4/sdanny/workingdata/tau/Censoring2mm/InidividualAnalyses2mm/
    mkdir $subj
    cd $subj

#remove any previous directories worked on.
rm -Rf ${subj}.results2mm
rm output.${subj}.process2mm.script


set subj_dir = /raid4/sdanny/workingdata/tau/subjects/${subj}/afni
set subj_anat = /raid4/sdanny/workingdata/tau/subjects/${subj}/anat
set stimonsetdir = /raid4/sdanny/workingdata/tau/behav_data/onsets
set motion_max = 2.0


afni_proc.py   -subj_id ${subj} \
	-dsets $subj_dir/OutBrick_r?+orig.HEAD \
	-scr_overwrite \
	-copy_anat $subj_anat/${subj}_anat+orig.HEAD \
	-tcat_remove_first_trs 4 \
        -blocks tshift align tlrc volreg blur mask scale regress \
	-align_opts_aea -giant_move -cost lpc+ZZ -AddEdge \
	-volreg_base_dset $subj_dir/OutBrick_r1+orig'[1]' \
	-volreg_align_e2a \
	-volreg_tlrc_warp \
	-blur_size 6 \
	-mask_dilate 1 \
	-scale_max_val 200 \
	-regress_basis GAM \
	-regress_censor_motion $motion_max \
	-regress_censor_outliers 0.1 \
	-out_dir ${subj}.results2mm \
	-script ${subj}.process2mm.script \
	-regress_stim_times $stimonsetdir/${subj2}_visit${visit}_AC_onsets.txt \
			    $stimonsetdir/${subj2}_visit${visit}_AI_onsets.txt \
                            $stimonsetdir/${subj2}_visit${visit}_Incorrect_onsets.txt \
                            $stimonsetdir/${subj2}_visit${visit}_N_onsets.txt \
        -regress_stim_labels AC \
                             AI \
                             Incorrect \
                             N  \
        -regress_local_times \
	-regress_make_ideal_sum sum_ideal.1D \
	-regress_est_blur_epits \
	-regress_est_blur_errts \
	-regress_reml_exec   \
	-regress_opts_3dD \
		-num_glt 8 \
     		-gltsym 'SYM: +AI -AC' -glt_label 1 ABias \
     		-gltsym 'SYM: +AC -N' -glt_label 2 ACvN \
     		-gltsym 'SYM: +AI -N' -glt_label 3 AIvN \
      		-gltsym 'SYM: +AI +AC' -glt_label 4 AngryvFix \
               	-gltsym 'SYM: +AI +AC +N' -glt_label 5 FacevFix \
 		-gltsym 'SYM: +3*Incorrect -AI -AC -N' -glt_label 6 ErrorvCorrect \
                -gltsym 'SYM: +AI +AC -2*N' -glt_label 7 ACAIvNEU        \
                -gltsym 'SYM: +.5*AI +.5*AC' -glt_label 8 Angry            \
		-cbucket cbucket.stats.${subj} \
 	        -xsave  \
                -jobs 4


#Change permissions on output script and execute.
chmod 775 ${subj}.process2mm.script
tcsh -xef ${subj}.process2mm.script |& tee output.${subj}.process2mm.script

# return to parent directory
cd /raid4/sdanny/workingdata/tau/scripts
@ line_no++
end

else
echo " need subject list"
exit
endif

#scr_overwrite - overwrites existing script
#do_block - adds coregistration (align) 
#copy_anat - copies anat to current results directory.
#tcat_remove_first_trs 4 (for crada b/c saving non-steady state)
#align_opts_aea - coregistration options, chosen to minimize errors and to be able to visualize the alignment
#volreg_base_dset OutBrick_r1+orig'[1]'
#volreg_align_e2a - aligns epi data to anat
#volreg_tlrc_warp - applies auto talaraich transformation to epi data 
#blur_size - use 6 mm FWHM smoothing
#regress_make_ideal_sum - allow you to look at the ideal shape of the data.
#regress_est_blur_epits and errts - used for AlphaSim calculations. 
#xjpg - generates jpg of design matrix. Standard now.

