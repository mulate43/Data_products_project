# Data_products_project
##Files for the project for Developing Data Products course on Coursera 

This app uses the Michelson Speed of Light data. This is a classical 
             data of Michelson (but not this one with Morley) on measurements done 
             in 1879 on the speed of light. The data consists of five experiments, 
             each consisting of 20 consecutive ‘runs’. The response is the speed of 
             light measurement, suitably coded (km/sec, with 299000 subtracted) (copied 
             from R (data morley from the datasets package). With this app you can explore
             the fit from different methods and different experiments.
             You must choose first the experiment (default is 
             Average which represents the average of the five experiments), then you can
             choose the type of fit (Simple (y~x), Log (y~log(x)),
             Two level polynomial (y~poly(x,2)), Loess and no fit at all (default is no fit)).
             Finally you choose whathever or not you want confidence intervals in the plot (default is yes). 
             Once you define the inputs you can see in the panel the plot and summary 
             tabs; in the plot tab you can see a plot with the selected fit for experiment
             or experiments selected and the condifence intervals (or not) according
             to your choose. In the summary tab you see the summary of the model 
             according to your selections (this include the intercept, slope and 
             Adjusted R^2); when you choose Loess there's no information about the model
             and when you choose no fit, the summary is calculated with the summary
             function so you can see the mean, median, etc. "))
