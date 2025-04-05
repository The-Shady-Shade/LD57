extends Node2D

@onready var player: CharacterBody2D = global.player

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body == player:
		player.dash_time = 0.0
		player.glide_force = 1.0
		player.velocity.y = player.jump_power * 2.5
		player.boost_sfx.play()
