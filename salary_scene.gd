extends Node2D

func _ready():
	var bonus = GameState.items_delivered * 20
	var day_pay = max(20, 50+ bonus)
	GameState.money += day_pay
	
	$DayLabel.text = "Day " + str(GameState.day) + " complete."
	$ItemsLabel.text = "Delivered: " + str(GameState.items_delivered) + " / 5"
	$SalaryLabel.text = "Pay today: $" + str(day_pay)
	$TotalLabel.text = "Running total: " + str(GameState.money)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		GameState.day += 1
		GameState.items_delivered = 0
		GameState.drive_mode = "to_town"
		GameState.items = 5
		if GameState.day > 3:
			get_tree().change_scene_to_file("res://end_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://boss_scene.tscn")
		
