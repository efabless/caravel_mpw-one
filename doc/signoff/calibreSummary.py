#!/usr/bin/env python3
# Copyright 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import re
import os

parser = argparse.ArgumentParser(
        description="Summarizes a Calibre summary report into a csv file.")

parser.add_argument("--targetPath", "-t", required=True,
                    help="Summaries Path. All .summary files inside that path and its subdirectories will be parsed")

parser.add_argument("--waivableList", "-w", required=False,
                    help="A file that contains white space separated list of waivable violations")

parser.add_argument("--outputDirectory", "-o", required=False,
                    help="Output Directory")

args = parser.parse_args()
summaryFolder = os.path.abspath(args.targetPath)
outputDirectory = args.outputDirectory
if outputDirectory is None:
    outputDirectory = summaryFolder

if not os.path.exists(outputDirectory):
    os.makedirs(outputDirectory)

waiveList=[]
if args.waivableList is not None:
    waivableListFileOpener = open(args.waivableList,"r")
    waiveList = waivableListFileOpener.read().split()
    waivableListFileOpener.close()

header = "RULE,Waivable,rule_letter,category,COUNT 1, COUNT 2\n"


mainOutputFile = outputDirectory+'/'+os.path.basename(summaryFolder)+'_merged.csv'

mainOutputFileOpener = open(mainOutputFile, "w+")
mainOutputFileOpener.write(header)
mainOutputFileOpener.close()


nonwaivableOutputFile = outputDirectory+'/'+os.path.basename(summaryFolder)+'_non_waivable.csv'

nonwaivableFileOpener = open(nonwaivableOutputFile, "w+")
nonwaivableFileOpener.write(header)
nonwaivableFileOpener.close()


def getListOfFiles(dirName):
    # create a list of file and sub directories
    # names in the given directory
    listOfFile = os.listdir(dirName)
    allFiles = list()
    # Iterate over all the entries
    for entry in listOfFile:
        # Create full path
        fullPath = os.path.join(dirName, entry)
        # If entry is a directory then get the list of files in this directory
        if os.path.isdir(fullPath):
            allFiles = allFiles + getListOfFiles(fullPath)
        else:
            allFiles.append(fullPath)
    return allFiles


def extractSummary(summaryFile):
    summaryFileOpener = open(summaryFile,"r")
    summaryContent = summaryFileOpener.read().split("\n")
    summaryFileOpener.close()
    rule_category=os.path.basename(os.path.dirname(summaryFile))
    outputFile = outputDirectory+'/'+rule_category+'.'+os.path.basename(summaryFile)+'.csv'

    splitter = "----------------------------------------------------------------------------------"
    ruleCheckString = "RULECHECK RESULTS STATISTICS"

    beginFlag = False

    outputFileOpener = open(outputFile, "w+")
    outputFileOpener.write(header)
    outputFileOpener.close()

    for line in summaryContent:
        if line.find(ruleCheckString) != -1:
            beginFlag = True

        if beginFlag:
            if line == splitter:
                break

            rule = re.findall(r'RULECHECK (\S+)\s*.*\s*TOTAL Result Count = (\d+)\s*\((\d+)\)', line)

            if len(rule) == 1:
                ruleName = rule[0][0]
                rk=ruleName[0]
                waivable= 'no'
                if ruleName in waiveList:
                    waivable='yes'
                elif int(rule[0][1]) + int(rule[0][2]) != 0:
                    nonwaivableFileOpener = open(nonwaivableOutputFile, "a+")
                    nonwaivableFileOpener.write(str(",".join((ruleName, waivable,rk,rule_category,rule[0][1],rule[0][2])))+'\n')
                    nonwaivableFileOpener.close()

                outputFileOpener = open(outputFile, "a+")
                outputFileOpener.write(str(",".join((ruleName, waivable,rk,rule_category,rule[0][1],rule[0][2])))+'\n')
                outputFileOpener.close()

                mainOutputFileOpener = open(mainOutputFile, "a+")
                mainOutputFileOpener.write(str(",".join((ruleName, waivable,rk,rule_category,rule[0][1],rule[0][2])))+'\n')
                mainOutputFileOpener.close()

files = getListOfFiles(summaryFolder)
for f in files:
    extension = os.path.splitext(f)[1]
    if extension == '.summary':
        extractSummary(f)
