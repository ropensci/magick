# line joins
img <- image_graph()
par(ljoin=0)
y=c(0,1,0,5,0)
plot(y,lwd=20,type="l",ylim=c(0,10))
par(ljoin=1)
lines(y+2,lwd=20,type="l")
par(ljoin=2)
lines(y+4,lwd=20,type="l")
dev.off()

# mitre (doesn't work)
img <- image_graph(res = 96)
par(ljoin=1, lmitre=5, lend=1) # lmitre only active for ljoin=1
y=c(0,30,0)
x=c(-1:1)
plot(x, y,lwd=10,type="l",ylim=c(0,40),xlim=c(-20,20))
par(ljoin=1, lmitre=30) # default lmitre=10
lines(x+4,y,lwd=10,type="l",ylim=c(0,40))
dev.off()
