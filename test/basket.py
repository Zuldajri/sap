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


results = [{'__metadata': {'Fastkey': '0020000000381822021', 'Description': 'SAP HANA CLIENT Version 2.7', 'Filesize': 206671, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000381762021', 'Description': 'SAP HANA CLIENT Version 2.7', 'Filesize': 125420, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000392102021', 'Description': 'Revision 255.00 for SAP HANA STUDIO 2', 'Filesize': 1076514, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000392142021', 'Description': 'Revision 255.00 for SAP HANA STUDIO 2', 'Filesize': 1041717, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000002208852020', 'Description': 'SAPCAR', 'Filesize': 4378, 'Infotype': 'EXE'},
{'__metadata': {'Fastkey': '0020000000393992021', 'Description': 'LCAPPS for HANA 2.00.055.00 Build 100.47 PL 009', 'Filesize': 106958, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000392162021', 'Description': 'Revision 2.00.055.0 (SPS05) for HANA DB 2.0', 'Filesize': 3611696, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000211202021', 'Description': 'Attribute Change Package 02 for SAP_UI 755', 'Filesize': 4, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000014247222017', 'Description': 'Attribute Change Package 11 for UIMDG001 200', 'Filesize': 4, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000561182019', 'Description': 'Attribute Change Package 11 for UITRV001 300', 'Filesize': 4, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000059642016', 'Description': 'Attribute Change Package 16 for EA-HR 608', 'Filesize': 7, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000029982015', 'Description': 'Attribute Change Package 18 for GBX01HR 600', 'Filesize': 4, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000060132013', 'Description': 'Attribute Change Package 19 for SRA004 600', 'Filesize': 5, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000033172015', 'Description': 'Attribute Change Package 21 for GBX01HR5 605', 'Filesize': 4, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000020208092017', 'Description': 'Attribute Change Package 27 for UIHR002 100', 'Filesize': 4, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000249512014', 'Description': 'Attribute Change Package 33 for SAP_HR 608', 'Filesize': 26, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000297212015', 'Description': 'Attribute Change Package 34 for ST-PI 740', 'Filesize': 4, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000001634982020', 'Description': 'Installation for SAP IGS integrated in SAP Kernel', 'Filesize': 134953, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000281972021', 'Description': 'Kernel Part I (781)', 'Filesize': 296386, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000281722021', 'Description': 'Kernel Part II (781)', 'Filesize': 7505, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000422652021', 'Description': 'Patch 2 for SOFTWARE UPDATE MANAGER 2.0 SP10', 'Filesize': 347058, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000410162020', 'Description': 'Predi. Analy. APL 2008 for SAP HANA 2.0 SPS03 and beyond', 'Filesize': 56889, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666752020', 'Description': 'S4CORE105_INST_EXPORT_1.zip', 'Filesize': 6, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666762020', 'Description': 'S4CORE105_INST_EXPORT_10.zip', 'Filesize': 1437597, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666772020', 'Description': 'S4CORE105_INST_EXPORT_11.zip', 'Filesize': 1353247, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666782020', 'Description': 'S4CORE105_INST_EXPORT_12.zip', 'Filesize': 976639, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666802020', 'Description': 'S4CORE105_INST_EXPORT_13.zip', 'Filesize': 1151293, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666842020', 'Description': 'S4CORE105_INST_EXPORT_14.zip', 'Filesize': 2017827, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666862020', 'Description': 'S4CORE105_INST_EXPORT_15.zip', 'Filesize': 1516728, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666872020', 'Description': 'S4CORE105_INST_EXPORT_16.zip', 'Filesize': 1456278, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666882020', 'Description': 'S4CORE105_INST_EXPORT_17.zip', 'Filesize': 1479934, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666892020', 'Description': 'S4CORE105_INST_EXPORT_18.zip', 'Filesize': 1955691, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666912020', 'Description': 'S4CORE105_INST_EXPORT_19.zip', 'Filesize': 1223741, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666922020', 'Description': 'S4CORE105_INST_EXPORT_2.zip', 'Filesize': 5, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666932020', 'Description': 'S4CORE105_INST_EXPORT_20.zip', 'Filesize': 1203006, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666942020', 'Description': 'S4CORE105_INST_EXPORT_21.zip', 'Filesize': 1418320, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666952020', 'Description': 'S4CORE105_INST_EXPORT_22.zip', 'Filesize': 1277856, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666982020', 'Description': 'S4CORE105_INST_EXPORT_23.zip', 'Filesize': 1626479, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001666992020', 'Description': 'S4CORE105_INST_EXPORT_24.zip', 'Filesize': 989592, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001667002020', 'Description': 'S4CORE105_INST_EXPORT_3.zip', 'Filesize': 154, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001667012020', 'Description': 'S4CORE105_INST_EXPORT_4.zip', 'Filesize': 154, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001667022020', 'Description': 'S4CORE105_INST_EXPORT_5.zip', 'Filesize': 154, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001667032020', 'Description': 'S4CORE105_INST_EXPORT_6.zip', 'Filesize': 2177825, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001667052020', 'Description': 'S4CORE105_INST_EXPORT_7.zip', 'Filesize': 2738497, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001667062020', 'Description': 'S4CORE105_INST_EXPORT_8.zip', 'Filesize': 2203902, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001667072020', 'Description': 'S4CORE105_INST_EXPORT_9.zip', 'Filesize': 1598012, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0030000001665652020', 'Description': 'S4HANAOP105_ERP_LANG_AR.SAR', 'Filesize': 444070, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665662020', 'Description': 'S4HANAOP105_ERP_LANG_BG.SAR', 'Filesize': 394521, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665682020', 'Description': 'S4HANAOP105_ERP_LANG_CA.SAR', 'Filesize': 379145, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665692020', 'Description': 'S4HANAOP105_ERP_LANG_CS.SAR', 'Filesize': 648239, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665712020', 'Description': 'S4HANAOP105_ERP_LANG_DA.SAR', 'Filesize': 437244, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665632020', 'Description': 'S4HANAOP105_ERP_LANG_DE.SAR', 'Filesize': 272960, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665722020', 'Description': 'S4HANAOP105_ERP_LANG_EL.SAR', 'Filesize': 428898, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665642020', 'Description': 'S4HANAOP105_ERP_LANG_EN.SAR', 'Filesize': 498589, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665742020', 'Description': 'S4HANAOP105_ERP_LANG_ES.SAR', 'Filesize': 849374, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665752020', 'Description': 'S4HANAOP105_ERP_LANG_ET.SAR', 'Filesize': 282804, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665802020', 'Description': 'S4HANAOP105_ERP_LANG_FI.SAR', 'Filesize': 430154, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665852020', 'Description': 'S4HANAOP105_ERP_LANG_FR.SAR', 'Filesize': 839817, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665892020', 'Description': 'S4HANAOP105_ERP_LANG_HE.SAR', 'Filesize': 452704, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665962020', 'Description': 'S4HANAOP105_ERP_LANG_HI.SAR', 'Filesize': 730133, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665972020', 'Description': 'S4HANAOP105_ERP_LANG_HR.SAR', 'Filesize': 414036, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001665992020', 'Description': 'S4HANAOP105_ERP_LANG_HU.SAR', 'Filesize': 477177, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666042020', 'Description': 'S4HANAOP105_ERP_LANG_IT.SAR', 'Filesize': 765586, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666052020', 'Description': 'S4HANAOP105_ERP_LANG_JA.SAR', 'Filesize': 789319, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666062020', 'Description': 'S4HANAOP105_ERP_LANG_KK.SAR', 'Filesize': 718868, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666082020', 'Description': 'S4HANAOP105_ERP_LANG_KO.SAR', 'Filesize': 451150, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666092020', 'Description': 'S4HANAOP105_ERP_LANG_LT.SAR', 'Filesize': 289582, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666122020', 'Description': 'S4HANAOP105_ERP_LANG_LV.SAR', 'Filesize': 288675, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666142020', 'Description': 'S4HANAOP105_ERP_LANG_MS.SAR', 'Filesize': 332062, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666152020', 'Description': 'S4HANAOP105_ERP_LANG_NL.SAR', 'Filesize': 492036, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666172020', 'Description': 'S4HANAOP105_ERP_LANG_NO.SAR', 'Filesize': 422301, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666192020', 'Description': 'S4HANAOP105_ERP_LANG_PL.SAR', 'Filesize': 481707, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666212020', 'Description': 'S4HANAOP105_ERP_LANG_PT.SAR', 'Filesize': 792231, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666222020', 'Description': 'S4HANAOP105_ERP_LANG_RO.SAR', 'Filesize': 418082, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666242020', 'Description': 'S4HANAOP105_ERP_LANG_RU.SAR', 'Filesize': 508694, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666252020', 'Description': 'S4HANAOP105_ERP_LANG_SH.SAR', 'Filesize': 378237, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666272020', 'Description': 'S4HANAOP105_ERP_LANG_SK.SAR', 'Filesize': 465519, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666292020', 'Description': 'S4HANAOP105_ERP_LANG_SL.SAR', 'Filesize': 399392, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666322020', 'Description': 'S4HANAOP105_ERP_LANG_SV.SAR', 'Filesize': 434204, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666332020', 'Description': 'S4HANAOP105_ERP_LANG_TH.SAR', 'Filesize': 410497, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666342020', 'Description': 'S4HANAOP105_ERP_LANG_TR.SAR', 'Filesize': 448939, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666362020', 'Description': 'S4HANAOP105_ERP_LANG_UK.SAR', 'Filesize': 379844, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666372020', 'Description': 'S4HANAOP105_ERP_LANG_VI.SAR', 'Filesize': 720496, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666392020', 'Description': 'S4HANAOP105_ERP_LANG_ZF.SAR', 'Filesize': 418092, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0030000001666412020', 'Description': 'S4HANAOP105_ERP_LANG_ZH.SAR', 'Filesize': 597893, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000363342021', 'Description': 'SAP HOST AGENT 7.21 SP51', 'Filesize': 87193, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000703122018', 'Description': 'SAP IGS Fonts and Textures', 'Filesize': 61489, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001645292020', 'Description': 'SAP_UI 755: SP 0001', 'Filesize': 202303, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000149592021', 'Description': 'SP12 Patch3 for UMML4HANA 1', 'Filesize': 268, 'Infotype': 'ZIP'},
{'__metadata': {'Fastkey': '0010000000216182021', 'Description': 'SPAM/SAINT Update - Version 755/0077', 'Filesize': 9932, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001984822020', 'Description': 'ST-PI 740: SP 0014', 'Filesize': 8529, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0020000000451992021', 'Description': 'SWPM20SP08', 'Filesize': 164897, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001013272020', 'Description': 'UIAPFI70 800: Add-On Installation', 'Filesize': 265495, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000638612020', 'Description': 'UIBAS001 600: Add-On Installation', 'Filesize': 107187, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000019183952017', 'Description': 'UIHR002 100: Add-On Installation', 'Filesize': 2610, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000020421312017', 'Description': 'UIHR002 100: SP 0001', 'Filesize': 4383, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000493432018', 'Description': 'UIHR002 100: SP 0002', 'Filesize': 5328, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001141912018', 'Description': 'UIHR002 100: SP 0003', 'Filesize': 7399, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001934802018', 'Description': 'UIHR002 100: SP 0004', 'Filesize': 8819, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000045522019', 'Description': 'UIHR002 100: SP 0005', 'Filesize': 11104, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000464552019', 'Description': 'UIHR002 100: SP 0006', 'Filesize': 8851, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001273902019', 'Description': 'UIHR002 100: SP 0007', 'Filesize': 15356, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001810332019', 'Description': 'UIHR002 100: SP 0008', 'Filesize': 13415, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000341482020', 'Description': 'UIHR002 100: SP 0009', 'Filesize': 23241, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000979992020', 'Description': 'UIHR002 100: SP 0010', 'Filesize': 15356, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000696272016', 'Description': 'UIMDG001 200: Add-On Installation', 'Filesize': 19342, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000014298612017', 'Description': 'UIMDG001 200: SP 0002', 'Filesize': 21180, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000019125502017', 'Description': 'UIMDG001 200: SP 0003', 'Filesize': 19934, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000019849022017', 'Description': 'UIMDG001 200: SP 0004', 'Filesize': 9691, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000020421762017', 'Description': 'UIMDG001 200: SP 0005', 'Filesize': 16374, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000493392018', 'Description': 'UIMDG001 200: SP 0006', 'Filesize': 16371, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001935022018', 'Description': 'UIMDG001 200: SP 0007', 'Filesize': 10835, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000464372019', 'Description': 'UIMDG001 200: SP 0008', 'Filesize': 10736, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001029322016', 'Description': 'UIMDG001 200: Support Package 0001', 'Filesize': 15880, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001013212020', 'Description': 'UIS4HOP1 600: Add-On Installation', 'Filesize': 843021, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001909232018', 'Description': 'UITRV001 300: Add-On Installation', 'Filesize': 7934, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000045572019', 'Description': 'UITRV001 300: SP 0001', 'Filesize': 7423, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001273832019', 'Description': 'UITRV001 300: SP 0002', 'Filesize': 9986, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000001810452019', 'Description': 'UITRV001 300: SP 0003', 'Filesize': 8637, 'Infotype': 'SAR'},
{'__metadata': {'Fastkey': '0010000000341512020', 'Description': 'UITRV001 300: SP 0004', 'Filesize': 10244, 'Infotype': 'SAR'}] 

cnt     = 0
while cnt < len(results):
    r = results[cnt]
    assert("Description" in r and "Infotype" in r and "Fastkey" in r and "Filesize" in r), \
        "Result does not have all required keys (%s)" % (str(r))

    r["Filesize"]   = int(r["Filesize"])

    # Filter out packages that don't match  
    filtered_out = False
    for f in p.filter:
        if not eval(f):
        results.pop(cnt)
        filtered_out = True
        break
if not filtered_out:
    cnt += 1

if p.selector: result = results[eval(p.selector)]
print("%s\n" % (result))
basket.add_item(DownloadItem(
    id            = result["Fastkey"],
    desc          = result["Description"],
    size          = result["Filesize"],
    time          = basket.latest,
    base_dir      = download_dir,
    target_dir    = "Archives",
    skip_download = dryrun,
))

if len(basket.items) > 0:
    basket.filter_latest()
    basket.download_all()
