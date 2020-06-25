### Reading epidemiological data (cases, deaths, recovered)
#Source BRAZIL DATA: 
## > https://brasil.io/dataset/covid19/caso ; #O Brasil em dados libertos # Repositório de dados públicos disponibilizados em formato acessível
## > Informações: https://blog.brasil.io/2020/03/23/dados-coronavirus-por-municipio-mais-atualizados/
## >              https://github.com/turicas/covid19-br/blob/master/api.md

getwd()
##"Dados de casos"
download.file("https://data.brasil.io/dataset/covid19/caso_full.csv.gz", destfile = "casos_br.csv.gz", mode="wb")
casos_br<-read.csv(gzfile("~/casos_br.csv.gz"))

#Substitute the Portuguese characters ==> UTF-8 encoding
casos_br$city<-as.character(casos_br$city)
Encoding(casos_br$city)<-"UTF-8"

#Name of columns
colnames(casos_br)

#####################################################################################################################
##Brazil states analysis
estado_dados<-casos_br[which(casos_br$place_type=="state"),c("date","new_confirmed","new_deaths")]
estado_dados$date<-as.Date(estado_dados$date)
new_cases<-aggregate(new_confirmed ~ date, data=estado_dados, sum)
cases<-cumsum(new_cases$new_confirmed)
new_mortes<-aggregate(new_deaths ~ date, data=estado_dados, sum)
mortes<-cumsum(new_mortes$new_deaths)
brasil_dados<-data.frame(unique(estado_dados$date),cases,mortes)
colnames(brasil_dados)<-c("date","cases","death")

############### Writing the data ########################
###############LINEAR GRAPH: CASES AND DEATHS #################################
file_path=file(c("~/js/covid_br.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias = [",paste("\"",brasil_dados$date[1:(length(brasil_dados$date)-1)], "\",",sep=""),paste("\"",brasil_dados$date[length(brasil_dados$date)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var casos = [",paste(brasil_dados$cases[1:(length(brasil_dados$cases)-1)], ",",sep=""),brasil_dados$cases[length(brasil_dados$cases)],"];\n\n",file=file_path,append=TRUE)
cat("var mortes = [",paste(brasil_dados$death[1:(length(brasil_dados$death)-1)], ",",sep=""),brasil_dados$death[length(brasil_dados$death)],"];\n\n",file=file_path,append=TRUE)
sink()

###############LOG GRAPH: CASES AND DEATHS #################################
file_path=file(c("~/js/covid_br_log.js"),encoding = "UTF-8")
sink(file_path)
cat("var dias_log = [",paste("\"",brasil_dados$date[which(brasil_dados$death>=1)[1:(length(brasil_dados$date)-22)]], "\",",sep=""),paste("\"",brasil_dados$date[length(brasil_dados$date)],"\"];\n\n",sep=""),file=file_path,append=TRUE)
cat("var casos_log = [",paste(brasil_dados$cases[which(brasil_dados$death>=1)[1:(length(brasil_dados$cases)-22)]], ",",sep=""),brasil_dados$cases[length(brasil_dados$cases)],"];\n\n",file=file_path,append=TRUE)
cat("var mortes_log = [",paste(brasil_dados$death[which(brasil_dados$death>=1)[1:(length(brasil_dados$death)-22)]], ",",sep=""),brasil_dados$death[length(brasil_dados$death)],"];\n\n",file=file_path,append=TRUE)
sink()

################################################################################################################
#Writting the data for the plot map 
################################################################################################################
download.file("https://raw.githubusercontent.com/wcota/covid19br/master/gps_cities.csv", destfile = "gps_cities.csv", mode="wb")
gps_cities<-read.csv("~/gps_cities.csv")
gps_cities<-gps_cities[,1:4]
colnames(gps_cities)<-c("ibge_code","city","lat","lon")
Encoding(gps_cities$city)<-"UTF-8"

city_dados<-casos_br[which(casos_br$place_type=="city"),c("city","state","city_ibge_code","date","new_confirmed","new_deaths","estimated_population_2019")]

#Substitute the Portuguese characters ==> UTF-8 encoding
casos_br$city<-as.character(casos_br$city)
Encoding(casos_br$city)<-"UTF-8"

findcity_code<-function(code){
  cidade_dados<-city_dados[which(city_dados$city_ibge_code==code),c("date","state","new_confirmed","new_deaths","estimated_population_2019")]
  return(cidade_dados)
}
stat<-c()
for (j in 1:dim(coord_cities)[1]){
  if (!is.na(any(city_dados$city_ibge_code==gps_cities$ibge_code[j]))){
    num_city<-findcity_code(gps_cities$ibge_code[j])
    pop<-num_city$estimated_population_2019[1]
    state<-as.character(num_city$state[1])
    soma_cases<-cumsum(num_city$new_confirmed)
    total_cases<-soma_cases[length(soma_cases)]
    soma_deaths<-cumsum(num_city$new_deaths)
    total_deaths<-soma_deaths[length(soma_deaths)]
    stat<-rbind(stat,c(gps_cities$ibge_code[j],state,total_cases,total_deaths,pop))
  }
}
colnames(stat)<-c("ibge_code","state","cases","deaths","pop")
stat_coord<-merge(stat,coord_cities,by="ibge_code")

file_path=file(c("~/js/cities_covid.js"),encoding = "UTF-8")
sink(file_path)
cat("var addressPoints = [",file=file_path,sep="\n")
for (j in 1:dim(stat_coord)[1]){
  cat(" [", file=file_path,sep="\n",append=TRUE)
  cat(paste(c("  \""),c(as.character(stat_coord$city[j])),c(" - "),c(as.character(stat_coord$state[j])),c("\","),sep=""), file=file_path,sep="\n",append=TRUE)
  cat(paste(c("  "),c(stat_coord$lat[j]),c(","),sep=""), file=file_path,sep="\n",append=TRUE)
  cat(paste(c("  "),c(stat_coord$lon[j]),c(","),sep=""), file=file_path,sep="\n",append=TRUE)
  cat(paste(c("  "),c(as.numeric(as.character(stat_coord$cases[j]))),c(","),sep=""), file=file_path,sep="\n",append=TRUE)
  cat(paste(c("  "),c(as.numeric(as.character(stat_coord$deaths[j]))),c(","),sep=""), file=file_path,sep="\n",append=TRUE)
  cat(paste(c("  "),c(as.numeric(as.character(stat_coord$pop[j]))),c(","),sep=""), file=file_path,sep="\n",append=TRUE)
  if(j==dim(stat_coord)[1]) {cat(" ]", file=file_path,sep="\n",append=TRUE)}
  else {cat(" ],", file=file_path,sep="\n",append=TRUE)}
}
cat("];", file=file_path,sep="\n",append=TRUE)
sink()
