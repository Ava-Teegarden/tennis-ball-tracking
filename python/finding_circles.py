import cv2
import numpy as np

#load image from computer into cv mat? must be 8bit grayscale
image = cv2.imread('working1.png', cv2.IMREAD_GRAYSCALE)
assert image is not None, "file can't be read, fix path or check with os.path.exists()"

cv2.imshow('grayscale',image)

#no other processing since im just reading in sobel'd ones but for now:
blurred = cv2.GaussianBlur(image, (9,9), 2)

cv2.imshow('gaussian',blurred)

#sobel simulation here
sobel_x = cv2.Sobel(blurred, cv2.CV_64F, 1, 0, ksize=3)
sobel_y = cv2.Sobel(blurred, cv2.CV_64F, 0, 1, ksize=3)
sobel_mag = cv2.magnitude(sobel_x, sobel_y)
sobel_mag = cv2.convertScaleAbs(sobel_mag)




minDist = 300 #minimum distance between the centers of detected circles.. stops multiple finds of same circle

param1 = 100 #higher thresh of canny detection

#param2 = 45 #accum thresh, how many votes a circle needs to be considered a valid detection.. ++ = fewer and reliable circles

#inverse ratio accumulator resolution to the image resolution.. 
#1 = accumulator res is same to image res, > 1 = coarser accumulator
dp = 1.2

method = cv2.HOUGH_GRADIENT #most commonly used, employed gradient info of edges

#returns (x of center, y of center, radius of circle)
#10-17 is the pixel range for the radius of the circle
circles = cv2.HoughCircles(sobel_mag, method, dp, minDist, param1, 50, 5, 17)

#from opencv.org 
filtered = []
circles = np.uint16(np.around(circles))
for circle in circles[0,:]:
    if 10 <= circle[2] <= 50:
        filtered.append(np.uint16(np.around(circle)))
    # draw the outer circle
    cv2.circle(blurred,(circle[0],circle[1]),circle[2],(0,255,0),2)
    # draw the center of the circle
    cv2.circle(blurred,(circle[0],circle[1]),2,(0,0,255),3)

print("circles found:",len(circles[0]))
for i in filtered:
    print(i[2])

 
cv2.imshow('detected circles',blurred)
cv2.waitKey(0)
cv2.destroyAllWindows()