#### EpiEStim R package 
### REf: https://github.com/jstockwin/EpiEstimApp/wiki/Example:-EpiEstim-R-package

### Thompson RN, Stockwin JE, van Gaalen RD, Polonsky JA, et al. Improved inference of time-varying reproduction numbers during infectious disease outbreaks. Epidemics (2019).

library(EpiEstim)
### Brazil data -> brasil_dados from brazilian_data.R

t_start <- seq(8, length(diff(brasil_dados$cases))-5) 
t_end <- t_start + 5 
res_bra<-estimate_R(incid = data.frame(dates=brasil_dados$date[2:length(brasil_dados$cases)], I=diff(brasil_dados$cases)), 
                    method = "parametric_si",
                    config = make_config(list(mean_si = 4.7, std_si = 2.9,
                                              min_mean_si = 3.7, max_mean_si = 6,
                                              min_std_si = 1.9, max_std_si = 4.9,
                                              t_start = t_start, 
                                              t_end = t_end)))

plot(res_bra)

result_bra<-data.frame(date=res_bra$date[res_bra$R$t_start],mean=res_bra$R$`Mean(R)`,quant005=res_bra$R$`Quantile.0.05(R)`,quant095=res_bra$R$`Quantile.0.95(R)`)
path<-paste(dirname(rstudioapi::getSourceEditorContext()$path),"/csv")
if (dir.exists(path)){
  write.csv(result_bra,file=paste(path,"R_bra_covid19.csv"))
}else{
  dir.create(path)
  write.csv(result_bra,file=paste(path,"R_bra_covid19.csv"))}

### Data per state
abrev<-c("AC","AL","AP","AM","BA", "CE", "DF", "ES", "GO", "MA",  "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
result_state=FALSE
for (name in abrev){
  t_start <- seq(8, length(df_allstates$new_confirmed[df_allstates$estado==name])-3) 
  t_end <- t_start + 3 
  if (any(df_allstates$new_confirmed[df_allstates$estado==name]<0)){
    df_allstates$new_confirmed[df_allstates$estado==name][which(df_allstates$new_confirmed[df_allstates$estado==name]<0)]<-0
  }
  
  res_state<-estimate_R(incid = data.frame(dates=df_allstates$date[df_allstates$estado==name], I=df_allstates$new_confirmed[df_allstates$estado==name]), 
                        method = "parametric_si",
                        config = make_config(list(mean_si = 4.7, std_si = 2.9,
                                                  min_mean_si = 3.7, max_mean_si = 6,
                                                  min_std_si = 1.9, max_std_si = 4.9,
                                                  t_start = t_start, 
                                                  t_end = t_end)))
  
  
  estado<-rep(name,length(res_state$date[res_state$R$t_start]))
  if (length(result_state)<=1) {
    result_state<-data.frame(date=res_state$date[res_state$R$t_start],mean=res_state$R$`Mean(R)`,quant005=res_state$R$`Quantile.0.05(R)`,quant095=res_state$R$`Quantile.0.95(R)`,estado=estado)
  } else {
    result_aux<-data.frame(date=res_state$date[res_state$R$t_start],mean=res_state$R$`Mean(R)`,quant005=res_state$R$`Quantile.0.05(R)`,quant095=res_state$R$`Quantile.0.95(R)`,estado=estado)
    result_state<-rbind(result_state,result_aux)
  }
}
if (dir.exists(path)){
  write.csv(result_state,file=paste(path,"R_braState_covid19.csv"))
}else{
  dir.create(path)
  write.csv(result_state,file=paste(path,"R_braState_covid19.csv"))}

