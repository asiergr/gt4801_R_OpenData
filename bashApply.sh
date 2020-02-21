#!/bin/bash
find ./../data/ -maxdepth 1 -mindepth 1 -name "*.csv" | parallel python3 dataCleaner.py
