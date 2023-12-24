;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname qf_daymoyl_defeateddragon_020205d4 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theDragon
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theDragon Auto
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

; FadeToBlackImod.Apply()
; Utility.Wait(2)
; FadeToBlackImod.PopTo(FadeToBlackHoldImod)

debug.Trace("[DAYMOYL] - Pacified the dragon temporarily", 0)
actor thePlayer = Alias_thePlayer.GetActorRef()
actor theDragon = Alias_theDragon.GetActorRef()
if !theDragon.HasSpell(Calmed as form)
	theDragon.AddSpell(Calmed, true)
endIf
Int DragonSoulCount = utility.RandomInt(0, math.Floor(thePlayer.GetActorValue("DragonSouls")))
if DragonSoulCount > 0
	thePlayer.ModActorValue("DragonSouls", (-DragonSoulCount) as Float)
	theDragon.AddItem(DragonSoul as form, DragonSoulCount, false)
	DragonAbsorbEffect.Play(thePlayer as objectreference, 8.00000, none)
	DragonAbsorbManEffect.Play(thePlayer as objectreference, 8.00000, none)
	NPCDragonDeathSequenceWind.Play(thePlayer as objectreference)
	NPCDragonDeathSequenceExplosion.Play(thePlayer as objectreference)
	DragonPowerAbsorbFXS.Play(thePlayer as objectreference, 12.0000)
endIf
Monitor.SetWeakenedDebuff(true)
Util.RegisterForOnReload(Monitor as form, "daymoyl_EndWeakenedDebuff", "OnEndWeakenedDebuff")
Util.RegisterForSingleGameTimeModEvent("daymoyl_EndWeakenedDebuff", Variables.WeakenedDebuffDuration)
Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0000)
self.SendModEvent("da_StartSecondaryQuest", "Both", 0.000000)
self.RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)

; Utility.Wait(4)
; FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Prompt.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
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

spell _WeakenedDebuff
spell property WeakenedDebuff
	spell function get()
		return _WeakenedDebuff
	endFunction
endproperty

spell property Calmed auto
daymoyl_monitorutility property Util auto
miscobject property DragonSoul auto
daymoyl_monitorvariables property Variables auto
sound property NPCDragonDeathSequenceWind auto
spell[] property WeakenedDebuffList auto
sound property NPCDragonDeathSequenceExplosion auto
visualeffect property DragonAbsorbEffect auto
daymoyl_monitorscript property Monitor auto
effectshader property DragonPowerAbsorbFXS auto
message property Prompt auto
visualeffect property DragonAbsorbManEffect auto

ImageSpaceModifier Property FadeToBlackImod  Auto  

ImageSpaceModifier Property FadeToBlackHoldImod  Auto  

ImageSpaceModifier Property FadeToBlackBackImod  Auto  
