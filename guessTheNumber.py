import random
randNumber = random.randint(1,100)
userGuess=None
gusses = 0
print(randNumber)

while(userGuess!=randNumber):
    userGuess=int(input("Enter your guess:"))
    gusses+=1
    if(userGuess==randNumber):
        print("Your guess is right!!")
    else:
        if(userGuess>randNumber):
            print("your guess is wrong!!Enter a smaller number")
        else:
            print("your guess is wrong!!Enter a biger number")

print(f"you gussed the number in {gusses} guesses")

with open("hiscore.txt","r") as f:
    hiscore =int(f.read())
   

if(gusses<hiscore):
    print("You just broke the high score!!!")
    with open("hiscore.txt","w") as f:
        f.write(str(gusses))
        
