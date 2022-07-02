import cv2 as cv
img = cv.imread("img.jpeg", cv.IMREAD_GRAYSCALE)
imagedata = []
for i in img:
    for j in i:
        imagedata.append(format(j, "b"))


hexfile = open ('imgdata.txt' , 'w' )
count = 0
for l in imagedata :
    hexfile.write(f"DRAM[{count}] = 8'b{l};")
    hexfile.write("\n")
    count = count + 1