
*Note: changed length and type for key variables: Subject Session Set Block Trial GetReady.FinishTime Faces.OnsetTime Condition Probe.ACC Probe.RT

GET DATA
  /TYPE=TXT
  /FILE='\\nimhirp-ds1\sdan1$\Data\AttentionRetraining\Tau_NIMH\fMRI\Files for '+
    'springsteen\s999_tau_visit1.txt'
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  ExperimentName A22
  Subject F5.0
  Session F1.0
  acqtime F4.0
  Clock.Information A514
  DataFile.Basename A30
  Display.RefreshRate F6.3
  ExperimentVersion A7
  Group F1.0
  leftresp F1.0
  RandomSeed F10.0
  rightresp F1.0
  RuntimeCapabilities A12
  RuntimeVersion A10
  RuntimeVersionExpected A10
  SessionDate A10
  SessionStartDateTimeUtc A20
  SessionTime A8
  Set A1
  SiteNumber F1.0
  StudioVersion A10
  Study F1.0
  TR F4.0
  triggervalue F1.0
  Block F1.0
  GetReady.FinishTime F6.0
  List1 F1.0
  List1.Cycle F1.0
  List1.Sample F1.0
  ProcedureBlock A7
  RunningBlock A5
  WaitScanner.FinishTime F6.0
  Trial F3.0
  Condition A11
  Correcto F1.0
  CorrectResponse F1.0
  FaceBottom A3
  Faces.ACC F1.0
  Faces.CRESP F1.0
  Faces.DurationError F1.0
  Faces.OnsetDelay F2.0
  Faces.OnsetTime F6.0
  Faces.OnsetToOnsetTime F3.0
  Faces.RESP F1.0
  Faces.RT F1.0
  Faces.RTTime F1.0
  FaceSet A1
  FaceTop A3
  Fixation.ACC F1.0
  Fixation.CRESP F1.0
  Fixation.DurationError F1.0
  Fixation.OnsetDelay F2.0
  Fixation.OnsetTime F6.0
  Fixation.OnsetToOnsetTime F3.0
  Fixation.RESP F1.0
  Fixation.RT F1.0
  Fixation.RTTime F1.0
  Fixation1.ACC F1.0
  Fixation1.CRESP F1.0
  Fixation1.DurationError F1.0
  Fixation1.OnsetDelay F2.0
  Fixation1.OnsetTime F6.0
  Fixation1.OnsetToOnsetTime F1.0
  Fixation1.RESP F1.0
  Fixation1.RT F1.0
  Fixation1.RTTime F1.0
  fNN F2.0
  fNTc F2.0
  fNTi F2.0
  Gender A6
  horizontalJitterBottom A3
  horizontalJitterTop A3
  ITI.ACC F1.0
  ITI.CRESP F1.0
  ITI.DurationError F1.0
  ITI.OnsetDelay F2.0
  ITI.OnsetTime F6.0
  ITI.OnsetToOnsetTime F1.0
  ITI.RESP F1.0
  ITI.RT F1.0
  ITI.RTTime F1.0
  ITIDur F3.0
  ITIList F2.0
  mNN F2.0
  mNTc F2.0
  mNTi F2.0
  NN F1.0
  NTc F1.0
  NTi F1.0
  PBehind A7
  pBottom A5
  Probe.ACC F1.0
  Probe.CRESP F1.0
  Probe.DurationError F1.0
  Probe.OnsetDelay F2.0
  Probe.OnsetTime F6.0
  Probe.OnsetToOnsetTime F4.0
  Probe.RESP F1.0
  Probe.RT F3.0
  Probe.RTTime F6.0
  ProbeBehind A7
  ProbeBottom A5
  ProbeLocation A6
  ProbeTop A5
  ProbeType A5
  ProcedureTrial A9
  pTop A5
  pType A5
  RunningTrial A9
  TrialList F1.0
  TrialList.Cycle F1.0
  TrialList.Sample F3.0
  TrialType A4
  VerticalJitterBottom A3
  VerticalJitterTop A3.
CACHE.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

*Keep only essential variables:  Subject	Session	Set	Block	GetReady.FinishTime	Trial	Condition	Faces.OnsetTime	Probe.ACC	Probe.RT

FILTER OFF.
USE ALL.
SELECT IF (Condition="congruent" | Condition="incongruent" | Condition="neutral").
EXECUTE.

SAVE TRANSLATE OUTFILE='Z:\Data\AttentionRetraining\Tau_NIMH\fMRI\Files for '+
    'springsteen\s999_tau_visit1.dat'
  /TYPE=TAB
  /MAP
  /REPLACE
  /FIELDNAMES
/KEEP   Subject	Session	Set	Block	GetReady.FinishTime	Trial	Condition	Faces.OnsetTime	Probe.ACC	Probe.RT
  /CELLS=VALUES.









*THESE ARE THE DELETED VARIABLES Experiment acqtime Clock.Information Display.RefreshRate Group leftresp RandomSeed rightresp SessionDate SessionTime SessionTimeUtc SiteNumber Study triggervalue VDurn 
 List1 List1.Cycle List1.Sample ProcedureBlock RunningBlock WaitScanner.FinishTime Correcto CorrectResponse FaceBottom Faces.ACC Faces.CRESP Faces.DurationError Faces.OnsetDelay  
Faces.RESP Faces.RT Faces.RTTime FaceSet FaceTop Fixation.ACC Fixation.CRESP Fixation.DurationError Fixation.OnsetDelay Fixation.OnsetTime  Fixation.RESP Fixation.RT Fixation.RTTime Fixation1.ACC
Fixation1.CRESP Fixation1.DurationError Fixation1.OnsetDelay Fixation1.OnsetTime Fixation1.RESP Fixation1.RT Fixation1.RTTime fNN fNTc fNTi Gender horizontalJitterBottom horizontalJitterTop ITI.ACC ITI.CRESP ITI.DurationError
ITI.OnsetDelay ITI.OnsetTime ITI.RESP ITI.RT ITI.RTTime ITIDur ITIList mNN mNTc mNTi NN NTc NTi PBehind pBottom  Probe.CRESP Probe.DurationError Probe.OnsetDelay Probe.OnsetTime Probe.RESP  Probe.RTTime 
ProbeBehind ProbeBottom ProbeLocation ProbeTop ProbeType ProcedureTrial pTop pType RunningTrial TrialList TrialList.Cycle TrialList.Sample TrialType VerticalJitterBottom VerticalJitterTop.

 


