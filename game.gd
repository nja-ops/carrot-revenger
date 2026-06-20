extends Node2D
var current_level = 1
var level_time = 0.0
var level_durations = [40.0, 60.0, 40.0]
var spawn_rates = [1, 0.8, 0.5]
var pickup_chances = [0.3, 0.15, 0.05]
var game_finished = false
var score = 0
func _ready():
	%Timer.wait_time = spawn_rates[0]
	%LevelUp.hide()
	update_level_visuals()
func _process(delta):
	if game_finished:
		return
	level_time += delta
	var required_time = level_durations[current_level - 1]
	var time_left = max(0, required_time - level_time)
	%TimerLabel.text = "Vreme: " + str(int(time_left))
	%ScoreLabel.text = "Skor: " + str(score)
	if level_time >= required_time:
		if current_level < 3:
			show_level_up()
		else:
			show_victory()
func add_score():
	score += 1
func spawn_mob():
	%PathFollow2D.progress_ratio = randf()
	var new_mob = preload("res://mob.tscn").instantiate()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.pickup_chance = pickup_chances[current_level - 1]
	new_mob.died.connect(add_score)
	add_child(new_mob)
func clear_pickups():
	for child in get_children():
		if child is Area2D and child.has_method("activate_rapid_fire"):
			child.queue_free()
func update_level_visuals():
	%Level1Map.visible = (current_level == 1)
	%Level2Map.visible = (current_level == 2)
	%Level3Map.visible = (current_level == 3)
func show_level_up():
	game_finished = true
	%Timer.stop()
	clear_pickups()
	%LevelUp.hide()
	var transition = preload("res://level_transition.tscn").instantiate()
	add_child(transition)
	get_tree().paused = true
	transition.play(current_level + 1)
	await transition.finished
	get_tree().paused = false
	transition.queue_free()
	current_level += 1
	level_time = 0.0
	game_finished = false
	update_level_visuals()
	%Timer.wait_time = spawn_rates[current_level - 1]
	%Timer.start()
func show_victory():
	game_finished = true
	%Timer.stop()
	%Music.stop()
	%VictoryMusic.process_mode = Node.PROCESS_MODE_ALWAYS
	%VictoryMusic.play()
	%Victory.show()
	get_tree().paused = true
func _on_timer_timeout():
	spawn_mob()
func _on_player_health_depleted():
	game_finished = true
	%GameOver.show()
	get_tree().paused = true
func _on_button_pressed():
	current_level = 1
	level_time = 0.0
	game_finished = false
	score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
