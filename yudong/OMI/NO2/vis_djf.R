
source("plot.stacked.R") 

# read the seasonal data for each city
read_city <- function (city) { 
  filename = paste("csv/", city,  ".txt", sep="")

  data=read.csv(filename, header=F, skip=1, sep=',')
  colnames(data)=c(city) 

  return(data)
} 

  
cities=c("Guangzhou", "Wuhan", "Hefei", "Nanjing", "Shanghai", "Zhengzhou", "Xian", "Jinan", 
         "Taiyuan", "Shijiazhuang", "Tianjin", "Beijing") 

df=data.frame(year=2005:2016) 
nc=length(cities) 
for (i in 1:nc) { 
   data=read_city(cities[i]) 
   df = cbind(df, data) 
} 

png("no2_cities_2005-2016.png", width=1000, height=700, bg='white')

par(mai=c(1.02, 1.02, 0.82, 0.42), xpd=NA) 
plot.stacked(2005:2016, df[2:(nc+1)], xlab='Year', xaxt='n', yaxt='n', xlim=c(2004, 2016),   
         lwd = 2, bty='n', border='white', cex.lab=1.5, main='NO2 Density', 
        col=rgb(1:nc*(155/nc), 128, 128, 200, maxColorValue = 255) ) 
axis(1, at=2005:2016, cex.axis=1.5)

stack_y = rep(0, nc) 
stack_y[1] = df[1, 2]
# stack the values of y to place city labels 
for (i in 2:nc) { 
  stack_y[i] = stack_y[i-1] + df[1, i+1]
}

text(rep(2004.8, nc), stack_y, cities, cex=1.4, adj=c(1, 1))
dev.off()

#dev.copy(png, "no2_cities_2005-2016.png") 
#dev.off()



