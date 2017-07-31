#from gcSettings import Settings
#   this import is only needed to execute the script standalone
#   (<GCDIR>/packages needs to be in your PYTHONPATH - or grid-control was properly installed)

import time
import os
import sys
import datetime
print(time.time())
import random
print(random.randint(1,999999))

cfg = Settings()
cfg.workflow.task = 'UserTask'
cfg.workflow.backend = 'condor'

cfg.jobs.wall_time = '18:00:00'
cfg.jobs.in_flight = '1000' 
cfg.jobs.set("memory", "2000")
cfg.condor.set("JDLData", "request_disk=33000000")
cfg.jobs.set("max retry", "4")
cfg.jobs.continuous = True
cfg.jobs.nseeds = 200
cfg.jobs.seeds = 7

cfg.usertask.executable = 'ShellSkripte/StartPowheg_MSSMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh'
cfg.usertask.set("input files", ["ShellSkripte/StartPowheg_MSSMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh", "FilesForBatchSystem/MSSM/powheg.input","FilesForBatchSystem/MSSM/powheg-fh.in" "FilesForBatchSystem/fromLHE2EDM.py"] )

executable = 'ShellSkripte/StartPowheg_MSSMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh'

cfg.parameters.set("parameters", ["P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8"])
cfg.parameters.set("repeat", 1)
cfg.parameters.set("P1", ["500", "800"])
cfg.parameters.set("P2", ["5", "10", "15", "30"])
cfg.parameters.set("P3", ["t", "b", "tb"])
cfg.parameters.set("P4", ["pure", "interference"])
cfg.parameters.set("P5", ["A"])
cfg.parameters.set("P6", ["/portal/ekpbms1/home/josmet/CMSSW_7_4_14/"])
cfg.parameters.set("P7", ["/portal/ekpbms1/home/josmet/CMSSW_8_0_25/"])
cfg.parameters.set("P8", ["/portal/ekpbms1/home/josmet/CMSSW_7_4_7/"])

arguments = "@P1@ @P2@ @P3@ @P4@ @P5@ @P6@ @P7@ @P8@ @SEED_0@"

cfg.usertask.set('arguments', "%s"%arguments)

cfg.storage.set('se path', "/storage/c/josmet/EtpFreiburgDesyEtp/lhe2edm-Files/")

cfg.storage.set('se output files', ["packed-@P5@-m@P5@@P1@_tb@P2@_@P3@_@P4@.tar.gz", "lhe2edm-@P5@-m@P5@@P1@_tb@P2@_@P3@_@P4@.root"])
cfg.storage.set('se output pattern', "@X@")
getattr(cfg, 'global').set('workdir', "/storage/c/josmet/Schritt1/Run_"+datetime.datetime.now().strftime("%Y-%m-%d_%H_%M")+"/workdir/")
print(cfg)
