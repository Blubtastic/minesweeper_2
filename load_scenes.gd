extends Node3D

const EXPLOSION_EFFECT = preload("uid://b8yejfq3fcemn")
const SNOW = preload("uid://62fr2rhqfdeo")
const TIRE_DEBRIS_SNOW = preload("uid://b7wmb8jxswbil")
const TRAIL_VFX = preload("uid://drynt1383xlht")
const SPARKS = preload("uid://dvabslbqfwp0v")
const POOF = preload("uid://ddwftyj3tif34")

func _ready():
	var explosion_instance = EXPLOSION_EFFECT.instantiate()
	var snow_instance = SNOW.instantiate()
	var tires_debris_instance = TIRE_DEBRIS_SNOW.instantiate()
	var trail_instance = TRAIL_VFX.instantiate()
	var sparks_instance = SPARKS.instantiate()
	var poof_instance = POOF.instantiate()
	
	add_child(explosion_instance)
	add_child(snow_instance)
	add_child(tires_debris_instance)
	add_child(trail_instance)
	add_child(sparks_instance)
	add_child(poof_instance)
	
	explosion_instance.hide()
	snow_instance.hide()
	tires_debris_instance.hide()
	trail_instance.hide()
	sparks_instance.hide()
	poof_instance.hide()

	print("preload & instancing complete!")
