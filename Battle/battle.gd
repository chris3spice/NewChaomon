extends CanvasLayer


#Background
@export var battleBackground : Texture
#Testing Variables
@export var playerChaomon : chaomon
@export var playerItems : Array[baseItem]
@export var opponentChaomon : chaomon
@export var opponentItems : Array[baseItem]

#Preload battle unit
var battleUnit = preload("res://Battle/battle_unit.tscn")

#Positions
@onready var player_unit = $PlayerUnit
@onready var opponent_unit = $OpponentUnit
@onready var dialog = $BattleUI/SecondaryBackground/MarginContainer/Dialog

func _ready():
	setupBattle()
	
func setupBattle():
	$background.texture = battleBackground
	setupPlayer()
	setupOpponent()
	#Connect to UI
	$BattleUI.setup()
	$BattleUI.updateUI()
	$BattleUI.disableMenu()
	$BattleUI.connect("actionSelected", chooseAction)
	$BattleUI.showDialog("A wild Chaomon appeared")
	await get_tree().create_timer(1.5).timeout
	getSelection()
	
func setupPlayer():
	var new_unit = battleUnit.instantiate()
	new_unit.battleUnitResource = playerChaomon
	new_unit.update()
	player_unit.add_child(new_unit)
	#Setup moves
	$BattleUI.battleUnit = playerChaomon
	$BattleUI.itemList = playerItems

func setupOpponent():
	var new_unit = battleUnit.instantiate()
	new_unit.battleUnitResource = opponentChaomon
	new_unit.update()
	opponent_unit.add_child(new_unit)

func getSelection():
	$BattleUI.showDialog("Choose an action")
	#Animate chaomon bouncing
	$PlayerUnit/battleUnit.animate("bounce")
	$BattleUI.enableMenu()
	
func chooseAction(actionResource):
	#Stop animating chaomon
	$PlayerUnit/battleUnit.animate("stop")
	#Type is for future use when adding items and swap
	var playerActionResource = actionResource
	#Player Action
	#Enemy Choose Action (Only attack right now)
	var opponentActionResource = opponentChaomon.knownMoves[randi() % opponentChaomon.knownMoves.size()]
	
	#See who goes first 
	if playerChaomon.speed == opponentChaomon.speed:
		#If tie flip coin to see who goes first
		var rng = RandomNumberGenerator.new()
		var flip = rng.randi_range(1, 100)
		if flip > 50:
			turnQueue(true, playerActionResource, opponentActionResource)
		else:
			turnQueue(false, playerActionResource, opponentActionResource)
	#Player is faster
	elif playerChaomon.speed > opponentChaomon.speed:
		turnQueue(true, playerActionResource, opponentActionResource)
	#Opponent is faster
	else:
		turnQueue(false, playerActionResource, opponentActionResource)

func turnQueue(player, playerActionResource, opponentActionResource):
	if player:
		await playerAction(playerActionResource)
		#Check faint
		if opponentChaomon.currentHp <= 0:
			win()
		else:
			await opponentAction(opponentActionResource)
	else:
		await opponentAction(opponentActionResource)
		#Check faint
		if playerChaomon.currentHp <= 0:
			lose()
		else:
			await playerAction(playerActionResource)
	#Update stuff
	$BattleUI.updateMoves()
	$BattleUI.updateItems()
	#For burn/poison
	await RunAfterTurn()
	#Get selection
	getSelection()

func playerAction(act):
	$BattleUI.showDialog("Player uses " + act.name)
	var num = act.battleUsage
	# 1 - MoveDamage, 2 - MoveRestore, 3 - ItemHpRestore, 4 - ItemEnergyRestore
	match num:
		1: #MoveDamage
			#Remove energy
			playerChaomon.loseEnergy(act.moveCost)
			#Calculate damage
			var dmg = calcDamage(playerChaomon.attack, opponentChaomon.defense, act.power)
			round(dmg)
			#Deal damage
			opponentChaomon.takeDamage(dmg)
			$OpponentUnit/battleUnit.animate("damage")
		2: #MoveRestore
			print("MoveRestore")
		3: #ItemHpRestore
			print("ItemHpRestore")
			playerChaomon.heal(act.restoreAmount)
		4: #ItemEnergyRestore
			print("ItemEnergyRestore")
	await get_tree().create_timer(1.2).timeout
	
func opponentAction(act):
	$BattleUI.showDialog("Opponent uses " + act.name)
	var num = act.battleUsage
	# 1 - MoveDamage, 2 - MoveRestore, 3 - ItemHpRestore, 4 - ItemEnergyRestore
	match num:
		1:
			#Remove energy
			opponentChaomon.loseEnergy(act.moveCost)
			#Calculate damage
			var dmg = calcDamage(opponentChaomon.attack, playerChaomon.defense, act.power)
			round(dmg)
			#Deal damage
			playerChaomon.takeDamage(dmg)
			$PlayerUnit/battleUnit.animate("damage")
		2:
			print("MoveRestore")
		3:
			print("ItemHpRestore")
		4:
			print("ItemEnergyRestore")
	await get_tree().create_timer(1.2).timeout
	
#Damage Calculation
func calcDamage(attack, defense, power):
	#Generate random number
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(85, 100)
	random = random/100
	#Calculate the damage
	var damage = ((attack/defense)*0.5*power)+(1*random)
	#See if crits
	if random == 100:
		damage = damage*1.8
	#Return the damage amount
	return damage
	
#Going to use for status effects like burn/poison
func RunAfterTurn():
	pass

func calculateExperience():
	var exp = opponentChaomon.maxHp/7
	return exp

func win():
	$BattleUI.showDialog("You win!")
	$BattleUI.disableMenu()
	var expGain = calculateExperience()
	await get_tree().create_timer(1.2).timeout
	playerChaomon.gainExperience(expGain)

func lose():
	$BattleUI.showDialog("You lose!")
	$BattleUI.disableMenu()
