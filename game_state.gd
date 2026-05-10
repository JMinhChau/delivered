extends Node

const SPEAKER_PITCH = {
	"":         1.0,
	"You":      1.1,
	"Mr. Gus":  0.55,
	"Momo":     1.3,
	"Pip":      0.85,
	"Benne":    0.65,
	"K":        1.15,
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
