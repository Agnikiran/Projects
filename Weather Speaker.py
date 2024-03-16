import requests
import json
import win32com.client as wincom
speak = wincom.Dispatch("SAPI.SpVoice")

city=input("Enter the name of the city\n")

url = f"https://api.weatherapi.com/v1/current.json?key=fc035dc4fec340a28d4162213231607&q={city}"

r=requests.get(url)
#print(r.text)
wdic = json.loads(r.text)
w=wdic["current"]["temp_c"]
f=wdic["current"]["feelslike_c"]
c=wdic["current"]["cloud"]
h=wdic["current"]["humidity"]
s=wdic["current"]["wind_kph"]
lu=wdic["current"]["last_updated"]


speak.Speak(f"Todays current weather in {city} is {w} degress,\
             feels like {f},\
             cloud coverage is {c} %,\
             humidity {h}\
             and the wind speed is {s} kilometer per hour\
                 as per latest update on {lu} ")

