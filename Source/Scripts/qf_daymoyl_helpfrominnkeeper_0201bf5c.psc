;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname qf_daymoyl_helpfrominnkeeper_0201bf5c Extends Quest Hidden

;BEGIN ALIAS PROPERTY theBed
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theBed Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInnCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theInnCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInn
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theInn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInnkeeper
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theInnkeeper Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
FetchFirewoodQuest.Start()
self.Stop()
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

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Alias_theInnkeeper.GetActorRef().EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
debug.Trace("Teleported at the inn", 0)
actor thePlayer = Alias_thePlayer.GetRef() as actor
objectreference theBed = Alias_theBed.GetRef()
thePlayer.MoveTo(Alias_theInnCenter.GetRef(), 0.000000, 0.000000, 0.000000, true)
if theBed != none && !theBed.IsFurnitureInUse(false)
	faction BedFaction = theBed.GetFactionOwner()
	if BedFaction
		debug.Trace("daymoyl - Bed faction owner " + BedFaction as String, 0)
		thePlayer.AddToFaction(BedFaction)
	endIf
	while PlayerAlias.bBlackoutAnimating || PlayerAlias.bRagdollAnimating
		utility.Wait(0.500000)
	endWhile
	thePlayer.MoveTo(theBed, 0.000000, 0.000000, 0.000000, true)
	if BedFaction
		thePlayer.RemoveFromFaction(BedFaction)
	endIf
endIf
Alias_theInnkeeper.GetRef().MoveTo(thePlayer as objectreference, 0.000000, 0.000000, 0.000000, true)
self.RegisterForSingleUpdate(2.00000)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Alias_thePlayer.GetRef().AddItem(Soup as form, 1, false)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function OnUpdate()
	if self.GetStage() == 0
		self.SetStage(10)
	endIf
endFunction

Quest property FetchFirewoodQuest auto
potion property Soup auto
daymoyl_monitorplayerscript property PlayerAlias auto
