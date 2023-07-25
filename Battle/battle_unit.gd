extends Marker2D

var battleUnitResource : chaomon
@onready var animationPlayer = $AnimationPlayer

func _ready():
	battleUnitResource.connect("hpChange", update)

func update():
	$Name.text = battleUnitResource.name
	$Sprite.texture = battleUnitResource.texture
	
	$hpBar.max_value = battleUnitResource.maxHp
	if battleUnitResource.currentHp != $hpBar.value:
		await animateHp()
#	$hpBar.value = battleUnitResource.currentHp
	$hpBar/Label.text = str(battleUnitResource.currentHp)
	
	$energyBar.max_value = battleUnitResource.maxEnergy
	$energyBar.value = battleUnitResource.currentEnergy
	$energyBar/Label.text = str(battleUnitResource.currentEnergy)

func animate(animation):
	match animation:
		"stop":
			animationPlayer.stop()
		"bounce":
			animationPlayer.play("Bounce")
		"damage":
			animationPlayer.play("Damage")
			await animationPlayer.animation_finished
			animationPlayer.play("RESET")


func animateHp():
	var tween = get_tree().create_tween()
	tween.tween_property($hpBar, "value", battleUnitResource.currentHp, 1).set_trans(Tween.TRANS_LINEAR)
