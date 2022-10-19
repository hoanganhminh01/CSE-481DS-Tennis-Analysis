import pandas as pd

START_YEAR = 2011

# 2011 - 2021 -> 10 years, ignore 2022 because only Wimbledon data is out
for year in range(11):
    current_year = START_YEAR + year
    print(current_year)
    filename = f"{current_year}-combined-matches.csv"

    ausopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-ausopen-matches.csv", low_memory=False)
    frenchopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-frenchopen-matches.csv", low_memory=False)
    usopen = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-usopen-matches.csv", low_memory=False)
    if current_year != 2020:
        wimbledon = pd.read_csv(f"../data/grand-slam-point-data/{current_year}-wimbledon-matches.csv", low_memory=False)

    grand_slams = [ausopen, frenchopen, usopen, wimbledon]
    result = pd.concat(grand_slams, axis=0)

    # Filter only men's singles matches
    result['match_id_num'] = result['match_id'].str.split('-').str[2]
    result['match_id_num'] = pd.to_numeric(result['match_id_num'], errors='coerce')
    result.drop(columns=result.columns[0], inplace=True, axis=1)
    result = result[result['match_id_num'] < 2000]
    result.to_csv(f"../data/grand-slam-point-data/combined-matches/{filename}")
