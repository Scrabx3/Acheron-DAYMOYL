;/ Decompiled by Champollion V1.0.1
Source   : daymoyl_OnBleedoutAbsorbSoul.psc
Modified : 2014-07-19 07:34:51
Compiled : 2016-01-30 17:26:56
User     : Harawada
Computer : HARAWADA-PC
/;
scriptName daymoyl_onbleedoutabsorbsoul extends daymoyl_QuestTemplate  hidden

;-- Properties --------------------------------------
soulgem property FilledBlackSoulGem auto
effectshader property SoulTrapCastActFXS auto
sound property MAGMysticismSoulTrapCapture auto
sound property NPCDragonDeathSequenceExplosion auto
imagespacemodifier property SoulTrapTakingImod auto
effectshader property HealFXS auto
perk property AvoidDeath auto
globalvariable property GameDaysPassed auto
globalvariable property PerkAvoidDeathTimer auto
effectshader property DragonPowerAbsorbFXS auto
message property Choice auto

;-- Variables ---------------------------------------
Int cidx

;-- Functions ---------------------------------------

Function Display()
	cidx = Choice.Show()
	QuestStart(none, none, none)
	self.SendModEvent("da_ApplyBlackscreen", "RemoveWoozy", 0.000000)

	RegisterForSingleUpdate(3)
EndFunction

Event OnUpdate()
	SetStage(25)
EndEvent

; --- ORIGINAL CODE

Bool function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)

	cidx = -1
	Actor akPlayer = game.GetPlayer()
	if akPlayer.GetItemCount(FilledBlackSoulGem as form) > 0 || akPlayer.GetActorValue("DragonSouls") > 0 as Float || akPlayer.HasPerk(AvoidDeath) && PerkAvoidDeathTimer.GetValue() < GameDaysPassed.GetValue()
		cidx = Choice.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
		return cidx <= 2
	else
		return false
	endIf
endFunction

Bool function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)

	Actor akPlayer = game.GetPlayer()
	if cidx == 0
		; self.SendModEvent("da_StartRecoverSequence", "", 9999.00)
		akPlayer.RemoveItem(FilledBlackSoulGem as form, 1, false, none)
		MAGMysticismSoulTrapCapture.play(akPlayer as objectreference)
		SoulTrapTakingImod.apply(1.00000)
		SoulTrapCastActFXS.play(akPlayer as objectreference, 3 as Float)
		return true
	elseIf cidx == 1
		; self.SendModEvent("da_StartRecoverSequence", "", 9999.00)
		akPlayer.ModActorValue("DragonSouls", -1 as Float)
		NPCDragonDeathSequenceExplosion.play(akPlayer as objectreference)
		DragonPowerAbsorbFXS.play(akPlayer as objectreference, 9 as Float)
		return true
	elseIf cidx == 2
		; self.SendModEvent("da_StartRecoverSequence", "", 250.000)
		PerkAvoidDeathTimer.SetValue(GameDaysPassed.GetValue() + 1.00000)
		HealFXS.play(akPlayer as objectreference, 5 as Float)
		return true
	else
		return false
	endIf
endFunction
