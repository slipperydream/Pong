extends Node2D

signal wall_height
signal left_scored
signal right_scored
signal new_game
signal game_over
signal reset
signal paused

@export var play_to_score : int = 5

@onready var left_paddle = $CanvasLayer/LeftPaddle
@onready var right_paddle = $CanvasLayer/RightPaddle
@onready var ball = $CanvasLayer/Ball
@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var settings = $CanvasLayer/Settings

var left_score : int = 0
var right_score : int = 0
var left_won : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("wall_height", $CanvasLayer/TopWall/Sprite2D.texture.get_height())
	
func check_for_win():
	var winner = false
	if left_score >= play_to_score:
		left_won = true
		winner = true
		emit_signal("game_over", left_won)
	elif right_score >= play_to_score:
		left_won = false
		winner = true
		emit_signal("game_over", left_won)
	
	if winner == false:
		reset_play()
		
func reset_play():
	emit_signal("reset")
	
func reset_ball():
	ball.reset()

func _on_left_goal_body_entered(body):
	if body is Ball:
		right_score += 1
		emit_signal("right_scored", right_score)
		check_for_win()

func _on_right_goal_body_entered(body):
	if body is Ball:
		left_score += 1
		emit_signal("left_scored", left_score)
		check_for_win()

func _on_ui_countdown_done():
	reset_ball()

func _on_game_over(_value):
	await get_tree().create_timer(2).timeout
	$CanvasLayer/MainMenu.show()

func _on_main_menu_num_players(value):
	reset_play()
	emit_signal("new_game")
	if value == 1:
		right_paddle.computer_controlled = true

func _on_main_menu_open_settings():
	settings.show()
	settings.start(play_to_score)
	
func _on_settings_play_to(value):
	play_to_score = value

func get_color(value):
	match value:
		"RED":
			return Color.RED
		"GREEN": 
			return Color.GREEN
		"BLUE":
			return Color.BLUE
		"YELLOW":
			return Color.YELLOW
		"PURPLE":
			return Color.PURPLE
		"ORANGE":
			return Color.ORANGE
		"WHITE":
			return Color.WHITE
		
func _on_settings_lp_color(value):
	var color = get_color(value)
	$CanvasLayer/LeftPaddle/Sprite2D.modulate = color

func _on_settings_rp_color(value):
	var color = get_color(value)
	$CanvasLayer/RightPaddle/Sprite2D.modulate = color
	
func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:			
			emit_signal("paused", get_tree().paused)
			get_tree().paused = false
		else:
			emit_signal("paused", get_tree().paused)
			get_tree().paused = true

func _on_settings_settings_closed():
	if get_tree().paused:
		get_tree().paused = false

