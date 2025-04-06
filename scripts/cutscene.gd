extends Control
@export var world_scene: PackedScene
var text: Array[String] = [
	"Error occured.",
	"Waiting for technical operation...",
]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(1).timeout
	dialog_manager.start_dialog(text, global_position)
	await dialog_manager.finished
	get_tree().change_scene_to_packed(world_scene)
