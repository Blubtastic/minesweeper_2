extends Node
class_name TimerHelper


static func toggle_for_duration(node: Node, property: String, duration: float) -> void:
	if not property in node:
		return
	node.set(property, not node.get(property))
	await node.get_tree().create_timer(duration).timeout
	node.set(property, not node.get(property))

static func true_for_duration(node: Node, property: String, duration: float) -> void:
	if not property in node:
		return
	node.set(property, true)
	await node.get_tree().create_timer(duration).timeout
	node.set(property, false)
