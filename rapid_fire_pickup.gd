extends Area2D

func activate_rapid_fire(player):
	player.start_rapid_fire()
	queue_free()
