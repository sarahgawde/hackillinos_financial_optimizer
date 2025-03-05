import pandas as pd
from statsmodels.tsa.stattools import adfuller
from statsmodels.tsa.statespace.sarimax import SARIMAX

df = pd.read_excel('../data/bank.xlsx')
df['DATE'] = pd.to_datetime(df['DATE'])
df['WITHDRAWAL AMT'].fillna(0, inplace=True)
df_filtered = df[df['Account No'] == "409000611074\'"]
df_filtered = df_filtered[['DATE', 'WITHDRAWAL AMT']]
df_filtered.set_index('DATE',inplace=True)
df = df_filtered.groupby(df_filtered.index).sum()



def predict_spending(timeseries):
    timeseries = df['WITHDRAWAL AMT']
    result = adfuller(timeseries, autolag='AIC')
    print('ADF Statistic:', result[0])
    print('p-value:', result[1])

    # If the p-value is > 0.05, difference the data
    if adfuller(df['WITHDRAWAL AMT'], autolag='AIC')[1] > 0.05:
        df['WITHDRAWAL AMT'] = df['WITHDRAWAL AMT'].diff().dropna()

    # Fit SARIMA model
    model = SARIMAX(df['WITHDRAWAL AMT'], order=(1,1,1), seasonal_order=(1,1,1,60))
    results = model.fit()

    # Print model summary
    # print(results.summary())

    # Forecast next 30 days
    forecast = results.get_forecast(steps=30)
    forecast_mean = forecast.predicted_mean
    forecast_ci = forecast.conf_int()

    # Print the forecasted values
    # print("\nForecasted values for the next 30 days:")
    # print(forecast_mean)
    return forecast_mean.tolist()