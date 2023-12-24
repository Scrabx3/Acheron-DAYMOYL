;/ Decompiled by Champollion V1.0.1
Source   : daymoyl_MonitorScript.psc
Modified : 2016-03-06 05:14:27
Compiled : 2016-03-07 05:31:49
User     : Harawada
Computer : HARAWADA-PC
/;
scriptName daymoyl_monitorscript extends Quest

;-- Properties --------------------------------------
faction property CalmedFaction auto
globalvariable property PlayerHasControl auto
imagespacemodifier property BlackScreen auto
message property MsgFollower auto
imagespacemodifier property FadeOut auto
message property MsgRecovered auto
daymoyl_monitorregistry property Registry auto
spell[] property BleedOutDebuffList auto
referencealias property akAggressorRef auto
message property MsgSuccumb auto
message property MsgRevert auto
imagespacemodifier property FadeIn auto
imagespacemodifier property LowHealthISM auto
spell property BleedOutDebuff
	spell function get()

		return _BleedOutDebuff
	endFunction
endproperty
globalvariable property DisplayBlackoutTutorial auto
message property BlackoutTutorial auto
spell property NearDeathDebuff
	spell function get()

		return _NearDeathDebuff
	endFunction
endproperty
Actor property Follower
	Actor function get()

		return akFollowerRef.GetRef() as Actor
	endFunction
endproperty
imagespacemodifier property WoozyFadeIn auto
daymoyl_monitormeterupdate property Meter auto
daymoyl_monitorutility property Util auto
sound property LowHealthHeartBeat auto
Bool property RegisteredForSheathe
	Bool function get()

		return bRegisterForSheathe as Bool && _Player.IsWeaponDrawn()
	endFunction
endproperty
daymoyl_monitorvariables property Variables auto
Location property CurrentLocation
	Location function get()

		return _CurrentLocation
	endFunction
	function set(Location newLocation)

		if newLocation
			_CurrentLocation = newLocation
			akLocationRef.ForceLocationTo(_CurrentLocation)
		endIf
	endFunction
endproperty
formlist property BlacklistedLocation auto
Actor property Aggressor
	Actor function get()

		return _Aggressor
	endFunction
	function set(Actor target)

		if target as Bool && !target.IsCommandedActor()
			_Aggressor = target
			akAggressorRef.ForceRefTo(_Aggressor as objectreference)
		elseIf _Aggressor as Bool && _Aggressor.IsDead()
			akAggressorRef.Clear()
		endIf
	endFunction
endproperty
message property BleedoutTutorial auto
daymoyl_monitorplayerscript property akPlayerRef auto
Actor property Player
	Actor function get()

		return _Player
	endFunction
endproperty
daymoyl_monitorfollowerscript property akFollowerRef auto
spell[] property WeakenedDebuffList auto
spell[] property NearDeathDebuffList auto
spell property DispelAOE auto
locationalias property akLocationRef auto
faction property PlayerFaction auto
spell property WeakenedDebuff
	spell function get()

		return _WeakenedDebuff
	endFunction
endproperty
spell property CalmSurrounding auto
Float property BleedoutHP
	Float function get()

		return _BleedoutHP
	endFunction
endproperty
spell property DADebug auto
message property MsgDrowned auto
globalvariable property DisplayBleedoutTutorial auto

;-- Variables ---------------------------------------
Bool bIsPrimaryQuestDisabled = false
Bool bProcessingOnHit = false
Actor _Player
Float fTimeInBleedOut = 0.000000
Bool bNearDeath = false
Bool bBypassBleedoutQuest = false
Bool bBleeding = false
Float maxHP = 0.000000
Float bufferHP = 0.000000
Bool bKeepBlackScreen = false
Bool bIsBlackScreen = false
spell _NearDeathDebuff
Bool bProcessing = false
Float _BleedoutHP = 100.000
Bool bRegisterForSheathe = false
Actor _Aggressor
Int LHHBID
Bool bBypassFollowerCheck = false
spell _WeakenedDebuff
Bool bWaitToRecover = false
spell _BleedOutDebuff
Float targetHP = 0.000000
Location _CurrentLocation
Float RegenClockTick = 0.000000
Bool bReadyToChangeBlackScreen = true

;-- Functions ---------------------------------------

function OnEndWeakenedDebuff(String eventName, String strArg, Float numArg, form sender)

	self.SetWeakenedDebuff(false)
endFunction

function RestorePacifiedEnemies(String eventName, String strArg, Float numArg, form sender)
	Acheron.ReleaseActor(Game.GetPlayer())

	; if _Player.HasSpell(CalmSurrounding as form)
	; 	_Player.RemoveSpell(CalmSurrounding)
	; endIf
	; DispelAOE.Cast(_Player as objectreference, _Player as objectreference)
endFunction

function PacifyNearbyEnemies(String eventName, String strArg, Float numArg, form sender)

	if strArg == "Restore"
		Acheron.ReleaseActor(Game.GetPlayer())
		; if _Player.HasSpell(CalmSurrounding as form)
		; 	_Player.RemoveSpell(CalmSurrounding)
		; endIf
		; DispelAOE.Cast(_Player as objectreference, _Player as objectreference)
	else
		Acheron.PacifyActor(Game.GetPlayer())
		; _Player.AddSpell(CalmSurrounding, false)
		; utility.Wait(0.100000)
		; _Player.RemoveSpell(CalmSurrounding)
	endIf
endFunction

function StartBleedOut()

	; Empty function
endFunction

function ForceBleedout(String eventName, String strArg, Float numArg, form sender)

	if !bProcessing
		debug.TraceConditional("daymoyl - Forced trigger!", Variables.bDebugMode)
		bProcessing = true
		bWaitToRecover = true
		bKeepBlackScreen = false
		bBypassFollowerCheck = false
		bBypassBleedoutQuest = false
		bRegisterForSheathe = false
		_Aggressor = none
		self.Aggressor = sender as Actor
		self.GotoState("EnterBleedOut")
	endIf
endFunction

function DisableBlackoutScenario(String eventName, String strArg, Float numArg, form sender)

	bIsPrimaryQuestDisabled = strArg != "Enable"
endFunction

function SetPlayerControl(Bool control)

	if control
		PlayerHasControl.SetValue(1 as Float)
		_Player.EnableAI(true)
		game.SetPlayerAIDriven(false)
		game.SetInCharGen(false, false, false)
		game.EnablePlayerControls(false, false, true, true, true, true, true, true, 0)
		self.UpdateCurrentInstanceGlobal(PlayerHasControl)
		_Player.EvaluatePackage()
	else
		game.DisablePlayerControls(false, false, true, false, true, true, true, false, 0)
		game.SetInCharGen(true, true, false)
		game.SetPlayerAIDriven(true)
		_Player.EnableAI(false)
		PlayerHasControl.SetValue(0 as Float)
	endIf
endFunction

Float function BufferDamageReceived(Float bufferValue)

	Float HP = _Player.GetActorValue("Health")
	if HP > bufferValue
		_Player.DamageActorValue("Health", HP - bufferValue)
		bufferHP = _Player.GetActorValue("Health")
		return 0.000000
	else
		_Player.RestoreActorValue("Health", bufferValue - HP)
		bufferHP = _Player.GetActorValue("Health")
		return math.Abs(bufferHP - HP)
	endIf
endFunction

function ApplyNearDeathDebuff()

	Util.RegisterForSingleGameTimeModEvent("da_EndNearDeathDebuff", Variables.NearDeathDebuffDuration)
	self.SetNearDeathExBleedoutDebuff(true)
	bNearDeath = true
endFunction

Bool function IsBlackscreenOn()

	return bIsBlackScreen
endFunction

function SetWeakenedDebuff(Bool apply)

	if apply
		if WeakenedDebuffList[Variables.DifficultySetting] != self.WeakenedDebuff
			_Player.RemoveSpell(self.WeakenedDebuff)
		endIf
		_WeakenedDebuff = WeakenedDebuffList[Variables.DifficultySetting]
		if self.WeakenedDebuff
			_Player.AddSpell(self.WeakenedDebuff, false)
		endIf
	elseIf self.WeakenedDebuff
		_Player.RemoveSpell(self.WeakenedDebuff)
	endIf
endFunction

daymoyl_QuestTemplate function PickPrimaryQuest()

	daymoyl_QuestTemplate Selected = none
	if bIsPrimaryQuestDisabled as Bool || BlacklistedLocation.HasForm(_CurrentLocation as form)
		Util.DisplayPM("You can't escape death in this location")
		return none
	elseIf _Aggressor
		Registry.SortPrimaryRegistryIfNeeded()
		Int n = Registry.GetPrimaryQuestCount()
		while n
			n -= 1
			daymoyl_QuestTemplate tQ = Registry.GetNthPrimaryQuest(n)
			if Selected as Bool && Selected.iPriority > tQ.iPriority
				return Selected
			endIf
			if tQ.bEnabled && tQ.QuestCondition(_CurrentLocation, _Aggressor, self.Follower)
				if Selected
					if utility.RandomInt(0, 1)
						Selected = tQ
					endIf
				else
					Selected = tQ
				endIf
			endIf
		endWhile
	endIf
	if !Selected && Registry.DefaultQuest.bEnabled && Registry.DefaultQuest.QuestCondition(_CurrentLocation, _Aggressor, self.Follower)
		Selected = Registry.DefaultQuest
	endIf
	return Selected
endFunction

function DisableAnimationSystem(String eventName, String strArg, Float numArg, form sender)

	if strArg == "Enable"
		if Variables.AnimationSetting == 0 && akPlayerRef.GetState() != "daymoylActive_CustomMethod"
			akPlayerRef.GotoState("daymoylActive_CustomMethod")
		elseIf Variables.AnimationSetting == 1 && akPlayerRef.GetState() != "daymoylActive_BleedoutAndRagdollMethod"
			akPlayerRef.GotoState("daymoylActive_BleedoutAndRagdollMethod")
		elseIf Variables.AnimationSetting == 2 && akPlayerRef.GetState() != "daymoylActive_BleedoutMethod"
			akPlayerRef.GotoState("daymoylActive_BleedoutMethod")
		elseIf Variables.AnimationSetting == 3 && akPlayerRef.GetState() != "daymoylActive_RagdollMethod"
			akPlayerRef.GotoState("daymoylActive_RagdollMethod")
		endIf
	elseIf akPlayerRef.GetState() != "daymoylActive_CustomMethod"
		akPlayerRef.GotoState("daymoylActive_CustomMethod")
	endIf
endFunction

function BleedoutExpired()

	self.GotoState("Recovering")
endFunction

function OnDisplayBleedoutMeter(String eventName, String strArg, Float numArg, form sender)

	Meter.ShowMeterAt(_BleedoutHP / maxHP, numArg)
endFunction

function HoldExtraFollowers(String eventName, String strArg, Float numArg, form sender)

	if strArg == "HoldExtra"
		akFollowerRef.HoldExtraFollowers()
	elseIf strArg == "HoldAll"
		akFollowerRef.HoldAllFollowers()
	elseIf strArg == "HoldNone"
		akFollowerRef.FreeAllFollowers()
	endIf
endFunction

function TryToStartBleedOut()

	; Empty function
endFunction

; Skipped compiler generated GetState

function ApplyBleedingDebuff()

	RegenClockTick = utility.GetCurrentGameTime()
	Util.RegisterForGameTimeModEvent("da_UpdateBleedingDebuff", 0.500000 / 24.0000)
	self.SetBleedoutExNearDeathDebuff(true)
	bBleeding = true
endFunction

Bool function IsFollowerIncapacitated()

	return !akFollowerRef.FollowerCanProtectPlayer()
endFunction

function SetBleedOutDebuff(Bool apply)

	if apply
		if BleedOutDebuffList[Variables.DifficultySetting] != self.BleedOutDebuff
			_Player.RemoveSpell(self.BleedOutDebuff)
		endIf
		_BleedOutDebuff = BleedOutDebuffList[Variables.DifficultySetting]
		if self.BleedOutDebuff
			_Player.AddSpell(self.BleedOutDebuff, false)
		endIf
	elseIf self.BleedOutDebuff
		_Player.RemoveSpell(self.BleedOutDebuff)
	endIf
endFunction

Bool function IsPlayerIncapacitated()

	return false
endFunction

function StartRecoverSequence(String eventName, String strArg, Float numArg, form sender)

	targetHP += numArg
	bKeepBlackScreen = strArg == "KeepBlackscreen"
	self.EndDefeat()
endFunction

function TriggerDefeat(objectreference akKiller)

	if _Player.GetActorValuePercentage("Health") <= Variables.HealthThreshold && !bProcessing
		debug.TraceConditional("daymoyl - Trigger!", Variables.bDebugMode)
		bProcessing = true
		bWaitToRecover = true
		bKeepBlackScreen = false
		bBypassFollowerCheck = false
		bBypassBleedoutQuest = false
		bRegisterForSheathe = false
		_Aggressor = none
		self.Aggressor = akKiller as Actor
		self.GotoState("EnterBleedOut")
	endIf
endFunction

function StartSecondaryQuest(String eventName, String strArg, Float numArg, form sender)

	daymoyl_QuestTemplate sec
	if strArg == "Both" || strArg == "FriendAndFoe"
		sec = self.PickSecondaryQuest(true, true)
	elseIf strArg == "FriendOnly"
		sec = self.PickSecondaryQuest(true, false)
	elseIf strArg == "FoeOnly"
		sec = self.PickSecondaryQuest(false, true)
	else
		debug.Trace("daymoyl - Unknown secondary quest requested by " + sender as String, 0)
		return 
	endIf
	if sec
		Float fSelectedProbability = sec.fProbability
		if sec.QuestStart(_CurrentLocation, _Aggressor, self.Follower)
			debug.TraceConditional("daymoyl - starting sub-quest " + sec as String, Variables.bDebugMode)
		endIf
		sec.fProbability = fSelectedProbability
	endIf
endFunction

function OnUpdate()

	fTimeInBleedOut += 1.00000
	debug.Trace("daymoyl - Update " + fTimeInBleedOut as String, 0)
	if fTimeInBleedOut >= Variables.BleedOutDuration
		debug.TraceConditional("daymoyl - Late Update", Variables.bDebugMode)
		self.BleedoutExpired()
	endIf
endFunction

daymoyl_QuestTemplate function PickOnBleedoutQuest()

	daymoyl_QuestTemplate Selected = none
	Registry.SortOnBleedoutRegistryIfNeeded()
	Int n = Registry.GetOnBleedoutQuestCount()
	while n
		n -= 1
		daymoyl_QuestTemplate tQ = Registry.GetNthOnBleedoutQuest(n)
		if Selected as Bool && Selected.iPriority != tQ.iPriority
			return Selected
		endIf
		if tQ.bEnabled && tQ.QuestCondition(_CurrentLocation, _Aggressor, self.Follower)
			if Selected
				if utility.RandomInt(0, 1)
					Selected = tQ
				endIf
			else
				Selected = tQ
			endIf
		endIf
	endWhile
	return Selected
endFunction

function OnEndNearDeathDebuff(String eventName, String strArg, Float numArg, form sender)

	self.SetNearDeathExBleedoutDebuff(false)
	bNearDeath = false
endFunction

function ModBleedoutHP(String eventName, String strArg, Float numArg, form sender)

	_BleedoutHP += numArg
	if numArg >= 0 as Float
		if _BleedoutHP > maxHP
			_BleedoutHP = maxHP
		endIf
	else
		self.ApplyBleedingDebuff()
		if _BleedoutHP < 0 as Float
			_BleedoutHP = 0 as Float
		endIf
	endIf
endFunction

function PlayerRecovered(String eventName, String strArg, Float numArg, form sender)

	; Empty function
endFunction

function DisableEventProcessing(String eventName, String strArg, Float numArg, form sender)

	if strArg == "Enable"
		if Variables.AnimationSetting == 0 && akPlayerRef.GetState() != "daymoylActive_CustomMethod"
			akPlayerRef.GotoState("daymoylActive_CustomMethod")
		elseIf Variables.AnimationSetting == 1 && akPlayerRef.GetState() != "daymoylActive_BleedoutAndRagdollMethod"
			akPlayerRef.GotoState("daymoylActive_BleedoutAndRagdollMethod")
		elseIf Variables.AnimationSetting == 2 && akPlayerRef.GetState() != "daymoylActive_BleedoutMethod"
			akPlayerRef.GotoState("daymoylActive_BleedoutMethod")
		elseIf Variables.AnimationSetting == 3 && akPlayerRef.GetState() != "daymoylActive_RagdollMethod"
			akPlayerRef.GotoState("daymoylActive_RagdollMethod")
		endIf
	elseIf akPlayerRef.GetState() != ""
		akPlayerRef.GotoState("")
	endIf
endFunction

function ForceBlackout(String eventName, String strArg, Float numArg, form sender)

	if !bProcessing
		debug.TraceConditional("daymoyl - Forced trigger!", Variables.bDebugMode)
		bProcessing = true
		bWaitToRecover = true
		bKeepBlackScreen = false
		bBypassFollowerCheck = true
		bBypassBleedoutQuest = true
		bRegisterForSheathe = false
		_Aggressor = none
		self.Aggressor = sender as Actor
		self.GotoState("EnterBleedOut")
		_BleedoutHP = -100.000
		self.TriggerDefeat(_Aggressor as objectreference)
	endIf
endFunction

function SetBlackScreenEffect(Bool apply, Bool bWoozy)

	debug.TraceConditional("daymoyl - SetBlackscreenEffect(" + apply as String + ")", Variables.bDebugMode)
	if apply && !bIsBlackScreen
		bIsBlackScreen = true
		bReadyToChangeBlackScreen = false
		FadeOut.apply(1.00000)
		utility.Wait(2.50000)
		FadeOut.PopTo(BlackScreen, 1.00000)
		bReadyToChangeBlackScreen = true
		debug.TraceConditional("daymoyl - BS added", Variables.bDebugMode)
	elseIf !apply && bIsBlackScreen as Bool
		while !bReadyToChangeBlackScreen
			utility.Wait(0.250000)
		endWhile
		utility.Wait(2.00000)
		if bWoozy
			BlackScreen.PopTo(WoozyFadeIn, 1.00000)
		else
			BlackScreen.PopTo(FadeIn, 1.00000)
		endIf
		utility.Wait(2.00000)
		bIsBlackScreen = false
		debug.TraceConditional("daymoyl - BS removed", Variables.bDebugMode)
	endIf
endFunction

function SetNearDeathExBleedoutDebuff(Bool apply)

	if apply
		self.SetBleedOutDebuff(false)
		self.SetNearDeathDebuff(true)
	else
		self.SetNearDeathDebuff(false)
		self.SetBleedOutDebuff(bBleeding)
	endIf
endFunction

function EndDefeat()

	self.GotoState("Recovering")
endFunction

function CheckStatus()

	_Player = game.GetPlayer()
	maxHP = _Player.GetBaseAV("Health")
	if !self.CurrentLocation
		self.CurrentLocation = _Player.GetCurrentLocation()
	endIf
	; debug.SetGodMode(false)
	; if !_Player.HasSpell(DADebug as form)
	; 	debug.Trace("daymoyl - Granted DA Debug spell", 0)
	; 	_Player.AddSpell(DADebug, false)
	; endIf
	debug.Trace("daymoyl - Registering custom quest events", 0)
	; bIsPrimaryQuestDisabled = false
	self.RegisterForModEvent("da_StartSecondaryQuest", "StartSecondaryQuest")
	; self.RegisterForModEvent("da_StartRecoverSequence", "StartRecoverSequence")
	; self.RegisterForModEvent("da_ModBleedoutHP", "ModBleedoutHP")
	self.RegisterForModEvent("da_ApplyBlackscreen", "ApplyBlackscreen")
	; self.RegisterForModEvent("da_PacifyNearbyEnemies", "PacifyNearbyEnemies")
	; self.RegisterForModEvent("da_RestorePacifiedEnemies", "RestorePacifiedEnemies")
	; self.RegisterForModEvent("da_DisableAnimationSystem", "DisableAnimationSystem")
	; self.RegisterForModEvent("da_DisableEventProcessing", "DisableEventProcessing")
	; self.RegisterForModEvent("da_DisableBlackoutScenario", "DisableBlackoutScenario")
	self.RegisterForModEvent("da_HoldExtraFollowers", "HoldExtraFollowers")
	; self.RegisterForModEvent("da_DisplayBleedoutMeter", "OnDisplayBleedoutMeter")
	; self.RegisterForModEvent("da_UpdateBleedingDebuff", "OnUpdateBleedingDebuff")
	; self.RegisterForModEvent("da_EndNearDeathDebuff", "OnEndNearDeathDebuff")
	; self.RegisterForModEvent("da_OnEndWeakenedDebuff", "OnEndWeakenedDebuff")
	; self.RegisterForModEvent("da_ForceBleedout", "ForceBleedout")
	; self.RegisterForModEvent("da_ForceBlackout", "ForceBlackout")
	; bProcessing = false
	; bProcessingOnHit = false
	; bWaitToRecover = false
endFunction

function OnUpdateBleedingDebuff(String eventName, String strArg, Float numArg, form sender)

	Float Time = utility.GetCurrentGameTime()
	_BleedoutHP += maxHP * (Time - RegenClockTick) / Variables.BleedoutDebuffDuration
	RegenClockTick = Time
	if _BleedoutHP >= maxHP
		_BleedoutHP = maxHP
		Util.UnregisterForGameTimeModEvent("da_UpdateBleedingDebuff")
		self.SendModEvent("da_EndBleedoutDebuff", "", 0.000000)
		self.SetBleedoutExNearDeathDebuff(false)
		bBleeding = false
	endIf
	Meter.ShowMeterAt(_BleedoutHP / maxHP, Variables.fMeterDuration)
endFunction

daymoyl_QuestTemplate function PickOnDeathQuest()

	daymoyl_QuestTemplate Selected = none
	Registry.SortOnDeathRegistryIfNeeded()
	Int n = Registry.GetOnDeathQuestCount()
	while n
		n -= 1
		daymoyl_QuestTemplate tQ = Registry.GetNthOnDeathQuest(n)
		if Selected as Bool && Selected.iPriority != tQ.iPriority
			return Selected
		endIf
		if tQ.bEnabled && tQ.QuestCondition(_CurrentLocation, _Aggressor, self.Follower)
			if Selected
				if utility.RandomInt(0, 1)
					Selected = tQ
				endIf
			else
				Selected = tQ
			endIf
		endIf
	endWhile
	return Selected
endFunction

daymoyl_QuestTemplate function PickSecondaryQuest(Bool bRescue, Bool bTheft)

	Bool SelectDetrimental
	Float r = utility.RandomFloat(0.000000, 100.000)
	debug.Trace("daymoyl - Secondary Quest First Roll " + r as String + "/100.0", 0)
	if bRescue && r < Variables.ChanceOfRescue
		SelectDetrimental = false
	elseIf bTheft && r > 100.000 - Variables.ChanceOfTheft
		SelectDetrimental = true
	else
		return none
	endIf
	Int n = Registry.SecondaryQuestRegistry.GetSize()
	Registry.ActivableSecondaryQuest.Revert()
	Float fSecondaryCumulative = 0.000000
	Int i = 0
	while i < n
		daymoyl_QuestTemplate tQ = Registry.SecondaryQuestRegistry.GetAt(i) as daymoyl_QuestTemplate
		if tQ.bEnabled && SelectDetrimental == tQ.bDetrimental && tQ.QuestCondition(_CurrentLocation, _Aggressor, self.Follower)
			fSecondaryCumulative = tQ.CompileProbability(fSecondaryCumulative)
			Registry.ActivableSecondaryQuest.AddForm(tQ as form)
		endIf
		i += 1
	endWhile
	n = Registry.ActivableSecondaryQuest.GetSize()
	r = utility.RandomFloat(0.000000, fSecondaryCumulative)
	debug.Trace("daymoyl - Secondary Quest Second Roll " + r as String + "/" + fSecondaryCumulative as String + " between " + n as String + " quests", 0)
	i = 0
	while i < n
		daymoyl_QuestTemplate tq = Registry.ActivableSecondaryQuest.GetAt(i) as daymoyl_QuestTemplate
		if r < tq.fCumulative
			return tq
		endIf
		i += 1
	endWhile
	return none
endFunction

function ForceDeath()

	debug.TraceConditional("daymoyl - Killed player with KillEssential", Variables.bDebugMode)
	debug.SetGodMode(false)
	_Player.KillEssential(none)
	_Player.EndDeferredKill()
endFunction

function ApplyBlackscreen(String eventName, String strArg, Float numArg, form sender)

	if self.GetState() != ""
		return 
	endIf
	if strArg == "Remove"
		self.SetBlackScreenEffect(false, false)
	elseIf strArg == "RemoveWoozy"
		self.SetBlackScreenEffect(false, true)
	else
		self.SetBlackScreenEffect(true, false)
	endIf
endFunction

function SetNearDeathDebuff(Bool apply)

	if apply
		if NearDeathDebuffList[Variables.DifficultySetting] != self.NearDeathDebuff
			_Player.RemoveSpell(self.NearDeathDebuff)
		endIf
		_NearDeathDebuff = NearDeathDebuffList[Variables.DifficultySetting]
		if self.NearDeathDebuff
			_Player.AddSpell(self.NearDeathDebuff, false)
		endIf
	elseIf self.NearDeathDebuff
		_Player.RemoveSpell(self.NearDeathDebuff)
	endIf
endFunction

function SetBleedoutExNearDeathDebuff(Bool apply)

	if apply
		self.SetBleedOutDebuff(!bNearDeath)
	else
		self.SetBleedOutDebuff(false)
	endIf
endFunction

; Skipped compiler generated GotoState

;-- State -------------------------------------------
state EnterBleedOut

	function BleedoutExpired()

		; Empty function
	endFunction

	function TriggerDefeat(objectreference akKiller)

		; Empty function
	endFunction

	function StartBleedOut()

		self.SendModEvent("da_BeginBleedout", "", 0.000000)
		if _Aggressor as Bool && !_Aggressor.IsDead() && _Aggressor.IsHostileToActor(_Player)
			_Aggressor.StartCombat(_Player)
		endIf
		self.BufferDamageReceived(9999.00)
		self.ApplyBleedingDebuff()
		bWaitToRecover = false
		if Variables.bTutorialActive && DisplayBleedoutTutorial.GetValueInt() == 1
			DisplayBleedoutTutorial.SetValueInt(0)
			BleedoutTutorial.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
		endIf
		akFollowerRef.FillFollowerAliasIfAble()
		if bBypassBleedoutQuest
			self.GotoState("bleedingout")
		else
			daymoyl_QuestTemplate OBOQuest = self.PickOnBleedoutQuest()
			if OBOQuest
				Int iSelectedPriority = OBOQuest.iPriority
				if !OBOQuest.QuestStart(_CurrentLocation, _Aggressor, self.Follower)
					self.GotoState("bleedingout")
				endIf
				OBOQuest.bEnabled = true
				OBOQuest.iPriority = iSelectedPriority
			else
				self.GotoState("bleedingout")
			endIf
		endIf
		fTimeInBleedOut = 0.000000
		self.RegisterForUpdate(1.00000)
	endFunction

	function TryToStartBleedOut()

		debug.TraceConditional("daymoyl - Reverted!", Variables.bDebugMode)
		self.SetPlayerControl(false)
		self.StartBleedOut()
	endFunction

	function onBeginState()

		debug.SetGodMode(true)
		self.SetPlayerControl(false)
		maxHP = _Player.GetBaseAV("Health")
		targetHP = 5.00000 + _Player.GetBaseAV("Health") * Variables.HealthThreshold
		self.BufferDamageReceived(9999.00)
		Meter.ShowMeterAt(_BleedoutHP / maxHP, Variables.fMeterLongDuration)
		LowHealthISM.apply(1.00000)
		LHHBID = LowHealthHeartBeat.Play(_Player as objectreference)
		if Variables.WerewolfModeQuest.IsRunning()
			_Player.PlayIdle(akPlayerRef.IdleBleedoutStart)
			Util.DisplayMSG(MsgRevert, 0.000000)
			Variables.WerewolfModeQuest.SetStage(100)
			return 
		elseIf Variables.VampireLordModeQuest as Bool && Variables.VampireLordModeQuest.IsRunning()
			_Player.PlayIdle(akPlayerRef.IdleBleedoutStart)
			Util.DisplayMSG(MsgRevert, 0.000000)
			Variables.VampireLordModeQuest.SetStage(100)
			return 
		endIf
		while _Player.GetAnimationVariableBool("IsBleedingOut")
			utility.Wait(0.100000)
		endWhile
		form ew = _Player.GetEquippedObject(1)
		if ew as Bool && ew.GetWeight() == 0.000000
			_Player.UnequipItemEx(ew, 1, false)
		elseIf !ew || (ew as spell) as Bool
			_Player.EquipSpell(DADebug, 1)
			_Player.UnequipSpell(DADebug, 1)
		endIf
		ew = _Player.GetEquippedObject(0)
		if ew as Bool && ew.GetWeight() == 0.000000
			_Player.UnequipItemEx(ew, 2, false)
		elseIf !ew || (ew as spell) as Bool
			_Player.EquipSpell(DADebug, 0)
			_Player.UnequipSpell(DADebug, 0)
		endIf
		armor ea = _Player.GetEquippedShield()
		if ea as Bool && ea.GetWeight() == 0.000000
			_Player.UnequipItem(ea as form, false, true)
		endIf
		self.StartBleedOut()
	endFunction

	function OnUpdate()

		fTimeInBleedOut += 1.00000
	endFunction

	Bool function IsPlayerIncapacitated()

		return true
	endFunction
endState

;-- State -------------------------------------------
state DyingOut

	function BleedoutExpired()

		if !bWaitToRecover
			self.GotoState("Recovering")
		endIf
	endFunction

	function onEndState()

		akPlayerRef.EnableIKPhysicsIfNeeded()
		game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
		self.SendModEvent("da_EndDying", "", 0.000000)
	endFunction

	function TriggerDefeat(objectreference akKiller)

		; Empty function
	endFunction

	function onBeginState()

		bWaitToRecover = true
		fTimeInBleedOut = 0.000000
		self.SendModEvent("da_BeginDying", "", 0.000000)
		game.DisablePlayerControls(true, true, false, false, false, true, true, false, 0)
		_Player.AddSpell(CalmSurrounding, false)
		_Player.StopCombat()
		_Player.StopCombatAlarm()
		akFollowerRef.OnDefeat(_Aggressor)
		daymoyl_QuestTemplate ODOQuest = self.PickOnDeathQuest()
		if ODOQuest
			self.SetBlackScreenEffect(true, false)
			akPlayerRef.DisableIKPhysicsIfNeeded()
			Int iSelectedPriority = ODOQuest.iPriority
			if ODOQuest.QuestStart(_CurrentLocation, _Aggressor, self.Follower)
				ODOQuest.bEnabled = true
				ODOQuest.iPriority = iSelectedPriority
				bWaitToRecover = false
				return 
			endIf
		endIf
		if Variables.ManageDeath
			Util.DisplayMSG(MsgSuccumb, 0.000000)
			self.ForceDeath()
		endIf
		bWaitToRecover = false
	endFunction

	function OnUpdate()

		fTimeInBleedOut += 1.00000
	endFunction

	Bool function IsPlayerIncapacitated()

		return true
	endFunction
endState

;-- State -------------------------------------------
state Recovering

	function TriggerDefeat(objectreference akKiller)

		; Empty function
	endFunction

	function onBeginState()

		debug.Trace("daymoyl - Recovering Start", 0)
		if bWaitToRecover
			return 
		endIf
		self.UnregisterForUpdate()
		if bProcessing
			fTimeInBleedOut = 0.000000
			bProcessing = false
			debug.SetGodMode(true)
			sound.StopInstance(LHHBID)
			LowHealthISM.Remove()
			self.BufferDamageReceived(targetHP)
			self.SendModEvent("da_EndBleedout", "", 0.000000)
			self.SetPlayerControl(true)
			self.SetBlackScreenEffect(bKeepBlackScreen, true)
			Util.DisplayMSG(MsgRecovered, 0.000000)
			utility.Wait(Variables.ImmunityDuration)
			debug.SetGodMode(false)
		endIf
		bProcessingOnHit = false
		self.GotoState("")
	endFunction

	Bool function IsPlayerIncapacitated()

		return false
	endFunction
endState

;-- State -------------------------------------------
state bleedingout

	function BleedoutExpired()

		if !bWaitToRecover
			self.GotoState("Recovering")
		endIf
	endFunction

	function TriggerDefeat(objectreference akKiller)

		if bProcessingOnHit
			return 
		endIf
		bProcessingOnHit = true
		self.Aggressor = akKiller as Actor
		Float hit = self.BufferDamageReceived(9999.00)
		if Variables.LargeHitThreshold > 0.000000 && hit > Variables.LargeHitThreshold * maxHP
			debug.TraceConditional("daymoyl - Large hit death", Variables.bDebugMode)
			self.GotoState("DyingOut")
		endIf
		_BleedoutHP -= hit * Variables.BleedOutDamageMult
		Meter.ShowMeterAt(_BleedoutHP / maxHP, Variables.fMeterLongDuration)
		if _BleedoutHP < 0.000000
			debug.SetGodMode(true)
			_BleedoutHP = 0.000000
			if !_Aggressor
				self.Aggressor = _Player.GetCombatTarget()
				if !_Aggressor
					debug.TraceConditional("daymoyl - Unknown aggressor", Variables.bDebugMode)
					self.Aggressor = Util.FindNearbyHostile()
				endIf
			endIf
			if akFollowerRef.FollowerCanProtectPlayer() && !bBypassFollowerCheck
				if _Aggressor as Bool && !_Aggressor.IsDead()
					if utility.RandomInt(0, 4) > 0
						_Aggressor.StartCombat(self.Follower)
					endIf
					self.Follower.StartCombat(_Aggressor)
				endIf
				bProcessingOnHit = false
				return 
			endIf
			bRegisterForSheathe = true
			if akPlayerRef.bIsSwimming
				self.GotoState("DrowningOut")
			elseIf bNearDeath
				self.GotoState("DyingOut")
			else
				self.GotoState("BlackingOut")
			endIf
		else
			bProcessingOnHit = false
		endIf
	endFunction

	function onBeginState()

		debug.SetGodMode(false)
	endFunction

	function OnUpdate()

		fTimeInBleedOut += 1.00000
		if bProcessingOnHit
			return 
		endIf
		bProcessingOnHit = true
		if fTimeInBleedOut >= Variables.BleedOutDuration
			fTimeInBleedOut = 0.000000
			if !bWaitToRecover
				if akFollowerRef.FollowerCanProtectPlayer() && self.Follower.GetCombatState() == 1
					if _BleedoutHP <= 0.000000 && utility.RandomInt(0, 4) as Bool
						Util.DisplayMSG(MsgFollower, 0.000000)
						bProcessingOnHit = false
						return 
					endIf
				endIf
			endIf
			self.GotoState("Recovering")
			bProcessingOnHit = false
		else
			bProcessingOnHit = false
			self.SendModEvent("da_UpdateBleedout", "", 0.000000)
			self.TriggerDefeat(_Aggressor as objectreference)
		endIf
	endFunction

	Bool function IsPlayerIncapacitated()

		return true
	endFunction
endState

;-- State -------------------------------------------
state BlackingOut

	function BleedoutExpired()

		if !bWaitToRecover
			self.GotoState("Recovering")
		endIf
	endFunction

	function onEndState()

		_Player.SetUnconscious(false)
		_Player.RemoveSpell(CalmSurrounding)
		akPlayerRef.EnableIKPhysicsIfNeeded()
		Util.SplatterBloodUnderPlayer()
		game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
		self.SendModEvent("da_EndBlackout", "", 0.000000)
	endFunction

	function TriggerDefeat(objectreference akKiller)

		; Empty function
	endFunction

	function onBeginState()

		bWaitToRecover = true
		fTimeInBleedOut = 0.000000
		self.SendModEvent("da_BeginBlackout", "", 0.000000)
		game.DisablePlayerControls(true, true, false, false, false, true, true, false, 0)
		_Player.AddSpell(CalmSurrounding, false)
		_Player.StopCombat()
		_Player.StopCombatAlarm()
		_Player.SetUnconscious(true)
		akFollowerRef.OnDefeat(_Aggressor)
		self.ApplyNearDeathDebuff()
		if Variables.bTutorialActive && DisplayBlackoutTutorial.GetValueInt() == 1
			DisplayBlackoutTutorial.SetValueInt(0)
			BlackoutTutorial.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
		endIf
		daymoyl_QuestTemplate CurrentQuest = self.PickPrimaryQuest()
		if CurrentQuest
			self.SetBlackScreenEffect(true, false)
			akPlayerRef.DisableIKPhysicsIfNeeded()
			utility.Wait(1.00000)
			Int iSelectedPriority = CurrentQuest.iPriority
			if CurrentQuest.QuestStart(_CurrentLocation, _Aggressor, self.Follower)
				CurrentQuest.bEnabled = true
				CurrentQuest.iPriority = iSelectedPriority
				bWaitToRecover = false
				return 
			else
				CurrentQuest.iPriority = iSelectedPriority
				debug.TraceConditional("daymoyl - Failed to start " + CurrentQuest as String, Variables.bDebugMode)
				CurrentQuest = Registry.DefaultQuest
				if CurrentQuest.bEnabled && CurrentQuest.QuestStart(_CurrentLocation, _Aggressor, self.Follower)
					bWaitToRecover = false
					return 
				endIf
			endIf
		endIf
		debug.TraceConditional("daymoyl - Failed to start " + CurrentQuest as String, Variables.bDebugMode)
		self.GotoState("DyingOut")
	endFunction

	function OnUpdate()

		fTimeInBleedOut += 1.00000
	endFunction

	Bool function IsPlayerIncapacitated()

		return true
	endFunction
endState

;-- State -------------------------------------------
state DrowningOut

	function BleedoutExpired()

		if !bWaitToRecover
			self.GotoState("Recovering")
		endIf
	endFunction

	function onEndState()

		akPlayerRef.EnableIKPhysicsIfNeeded()
		game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
		self.SendModEvent("da_EndDrowning", "", 0.000000)
	endFunction

	function TriggerDefeat(objectreference akKiller)

		; Empty function
	endFunction

	function onBeginState()

		bWaitToRecover = true
		fTimeInBleedOut = 0.000000
		self.SendModEvent("da_BeginDrowning", "", 0.000000)
		game.DisablePlayerControls(true, true, false, false, false, true, true, false, 0)
		_Player.AddSpell(CalmSurrounding, false)
		_Player.StopCombat()
		_Player.StopCombatAlarm()
		akFollowerRef.OnDefeat(_Aggressor)
		daymoyl_QuestTemplate ODOQuest = self.PickOnDeathQuest()
		if ODOQuest
			self.SetBlackScreenEffect(true, false)
			akPlayerRef.DisableIKPhysicsIfNeeded()
			Int iSelectedPriority = ODOQuest.iPriority
			if ODOQuest.QuestStart(_CurrentLocation, _Aggressor, self.Follower)
				ODOQuest.bEnabled = true
				ODOQuest.iPriority = iSelectedPriority
				bWaitToRecover = false
				return 
			endIf
		endIf
		if Variables.ManageDeath
			Util.DisplayMSG(MsgDrowned, 0.000000)
			self.ForceDeath()
		endIf
		bWaitToRecover = false
	endFunction

	function OnUpdate()

		fTimeInBleedOut += 1.00000
	endFunction

	Bool function IsPlayerIncapacitated()

		return true
	endFunction
endState
