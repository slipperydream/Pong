extends Control

signal lp_color
signal rp_color
signal play_to
signal settings_closed
signal speed_set

@onready var points = $HBoxContainer3/SpinBox
@onready var lp_color_setting = $HBoxContainer2/LeftPaddleColor
@onready var rp_color_setting = $HBoxContainer/RightPaddleColor
@onready var ball_speed = $HBoxContainer4/BallSpeed

func start(game_length):
	points.value = game_length
	
func _on_button_pressed():
	emit_signal("settings_closed")
	hide()

func _on_spin_box_value_changed(value):
	emit_signal("play_to", points.value)

func _on_left_paddle_color_item_selected(index):
	var color = lp_color_setting.get_item_text(index)
	emit_signal("lp_color", color)


func _on_right_paddle_color_item_selected(index):
	var color = rp_color_setting.get_item_text(index)
	emit_signal("rp_color", color)

func _on_main_paused(value):
	if value:
		visible = true
	else:
		visible = false

func _on_ball_speed_item_selected(index):
	var speed = ball_speed.get_item_text(index)
	emit_signal("speed_set", speed)
