extends Control
@onready var PlayerNode = load("res://Scripts/Player.gd")
static var SelectedAbility = 1
@onready var rect_ability_1 = $AbilityAid/SelectedAbility/RectAbility1
@onready var rect_ability_2 = $AbilityAid/SelectedAbility/RectAbility2
@onready var rect_ability_3 = $AbilityAid/SelectedAbility/RectAbility3


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_ability_1.visible = false
	rect_ability_2.visible = false
	rect_ability_3.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	SelectedAbility = PlayerNode.GetSelectedAbility()
	if SelectedAbility != null:
		if SelectedAbility == 1:
			rect_ability_1.visible = true
			rect_ability_2.visible = false
			rect_ability_3.visible = false
		if SelectedAbility == 2:
			rect_ability_1.visible = false
			rect_ability_2.visible = true
			rect_ability_3.visible = false
		if SelectedAbility == 3:
			rect_ability_1.visible = false
			rect_ability_2.visible = false
			rect_ability_3.visible = true
