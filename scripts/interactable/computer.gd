extends Node2D

@export var text_box_scene: PackedScene
@export var animation: AnimatedSprite2D
@export var fix_sfx: AudioStreamPlayer
var text: Array[String] = [
	"Press Shift to Dash!",
	"Press S to transform into a ball!",
	"Hold Space to glide!"
]
var text_box: Control
var fixed: bool = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body == global.player && !fixed:
		global.computers_fixed += 1
		match global.computers_fixed:
			1:
				global.player.can_dash = true
				text = ["Press Shift to Dash!"]
			2:
				global.player.can_ball = true
				text = ["Press S to transform into a ball!"]
			3:
				global.player.can_glide = true
				text = ["Hold Space to glide!"]
		animation.play("fixed")
		fix_sfx.play()
		fixed = true
		
		dialog_manager.start_dialog(text, global_position)
