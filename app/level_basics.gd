extends Node3D
@onready var total: Label = $Debug/Total
@onready var mines: Label = $Debug/Mines
@onready var clearable: Label = $Debug/Clearable
@onready var cleared: Label = $Debug/Cleared


func _physics_process(_delta: float) -> void:
	clearable.text = str(Globals.clearable_cubes)
	cleared.text = str(Globals.cleared_cubes)
	#total.text = Globals.
	#mines.text = Globals.
