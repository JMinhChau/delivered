extends Node2D

func _ready():
	var max_deliveries = GameState.active_npcs.size()
	var delivery_bonus = GameState.items_delivered * 20
	var near_bonus = GameState.near_miss_bonus
	var day_pay = max(20, 50 + delivery_bonus + near_bonus)
	GameState.money += day_pay

	GameState.total_km += GameState.drive_km
	GameState.drive_score = int(round(GameState.drive_km * 100.0))
	if GameState.drive_km > GameState.best_km:
		GameState.best_km = GameState.drive_km
	GameState.highscore = int(round(GameState.best_km * 100.0))

	$DayLabel.text = "Day " + str(GameState.day) + " complete."
	$ItemsLabel.text = "Delivered: " + str(GameState.items_delivered) + " / " + str(max_deliveries)
	$SalaryLabel.text = "Pay today: $" + str(day_pay)
	$TotalLabel.text = "Running total: $" + str(GameState.money)

	if near_bonus > 0:
		$NearMissLabel.text = "Near miss bonus: $" + str(near_bonus) + " 🔥"
		$NearMissLabel.visible = true
	else:
		$NearMissLabel.visible = false

	if GameState.gas_collected > 0:
		$GasLabel.text = "Gas pickups: " + str(GameState.gas_collected) + "  (+" + _km_text(GameState.gas_collected * 0.08) + ")"
		$GasLabel.visible = true
	else:
		$GasLabel.visible = false

	$ScoreLabel.text = "Drive: " + _km_text(GameState.drive_km)
	if GameState.drive_km > 0 and GameState.drive_km >= GameState.best_km:
		$HighscoreLabel.text = "Best drive: " + _km_text(GameState.best_km) + " *"
	else:
		$HighscoreLabel.text = "Best drive: " + _km_text(GameState.best_km)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		GameState.last_delivered = GameState.items_delivered
		GameState.day += 1
		GameState.items_delivered = 0
		GameState.near_miss_chain = 0
		GameState.near_miss_bonus = 0
		GameState.gas_collected = 0
		if GameState.day > 3:
			get_tree().change_scene_to_file("res://end_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://boss_scene.tscn")

func _km_text(km: float) -> String:
	return "%0.2f km" % km
