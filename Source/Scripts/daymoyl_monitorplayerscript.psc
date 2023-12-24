;/ Decompiled by Champollion V1.0.1
Source   : daymoyl_MonitorPlayerScript.psc
Modified : 2016-02-29 03:05:35
Compiled : 2016-02-29 03:05:44
User     : Harawada
Computer : HARAWADA-PC
/;
scriptName daymoyl_monitorplayerscript extends ReferenceAlias

;-- Properties --------------------------------------
Bool property bIsSwimming
	Bool function get()

		return _Player.IsSwimming()
	endFunction
endproperty
spell property FollowerBehaviorCloak auto
Bool property bBlackoutAnimating = false auto hidden
daymoyl_monitorutility property Util auto
Bool property bRagdollAnimating = false auto hidden
daymoyl_monitorvariables property Variables auto
daymoyl_monitorscript property Monitor auto
idle property IdleBleedoutStart auto
Bool property bBleedoutAnimating = false auto hidden
Bool property bIs1stPersonCamera = false auto hidden
idle property IdleBleedoutStop auto
idle property IdleTG05GetUp auto
idle property IdleTG05Knockdown auto

;-- Variables ---------------------------------------
Actor _Player
Bool bRagdollAnimated = false

;-- Functions ---------------------------------------

function OnInit()

	debug.Trace("daymoyl - OnInit", 0)
	OnPlayerLoadGame()
endFunction

function EndBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

	; Empty function
endFunction

function RegisterPlayerModEvents()

	self.RegisterForModEvent("da_BeginBleedout", "StartBleedoutAnim")
	self.RegisterForModEvent("da_EndBleedout", "EndBleedoutAnim")
	self.RegisterForModEvent("da_UpdateBleedout", "UpdateBleedoutAnim")
	self.RegisterForModEvent("da_BeginBlackout", "StartBlackoutAnim")
	self.RegisterForModEvent("da_EndBlackout", "EndBlackoutAnim")
endFunction

function EndBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

	; Empty function
endFunction

function PlayerRecoveredLastUpdate()

	if Monitor.RegisteredForSheathe
		utility.Wait(0.250000)
		game.SetPlayerAIDriven(true)
		utility.Wait(0.100000)
		game.SetPlayerAIDriven(false)
		game.DisablePlayerControls(true, true, false, false, false, true, true, false, 0)
		utility.Wait(0.100000)
		game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
	endIf
endFunction

function OnDying(Actor akKiller)

	debug.Trace("daymoyl - On Dying", 0)
endFunction

function UpdateBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

	; Empty function
endFunction

function DisableIKPhysicsIfNeeded()

	if bRagdollAnimating
		bRagdollAnimated = true
		_Player.ForceRemoveRagdollFromWorld()
	endIf
endFunction

function StartBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

	; Empty function
endFunction

function OnPlayerLoadGame()
	debug.TraceConditional("[DAYMOYL] - OnPlayerLoadGame Update", Variables.bDebugMode)
	_Player = game.GetPlayer()
	Util.RefreshRegisteredModEvent()
	Monitor.CheckStatus()

	; debug.TraceConditional("daymoyl - OnPlayerLoadGame", Variables.bDebugMode)
	; debug.Trace("daymoyl - OnPlayerLoadGame", 0)
	; if Variables.ModActive
	; 	self.RegisterForSingleUpdate(1.00000)
	; endIf
endFunction

function RegisterPlayerAnimEvents()

	self.RegisterForAnimationEvent(_Player as objectreference, "RemoveCharacterControllerFromWorld")
	self.RegisterForAnimationEvent(_Player as objectreference, "GetUpEnd")
	self.RegisterForAnimationEvent(_Player as objectreference, "JumpLandEnd")
endFunction

function onEndState()

	debug.Trace("daymoyl - Waking Up", 0)
	if Variables.bFollowerCloakActive
		_Player.AddSpell(FollowerBehaviorCloak, false)
	endIf
	self.RegisterForSingleUpdate(1.00000)
endFunction

function onBeginState()

	if Variables.bFollowerCloakActive
		_Player.RemoveSpell(FollowerBehaviorCloak)
	endIf
	debug.Trace("daymoyl - Shutting Down", 0)
endFunction

function EnableIKPhysicsIfNeeded()

	if bRagdollAnimated
		_Player.ForceAddRagdollToWorld()
		bRagdollAnimated = false
	endIf
endFunction

function StartBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

	; Empty function
endFunction

function OnUpdate()

	debug.TraceConditional("daymoyl - OnPlayerLoadGame Update", Variables.bDebugMode)
	_Player = game.GetPlayer()
	self.RegisterPlayerAnimEvents()
	self.RegisterPlayerModEvents()
	Util.RefreshRegisteredModEvent()
	Monitor.CheckStatus()
	Util.DisplayPM("DA Ready")
endFunction

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

;-- State -------------------------------------------
state daymoylactive_bleedoutandragdollmethod

	function OnCellLoad()

		if Variables.bFollowerCloakActive
			_Player.RemoveSpell(FollowerBehaviorCloak)
			utility.Wait(0.100000)
			_Player.AddSpell(FollowerBehaviorCloak, false)
		endIf
	endFunction

	function OnLocationChange(Location akOldLoc, Location akNewLoc)

		if akNewLoc
			Monitor.CurrentLocation = akNewLoc
		endIf
	endFunction

	function StartBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Normal -> Bleedout", Variables.bDebugMode)
			bBleedoutAnimating = true
			game.ForceThirdPerson()
			utility.Wait(0.100000)
			if !bRagdollAnimating
				_Player.PlayIdle(IdleBleedoutStart)
			endIf
		endIf
	endFunction

	function OnAnimationEvent(objectreference akSource, String asEventName)

		if akSource == _Player as objectreference
			if asEventName == "RemoveCharacterControllerFromWorld"
				debug.TraceConditional("daymoyl - received Ragdoll Start anim event", Variables.bDebugMode)
				bRagdollAnimating = true
			elseIf asEventName == "GetUpEnd"
				debug.TraceConditional("daymoyl - received Ragdoll Stop anim event", Variables.bDebugMode)
				if !bBlackoutAnimating
					if bBleedoutAnimating
						debug.TraceConditional("daymoyl - Anim Bleedout -> Bleedout", Variables.bDebugMode)
						utility.Wait(0.100000)
						_Player.PlayIdle(IdleBleedoutStart)
					else
						debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
						self.PlayerRecoveredLastUpdate()
						self.SendModEvent("da_PlayerRecovered", "", 0.000000)
					endIf
				endIf
				bRagdollAnimating = false
			elseIf asEventName == "JumpLandEnd"
				debug.TraceConditional("daymoyl - JumpLandEnd", Variables.bDebugMode)
				utility.Wait(Variables.CriticalBleedOutDelay)
				if _Player.GetActorValue("Health") <= 0.000000 || Monitor.IsPlayerIncapacitated()
					Monitor.GotoState("DyingOut")
				endIf
			endIf
		endIf
	endFunction

	function EndBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - End Blackout", Variables.bDebugMode)
			bBlackoutAnimating = false
		endIf
	endFunction

	function OnEnterBleedout()

		if self.bIsSwimming
			Monitor.GotoState("DrowningOut")
			return 
		endIf
		if _Player.GetActorValuePercentage("Health") <= Variables.HealthThreshold + 0.100000
			debug.TraceConditional("daymoyl - OnEnterBleedout - No Hit", Variables.bDebugMode)
			Monitor.TriggerDefeat(none)
		else
			debug.TraceConditional("daymoyl - OnEnterBleedout - Wait for Hit", Variables.bDebugMode)
			utility.Wait(Variables.CriticalBleedOutDelay)
			if Monitor.GetState() == ""
				Monitor.GotoState("DyingOut")
			endIf
		endIf
	endFunction

	function onEndState()

		; Empty function
	endFunction

	function UpdateBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			if bBleedoutAnimating as Bool && !bBlackoutAnimating && !bRagdollAnimating
				_Player.PlayIdle(IdleBleedoutStart)
			endIf
		endIf
	endFunction

	function OnHit(objectreference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)

		Monitor.TriggerDefeat(akAggressor)
	endFunction

	function StartBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			bBlackoutAnimating = true
			_Player.PushActorAway(_Player, 0 as Float)
			_Player.ApplyHavokImpulse(_Player.GetAngleX(), _Player.GetAngleY(), 0.300000, 10 as Float)
		endIf
	endFunction

	function onBeginState()

		; Empty function
	endFunction

	function EndBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Bleedout -> Normal", Variables.bDebugMode)
			if !bRagdollAnimating
				_Player.PlayIdle(IdleBleedoutStop)
				debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
				self.PlayerRecoveredLastUpdate()
				self.SendModEvent("da_PlayerRecovered", "", 0.000000)
			else
				_Player.PushActorAway(_Player, 0 as Float)
			endIf
			bBleedoutAnimating = false
		endIf
	endFunction

	function OnRaceSwitchComplete()

		self.RegisterPlayerAnimEvents()
		Monitor.TryToStartBleedOut()
	endFunction
endState

;-- State -------------------------------------------
state daymoylactive_bleedoutmethod

	function OnCellLoad()

		if Variables.bFollowerCloakActive
			_Player.RemoveSpell(FollowerBehaviorCloak)
			utility.Wait(0.100000)
			_Player.AddSpell(FollowerBehaviorCloak, false)
		endIf
	endFunction

	function OnLocationChange(Location akOldLoc, Location akNewLoc)

		if akNewLoc
			Monitor.CurrentLocation = akNewLoc
		endIf
	endFunction

	function StartBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Normal -> Bleedout", Variables.bDebugMode)
			bBleedoutAnimating = true
			game.ForceThirdPerson()
			if !bRagdollAnimating
				_Player.PlayIdle(IdleBleedoutStart)
			endIf
		endIf
	endFunction

	function OnAnimationEvent(objectreference akSource, String asEventName)

		if akSource == _Player as objectreference
			if asEventName == "RemoveCharacterControllerFromWorld"
				debug.TraceConditional("daymoyl - received Ragdoll Start anim event", Variables.bDebugMode)
				bRagdollAnimating = true
			elseIf asEventName == "GetUpEnd"
				debug.TraceConditional("daymoyl - received Ragdoll Stop anim event", Variables.bDebugMode)
				if !bBlackoutAnimating
					if bBleedoutAnimating
						debug.TraceConditional("daymoyl - Anim Bleedout -> Bleedout", Variables.bDebugMode)
						utility.Wait(0.100000)
						_Player.PlayIdle(IdleBleedoutStart)
					else
						debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
						self.PlayerRecoveredLastUpdate()
						self.SendModEvent("da_PlayerRecovered", "", 0.000000)
					endIf
				endIf
				bRagdollAnimating = false
			elseIf asEventName == "JumpLandEnd"
				debug.TraceConditional("daymoyl - JumpLandEnd", Variables.bDebugMode)
				utility.Wait(Variables.CriticalBleedOutDelay)
				if _Player.GetActorValue("Health") <= 0.000000 || Monitor.IsPlayerIncapacitated()
					Monitor.GotoState("DyingOut")
				endIf
			endIf
		endIf
	endFunction

	function EndBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			bBlackoutAnimating = false
		endIf
	endFunction

	function OnEnterBleedout()

		if self.bIsSwimming
			Monitor.GotoState("DrowningOut")
			return 
		endIf
		if _Player.GetActorValuePercentage("Health") <= Variables.HealthThreshold + 0.100000
			debug.TraceConditional("daymoyl - OnEnterBleedout - No Hit", Variables.bDebugMode)
			Monitor.TriggerDefeat(none)
		else
			debug.TraceConditional("daymoyl - OnEnterBleedout - Wait for Hit", Variables.bDebugMode)
			utility.Wait(Variables.CriticalBleedOutDelay)
			if Monitor.GetState() == ""
				Monitor.GotoState("DyingOut")
			endIf
		endIf
	endFunction

	function onEndState()

		; Empty function
	endFunction

	function UpdateBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			if bBleedoutAnimating as Bool && !bBlackoutAnimating && !bRagdollAnimating
				_Player.PlayIdle(IdleBleedoutStart)
			endIf
		endIf
	endFunction

	function OnHit(objectreference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)

		Monitor.TriggerDefeat(akAggressor)
	endFunction

	function StartBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			bBlackoutAnimating = true
		endIf
	endFunction

	function onBeginState()

		; Empty function
	endFunction

	function EndBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Bleedout -> Normal", Variables.bDebugMode)
			if !bRagdollAnimating
				_Player.PlayIdle(IdleBleedoutStop)
				debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
				self.PlayerRecoveredLastUpdate()
				self.SendModEvent("da_PlayerRecovered", "", 0.000000)
			else
				_Player.PushActorAway(_Player, 0 as Float)
			endIf
			bBleedoutAnimating = false
		endIf
	endFunction

	function OnRaceSwitchComplete()

		self.RegisterPlayerAnimEvents()
		Monitor.TryToStartBleedOut()
	endFunction
endState

;-- State -------------------------------------------
state daymoylactive_ragdollmethod

	function OnCellLoad()

		if Variables.bFollowerCloakActive
			_Player.RemoveSpell(FollowerBehaviorCloak)
			utility.Wait(0.100000)
			_Player.AddSpell(FollowerBehaviorCloak, false)
		endIf
	endFunction

	function OnLocationChange(Location akOldLoc, Location akNewLoc)

		if akNewLoc
			Monitor.CurrentLocation = akNewLoc
		endIf
	endFunction

	function StartBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Normal -> Bleedout", Variables.bDebugMode)
			bBleedoutAnimating = true
			game.ForceThirdPerson()
			_Player.PushActorAway(_Player, 0 as Float)
			_Player.ApplyHavokImpulse(_Player.GetAngleX(), _Player.GetAngleY(), 0.300000, 10 as Float)
		endIf
	endFunction

	function OnAnimationEvent(objectreference akSource, String asEventName)

		if akSource == _Player as objectreference
			if asEventName == "RemoveCharacterControllerFromWorld"
				debug.TraceConditional("daymoyl - received Ragdoll Start anim event", Variables.bDebugMode)
				bRagdollAnimating = true
			elseIf asEventName == "GetUpEnd"
				debug.TraceConditional("daymoyl - received Ragdoll Stop anim event", Variables.bDebugMode)
				if !bBlackoutAnimating
					if bBleedoutAnimating
						debug.TraceConditional("daymoyl - Anim Bleedout -> Bleedout", Variables.bDebugMode)
						_Player.PushActorAway(_Player, 0 as Float)
						_Player.ApplyHavokImpulse(_Player.GetAngleX(), _Player.GetAngleY(), 0.300000, 10 as Float)
					else
						debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
						self.PlayerRecoveredLastUpdate()
						self.SendModEvent("da_PlayerRecovered", "", 0.000000)
					endIf
				endIf
				bRagdollAnimating = false
			elseIf asEventName == "JumpLandEnd"
				debug.TraceConditional("daymoyl - JumpLandEnd", Variables.bDebugMode)
				utility.Wait(Variables.CriticalBleedOutDelay)
				if _Player.GetActorValue("Health") <= 0.000000 || Monitor.IsPlayerIncapacitated()
					Monitor.GotoState("DyingOut")
				endIf
			endIf
		endIf
	endFunction

	function OnEnterBleedout()

		if self.bIsSwimming
			Monitor.GotoState("DrowningOut")
			return 
		endIf
		if _Player.GetActorValuePercentage("Health") <= Variables.HealthThreshold + 0.100000
			debug.TraceConditional("daymoyl - OnEnterBleedout - No Hit", Variables.bDebugMode)
			Monitor.TriggerDefeat(none)
		else
			debug.TraceConditional("daymoyl - OnEnterBleedout - Wait for Hit", Variables.bDebugMode)
			utility.Wait(Variables.CriticalBleedOutDelay)
			if Monitor.GetState() == ""
				Monitor.GotoState("DyingOut")
			endIf
		endIf
	endFunction

	function onEndState()

		; Empty function
	endFunction

	function EndBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			bBlackoutAnimating = false
		endIf
	endFunction

	function OnHit(objectreference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)

		Monitor.TriggerDefeat(akAggressor)
	endFunction

	function StartBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			bBlackoutAnimating = true
		endIf
	endFunction

	function onBeginState()

		; Empty function
	endFunction

	function EndBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Bleedout -> Normal", Variables.bDebugMode)
			if !bRagdollAnimating
				debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
				self.PlayerRecoveredLastUpdate()
				self.SendModEvent("da_PlayerRecovered", "", 0.000000)
			else
				_Player.PushActorAway(_Player, 0 as Float)
			endIf
			bBleedoutAnimating = false
		endIf
	endFunction

	function OnRaceSwitchComplete()

		self.RegisterPlayerAnimEvents()
		Monitor.TryToStartBleedOut()
	endFunction
endState

;-- State -------------------------------------------
state daymoylactive_custommethod

	function OnCellLoad()

		if Variables.bFollowerCloakActive
			_Player.RemoveSpell(FollowerBehaviorCloak)
			utility.Wait(0.100000)
			_Player.AddSpell(FollowerBehaviorCloak, false)
		endIf
	endFunction

	function OnLocationChange(Location akOldLoc, Location akNewLoc)

		if akNewLoc
			Monitor.CurrentLocation = akNewLoc
		endIf
	endFunction

	function StartBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Normal -> Bleedout", Variables.bDebugMode)
			bBleedoutAnimating = true
		endIf
	endFunction

	function OnAnimationEvent(objectreference akSource, String asEventName)

		if akSource == _Player as objectreference
			if asEventName == "RemoveCharacterControllerFromWorld"
				debug.TraceConditional("daymoyl - received Ragdoll Start anim event", Variables.bDebugMode)
				bRagdollAnimating = true
			elseIf asEventName == "GetUpEnd"
				debug.TraceConditional("daymoyl - received Ragdoll Stop anim event", Variables.bDebugMode)
				if !bBleedoutAnimating
					debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
					self.PlayerRecoveredLastUpdate()
					self.SendModEvent("da_PlayerRecovered", "", 0.000000)
				endIf
				bRagdollAnimating = false
			elseIf asEventName == "JumpLandEnd"
				debug.TraceConditional("daymoyl - JumpLandEnd", Variables.bDebugMode)
				utility.Wait(Variables.CriticalBleedOutDelay)
				if _Player.GetActorValue("Health") <= 0.000000 || Monitor.IsPlayerIncapacitated()
					Monitor.GotoState("DyingOut")
				endIf
			endIf
		endIf
	endFunction

	function OnEnterBleedout()

		if self.bIsSwimming
			Monitor.GotoState("DrowningOut")
			return 
		endIf
		if _Player.GetActorValuePercentage("Health") <= Variables.HealthThreshold + 0.100000
			debug.TraceConditional("daymoyl - OnEnterBleedout - No Hit", Variables.bDebugMode)
			Monitor.TriggerDefeat(none)
		else
			debug.TraceConditional("daymoyl - OnEnterBleedout - Wait for Hit", Variables.bDebugMode)
			utility.Wait(Variables.CriticalBleedOutDelay)
			if Monitor.GetState() == ""
				Monitor.GotoState("DyingOut")
			endIf
		endIf
	endFunction

	function onEndState()

		; Empty function
	endFunction

	function EndBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			bBlackoutAnimating = false
		endIf
	endFunction

	function OnHit(objectreference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)

		Monitor.TriggerDefeat(akAggressor)
	endFunction

	function StartBlackoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			bBlackoutAnimating = true
		endIf
	endFunction

	function onBeginState()

		; Empty function
	endFunction

	function EndBleedoutAnim(String eventName, String strArg, Float numArg, Form sender)

		if sender == Monitor as Form
			debug.TraceConditional("daymoyl - Anim Bleedout -> Normal", Variables.bDebugMode)
			if !bRagdollAnimating
				debug.TraceConditional("daymoyl - Player Recovered", Variables.bDebugMode)
				self.PlayerRecoveredLastUpdate()
				self.SendModEvent("da_PlayerRecovered", "", 0.000000)
			else
				_Player.PushActorAway(_Player, 0 as Float)
			endIf
			bBleedoutAnimating = false
		endIf
	endFunction

	function OnRaceSwitchComplete()

		self.RegisterPlayerAnimEvents()
		Monitor.TryToStartBleedOut()
	endFunction
endState
