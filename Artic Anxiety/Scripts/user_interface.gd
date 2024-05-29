extends Control
#@onready var PlayerNode = load("res://Scripts/Player.gd")
static var SelectedAbility = 1
@onready var rect_ability_1 = $AbilityAid/SelectedAbility/RectAbility1
@onready var rect_ability_2 = $AbilityAid/SelectedAbility/RectAbility2
@onready var rect_ability_3 = $AbilityAid/SelectedAbility/RectAbility3
#all vars from the jezus "stamina" bar
#timer to track jezusability
var MaxtimeJezusAbility = 3.0
var timerJezusAbility = MaxtimeJezusAbility
# Timer to track the elapsed time
var JezusAbility_elapsed_time = 0.0
static var ActivatedJezus = false
@onready var jezus_ability_bar = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbility"

#All vars for the cooldown bar , 2 diffrent ones jezus cooldown is double the time of the normal one
#normal cooldown 3 sec
#jezus cooldown  6 sec
static var MaxNormalAbilityCooldown = 3.0
static var MaxAbilityCooldown = 6.0
static var timerAbilityCooldown = 0.0
var timerAbility_elapsed_time = 0.0
static var ActivatedAbility = false
@onready var cooldown_bar = $"Ability Cooldown/CooldownBar"


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_ability_1.visible = false
	rect_ability_2.visible = false
	rect_ability_3.visible = false
	AnAbilityGotActivated()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#JezusBar
	if ActivatedJezus:
		timerJezusAbility -= delta
		JezusAbility_elapsed_time += delta
		jezus_ability_bar.size.x = 65 * (1 - JezusAbility_elapsed_time / MaxtimeJezusAbility)
	if timerJezusAbility < 0:
		ActivatedJezus = false
		jezus_ability_bar.size.x = 65
		JezusAbility_elapsed_time = 0
		timerJezusAbility = MaxtimeJezusAbility
	#Ability Selector
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
	#Cooldown Bar
	if ActivatedAbility:
		timerAbilityCooldown -= delta
		timerAbility_elapsed_time += delta
		if ActivatedJezus:
			cooldown_bar.size.y = 1150 * (1 - timerAbility_elapsed_time / MaxAbilityCooldown)
		else:
			cooldown_bar.size.y = 1150 * (1 - timerAbility_elapsed_time / MaxNormalAbilityCooldown)
	if timerJezusAbility < 0:
		ActivatedAbility = false
		timerAbility_elapsed_time = 0
		cooldown_bar.size.x = 1150
		
		
		
static func SetAbility(nr: int):
	SelectedAbility = nr
static func SetActivatedJezusTrue():
	ActivatedJezus = true
static func AnAbilityGotActivated():
	ActivatedAbility = true
	#fixing timer
	timerAbilityCooldown = MaxNormalAbilityCooldown
	if ActivatedJezus:
		timerAbilityCooldown = MaxAbilityCooldown

func ChangeVisibilityJesusBar():
	
	var jezus_ability_grayed_out = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbilityGrayed out"
	var jezus_ability_border = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbilityBorder"
	var jezus_ability = $"AbilityAid/Ability 2/JesusAbilityBar/JezusAbility"
	var time_remaining_txt = $"AbilityAid/Ability 2/JesusAbilityBar/Time Remaining_"

	if(rect_ability_2.visible):
		jezus_ability_grayed_out.visible = true
		jezus_ability_border.visible = true
		jezus_ability.visible = true
		time_remaining_txt.visible = true
	else:
		jezus_ability_grayed_out.visible = false
		jezus_ability_border.visible = false
		jezus_ability.visible = false
		time_remaining_txt.visible = false
	


