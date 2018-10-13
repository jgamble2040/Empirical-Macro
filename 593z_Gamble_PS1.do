***********************************
*                                 *
*        WWS 593z PSET 1          *
*         JOELLE GAMBLE           *
*        September 25, 2018       *
*                                 *
***********************************


// Download time series. Contains: quarterly investment, consumption, income variables
// for West Germany from 1960Q1-1982Q4.
webuse lutkepohl2

//Restrict Data to 1964Q1-1981Q4
drop if qtr < tq(1964q1)
drop if qtr > tq(1981q4)
*Consumption has a missing value.*

// Carry out Dickey-Fuller Tests for investment and consumption.

*DF Ha = stationary

//INVESTMENT//
dfuller ln_inv
//Critical value is -0.611. Fails test. Time series is non-stationary and at least I(1).
dfuller dln_inv
graph twoway scatter dln_inv qtr || lfit dln_inv qtr
//Critical value is -8.59. Reject null. Log Investment is I(1).

//CONSUMPTION//
dfuller ln_consump
//Critical value is -0.780. Fails test. Time series is non-stationary and at least I(1).
dfuller dln_consump
//Critical value is -9.059. Reject Null. Time series is non-stationary and at least I(1).

*DF Ha = stationary with deterministic time trend

//INVESTMENT//
dfuller ln_inv, trend
//Critical value is -1.751. Fails test. Time series is non-stationary and at least I(1).
dfuller dln_inv, trend
//Critical value is -8.522. Reject null. Log Investment is I(1).

//CONSUMPTION//
dfuller ln_consump, trend
//Critical value is -0.754. Fails test. Time series is non-stationary and at least I(1).
**What does it mean that adding a deterministic trend lessened the critical value?**
dfuller dln_consump, trend
//Critical value is -9.068. Reject null. Log Investment is I(1).

//Carry out augmented Dicket-Fuller Tests. These tests include lagged terms
*DF Ha = stationary

//INVESTMENT//
dfuller dln_inv, lags(4)
//Critical value is -2.356. Cannot reject null. Test has less power?
dfuller D.dln_inv, lags(4)
//Critical value is -4.294. Reject null. Series is I(2) which conflicts with I(1) of DF.
**Does augmented test have less power due to inclusion of lags? What are the perks?**

//CONSUMPTION//
dfuller dln_consump, lags(4)
//Critical value is -2.450. Cannot reject null.
dfuller D.dln_consump, lags(4)
//Critical value is -4.888. Reject null. Series is I(2) which conflicts with I(1) of DF.

*DF Ha = stationary with deterministic time trend

//INVESTMENT//
dfuller dln_inv, trend lags(4)
//Critical value is -2.304. Cannot reject null.
dfuller D.dln_inv, trend lags(4)
//Critical value is -4.296. Cannot reject null.

//CONSUMPTION//
dfuller dln_consump, trend lags(4)
//Critical value is -2.485
dfuller D.dln_consump, trend lags(4)
//Critical value is -4.819

//Carry out Philips-Perron test which accounts for serial correlation and heteroskedasticity
// in residual. The account for this non-parametrically using two estimators. 
//Auto-generates lags(3).

//INVESTMENT//
pperron ln_inv
//Z(t) is -0.621. Cannot reject null that it has a unit root. 
pperron dln_inv
//Z(t) is -8.609. Reject null that it has a unit root. Series is I(1).

//CONSUMPTION//
pperron ln_consump
//Z(t) is -0.720. Cannot reject null that it has a unit root. 
pperron dln_consump
//Z(t) is -9.086. Reject null that it has a unit root. Series is I(1).

//Carry out DF-GLS test which has more power than augmented Dickey-Fuller.
//The null hypothesis is a random walk with a possible drift with two specific 
//alternative hypotheses: the series is stationary around a linear time trend, 
//or the series is stationary around a possible nonzero mean with no time trend.
//This tesst controls for a linear time trend by default. THe GLS estimates the
//drift and linear trend first. Then, the unit root test is performed. This makes
//it easier for the test to distinguish between null and stationarity. This is useful
// if the coefficient is close to 1.

//INVESTMENT//
dfgls ln_inv, maxlag(4)
// Critical value with four lags is -3.933 and is at 1% level but other lags have too low values
**This conflicts with the findings of prior tests.
dfgls ln_inv, notrend
//If you assume stationary around a mean instead of a linear trend it fails to reject.
dfgls dln_inv, maxlag(4)
//Critical value is -2.28. Cannot reject null. This is odd.
dfgls D.dln_inv, maxlag(4)
//Critical values at 1 lag is -8.3. Can reject with 1 lag yet not with four.

//CONSUMPTION//
dfgls ln_consump, maxlag(4)
//Critical values at all lags low. At 4, -1.9. Fail to reject null. 
dfgls dln_consump, maxlag(4)
//Critical value at 1 lag is highest: -4.054. Reject null. Series is I(1).
dfgls D.dln_consump, maxlag(4)
//Critical values at 1 is highest: -5.07. Reject null.

//Carry out KPSS test
//HO = stationarity. Rejecting the null means series has unit root.
//Not rejecting the null does not mean stationarity. Series could be trend-stationary.

//INVESTMENT//
kpss ln_inv
//Critical value at zero lag is 0.4. Reject null. Series has unit root. Cannot reject for higher lags.
kpss dln_inv
//Highest critical value is 0.08. Cannot reject null. Series is trend stationary or stationary.

kpss ln_consump
//Critical value at zero lag is 0.787. Reject null. Series has unit root. Can reject for all lag counts.
kpss dln_consump
//Highest critical value is at 1 lag: 0.208. Reject null.
kpss D.dln_consump
//Critical values too low. Cannot reject null. Series is I(2).

//CONSUMPTION//
