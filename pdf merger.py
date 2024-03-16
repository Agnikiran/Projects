import PyPDF2

# Get the number of PDF files to merge from the user
num_files = int(input("Enter the number of PDF files to merge: "))

# Initialize an empty list to store the file names
pdfiles = []

# Get file names from the user
for i in range(num_files):
    file_name = input(f"Enter the name of PDF file {i + 1}: ")
    pdfiles.append(file_name)

# Get the destination file name and location from the user
destination_file = input("Enter the name and location of the merged PDF file: ")

# Merge the PDF files
merger = PyPDF2.PdfMerger()
for filename in pdfiles:
    pdfFile = open(filename, 'rb')
    pdfReader = PyPDF2.PdfReader(pdfFile)
    merger.append(pdfReader)
    pdfFile.close()

# Save the merged PDF to the destination file
merger.write(destination_file)
merger.close()

print("PDFs merged successfully!")
