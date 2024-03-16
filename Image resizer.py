import cv2

#percent by which the image is resized
scale_percent = int(input("How much do you want to reduce"))

#input give the file location with name and type  for ex:d:\desktop\vk.jpg
inp=str(input("Enter the file link"))
source = inp

src = cv2.imread(source, cv2.IMREAD_UNCHANGED)

#calculate the 50 percent of original dimensions
width = int(src.shape[1] * scale_percent / 100)
height = int(src.shape[0] * scale_percent / 100)

# dsize-->it is a tupple which contain new width and new hight
dsize = (width, height)

# resize image
output = cv2.resize(src, dsize)
destination = input("Enter the destination folder and filename to save the resized image (e.g., /path/to/save/resizedImage.jpg): ")

cv2.imwrite(destination,output)
print("Resized image saved successfully in the specified location!")

