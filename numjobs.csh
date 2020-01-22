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

set dataName=numjobs.txt
if(-e $dataName) rm $dataName
touch $dataName
echo "$nJobs" >> $dataName

echo ""
