extends Control

func _ready():
	$InstructionsPanel.hide()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://survivors_game.tscn")

func _on_instructions_button_pressed():
	$InstructionsPanel.visible = !$InstructionsPanel.visible

func _on_exit_button_pressed():
	get_tree().quit()
	
func _on_close_button_pressed():
	$InstructionsPanel.hide()


func _on_button_pressed() -> void:
	$InstructionsPanel.hide()
