;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname qf_daymoyl_helpfromcompanion_0201a9b9 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theExit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Vilkas
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Vilkas Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Farkas
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Farkas Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
actor vilkas = Alias_Vilkas.GetRef() as actor
vilkas.SetPlayerTeammate(false, true)
(Alias_Farkas.GetRef() as actor).SetPlayerTeammate(false, true)
if vilkas as Bool && !vilkas.IsDead()
	vilkas.RemoveFromFaction(CurrentFollowerFaction)
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
actor vilkas = Alias_Vilkas.GetRef() as actor
if vilkas as Bool && !vilkas.IsDead()
	vilkas.AddToFaction(CurrentFollowerFaction)
endIf
vilkas.SetPlayerTeammate(true, true)
(Alias_Farkas.GetRef() as actor).SetPlayerTeammate(true, true)
Util.RegisterForOnReload(self as Form, "daymoyl_CompanionHelpOfferTimeout", "OnHelpOfferTimeout")
Util.RegisterForSingleGameTimeModEvent("daymoyl_CompanionHelpOfferTimeout", Variables.TimeOnHelpOffer)
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

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
Alias_thePlayer.GetRef().AddItem(SkyforgeSword as Form, 1, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
actor vilkas = Alias_Vilkas.GetRef() as actor
vilkas.SetPlayerTeammate(false, true)
(Alias_Farkas.GetRef() as actor).SetPlayerTeammate(false, true)
if vilkas as Bool && !vilkas.IsDead()
	vilkas.RemoveFromFaction(CurrentFollowerFaction)
endIf
Util.UnregisterForOnReload(self as Form, "daymoyl_CompanionHelpOfferTimeout")
Alias_Farkas.GetRef().MoveToMyEditorLocation()
Alias_Vilkas.GetRef().MoveToMyEditorLocation()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Util.DisplayPM("Someone is approaching")
objectreference[] Helper = new objectreference[2]
Helper[0] = Alias_Farkas.GetRef()
Helper[1] = Alias_Vilkas.GetRef()
Util.MoveBehindPlayer(Helper, 256.000, 90.0000)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function OnHelpOfferTimeout(String eventName, String strArg, Float numArg, Form sender)
	self.SetStage(20)
endFunction

daymoyl_monitorutility property Util auto
dialoguefollowerscript property FollowerQuest auto
weapon property SkyforgeSword auto
faction property CurrentFollowerFaction auto
daymoyl_monitorvariables property Variables auto
