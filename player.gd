extends CharacterBody2D

signal health_depleted

var health = 100.0
var rapid_fire_active = false

func _ready():
	%PickupBox.area_entered.connect(_on_pickup)

func _on_pickup(area):
	if area.has_method("activate_rapid_fire"):
		area.activate_rapid_fire(self)

func _physics_process(delta):
	const SPEED = 600.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	if velocity.length() > 0.0:
		%Sprite2D.flip_h = velocity.x < 0
	const DAMAGE_RATE = 6.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%HealthBar.value = health
		if health <= 0.0:
			health_depleted.emit()

func start_rapid_fire():
	if rapid_fire_active:
		return
	rapid_fire_active = true
	%Gun.apply_rapid_fire(true)
	await get_tree().create_timer(5.0).timeout
	%Gun.apply_rapid_fire(false)
	rapid_fire_active = false
