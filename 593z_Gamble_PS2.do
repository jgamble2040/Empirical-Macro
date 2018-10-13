***********************************
*                                 *
*        WWS 593z PSET 2          *
*         JOELLE GAMBLE           *
*        September 25, 2018       *
*                                 *
***********************************

// Load Chow data and name variables.
*year = y
* relative price level = p
* real GDP = y
* real money supply = M2

//Goal: Replicate Chow_
*Set time variable and log terms
tsset year
gen ln_p = log(p)
gen ln_y = log(y)
gen ln_m2 = log(m2)
gen lnm2_y =log(m2) - log(y)
foreach var in ln_p ln_y ln_m2{

gen d`var' = `var'[_n]-`var'[_n-1]

}

//Unit Root Testing
*Augmented Dickey-Fuller
**Price**
dfuller ln_p, lags(4)
*Series has unit root
dfuller dln_p, lags(4)
*Series has unit root
dfuller D.dln_p, lags(4)
*Series is I(2)

**Nominal GDP**
dfuller ln_y, lags(4)
*Series has unit root
dfuller dln_y, lags(4)
*Series is I(1)

**Money**
dfuller ln_m2, lags(4)
*Series has unit root
dfuller dln_m2, lags(4)
*Series has unit root
dfuller D.dln_m2, lags(4)
*Series is I(2)

*DF-GLS
**Price**
dfgls ln_p, maxlag(4)
*Series has unit root. Test stat is only -1.6.
dfgls dln_p, maxlag(4)
*Series has unit root. Test stat is only -2.1. Except it's -4 at 1 lag due to test power.
*At 1 lag, series is I(1)
dfgls D.dln_p, maxlag(4)
*Series is squarely stationary and I(2)

**Nominal GDP**
dfgls ln_y, maxlag(4)
*Series has unit root. At lag 4, stat is -1.3
dfgls dln_y, maxlag(4)
*Series is I(1) at 3 lags. Test stat is -3.8
dfgls D.dln_y, maxlag(4)
*Series is squarely stationary and I(2)

**Money**
dfgls ln_m2, maxlag(4)
*Series has unit root. At lag 4, stat is -1.5
dfgls dln_m2, maxlag(4)
*Series has unit root. At lag 1, stat is -2.6
dfgls D.dln_m2, maxlag(4)
*Series is squarely stationary and is definitely I(2)

*KPSS
**Price**
kpss ln_p
*Reject null. Series is non-stationary
kpss dln_p
*At some lags, reject null. At others, series is stationary.
kpss D.dln_p
*Cannot reject null. series is stationary.

**Nominal GDP**
kpss ln_y
*Reject null. Series is non-stationary
kpss dln_y
*Cannot reject null. Series is stationary.
kpss D.dln_y
*Series is stationary.

**Money**
kpss ln_m2
*Reject null. Series is non-stationary
kpss dln_m2
*At some lags, reject null. At others, series is stationary.
kpss D.dln_m2
*Cannot reject null. series is stationary.

//Cointegration: Johansen
vecrank p y m2, lags(5)
*Max rank is 2. Two cointegrating vectors. Trace statistic is 2.6 and critical value is 3.76.
vecrank ln_p lnm2_y, lags(5)
*Max rank is 0 at 5%. So, there are no cointegrating vectors. Paper only rejected at 10%

//Cointegration: Engle-Granger
reg ln_p lnm2_y
*You get same values as the paper. B0 = -0.7 B1 = 0.368
predict residual, res
line residual year, title(Residuals vs. year)
dfuller residual, lags(5)
*Residual has unit root. So, series is not cointegrated.

*Alternatively.
egranger ln_p lnm2_y, lags(2)
*Cannot reject null. Thus, series is not cointegrated.

//Conclusion is that this model has high parameter stability.


