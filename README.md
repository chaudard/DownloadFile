# DownloadFile
allow you to download a file with several parameters :
- url
- name of the file
- extension of the file
- directory
for example :
DowloadFile.exe "http://localhost:8080/download" "myGuidFile" "xmt" "C:\Users\Dany\AppData\Local\Temp\"
The GET request is : http://localhost:8080/download/myGuidFile/xmt
-> The file myGuidFile.xmt will be downloaded in directory C:\Users\Dany\AppData\Local\Temp\
