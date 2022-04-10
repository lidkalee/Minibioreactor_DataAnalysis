#!/bin/python3

# Import libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import datetime as DT
from datetime import timedelta
import parsedatetime
from pytimeparse import parse

# Define the function to preprocess data

def join_rawdata_and_metadata(rawdata_path, metadata_path, output_path = 'Bioscreen_output_table.csv'):
    '''
    Funkcja przekształca tabelę wyników Bioscreen - dodaje poprawne nazwy kolumn na podstawie 
    pliku csv z metadanymi oraz przekształca format kolumny 'Time'.
    Input:
        rawdata_path    str, sciezka do pliku z danymi
        metadata_path   str, sciezka do pliku z metadanymi (nazwy prob na plytce Bioscreen)
    Output:
        output_path     str, sciezka do pliku po przekształceniu 
    
    '''
    

    metadata = pd.read_csv(metadata_path, sep = ';')
    raw_results = pd.read_csv(rawdata_path, sep=',')
    column_names = pd.concat([metadata[col_name] for col_name in metadata.columns],ignore_index=True)

    results = raw_results.drop(['Time'], axis=1)
    if results.shape[1] == column_names.shape[0]:
        results.columns = column_names
    else: 
        results = results.iloc[: , :column_names.shape[0]]
        print('Tabela z metadanymi zawiera {} prób, a tabela z wynikami {} prób.\n Tabela z wynikami zawiera {} prób. \n Aby otrzymać pełną tabelę wyników, uzupełnij tabelę z metadanymi')

    time = raw_results['Time']
    for i in range(len(time)):
        time[i] = parse(time[i], '%H:%M:%S')
    time = time/3600.0
    results2= results.set_index(time)
    results2.to_csv(output_path)
    #if results.shape[1] >100:
