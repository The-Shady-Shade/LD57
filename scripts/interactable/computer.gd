extends Node2D

@export var text_box_scene: PackedScene
@export var animation: AnimatedSprite2D
@export var fix_sfx: AudioStreamPlayer
@export var tilemap: TileMap
@export var decoration_tilelayer: TileMapLayer
@export var spikes: Node2D
var text: Array[String] = [
	"Press Shift to Dash!",
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
				global.player.can_glide = true
				text = ["Hold Space to glide!"]
			3:
				text = ["2 more left, buddy."]
			4:
				text = ["Last one left!"]
			5:
				global.destroy = true
		animation.play("fixed")
		fix_sfx.play()
		fixed = true
		
		if global.destroy:
			text = ["Get out of here."]
		dialog_manager.start_dialog(text, global_position)
		
		if global.destroy:
			await get_tree().create_timer(2).timeout
			tilemap.queue_free()
			decoration_tilelayer.queue_free()
			spikes.queue_free()
			queue_free()
