;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname qf_daymoyl_defeateddraugr_02001d91 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theUrn
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theUrn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theAlcove
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theAlcove Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInsideEntrance
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theInsideEntrance Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
self.SendModEvent("da_ApplyBlackscreen")
Utility.Wait(5)


Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0000)
akPlayer = Alias_thePlayer.GetRef() as Actor
if Alias_theMarker.GetRef()
	akPlayer.MoveTo(Alias_theMarker.GetRef(), 0.000000, 0.000000, 0.000000, true)
endIf
if Alias_theUrn.GetRef() as Bool && utility.RandomInt(0, 1) as Bool
	bItemTaken = true
	Int[] typesToRemove = new Int[2]
	typesToRemove[0] = 26
	typesToRemove[1] = 41
	RecoveryQuest.StealItemsOfTypesFromPlayerAndBlame(typesToRemove, Alias_theUrn.GetRef(), false)
	if !Alias_theMarker.GetRef()
		Int i = DraugrOutfit.GetNumParts()
		while i > 0
			i -= 1
			akPlayer.AddItem(DraugrOutfit.GetNthPart(i), 1, true)
			akPlayer.EquipItem(DraugrOutfit.GetNthPart(i), false, true)
		endWhile
		form DW = DraugrWeapon as form
		akPlayer.AddItem(DW, 1, true)
		akPlayer.EquipItemEX(DW, 0, false, true)
	else
		self.SendModEvent("da_StartSecondaryQuest", "Both", 0.000000)
	endIf
else
	self.SendModEvent("da_StartSecondaryQuest", "Both", 0.000000)
endIf
Acheron.RescueActor(akPlayer, false)
self.RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; self.SendModEvent("da_StartRecoverSequence", "", 0.000000)
self.SendModEvent("da_ApplyBlackscreen", "RemoveWoozy", 0.000000)
theMovableMarker = akPlayer.PlaceAtMe(MovableMarker as form, 1, false, false)
self.RegisterForUpdate(10.0000)
if bItemTaken
	if Alias_theMarker.GetRef()
		PromptNaked.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
	else
		Prompt.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
	endIf
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
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

GetItems()

; self.SendModEvent("da_RestorePacifiedEnemies", "", 0.000000)
theMovableMarker.DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

function OnUpdate()
	if self.GetStage() == 0
		self.SetStage(10)
	elseIf akPlayer.GetDistance(theMovableMarker) > 2048.00
		; self.SendModEvent("da_RestorePacifiedEnemies", "", 0.000000)
		self.Stop()
	endIf
endFunction

function GetItems()
	If (GetStageDone(5))
		return
	EndIf
	Alias_theUrn.GetRef().RemoveAllItems(Alias_thePlayer.GetRef(), true, true)
endFunction

ObjectReference theMovableMarker
Actor akPlayer
Bool bItemTaken = false

miscobject property MovableMarker auto
outfit property DraugrOutfit auto
leveleditem property DraugrWeapon auto
message property PromptNaked auto
daymoyl_monitorutility property Util auto
daymoyl_getyourgearscript property RecoveryQuest auto
daymoyl_monitorvariables property Variables auto
message property Prompt auto

ImageSpaceModifier Property FadeToBlackImod  Auto  
