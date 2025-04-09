extends Node2D

@export var ending_scene: PackedScene
@export var system_malfunction_soundtrack: AudioStreamPlayer
@export var circuits_dance_soundtrack: AudioStreamPlayer
@export var stack_overflow_soundtrack: AudioStreamPlayer

func _process(_delta: float) -> void:
	if global.destroy:
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_packed(ending_scene)
	
	elif !system_malfunction_soundtrack.playing && !circuits_dance_soundtrack.playing && !stack_overflow_soundtrack.playing:
		var soundtrack: int = randi_range(1, 3)
		match soundtrack:
			1:
				system_malfunction_soundtrack.play()
			2:
				circuits_dance_soundtrack.play()
			3:
				stack_overflow_soundtrack.play()
