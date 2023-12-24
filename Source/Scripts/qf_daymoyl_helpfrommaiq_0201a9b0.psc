;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname qf_daymoyl_helpfrommaiq_0201a9b0 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MaiqTheLiar
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MaiqTheLiar Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Alias_MaiqTheLiar.GetRef().MoveToMyEditorLocation()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
Alias_thePlayer.GetRef().AddItem(Fork as form, 1, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
if TriggerCount.GetValue() != 0 as Float
	self.Stop()
	return 
endIf
TriggerCount.SetValue(1 as Float)
Util.DisplayPM("Someone is approaching")
objectreference[] Maiq = new objectreference[1]
Maiq[0] = Alias_MaiqTheLiar.GetRef()
Util.MoveBehindPlayer(Maiq, 256.000, 90.0000)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

daymoyl_monitorutility property Util auto
weapon property Fork auto
globalvariable property TriggerCount auto
