#!/bin/python
import os
import sys
import csv
import pandas as pd
import numpy as np

def findMaxLen(l1):
    maxLen = 0
    for row in l1:
        if len(row) > maxLen:
            maxLen = len(row)
    return maxLen

def rowFixer(rowList):
    outRow = []
    for n in range(len(rowList)):
        outRow += rowList[n].split(";")
    return outRow


def main(argv):
    dataCSV = open(argv[1])
    data = list(csv.reader(dataCSV))

    # fix all the rows in the data
    for n in range(len(data)):
        data[n] = rowFixer(data[n])

    print("Creating Dataframe")
    outData = pd.DataFrame(index=range(len(data)), columns=range(findMaxLen(data)), dtype=str)


    print("Filling DataFrame")
    # for every row in data
    for y in range(len(data)):
        # for every column in the row
        for x in range(len(data[y])):
            outData.at[y, x] = data[y][x]

    print("Writting data")
    outData.to_csv("./../cleanData/Clean_" + argv[1][10:])





# Execution
main(sys.argv)
