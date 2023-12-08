import pyautogui
import time
#import pyautogui
def Getmouseposition():
    while 1:
        mouse=pyautogui.position()
        print(mouse)
Getmouseposition()
abisciseUp = 1284
ordonneUP = 515
abisciseDown = 1284
ordonneDown = 574

def clic_fonction(quantite,upX,upY,downX,downY):
	#print("anaty fonction click")
	#print(indicator_3_sma)
	if quantite == 2:
		#print("Click miakatra")
		pyautogui.click(upX ,upY)
		time.sleep(5 )
	elif quantite == 1:
		#print("Click midina")
		pyautogui.click(downX,downY)
		time.sleep(5)
	else:
    	 return 0
def main():
	clic_fonction(2,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
	clic_fonction(1,abisciseUp,ordonneUP,abisciseDown,ordonneDown)


#while(1):
#	main()
	