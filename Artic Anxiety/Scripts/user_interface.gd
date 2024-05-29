extends Control
#@onready var PlayerNode = load("res://Scripts/Player.gd")
static var SelectedAbility = 1
@onready var rect_ability_1 = $AbilityAid/SelectedAbility/RectAbility1
@onready var rect_ability_2 = $AbilityAid/SelectedAbility/RectAbility2
@onready var rect_ability_3 = $AbilityAid/SelectedAbility/RectAbility3
#timer to track jezusability
var MaxtimeJezusAbility = 3.0
var timerJezusAbility = MaxtimeJezusAbility
# Timer to track the elapsed time
var JezusAbility_elapsed_time = 0.0
static var ActivatedJezus = false
@onready var jezus_ability_bar = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbility"

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_ability_1.visible = false
	rect_ability_2.visible = false
	rect_ability_3.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ActivatedJezus:
		timerJezusAbility -= delta
		JezusAbility_elapsed_time += delta
		jezus_ability_bar.size.x = 65 * (1 - JezusAbility_elapsed_time / MaxtimeJezusAbility)
		print(timerJezusAbility)
		
	if timerJezusAbility < 0:
		ActivatedJezus = false
		jezus_ability_bar.size.x = 65
		JezusAbility_elapsed_time = 0
		timerJezusAbility = MaxtimeJezusAbility
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
	ChangeVisibilityJesusBar()
static func SetAbility(nr: int):
	SelectedAbility = nr
static func SetActivatedJezusTrue():
	ActivatedJezus = true
func ChangeVisibilityJesusBar():
	
	var jezus_ability_grayed_out = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbilityGrayed out"
	var jezus_ability_border = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbilityBorder"
	var jezus_ability = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbility"
	if(rect_ability_2.visible):
		jezus_ability_grayed_out.visible = true
		jezus_ability_border.visible = true
		jezus_ability.visible = true
	else:
		jezus_ability_grayed_out.visible = false
		jezus_ability_border.visible = false
		jezus_ability.visible = false
	


