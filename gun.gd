extends Area2D

var base_wait_time = 0.3

func _process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const BULLET = preload("res://bullet_2d.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	%ShootingPoint.add_child(new_bullet)

func apply_rapid_fire(active):
	if active:
		%Timer.wait_time = base_wait_time / 10.0
	else:
		%Timer.wait_time = base_wait_time

func _on_timer_timeout() -> void:
	shoot()
