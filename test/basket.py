#!/usr/bin/env python3
# 
#       SMP Downloader
#
#       License:        GNU General Public License (GPL)
#       (c) 2019        Microsoft Corp.
#

import argparse
import re

from helper import *
from SAP_DLM import *
from SAP_SMP import *

parser = argparse.ArgumentParser(description="Downloader")
parser.add_argument("--config", required=True, type=str, dest="config", help="The configuration file")
parser.add_argument("--dir", required=False, type=str, dest="dir", help="Location to place the download file")
parser.add_argument("--dryrun", required=False, action="store_true", dest="dryrun", help="Dryrun set to True will not actually download the bits")

args = parser.parse_args()
Config.load(args.config)
dryrun         = args.dryrun
download_dir   = args.dir

# define shortcuts to the configuration files
app = Config.app_scenario
db  = Config.db_scenario
rti = Config.rti_scenario

DLM.init(download_dir, dryrun)
basket = DownloadBasket()


SMP.init()


results = [] 

cnt     = 0
while cnt < len(results):
    r = results[cnt]
    assert("Description" in r and "Infotype" in r and "Fastkey" in r and "Filesize" in r), \
        "Result does not have all required keys (%s)" % (str(r))

    r["Filesize"]   = int(r["Filesize"])

 


print("%s\n" % (results))
basket.add_item(DownloadItem(
    id            = results["Fastkey"],
    desc          = results["Description"],
    size          = results["Filesize"],
    time          = basket.latest,
    base_dir      = download_dir,
    target_dir    = "Archives",
    skip_download = dryrun,
))

if len(basket.items) > 0:
    basket.filter_latest()
    basket.download_all()
