### COVID19 Data####

### Starting finding data ###
### Reading epidemiological data (cases, deaths, recovered)
#Source BRAZIL DATA: 
## > https://brasil.io/dataset/covid19/caso ; #O Brasil em dados libertos # Repositório de dados públicos disponibilizados em formato acessível
## > Informações: https://blog.brasil.io/2020/03/23/dados-coronavirus-por-municipio-mais-atualizados/
## >              https://github.com/turicas/covid19-br/blob/master/api.md

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

if (!dir.exists("~/csv")){ #IF DIRECTORY NOT EXISTS CREATE
  dir.create("~/csv")
}

if (!dir.exists("~/png")){ #IF DIRECTORY NOT EXISTS CREATE
  dir.create("~/png")
}

##"Dados de casos"
download.file("https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv", destfile = "~/csv/global_mobility.csv", mode="wb")
g_mobility<-read.csv("~/csv/global_mobility.csv", stringsAsFactors = FALSE)
colnames(g_mobility)<-c("country_region_code","country_region","sub_region_1","sub_region_2","iso_3166_2_code","census_fips_code","date",
                        "recreation","grocery","parks","transit","workplaces","residential")

#Name of columns
colnames(g_mobility)

#function to get data of specific city
findCountry<-function(country,region=NULL){
  if (is.null(region)) {region=""}
  country<-g_mobility[which(g_mobility$country_region==country & g_mobility$sub_region_1==region),7:13]
  return(country)
}

library(ggplot2)
library(RColorBrewer)


rdbu_col <- colorRampPalette(brewer.pal(12,'RdBu')) #max até 31
burdc <- rdbu_col(12) #reverse color scale

pais<-findCountry("Brazil")

head(pais)
tail(pais)

pais$date<-as.Date(pais$date)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade do Brasil \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  geom_vline(xintercept = pais$date[39],colour = "black", size=1, alpha=.2,linetype=2)+
  annotate("text", x = pais$date[39]+2, y = -20, label = "Decreto Início da Quarentena \n no estado de SP", color = "black",alpha=.6,angle = 90)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_Brasil.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

pais<-findCountry("United States")
head(pais)

pais$date<-as.Date(pais$date)
tail(pais)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade dos EUA \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_EUA.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

pais<-findCountry("Spain")
head(pais)

pais$date<-as.Date(pais$date)
tail(pais)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade da Espanha \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_Espanha.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

pais<-findCountry("Italy")
head(pais)

pais$date<-as.Date(pais$date)
tail(pais)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade da Itália \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_Italia.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

pais<-findCountry("Germany")
head(pais)

pais$date<-as.Date(pais$date)
tail(pais)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade da Alemanha \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_Aleamanha.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

pais<-findCountry("Sweden")
head(pais)

pais$date<-as.Date(pais$date)
tail(pais)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade da Suécia \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_Suecia.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

pais<-findCountry("Peru")
head(pais)

pais$date<-as.Date(pais$date)
tail(pais)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade do Peru \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_Peru.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

pais<-findCountry("India")
head(pais)

pais$date<-as.Date(pais$date)
tail(pais)

date_aux<-paste(substr(format(seq(pais$date[1],pais$date[length(pais$date)],by=1), "%a"),1,1),format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%d"),substr(format(seq(pais$date[1]-10,pais$date[length(pais$date)]+10,by=1), "%b"),1,1),sep="\n")
mean_m<-rowMeans(pais[2:7])
pais$mobility<-mean_m
theme_set(theme_bw() + theme(legend.position = c(0.7,0.2),legend.direction = "horizontal",legend.text = element_text(size=16))) 
ggplot(pais, aes(x=date,group = 1))+
  geom_line(aes(y=mobility),color=burdc[1],linetype=1,size=1.2,alpha=0.3)+
  geom_point(aes(y=mobility),shape=21, color="black", fill="slategray3", size=1.5)  +
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0),date_breaks = "1 day", date_labels =paste(substr(format(pais$date, "%a"),1,1),format(pais$date, "%d"),substr(format(pais$date, "%b"),1,1),sep="\n") )+#date_labels = "%a\n%d\n%b")+
  scale_y_continuous(breaks = c(-50,-40,-30,-20,-10,0,10), limits = c(-50,10))+
  labs(title="Mobilidade da Índia \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  theme(plot.title = element_text(hjust = 0.5,size=14),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1,color=c(rep("red",2),rep("black",5))),
        axis.text.y = element_text(size=14),legend.title = element_text(hjust = 0.5,size=14),
        legend.position = "none",axis.line = element_line(linetype="solid"))
ggsave("png/Mobilidade_India.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

#####################################################################################################################
## PLOT per state facet
#function to get data of specific city
findStatesBR<-function(country){
  country<-g_mobility[which(g_mobility$country_region==country & g_mobility$sub_region_1!=""),c(3,7:13)]
  return(country)
}

pais<-findStatesBR("Brazil")

head(pais)
tail(pais)

pais$date<-as.Date(pais$date)

abrev<-c("DF","AC","AL","AP","AM","BA", "CE", "ES", "GO", "MA",  "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SP", "SC", "SE", "TO")
pais$abrev<-rep(abrev,each=dim(pais)[1]/length(abrev))
pais_aux<-rbind(pais[,c(1,2,9)],pais[,c(1,2,9)],pais[,c(1,2,9)],pais[,c(1,2,9)],pais[,c(1,2,9)],pais[,c(1,2,9)])
mobility<-c(pais$recreation,pais$grocery,pais$parks,pais$transit,pais$workplaces,pais$residential)
pais_aux$mob<-mobility
pais_aux$tipo<-rep(c("Recreação", "Mercado","Parques", "Trânsito","Trabalho", "Residencial"),each=dim(pais)[1])
pais_aux$date<-as.Date(pais_aux$date)
library(ggplot2)
library(RColorBrewer)

if (!dir.exists("../brazil/png")){ #IF DIRECTORY NOT EXISTS CREATE
  dir.create("../brazil/png")
}

rdbu_col <- colorRampPalette(brewer.pal(24,'RdBu')) #max até 31
burdc <- rdbu_col(24) #reverse color scale

theme_set(theme_bw() + theme(legend.position = c(0.75,0.1),legend.direction = "horizontal",legend.text = element_text(size=10))) 
ggplot(pais_aux, aes(x=date))+
  annotate("rect", fill = "gray", alpha = 0.3, 
           xmin = pais_aux$date[39], xmax = pais_aux$date[117],
           ymin = -Inf, ymax = Inf) + 
  geom_line(aes(y=mob, color=tipo, linetype=tipo),size=1)+
  scale_x_date(limits=c(pais$date[1],pais$date[length(pais$date)]),expand=c(0,0))+
  scale_y_continuous(breaks = c(-100,-75,-50,-25,0,25,50,75,100), limits = c(-100,100))+
  labs(title="Mobilidade por estado brasileiro \n com relação a mediana dos valores dos dias de 3 Jan - 6 Fev, 2020", x="Data", y="Variação (%)")+
  geom_hline(yintercept = 0, colour = "black", size=1.2, alpha=.2,linetype=1)+
  annotate("text", x = pais$date[39]+20, y = 75, label = "Quarentena", color = "black",alpha=.6, size=2.5)+
  facet_wrap(~abrev)+
  scale_color_manual("",values = alpha(burdc[c(1,3,5,24,22,20)],c(0.6,0.6,0.6,1,0.6,0.6))) +
  scale_linetype_manual("",values = c(1,2,5,1,2,5),guide = guide_legend(title= "")) +
  theme(plot.title = element_text(hjust = 0.5,size=12),axis.title.x = element_text(size = 12),  
        axis.title.y = element_text(size = 12),axis.text.x = element_text(angle=0,size=8,hjust = 1),
        axis.text.y = element_text(size=10),legend.title = element_text(hjust = 0.5,size=12),
        legend.direction = "horizontal",axis.line = element_line(linetype="solid"))
ggsave("../brazil/png/Mobilidade_BR_estados.png",width = 14, height = 7,units = "in",dpi = 100)#maxsize 50 inches

