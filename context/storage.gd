extends Node

var a_player_has_been_damaged := false
var clearable_cubes: int = 0
var cleared_cubes: int = 0
const REWARDS_INITIAL_STATE: Dictionary = {
	"1": {
		"1": {"1": false, "2": false, "3": false},
		"2": {"1": false, "2": false, "3": false},
		"3": {"1": false, "2": false, "3": false},
		"4": {"1": false, "2": false, "3": false},
		"5": {"1": false, "2": false, "3": false},
	},
	"2": {
		"1": {"1": false, "2": false, "3": false},
		"2": {"1": false, "2": false, "3": false},
		"3": {"1": false, "2": false, "3": false},
	},
	"3": {
		"1": {"1": false, "2": false, "3": false},
		"2": {"1": false, "2": false, "3": false},
		"3": {"1": false, "2": false, "3": false},
	},
}
var rewards_state := REWARDS_INITIAL_STATE.duplicate(true)

const FILE_PATH: String = "user://savegame.save"

func save_game() -> void:
	var save_dict: Dictionary = rewards_state
	var save_file := FileAccess.open(FILE_PATH, FileAccess.WRITE)

	var json_string := JSON.stringify(save_dict)
	save_file.store_line(json_string)
	print("Game saved!")


func load_game() -> void:
	print("Trying to load...")
	if not FileAccess.file_exists(FILE_PATH):
		return
	
	var save_file := FileAccess.open(FILE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string := save_file.get_line()
		var json := JSON.new()
		
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result := json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var node_data: Variant = json.data
		if typeof(json.data) == TYPE_DICTIONARY:
			rewards_state = node_data
			print("Game loaded!")


func reset_level() -> void:
	clearable_cubes = 0
	cleared_cubes = 0
	a_player_has_been_damaged = false


func reset_saved_data() -> void:
	rewards_state = REWARDS_INITIAL_STATE.duplicate(true)
	save_game()


func set_reward_vars() -> void:
	set_current_level_reward(1)
	if !a_player_has_been_damaged:
		set_current_level_reward(2)
	if clearable_cubes == cleared_cubes:
		set_current_level_reward(3)


func increase_clearable_cubes(amount: int) -> void:
	clearable_cubes += amount


func increase_cleared_cubes_by_one() -> void:
	cleared_cubes += 1


func get_level_reward(group: int, level: int, reward_type: int) -> bool:
	return rewards_state[str(group)][str(level)][str(reward_type)]

func get_current_level_reward(reward_type: int) -> bool:
	return rewards_state[str(Globals.current_group)][str(Globals.current_level)][str(reward_type)]


func set_level_reward(group: int, level: int, reward_type: int) -> void:
	rewards_state[str(group)][str(level)][str(reward_type)] = true

func set_current_level_reward(reward_type: int) -> void:
	rewards_state[str(Globals.current_group)][str(Globals.current_level)][str(reward_type)] = true
