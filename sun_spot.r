#Bu program Güneş görüntüsünü çeşitli filtrelerle incelemek amaçlı yazılmıştır.
library(EBImage)
#görüntü açma
img = readImage("/home/nurdan/Desktop/R_ile_veri_analizi/proje/sun.jpeg")
display(img)
hist(img,main='RGB Histogram')

#Lapcian Filtreleme
f = matrix(1, nrow = 6, ncol = 6)
f[2, 2] = -16
img_f = filter2(img, f)
display(img_f)

#Blur filtreleme
img_gblur = gblur(img, sigma = 5)
display(img_gblur, all=TRUE )

#Median Filter
img_noisy = img
ind=which(img_noisy<0.01)
l = length(ind)
n = l/100
img_noisy[ind] = runif(n, min=0.8, max=1)
display(img_noisy)

#Görüntünün boyutunu,matris formatını oluşturma
A=dim(img)
B=imageData(img)

#Grayscale maskeleme
y = channel(img,'gray')
display(y)
hist(y,main='Grayscale Histogram')

#threshold-sadece greyscale görüntülerde çalışıyor.
thres_img = thresh(y, w=5, h=5, offset=0.01)
display(thres_img)

#Maskeleme
nmask = thresh(y, 10, 10, 0.05)
nmask = opening(nmask, makeBrush(5, shape='disc'))
nmask = fillHull(nmask)
nmask = bwlabel(nmask)
display(normalize(nmask), title='Leke Maskeleme')

#Pixel değerlerinin merkezlerinden yayılmalarına göre maskeleme
ctmask = opening(y>0.1, makeBrush(5, shape='disc'))
cmask = propagate(y, nmask, ctmask)
S=normalize(cmask)
display(S, title='Leke Dışı alanları Maskeleme')

#Maskelenmiş görüntüye Gausian Filtreleme
g = matrix(1, nrow = 3, ncol = 3)
g[2, 2] = -8
img_g = filter2(S, g)
display(img_g)

#Karşılaştırma -Devam edilecek!!!!
img_g_hist=hist(img_g)
S_hist=hist(S)
