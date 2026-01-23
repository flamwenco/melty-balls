extends Control

@onready var hud_text := $MarginContainer/VBoxContainer/HBoxContainer2/Control/RichTextLabel

func _ready():
	hide()
	SignalBus.updateHud.connect(update_display)

func update_display():
	hud_text.text = "\n\nGoals: " + str(HudData.current_goals) + " / " + str(HudData.goals_needed) + "\nLil Guys Remaining: " + str(HudData.lilguys_remaining) + " / " + str(HudData.lilguys_max) + "\nLil Guys Melted: " + str(HudData.lilguys_melted)
