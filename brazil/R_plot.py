# -*- coding: utf-8 -*-
"""
Created on Thu Jun 25 20:41:48 2020

@author: Ana Paula
"""

import pandas as pd
import numpy as np
import os

from matplotlib import pyplot as plt
from matplotlib.dates import date2num, num2date
from matplotlib import dates as mdates
from matplotlib import ticker
from matplotlib import cm
from matplotlib.colors import ListedColormap
from matplotlib.patches import Patch

from scipy.interpolate import interp1d

from IPython.display import clear_output

from IPython import get_ipython
#when you want graphs in a separate window and
get_ipython().run_line_magic('matplotlib', 'qt') 

def plot_rt(result, ax, state_name):
    
    ax.set_title(f"{state_name}")
    
    palette=cm.get_cmap("RdBu_r")
    newcolors =palette(np.linspace(0, 1, 25))
    cmap = ListedColormap(newcolors)
   
    color_mapped = lambda y: np.clip(y, .5, 1.5)-.5
    
    index = result['ML'].index.get_level_values('date')
    values = result['ML'].values
    
    # Plot dots and line
    ax.plot(index, values, c='k', zorder=1, alpha=.25)
    ax.scatter(index,
               values,
               s=40,
               lw=.5,
               c=cmap(color_mapped(values)),
               edgecolors='k', zorder=2)
    
    # Aesthetically, extrapolate credible interval by 1 day either side
    lowfn = interp1d(date2num(index.to_pydatetime()),#date2num(index),
                     result['Low_95'].values,
                     bounds_error=False,
                     fill_value='extrapolate')
    
    highfn = interp1d(date2num(index.to_pydatetime()),#date2num(index),
                      result['High_95'].values,
                      bounds_error=False,
                      fill_value='extrapolate')
    
    extended = pd.date_range(start=pd.Timestamp('2020-03-01'),
                             end=index[-1]+pd.Timedelta(days=1))
    
    ax.fill_between(extended,
                    lowfn(date2num(extended.to_pydatetime())),#date2num(extended)
                    highfn(date2num(extended.to_pydatetime())),#date2num(extended)
                    color='k',
                    alpha=.1,
                    lw=0,
                    zorder=3)

    ax.axhline(1.0, c='k', lw=1, label='$R_t=1.0$', alpha=.25);
    
    # Formatting
    ax.xaxis.set_major_locator(mdates.MonthLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%b'))
    ax.xaxis.set_minor_locator(mdates.DayLocator())
    
    ax.yaxis.set_major_locator(ticker.MultipleLocator(1))
    ax.yaxis.set_major_formatter(ticker.StrMethodFormatter("{x:.1f}"))
    ax.yaxis.tick_right()
    ax.spines['left'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.margins(0)
    ax.grid(which='major', axis='y', c='k', alpha=.1, zorder=-2)
    ax.margins(0)
    ax.set_ylim(0.0, 5.0)
    ax.set_xlim(pd.Timestamp('2020-03-01'), result.index.get_level_values('date')[-1]+pd.Timedelta(days=1))
    fig.set_facecolor('w')


def plot_standings(mr, figsize=None):
    if not figsize:
        figsize = ((15.9/50)*len(mr)+.1,2.5)
        
    fig, ax = plt.subplots(figsize=figsize)

    ax.set_title(f'$R_t$ instantâneo por estado em {results.index[-1]:%d-%m-%y}')
    err = mr[['Low_95', 'High_95']].sub(mr['ML'], axis=0).abs()
    bars = ax.bar(mr.index,
                  mr['ML'],
                  width=.825,
                  color=FULL_COLOR,
                  ecolor=ERROR_BAR_COLOR,
                  capsize=2,
                  error_kw={'alpha':.5, 'lw':1},
                  yerr=err.values.T)
    
    labels = mr.index.to_series()

    ax.set_xticklabels(labels, rotation=90, fontsize=11)
    ax.margins(0)
    ax.set_ylim(0,3)
    ax.axhline(1.0, linestyle=':', color='k', lw=1)

    fig.set_facecolor('w')
    return fig, ax
##########################################
### Plotting the data from R EpiEstim calculation
##########################################
## BRAZIL
results = pd.read_csv("~/csv/R_bra_covid19.csv",
                     usecols=['date', 'mean','quant005', 'quant095'],
                     parse_dates=['date'],
                     index_col=['date'],
                     squeeze=True).sort_index()

results.rename(columns={'mean':'ML'}, inplace=True)

results.rename(columns={'quant005':'Low_95'}, inplace=True)

results.rename(columns={'quant095':'High_95'}, inplace=True)

fig, axes = plt.subplots()

plot_rt(results, axes, 'Brasil')

os.getcwd()
plt.savefig('~/png/BR_R0_instant.png',bbox_inches='tight')

##########################################
### Plotting the data from R EpiEstim calculation
##########################################
## STATES
results = pd.read_csv("~/csv/R_braState_covid19.csv",
                     usecols=['date', 'mean','quant005', 'quant095','estado'],
                     parse_dates=['date'],
                     index_col=['date'],
                     squeeze=True).sort_index()

results.rename(columns={'mean':'ML'}, inplace=True)

results.rename(columns={'quant005':'Low_95'}, inplace=True)

results.rename(columns={'quant095':'High_95'}, inplace=True)

ncols = 4
nrows = 7
fig, axes = plt.subplots(
    nrows=nrows,
    ncols=ncols,
    figsize=(14, nrows*3))

names=['AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS',
       'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC',
       'SE', 'SP', 'TO']
for ax, name in zip(axes.flat, names):
        plot_rt(results[results.estado==name], ax, name)

fig.tight_layout()
fig.set_facecolor('w')

os.getcwd()
plt.savefig('~/png/R0_instant.png',bbox_inches='tight')


mr=results.groupby("estado").last()
mr.sort_values('ML', inplace=True)


FULL_COLOR = [.7,.7,.7]
ERROR_BAR_COLOR = [.3,.3,.3]
plot_standings(mr);
os.getcwd()
plt.savefig('~/png/RT_estado_instantaneo.png',bbox_inches='tight')
