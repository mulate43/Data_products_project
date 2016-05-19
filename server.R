#Simple Analysis on Michelson Speed of Light Data

#This app uses the Michelson Speed of Light data. This is a classical 
#data of Michelson (but not this one with Morley) on measurements done 
#in 1879 on the speed of light. The data consists of five experiments, 
#each consisting of 20 consecutive 'runs'. The response is the speed of 
#light measurement, suitably coded (km/sec, with 299000 subtracted) (copied 
#from R (data morley from the datasets package).

#Load the require packages
library(shiny)
library(datasets)
library(ggplot2)
library(data.table)

#Load the data from datasets package
data(morley)

#Define the data as data.table, so the management could be more efficient
morley<-as.data.table(morley)

#Create the Average with the average of the five experiments
morley<-rbind(data.table(Expt=rep("Average"),morley[,list(Speed=mean(Speed)),by=c("Run")]),
              morley)

#Define the calculations within the app to obtain an output
shinyServer(function(input, output) {
        
        #Make the plot
        output$plot <- renderPlot({
                
                #Define the data as x (according to the experiment selected)
                x<-morley[Expt%in%input$exp]
                
                #Change the name for the columns
                colnames(x)<-c("Experiment","Run","Speed (km/sec)")
                
                #Define column Experiment as factor
                x$Experiment<-as.factor(x$Experiment)
                
                #Make the plot according to the inputs selected
                if (input$CI=="Yes"){
                        if (input$reg=="Simple (y~x)"){
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=lm,formula=y~x,se=T)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="Log (y~log(x))") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=lm,formula=y~log(x),se=T)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="Two level polynomial (y~poly(x,2))") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=lm,formula=y~poly(x,2),se=T)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="Loess") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=loess,se=T)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="No fit") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_point()+
                                        theme(text=element_text(size=15))
                        }
                } else {
                        if (input$reg=="Simple (y~x)"){
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=lm,formula=y~x,se=F)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="Log (y~log(x))") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=lm,formula=y~log(x),se=F)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="Two level polynomial (y~poly(x,2))") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=lm,formula=y~poly(x,2),se=F)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="Loess") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_smooth(method=loess,se=F)+
                                        theme(text=element_text(size=15))
                        } else if (input$reg=="No fit") {
                                ggplot(x,aes(x=Run,y=`Speed (km/sec)`,colour=Experiment))+
                                        geom_point()+
                                        theme(text=element_text(size=15))
                        }
                }
                
                
        })
        
        #Create the summary
        output$summary <- renderTable({
                
                #Define the data as x (according to the experiment selected)
                x<-morley[Expt%in%input$exp]
                
                #Change the name for the columns
                colnames(x)<-c("Experiment","Run","Speed (km/sec)")
                
                #Define column Experiment as factor
                x$Experiment<-as.factor(x$Experiment)
                
                #Make the summary table according to the inputs selected
                if (input$reg=="Simple (y~x)"){
                        AN<-by(x,x$Experiment,
                               function(y)summary(lm(`Speed (km/sec)`~Run,data=y)))
                        int<-data.table(Intercept=sapply(AN,function(y)y$coefficients[1]))
                        sl<-data.table(Slope=sapply(AN,function(y)y$coefficients[2]))
                        rs<-data.table(`Adjusted R-squared`=sapply(AN,function(y)y$adj.r.squared))
                        data.table(Experiment=input$exp,int,sl,rs)
                } else if (input$reg=="Log (y~log(x))") {
                        AN<-by(x,x$Experiment,
                               function(y)summary(lm(`Speed (km/sec)`~log(Run),data=y)))
                        int<-data.table(Intercept=sapply(AN,function(y)y$coefficients[1]))
                        sl<-data.table(Slope=sapply(AN,function(y)y$coefficients[2]))
                        rs<-data.table(`Adjusted R-squared`=sapply(AN,function(y)y$adj.r.squared))
                        data.table(Experiment=input$exp,int,sl,rs) 
                } else if (input$reg=="Two level polynomial (y~poly(x,2))") {
                        AN<-by(x,x$Experiment,
                               function(y)summary(lm(`Speed (km/sec)`~poly(Run,2),data=y)))
                        int<-data.table(Intercept=sapply(AN,function(y)y$coefficients[1]))
                        sl<-data.table(Slope=sapply(AN,function(y)y$coefficients[2]))
                        rs<-data.table(`Adjusted R-squared`=sapply(AN,function(y)y$adj.r.squared))
                        data.table(Experiment=input$exp,int,sl,rs)  
                } else if (input$reg=="No fit") {
                     summary(x)   
                }
        })
        
})



