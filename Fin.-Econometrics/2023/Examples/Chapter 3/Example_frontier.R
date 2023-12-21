

w = seq(0,1,by = 0.01)


E1 = 2.07
E2 = 1.01
V1 = 48.2
V2 = 34.25
C12 = -2.65

Ep = w*E1+(1-w)*E2

vp = w^2*V1 + (1-w)^2*V2 +2*w*(1-w)*C12


plot(sqrt(vp),Ep)
