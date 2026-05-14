extends Node

const SPEAKER_PITCH = {
	"":         1.0,
	"You":      1.1,
	"Mr. Gus":  0.55,
	"Momo":     1.3,
	"Pip":      0.85,
	"Benne":    0.65,
	"K":        1.15,
	"Lou":      0.92,
}

const GAS_SCORE_VALUE = 50

var day = 1
var items = 5
var money = 100
var items_delivered = 0
var last_delivered = 0
var near_miss_chain = 0
var near_miss_bonus = 0
var gas_collected = 0
var drive_score = 0
var highscore = 0
var drive_km = 0.0
var total_km = 0.0
var best_km = 0.0
var last_ignition_bonus = 0
var last_ignition_quality = ""
var inventory = {}
var active_npcs = []

# Cross-day delivery memory
# { "Momo": [true, false, true, ...], "Pip": [...], ... }
# Each entry = whether that NPC got their delivery on that day they were active
var npc_delivery_log: Dictionary = {}

# Running total deliveries across all days (for ending branch)
var total_deliveries: int = 0

# Per-day delivery count snapshot [ d1_count, d2_count, ... ]
var day_history: Array = []

func reset_run():
	day = 1
	items = 5
	money = 100
	items_delivered = 0
	last_delivered = 0
	near_miss_chain = 0
	near_miss_bonus = 0
	gas_collected = 0
	drive_score = 0
	highscore = 0
	drive_km = 0.0
	total_km = 0.0
	best_km = 0.0
	last_ignition_bonus = 0
	last_ignition_quality = ""
	inventory = {}
	active_npcs = []
	npc_delivery_log = {}
	total_deliveries = 0
	day_history = []
