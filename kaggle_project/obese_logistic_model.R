#ok load the libraries
library(tidyverse)

#ok lets import the training datasets
train_part<-as_tibble(read.csv("data/train_participant_data(trainset).csv",header = T,sep = ","))# A tibble: 114 x 21
train_walk<-as_tibble(read.csv("data/train_walking_data(trainset).csv",header = T,sep = ","))# A tibble: 114 x 21
#TESTING TIME
test_part<-as_tibble(read.csv("data/test_participant_data(testset).csv",header = T,sep = ","))# A tibble: 114 x 21
test_walk<-as_tibble(read.csv("data/test_walking_data(testset).csv",header = T,sep = ","))# A tibble: 114 x 21

c<-train_walk%>%group_by(id)


#fix the walking datasets by concatenating the id column

#merge the two datasets
#train<-merge(train_part,train_walk,by = "id")
#merge the two testing dataset
#test<-merge(test_part,test_walk,by = "id")
colnames(test_walk)
###########
#filler code, delete this later
###########
train<-train_part
test<-test_part



#ok lets start by cleaning up the data a bit
#First lets fix these date time formats
train$date
train$date<-as.Date(train$date,tryFormats = "%m/%d/%Y %H:%M")
#convert the testing dates to date time format
test$date
test$date<-as.Date(test$date,tryFormats = "%m/%d/%Y %H:%M")

# # good now lets merge the race columns
# race<-train%>%
#   select(c(id,asian,black,white,other,hispanic))%>%
#   pivot_longer(cols = c(asian,black,white,other,hispanic),names_to="race")%>%
#   filter(value==TRUE)%>%
#   group_by(id,race)




# ok lets split our training data into 80:20 for testing

#train<-train
#train<-head(train,91L)
#test<-tail(train,23L)

#linear regression model
# mod_lm<- lm(formula =BMI_level ~ id+
#                  date+
#                  pain+
#                  medication+
#                  walking+
#                  tbi+
#                  six_months+
#                  multiple_tbi+
#                  gender+ 
#                  asian+
#                  black+
#                  white+
#                  other+
#                  hispanic+
#                  # weight+
#                  # height+
#                  valid,
#                data = train)


#logistic regression model (parallel slopes)

#maybe lets try building the obesity model based on BMI score because it has higher resolution than 1 or 0 for obese


mod_glm<- glm(formula = BMI_level ~ id+
                date+
                pain+
                medication+
                walking+
                tbi+
                six_months+
                multiple_tbi+
                gender+ 
                asian+
                black+
                white+
                other+
                hispanic+
                # weight+
                #  height+
                valid,family = gaussian,
              data = train)


# #logistic regression (interaction slopes)
# mod_glm<- glm(formula = BMI_level ~ id+
#                  id*date+
#                  id*pain+
#                  id*medication+
#                  id*walking+
#                  id*tbi+
#                  id*six_months+
#                  id*multiple_tbi+
#                 id*gender+ 
#                 id*asian+
#                  id*black+
#                  id*white+
#                  id*other+
#                  id*hispanic+
#                 # weight+
#                 #  height+
#                  valid,family = gaussian,
#                data = train)

msummary(mod_glm)
library(broom)
##################################################################################
# I commented lines 111 to 131 out to save time, 
#but you should uncomment them out when you run the model to get the results
#############################################################################
#get the odds ratio
# OR<-tidy(mod_glm, conf.int=T,exponentiate = T)
# #OR
# #get the analysis of variance
# mod_glm_aov<-anova(mod_glm)
# #mod_glm_aov
# #get the coefficients
# mod_glm_coef<-coef(mod_glm)
# #mod_glm_coef
# #get the 95% confidence intervals
# mod_glm_confint<-confint(mod_glm)
# #mod_glm_confint
# #get the r squared vaslus
# mod_glm_rqsuared<-rsquared(mod_glm)
# #mod_glm_rqsuared
# #Diagnostics; plot residuals
# gf_dhistogram(~resid(mod_glm))
# gf_qq(~resid(mod_glm))
# 
# #Diagnostics; plot residuals vs. fitted
# gf_point(resid(mod_glm) ~fitted(mod_glm))

#make a function based on the model
mod_glm_fun <- makeFun(mod_glm)
#mod_lm_fun <- makeFun(mod_lm)
###################################################################



# test$BMI_lm_pred<-mod_lm_fun(id = test$id,
#                              date = test$date,
#                              pain = test$pain,
#                              medication = test$medication,
#                              walking = test$walking,
#                              tbi = test$tbi,
#                              six_months = test$six_months,
#                              multiple_tbi = test$multiple_tbi,
#                              gender = test$gender,
#                              asian = test$asian,
#                              black = test$black,
#                              white = test$white,
#                              other = test$other,
#                              hispanic = test$hispanic,
#                             # weight = NULL,
#                             # height = NULL,
#                              valid = test$valid)


# train$BMI_lm_pred<-mod_lm_fun(id = train$id,
#                              date = train$date,
#                              pain = train$pain,
#                              medication = train$medication,
#                              walking = train$walking,
#                              tbi = train$tbi,
#                              six_months = train$six_months,
#                              multiple_tbi = train$multiple_tbi,
#                              gender = train$gender,
#                              asian = train$asian,
#                              black = train$black,
#                              white = train$white,
#                              other = train$other,
#                              hispanic = train$hispanic,
#                             # weight = NA,
#                             # height = NA,
#                              valid = train$valid)
# 



# predict based on training data 
#(bad, this can cause overfitting,the right answer is to cut out 20% from the model 
# build and run it as test)
train$BMI_glm_pred<-mod_glm_fun(id = train$id,
                                     date = train$date,
                                     pain = train$pain,
                                     medication = train$medication,
                                     walking = train$walking,
                                     tbi = train$tbi,
                                     six_months = train$six_months,
                                     multiple_tbi = train$multiple_tbi,
                                     gender = train$gender,
                                     asian = train$asian,
                                     black = train$black,
                                     white = train$white,
                                     other = train$other,
                                     hispanic = train$hispanic,
                                  #   weight = NULL,
                                  #   height = NULL,
                                     valid = train$valid)

#predict based on test data
test$BMI_glm_pred<-mod_glm_fun(id = test$id,
                                    date = test$date,
                                    pain = test$pain,
                                    medication = test$medication,
                                    walking = test$walking,
                                    tbi = test$tbi,
                                    six_months = test$six_months,
                                    multiple_tbi = test$multiple_tbi,
                                    gender = test$gender,
                                    asian = test$asian,
                                    black = test$black,
                                    white = test$white,
                                    other = test$other,
                                    hispanic = test$hispanic,
                                    #   weight = NULL,
                                    #   height = NULL,
                                    valid = test$valid)



#evaluate the model!
# convert the results from a double to an interger by rounding

train$BMI_glm_pred<-round(train$BMI_glm_pred,digits = 0)

test$BMI_glm_pred<-round(test$BMI_glm_pred,digits = 0)


#bind the columns id and glm predicted into a df called res as results
res<-cbind(test$id,test$BMI_glm_pred)
#convert to a tibble
res<-as_tibble(res)

res
train
tail(res)
#adding the column
#warning: this calum if called obese, but its really the 
#BMI score and needs to be converted into a 1 or a 0
colnames(res)<-c("id","Obese")
res

write.table(res,"res.tsv",sep = "\t",quote = F,row.names = F)





train$BMI_glm_pred
train$glmdiff<-train$BMI_glm_pred==train$BMI_level

train$glmdiff


tally(~train$glmdiff)
tally(~train$glmdiff,format = "percent")

write.table(train,"train.tsv",sep = "\t",quote = F,row.names = F)


#make a ggplot 2 scatter plot that shows that actual versus predicted with the training model
train$BMI_glm_pred
train$BMI_level

scatter<-ggplot(train)+geom_point(mapping = aes(x = BMI_level, y=BMI_glm_pred))
scatter
bar<-ggplot(train)+geom_bar(mapping = aes(x = glmdiff))
bar
res



#how to improve this model

#instead of convert the results from a double to an interger by rounding up or down

#incorporate the start and stop times in difference by converting to seconds and then building it into the model

#incorporate the interaction slopes into the model

#look at the differences with the things that were close to being bmi4 but not bmi4



#add the walking data to the analysis portion


# good now lets merge the race columns