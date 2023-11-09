extends Control

signal countdown_done

@onready var left_score = $LeftScore
@onready var right_score = $RightScore

@onready var screen_size : Vector2 = get_viewport_rect().size
@onready var countdown = $CountdownPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	left_score.global_position = Vector2(screen_size.x * 0.25, 50)
	right_score.global_position = Vector2(screen_size.x * 0.75, 50)


func _on_main_left_scored(value):
	left_score.text = str(value)

func _on_main_game_over(left_won):
	$WinnerLabel.show()
	if left_won:
		$WinnerLabel.text = "Player One is the winner!"
	else:
		$WinnerLabel.text = "Player Two is the winner!"


func _on_main_right_scored(value):
	right_score.text =  str(value)

func _on_main_reset():
	countdown.start()

func _on_countdown_panel_countdown_over():
	emit_signal("countdown_done")

func _on_main_new_game():
	left_score.text = str(0)
	right_score.text = str(0)
	$WinnerLabel.hide()
