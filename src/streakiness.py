import os
import sys
import hashlib
import pandas as pd

START_YEAR = 2021

# 2011 - 2021 -> 10 years, ignore 2022 because only Wimbledon data is out
for year in range(2):
    current_year = START_YEAR + year
    print(current_year)
    filename = f"{current_year}-combined-points.csv"

    if (current_year != 2022):
        ausopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-ausopen-points.csv")
    if (current_year != 2022):
        frenchopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-frenchopen-points.csv")
    if (current_year != 2022):
        usopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-usopen-points.csv")
    if (current_year != 2020):
        wimbledon = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-wimbledon-points.csv")

    grand_slams = [ausopen, frenchopen, usopen, wimbledon]
    result = pd.concat(grand_slams, axis=0)
    # print(ausopen)
    # print(frenchopen)
    # print(usopen)
    # print(wimbledon)
    # print(result)
    result.to_csv(f"../data/grand-slam-point-data/combined-points/{filename}")
