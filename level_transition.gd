extends CanvasLayer

signal finished

func play(level_number: int):
	process_mode = Node.PROCESS_MODE_ALWAYS
	show()
	$AnimatedSprite2D.play("default")
	$Label.text = "Sledeci nivo: " + str(level_number)
	await get_tree().create_timer(4.0, true).timeout
	hide()
	emit_signal("finished")
