#!/bin/csh

date

set energy=`printf "%.1f" $1`

if($1 == "")then
echo "IS NULL, please entry the energy (7.7, 11.5, 14.6, 19.6, 27.0, 39.0, 62.4, 200.0) , (Run10/Run...)"
echo ""
exit
endif

set menergy=`echo $energy | awk -F . '($2>0)?a=$1:a=$1{print a}'`
set benergy=`echo $energy | awk -F . '($2>0)?a=$1:a=$1{print a}'`
set mRun=Run10
if($benergy>199 && $benergy<201)set mRun=Run11
if($benergy>18  && $benergy<20 )set mRun=Run11
if($benergy>26  && $benergy<28 )set mRun=Run11
if($benergy>13  && $benergy<15 )set mRun=Run14
if($benergy>13  && $benergy<15 )set menergy=15
if($benergy>13  && $benergy<15 )set benergy=15
if($benergy>6   && $benergy<8  )set menergy=7.7
if($benergy>6   && $benergy<8  )set benergy=7

if($2 != "")set mRun=$2
set nRun=`echo $mRun | sed 's/Run//'`

echo $mRun  $energy  $menergy


set mainDir=`pwd`

#set outDir=$mainDir/output/${energy}GeV_${mRun}
set SCdir=/star/scratch/tedmonds/femtoDst/treeMaker/${mRun}
set outDir=${SCdir}/output
set logDir=$SCdir/err
set relist=${logDir}/resub.list
echo $relist

set nR=`wc -l < $relist`
echo "$nR jobs will resubmit..."

# setting some variables from sub.csh
set shName=run.csh
# end of setting variables for sub.csh

foreach ifile(`cat $relist`)
	if(-e ${logDir}/$ifile.out)rm ${logDir}/$ifile.out
	if(-e ${logDir}/$ifile.err)rm ${logDir}/$ifile.err
	if(-e ${logDir}/$ifile.log)rm ${logDir}/$ifile.log
	if(-e ${outDir}/femtoDst${energy}_$ifile.root)rm ${outDir}/femtoDst${energy}_$ifile.root 

	set subJob=$logDir/sub$ifile.con

	echo "$subJob"

	cd $mainDir
	
	if(-e ${subJob}) then
		cp $subJob Fsub.con 
		condor_submit Fsub.con 
		rm Fsub.con
	endif
	if(!(-e $subJob)) then
        	touch $subJob
        	echo "Universe     = vanilla" >> $subJob
        	echo "Notification = Error" >> $subJob
        	echo "Initialdir   = $mainDir" >> $subJob
        	echo "Executable   = $shName" >> $subJob
        	echo "Arguments    = $energy $mRun  $ifile" >> $subJob
        	echo "Output       = $logDir/${ifile}.out" >> $subJob
        	echo "Error        = $logDir/${ifile}.err" >> $subJob
        	echo "Log          = $logDir/${ifile}.log" >> $subJob
		echo 'Requirements = ((CPU_Experiment == "star" ) || (CPU_Experiment == "phenix"))' >> $subJob
        	#echo "Notify_user  = tedmonds@purdue.edu" >> $subJob
        	echo "GetEnv       = True" >> $subJob
        	echo '+Experiment  = "general" ' >> $subJob
        	echo '+Job_Type    = "cas" ' >> $subJob
        	#echo '+Job_Type    = "long" ' >> $subJob
		echo 'kill_sig     = SIGINT ' >> $subJob
		echo "PeriodicRemove = (NumJobStarts >=1 && JobStatus==1) || (JobStatus == 2 && (CurrentTime - JobCurrentStartDate > (54000)) && ((RemoteUserCpu+RemoteSysCpu)/(CurrentTime-JobCurrentStartDate)<0.10)) || (((CurrentTime-EnteredCurrentStatus) > (2*24*3600)) && JobStatus == 5)" >> $subJob
		echo "Priority =+10" >> $subJob
        	echo "Queue 1" >> $subJob
        	echo "  " >> $subJob

        	#@ iJob++
        	#@ iJob+=100

        	cp $subJob Fsub.con
        	condor_submit Fsub.con
        	rm Fsub.con
	endif
	
	end

	echo "Done GoodLuck..."
	echo ""
