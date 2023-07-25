extends Resource
class_name baseChaomon

@export var chaomonID : int
@export var name : String
@export var description : String
@export var texture : Texture
@export var type1 : type
@export var type2 : type

enum type { NONE, PLAIN, WIND, FIRE, WATER, EARTH, METAL, WOOD }

@export var learnableMoves : Array[Array]
