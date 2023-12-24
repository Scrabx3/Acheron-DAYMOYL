;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname qf_daymoyl_defeatedforsworn_0201f576 Extends Quest Hidden

;BEGIN ALIAS PROPERTY theFollower
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theFollower Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theJailer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theJailer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCage
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCage Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theJailerMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theJailerMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCollisionBoxBack
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCollisionBoxBack Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theDoor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theDoor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theFollowerMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theFollowerMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theForsworn
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theForsworn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCollisionBoxRight
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCollisionBoxRight Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theEscapeTriggerBox
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theEscapeTriggerBox Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCollisionBoxLeft
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCollisionBoxLeft Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
self.GotoState("")
if AddedPlayerToFaction
	thePlayer.RemoveFromFaction(captivefaction)
	AddedPlayerToFaction = false
endIf
if theFollower
	theFollower.RemoveFromFaction(captivefaction)
	FollowerStandStillScene.Stop()
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
self.SendModEvent("da_ApplyBlackscreen")
Utility.Wait(5)

self.SendModEvent("da_HoldExtraFollowers", "HoldExtra", 0.000000)
thePlayer = Alias_thePlayer.GetRef() as Actor
theMarker = Alias_theMarker.GetRef()
debug.Trace("[DAYMOYL] - Teleported to Forsworn Camp Location", 0)
Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0000)
if !thePlayer.IsInFaction(captivefaction)
	AddedPlayerToFaction = true
	thePlayer.AddToFaction(captivefaction)
endIf
game.SetPlayerAIDriven(false)
thePlayer.MoveTo(theMarker, 0.000000, 0.000000, 0.000000, true)
theCage = theMarker.PlaceAtMe(Cage as form, 1, false, false)
theCage.SetPosition(theMarker.GetPositionX(), theMarker.GetPositionY(), theMarker.GetPositionZ() + 93.3300)
theCage.SetAngle(theMarker.GetAngleX(), theMarker.GetAngleY(), theMarker.GetAngleZ())
Int lockDifficulty = utility.RandomInt(1, 4) * 25
theCageDoor = Alias_theDoor.GetRef()
theCageDoor.SetOpen(false)
theCageDoor.SetLockLevel(lockDifficulty)
theCageDoor.Lock(true, false)
theCageDoor.MoveTo(theCage, 0.000000, 0.000000, 0.000000, true)
Float dir = theCage.GetAngleZ()
Float c = math.Cos(dir)
Float S = math.Sin(dir)
Alias_theEscapeTriggerBox.GetRef().MoveTo(theCage, -(32.0000 * c) + 150.000 * S, 32.0000 * S + 150.000 * c, 28.0000, true)
theJailerMarker = theCage.PlaceAtMe(Marker as form, 1, false, false)
theJailerMarker.MoveTo(theCage, 128.000 * math.Sin(dir), 128.000 * math.Cos(dir), 0.000000, true)
Alias_theJailerMarker.ForceRefTo(theJailerMarker)
theJailer = theJailerMarker.PlaceAtMe(Jailer as form, 1, false, false)
Alias_theJailer.ForceRefTo(theJailer)
key theKey = theCageDoor.GetKey()
if theKey
	theJailer.AddItem(theKey as form, 1, false)
endIf
form Fire = game.GetFormFromFile(221001, "Skyrim.esm")
theFire = theMarker.PlaceAtMe(Fire, 1, false, false)
theFire.MoveTo(theMarker, 160.000 * math.Sin(dir + 115.000), 160.000 * math.Cos(dir + 115.000), 5.00000, true)
thePlayerMarker = theCage.PlaceAtMe(Marker as form, 1, false, false)
thePlayerMarker.MoveTo(theCage, 100.000 * math.Sin(dir + 180.000), 100.000 * math.Cos(dir + 180.000), 0.000000, true)
thePlayer.MoveTo(thePlayerMarker, 0.000000, 0.000000, 0.000000, true)
theFollower = Alias_theFollower.GetRef() as Actor
if theFollower as Bool && !theFollower.IsDead()
	theFollower.AddToFaction(captivefaction)
	theFollowerMarker = thePlayerMarker.PlaceAtMe(Marker as form, 1, false, false)
	theFollowerMarker.MoveTo(thePlayerMarker, 50.0000 * math.Sin(dir - 90.0000), 50.0000 * math.Cos(dir - 90.0000), 0.000000, true)
	Alias_theFollowerMarker.ForceRefTo(theFollowerMarker)
	theFollower.MoveTo(theFollowerMarker, 0.000000, 0.000000, 0.000000, true)
	RecoveryQuest.StealAllItemsFromTargetAndBlame(theFollower as ObjectReference, theJailer, true)
	theFollower.AddItem(RagOutfit as form, 1, true)
	theFollower.EquipItem(RagOutfit as form, false, true)
else
	theFollowerMarker = none
	theFollower = none
endIf
Int[] typesToRemove = new Int[3]
typesToRemove[0] = 26
typesToRemove[1] = 41
typesToRemove[2] = 42
RecoveryQuest.StealItemsOfTypesFromPlayerAndBlame(typesToRemove, theJailer, true)
thePlayer.AddItem(RagOutfit as form, 1, true)
thePlayer.EquipItem(RagOutfit as form, false, true)
self.SetObjectiveDisplayed(0, true, true)
self.RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)
self.RegisterForUpdateGameTime(1.00000)
Acheron.RescueActor(thePlayer, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
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
Acheron.DisableConsequence(false)
; self.SendModEvent("da_DisableBlackoutScenario", "Enable", 0.000000)
self.UnRegisterForUpdateGameTime()
Util.UnregisterForOnReload(self as form, "daymoyl_StartMarkarthRescue")
self.GotoState("")
self.SetObjectiveDisplayed(0, false, false)
if AddedPlayerToFaction
	thePlayer.RemoveFromFaction(captivefaction)
	AddedPlayerToFaction = false
endIf
if theFollower
	theFollower.RemoveFromFaction(captivefaction)
	FollowerStandStillScene.Stop()
endIf
if theFollowerMarker
	theFollowerMarker.DeleteWhenAble()
endIf
theCage.DeleteWhenAble()
theCageDoor.MoveToMyEditorLocation()
Alias_theEscapeTriggerBox.GetRef().MoveToMyEditorLocation()
theFire.DeleteWhenAble()
thePlayerMarker.DeleteWhenAble()
theJailerMarker.DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
bReleaseSceneOn = false
RecoveryQuest.StealPreciousItemsFromPlayerAndBlame(theJailer, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Prompt.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
; self.SendModEvent("da_StartRecoverSequence", "", 0.000000)
self.SendModEvent("da_ApplyBlackscreen", "RemoveWoozy", 0.000000)
bReleaseSceneOn = false
Util.RegisterForOnReload(self as form, "daymoyl_StartMarkarthRescue", "StartMarkarthRescue")
self.GotoState("WaitingForRescue")
if Variables.bTutorialActive && DisplayTutorial.GetValueInt() == 1
	DisplayTutorial.SetValueInt(0)
	Tutorial.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
endIf
; self.SendModEvent("da_DisableBlackoutScenario", "", 0.000000)
Acheron.DisableConsequence(true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

state WaitingForRescue
	function onEndState()
		Util.UnregisterForGameTimeModEvent("daymoyl_StartMarkarthRescue")
		self.SendModEvent("da_HoldExtraFollowers", "HoldNone", 0.000000)
	endFunction

	function onBeginState()
		self.SendModEvent("da_HoldExtraFollowers", "HoldExtra", 0.000000)
		Util.RegisterForSingleGameTimeModEvent("daymoyl_StartMarkarthRescue", utility.RandomFloat(0.250000, 1.50000))
	endFunction

	function StartMarkarthRescue(String eventName, String strArg, Float numArg, form sender)
		if MarkarthCrimeFaction.GetCrimeGold() > 10
			theCageDoor.Lock(false, false)
			theCageDoor.SetOpen(true)
			bReleaseSceneOn = true
			ReleaseScene.Start()
		else
			RansomQuest.Start()
		endIf
	endFunction
endState

function GiveFoodandDrink()
	thePlayer.AddItem(Bread as form, 1, false)
	thePlayer.AddItem(Soup as form, 1, false)
endFunction

function OnUpdateGameTime()
	if bReleaseSceneOn as Bool && !ReleaseScene.IsPlaying()
		ReleaseScene.Start()
	endIf
endFunction

function TransferItemsToTarget(ObjectReference target)
	RecoveryQuest.TransferStolenItemsBetweenTargetsIfAble(theJailer, thePlayer as ObjectReference, true)
endFunction

function OnJailerDeath()
	self.GotoState("")
	theCageDoor.SetOpen(true)
endFunction

function OnUpdate()
	if self.GetStage() == 0
		self.SetStage(10)
	endIf
endFunction

function StartMarkarthRescue(String eventName, String strArg, Float numArg, form sender)
	; Empty function
endFunction

ObjectReference thePlayerMarker
Actor theFollower
ObjectReference theJailerMarker
ObjectReference theJailer
ObjectReference theFollowerMarker
Bool bReleaseSceneOn = false
ObjectReference theMarker
ObjectReference theCageDoor
Bool AddedPlayerToFaction = false
ObjectReference theCage
ObjectReference theFire
Actor thePlayer

potion property Bread auto
door property CageDoor auto
daymoyl_monitorutility property Util auto
static property Cage auto
globalvariable property DisplayTutorial auto
Quest property RansomQuest auto
potion property Soup auto
static property Marker auto
daymoyl_monitorvariables property Variables auto
actorbase property Jailer auto
daymoyl_getyourgearscript property RecoveryQuest auto
scene property ReleaseScene auto
container property Chest auto
scene property FollowerStandStillScene auto
faction property MarkarthCrimeFaction auto
armor property RagOutfit auto
faction property captivefaction auto
miscobject property Gold auto
message property Tutorial auto
message property Prompt auto

ImageSpaceModifier Property FadeToBlackImod  Auto  
