# 110m Hurdle Analysis

This project aims to utilize R and Julia to perform extensive analysis on data for professional 110m hurdle races. Analyses range from exploratory data analysis over machine learning to time-to-event analysis.

All code and data set is available in this Git for replication

## Data Set and Source

The data set is derived from Todd Henson (2023) and AthleteFirst (https://www.athletefirst.org). At this point: a big shout out to him for such an amazing collection of spring and hurdle data for both, men and women. This is truly an amazing data base and should be acknowledged properly.

!["Example of PDF table](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/PDF.png)

The data set was, unfortunately, only available in PDF version. The PDF seemed to consist of several HTML tables, for each competition. The data contained data about intervals (in seconds) and velocity (in m/s) for each hurdle. Additionally, the data set contained reaction time data (in s). Using R and extensive matching using regex, and moving columns the PDF table was cleaned and preprocessed. Only complete data was retained, and outliers above 4 standard deviation for the final racing time were excluded. This resulted in a data set of 1177 sprinters (albeit many repeating). 

## Exploratory Data Analysis

From here on out, Julia was utilized.

As first step, EDA was performed to get familiar with the data set. For example, the mean final time was 13.65 seconds, with the fastest time being the world record, set by Aries Merritt (USA) in 2012 with 12.80 seconds. The summary also shows that there is no missing data.

Making use of both main measurements, interval and velocity per hurdle, the first plots are time-series over hurdles.

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot.png)
![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot2.png)

As can be seen in the interval time-series, there is a sharp drop at the start of the race, followed by a very marginal increase in interval as the race progresses. Of note, the distance to the first hurdle is 13.72m, and subsequently it is 9.72m between each hurdle. 

Interestingly, the velocity time-series shows a steeper decline in velocity throughout the race, followed by a sharp incline for the final finish sprint. 

This graph inspired one of the main questions in this project: **which hurdles' velocities are critical for final time, and therefore, race performance?** 

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot3.png)
![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot4.png)
![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot5.png)

Additional scatterplots were created to investigate the relationship between the average interval and velocity as function of the final time. This is, unsurprisingly, a very linear relationship. Looking at the velocity vs. final time plot, it appears that there is a small group of athletes that exhibit slower velocities but similar times. It is believed these are U20 and U18 youth. These groups are running over lower hurdles (99cm & 91cm, respectively), as opposed to 1.07m for men. Therefore, while their velocity is not fully matured yet, their time can be as fast, or faster than the men.

Interestingly, reaction time only shows a small positive relationship with final time. This further suggests that it appears that the start of the race is not as decisive as the latter part.

Using histograms, the distribution of each feature was assessed, which points to quite normal distribution across every variable. 

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot6.png)

As final step in the EDA, a heat map was computed to show the correlation between each hurdles' velocities. This shows that the early hurdles are in fact not much correlated with the later hurdles. 

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot7.png)

## Random Forest Regression

In order to understand the relationship of the features on the final time for each race, a random forest regression was performed. This model was chosen due to its transparency and explainability, especially in relation to SHAP (SHapley Additive exPlanations) values, which show feature importance. The random forest regression had 120 trees, which was deemed optimal after trial and error with other values. Of note, within Julia, R was called to compute the model due to difficulty implementing it in Julia itself, upon which the predictions were exported back in to Julia.

Looking at the MSE (0.11), MAE (0.14), and R2 (71.59%), the model exhibits very good predictive performance.

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot8.png)

The actual vs. prediction plot shows a slot linear relationship, and it's only a few outliers that seemed tough to predict. It is believed that these are youth identified in the EDA. 

Diagnosing the regression performance using the residual histogram and residual plot, it appears that the histograms are decently normally distributed. 

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot9.png)

In R, the SHAP values were computed and subsequently a SHAP summary plot as well as a SHAP waterfall plot for the world-record race were computed to further evaluate the model and feature importances.

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/SHAP%20Summary.png)

The SHAP summary plot shows clearly that the latter hurdles are more important than the first few, in both measurements: interval and velocity. Interestingly, the reaction time is least predictive of final time, relative to the other features. Unsurprisingly, however, given the weak correlation between the two measurements. 

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot10.png)

When looking at the last four hurdles, it seems as there is a very linear relationship between interval and final time. 

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot11.png)

Also, when comparing the intervals for hurdle 7 with hurdle 2, it appears that hurdle 7 is more linear, and hurdle 2 a bit more harmonic in curvature. This further corroborates that the later hurdles are more critical in final time than earlier hurdles are.

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/SHAP%20Waterfall.png)

The SHAP waterfall plot shows the individual feature contributions on the predictions for the world record. Importantly, it seems that it is the velocity and interval for hurdles 7 and 8 are most critical, followed by hurdles 5 and 3. This plot therefore suggests that the velocity in the later hurdles were more critical for the world record.

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot12.png)
![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot13.png)

Additionally to the SHAP waterfall plot, when comparing the time series of velocity and interval of the world record race with the mean, it shows that there is a more consistent velocity across the hurdles. Although there is drop-off at some point, toward hurdle 8, the drop off occurs toward hurdle 5 already, on average. Similarly, the intervals are kept down for longer. 
While the world record is the world record for a reason, it is informative to compare the dynamics with the average, as it further suggests that the race is decided in the end. Further, the evidence becomes more and more clear that athletes should focus more on staying strong toward the end of the race, rather than exploding in the beginning and suffering a steeper drop-off during the later hurdles. 

## Time-To-Event Analysis

Using the idea of survival analysis, or time-to-event analysis, a Kaplan-Meier analysis was performed using a velocity drop of 3% for each interval as death variable here. While not fully valid as "death", because the athlete is still in the race, in terms of final time (and a possible PR or other records), a drop of 3% may be detrimental. Hence, the survival analysis may give interesting insights in race dynamics. Two were completed: time being hurdles, and time being final time.

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot14.png)

When investigating the survival analysis across the 10 hurdles, there certainly seems to be a steady drop-off in chance of not suffering a 3% velocity loss, but this chance reaches its minimum after hurdle 8. This suggests that hurdle 8 to 10 is very critical, as seen in the SHAP analysis already.

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot15.png)

Similarly, the chance of not suffering a 3% velocity drop decreases substantially with greater final time. This is unsurprising, yet still interesting that slower times also point to less consistent velocity over the intervals.

##Individual Athletes

Lastly, four of recent history's best athletes were picked and plotted over hurdles, to identify possible differences. The athletes picked were: Aries Merritt (USA), world record holder, Omar McLeod (JAM), Olympic champion from 2016, Grant Holloway (USA), Olympic champion from 2020, and Pascal Martinot-Lagarde (FRA), European champion from 2018. 

![](https://github.com/lucasweyrich958/HurdleAnalysis/blob/main/figures/plot16.png)

Comparing the individual lines, it is striking how much faster Holloway appears to be in the beginning of the race, but also the strong velocity drop he suffers toward the last third. On the other hand, Aries Merritt is the most consistent of the four. Since retired, perhaps that is why he still hold the world record to this day, since 2012?

## Conclusion

This project aimed to utilize several advanced analytical techniques to investigate the race dynamics of 110m hurdle races, using relatively easy-to-obtain measurements: interval between hurdles, velocity, and reaction time. The advantage of conducting such analysis with hurdles over a last 100m sprint is that the athletes always take a predictable amount of steps: 7 toward the first hurdle, then 3 between each. Additionally, the hurdle allows for a clear separation of intervals. 

The main finding of this is that it seems that, even though the last four hurdles are most critical in predicting final race time (and hence records and race placement), a velocity drop-off toward the end appears to be the norm. While a certain drop-off is expected, perhaps a focus on staying strong and consistent throughout the whole race could improve racing times. The current main consensus among hurdle coaching is explosiveness. From the get-go and over the hurdle. This makes sense; however, if the velocity drops down in the end, it does not matter how fast the athlete clears the hurdle. Hence, it may be worthwhile to explore an approach that includes "over-distance" practices, where 11 or 12 hurdles are placed in the 110m, which is repeatedly run. This allows the sprinter to stay stronger throughout 10 hurdles in the race.
