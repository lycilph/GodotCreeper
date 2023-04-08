extends Node2D

@export var animation : AnimationPlayer

var direction : Vector2
var speed : int = 500
var target : Vector2
var hit_target = false

func _ready():
	animation.play("flying")

func _physics_process(delta):
	if (hit_target == false):
		position = position + direction.normalized() * speed * delta
	
	if (position.distance_to(target) < 5):
		hit_target = true
		animation.play("explosion")

func animation_finished():
	queue_free()
