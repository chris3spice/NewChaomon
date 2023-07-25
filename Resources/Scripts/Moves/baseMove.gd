extends battleUse
class_name baseMove

@export var name : String
@export_multiline var description : String
@export var accuracy : int
@export var moveType : type
@export var moveCost : int

enum type { NONE, PLAIN, WIND, FIRE, WATER, EARTH, METAL, WOOD }
