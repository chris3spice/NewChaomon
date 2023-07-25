extends Button

signal moveSelected

@export var moveResource : move

func _on_pressed():
	emit_signal("moveSelected", moveResource, "move")

func update():
	text = moveResource.name + "\n" + str(moveResource.moveCost)
