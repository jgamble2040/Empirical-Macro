***********************************
*                                 *
*        WWS 593z PSET 3          *
*         JOELLE GAMBLE           *
*        October 9, 2018          *
*                                 *
***********************************


**Should I add the funds rate since Canada imports much of the US rate?
//CANADA SPECIFICATION
encode year, gen(t)
tsset t

//Determine number of lags
varsoc i pi u, maxlag(8)
*LR, FPE, AIC say eight lags. HQIC says seven.

//Run VAR
var i pi u, lags(1/7) dfk small

//Display variance-covariance matrix
matlist e(Sigma)
             |         i         pi          u 
-------------+---------------------------------
           i |  2.540417                       
          pi |  .8724329   1.958466            
           u | -.7020932  -.1461839   .5281799 
// Granger Causality Tests

quietly var i pi u, lags(1/7) dfk small
vargranger
*Cannot reject null on any specification
quietly regress u l(1/6).u l(1/6).i l(1/6).pi
test   l1.pi=l2.pi=l3.pi=0

test l1.i=l2.i=l3.i=l4.i=l5.i=l6.i=0

//Create and graph impulse response function
matlist e(Sigma)

quietly var pi u i, lags(1/7) dfk small

irf create var1, step(20) set(myirf) replace
irf graph oirf, impulse(pi u i) response(pi u i) 
        yline(0,lcolor(black)) xlabel(0(4)20) byopts(yrescale)



*Based on your estimation results, what is the optimal lag length for your VAR? 
*Which variables Granger-cause other variables? 
*What did you learn from your impulse response functions?
