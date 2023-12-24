;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname qf_daymoyl_defeatedlaw_02019421 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theAggressor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theAggressor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theGuard
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theGuard Auto
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
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
self.SendModEvent("da_ApplyBlackscreen")
Utility.Wait(5)


Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0000)
Bool bGuardFound = false
actor attacker = Alias_theAggressor.GetActorRef()
if attacker.IsGuard()
	bGuardFound = true
elseIf Alias_theGuard.GetRef()
	attacker = Alias_theGuard.GetActorRef()
	bGuardFound = true
endIf
if attacker
	faction crimeFaction = attacker.GetCrimeFaction()
	if crimeFaction as Bool && !game.GetPlayer().IsArrested()
		If (crimeFaction.GetCrimeGold() <= 0)
			crimeFaction.SetCrimeGold(120)
		EndIf
		pTGRSS.TGArrestedCheck()
		if crimeFaction == MarkarthCrimeFaction
			if MS01GuardAmbushQuest.GetStageDone(10) && !MS01GuardAmbushQuest.GetStageDone(100)
				CrimeGuard.SetupCidhnaMine()
				MS01GuardAmbushQuest.SetStage(100)
			else
				crimeFaction.SendPlayerToJail(true, true)
				CrimeGuard.SetupCidhnaMine()
			endIf
		else
			crimeFaction.SendPlayerToJail(true, true)
		endIf
	else
		self.Stop()
	endIf
endIf
self.RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
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

crimeguardsscript property CrimeGuard auto
daymoyl_monitorutility property Util auto
tgrshellscript property pTGRSS auto
daymoyl_monitorvariables property Variables auto
faction property MarkarthCrimeFaction auto
Quest property MS01GuardAmbushQuest auto

ImageSpaceModifier Property FadeToBlackImod  Auto  
