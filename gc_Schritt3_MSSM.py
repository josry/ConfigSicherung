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

cfg.jobs.wall_time = '08:00:00'
cfg.jobs.in_flight = '1000' #war 1000
cfg.jobs.set("memory", "2000")
cfg.condor.set("JDLData", "request_disk=4000000")
cfg.jobs.set("max retry", "4")
cfg.jobs.continuous = True
cfg.jobs.nseeds = 200
cfg.jobs.seeds = 7

cfg.usertask.executable = 'ShellSkripte/Schritt3_MSSMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh'
cfg.usertask.set("input files", ["ShellSkripte/Schritt3_MSSMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh", "FilesForBatchSystem/baseConfig_pdg-A.json", "FilesForBatchSystem/gen_pdg-A.json"])

executable = 'ShellSkripte/Schritt3_MSSMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh'

cfg.parameters.set("parameters", ["P1", "P2", "P3", "P4", "P5"])
cfg.parameters.set("repeat", 1)
cfg.parameters.set("P1", ["400", "500", "600", "700", "800"])
cfg.parameters.set("P2", ["5", "10", "15", "30"])
cfg.parameters.set("P3", ["t_pure", "b_pure", "tb_interference","t_interference", "b_interference"])
cfg.parameters.set("P4", ["A"])
cfg.parameters.set("P5", ["/portal/ekpbms1/home/josmet/CMSSW_7_4_7/"])

arguments = "@P1@ @P2@ @P3@ @P4@ @P5@"

cfg.usertask.set('arguments', "%s"%arguments)

cfg.storage.set('se path', "/storage/c/josmet/EtpFreiburgDesyEtp/MSSM-Files/kappa2artus-Files/")

cfg.storage.set('se output files', ["kappa2artus-@P4@-m@P4@@P1@_tb@P2@_@P3@.root"])
cfg.storage.set('se output pattern', "@X@")
getattr(cfg, 'global').set('workdir', "/storage/c/josmet/EtpFreiburgDesyEtp/MSSM-Files/Schritt3_MSSM/Run_"+datetime.datetime.now().strftime("%Y-%m-%d_%H_%M")+"/workdir/")
print(cfg)
