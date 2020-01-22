#!/bin/csh

set energy=`printf "%.1f" $1`
set mRun=$2
set nRun=`echo $mRun | sed 's/Run//'`
#set nRun=`echo $mRun | sed -e 's/...//'`

echo $energy  $nRun  $3  $4

set inDir=`pwd`
set scDir=/star/scratch/tedmonds/f0Analysis/Run16/Analysis/Hist
#set tmp=$inDir/tmp/Tmp$3
set tmp=$scDir/tmp/Tmp$3

mkdir $tmp

set nstep=$4

@ index = $3 * $nstep 
@ index1 = $index + $nstep 

while( $index < $index1)
   set fileName=$scDir/../output/${energy}GeV_${mRun}/TPC${energy}_$index.root

   if(-e $fileName)ln -s "$fileName" $tmp/
   @ index ++
end

cd $inDir

@ jobid = $3
#if(-e ./Hadd/hadd_$jobid.root)rm ./Hadd/hadd_$jobid.root
#hadd -f ./Hadd/hadd_$jobid.root $tmp/*.root

hadd -f Hadd/run16_200GeV_${jobid}_noTOF.root $scDir/../output/${energy}GeV_${mRun}/*$jobid.root

rm -r $tmp 










#touch list.list
#set filelistN=list.list
#
#echo "hadd -T test.root ">> $filelistN
#
#set index = $1 
#while( $index < $2 )
#      echo "$output/hist$index.root" >> $filelistN 
#      @ index ++
#end
#
##hadd test.root $filelistN
#
#csh `cat "$filelistN"`

