extends Node2D

var labelText = ""
var fontSize: int = 25
var fontColor = "ffffff"
var crit = false
var critFontSize: int = 40
var critFontColor := "d0d000"

func _ready():
	$DamageTextLabel.text = labelText
	if crit:
		fontSize = critFontSize
		fontColor = critFontColor
	$DamageTextLabel.set("theme_override_font_sizes/font_size", fontSize)
	$DamageTextLabel.set("theme_override_colors/font_color", fontColor)
	$AnimationPlayer.play("up_fade")
