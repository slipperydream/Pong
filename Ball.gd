extends CharacterBody2D

class_name Ball

@export var max_speed : int = 250
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var sound_player = $AudioStreamPlayer2D

@export var hit_sounds : Array[AudioStreamWAV] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		play_hit()
		velocity = velocity.bounce(collision.get_normal())
		velocity.x *= 1.05
		velocity.y *= 1.05
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func reset():
	global_position =  Vector2(screen_size.x/2, screen_size.y/2)
	var vel_x = get_seed() * max_speed
	var vel_y = get_seed() * max_speed
	velocity = Vector2(vel_x, vel_y)

func get_seed():
	var nums = [-1,-0.75, -0.5, 0.5, 0.75,1]
	randomize()
	return nums[randi() % nums.size()]

func play_hit():
	sound_player.volume_db = -20
	var sound = hit_sounds[randi() % hit_sounds.size()]
	sound_player.stream = sound
	sound_player.play()


func _on_settings_speed_set(speed):
	match speed:
		"NORMAL":
			max_speed = 250
		"FAST": 
			max_speed = 325
		"VERY FAST":
			max_speed = 400
