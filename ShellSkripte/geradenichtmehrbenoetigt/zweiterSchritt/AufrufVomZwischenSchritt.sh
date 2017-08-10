#!/bin/bash

if [ $# -ne 2 ]; then
	    echo "sh generate.sh [mass] [tan(beta)] [tb,t,b] [interference, pure] [htype] [CMSSW_7_4_14_Path] [CMSSW_7_4_7_Path] [CMSSW_8_0_25_Path]" 
		exit 1
fi


./ZwischenSchritt.sh $1 $2 t pure A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 &

./ZwischenSchritt.sh $1 $2 b pure A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 &

./ZwischenSchritt.sh $1 $2 tb interference A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 &

./ZwischenSchritt.sh $1 $2 t interference A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 &

./ZwischenSchritt.sh $1 $2 b interference A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 &
