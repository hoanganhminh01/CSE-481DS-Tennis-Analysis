####Code to analyse tennis shot by shot data. Gives odds ratios, and regressions######
#Written by David Harris 23/01/2018#
#load packages
library(readr)
library(dotwhisker)
library(dplyr)
library(questionr)
library(ggplot2) 
library(stringr)
library(psycho)
library(DescTools)
library(sjstats)
library(emmeans)
#set working directory
setwd("~/")
#load data
combined2011 <- read_csv("2011-combined-points.csv")
combined2012 <- read_csv("2012-combined-points.csv")
combined2013 <- read_csv("2013-combined-points.csv")
combined2014 <- read_csv("2014-combined-points.csv")
combined2015 <- read_csv("2015-combined-points.csv")
combined2016 <- read_csv("2016-combined-points.csv")
combined2017 <- read_csv("2017-combined-points.csv")
combined2018 <- read_csv("2018-combined-points.csv")
combined2019 <- read_csv("2019-combined-points.csv")
combined2020 <- read_csv("2020-combined-points.csv")
combined2021 <- read_csv("2021-combined-points.csv")

#correct a couple errors so the data will join ####### folded for neatness
for (i in 1:1) {
  combined2017$PointNumber[1]<-0
  combined2017$PointNumber[2]<-0
  combined2017$PointNumber <- as.numeric(combined2017$PointNumber)
  
  combined2018$PointNumber[1]<-0
  combined2018$PointNumber[2]<-0
  combined2018$PointNumber <- as.numeric(combined2018$PointNumber)
  
  combined2019$PointNumber[1]<-0
  combined2019$PointNumber[2]<-0
  combined2019$PointNumber <- as.numeric(combined2019$PointNumber)
  
  combined2020$PointNumber[1]<-0
  combined2020$PointNumber[2]<-0
  combined2020$PointNumber <- as.numeric(combined2020$PointNumber)
  
  combined2021$PointNumber[1]<-0
  combined2021$PointNumber[2]<-0
  combined2021$PointNumber <- as.numeric(combined2021$PointNumber)
  
}

myfunc <- function(input){  #to select only relevant columns
  select(input, match_id, SetNo, P1GamesWon, P2GamesWon, GameNo,
         GameWinner, PointNumber, PointWinner, PointServer, P1Score, P2Score, 
         P1Winner, P2Winner, P1DoubleFault, P2DoubleFault, P1UnfErr, P2UnfErr,
         P1BreakPoint, P2BreakPoint)
}

#select the relevant variable and join tables together ####### folded for neatness
for (j in 1:1){ 
  combined2011 <- myfunc(combined2011)
  combined2012 <- myfunc(combined2012)
  combined2013 <- myfunc(combined2013)
  combined2014 <- myfunc(combined2014)
  combined2015 <- myfunc(combined2015)
  combined2016 <- myfunc(combined2016)
  combined2017 <- myfunc(combined2017)
  combined2018 <- myfunc(combined2018)
  combined2019 <- myfunc(combined2019)
  combined2020 <- myfunc(combined2020)
  combined2021 <- myfunc(combined2021)
  
  alldata <- full_join(combined2011, combined2012)
  alldata <- full_join(alldata, combined2013)
  alldata <- full_join(alldata, combined2014)
  alldata <- full_join(alldata, combined2015)
  alldata <- full_join(alldata, combined2016) 
  alldata <- full_join(alldata, combined2017) 
  alldata <- full_join(alldata, combined2018)
  alldata <- full_join(alldata, combined2019)
  alldata <- full_join(alldata, combined2020)
  alldata <- full_join(alldata, combined2021)
 
}

data <- as.data.frame(alldata)
rm(combined2011, combined2012, combined2013, combined2014, combined2015, combined2016, combined2017, combined2018, combined2019, combined2020, combined2021, alldata) #clear workspace


#all score labels are 1 row down so....
tempP1values<-as.data.frame(data$P1Score)
toadd<-as.data.frame(data$P1Score[1])
toadd <- rename(toadd, 'data$P1Score'='data$P1Score[1]') #make names match
tempP1values <- rbind(toadd, tempP1values)
tempP1values <- (tempP1values[-c(nrow(tempP1values)), ])

tempP2values<-as.data.frame(data$P2Score)
toadd<-as.data.frame(data$P2Score[1])
toadd <- rename(toadd, 'data$P2Score'='data$P2Score[1]') #make names match
tempP2values <- rbind(toadd, tempP2values)
tempP2values <- (tempP2values[-c(nrow(tempP2values)), ])

#add both to main data frame
data$P1Score <- tempP1values
data$P2Score <- tempP2values

#Find rows with an NA
data[data=='NA'] <- NA #make sure NA not as character
miss.vals <- sum(is.na(data))  #count NAs in data
texta<- "There are"
textb<- "missing values"
print(paste(texta,miss.vals,textb))  #print out to console
rm(texta)
rm(textb)

data <- filter(data, !is.na(P1GamesWon))
data <- filter(data, !is.na(SetNo)) %>%    #remove NA rows
        filter(!is.na(GameNo)) %>%  #pipe
        filter(!is.na(match_id))
#add others that may contain NAs

####Find if men's or women's match
tournament <- substr(data$match_id, start=1, stop=8)
gender <- as.numeric(str_sub(data$match_id, -4, -4))
match <- as.numeric(str_sub(data$match_id, -4, -1))
match <- as.data.frame(match)
#add to data
data <- mutate(data, tournament=tournament, gender=gender)
    

#######Find the errors#######
##Defined as as unforced error, a double fault if serving....
#Do separatately for each player
P1Errors <- rep(0, length(data$SetNo)) #preallocate vector of zeros
#loop to find errors
for (i in 1:length(data$SetNo)) {
  if  ((data$P1UnfErr[i] == 1) | (data$P1DoubleFault[i] == 1)) 
  {
    P1Errors[i]<-1
  }
  
} 
rm(i)

#For P2
P2Errors <- rep(0, length(data$SetNo)) #preallocate vector of zeros
#loop to find errors
for (j in 1:length(data$SetNo)) {
  if  ((data$P2UnfErr[j] == 1) | (data$P2DoubleFault[j] == 1)) 
  {
    P2Errors[j]<-1
  }
  
} 
rm(j)

######Score the pressure#######
#for P1
P1pressure <- rep(0, length(data$SetNo))

for (h in 1:length(data$SetNo)){
  #if late in the game
  if (((identical(data$P1Score[h-1], '30')) | (identical(data$P1Score[h-1], '40')) |
           (identical(data$P1Score[h-1], 'AD'))) & ((identical(data$P2Score[h-1], '30')) | 
           (identical(data$P2Score[h-1], '40')) |  (identical(data$P2Score[h-1], 'AD')))){
    P1pressure[h] <- P1pressure[h]+1        #add 1
  }
  #if opponent about to win the set, and you are behind
  if ((data$P2GamesWon[h] >= 5) & (data$P1GamesWon[h] < data$P2GamesWon[h])){       
    P1pressure[h] <- P1pressure[h]+1        #add 1  
  }      
  #if deciding set
  if (((data$SetNo[h] == 3) & (data$gender[h] == 2)) | ((data$SetNo[h] == 5) & (data$gender[h] == 1))){
    P1pressure[h] <- P1pressure[h]+1
  }      
  #if facing a game point
  if (((identical(data$P2Score[h-1], 'AD')) & ((identical(data$P1Score[h-1], 'AD'))==FALSE))  | 
      ((identical(data$P2Score[h-1], '40')) & 
       ((identical(data$P1Score[h-1], '30')) | (identical(data$P1Score[h-1], '15')) | (identical(data$P1Score[h-1], '0'))))
      ){
    P1pressure[h] <- P1pressure[h]+1
  }      
  #if facing break point
  if (data$P2BreakPoint[h] == 1){
    P1pressure[h] <- P1pressure[h]+1
  }      
  
}
rm(h)

#for P2
P2pressure <- rep(0, length(data$SetNo))

for (k in 1:length(data$SetNo)){
  #if late in the game
  if (((identical(data$P2Score[k-1], '30')) | (identical(data$P2Score[k-1], '40')) |
       (identical(data$P2Score[k-1], 'AD'))) & ((identical(data$P1Score[k-1], '30')) | 
       (identical(data$P1Score[k-1], '40')) |  (identical(data$P1Score[k-1], 'AD')))){
    P2pressure[k] <- P2pressure[k]+1        #add 1
  }
  #if opponent about to win the set, and you are behind
  if ((data$P1GamesWon[k] >= 5) & (data$P2GamesWon[k] < data$P1GamesWon[k])){       
    P2pressure[k] <- P2pressure[k]+1        #add 1  
  }      
  #if deciding set
  if (((data$SetNo[k] == 3) & (data$gender[k] == 2)) | ((data$SetNo[k] == 5) & (data$gender[k] == 1))){
   P2pressure[k] <- P2pressure[k]+1
  }      
  #if facing game point
  if (((identical(data$P1Score[k-1], 'AD')) & ((identical(data$P2Score[k-1], 'AD'))==FALSE))  | 
      ((identical(data$P1Score[k-1], '40')) & 
       ((identical(data$P2Score[k-1], '30')) | (identical(data$P2Score[k-1], '15')) | (identical(data$P2Score[k-1], '0'))))
  ){
    P2pressure[k] <- P2pressure[k]+1
  }      
  #if facing break point
  if (data$P1BreakPoint[k] == 1){
    P2pressure[k] <- P2pressure[k]+1
  }      
  
}
rm(k)

########Append P1 to P2#########
#remove rows that are 0-0, ie before a point
filter.col <- rep(FALSE, length(data$P1Score))
for (l in 1:length(data$P1Score)){
  filter.col[l] <- (identical(data$P1Score[l], '0')) & (identical(data$P2Score[l], '0'))
}
P1Errors <- as.data.frame(P1Errors)
P2Errors <- as.data.frame(P2Errors)
P1pressure <- as.data.frame(P1pressure)
P2pressure <- as.data.frame(P2pressure)
filter.col <- as.data.frame(filter.col) 
P1Winner <- as.data.frame(data$P1Winner)
P2Winner <- as.data.frame(data$P2Winner)
P1PointWon <- as.data.frame(data$PointWinner == 1)
P2PointWon <- as.data.frame(data$PointWinner == 2)

set <- as.data.frame(pp<-c(P1Errors, P2Errors, P1pressure, P2pressure, P1Winner, P2Winner, P1PointWon, P2PointWon, filter.col, match)) 
set <- mutate(set, tournament=tournament, gender=gender)%>%
 filter(filter.col==FALSE) #removes rows that were 0-0 (i.e. no preceding point)

###loop to find point preceded by an error
#Player 1
P1.post.error <- rep(3, length(set$P1Errors)) #preallocate 3s which allows removal after 
for (m in 2:length(set$P1Errors)) {
  if ((set$P1Errors[m-1]==1) & (set$match[m]==set$match[m-1])){
    P1.post.error[m] <- 1
  }
  
}
rm(m)

#find plays immediately preceded by a success and in the same match
for (n in 2:length(set$P1Errors)) {
  if ((set$P1Errors[n-1]==0) & (set$match[n]==set$match[n-1])){
    P1.post.error[n] <- 0
  }
  
}
rm(n)
#Player 2
P2.post.error <- rep(3, length(set$P2Errors)) #preallocate
for (o in 2:length(set$P2Errors)) {
  if ((set$P2Errors[o-1]==1) & (set$match[o]==set$match[o-1])){
    P2.post.error[o] <- 1
  }
  
}
rm(o)

for (p in 2:length(set$P2Errors)) {
  if ((set$P2Errors[p-1]==0) & (set$match[p]==set$match[p-1])){
    P2.post.error[p] <- 0
  }
  
}
rm(p)

#add to data frame
P1.post.error <- as.data.frame(P1.post.error)
P2.post.error <- as.data.frame(P2.post.error)
set <- bind_cols(set, P1.post.error, P2.post.error)

#chop rows with 3 in p1 or p2 post error
set <- filter(set, !P1.post.error==3) #effectively removes the first point

set$match2 <- set$match
set$P1code <- set$match+10000
set$P2code <- set$match+20000
set$tournament2 <- set$tournament #so 2 columns for stacking
set$gender2 <- set$gender #so 2 columns for stacking

#stack variables
a<-stack(select(set, P1Errors, P2Errors))
b<-stack(select(set, P1pressure, P2pressure))
c<-stack(select(set, P1.post.error, P2.post.error))
d<-stack(select(set, match, match2))
e<-stack(select(set, P1code, P2code))
f<-stack(select(set, tournament, tournament2))
g<-stack(select(set, gender, gender2))
h<-stack(select(set, data.P1Winner, data.P2Winner))
i<-stack(select(set, data.PointWinner....7, data.PointWinner....8))

#combine into final set
final.set<-bind_cols(a, b, c, d, e, f, g, h, i) %>%
  select(values...1, values...3, values...5, values...7, values...9, values...11, values...13, values...15, values...17) %>%
  rename(Made.error=values...1, Pressure=values...3, Post.error=values...5, matchID=values...7, playerID=values...9, tournament=values...11, gender=values...13, winners=values...15, point.won=values...17)

#combine last two columns because last one is too sparse
final.set$Pressure[final.set$Pressure == "5"] <- "4" 

######clear out environment###########
rm(a,b,c,d,e,f,g,h)
rm(P1.post.error, P1Errors, P1pressure, P2.post.error, P2Errors, P2pressure)
#coerce data types
final.set$Made.error <- as.numeric(final.set$Made.error)
final.set$Pressure <- as.factor(final.set$Pressure)
final.set$Post.error <- as.factor(final.set$Post.error)
final.set$matchID <- as.factor(final.set$matchID)
final.set$playerID <- as.factor(final.set$playerID)
final.set$tournament <- as.factor(final.set$tournament)
final.set$gender <- as.factor(final.set$gender)
final.set$Pressure <- as.factor(final.set$Pressure)


#===============================================================================
################# LMMs  #####################################################
#mixed effects model form 
library(lme4)
library(sjPlot)
int_model_full2 <- glmer(Made.error ~ Pressure * Post.error
                         + (1 | playerID),
                         data = final.set,
                         family=binomial(link = "logit"),
                         # glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 100000)),
                         na.action = "na.omit") 

int_model_full3 <- glmer(winners ~ Pressure * Post.error
                            + (1 | playerID),
                            data = final.set,
                  family=binomial(link = "logit"),
                 # glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 100000)),
                            na.action = "na.omit") 
##rePCA analysis
PCAanalysis <- rePCA(int_model_full3)
summary(PCAanalysis)
#how many principal components? can it be simplified? Are they all explaining additional variance

#####reporting stuff#######
summary(int_model_full2)
tab_model(int_model_full3)
anova(int_model_full3)
anova_stats(int_model_full3)
library(report)
#report(int_model_full2)
#odds.ratio(int_model_full2)
library(effects)
plot(allEffects(int_model_full2))
plot(allEffects(int_model_full3))

#pairwise comaprisons
library(lsmeans)
emm_options(pbkrtest.limit = 516) #3516
lsmeans(int_model_full2, pairwise~Pressure*Made.error, adjust="none")
p.adjust(c(.0001, .0001, .0001, .0001, .0001, .0001, .0001, .0001, .025, .803), method="holm")

########################for graphs
a4<-subset(final.set, Pressure==4)
a4E<-subset(a4, Post.error=='1')
a4nE<-subset(a4, Post.error=='0')

a3<-subset(final.set, Pressure==3)
a3E<-subset(a3, Post.error=='1')
a3nE<-subset(a3, Post.error=='0')

a2<-subset(final.set, Pressure==2)
a2E<-subset(a2, Post.error=='1')
a2nE<-subset(a2, Post.error=='0')

a1<-subset(final.set, Pressure==1)
a1E<-subset(a1, Post.error=='1')
a1nE<-subset(a1, Post.error=='0')

a0<-subset(final.set, Pressure==0)
a0E<-subset(a0, Post.error=='1')
a0nE<-subset(a0, Post.error=='0')

mean(as.numeric(a4$Made.error))
sd(as.numeric(a4$Made.error))

mean(as.numeric(a0nE$winners))
sd(as.numeric(a0nE$winners))


