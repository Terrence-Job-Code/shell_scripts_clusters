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

set ListDir=/star/u/tedmonds/Analysis/f0Analysis_03/Run16/datalist/
set nFiles=`find ${ListDir}/${energy}GeV_${mRun} -name "$energy.list.*" |wc -l`
#set nFiles = 100

if( $nFiles == 0) then
   echo "no Files founded, Bye ..."
   exit
endif

set nJobs=10
set nstep=`echo "scale=10; $nFiles/$nJobs" | bc | awk '{print int($1)==$1?int($1):int(int($1*10/10+1))}'`

echo "Au+Au: $energy GeV data,  $nFiles files total, $nJobs jobs, $nstep files/job... "

set mainDir=`pwd`
set logDir=$mainDir/err/

set shName=tensHadd.csh
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
        echo "Arguments    = $energy $mRun $iJob $nstep" >> $subJob
        echo "Output       = $logDir/${iJob}.out" >> $subJob
        echo "Error        = $logDir/${iJob}.err" >> $subJob
        echo "Log          = $logDir/${iJob}.log" >> $subJob
        echo "Notify_user  = tedmonds@purdue.edu" >> $subJob
        echo "GetEnv       = True" >> $subJob
        echo '+Experiment  = "star" ' >> $subJob
        echo '+Job_Type    = "cas" ' >> $subJob
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
