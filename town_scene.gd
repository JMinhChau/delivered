extends Node2D

const DIALOGUE = {
	"NPC1": ["Oh wonderful, thanks!", "Nothing today? That's alright..."],
	"NPC2": ["You're a lifesaver!", "Empty-handed again. That boss of yours..."],
	"NPC3": ["Yes!! My stuff arrived!", "Aww... maybe tomorrow?"],
}

var visited = []

@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var leave_button = $LeaveButton

func _ready():
	for npc_name in ["NPC1", "NPC2", "NPC3"]:
		var npc = get_node(npc_name)
		npc.input_event.connect(_on_npc_clicked.bind(npc_name))
	leave_button.pressed.connect(_on_leave)

func _on_npc_clicked(viewport, event, shape, npc_name):
	if not event is InputEventMouseButton or not event.pressed:
		return
	if npc_name in visited:
		return

	visited.append(npc_name)

	var variant = 0 if GameState.items > 0 else 1
	dialogue_text.text = DIALOGUE[npc_name][variant]
	dialogue_box.visible = true

	if variant == 0:
		GameState.items -= 1
		GameState.items_delivered += 1

	if visited.size() == 3:
		leave_button.visible = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and dialogue_box.visible:
		dialogue_box.visible = false

func _on_leave():
	GameState.drive_mode = "return"  # ← this line must be here
	get_tree().change_scene_to_file("res://drive_scene.tscn")
