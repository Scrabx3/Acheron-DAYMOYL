;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 0
Scriptname qf_daymoyl_worstdayofyourlif_0200335e Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theBrigandHenchman2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theBrigandHenchman2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theRandomExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theRandomExit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theDefaultExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theDefaultExit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theRandomLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theRandomLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theExit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theBrigandHenchman1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theBrigandHenchman1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theBrigand
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theBrigand Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
Alias_theBrigand.GetActorRef().SetActorValue("Aggression", 0 as Float)
Actor thePlayer = Alias_thePlayer.GetRef() as Actor
Int level = thePlayer.GetLevel()
if level > 10 || utility.RandomInt(0, 2) == 0
	theHenchman1 = thePlayer.PlaceActorAtMe(BrigandBase, 2, none)
	theHenchman1.SetActorValue("Aggression", 0 as Float)
	Alias_theBrigandHenchman1.ForceRefTo(theHenchman1 as objectreference)
else
	theHenchman1 = none
endIf
if level > 25 || utility.RandomInt(0, 4) == 0
	theHenchman2 = thePlayer.PlaceActorAtMe(BrigandBase, 2, none)
	theHenchman2.SetActorValue("Aggression", 0 as Float)
	Alias_theBrigandHenchman2.ForceRefTo(theHenchman2 as objectreference)
else
	theHenchman2 = none
endIf
If (Acheron.IsDefeated(thePlayer))
	Acheron.RescueActor(thePlayer, true)
ElseIf (Acheron.IsPacified(thePlayer))
	Acheron.ReleaseActor(thePlayer)
EndIf
Util.DisplayPM("Someone is approaching")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Actor theBrigand = Alias_theBrigand.GetRef() as Actor
theBrigand.DeleteWhenAble()
theBrigand.Disable(false)
if theHenchman1
	theHenchman1.DeleteWhenAble()
	theHenchman1.Disable(false)
endIf
if theHenchman2
	theHenchman2.DeleteWhenAble()
	theHenchman2.Disable(false)
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
Actor theBrigand = Alias_theBrigand.GetRef() as Actor
theBrigand.SetActorValue("Aggression", 2 as Float)
theBrigand.StartCombat(Alias_thePlayer.GetRef() as Actor)
theBrigand.SendAssaultAlarm()
if theHenchman1
	theHenchman1.SetActorValue("Aggression", 2 as Float)
	theHenchman1.StartCombat(Alias_thePlayer.GetRef() as Actor)
	theHenchman1.SendAssaultAlarm()
endIf
if theHenchman2
	theHenchman2.SetActorValue("Aggression", 2 as Float)
	theHenchman2.StartCombat(Alias_thePlayer.GetRef() as Actor)
	theHenchman2.SendAssaultAlarm()
endIf
self.SetStage(90)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
RecoveryQuest.StealPreciousItemsFromPlayerAndBlame(Alias_theBrigand.GetRef(), true)
self.RegisterForSingleUpdate(60 as Float)
self.SetStage(90)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor theHenchman2
Actor theHenchman1

function OnUpdate()
	Actor theBrigand = Alias_theBrigand.GetRef() as Actor
	theBrigand.SetActorValue("Aggression", 2 as Float)
	if theHenchman1
		theHenchman1.SetActorValue("Aggression", 2 as Float)
	endIf
	if theHenchman2
		theHenchman2.SetActorValue("Aggression", 2 as Float)
	endIf
endFunction

actorbase property BrigandBase auto
daymoyl_monitorutility property Util auto
daymoyl_getyourgearscript property RecoveryQuest auto
