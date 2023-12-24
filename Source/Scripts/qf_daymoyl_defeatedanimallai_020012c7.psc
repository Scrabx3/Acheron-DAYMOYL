;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname qf_daymoyl_defeatedanimallai_020012c7 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocEntrance
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocEntrance Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocMapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLocMapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLair
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLair Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thisLair
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_thisLair Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
self.SendModEvent("da_ApplyBlackscreen")
Utility.Wait(5)


debug.Trace("[DAYMOYL] Teleport To Lair Entrance", 0)
Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0000)
Alias_thePlayer.GetRef().MoveTo(Alias_theMarker.GetRef(), 0.000000, 0.000000, 0.000000, true)
self.SendModEvent("da_StartSecondaryQuest", "Both", 0.000000)
self.RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Prompt.Show()
; self.SendModEvent("da_StartRecoverSequence", "", 0.000000)
self.SendModEvent("da_ApplyBlackscreen", "RemoveWoozy", 0.000000)
self.Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; shut down stage
Actor player = Game.GetPlayer()
If(Acheron.IsDefeated(player))
  Acheron.RescueActor(player, false)
  Utility.Wait(3)
  Acheron.ReleaseActor(player)
ElseIf(Acheron.IsPacified(player))
  Acheron.ReleaseActor(player)
  Debug.SendAnimationEvent(player, "IdleForceDefaultState")
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function OnUpdate()
	self.SetStage(10)
endFunction

daymoyl_monitorutility property Util auto
message property Prompt auto
daymoyl_monitorvariables property Variables auto

ImageSpaceModifier Property FadeToBlackImod  Auto  
