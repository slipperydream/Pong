extends CharacterBody2D

@export var is_left_paddle : bool = true
@export var speed : int = 5
@onready var paddle_height = $Sprite2D.texture.get_height()
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var ball = get_tree().get_first_node_in_group("ball")

var wall_height = 80
var vert_speed = 0
var computer_controlled : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func get_input():
	var input_dir
	if is_left_paddle:
		input_dir = Input.get_axis("left_up", "left_down")
	else:
		input_dir = Input.get_axis("right_up", "right_down")
	vert_speed = input_dir * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if computer_controlled:
		get_computer_movement()
	else:
		get_input()
	global_position.y += vert_speed
	global_position.y = clamp(global_position.y, wall_height + paddle_height/2, screen_size.y-(wall_height + paddle_height/2) )

func get_computer_movement():
	if ball.global_position.x > screen_size.x/2:
		if ball.global_position.y > (global_position.y + paddle_height/2):
			vert_speed = randi_range(0,2) * speed
		elif ball.global_position.y < (global_position.y - paddle_height/2):
			vert_speed = randi_range(-2,0) * speed
		else:
			vert_speed = 0
	else:
			vert_speed = 0
			
func hit():
	$AnimationPlayer.play("hit")
	
func reset():
	if is_left_paddle:
		global_position = Vector2(screen_size.x * 0.1, screen_size.y/2)
	else:
		global_position = Vector2(screen_size.x * 0.9, screen_size.y/2)

func _on_main_wall_height(value):
	wall_height = value

func _on_main_reset():
	reset()

func _on_main_game_over(left_is_winner):
	if left_is_winner and is_left_paddle:
		$AnimationPlayer.play("winner")
	elif left_is_winner == false and is_left_paddle == false:
		$AnimationPlayer.play("winner")
	else:
		$AnimationPlayer.play("loser")

func _on_main_new_game():
	$AnimationPlayer.stop()
