extends KinematicBody2D

# the running speed
export (int) var x_speed = 300
# the height of a jump at its apex
export (int) var jump_height = 64 * 3
# the x distance of a jump at its apex
export (int) var jump_distance = 64 * 2

# these physics variables will be set in _ready
var gravity = 0
var initial_jump_y_speed = 0
var can_shoot = true
var is_right = true

# player's current velocity
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = 2 * jump_height * (x_speed * x_speed)
	gravity /= (jump_distance * jump_distance)
	initial_jump_y_speed = -2 * jump_height * x_speed
	initial_jump_y_speed /= jump_distance

func get_input(delta):
	if Input.is_action_just_pressed("ui_restart"):
		restart()
	velocity.x = get_floor_velocity().x /200
	if Input.is_action_pressed("ui_right"):
		velocity.x += x_speed
		is_right = true
	if Input.is_action_pressed("ui_left"):
		velocity.x -= x_speed
		is_right = false
	if is_on_floor() and Input.is_action_pressed("ui_select"):
		velocity.y += initial_jump_y_speed
	if Input.is_action_just_pressed("ui_action") and can_shoot:
		shoot()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	get_input(delta)
	velocity.y += gravity * delta
	# we change this depending on the platform we're on
	# var ground_normal = Vector2(0, -1)
	velocity = move_and_slide(velocity, Vector2(0, -1), true)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "KillZone":
			restart()

func shoot():
	can_shoot = false
	get_node("CooldownTimer").start()
	
	var projectile = load("res://Orb.tscn")
	var orb = projectile.instance()
	orb.transform.origin = self.transform.origin
	

	var bouncer = orb.get_child(0)
	if is_right:
		bouncer.velocity.x = 1
		orb.transform.origin.x += 64
	else:
		bouncer.velocity.x = -1
		orb.transform.origin.x -= 64
	get_tree().get_root().get_child(0).get_node("OrbManager").add_child(orb)

func restart():
	get_tree().change_scene(get_tree().current_scene.filename)

func _on_CooldownTimer_timeout():
	can_shoot = true
	# maybe disable the timer?
