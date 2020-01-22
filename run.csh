#!/bin/csh

#this is the version originally here, currently has a bug though
#starver SL16j

#new version because I'm getting a bug
starver SL18f

set energy=`printf "%.1f" $1`
set mRun=$2
set nRun=`echo $mRun | sed 's/Run//'`
#set nRun=`echo $mRun | sed -e 's/...//'`

echo $energy $nRun

set inDir=`pwd`
set nflies=1000
set nevents=0
set output=${inDir}/output
#set JobName=${output}/${energy}GeV_${mRun}/TPC${energy}_$3.root
set JobName=/star/scratch/tedmonds/femtoDst/treeMaker/${mRun}/output/femtoDst${energy}_$3.root
#set ListDir=/star/u/tedmonds/Analysis/f0Analysis_03/datalist/
set ListDir=/star/u/tedmonds/Analysis/femtoDst/treeMaker/${mRun}/datalist/
set filelist={$ListDir}/${energy}GeV_${mRun}/$energy.list.`printf "%.5d" $3`
#set filelist={$ListDir}/${energy}GeV_${mRun}/$energy.list.`printf "%.4d" $3`
set mEnergy=`printf "%.1f" $energy`

cd ${inDir}

echo $filelist  $nRun  $mEnergy 

#echo root4star -b -q ${inDir}/readPicoDst.C\(\"$filelist\",\"$JobName\",$nRun,$mEnergy,\"$ListDir\"\)
echo ""
root4star -b -q ${inDir}/readPicoDst.C\(\"$filelist\",\"$JobName\",$nRun,$mEnergy,\"$ListDir\"\)
#root4star -b -q ${inDir}/readPicoDst.C
