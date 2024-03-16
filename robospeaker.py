import win32com.client as wincom
speak = wincom.Dispatch("SAPI.SpVoice")
if __name__ == '__main__':
    print("Welcome to the robo speaker. created by Agni")
    while True:
        x=input("Enter the text ")
        if x== "q":
            speak.Speak("Bye")
            break

        speak.Speak(f"{x}")
