;/ Decompiled by Champollion V1.0.1
Source   : daymoyl_MonitorConfig.psc
Modified : 2017-11-01 03:41:49
Compiled : 2017-11-01 03:58:51
User     : Harawada
Computer : HARAWADA-PC
/;
scriptName daymoyl_monitorconfig extends SKI_ConfigBase

;-- Properties --------------------------------------
daymoyl_monitorregistry property Registry auto
message property MsgUpdateVersion auto
perk property DeathItemsPerk auto
perk property HealthBufferPerk auto
daymoyl_monitorplayerscript property akPlayerRef auto
perk property AddFollowerPerk auto
daymoyl_monitorfollowerscript property akFollowerRef auto
quest property EssentialAliasHolder auto
perk property DisengagePerk auto
daymoyl_monitorscript property Monitor auto
daymoyl_monitorutility property Util auto
daymoyl_monitormeter property Meter auto
daymoyl_monitorvariables property Variables auto
daymoyl_monitormeterupdate property MeterController auto

;-- Variables ---------------------------------------
Bool bManualRegistration = false
String[] DifficultySettingNameList
Bool bQueryRegistrySorting = false
Actor akPlayer
String[] FollowerSettingNameList
String[] StolenGearSettingNameList
Float[] DifficultySettingBDMList
String[] AnimationSettingNameList

;-- Functions ---------------------------------------

function OnOptionHighlight(Int option)

	Int n
	if self.CurrentPage == "$DAYMOYL_TAB_BLEEDOUT"
		n = Registry.OnBleedoutQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tQ = Registry.OnBleedoutQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tQ.iPriorityID
				self.SetInfoText("$DAYMOYL_DESC_PRIORITY")
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_QUEST"
		n = Registry.PrimaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.PrimaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iPriorityID
				self.SetInfoText("$DAYMOYL_DESC_PRIORITY")
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_DEATH"
		n = Registry.OnDeathQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.OnDeathQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iPriorityID
				self.SetInfoText("$DAYMOYL_DESC_PRIORITY")
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_RADIANT"
		n = Registry.SecondaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.SecondaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iProbabilityID
				self.SetInfoText("$DAYMOYL_DESC_PROBABILITY")
				return 
			endIf
		endWhile
	endIf
endFunction

function CheckStatus()

	akPlayer = game.GetPlayer()
	Variables.ModActivable = true
	Float skseNeeded = 2.00000
	Float skseInstalled = skse.GetVersion() as Float + skse.GetVersionMinor() as Float * 0.0100000 + skse.GetVersionBeta() as Float * 0.000100000
	if skseInstalled == 0 as Float
		debug.MessageBox("$DAYMOYL_ERR_NOSKSE")
		Variables.ModActivable = false
	endIf
	Float skyrimNeeded = 1.50000
	Float skyrimMajor = stringutil.SubString(debug.GetVersionNumber(), 0, 3) as Float
	if skyrimMajor < skyrimNeeded
		debug.MessageBox("$DAYMOYL_ERR_VERSION")
		Variables.ModActivable = false
	endIf
	debug.Trace("===============================[DAYMOYL: Ignore all Warnings start]================================", 0)
	if game.GetModByName("SkyUI_SE.esp") != 255
		form SkyUI = game.GetFormFromFile(2080, "SkyUI_SE.esp")
		if SkyUI
			debug.Trace("daymoyl - SkyUI_SE.esp found", 0)
		else
			debug.Trace("daymoyl - SkyUI_SE.esp not found, daymoyl has been turned off", 0)
			debug.MessageBox("$DAYMOYL_ERR_SKYUI")
			Variables.ModActivable = false
		endIf
	else
		debug.Trace("daymoyl - SkyUI.esp not found, daymoyl has been turned off", 0)
		debug.MessageBox("$DAYMOYL_ERR_SKYUI")
		Variables.ModActivable = false
	endIf
	if game.GetModByName("Dawnguard.esm") != 255
		Variables.VampireLordTransformSpell = game.GetFormFromFile(10299, "Dawnguard.esm") as spell
		Variables.VampireLordModeQuest = game.GetFormFromFile(29136, "Dawnguard.esm") as quest
		if Variables.VampireLordModeQuest
			debug.Trace("daymoyl - Dawnguard.esm found", 0)
		endIf
	else
		Variables.VampireLordModeQuest = none
	endIf
	if game.GetModByName("AmazingFollowerTweaks.esp") != 255
		Variables.FollowerTweakQuest = game.GetFormFromFile(4814, "AmazingFollowerTweaks.esp") as quest
		if Variables.FollowerTweakQuest
			debug.Trace("daymoyl - AmazingFollowerTweaks.esp found", 0)
		endIf
	else
		Variables.FollowerTweakQuest = none
	endIf
	if game.GetModByName("3DNPC.esp") != 255
		Variables.Follower3DNPCQuest = game.GetFormFromFile(1251404, "3DNPC.esp") as quest
		if Variables.Follower3DNPCQuest
			debug.Trace("daymoyl - 3DNPC.esp found", 0)
		endIf
	else
		Variables.Follower3DNPCQuest = none
	endIf
	if game.GetModByName("ZaZAnimationPack.esm") != 255
		Variables.ZazBoundIdle[0] = game.GetFormFromFile(81567, "ZaZAnimationPack.esm") as idle
		Variables.ZazBoundIdle[1] = game.GetFormFromFile(81568, "ZaZAnimationPack.esm") as idle
		Variables.ZazBoundIdle[2] = game.GetFormFromFile(81569, "ZaZAnimationPack.esm") as idle
		Variables.ZazBoundIdle[3] = game.GetFormFromFile(81571, "ZaZAnimationPack.esm") as idle
		Variables.ZazBoundIdle[4] = game.GetFormFromFile(82950, "ZaZAnimationPack.esm") as idle
		Variables.ZazBoundIdle[5] = game.GetFormFromFile(82953, "ZaZAnimationPack.esm") as idle
		Variables.ZazBoundIdle[6] = game.GetFormFromFile(82954, "ZaZAnimationPack.esm") as idle
		debug.Trace("daymoyl - ZaZAnimationPack.esm found", 0)
	else
		Variables.ZazBoundIdle[0] = none
		Variables.ZazBoundIdle[1] = none
		Variables.ZazBoundIdle[2] = none
		Variables.ZazBoundIdle[3] = none
		Variables.ZazBoundIdle[4] = none
		Variables.ZazBoundIdle[5] = none
		Variables.ZazBoundIdle[6] = none
	endIf
	debug.Trace("================================[DAYMOYL: Ignore all Warnings end]=================================", 0)
	self.SetModActive(Variables.ModActive)
endFunction

Int function GetVersion()

	return 620
endFunction

function OnConfigInit()

	debug.Trace("daymoyl -- OnConfigInit()", 0)
	ModName = "Death Alternative"
	Pages = new String[4]
	; Pages[0] = "$DAYMOYL_TAB_PLAYER"
	Pages[1] = "$DAYMOYL_TAB_FOLLOWER"
	; Pages[2] = "$DAYMOYL_TAB_BLEEDOUT"
	; Pages[3] = "$DAYMOYL_TAB_QUEST"
	; Pages[4] = "$DAYMOYL_TAB_DEATH"
	Pages[2] = "$DAYMOYL_TAB_RADIANT"
	Pages[0] = "$DAYMOYL_TAB_VARIABLES"
	; Pages[7] = "$DAYMOYL_TAB_WIDGET"
	Pages[3] = "$DAYMOYL_TAB_DEBUG"
	AnimationSettingNameList = new String[4]
	AnimationSettingNameList[0] = "$DAYMOYL_OPT_CUSTOMANIM"
	AnimationSettingNameList[1] = "$DAYMOYL_OPT_BLEEDOUTANDRAGDOLLANIM"
	AnimationSettingNameList[2] = "$DAYMOYL_OPT_BLEEDOUTANIM"
	AnimationSettingNameList[3] = "$DAYMOYL_OPT_RAGDOLLANIM"
	DifficultySettingNameList = new String[5]
	DifficultySettingBDMList = new Float[5]
	DifficultySettingNameList[0] = "$DAYMOYL_OPT_NONE"
	DifficultySettingNameList[1] = "$DAYMOYL_OPT_EASY"
	DifficultySettingNameList[2] = "$DAYMOYL_OPT_NORMAL"
	DifficultySettingNameList[3] = "$DAYMOYL_OPT_DIFFICULT"
	DifficultySettingNameList[4] = "$DAYMOYL_OPT_HARDCORE"
	DifficultySettingBDMList[0] = 1.00000
	DifficultySettingBDMList[1] = 0.500000
	DifficultySettingBDMList[2] = 1.00000
	DifficultySettingBDMList[3] = 2.00000
	DifficultySettingBDMList[4] = 4.00000
	FollowerSettingNameList = new String[7]
	FollowerSettingNameList[0] = "$DAYMOYL_OPT_NONE"
	FollowerSettingNameList[1] = "$DAYMOYL_OPT_DISMISS"
	FollowerSettingNameList[2] = "$DAYMOYL_OPT_KILL"
	FollowerSettingNameList[3] = "$DAYMOYL_OPT_KILLPROT"
	FollowerSettingNameList[4] = "$DAYMOYL_OPT_KILLESS"
	FollowerSettingNameList[5] = "$DAYMOYL_OPT_RANDOM"
	FollowerSettingNameList[6] = "$DAYMOYL_OPT_RANDOMANY"
	StolenGearSettingNameList = new String[4]
	StolenGearSettingNameList[0] = "$DAYMOYL_OPT_LEGACY"
	StolenGearSettingNameList[1] = "$DAYMOYL_OPT_QUESTSAFE"
	StolenGearSettingNameList[2] = "$DAYMOYL_OPT_FIXEDLOST"
	StolenGearSettingNameList[3] = "$DAYMOYL_OPT_HALFLIFE"
endFunction

function FullMenuMessage()

	self.ShowMessage("$DAYMOYL_OPT_NEEDPATCH", false, "$Accept", "$Cancel")
endFunction

Int function GetOnDeathMenuLimit()

	return 59
endFunction

function SetAnimSystem(Int op)

	if Variables.ModActive && op >= 0
		if op == 0 && akPlayerRef.GetState() != "daymoylActive_CustomMethod"
			akPlayerRef.GotoState("daymoylActive_CustomMethod")
		elseIf op == 1 && akPlayerRef.GetState() != "daymoylActive_BleedoutAndRagdollMethod"
			akPlayerRef.GotoState("daymoylActive_BleedoutAndRagdollMethod")
		elseIf op == 2 && akPlayerRef.GetState() != "daymoylActive_BleedoutMethod"
			akPlayerRef.GotoState("daymoylActive_BleedoutMethod")
		elseIf op == 3 && akPlayerRef.GetState() != "daymoylActive_RagdollMethod"
			akPlayerRef.GotoState("daymoylActive_RagdollMethod")
		endIf
	elseIf akPlayerRef.GetState() != ""
		akPlayerRef.GotoState("")
	endIf
endFunction

function SetModActive(Bool active)

	if Variables.ModActivable && active && !Monitor.IsRunning()
		debug.TraceConditional("daymoyl - Activating monitor", Variables.bDebugMode)
		Monitor.Start()
		akPlayer.AddPerk(DeathItemsPerk)
		self.SetExtraHPBuffer(Variables.HealthBuffer)
		self.SetDeferredKill(Variables.bUseDeferredKill)
		self.SetEssential(Variables.EssentialPlayer)
		self.SetAnimSystem(Variables.AnimationSetting)
	elseIf !active && Monitor.IsRunning()
		self.SetAnimSystem(-1)
		self.SetDeferredKill(false)
		self.SetEssential(false)
		self.SetExtraHPBuffer(false)
		akPlayer.RemovePerk(DeathItemsPerk)
		Monitor.Stop()
		debug.Notification("DA Disabled")
		debug.TraceConditional("daymoyl - daymoyl has been disabled", Variables.bDebugMode)
	endIf
	Util.DisplayMessage(Variables.MessageActive)
endFunction

function OnUpdate()

	if bQueryRegistrySorting
		Registry.SortAllRegistries()
		if Variables.bDebugMode || bManualRegistration as Bool
			debug.Notification("DA Ready")
		endIf
		bManualRegistration = false
		bQueryRegistrySorting = false
	endIf
endFunction

function OnOptionSliderAccept(Int option, Float value)

	Int n
	if self.CurrentPage == "$DAYMOYL_TAB_BLEEDOUT"
		n = Registry.OnBleedoutQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tQ = Registry.OnBleedoutQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tQ.iPriorityID
				tQ.iPriority = value as Int
				self.SetSliderOptionValue(tQ.iPriorityID, value, "{0}", false)
				return 
			endIf
		endWhile
		Registry.SortOnBleedoutRegistry()
	elseIf self.CurrentPage == "$DAYMOYL_TAB_QUEST"
		n = Registry.PrimaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.PrimaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iPriorityID
				tq.iPriority = value as Int
				self.SetSliderOptionValue(tq.iPriorityID, value, "{0}", false)
				return 
			endIf
		endWhile
		Registry.SortPrimaryRegistry()
	elseIf self.CurrentPage == "$DAYMOYL_TAB_DEATH"
		n = Registry.OnDeathQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.OnDeathQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iPriorityID
				tq.iPriority = value as Int
				self.SetSliderOptionValue(tq.iPriorityID, value, "{0}", false)
				return 
			endIf
		endWhile
		Registry.SortOnDeathRegistry()
	elseIf self.CurrentPage == "$DAYMOYL_TAB_RADIANT"
		n = Registry.SecondaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.SecondaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iProbabilityID
				tq.fProbability = value
				self.SetSliderOptionValue(tq.iProbabilityID, value, "{0}%", false)
				return 
			endIf
		endWhile
	endIf
endFunction

Int function GetOnBleedoutMenuLimit()

	return 61
endFunction

function OnOptionSliderOpen(Int option)

	Int n
	if self.CurrentPage == "$DAYMOYL_TAB_BLEEDOUT"
		n = Registry.OnBleedoutQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tQ = Registry.OnBleedoutQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tQ.iPriorityID
				self.SetSliderDialogStartValue(tQ.iPriority as Float)
				self.SetSliderDialogDefaultValue(0.000000)
				self.SetSliderDialogRange(0.000000, 99.0000)
				self.SetSliderDialogInterval(1.00000)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_QUEST"
		n = Registry.PrimaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.PrimaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iPriorityID
				self.SetSliderDialogStartValue(tq.iPriority as Float)
				self.SetSliderDialogDefaultValue(0.000000)
				self.SetSliderDialogRange(0.000000, 99.0000)
				self.SetSliderDialogInterval(1.00000)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_DEATH"
		n = Registry.OnDeathQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.OnDeathQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iPriorityID
				self.SetSliderDialogStartValue(tq.iPriority as Float)
				self.SetSliderDialogDefaultValue(0.000000)
				self.SetSliderDialogRange(0.000000, 99.0000)
				self.SetSliderDialogInterval(1.00000)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_RADIANT"
		n = Registry.SecondaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.SecondaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iProbabilityID
				self.SetSliderDialogStartValue(tq.fProbability)
				self.SetSliderDialogDefaultValue(10.0000)
				self.SetSliderDialogRange(0.000000, 100.000)
				self.SetSliderDialogInterval(1.00000)
				return 
			endIf
		endWhile
	endIf
endFunction

function OnOptionDefault(Int option)

	Int n
	if self.CurrentPage == "$DAYMOYL_TAB_BLEEDOUT"
		n = Registry.OnBleedoutQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tQ = Registry.OnBleedoutQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tQ.iEnabledID
				tQ.bEnabled = true
				self.SetToggleOptionValue(tQ.iEnabledID, tQ.bEnabled, false)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_QUEST"
		n = Registry.PrimaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.PrimaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iEnabledID
				tq.bEnabled = true
				self.SetToggleOptionValue(tq.iEnabledID, tq.bEnabled, false)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_DEATH"
		n = Registry.OnDeathQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.OnDeathQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iEnabledID
				tq.bEnabled = true
				self.SetToggleOptionValue(tq.iEnabledID, tq.bEnabled, false)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_RADIANT"
		n = Registry.SecondaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.SecondaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iEnabledID
				tq.bEnabled = true
				self.SetToggleOptionValue(tq.iEnabledID, tq.bEnabled, false)
				return 
			endIf
		endWhile
	endIf
endFunction

function OnOptionSelect(Int option)

	Int n
	if self.CurrentPage == "$DAYMOYL_TAB_BLEEDOUT"
		n = Registry.OnBleedoutQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tQ = Registry.OnBleedoutQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tQ.iEnabledID
				tQ.bEnabled = !tQ.bEnabled
				self.SetToggleOptionValue(tQ.iEnabledID, tQ.bEnabled, false)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_QUEST"
		n = Registry.PrimaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.PrimaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iEnabledID
				tq.bEnabled = !tq.bEnabled
				self.SetToggleOptionValue(tq.iEnabledID, tq.bEnabled, false)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_DEATH"
		n = Registry.OnDeathQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.OnDeathQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iEnabledID
				tq.bEnabled = !tq.bEnabled
				self.SetToggleOptionValue(tq.iEnabledID, tq.bEnabled, false)
				return 
			endIf
		endWhile
	elseIf self.CurrentPage == "$DAYMOYL_TAB_RADIANT"
		n = Registry.SecondaryQuestRegistry.GetSize()
		while n
			n -= 1
			daymoyl_questtemplate tq = Registry.SecondaryQuestRegistry.GetAt(n) as daymoyl_questtemplate
			if option == tq.iEnabledID
				tq.bEnabled = !tq.bEnabled
				self.SetToggleOptionValue(tq.iEnabledID, tq.bEnabled, false)
				return 
			endIf
		endWhile
	endIf
endFunction

function OnGameReload()

	parent.OnGameReload()
	self.CheckStatus()
endFunction

function SetEssential(Bool on)

	if Variables.ModActive && on
		akPlayer.GetActorBase().SetEssential(on)
		akPlayer.SetNoBleedoutRecovery(Variables.EssentialPlayer)
	else
		akPlayer.SetNoBleedoutRecovery(false)
		akPlayer.GetActorBase().SetEssential(false)
	endIf
endFunction

; Skipped compiler generated GotoState

function OnPageReset(String pagename)

	if pagename == ""
		self.LoadCustomContent("DAYMOYL/MCM-DA-monochrome.dds", 48 as Float, 73 as Float)
		return 
	else
		self.UnloadCustomContent()
	endIf
	if false
	; if pagename == "$DAYMOYL_TAB_PLAYER"
	; 	self.SetCursorFillMode(self.TOP_TO_BOTTOM)
	; 	self.AddHeaderOption("$DAYMOYL_OPT_GENERAL", 0)
	; 	if Variables.ModActivable
	; 		self.AddToggleOptionST("GENERAL_MODACTIVE_TOGGLE", "$DAYMOYL_OPT_ACTIVATE", Variables.ModActive, 0)
	; 	else
	; 		self.AddToggleOptionST("GENERAL_MODACTIVE_TOGGLE", "$DAYMOYL_OPT_ACTIVATE", false, self.OPTION_FLAG_DISABLED)
	; 	endIf
	; 	self.AddTextOptionST("GENERAL_REGISTER_TEXT", "$DAYMOYL_OPT_REGISTER", "$DAYMOYL_OPT_REGISTERNOW", self.OPTION_FLAG_NONE)
	; 	self.AddEmptyOption()
	; 	if !Variables.ModActive
	; 		self.AddTextOption("$DAYMOYL_ACTIVATE_MESSAGE", "", self.OPTION_FLAG_DISABLED)
	; 		self.AddTextOption("$DAYMOYL_REGISTER_MESSAGE", "", self.OPTION_FLAG_DISABLED)
	; 		return 
	; 	endIf
	; 	self.AddToggleOptionST("GENERAL_DPYMSG_TOGGLE", "$DAYMOYL_OPT_DPYMSG", Variables.MessageActive, 0)
	; 	self.AddToggleOptionST("GENERAL_TUTORIAL_TOGGLE", "$DAYMOYL_OPT_TUTORIAL", Variables.bTutorialActive, 0)
	; 	self.AddMenuOptionST("GENERAL_ANIMATION_MENU", "$DAYMOYL_OPT_ANIMATION", AnimationSettingNameList[Variables.AnimationSetting], 0)
	; 	self.AddMenuOptionST("GENERAL_DIFFICULTY_MENU", "$DAYMOYL_OPT_DIFFICULTY", DifficultySettingNameList[Variables.DifficultySetting], 0)
	; 	self.AddEmptyOption()
	; 	self.AddHeaderOption("$DAYMOYL_OPT_TRIGGER", 0)
	; 	self.AddSliderOptionST("TRIGGER_PERCHPT_SLIDER", "$DAYMOYL_OPT_PERCHPT", Variables.HealthThreshold * 100.000, "{0}%", 0)
	; 	self.AddToggleOptionST("HEALTH_ESSPC_TOGGLE", "$DAYMOYL_OPT_ESSPC", Variables.EssentialPlayer, 0)
	; 	self.AddToggleOptionST("HEALTH_DEFERRED_TOGGLE", "$DAYMOYL_OPT_DEFERRED", Variables.bUseDeferredKill, 0)
	; 	self.SetCursorPosition(1)
	; 	self.AddHeaderOption("$DAYMOYL_OPT_HEALTH", 0)
	; 	self.AddToggleOptionST("HEALTH_EXTRAHP_TOGGLE", "$DAYMOYL_OPT_EXTRAHP", Variables.HealthBuffer, 0)
	; 	self.AddSliderOptionST("TRIGGER_LARGEHIT_SLIDER", "$DAYMOYL_OPT_LARGEHIT", Variables.LargeHitThreshold * 100.000, "{0}%", 0)
	; 	self.AddSliderOptionST("TRIGGER_BODMGMULT_SLIDER", "$DAYMOYL_OPT_BODMGMULT", Variables.BleedOutDamageMult, "{1}x", 0)
	; 	self.AddSliderOptionST("RECOVERY_BODUR_SLIDER", "$DAYMOYL_OPT_BODUR", Variables.BleedOutDuration, "$DAYMOYL_OPT_SECONDS", 0)
	; 	self.AddEmptyOption()
	; 	self.AddHeaderOption("$DAYMOYL_OPT_RECOVERY", 0)
	; 	self.AddSliderOptionST("RECOVERY_IMMDUR_SLIDER", "$DAYMOYL_OPT_IMMDUR", Variables.ImmunityDuration, "$DAYMOYL_OPT_SECONDS", 0)
	; 	self.AddSliderOptionST("RECOVERY_REALLAPSE_SLIDER", "$DAYMOYL_OPT_REALLAPSE", Variables.BlackoutRealTimeLapse, "$DAYMOYL_OPT_SECONDS", 0)
	; 	self.AddSliderOptionST("RECOVERY_LAPSE_SLIDER", "$DAYMOYL_OPT_LAPSE", Variables.BlackoutTimeLapse * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
	; 	self.AddSliderOptionST("RECOVERY_CALMDUR_SLIDER", "$DAYMOYL_OPT_CALMDUR", Variables.CalmedDuration, "$DAYMOYL_OPT_HOURS", 0)
	; 	self.AddSliderOptionST("RECOVERY_BODDUR_SLIDER", "$DAYMOYL_OPT_BODDUR", Variables.BleedoutDebuffDuration * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
	; 	self.AddSliderOptionST("RECOVERY_NDDUR_SLIDER", "$DAYMOYL_OPT_NDDDUR", Variables.NearDeathDebuffDuration * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
	elseIf pagename == "$DAYMOYL_TAB_FOLLOWER"
		; if !Variables.ModActive
		; 	self.SetCursorFillMode(self.TOP_TO_BOTTOM)
		; 	self.AddTextOption("$DAYMOYL_ACTIVATE_MESSAGE", "", self.OPTION_FLAG_DISABLED)
		; 	self.AddTextOption("$DAYMOYL_REGISTER_MESSAGE", "", self.OPTION_FLAG_DISABLED)
		; 	return 
		; endIf
		self.SetCursorFillMode(self.TOP_TO_BOTTOM)
		self.AddHeaderOption("$DAYMOYL_OPT_BEHAVIOR", 0)
		self.AddToggleOptionST("FOLLOWER_FOLCLOAK_TOGGLE", "$DAYMOYL_OPT_FOLCLOAK", Variables.bFollowerCloakActive, 0)
		; self.AddToggleOptionST("FOLLOWER_FOLDOWN_TOGGLE", "$DAYMOYL_OPT_FOLDOWN", Variables.bFollowerForcedBleedout, 0)
		; self.AddToggleOptionST("FOLLOWER_PROTPLYR_TOGGLE", "$DAYMOYL_OPT_PROTPLYR", Variables.FollowerProtectPlayer, 0)
		; self.AddMenuOptionST("FOLLOWER_ONDEFEAT_MENU", "$DAYMOYL_OPT_FOLDEFEAT", FollowerSettingNameList[Variables.FollowerSetting], 0)
		; self.AddEmptyOption()
		self.AddToggleOptionST("DEBUG_ADDADDFOLLOWER", "$DAYMOYL_OPT_ADDADDFOLLOWER", akPlayer.HasPerk(AddFollowerPerk), 0)
		self.SetCursorPosition(1)
		self.AddHeaderOption("$DAYMOYL_OPT_TRACKEDFOLLOWER", 0)
		Int i = akFollowerRef.FollowerList.GetSize()
		while i
			i -= 1
			Actor rF = akFollowerRef.FollowerList.GetAt(i) as Actor
			String rFName = rF.GetBaseObject().GetName()
			if rFName == ""
				rFName = "Unnamed Follower"
			endIf
			if rF.IsNearPlayer()
				if rF.GetAnimationVariableBool("IsBleedingOut") || rF.HasSpell(akFollowerRef.Incapacitated as form)
					self.AddTextOption(rFName, "$DAYMOYL_OPT_INCAP", self.OPTION_FLAG_DISABLED)
				else
					self.AddTextOption(rFName, "$DAYMOYL_OPT_ACTIVE", self.OPTION_FLAG_DISABLED)
				endIf
			else
				self.AddTextOption(rFName, "$DAYMOYL_OPT_OUTOFRANGE", self.OPTION_FLAG_DISABLED)
			endIf
		endWhile
		self.AddEmptyOption()
		self.AddHeaderOption("$DAYMOYL_OPT_HELDFOL", 0)
		i = akFollowerRef.HeldFollowerList.GetSize()
		while i
			i -= 1
			Actor rf = akFollowerRef.HeldFollowerList.GetAt(i) as Actor
			String rfname = rf.GetBaseObject().GetName()
			if rfname == ""
				rfname = "Unnamed Follower"
			endIf
			self.AddTextOption(rfname, "$DAYMOYL_OPT_DEACTIVATED", self.OPTION_FLAG_DISABLED)
		endWhile
	; elseIf pagename == "$DAYMOYL_TAB_BLEEDOUT"
	; 	self.SetCursorPosition(0)
	; 	self.SetCursorFillMode(self.LEFT_TO_RIGHT)
	; 	self.AddHeaderOption("$DAYMOYL_OPT_TOGBLEEDOUTQST", 0)
	; 	self.AddHeaderOption("", 0)
	; 	Int i = 0
	; 	Int n = Registry.OnBleedoutQuestRegistry.GetSize()
	; 	if n > self.GetOnBleedoutMenuLimit()
	; 		n = self.GetOnBleedoutMenuLimit()
	; 		self.FullMenuMessage()
	; 	endIf
	; 	while i < n
	; 		daymoyl_questtemplate tQ = Registry.OnBleedoutQuestRegistry.GetAt(i) as daymoyl_questtemplate
	; 		tQ.iEnabledID = self.AddToggleOption(tQ.sName, tQ.bEnabled, 0)
	; 		tQ.iPriorityID = self.AddSliderOption("$DAYMOYL_OPT_PRIORITY", tQ.iPriority as Float, "{0}", 0)
	; 		i += 1
	; 	endWhile
	; elseIf pagename == "$DAYMOYL_TAB_QUEST"
	; 	self.SetCursorPosition(0)
	; 	self.SetCursorFillMode(self.LEFT_TO_RIGHT)
	; 	self.AddHeaderOption("$DAYMOYL_OPT_TOGMAINQST", 0)
	; 	self.AddHeaderOption("", 0)
	; 	self.AddToggleOptionST("TOGMAINQST_DEFAULTQST_TOGGLE", Registry.DefaultQuest.sName, Registry.DefaultQuest.bEnabled, 0)
	; 	self.AddTextOption("$DAYMOYL_OPT_PRIORITY", 0 as String, self.OPTION_FLAG_DISABLED)
	; 	Int i = 0
	; 	Int n = Registry.PrimaryQuestRegistry.GetSize()
	; 	if n > self.GetOnDefeatMenuLimit()
	; 		n = self.GetOnDefeatMenuLimit()
	; 		self.FullMenuMessage()
	; 	endIf
	; 	while i < n
	; 		daymoyl_questtemplate tq = Registry.PrimaryQuestRegistry.GetAt(i) as daymoyl_questtemplate
	; 		tq.iEnabledID = self.AddToggleOption(tq.sName, tq.bEnabled, 0)
	; 		tq.iPriorityID = self.AddSliderOption("$DAYMOYL_OPT_PRIORITY", tq.iPriority as Float, "{0}", 0)
	; 		i += 1
	; 	endWhile
	; elseIf pagename == "$DAYMOYL_TAB_DEATH"
	; 	self.SetCursorPosition(0)
	; 	self.SetCursorFillMode(self.LEFT_TO_RIGHT)
	; 	self.AddHeaderOption("$DAYMOYL_OPT_TOGDEATHQST", 0)
	; 	self.AddHeaderOption("", 0)
	; 	self.AddToggleOptionST("RECOVERY_KILLPC_TOGGLE", "$DAYMOYL_OPT_KILLPC", Variables.ManageDeath, 0)
	; 	self.AddTextOption("$DAYMOYL_OPT_PRIORITY", 0 as String, self.OPTION_FLAG_DISABLED)
	; 	Int i = 0
	; 	Int n = Registry.OnDeathQuestRegistry.GetSize()
	; 	if n > self.GetOnDeathMenuLimit()
	; 		n = self.GetOnDeathMenuLimit()
	; 		self.FullMenuMessage()
	; 	endIf
	; 	while i < n
	; 		daymoyl_questtemplate tq = Registry.OnDeathQuestRegistry.GetAt(i) as daymoyl_questtemplate
	; 		tq.iEnabledID = self.AddToggleOption(tq.sName, tq.bEnabled, 0)
	; 		tq.iPriorityID = self.AddSliderOption("$DAYMOYL_OPT_PRIORITY", tq.iPriority as Float, "{0}", 0)
	; 		i += 1
	; 	endWhile
	elseIf pagename == "$DAYMOYL_TAB_RADIANT"
		self.AddSliderOptionST("SECQUEST_PROBRESCUE_SLIDER", "$DAYMOYL_OPT_PROBRESCUE", Variables.ChanceOfRescue, "{0}%", 0)
		self.AddSliderOptionST("SECQUEST_PROBTHEFT_SLIDER", "$DAYMOYL_OPT_PROBTHEFT", Variables.ChanceOfTheft, "{0}%", 0)
		self.SetCursorPosition(4)
		self.AddHeaderOption("$DAYMOYL_OPT_TOGFRIENDQST", 0)
		self.AddHeaderOption("", 0)
		Int i = 0
		Int n = Registry.SecondaryQuestRegistry.GetSize()
		if n > self.GetOnRadiantMenuLimit()
			n = self.GetOnRadiantMenuLimit()
			self.FullMenuMessage()
		endIf
		while i < n
			daymoyl_questtemplate tq = Registry.SecondaryQuestRegistry.GetAt(i) as daymoyl_questtemplate
			if !tq.bDetrimental
				tq.iEnabledID = self.AddToggleOption(tq.sName, tq.bEnabled, 0)
				tq.iProbabilityID = self.AddSliderOption("$DAYMOYL_OPT_PROB", tq.fProbability, "{0}%", 0)
			endIf
			i += 1
		endWhile
		self.AddEmptyOption()
		self.AddEmptyOption()
		self.AddHeaderOption("$DAYMOYL_OPT_TOGFOEQST", 0)
		self.AddHeaderOption("", 0)
		i = 0
		while i < n
			daymoyl_questtemplate tq = Registry.SecondaryQuestRegistry.GetAt(i) as daymoyl_questtemplate
			if tq.bDetrimental
				tq.iEnabledID = self.AddToggleOption(tq.sName, tq.bEnabled, 0)
				tq.iProbabilityID = self.AddSliderOption("$DAYMOYL_OPT_PROB", tq.fProbability, "{0}%", 0)
			endIf
			i += 1
		endWhile
	elseIf pagename == "$DAYMOYL_TAB_VARIABLES"
		self.SetCursorFillMode(self.LEFT_TO_RIGHT)
		self.AddHeaderOption("$DAYMOYL_OPT_RECOVERY", 0)
		AddEmptyOption()
		self.AddSliderOptionST("RECOVERY_REALLAPSE_SLIDER", "$DAYMOYL_OPT_REALLAPSE", Variables.BlackoutRealTimeLapse, "$DAYMOYL_OPT_SECONDS", 0)
		self.AddSliderOptionST("RECOVERY_LAPSE_SLIDER", "$DAYMOYL_OPT_LAPSE", Variables.BlackoutTimeLapse * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
		AddEmptyOption()
		AddEmptyOption()
		self.SetCursorFillMode(self.TOP_TO_BOTTOM)
		self.AddHeaderOption("$DAYMOYL_OPT_RESCUEQST", 0)
		self.AddSliderOptionST("RESCUEQST_HELPDUR_SLIDER", "$DAYMOYL_OPT_HELPDUR", Variables.TimeOnHelpOffer * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
		self.AddEmptyOption()
		self.AddHeaderOption("$DAYMOYL_OPT_RECOVERQST", 0)
		self.AddMenuOptionST("RECOVERQST_SGSETTING_MENU", "$DAYMOYL_OPT_SGSETTING", StolenGearSettingNameList[Variables.StolenGearSetting], 0)
		self.AddSliderOptionST("RECOVERQST_TIMEPAY_SLIDER", "$DAYMOYL_OPT_TIMEPAY", Variables.TimeToPayVendor * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
		self.AddToggleOptionST("RECOVERQST_ROAMING_TOGGLE", "$DAYMOYL_OPT_ROAMING", Variables.bRoamingGearThief, 0)
		self.SetCursorPosition(9)
		self.AddSliderOptionST("RECOVERQST_PERCLOST_SLIDER", "$DAYMOYL_OPT_PERCLOST", Variables.StolenGearPercentLost, "{0}%", 0)
		self.AddSliderOptionST("RECOVERQST_HALFLIFE_SLIDER", "$DAYMOYL_OPT_HALFLIFEDUR", Variables.StolenGearHalflife * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
		self.AddSliderOptionST("RECOVERQST_GOLDHALFLIFE_SLIDER", "$DAYMOYL_OPT_GOLDHALFLIFEDUR", Variables.StolenGoldHalflife * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
		self.SetCursorPosition(14)
		self.AddEmptyOption()
		self.AddHeaderOption("$DAYMOYL_OPT_STOLENITEM", 0)
		self.SetCursorFillMode(self.LEFT_TO_RIGHT)
		self.AddSliderOptionST("STOLENITEM_LOWCOST_SLIDER", "$DAYMOYL_OPT_LOWCOST", Variables.LowCostItem, "$DAYMOYL_OPT_GOLD", 0)
		self.AddSliderOptionST("STOLENITEM_LOWPROB_SLIDER", "$DAYMOYL_OPT_THEFTPROB", Variables.LowCostItemPerc, "{0}%", 0)
		self.AddSliderOptionST("STOLENITEM_MEDCOST_SLIDER", "$DAYMOYL_OPT_MEDCOST", Variables.MediumCostItem, "$DAYMOYL_OPT_GOLD", 0)
		self.AddSliderOptionST("STOLENITEM_MEDPROB_SLIDER", "$DAYMOYL_OPT_THEFTPROB", Variables.MediumCostItemPerc, "{0}%", 0)
		self.AddSliderOptionST("STOLENITEM_HIGHCOST_SLIDER", "$DAYMOYL_OPT_HIGHCOST", Variables.HighCostItem, "$DAYMOYL_OPT_GOLD", 0)
		self.AddSliderOptionST("STOLENITEM_HIGHPROB_SLIDER", "$DAYMOYL_OPT_THEFTPROB", Variables.HighCostItemPerc, "{0}%", 0)
		self.SetCursorFillMode(self.TOP_TO_BOTTOM)
		self.AddEmptyOption()
		self.AddSliderOptionST("STOLENITEM_PERCGOLD_SLIDER", "$DAYMOYL_OPT_PERCGOLD", Variables.PercGoldTheft, "{0}%", 0)
		self.AddEmptyOption()
		self.AddHeaderOption("$DAYMOYL_OPT_DRAGONQST", 0)
		self.AddSliderOptionST("RECOVERY_WDDUR_SLIDER", "$DAYMOYL_OPT_WDDDUR", Variables.WeakenedDebuffDuration * 24.0000, "$DAYMOYL_OPT_HOURS", 0)
		self.AddEmptyOption()
		self.AddHeaderOption("$DAYMOYL_OPT_DEATHQST", 0)
		self.AddSliderOptionST("DEFEATED_DEATH_SLIDER", "$DAYMOYL_OPT_DEATHCHANCE", Variables.PercChanceDeath, "{0}%", 0)
		self.AddEmptyOption()
		self.AddHeaderOption("$DAYMOYL_OPT_BINDING", 0)
		self.AddToggleOptionST("FORCE_GAMEPAD_TOGGLE", "$DAYMOYL_OPT_FORCEGAMEPAD", Variables.bForceGamepad, 0)
		self.AddSliderOptionST("BINDING_DIFFICULTY_SLIDER", "$DAYMOYL_OPT_BINDINGDIFF", Variables.fBindingDifficulty, "{1}x", 0)
	; elseIf pagename == "$DAYMOYL_TAB_WIDGET"
	; 	if !Variables.ModActive
	; 		self.SetCursorFillMode(self.TOP_TO_BOTTOM)
	; 		self.AddTextOption("$DAYMOYL_ACTIVATE_MESSAGE", "", self.OPTION_FLAG_DISABLED)
	; 		self.AddTextOption("$DAYMOYL_REGISTER_MESSAGE", "", self.OPTION_FLAG_DISABLED)
	; 		return 
	; 	endIf
	; 	self.SetCursorFillMode(self.TOP_TO_BOTTOM)
	; 	self.AddHeaderOption("$DAYMOYL_OPT_METER", 0)
	; 	self.AddToggleOptionST("METER_DISPLAY_TOGGLE", "$DAYMOYL_OPT_METER_DISPLAY", Variables.bMeterDisplayed, 0)
	; 	self.AddSliderOptionST("METER_SHORT_DURATION_SLIDER", "$DAYMOYL_OPT_METER_DUR", Variables.fMeterDuration, "$DAYMOYL_OPT_SECONDS_1DIGITS", 0)
	; 	self.AddSliderOptionST("METER_LONG_DURATION_SLIDER", "$DAYMOYL_OPT_METER_LONGDUR", Variables.fMeterLongDuration, "$DAYMOYL_OPT_SECONDS_1DIGITS", 0)
	; 	self.AddEmptyOption()
	; 	self.AddSliderOptionST("METER_XPOS_SLIDER", "$DAYMOYL_OPT_METER_XPOS", Meter.X, "{1}", 0)
	; 	self.AddSliderOptionST("METER_YPOS_SLIDER", "$DAYMOYL_OPT_METER_YPOS", Meter.Y, "{1}", 0)
	; 	self.AddEmptyOption()
	; 	self.AddColorOptionST("METER_COLOR_PICKER", "$DAYMOYL_OPT_METER_COLOR", Variables.iMeterColor, 0)
	; 	self.AddSliderOptionST("METER_OPACITY_SLIDER", "$DAYMOYL_OPT_METER_OPACITY", Variables.fMeterOpacity, "{0}%", 0)
	elseIf pagename == "$DAYMOYL_TAB_DEBUG"
		self.SetCursorFillMode(self.TOP_TO_BOTTOM)
		self.AddHeaderOption("$DAYMOYL_OPT_DEBUGHEADER", 0)
		self.AddToggleOptionST("DEBUG_TOGGLE", "$DAYMOYL_OPT_DEBUG", Variables.bDebugMode, 0)
		self.AddEmptyOption()
		; self.AddTextOptionST("DEBUG_CHEAT_TEXT", "$DAYMOYL_OPT_RECOVERCHEAT", "$DAYMOYL_OPT_YES", self.OPTION_FLAG_NONE)
		; self.AddTextOptionST("DEBUG_RESET_TEXT", "$DAYMOYL_OPT_RESET", "$DAYMOYL_OPT_YES", self.OPTION_FLAG_NONE)
		self.AddTextOptionST("DEBUG_BSRESET_TEXT", "$DAYMOYL_OPT_BSRESET", "$DAYMOYL_OPT_YES", self.OPTION_FLAG_NONE)
		; self.AddTextOptionST("DEBUG_RESETEFFECT_TEXT", "$DAYMOYL_OPT_RESETEFFECT", "$DAYMOYL_OPT_YES", self.OPTION_FLAG_NONE)
		self.AddTextOptionST("DEBUG_RESETFOLLOWER_TEXT", "$DAYMOYL_OPT_CLEARFOLLOWER", "$DAYMOYL_OPT_YES", self.OPTION_FLAG_NONE)
		self.SetCursorPosition(1)
		; self.AddHeaderOption("$DAYMOYL_OPT_DEBUGDIAG", 0)
		; self.AddToggleOption("$DAYMOYL_OPT_ISMONITORRUNNING", Monitor.IsRunning(), self.OPTION_FLAG_DISABLED)
		; self.AddToggleOption("$DAYMOYL_OPT_ISALIASFILLED", akPlayerRef.GetRef() == game.GetPlayer() as objectreference, self.OPTION_FLAG_DISABLED)
		; self.AddToggleOption("$DAYMOYL_OPT_ISESSPC", akPlayer.IsEssential(), self.OPTION_FLAG_DISABLED)
		; self.AddTextOption("$DAYMOYL_OPT_MONITORSTATE", Monitor.GetState(), self.OPTION_FLAG_DISABLED)
		; self.AddEmptyOption()
		; self.AddHeaderOption("$DAYMOYL_OPT_DEBUGEXTRA", 0)
		; self.AddToggleOptionST("DEBUG_ADDDISENGAGE", "$DAYMOYL_OPT_ADDDISENGAGE", akPlayer.HasPerk(DisengagePerk), 0)
	endIf
endFunction

; Skipped compiler generated GetState

function OnVersionUpdate(Int newVersion)

	if CurrentVersion as Bool && CurrentVersion < newVersion
		MsgUpdateVersion.Show(newVersion as Float / 100.000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
		debug.Trace("daymoyl - Updating script version " + (CurrentVersion as Float / 100.000) as String + " -> " + (newVersion as Float / 100.000) as String, 0)
		Registry.OnInit()
		self.OnConfigInit()
	endIf
endFunction

function SetDeferredKill(Bool on)

	if Variables.ModActive && on
		akPlayer.StartDeferredKill()
	else
		akPlayer.GetActorBase().SetEssential(true)
		akPlayer.GetActorBase().SetInvulnerable(true)
		EssentialAliasHolder.Start()
		akPlayer.EndDeferredKill()
		EssentialAliasHolder.Stop()
		akPlayer.GetActorBase().SetInvulnerable(false)
		akPlayer.GetActorBase().SetEssential(false)
	endIf
endFunction

Int function GetOnRadiantMenuLimit()

	return 57
endFunction

Int function GetOnDefeatMenuLimit()

	return 59
endFunction

function ResetAllQuests()

	if Variables.RecoveryQuest.IsRunning()
		(Variables.RecoveryQuest as daymoyl_getyourgearscript).ResetChests()
	endIf
	Registry.ResetAllQuests()
endFunction

function SetExtraHPBuffer(Bool on)

	if Variables.ModActive && on
		akPlayer.AddPerk(HealthBufferPerk)
	else
		akPlayer.RemovePerk(HealthBufferPerk)
	endIf
endFunction

;-- State -------------------------------------------
state TRIGGER_PERCHPT_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.HealthThreshold * 100.000)
		self.SetSliderDialogDefaultValue(0.000000)
		self.SetSliderDialogRange(0.000000, 50.0000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_HEALTHTH")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.HealthThreshold = value / 100.000
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERQST_TIMEPAY_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.TimeToPayVendor * 24.0000)
		self.SetSliderDialogDefaultValue(24.0000)
		self.SetSliderDialogRange(2.00000, 72.0000)
		self.SetSliderDialogInterval(2.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_PAWNTIMER")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.TimeToPayVendor = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state HEALTH_DEFERRED_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_DEFERRED")
	endFunction

	function OnSelectST()

		Variables.bUseDeferredKill = !Variables.bUseDeferredKill
		self.SetToggleOptionValueST(Variables.bUseDeferredKill, false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.SetDeferredKill(Variables.bUseDeferredKill)
	endFunction

	function OnDefaultST()

		Variables.bUseDeferredKill = false
		self.SetToggleOptionValueST(Variables.bUseDeferredKill, false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.SetDeferredKill(Variables.bUseDeferredKill)
	endFunction
endState

;-- State -------------------------------------------
state general_autoreg_toggle

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_AUTOREG")
	endFunction

	function OnSelectST()

		Variables.bAutoRegister = !Variables.bAutoRegister
		self.SetToggleOptionValueST(Variables.bAutoRegister, false, "")
	endFunction

	function OnDefaultST()

		Variables.bAutoRegister = false
		self.SetToggleOptionValueST(Variables.bAutoRegister, false, "")
	endFunction
endState

;-- State -------------------------------------------
state STOLENITEM_LOWCOST_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.LowCostItem)
		self.SetSliderDialogDefaultValue(10.0000)
		self.SetSliderDialogRange(0.000000, 40.0000)
		self.SetSliderDialogInterval(2.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_GEARVALUE")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.LowCostItem = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_GOLD", false, "")
	endFunction
endState

;-- State -------------------------------------------
state FOLLOWER_FOLDOWN_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_FOLDOWN")
	endFunction

	function OnSelectST()

		Variables.bFollowerForcedBleedout = !Variables.bFollowerForcedBleedout
		self.SetToggleOptionValueST(Variables.bFollowerForcedBleedout, false, "")
	endFunction

	function OnDefaultST()

		Variables.bFollowerForcedBleedout = true
		self.SetToggleOptionValueST(Variables.bFollowerForcedBleedout, false, "")
	endFunction
endState

;-- State -------------------------------------------
state trigger_bocamera_toggle

	function OnHighlightST()

		self.SetInfoText("")
	endFunction

	function OnSelectST()

		Variables.ThirdPersonOnBleedout = !Variables.ThirdPersonOnBleedout
		self.SetToggleOptionValueST(Variables.ThirdPersonOnBleedout, false, "")
	endFunction

	function OnDefaultST()

		Variables.ThirdPersonOnBleedout = true
		self.SetToggleOptionValueST(Variables.ThirdPersonOnBleedout, false, "")
	endFunction
endState

;-- State -------------------------------------------
state GENERAL_MODACTIVE_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_ACTIVATE")
	endFunction

	function OnSelectST()

		Variables.ModActive = !Variables.ModActive
		self.SetToggleOptionValueST(Variables.ModActive, false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.SetModActive(Variables.ModActive)
	endFunction

	function OnDefaultST()

		Variables.ModActive = false
		self.SetToggleOptionValueST(Variables.ModActive, false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.SetModActive(Variables.ModActive)
	endFunction
endState

;-- State -------------------------------------------
state GENERAL_DIFFICULTY_MENU

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_DIFSETTING")
	endFunction

	function OnMenuAcceptST(Int index)

		Variables.DifficultySetting = index
		self.SetMenuOptionValueST(DifficultySettingNameList[index], false, "")
		Variables.BleedOutDamageMult = DifficultySettingBDMList[index]
		self.SetSliderOptionValueST(Variables.BleedOutDamageMult, "{1}x", false, "TRIGGER_BODMGMULT_SLIDER")
	endFunction

	function OnMenuOpenST()

		self.SetMenuDialogStartIndex(Variables.DifficultySetting)
		self.SetMenuDialogDefaultIndex(2)
		self.SetMenuDialogOptions(DifficultySettingNameList)
	endFunction
endState

;-- State -------------------------------------------
state RECOVERQST_PERCLOST_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.StolenGearPercentLost)
		self.SetSliderDialogDefaultValue(20.0000)
		self.SetSliderDialogRange(0.000000, 100.000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_PERCLOST")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.StolenGearPercentLost = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_ADDDISENGAGE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_ADDDISENGAGE")
	endFunction

	function OnSelectST()

		if akPlayer.HasPerk(DisengagePerk)
			akPlayer.RemovePerk(DisengagePerk)
			self.SetToggleOptionValueST(false, false, "")
		else
			akPlayer.AddPerk(DisengagePerk)
			self.SetToggleOptionValueST(true, false, "")
		endIf
	endFunction

	function OnDefaultST()

		akPlayer.RemovePerk(DisengagePerk)
		self.SetToggleOptionValueST(false, false, "")
	endFunction
endState

;-- State -------------------------------------------
state STOLENITEM_HIGHPROB_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.HighCostItemPerc)
		self.SetSliderDialogDefaultValue(100.000)
		self.SetSliderDialogRange(0.000000, 100.000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_GEARPROB")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.HighCostItemPerc = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_BSRESET_TEXT

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_BSRESET")
	endFunction

	function OnSelectST()

		self.SetOptionFlagsST(self.OPTION_FLAG_DISABLED, false, "")
		self.SetTextOptionValueST("$DAYMOYL_OPT_CLOSE", false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		Monitor.SetBlackScreenEffect(false, false)
		debug.Notification("DA - Blackscreen Reseted")
	endFunction
endState

;-- State -------------------------------------------
state GENERAL_ANIMATION_MENU

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_ANIMATIONSETTING")
	endFunction

	function OnMenuAcceptST(Int index)

		Variables.AnimationSetting = index
		self.SetAnimSystem(Variables.AnimationSetting)
		self.SetMenuOptionValueST(AnimationSettingNameList[index], false, "")
	endFunction

	function OnMenuOpenST()

		self.SetMenuDialogStartIndex(Variables.AnimationSetting)
		self.SetMenuDialogDefaultIndex(1)
		self.SetMenuDialogOptions(AnimationSettingNameList)
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_BODUR_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.BleedOutDuration)
		self.SetSliderDialogDefaultValue(10.0000)
		self.SetSliderDialogRange(1.00000, 30.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_BORECOVER")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.BleedOutDuration = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_SECONDS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state STOLENITEM_MEDPROB_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.MediumCostItemPerc)
		self.SetSliderDialogDefaultValue(80.0000)
		self.SetSliderDialogRange(0.000000, 100.000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_GEARPROB")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.MediumCostItemPerc = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state GENERAL_REGISTER_TEXT

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_REGISTER")
	endFunction

	function OnSelectST()

		self.SetOptionFlagsST(self.OPTION_FLAG_DISABLED, false, "")
		self.SetTextOptionValueST("$DAYMOYL_OPT_CLOSE", false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		debug.Notification("Updating DA events...")
		if Registry.ValidateRegisteredQuests()
			debug.Trace("daymoyl - All Registered Events Validated", 0)
		else
			Registry.ClearRegisteredQuests()
		endIf
		self.SendModEvent("daymoyl_MonitorReady", "", 0.000000)
		bManualRegistration = true
		bQueryRegistrySorting = true
		self.RegisterForSingleUpdate(4.00000)
	endFunction
endState

;-- State -------------------------------------------
state METER_COLOR_PICKER

	function OnColorOpenST()

		self.SetColorDialogStartColor(Variables.iMeterColor)
		self.SetColorDialogDefaultColor(4194304)
	endFunction

	function OnColorAcceptST(Int value)

		Variables.iMeterColor = value
		Meter.SetColors(Variables.iMeterColor, -1, -1)
		self.SetColorOptionValueST(Variables.iMeterColor, false, "")
	endFunction

	function OnDefaultST()

		Variables.iMeterColor = 4194304
		self.SetColorOptionValueST(Variables.iMeterColor, false, "")
	endFunction
endState

;-- State -------------------------------------------
state TRIGGER_BODMGMULT_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.BleedOutDamageMult)
		self.SetSliderDialogDefaultValue(1.00000)
		self.SetSliderDialogRange(0.100000, 10.0000)
		self.SetSliderDialogInterval(0.100000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_DMGMULT")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.BleedOutDamageMult = value
		self.SetSliderOptionValueST(value, "{1}x", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_IMMDUR_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.ImmunityDuration)
		self.SetSliderDialogDefaultValue(2.00000)
		self.SetSliderDialogRange(0.500000, 10.0000)
		self.SetSliderDialogInterval(0.500000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_INVTIMER")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.ImmunityDuration = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_SECONDS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state TRIGGER_LARGEHIT_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.LargeHitThreshold * 100.000)
		self.SetSliderDialogDefaultValue(200.000)
		self.SetSliderDialogRange(0.000000, 1000.00)
		self.SetSliderDialogInterval(20.0000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_LARGEHIT")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.LargeHitThreshold = value / 100.000
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state FOLLOWER_FOLCLOAK_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_FOLCLOAK")
	endFunction

	function OnSelectST()

		Variables.bFollowerCloakActive = !Variables.bFollowerCloakActive
		if Variables.bFollowerCloakActive
			if !akPlayer.HasSpell(akPlayerRef.FollowerBehaviorCloak as form)
				akPlayer.AddSpell(akPlayerRef.FollowerBehaviorCloak, false)
			endIf
		else
			akPlayer.RemoveSpell(akPlayerRef.FollowerBehaviorCloak)
		endIf
		self.SetToggleOptionValueST(Variables.bFollowerCloakActive, false, "")
	endFunction

	function OnDefaultST()

		Variables.bFollowerCloakActive = true
		if !akPlayer.HasSpell(akPlayerRef.FollowerBehaviorCloak as form)
			akPlayer.AddSpell(akPlayerRef.FollowerBehaviorCloak, false)
		endIf
		self.SetToggleOptionValueST(Variables.bFollowerCloakActive, false, "")
	endFunction
endState

;-- State -------------------------------------------
state METER_YPOS_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Meter.Y)
		self.SetSliderDialogDefaultValue(645.000)
		self.SetSliderDialogRange(0.000000, 720.000)
		self.SetSliderDialogInterval(0.500000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_YPOS")
	endFunction

	function OnSliderAcceptST(Float a_value)

		Meter.Y = a_value
		MeterController.ShowMeter(8 as Float)
		self.SetSliderOptionValueST(a_value, "{1}", false, "")
	endFunction
endState

;-- State -------------------------------------------
state trigger_critdelay_slider

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.CriticalBleedOutDelay)
		self.SetSliderDialogDefaultValue(0.250000)
		self.SetSliderDialogRange(0.0500000, 1.00000)
		self.SetSliderDialogInterval(0.0500000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_CRITDELAY")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.CriticalBleedOutDelay = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_SECONDS_2DIGITS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_WDDUR_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.WeakenedDebuffDuration * 24.0000)
		self.SetSliderDialogDefaultValue(12.0000)
		self.SetSliderDialogRange(1.00000, 48.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.WeakenedDebuffDuration = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state SECQUEST_PROBTHEFT_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.ChanceOfTheft)
		self.SetSliderDialogDefaultValue(30.0000)
		self.SetSliderDialogRange(0.000000, 100.000 - Variables.ChanceOfRescue)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_THEFTPROB")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.ChanceOfTheft = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state METER_SHORT_DURATION_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.fMeterDuration)
		self.SetSliderDialogDefaultValue(6.00000)
		self.SetSliderDialogRange(2.00000, 30.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_METERDUR")
	endFunction

	function OnSliderAcceptST(Float a_value)

		Variables.fMeterDuration = a_value
		self.SetSliderOptionValueST(a_value, "$DAYMOYL_OPT_SECONDS_1DIGITS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state FOLLOWER_ONDEFEAT_MENU

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_FOLLOWERSETTING")
	endFunction

	function OnMenuAcceptST(Int index)

		Variables.FollowerSetting = index
		self.SetMenuOptionValueST(FollowerSettingNameList[index], false, "")
	endFunction

	function OnMenuOpenST()

		self.SetMenuDialogStartIndex(Variables.FollowerSetting)
		self.SetMenuDialogDefaultIndex(3)
		self.SetMenuDialogOptions(FollowerSettingNameList)
	endFunction
endState

;-- State -------------------------------------------
state METER_LONG_DURATION_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.fMeterLongDuration)
		self.SetSliderDialogDefaultValue(12.0000)
		self.SetSliderDialogRange(2.00000, 60.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_METERLONGDUR")
	endFunction

	function OnSliderAcceptST(Float a_value)

		Variables.fMeterLongDuration = a_value
		self.SetSliderOptionValueST(a_value, "$DAYMOYL_OPT_SECONDS_1DIGITS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_RESETEFFECT_TEXT

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_RESETEFFECT")
	endFunction

	function OnSelectST()

		self.SetOptionFlagsST(self.OPTION_FLAG_DISABLED, false, "")
		self.SetTextOptionValueST("$DAYMOYL_OPT_CLOSE", false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.SendModEvent("da_UpdateBleedingDebuff", "", 0.000000)
		self.SendModEvent("da_EndNearDeathDebuff", "", 0.000000)
		self.SendModEvent("da_RestorePacifiedEnemies", "", 0.000000)
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_REALLAPSE_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.BlackoutRealTimeLapse)
		self.SetSliderDialogDefaultValue(3.00000)
		self.SetSliderDialogRange(1.00000, 12.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_REALLAPSE")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.BlackoutRealTimeLapse = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_SECONDS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_CHEAT_TEXT

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_RESETQUEST")
	endFunction

	function OnSelectST()

		self.SetOptionFlagsST(self.OPTION_FLAG_DISABLED, false, "")
		self.SetTextOptionValueST("$DAYMOYL_OPT_CLOSE", false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.ResetAllQuests()
	endFunction
endState

;-- State -------------------------------------------
state STOLENITEM_HIGHCOST_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.HighCostItem)
		self.SetSliderDialogDefaultValue(200.000)
		self.SetSliderDialogRange(0.000000, 1000.00)
		self.SetSliderDialogInterval(50.0000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_GEARVALUE")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.HighCostItem = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_GOLD", false, "")
	endFunction
endState

;-- State -------------------------------------------
state STOLENITEM_PERCGOLD_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.PercGoldTheft)
		self.SetSliderDialogDefaultValue(90.0000)
		self.SetSliderDialogRange(0.000000, 100.000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_PERCGOLD")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.PercGoldTheft = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_LAPSE_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.BlackoutTimeLapse * 24.0000)
		self.SetSliderDialogDefaultValue(0.500000)
		self.SetSliderDialogRange(0.100000, 4.00000)
		self.SetSliderDialogInterval(0.100000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_LAPSE")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.BlackoutTimeLapse = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_ADDADDFOLLOWER

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_ADDADDFOLLOWER")
	endFunction

	function OnSelectST()

		if akPlayer.HasPerk(AddFollowerPerk)
			akPlayer.RemovePerk(AddFollowerPerk)
			self.SetToggleOptionValueST(false, false, "")
		else
			akPlayer.AddPerk(AddFollowerPerk)
			self.SetToggleOptionValueST(true, false, "")
		endIf
	endFunction

	function OnDefaultST()

		akPlayer.RemovePerk(AddFollowerPerk)
		self.SetToggleOptionValueST(false, false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERQST_SGSETTING_MENU

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_SGSETTING")
	endFunction

	function OnMenuAcceptST(Int index)

		Variables.StolenGearSetting = index
		self.SetMenuOptionValueST(StolenGearSettingNameList[index], false, "")
	endFunction

	function OnMenuOpenST()

		self.SetMenuDialogStartIndex(Variables.StolenGearSetting)
		self.SetMenuDialogDefaultIndex(1)
		self.SetMenuDialogOptions(StolenGearSettingNameList)
	endFunction
endState

;-- State -------------------------------------------
state FORCE_GAMEPAD_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_FORCEGAMEPAD")
	endFunction

	function OnSelectST()

		Variables.bForceGamepad = !Variables.bForceGamepad
		self.SetToggleOptionValueST(Variables.bForceGamepad, false, "")
	endFunction

	function OnDefaultST()

		Variables.bForceGamepad = false
		self.SetToggleOptionValueST(Variables.bForceGamepad, false, "")
	endFunction
endState

;-- State -------------------------------------------
state GENERAL_TUTORIAL_TOGGLE

	function OnHighlightST()

		; Empty function
	endFunction

	function OnSelectST()

		Variables.bTutorialActive = !Variables.bTutorialActive
		self.SetToggleOptionValueST(Variables.bTutorialActive, false, "")
	endFunction

	function OnDefaultST()

		Variables.bTutorialActive = true
		self.SetToggleOptionValueST(Variables.bTutorialActive, false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_BODDUR_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.BleedoutDebuffDuration * 24.0000)
		self.SetSliderDialogDefaultValue(4.00000)
		self.SetSliderDialogRange(1.00000, 24.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_BOTIMER")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.BleedoutDebuffDuration = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state GENERAL_DPYMSG_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_DPYSTATUS")
	endFunction

	function OnSelectST()

		Variables.MessageActive = !Variables.MessageActive
		Util.DisplayMessage(Variables.MessageActive)
		self.SetToggleOptionValueST(Variables.MessageActive, false, "")
	endFunction

	function OnDefaultST()

		Variables.MessageActive = true
		Util.DisplayMessage(Variables.MessageActive)
		self.SetToggleOptionValueST(Variables.MessageActive, false, "")
	endFunction
endState

;-- State -------------------------------------------
state RESCUEQST_HELPDUR_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.TimeOnHelpOffer * 24.0000)
		self.SetSliderDialogDefaultValue(6.00000)
		self.SetSliderDialogRange(1.00000, 24.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_HELPOFFER")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.TimeOnHelpOffer = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_NDDUR_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.NearDeathDebuffDuration * 24.0000)
		self.SetSliderDialogDefaultValue(1.00000)
		self.SetSliderDialogRange(0.500000, 12.0000)
		self.SetSliderDialogInterval(0.500000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_CDRECOVER")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.NearDeathDebuffDuration = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state METER_DISPLAY_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_METERDPY")
	endFunction

	function OnSelectST()

		Variables.bMeterDisplayed = !Variables.bMeterDisplayed
		self.SetToggleOptionValueST(Variables.bMeterDisplayed, false, "")
	endFunction

	function OnDefaultST()

		Variables.bMeterDisplayed = true
		self.SetToggleOptionValueST(Variables.bMeterDisplayed, false, "")
	endFunction
endState

;-- State -------------------------------------------
state SECQUEST_PROBRESCUE_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.ChanceOfRescue)
		self.SetSliderDialogDefaultValue(50.0000)
		self.SetSliderDialogRange(0.000000, 100.000 - Variables.ChanceOfTheft)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_RESCPROB")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.ChanceOfRescue = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_KILLPC_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_KILLPC")
	endFunction

	function OnSelectST()

		Variables.ManageDeath = !Variables.ManageDeath
		self.SetToggleOptionValueST(Variables.ManageDeath, false, "")
	endFunction

	function OnDefaultST()

		Variables.ManageDeath = true
		self.SetToggleOptionValueST(Variables.ManageDeath, false, "")
	endFunction
endState

;-- State -------------------------------------------
state BINDING_DIFFICULTY_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.fBindingDifficulty)
		self.SetSliderDialogDefaultValue(1.00000)
		self.SetSliderDialogRange(0.100000, 10.0000)
		self.SetSliderDialogInterval(0.100000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_BINDING_DIFF")
	endFunction

	function OnSliderAcceptST(Float a_value)

		Variables.fBindingDifficulty = a_value
		self.SetSliderOptionValueST(a_value, "{1}x", false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_DEBUG")
	endFunction

	function OnSelectST()

		Variables.bDebugMode = !Variables.bDebugMode
		self.SetToggleOptionValueST(Variables.bDebugMode, false, "")
	endFunction

	function OnDefaultST()

		Variables.bDebugMode = true
		self.SetToggleOptionValueST(Variables.bDebugMode, false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERQST_HALFLIFE_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.StolenGearHalflife * 24.0000)
		self.SetSliderDialogDefaultValue(12.0000)
		self.SetSliderDialogRange(1.00000, 48.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_HALFLIFEDUR")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.StolenGearHalflife = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state HEALTH_EXTRAHP_TOGGLE

	function OnHighlightST()

		self.SetInfoText("")
	endFunction

	function OnSelectST()

		Variables.HealthBuffer = !Variables.HealthBuffer
		self.SetExtraHPBuffer(Variables.HealthBuffer)
		self.SetToggleOptionValueST(Variables.HealthBuffer, false, "")
	endFunction

	function OnDefaultST()

		Variables.HealthBuffer = false
		self.SetExtraHPBuffer(Variables.HealthBuffer)
		self.SetToggleOptionValueST(Variables.HealthBuffer, false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEFEATED_DEATH_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.PercChanceDeath)
		self.SetSliderDialogDefaultValue(0.000000)
		self.SetSliderDialogRange(0.000000, 100.000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_DEATHCHANCE")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.PercChanceDeath = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state FOLLOWER_PROTPLYR_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_FOLPROTPLYR")
	endFunction

	function OnSelectST()

		Variables.FollowerProtectPlayer = !Variables.FollowerProtectPlayer
		self.SetToggleOptionValueST(Variables.FollowerProtectPlayer, false, "")
	endFunction

	function OnDefaultST()

		Variables.FollowerProtectPlayer = false
		self.SetToggleOptionValueST(Variables.FollowerProtectPlayer, false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_RESET_TEXT

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_RESET")
	endFunction

	function OnSelectST()

		self.SetOptionFlagsST(self.OPTION_FLAG_DISABLED, false, "")
		self.SetTextOptionValueST("$DAYMOYL_OPT_CLOSE", false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		Monitor.SetPlayerControl(true)
		Monitor.BufferDamageReceived(9999.00)
		Monitor.GotoState("")
		game.ForceThirdPerson()
		debug.SetGodMode(false)
		game.SetPlayerAIDriven(true)
		utility.Wait(0.100000)
		game.SetPlayerAIDriven(false)
		debug.SendAnimationEvent(game.GetPlayer() as objectreference, "IdleForceDefaultState")
		if akPlayerRef.GetRef() == none
			akPlayerRef.ForceRefTo(game.GetPlayer() as objectreference)
		endIf
		debug.Notification("DA - Player State Reseted")
	endFunction
endState

;-- State -------------------------------------------
state TOGMAINQST_DEFAULTQST_TOGGLE

	function OnHighlightST()

		self.SetInfoText("")
	endFunction

	function OnSelectST()

		Registry.DefaultQuest.bEnabled = !Registry.DefaultQuest.bEnabled
		self.SetToggleOptionValueST(Registry.DefaultQuest.bEnabled, false, "")
	endFunction

	function OnDefaultST()

		Registry.DefaultQuest.bEnabled = true
		self.SetToggleOptionValueST(Registry.DefaultQuest.bEnabled, false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERY_CALMDUR_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.CalmedDuration)
		self.SetSliderDialogDefaultValue(6.00000)
		self.SetSliderDialogRange(1.00000, 24.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_CALMTIMER")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.CalmedDuration = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state STOLENITEM_LOWPROB_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.LowCostItemPerc)
		self.SetSliderDialogDefaultValue(20.0000)
		self.SetSliderDialogRange(0.000000, 100.000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_GEARPROB")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.LowCostItemPerc = value
		self.SetSliderOptionValueST(value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state METER_XPOS_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Meter.X)
		self.SetSliderDialogDefaultValue(640.500)
		self.SetSliderDialogRange(0.000000, 1280.00)
		self.SetSliderDialogInterval(0.500000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_XPOS")
	endFunction

	function OnSliderAcceptST(Float a_value)

		Meter.X = a_value
		MeterController.ShowMeter(8 as Float)
		self.SetSliderOptionValueST(a_value, "{1}", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERQST_ROAMING_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_ROAMING")
	endFunction

	function OnSelectST()

		Variables.bRoamingGearThief = !Variables.bRoamingGearThief
		self.SetToggleOptionValueST(Variables.bRoamingGearThief, false, "")
	endFunction

	function OnDefaultST()

		Variables.bRoamingGearThief = false
		self.SetToggleOptionValueST(Variables.bRoamingGearThief, false, "")
	endFunction
endState

;-- State -------------------------------------------
state STOLENITEM_MEDCOST_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.MediumCostItem)
		self.SetSliderDialogDefaultValue(40.0000)
		self.SetSliderDialogRange(0.000000, 200.000)
		self.SetSliderDialogInterval(10.0000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_GEARVALUE")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.MediumCostItem = value
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_GOLD", false, "")
	endFunction
endState

;-- State -------------------------------------------
state METER_OPACITY_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.fMeterOpacity)
		self.SetSliderDialogDefaultValue(100.000)
		self.SetSliderDialogRange(0 as Float, 100.000)
		self.SetSliderDialogInterval(5.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_OPACITY")
	endFunction

	function OnSliderAcceptST(Float a_value)

		Variables.fMeterOpacity = a_value
		self.SetSliderOptionValueST(a_value, "{0}%", false, "")
	endFunction
endState

;-- State -------------------------------------------
state RECOVERQST_GOLDHALFLIFE_SLIDER

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(Variables.StolenGoldHalflife * 24.0000)
		self.SetSliderDialogDefaultValue(12.0000)
		self.SetSliderDialogRange(0.000000, 48.0000)
		self.SetSliderDialogInterval(1.00000)
	endFunction

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_GOLDHALFLIFEDUR")
	endFunction

	function OnSliderAcceptST(Float value)

		Variables.StolenGoldHalflife = value / 24.0000
		self.SetSliderOptionValueST(value, "$DAYMOYL_OPT_HOURS", false, "")
	endFunction
endState

;-- State -------------------------------------------
state DEBUG_RESETFOLLOWER_TEXT

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_CLEARFOLLOWER")
	endFunction

	function OnSelectST()

		self.SetOptionFlagsST(self.OPTION_FLAG_DISABLED, false, "")
		self.SetTextOptionValueST("$DAYMOYL_OPT_DONE", false, "")
		akFollowerRef.FreeAllFollowers()
		akFollowerRef.ClearFollowerList()
	endFunction
endState

;-- State -------------------------------------------
state HEALTH_ESSPC_TOGGLE

	function OnHighlightST()

		self.SetInfoText("$DAYMOYL_DESC_ESSPC")
	endFunction

	function OnSelectST()

		Variables.EssentialPlayer = !Variables.EssentialPlayer
		self.SetToggleOptionValueST(Variables.EssentialPlayer, false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.SetEssential(Variables.EssentialPlayer)
	endFunction

	function OnDefaultST()

		Variables.EssentialPlayer = true
		self.SetToggleOptionValueST(Variables.EssentialPlayer, false, "")
		self.ShowMessage("$DAYMOYL_OPT_EXITMENU", false, "$Accept", "$Cancel")
		utility.Wait(0.100000)
		self.SetEssential(Variables.EssentialPlayer)
	endFunction
endState
