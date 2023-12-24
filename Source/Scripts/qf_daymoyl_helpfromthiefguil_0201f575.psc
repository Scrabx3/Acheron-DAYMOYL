;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname qf_daymoyl_helpfromthiefguil_0201f575 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theExit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theThief
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theThief Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
objectreference thePlayer = Alias_thePlayer.GetRef()
Int i = utility.RandomInt(1, 5)
while i
	i -= 1
	thePlayer.AddItem(RandomThiefLoot as form, 1, false)
endWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
actor theThief = Alias_theThief.GetRef() as actor
theThief.SetActorValue("Aggression", 2 as Float)
theThief.StartCombat(Alias_thePlayer.GetRef() as actor)
theThief.SendAssaultAlarm()
self.SetStage(90)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Alias_theThief.GetRef().DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
objectreference thePlayer = Alias_thePlayer.GetRef()
thePlayer.AddItem(RandomLightArmor as form, 1, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
objectreference thePlayer = Alias_thePlayer.GetRef()
objectreference theThief = Alias_theThief.GetRef()
Int amount = (thePlayer.GetItemCount(Gold as form) as Float * Variables.PercGoldTheft / 100 as Float) as Int
thePlayer.RemoveItem(Gold as form, amount, false, theThief)
self.SetStage(90)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Alias_theThief.GetActorRef().SetActorValue("Aggression", 0 as Float)
Actor player = Game.GetPlayer()
If (Acheron.IsDefeated(player))
	Acheron.RescueActor(player, true)
ElseIf (Acheron.IsPacified(player))
	Acheron.ReleaseActor(player)
EndIf
Util.DisplayPM("Someone is approaching")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

daymoyl_monitorutility property Util auto
miscobject property Gold auto
leveleditem property RandomLightArmor auto
daymoyl_monitorvariables property Variables auto
leveleditem property RandomThiefLoot auto
