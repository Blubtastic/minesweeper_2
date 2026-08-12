extends Node

var a_player_has_been_damaged := false
var clearable_cubes: int = 0
var cleared_cubes: int = 0
const REWARDS_INITIAL_STATE: Dictionary = {
	1: {
		1: {1: false, 2: false, 3: false},
		2: {1: false, 2: false, 3: false},
		3: {1: false, 2: false, 3: false},
		4: {1: false, 2: false, 3: false},
		5: {1: false, 2: false, 3: false},
	},
	2: {
		1: {1: false, 2: false, 3: false},
		2: {1: false, 2: false, 3: false},
		3: {1: false, 2: false, 3: false},
	},
	3: {
		1: {1: false, 2: false, 3: false},
		2: {1: false, 2: false, 3: false},
		3: {1: false, 2: false, 3: false},
	},
}
var rewards_state := REWARDS_INITIAL_STATE.duplicate(true)


func reset_level() -> void:
	clearable_cubes = 0
	cleared_cubes = 0
	a_player_has_been_damaged = false


func reset_stored_state() -> void:
	rewards_state = REWARDS_INITIAL_STATE.duplicate(true)


func set_reward_vars() -> void:
	rewards_state[Globals.current_group][Globals.current_level][1] = true
	if !a_player_has_been_damaged:
		rewards_state[Globals.current_group][Globals.current_level][2] = true
	if clearable_cubes == cleared_cubes:
		rewards_state[Globals.current_group][Globals.current_level][3] = true


func increase_clearable_cubes(amount: int) -> void:
	clearable_cubes += amount


func increase_cleared_cubes_by_one() -> void:
	cleared_cubes += 1
