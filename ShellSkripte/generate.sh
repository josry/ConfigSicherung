#!/bin/bash

#if [ $# -ne 5 ]; then
 #   echo "sh generate.sh [mass] [tan(beta)] [tb,t,b] [interference, pure] [htype]"
 #   exit 1
#fi

mass=$1
tb=$2
particle=$3
isInterference=$4
htype=$5
seed=$7
pushd ../../scales/scales
	source /cvmfs/cms.cern.ch/cmsset_default.sh
	SCRAM_ARCH=slc6_amd64_gcc491
	eval `scramv1 runtime -sh`
	if [ "$isInterference" = "interference" ]; then
	    HFACT=$(python plotscale.py -p $htype -m $mass -t $tb |grep "Qtb ="|awk '{print $3}')
	fi
	if [ "$isInterference" = "pure" ]; then
		HFACT=$(python plotscale.py -p $htype -m $mass -t $tb |grep "Q${particle} ="|awk '{print $3}')
	fi
popd



echo "mass = $mass"
echo "tan(beta) = $tb"
echo "particle to be considered = $particle"
echo "isInterference = $isInterference"
echo "higgstype = $htype"
echo "HFACT = $HFACT"

dir=$6/Juli_2017_testrun-lhc-${htype}-m${htype}${mass}_tb${tb}_${particle}_${isInterference}

if [ "$particle" = "tb" ]; then
    echo "You choose tb"
elif [ "$particle" = "t" ]; then
    echo "You choose t"
elif [ "$particle" = "b" ]; then
    echo "You choose b"
else
    echo "Not valid option ... choose from [tb, t, b]"
    exit 1
fi

if [ "$htype" = "A" ]; then
    echo "You choose pseudo-scalar A"
elif [ "$htype" = "H" ]; then
    echo "You choose heavy Higgs H"
else
    echo "Not valid option ... choose from [H,A]"
    exit 1
fi

if [ "$isInterference" = "interference" ]; then
    echo "You choose interference"
else
    echo "You choose pure process"
    if [ "$particle" = "tb" ]; then
	echo "You don't need to choose this process for pure term"
	exit 1
    fi
fi

if [ -d ${dir} ]; then
    echo "directory already exist ... avoid !"
    exit 1
else
    echo "create directory : $dir"
    mkdir $dir -p
fi



cp powheg.input $dir
sed -i -e "s/iseed    55555/iseed    ${seed}/" $dir/powheg.input
sed -i -e "s/hmass  500/hmass  ${mass}/" $dir/powheg.input
sed -i -e "s/tanb 50d0/tanb ${tb}d0/" $dir/powheg.input

if [ "$particle" = "tb" ]; then
    echo ""
elif [ "$particle" = "t" ]; then
    echo "nobot 1" >> $dir/powheg.input
    echo ""
elif [ "$particle" = "b" ]; then
    echo "notop 1" >> $dir/powheg.input
    echo ""
fi


if [ "$htype" = "H" ]; then
    sed -i -e "s/higgstype 3/higgstype 2/" $dir/powheg.input
fi

sed -i -e "s/hfact    17d0/hfact    ${HFACT}d0/" $dir/powheg.input
echo "Done !"
