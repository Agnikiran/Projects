import random

#function declaration
def game(comp,you):
    #check all posibilities if the computer and user are same
    if comp == you:
        return None
    #check all possibilities if the computer choose 'stone'
    elif comp=='s':
        if you == 'z':
            return False
        elif you == 'p':
            return True
    ##check all possibilities if the computer choose 'paper'
    elif comp=='p':
        if you == 's':
            return False
        elif you == 'z':
            return True
    ##check all possibilities if the computer choose 'sizer'
    elif comp=='z':
        if you == 'p':
            return False
        elif you == 's':
            return True
    

#COMPUTER'S TURN DECLARATION
print("Computer's turn:Stone(s) Paper(p) Sizer(z)")
randNo=random.randint(1,3)
if randNo == 1:
    comp='s'
elif randNo == 2:
    comp='p'
elif randNo == 3:
    comp='z'

#USER'S TURN DECLARATION    
you=input("Your turn: Stone(s) Paper(p) Sizer(z)")
if(you=='s' or you=='p' or you=='z'):
    a=game(comp,you)    #function call

#To view the turns of user and computer
    print(f"computer choose : {comp}")
    print(f"You choose:  {you}")

    #Result
    if a== None:
        print("THE GAME IS TIE!")
    elif a== True:
        print("YOU WIN!")
    elif a== False:
        print("YOU LOOSE!")
else:
    print("WRONG INPUT")


#ask the user to play again
#b=input("Do you want to play again y/n?   ")
#if b=='y':
 #  pass
#elif b=='n':
#    exit(0)
#else:
 #   print("Give a valid input")