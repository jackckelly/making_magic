extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
export var velocity = Vector2()

func _ready():
	print("Shooting projectile")
	#velocity.x = 50


func _physics_process(delta):
	var collide = move_and_collide(velocity * delta)
	if collide and not collide.get_collider().name == "Olauer":
		velocity = velocity.bounce(collide.normal)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
