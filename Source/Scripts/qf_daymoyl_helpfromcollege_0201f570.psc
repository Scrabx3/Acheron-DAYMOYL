;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname qf_daymoyl_helpfromcollege_0201f570 Extends Quest Hidden

;BEGIN ALIAS PROPERTY theScholar
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theScholar Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theExit
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theExit Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
actor thePlayer = Alias_thePlayer.GetActorRef()
Int i = 0
Int j = 0
if thePlayer.IsInFaction(ArchmageFaction)
	i = utility.RandomInt(1, 2)
	j = utility.RandomInt(1, 2)
else
	i = utility.RandomInt(2, 4)
	j = utility.RandomInt(2, 4)
endIf
while i
	i -= 1
	thePlayer.AddItem(RandomScroll as form, 1, false)
endWhile
while j
	j -= 1
	thePlayer.AddItem(RandomPotion as form, 1, false)
endWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
objectreference thePlayer = Alias_thePlayer.GetRef()
thePlayer.AddItem(CollegeRobes as form, 1, false)
thePlayer.AddItem(CollegeHood as form, 1, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Alias_theScholar.GetRef().DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Util.DisplayPM("Someone is approaching")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

leveleditem property RandomPotion auto
daymoyl_monitorutility property Util auto
leveleditem property CollegeHood auto
faction property ArchmageFaction auto
leveleditem property CollegeRobes auto
leveleditem property RandomScroll auto
