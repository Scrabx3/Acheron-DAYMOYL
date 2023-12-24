;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname qf_daymoyl_helpfromtemple_0201bf63 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theTemple
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theTemple Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theTempleCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theTempleCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePriest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePriest Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Alias_thePriest.GetActorRef().AddSpell(HealingHand, true)
PriestScene.Start()
Alias_thePriest.GetActorRef().EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
debug.Trace("daymoyl - Teleported to Temple Location", 0)
Alias_thePlayer.GetRef().MoveTo(Alias_theTempleCenter.GetRef(), 0.000000, 0.000000, 0.000000, true)
Alias_thePriest.GetRef().MoveTo(Alias_thePlayer.GetRef(), 0.000000, 0.000000, 0.000000, true)
self.RegisterForSingleUpdate(2.00000)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function OnUpdate()
	if self.GetStage() == 0
		self.SetStage(10)
	endIf
endFunction

daymoyl_monitorscript property Monitor auto
potion property HealthPotion auto
spell property HealingHand auto
scene property PriestScene auto
