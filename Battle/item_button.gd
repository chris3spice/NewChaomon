extends Panel

signal itemSelected

var isMouseOver = false

@export var itemResource : baseItem


func update():
	$Image.texture = itemResource.texture


func _on_mouse_entered():
	isMouseOver = true

func _on_mouse_exited():
	isMouseOver = false


func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and isMouseOver:
		emit_signal("itemSelected", itemResource, "item")
