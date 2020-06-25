
##"John Hopkins DATA"
## Downloding the Global data
download.file("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", destfile = "jhu_confirmed_global.csv", mode="wb")
jhu_confirmed_global<-read.csv("~/jhu_confirmed_global.csv")

download.file("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv", destfile = "jhu_deaths_global.csv", mode="wb")
jhu_deaths_global<-read.csv("~/jhu_deaths_global.csv")

download.file("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv", destfile = "jhu_recovered_global.csv", mode="wb")
jhu_recovered_global<-read.csv("~/jhu_recovered_global.csv")

# Getting the cases per day, starting at Fifth position
findCountryCases<-function(country){
  country_data<-jhu_confirmed_global[which(jhu_confirmed_global$Country.Region==country),5:length(jhu_confirmed_global)]
  return(country_data)
}
# Getting the deaths per day, starting at Fifth position
findCountryDeaths<-function(country){
  country_data<-jhu_deaths_global[which(jhu_deaths_global$Country.Region==country),5:length(jhu_deaths_global)]
  return(country_data)
}
# Getting the recovered per day, starting at Fifth position
findCountryRecovered<-function(country){
  country_data<-jhu_recovered_global[which(jhu_recovered_global$Country.Region==country),5:length(jhu_recovered_global)]
  return(country_data)
}

Country_data_cases<-function(country){
  track<-findCountryCases(country)
  if (dim(track)[1]>1){
    dates<-as.Date(colnames(track),"X%m.%d.%y")
    cases<-unlist(colSums(track))
    newcases<-c(NaN,diff(cases))
  } else {
    dates<-as.Date(colnames(track),"X%m.%d.%y")
    cases<-unlist(track)
    newcases<-c(NaN,diff(cases))
  }
  Country<-data.frame(dates=dates,cases=cases,newcases=newcases)
  return(Country)
}

Country_data_deaths<-function(country){
  track<-findCountryDeaths(country)
  if (dim(track)[1]>1){
    dates<-as.Date(colnames(track),"X%m.%d.%y")
    cases<-unlist(colSums(track))
    newcases<-c(NaN,diff(cases))
  } else {
    dates<-as.Date(colnames(track),"X%m.%d.%y")
    cases<-unlist(track)
    newcases<-c(NaN,diff(cases))
  }
  Country<-data.frame(dates=dates,cases=cases,newcases=newcases)
  return(Country)
}

Country_data_recovered<-function(country){
  track<-findCountryRecovered(country)
  if (dim(track)[1]>1){
    dates<-as.Date(colnames(track),"X%m.%d.%y")
    cases<-unlist(colSums(track))
    newcases<-c(NaN,diff(cases))
  } else {
    dates<-as.Date(colnames(track),"X%m.%d.%y")
    cases<-unlist(track)
    newcases<-c(NaN,diff(cases))
  }
  Country<-data.frame(dates=dates,cases=cases,newcases=newcases)
  return(Country)
}

#Brazil cases, deaths and recovered
br_cases<-Country_data_cases("Brazil")
br_deaths<-Country_data_deaths("Brazil")
br_recover<-Country_data_recovered("Brazil")

#United Kingdom
uk_cases<-Country_data_cases("United Kingdom")
uk_deaths<-Country_data_deaths("United Kingdom")

#Germany
de_cases<-Country_data_cases("Germany")
de_deaths<-Country_data_deaths("Germany")

#Chile
cle_cases<-Country_data_cases("Chile")
cle_deaths<-Country_data_deaths("Chile")

#Italy
it_cases<-Country_data_cases("Italy")
it_deaths<-Country_data_deaths("Italy")

#Iran
ir_cases<-Country_data_cases("Iran")
ir_deaths<-Country_data_deaths("Iran")

#Spain
sp_cases<-Country_data_cases("Spain")
sp_deaths<-Country_data_deaths("Spain")

#China
ch_cases<-Country_data_cases("China")
ch_deaths<-Country_data_deaths("China")

#Russia
ru_cases<-Country_data_cases("Russia")
ru_deaths<-Country_data_deaths("Russia")

#Turkey
tu_cases<-Country_data_cases("Turkey")
tu_deaths<-Country_data_deaths("Turkey")

#India
in_cases<-Country_data_cases("India")
in_deaths<-Country_data_deaths("India")

#Peru
pe_cases<-Country_data_cases("Peru")
pe_deaths<-Country_data_deaths("Peru")

#Getting the USA data
download.file("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv", destfile = "jhu_confirmed_US.csv", mode="wb")
jhu_confirmed_US<-read.csv("~/jhu_confirmed_US.csv")

download.file("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv", destfile = "jhu_deaths_US.csv", mode="wb")
jhu_deaths_US<-read.csv("~/jhu_deaths_US.csv")

USA_cases<-jhu_confirmed_US[,12:length(jhu_confirmed_US)]
USA_deaths<-jhu_deaths_US[,13:length(jhu_deaths_US)]

US_dates<-as.Date(colnames(USA_cases),"X%m.%d.%y")
US_cases<-unlist(colSums(USA_cases))
US_newcases<-c(NaN,diff(US_cases))
US_deaths<-unlist(colSums(USA_deaths))
US_newdeaths<-c(NaN,diff(US_deaths))

USA<-data.frame(dates=US_dates,cases=US_cases,newcases=US_newcases,deaths=US_deaths,newdeaths=US_newdeaths)


############### Writing the data ########################
############### NEWCASES#################################
dias<-seq(min(USA$dates)+1, max(USA$dates), by="days")
file_path=file(c("~/js/newcases.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias = [",paste("\"",dias[1:(length(dias)-1)], "\",",sep=""),paste("\"",dias[length(dias)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var US_newcases = [",paste(USA$newcases[2:(dim(USA)[1]-1)], ",",sep=""),USA$newcases[dim(USA)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Brazil_newcases = [",paste(br_cases$newcases[2:(dim(br_cases)[1]-1)], ",",sep=""),br_cases$newcases[dim(br_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var UK_newcases = [",paste(uk_cases$newcases[2:(dim(uk_cases)[1]-1)], ",",sep=""),uk_cases$newcases[dim(uk_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Germany_newcases = [",paste(de_cases$newcases[2:(dim(de_cases)[1]-1)], ",",sep=""),de_cases$newcases[dim(de_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Chile_newcases = [",paste(cle_cases$newcases[2:(dim(cle_cases)[1]-1)], ",",sep=""),cle_cases$newcases[dim(cle_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Peru_newcases = [",paste(pe_cases$newcases[2:(dim(pe_cases)[1]-1)], ",",sep=""),pe_cases$newcases[dim(pe_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Italy_newcases = [",paste(it_cases$newcases[2:(dim(it_cases)[1]-1)], ",",sep=""),it_cases$newcases[dim(it_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Iran_newcases = [",paste(ir_cases$newcases[2:(dim(ir_cases)[1]-1)], ",",sep=""),ir_cases$newcases[dim(ir_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var India_newcases = [",paste(in_cases$newcases[2:(dim(in_cases)[1]-1)], ",",sep=""),in_cases$newcases[dim(in_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Spain_newcases = [",paste(sp_cases$newcases[2:(dim(sp_cases)[1]-1)], ",",sep=""),sp_cases$newcases[dim(sp_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Russia_newcases = [",paste(ru_cases$newcases[2:(dim(ru_cases)[1]-1)], ",",sep=""),ru_cases$newcases[dim(ru_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Turkey_newcases = [",paste(tu_cases$newcases[2:(dim(tu_cases)[1]-1)], ",",sep=""),tu_cases$newcases[dim(tu_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var China_newcases = [",paste(ch_cases$newcases[2:(dim(ch_cases)[1]-1)], ",",sep=""),ch_cases$newcases[dim(ch_cases)[1]],"];\n\n",file=file_path,append=TRUE)
sink()

############### NEWDEATHS#################################
dias<-seq(min(USA$dates)+1, max(USA$dates), by="days")
file_path=file(c("~/js/newdeaths.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias = [",paste("\"",dias[1:(length(dias)-1)], "\",",sep=""),paste("\"",dias[length(dias)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var US_newdeaths = [",paste(USA$newdeaths[2:(dim(USA)[1]-1)], ",",sep=""),USA$newdeaths[dim(USA)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Brazil_newdeaths = [",paste(br_deaths$newcases[2:(dim(br_deaths)[1]-1)], ",",sep=""),br_deaths$newcases[dim(br_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var UK_newdeaths = [",paste(uk_deaths$newcases[2:(dim(uk_deaths)[1]-1)], ",",sep=""),uk_deaths$newcases[dim(uk_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Germany_newdeaths = [",paste(de_deaths$newcases[2:(dim(de_deaths)[1]-1)], ",",sep=""),de_deaths$newcases[dim(de_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Chile_newdeaths = [",paste(cle_deaths$newcases[2:(dim(cle_deaths)[1]-1)], ",",sep=""),cle_deaths$newcases[dim(cle_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Peru_newdeaths = [",paste(pe_deaths$newcases[2:(dim(pe_deaths)[1]-1)], ",",sep=""),pe_deaths$newcases[dim(pe_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Italy_newdeaths = [",paste(it_deaths$newcases[2:(dim(it_deaths)[1]-1)], ",",sep=""),it_deaths$newcases[dim(it_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Iran_newdeaths = [",paste(ir_deaths$newcases[2:(dim(ir_deaths)[1]-1)], ",",sep=""),ir_deaths$newcases[dim(ir_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var India_newdeaths = [",paste(in_deaths$newcases[2:(dim(in_deaths)[1]-1)], ",",sep=""),in_deaths$newcases[dim(in_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Spain_newdeaths = [",paste(sp_deaths$newcases[2:(dim(sp_deaths)[1]-1)], ",",sep=""),sp_deaths$newcases[dim(sp_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Russia_newdeaths = [",paste(ru_deaths$newcases[2:(dim(ru_deaths)[1]-1)], ",",sep=""),ru_deaths$newcases[dim(ru_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Turkey_newdeaths = [",paste(tu_deaths$newcases[2:(dim(tu_deaths)[1]-1)], ",",sep=""),tu_deaths$newcases[dim(tu_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var China_newdeaths = [",paste(ch_deaths$newcases[2:(dim(ch_deaths)[1]-1)], ",",sep=""),ch_deaths$newcases[dim(ch_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
sink()

############### TOTAL CASES#################################
dias<-seq(min(USA$dates), max(USA$dates), by="days")
file_path=file(c("~/js/cases.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias = [",paste("\"",dias[1:(length(dias)-1)], "\",",sep=""),paste("\"",dias[length(dias)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var US_totalcases = [",paste(USA$cases[1:(dim(USA)[1]-1)], ",",sep=""),USA$cases[dim(USA)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Brazil_totalcases = [",paste(br_cases$cases[1:(dim(br_cases)[1]-1)], ",",sep=""),br_cases$cases[dim(br_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var UK_totalcases = [",paste(uk_cases$cases[1:(dim(uk_cases)[1]-1)], ",",sep=""),uk_cases$cases[dim(uk_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Germany_totalcases = [",paste(de_cases$cases[1:(dim(de_cases)[1]-1)], ",",sep=""),de_cases$cases[dim(de_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Chile_totalcases = [",paste(cle_cases$cases[1:(dim(cle_cases)[1]-1)], ",",sep=""),cle_cases$cases[dim(cle_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Peru_totalcases = [",paste(pe_cases$cases[1:(dim(pe_cases)[1]-1)], ",",sep=""),pe_cases$cases[dim(pe_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Italy_totalcases = [",paste(it_cases$cases[1:(dim(it_cases)[1]-1)], ",",sep=""),it_cases$cases[dim(it_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Iran_totalcases = [",paste(ir_cases$cases[1:(dim(ir_cases)[1]-1)], ",",sep=""),ir_cases$cases[dim(ir_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var India_totalcases = [",paste(in_cases$cases[1:(dim(in_cases)[1]-1)], ",",sep=""),in_cases$cases[dim(in_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Spain_totalcases = [",paste(sp_cases$cases[1:(dim(sp_cases)[1]-1)], ",",sep=""),sp_cases$cases[dim(sp_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Russia_totalcases = [",paste(ru_cases$cases[1:(dim(ru_cases)[1]-1)], ",",sep=""),ru_cases$cases[dim(ru_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Turkey_totalcases = [",paste(tu_cases$cases[1:(dim(tu_cases)[1]-1)], ",",sep=""),tu_cases$cases[dim(tu_cases)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var China_totalcases = [",paste(ch_cases$cases[1:(dim(ch_cases)[1]-1)], ",",sep=""),ch_cases$cases[dim(ch_cases)[1]],"];\n\n",file=file_path,append=TRUE)
sink()

############### TOTAL DEATHS#################################
dias<-seq(min(USA$dates), max(USA$dates), by="days")
file_path=file(c("~/js/deaths.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias = [",paste("\"",dias[1:(length(dias)-1)], "\",",sep=""),paste("\"",dias[length(dias)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var US_totaldeaths = [",paste(USA$deaths[1:(dim(USA)[1]-1)], ",",sep=""),USA$deaths[dim(USA)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Brazil_totaldeaths = [",paste(br_deaths$cases[1:(dim(br_deaths)[1]-1)], ",",sep=""),br_deaths$cases[dim(br_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var UK_totaldeaths = [",paste(uk_deaths$cases[1:(dim(uk_deaths)[1]-1)], ",",sep=""),uk_deaths$cases[dim(uk_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Germany_totaldeaths = [",paste(de_deaths$cases[1:(dim(de_deaths)[1]-1)], ",",sep=""),de_deaths$cases[dim(de_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Chile_totaldeaths = [",paste(cle_deaths$cases[1:(dim(cle_deaths)[1]-1)], ",",sep=""),cle_deaths$cases[dim(cle_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Peru_totaldeaths = [",paste(pe_deaths$cases[1:(dim(pe_deaths)[1]-1)], ",",sep=""),pe_deaths$cases[dim(pe_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Italy_totaldeaths = [",paste(it_deaths$cases[1:(dim(it_deaths)[1]-1)], ",",sep=""),it_deaths$cases[dim(it_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Iran_totaldeaths = [",paste(ir_deaths$cases[1:(dim(ir_deaths)[1]-1)], ",",sep=""),ir_deaths$cases[dim(ir_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var India_totaldeaths = [",paste(in_deaths$cases[1:(dim(in_deaths)[1]-1)], ",",sep=""),in_deaths$cases[dim(in_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Spain_totaldeaths = [",paste(sp_deaths$cases[1:(dim(sp_deaths)[1]-1)], ",",sep=""),sp_deaths$cases[dim(sp_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Russia_totaldeaths = [",paste(ru_deaths$cases[1:(dim(ru_deaths)[1]-1)], ",",sep=""),ru_deaths$cases[dim(ru_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var Turkey_totaldeaths = [",paste(tu_deaths$cases[1:(dim(tu_deaths)[1]-1)], ",",sep=""),tu_deaths$cases[dim(tu_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
cat("var China_totaldeaths = [",paste(ch_deaths$cases[1:(dim(ch_deaths)[1]-1)], ",",sep=""),ch_deaths$cases[dim(ch_deaths)[1]],"];\n\n",file=file_path,append=TRUE)
sink()

library("wpp2019")
data("pop")
#These datasets are based on estimates and projections of United Nations, Department of Economic
#and Social Affairs, Population Division (2019).
#Ref:https://population.un.org/wpp/
#pop >> provides estimates of historical total population count
dem_world<-data.frame(Country=pop$name,Pop=pop$`2020`)
dem_world$Pop<-dem_world$Pop*1000

############### CASES PER MILLION#################################
dias<-seq(min(USA$dates), max(USA$dates), by="days")
file_path=file(c("~/js/casesmi.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias = [",paste("\"",dias[1:(length(dias)-1)], "\",",sep=""),paste("\"",dias[length(dias)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var US_casesmi = [",paste(round(USA$cases[1:(dim(USA)[1]-1)]*1000000/dem_world[dem_world$Country=="United States of America","Pop"],digits = 2), ",",sep=""),round(USA$cases[dim(USA)[1]]*1000000/dem_world[dem_world$Country=="United States of America","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Brazil_casesmi = [",paste(round(br_cases$cases[1:(dim(br_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Brazil","Pop"],digits = 2), ",",sep=""),round(br_cases$cases[dim(br_cases)[1]]*1000000/dem_world[dem_world$Country=="Brazil","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var UK_casesmi = [",paste(round(uk_cases$cases[1:(dim(uk_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="United Kingdom","Pop"],digits = 2), ",",sep=""),round(uk_cases$cases[dim(uk_cases)[1]]*1000000/dem_world[dem_world$Country=="United Kingdom","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Germany_casesmi = [",paste(round(de_cases$cases[1:(dim(de_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Germany","Pop"],digits = 2), ",",sep=""),round(de_cases$cases[dim(de_cases)[1]]*1000000/dem_world[dem_world$Country=="Germany","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Chile_casesmi = [",paste(round(cle_cases$cases[1:(dim(cle_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Chile","Pop"],digits = 2), ",",sep=""),round(cle_cases$cases[dim(cle_cases)[1]]*1000000/dem_world[dem_world$Country=="Chile","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Peru_casesmi = [",paste(round(pe_cases$cases[1:(dim(pe_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Peru","Pop"],digits = 2), ",",sep=""),round(pe_cases$cases[dim(pe_cases)[1]]*1000000/dem_world[dem_world$Country=="Peru","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Italy_casesmi = [",paste(round(it_cases$cases[1:(dim(it_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Italy","Pop"],digits = 2), ",",sep=""),round(it_cases$cases[dim(it_cases)[1]]*1000000/dem_world[dem_world$Country=="Italy","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Iran_casesmi = [",paste(round(ir_cases$cases[1:(dim(ir_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Iran (Islamic Republic of)","Pop"],digits = 2), ",",sep=""),round(ir_cases$cases[dim(ir_cases)[1]]*1000000/dem_world[dem_world$Country=="Iran (Islamic Republic of)","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var India_casesmi = [",paste(round(in_cases$cases[1:(dim(in_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="India","Pop"],digits = 2), ",",sep=""),round(in_cases$cases[dim(in_cases)[1]]*1000000/dem_world[dem_world$Country=="India","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Spain_casesmi = [",paste(round(sp_cases$cases[1:(dim(sp_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Spain","Pop"],digits = 2), ",",sep=""),round(sp_cases$cases[dim(sp_cases)[1]]*1000000/dem_world[dem_world$Country=="Spain","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Russia_casesmi = [",paste(round(ru_cases$cases[1:(dim(ru_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Russian Federation","Pop"],digits = 2), ",",sep=""),round(ru_cases$cases[dim(ru_cases)[1]]*1000000/dem_world[dem_world$Country=="Russian Federation","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Turkey_casesmi = [",paste(round(tu_cases$cases[1:(dim(tu_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="Turkey","Pop"],digits = 2), ",",sep=""),round(tu_cases$cases[dim(tu_cases)[1]]*1000000/dem_world[dem_world$Country=="Turkey","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var China_casesmi = [",paste(round(ch_cases$cases[1:(dim(ch_cases)[1]-1)]*1000000/dem_world[dem_world$Country=="China","Pop"],digits = 2), ",",sep=""),round(ch_cases$cases[dim(ch_cases)[1]]*1000000/dem_world[dem_world$Country=="China","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
sink()

############### DEATHS PER MILLION#################################
dias<-seq(min(USA$dates), max(USA$dates), by="days")
file_path=file(c("~/js/deathsmi.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias = [",paste("\"",dias[1:(length(dias)-1)], "\",",sep=""),paste("\"",dias[length(dias)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var US_deathsmi = [",paste(round(USA$deaths[1:(dim(USA)[1]-1)]*1000000/dem_world[dem_world$Country=="United States of America","Pop"],digits = 2), ",",sep=""),round(USA$deaths[dim(USA)[1]]*1000000/dem_world[dem_world$Country=="United States of America","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Brazil_deathsmi = [",paste(round(br_deaths$cases[1:(dim(br_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Brazil","Pop"],digits = 2), ",",sep=""),round(br_deaths$cases[dim(br_deaths)[1]]*1000000/dem_world[dem_world$Country=="Brazil","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var UK_deathsmi = [",paste(round(uk_deaths$cases[1:(dim(uk_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="United Kingdom","Pop"],digits = 2), ",",sep=""),round(uk_deaths$cases[dim(uk_deaths)[1]]*1000000/dem_world[dem_world$Country=="United Kingdom","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Germany_deathsmi = [",paste(round(de_deaths$cases[1:(dim(de_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Germany","Pop"],digits = 2), ",",sep=""),round(de_deaths$cases[dim(de_deaths)[1]]*1000000/dem_world[dem_world$Country=="Germany","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Chile_deathsmi = [",paste(round(cle_deaths$cases[1:(dim(cle_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Chile","Pop"],digits = 2), ",",sep=""),round(cle_deaths$cases[dim(cle_deaths)[1]]*1000000/dem_world[dem_world$Country=="Chile","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Peru_deathsmi = [",paste(round(pe_deaths$cases[1:(dim(pe_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Peru","Pop"],digits = 2), ",",sep=""),round(pe_deaths$cases[dim(pe_deaths)[1]]*1000000/dem_world[dem_world$Country=="Peru","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Italy_deathsmi = [",paste(round(it_deaths$cases[1:(dim(it_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Italy","Pop"],digits = 2), ",",sep=""),round(it_deaths$cases[dim(it_deaths)[1]]*1000000/dem_world[dem_world$Country=="Italy","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Iran_deathsmi = [",paste(round(ir_deaths$cases[1:(dim(ir_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Iran (Islamic Republic of)","Pop"],digits = 2), ",",sep=""),round(ir_deaths$cases[dim(ir_deaths)[1]]*1000000/dem_world[dem_world$Country=="Iran (Islamic Republic of)","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var India_deathsmi = [",paste(round(in_deaths$cases[1:(dim(in_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="India","Pop"],digits = 2), ",",sep=""),round(in_deaths$cases[dim(in_deaths)[1]]*1000000/dem_world[dem_world$Country=="India","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Spain_deathsmi = [",paste(round(sp_deaths$cases[1:(dim(sp_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Spain","Pop"],digits = 2), ",",sep=""),round(sp_deaths$cases[dim(sp_deaths)[1]]*1000000/dem_world[dem_world$Country=="Spain","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Russia_deathsmi = [",paste(round(ru_deaths$cases[1:(dim(ru_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Russia Federation","Pop"],digits = 2), ",",sep=""),round(ru_deaths$cases[dim(ru_deaths)[1]]*1000000/dem_world[dem_world$Country=="Russia Federation","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var Turkey_deathsmi = [",paste(round(tu_deaths$cases[1:(dim(tu_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="Turkey","Pop"],digits = 2), ",",sep=""),round(tu_deaths$cases[dim(tu_deaths)[1]]*1000000/dem_world[dem_world$Country=="Turkey","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
cat("var China_deathsmi = [",paste(round(ch_deaths$cases[1:(dim(ch_deaths)[1]-1)]*1000000/dem_world[dem_world$Country=="China","Pop"],digits = 2), ",",sep=""),round(ch_deaths$cases[dim(ch_deaths)[1]]*1000000/dem_world[dem_world$Country=="China","Pop"],digits = 2),"];\n\n",file=file_path,append=TRUE)
sink()
