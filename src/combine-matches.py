import pandas as pd

START_YEAR = 2011

# 2011 - 2021 -> 10 years, ignore 2022 because only Wimbledon data is out
for year in range(12):
    current_year = START_YEAR + year
    print(current_year)
    filename = f"{current_year}-combined-matches.csv"

    if (current_year != 2022):
        ausopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-ausopen-matches.csv")
    if (current_year != 2022):
        frenchopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-frenchopen-matches.csv")
    if (current_year != 2022):
        usopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-usopen-matches.csv")
    if (current_year != 2020):
        wimbledon = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-wimbledon-matches.csv")

    grand_slams = [ausopen, frenchopen, usopen, wimbledon]
    result = pd.concat(grand_slams, axis=0)
    # print(ausopen)
    # print(frenchopen)
    # print(usopen)
    # print(wimbledon)
    # print(result)
    result.to_csv(f"../data/grand-slam-point-data/combined-matches/{filename}")