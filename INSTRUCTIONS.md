## The Most Alarming Weather Events
*Shiny Application and Reproducible Pitch*

*This is a project for* **Developing Data Products** *course, which is a part of Coursera’s* **Data Science** *and* **Data Science: Statistics and Machine Learning** *Specializations*. It consists of Shiny Application *[StormApp](http://kuba-ee.shinyapps.io/StormApp/)*, reactively calculating the most dangerous weather events based on [NOAA Storm Events Database](http://www.ncdc.noaa.gov/stormevents/choosedates.jsp?statefips=-999%2CALL), and Reproducible Pitch [Presentation](http://rpubs.com/kuba-ee/699405) with some details about the project.

### Subject
NOAA has been collecting data on most massive storms and other severe weather events in the US since 1950. These phenomena harm people causing deaths and injuries, and damage economics, that is property and crops.

For calculations, *StormApp* uses *Storm Events Database* observations from 1950 to 2011 with a total of 48 types of events monitored (now there are 51 types). According to input parameters specified by a user, *StormApp* displays ordered data plots/ tables of dangers to humans and economics.

### How to use the *StormApp*

- **Plots tab**
    + *Harm to Humans*: select "Total Harm"/ "Deaths Dangers"/ "Injuries Dangers" for the *StormApp* to display a plot of Top-10 Dangers to Humans in the corresponding category.        
    + *Damage to Economics*: select "Total Damage"/ "Dangers to Property"/ "Dangers to Crops" and click the "Update Plot" button. The *StormApp* then shows a plot of Top-10 Dangers to Economics in the corresponding category.
- **Tables tab**
Select "Top-10"/ "Top-20"/ "All-48" for the *StormApp* to display the most 10/ 20 dangers, or a list of all 48 severe weather events sorted by danger, respectively.