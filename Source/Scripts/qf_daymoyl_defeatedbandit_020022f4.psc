;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname qf_daymoyl_defeatedbandit_020022f4 Extends Quest Hidden

;BEGIN ALIAS PROPERTY theLocMapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocMapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCity
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theCity Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theBandit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theBandit Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thisLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_thisLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocEdge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocEdge Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMarker Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Actor player = Game.GetPlayer()
If(Acheron.IsDefeated(player))
  Acheron.RescueActor(player, false)
  Utility.Wait(3)
  Acheron.ReleaseActor(player)
ElseIf(Acheron.IsPacified(player))
  Acheron.ReleaseActor(player)
  Debug.SendAnimationEvent(player, "IdleForceDefaultState")
EndIf

if Variables.bRoamingGearThief && Alias_theBandit.GetActorRef().IsInFaction(BanditFaction)
	RoamingThiefQuest.Start()
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
self.SendModEvent("da_ApplyBlackscreen")
Utility.Wait(5)

debug.Trace("[DAYMOYL] Teleported away from Bandit", 0)
Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0000)
objectreference thePlayer = Alias_thePlayer.GetRef()
thePlayer.MoveTo(Alias_theMarker.GetRef(), 0.000000, 0.000000, 0.000000, true)
RecoveryQuest.StealPreciousItemsFromPlayerAndBlame((Alias_theBandit.GetRef() as actor) as objectreference, true)
self.SendModEvent("da_StartSecondaryQuest", "FriendOnly", 0.000000)
self.RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; self.SendModEvent("da_StartRecoverSequence", "", 0.000000)
self.SendModEvent("da_ApplyBlackscreen", "RemoveWoozy", 0.000000)
self.Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function OnUpdate()
	self.SetStage(10)
endFunction

faction property BanditFaction auto
Quest property RoamingThiefQuest auto
daymoyl_monitorvariables property Variables auto
daymoyl_monitorutility property Util auto
daymoyl_getyourgearscript property RecoveryQuest auto


ImageSpaceModifier Property FadeToBlackImod  Auto  
