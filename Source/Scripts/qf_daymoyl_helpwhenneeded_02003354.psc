;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname qf_daymoyl_helpwhenneeded_02003354 Extends Quest Hidden

;BEGIN ALIAS PROPERTY theRandomExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theRandomExit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theRandomLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theRandomLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theExit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY anAdventurer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_anAdventurer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theDefaultExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theDefaultExit Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
actor akPlayer = Alias_thePlayer.GetRef() as actor
Int r = utility.RandomInt(0, IronSteel1H.length - 1)
akPlayer.AddItem(IronSteel1H[r] as Form, 1, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
actor adv = Alias_anAdventurer.GetRef() as actor
adv.SetPlayerTeammate(true, true)
if adv as Bool && !adv.IsDead()
	adv.AddToFaction(CurrentFollowerFaction)
endIf
Util.RegisterForOnReload(self as Form, "daymoyl_AdventurerHelpOfferTimeout", "OnHelpOfferTimeout")
Util.RegisterForSingleGameTimeModEvent("daymoyl_AdventurerHelpOfferTimeout", Variables.TimeOnHelpOffer)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
actor adv = Alias_anAdventurer.GetRef() as actor
if adv as Bool && !adv.IsDead()
	adv.SetPlayerTeammate(false, true)
	adv.RemoveFromFaction(CurrentFollowerFaction)
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
actor adv = Alias_anAdventurer.GetRef() as actor
if adv as Bool && !adv.IsDead()
	adv.SetPlayerTeammate(false, true)
	adv.RemoveFromFaction(CurrentFollowerFaction)
endIf
Util.UnregisterForOnReload(self as Form, "daymoyl_AdventurerHelpOfferTimeout")
Alias_anAdventurer.GetRef().DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function OnHelpOfferTimeout(String eventName, String strArg, Float numArg, Form sender)
	self.SetStage(20)
endFunction

daymoyl_monitorvariables property Variables auto
daymoyl_monitorutility property Util auto
leveleditem[] property IronSteel1H auto
faction property CurrentFollowerFaction auto
dialoguefollowerscript property FollowerQuest auto
