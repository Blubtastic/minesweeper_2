extends Node3D
@onready var total: Label = $Debug/Total
@onready var mines: Label = $Debug/Mines
@onready var clearable: Label = $Debug/Clearable
@onready var cleared: Label = $Debug/Cleared


func _physics_process(_delta: float) -> void:
	clearable.text = str(Storage.clearable_cubes)
	cleared.text = str(Storage.cleared_cubes)
	#total.text = Storage.
	#mines.text = Storage.
