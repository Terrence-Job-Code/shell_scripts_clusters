#!/bin/tcsh

date

# {7.7, 11.5, 14.6, 19.6, 27.0, 39.0, 62.4}
set energy=`printf "%.1f" $1`

if($1 == "")then
  echo "IS NULL, please entry the energy (7.7, 11.5, 14.6, 19.6, 27.0, 39.0, 62.4, 200.0) , (Run10/Run...)"
  echo ""
  exit
endif 

set menergy=`echo $energy | awk -F . '($2>0)?a=$1:a=$1{print a}'` 
set benergy=`echo $energy | awk -F . '($2>0)?a=$1:a=$1{print a}'` 
set mRun=Run10
if($benergy>199 && $benergy<201)set mRun=Run16
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

set ListDir=/star/u/tedmonds/Analysis/femtoDst/treeMaker/Run16/datalist/
#set ListDir=/star/scratch/tedmonds/f0Analysis/Run16/datalist/
set nJobs=`find ${ListDir}/${energy}GeV_${mRun} -name "$energy.list.*" |wc -l`
#set nJobs=1000

if( $nJobs == 0) then
   echo "no job founded, Bye ..."
   exit
endif

echo "Au+Au: $energy GeV data,  $nJobs jobs will submitted..."


set mainDir=`pwd`
set SCdir = /star/scratch/tedmonds/femtoDst/treeMaker/${mRun}/

#set outDir=$mainDir/output/${energy}GeV_${mRun}
set outDir=${SCdir}/output/
set logDir=${SCdir}/err/
#set logDir=/star/scratch/tedmonds/f0Analysis/Analysis/err/${energy}GeV_${mRun}

cat << EOF
Warning: will delete the following files 
$outDir 
$logDir
  are you sure want to continue, y/n ?
EOF
set choice = $<
if( !($choice =~ [Yy]*) ) then
	echo 'byebye...'
	exit
endif

if(-e $outDir)rm -r $outDir
if(-e $logDir)rm -r $logDir
if(!(-e $outDir))mkdir $outDir
if(!(-e $logDir))mkdir $logDir


set shName=run.csh
set iJob=0
@ nMax= $nJobs + $iJob
while($iJob < $nMax)
        set subJob=$logDir/sub$iJob.con
        if(-e $subJob)rm $subJob
        touch $subJob
        echo "Universe     = vanilla" >> $subJob
        echo "Notification = Error" >> $subJob
        echo "Initialdir   = $mainDir" >> $subJob
        echo "Executable   = $shName" >> $subJob
        echo "Arguments    = $energy $mRun  $iJob" >> $subJob
        echo "Output       = $logDir/${iJob}.out" >> $subJob
        echo "Error        = $logDir/${iJob}.err" >> $subJob
        echo "Log          = $logDir/${iJob}.log" >> $subJob
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

        @ iJob++
        #@ iJob+=100

        cd $mainDir
        cp $subJob Fsub.con
        condor_submit Fsub.con
        rm Fsub.con
end


echo "Done GoodLuck..."
echo ""
