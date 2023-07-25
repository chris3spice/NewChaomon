extends Control

signal actionSelected(actionResource)

#Preload move button
var moveButton = preload("res://Battle/move_button.tscn")
var itemButton = preload("res://Battle/item_button.tscn")
#
var battleUnit : chaomon
var itemList : Array[baseItem]

#Access to various things
@onready var mainMenu = $MenuBackground/MarginContainer/MainMenu
@onready var moves = $SecondaryBackground/MarginContainer/Moves
@onready var dialog = $SecondaryBackground/MarginContainer/Dialog
@onready var items = $SecondaryBackground/MarginContainer/Items

func setup():
	battleUnit.connect("energyChanged", updateMoves)
	for i in battleUnit.knownMoves:
		var newMove = moveButton.instantiate()
		newMove.moveResource = i
		newMove.update()
		moves.add_child(newMove)
	for i in itemList:
		var newItem = itemButton.instantiate()
		newItem.itemResource = i
		newItem.update()
		items.add_child(newItem)

func updateUI():
	for i in moves.get_children():
		i.connect("moveSelected", action)
	updateMoves()
	for i in items.get_children():
		i.connect("itemSelected", action)
		
func updateMoves():
	for i in moves.get_children():
		if battleUnit.currentEnergy < i.moveResource.moveCost:
			i.disabled = true
		else:
			i.disabled = false

func updateItems():
	pass
			

func action(actionResource, type):
	emit_signal("actionSelected", actionResource)

func showMoves():
	moves.visible = true
	
func hideMoves():
	moves.visible = false
	
func showItems():
	items.visible = true

func hideItems():
	items.visible = false
	
func hideAll():
	moves.visible = false
	items.visible = false

#MENU BUTTONS
func _on_fight_button_pressed():
	moves.visible = !moves.visible
	checkDialog()
	
func _on_item_button_pressed():
	items.visible = !items.visible
	checkDialog()

#MENU STUFF
func enableMenu():
	for i in mainMenu.get_children():
		i.disabled = false

func disableMenu():
	hideMoves()
	for i in mainMenu.get_children():
		i.disabled = true

#DIALOG STUFF
func checkDialog():
	if moves.visible or items.visible:
		dialog.visible = false
	else: 
		dialog.visible = true
		
func showDialog(text):
	hideAll()
	dialog.text = text
	dialog.visible = true
	
func hideDialog():
	dialog.visible = false



