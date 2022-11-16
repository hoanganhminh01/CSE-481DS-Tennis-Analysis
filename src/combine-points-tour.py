import pandas as pd

grand_slams = ["ausopen", "frenchopen", "usopen", "wimbledon"]
# 2011 - 2021 -> 10 years, ignore 2022 because only Wimbledon data is out
for tour in grand_slams:
    print(tour)

    tour_2011 = pd.read_csv(f"../data/grand-slam-point-data/2011-{tour}-points.csv", low_memory=False)
    tour_2012 = pd.read_csv(f"../data/grand-slam-point-data/2012-{tour}-points.csv", low_memory=False)
    tour_2013 = pd.read_csv(f"../data/grand-slam-point-data/2013-{tour}-points.csv", low_memory=False)
    tour_2014 = pd.read_csv(f"../data/grand-slam-point-data/2014-{tour}-points.csv", low_memory=False)
    tour_2015 = pd.read_csv(f"../data/grand-slam-point-data/2015-{tour}-points.csv", low_memory=False)
    tour_2016 = pd.read_csv(f"../data/grand-slam-point-data/2016-{tour}-points.csv", low_memory=False)
    tour_2017 = pd.read_csv(f"../data/grand-slam-point-data/2017-{tour}-points.csv", low_memory=False)
    tour_2018 = pd.read_csv(f"../data/grand-slam-point-data/2018-{tour}-points.csv", low_memory=False)
    tour_2019 = pd.read_csv(f"../data/grand-slam-point-data/2019-{tour}-points.csv", low_memory=False)
    tour_2020 = pd.read_csv(f"../data/grand-slam-point-data/2020-{tour}-points.csv", low_memory=False)
    tour_2021 = pd.read_csv(f"../data/grand-slam-point-data/2021-{tour}-points.csv", low_memory=False)

    years = [tour_2011, tour_2012, tour_2013, tour_2014, tour_2015, tour_2016, tour_2017, tour_2018, tour_2019, tour_2020, tour_2021]
    result = pd.concat(years, axis=0)
    filename = f"{tour}-combined-points.csv"

    # Filter only men's singles matches

    result['match_id_num'] = result['match_id'].str.split('-').str[2]
    result['match_id_num'] = pd.to_numeric(result['match_id_num'], errors='coerce')
    result = result[result['match_id_num'] < 2000]
    result.to_csv(f"../data/grand-slam-point-data/combined-points-tour/{filename}")