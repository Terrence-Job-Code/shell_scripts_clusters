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

#set ListDir=/star/u/jiezhao/pwgDisk/LPV/run16AuAu/datalist/
set ListDir=/star/u/tedmonds/Analysis/femtoDst/treeMaker/Run16/datalist/
set nJobs=`find ${ListDir}/${energy}GeV_${mRun} \( -name "$energy.list.*" -a -not -name "*tmp" \) |wc -l`
#set nJobs=50

if( $nJobs == 0) then
echo "no job founded, Bye ..."
exit
endif

echo "Au+Au: $energy GeV data,  $nJobs jobs total..."


set mainDir=`pwd`
set SCdir=/star/scratch/tedmonds/femtoDst/treeMaker/${mRun}
set outDir=$SCdir/output/
set logDir=$SCdir/err/
set relist=${logDir}/resub.list
echo $relist

if(-e $relist)rm $relist
touch $relist

set ifile=0
while ( $ifile < $nJobs )

	if( !(`grep -sc 'Goodbye' $logDir/${ifile}.out`) )echo $ifile >> $relist
	if( `grep -sc 'Disk quota exceeded' $logDir/${ifile}.err` )echo $ifile >> $relist
	if( `grep -sc 'segmentation violation' $logDir/${ifile}.err` )echo $ifile >> $relist
	if( `grep -sc 'Brake' $logDir/${ifile}.err` )echo $ifile >> $relist
	if( `grep -sc 'dlopen erro' $logDir/${ifile}.err` )echo $ifile >> $relist
	if( `grep -sc 'Abort' $logDir/${ifile}.err` )echo $ifile >> $relist
	if( !(-e $logDir/${ifile}.err) )echo $ifile >> $relist
	if( !(-e $logDir/${ifile}.out) )echo $ifile >> $relist
	if( !(-e $outDir/femtoDst${energy}_${ifile}.root) )echo $ifile >> $relist
#	if( (`grep -sc 'evicted' $logDir/${ifile}.log`) )echo $ifile >> $relist

	@ ifile++ 
end

cat $relist | sort -u -n >tmp000
mv tmp000 $relist

set nR=`wc -l < $relist`
echo "$nR jobs need resubmit..."

cat $relist

echo "Done GoodLuck..."
echo ""






