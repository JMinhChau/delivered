extends Node2D

func _ready():
	var max_deliveries = GameState.active_npcs.size()
	var delivery_bonus = GameState.items_delivered * 20
	var near_bonus = GameState.near_miss_bonus
	var day_pay = max(20, 50 + delivery_bonus + near_bonus)
	GameState.money += day_pay

	$DayLabel.text = "Day " + str(GameState.day) + " complete."
	$ItemsLabel.text = "Delivered: " + str(GameState.items_delivered) + " / " + str(max_deliveries)
	$SalaryLabel.text = "Pay today: $" + str(day_pay)
	$TotalLabel.text = "Running total: $" + str(GameState.money)

	if near_bonus > 0:
		$NearMissLabel.text = "Near miss bonus: $" + str(near_bonus) + " 🔥"
		$NearMissLabel.visible = true
	else:
		$NearMissLabel.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		GameState.last_delivered = GameState.items_delivered
		GameState.day += 1
		GameState.items_delivered = 0
		GameState.near_miss_chain = 0
		GameState.near_miss_bonus = 0
		GameState.drive_mode = "to_town"
		if GameState.day > 3:
			get_tree().change_scene_to_file("res://end_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://boss_scene.tscn")
