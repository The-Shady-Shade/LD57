extends Node

var text_box_scene: PackedScene = preload("res://scenes/text_box.tscn")
var text_box: MarginContainer
var text_box_position: Vector2
var dialog_lines: Array[String] = []
var current_line_index: int = 0
var dialog_active: bool = false
var can_advance_line: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() && dialog_active && can_advance_line:
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			dialog_active = false
			current_line_index = 0
			return
		show_text_box()

func start_dialog(lines: Array[String], position: Vector2) -> void:
	if dialog_active:
		return
	dialog_lines = lines
	text_box_position = position
	show_text_box()
	dialog_active = true

func show_text_box() -> void:
	text_box = text_box_scene.instantiate()
	text_box.finished.connect(on_text_box_finished)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false

func on_text_box_finished() -> void:
	can_advance_line = true
