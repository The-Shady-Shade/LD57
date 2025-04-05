extends Node2D

func _on_collision_area_body_entered(body: Node2D) -> void:
	if body == global.player:
		body.get_damage()
