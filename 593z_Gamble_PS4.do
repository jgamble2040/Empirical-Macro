***********************************
*                                 *
*        WWS 593z PSET 4          *
*         JOELLE GAMBLE           *
*        October 16, 2018         *
*                                 *
***********************************


//Generate time variable
encode quarter, gen(t)
tsset t

//Summary statistics
*t=193
sum y pi credit reer m kal r
line pi r t, legend(size(medsmall))
line y credit t, legend(size(medsmall))
corr kal y
*international reserves are weakly, negatively correlated with real gdp growth

//First Specification: Paper replication\\ 
// Run lag-order selection tests.
varsoc y kal pi reer r m, maxlag(11)
*Lag 11 via LR. Suggested lag either 3 (FPE or AIC) or 2 (HQIC SBIC)

// run VAR
var y kal pi reer r m, lags(1/11) dfk small
var y kal pi reer r m, lags(1/2) dfk small

// View variance-covariance matrix.
matlist e(Sigma)

*11 lags
            |         y        kal         pi       reer          r          m 
-------------+------------------------------------------------------------------
           y |  5.020079                                                        
         kal | -30.35389   79901.08                                             
          pi | -.0091107  -6.277315   2.240045                                  
        reer |  2.142362  -23.83657   .8188741   23.92731                       
           r | -.0410126   .5365223  -1.934966  -1.082182   2.314055            
           m |  -.255137  -33.38626   -.108529  -.4025692   .0540405   10.05717 
		   
*2 lags   
             |         y        kal         pi       reer          r          m 
-------------+------------------------------------------------------------------
           y |  5.020079                                                        
         kal | -30.35389   79901.08                                             
          pi | -.0091107  -6.277315   2.240045                                  
        reer |  2.142362  -23.83657   .8188741   23.92731                       
           r | -.0410126   .5365223  -1.934966  -1.082182   2.314055            
           m |  -.255137  -33.38626   -.108529  -.4025692   .0540405   10.05717 



//Granger causality tests
quietly var y kal pi reer r m, lags(1/11) dfk small
vargranger
*Very few iterations are statistically significant.
*Few terms granger cause themselves or each other. Exception m-m m-exlpi m-exlr r-r
*Do I have coefficient bias due to a large number of lags?
quietly var y kal pi reer r m, lags(1/2) dfk small
vargranger
*With two lags, I found a specfication where all terms granger cause y when money growth is exlcuded.
*This makes the case for my proposed specification that includes credit growth but 
*excludes money growth

// View variance-covariance matrix.
matlist e(Sigma)

//Generate impulse response function
quietly var y kal pi reer r m, lags(1/2) dfk small
irf create var1, step(20) set(myirf) replace
irf graph oirf, impulse( y kal pi reer r m) response(y kal pi reer r m) yline(0,lcolor(black)) xlabel(0(4)20) byopts(yrescale)


//Second Specification: My specification\\ 

// Run lag-order selection tests.
varsoc y kal pi reer r credit, maxlag(11)
*Lag 11 via LR. Suggested lag either 5 (FPE or AIC) or 2 (HQIC SBIC)

// run VAR
var y kal pi reer r credit, lags(1/5) dfk small

// View variance-covariance matrix.
matlist e(Sigma)

             |         y        kal         pi       reer          r     credit 
-------------+------------------------------------------------------------------
           y |  3.651502                                                        
         kal |  21.31811   81409.94                                             
          pi | -.0555709   -14.3581      2.038                                  
        reer |  1.158948  -19.38366   .6184418   21.81327                       
           r |  .1777611    18.2533  -1.729136  -1.088814   2.127172            
      credit | -.7486591  -11.94639   .1817396   .1724581   -.121507   3.567993 
*NOTE: The change in sign on relationship between reserves and real gdp

//Granger causality tests
quietly var y kal pi reer r credit, lags(1/5) dfk small
vargranger
*For y equation reject null if inflation or credit are excluded. So, pi and credit
*Granger-cause real gdp growth.
*At this point credit growth matters more than capital controls.
// View variance-covariance matrix.
matlist e(Sigma)

//Generate impulse response function
quietly var y kal pi reer r credit, lags(1/5) dfk small
irf create var1, step(20) set(myirf) replace
irf graph oirf, impulse( ) response() yline(0,lcolor(black)) xlabel(0(4)20) byopts(yrescale)


