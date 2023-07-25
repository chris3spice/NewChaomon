extends baseChaomon
class_name chaomon

signal hpChange
signal energyChange

@export var originalOwner : int #original trainer who caught it
@export var owner : int #current trainer

@export var level : int
#Current Variables
@export var maxHp : int
@export var currentHp : int
@export var maxEnergy : int
@export var currentEnergy : int
		
@export var attack : int
@export var defense : int
@export var speed : int
#Experience Varialbes
var totalExperience : int = 100
var currentExperience : int = 100
var experienceRequired : int = get_required_experience(level + 1)

@export var knownMoves : Array[move]

func setStat(x, y):
	var rng = RandomNumberGenerator.new()
	var stat = rng.randi_range(x, y)
	return stat
	
func loseEnergy(amount):
	currentEnergy -= amount
	emit_signal("energyChange")

func takeDamage(amount):
	print("Take " + str(amount) + " damage")
	currentHp -= amount
	#Make sure can't go below zero
	if currentHp <= 0:
		currentHp = 0
		
	emit_signal("hpChange")

#HEALING ITEM USED
func heal(amount):
	currentHp += amount
	#Make sure can't go over the max health
	if currentHp > maxHp:
		currentHp = maxHp
	emit_signal("hpChange")

# EXPERIENCE STUFF
func gainExperience(amount):
	totalExperience += amount
	while currentExperience >= experienceRequired:
		currentExperience -= experienceRequired
		levelUp()

	print(str(amount) + " experience points earned")

#Calculate experience required to level up
func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)

func levelUp():
	print("Level up")
	level += 1
	experienceRequired = get_required_experience(level + 1)
	#Increase the stats
	maxHp += setStat(1,2)
	maxEnergy += setStat(1,2)
	attack += setStat(1,2)
	defense += setStat(1,2)
	speed += setStat(1,2)
	#Set currentHp and currentEnergy to the new max
	currentHp = maxHp
	currentEnergy = maxEnergy


#INTIALIZE FOR RANDOM BATTLE
func initializeChaomon():
	maxHp = setStat(35, 135)
	maxEnergy = setStat(35, 135)
	attack = setStat(25, 135)
	defense = setStat(25, 135)
	speed = setStat(25, 135)
