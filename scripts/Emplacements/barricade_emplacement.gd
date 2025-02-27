class_name BarricadeEmplacement
extends Emplacement

signal on_destroy

@export var max_health := 100.0

@onready var actor_collision_shape = $ActorCollision/ActorCollisionShape
@onready var hurtbox = $Hurtbox
@onready var animation_player = %AnimationPlayer
@onready var emplacement_seller = $EmplacementSeller
@onready var healthy_model = %HealthyModel
@onready var slightly_damaged_model = $SlightlyDamagedModel
@onready var badly_damaged_model = $BadlyDamagedModel

var current_health

func _ready():
	super()
	animation_player.play("default")
	emplacement_seller.on_sell.connect(sell)

func place():
	animation_player.play("place")
	current_health = max_health
	hurtbox.monitoring = true
	hurtbox.monitorable = true
	# models
	healthy_model.visible = true
	slightly_damaged_model.visible = false
	badly_damaged_model.visible = false
	actor_collision_shape.disabled = false
	GameManager.on_barricade_added.emit(self)

func damage(amount):
	current_health -= amount
	if current_health < max_health / 2 and current_health > max_health / 4:
		healthy_model.visible = false
		slightly_damaged_model.visible = true
		badly_damaged_model.visible = false
	if current_health < max_health / 4:
		healthy_model.visible = false
		slightly_damaged_model.visible = false
		badly_damaged_model.visible = true
	if current_health <= 0:
		destroy()

func destroy():
	hurtbox.monitoring = false
	hurtbox.set_deferred("monitorable", false)
	actor_collision_shape.disabled = true
	healthy_model.visible = false
	slightly_damaged_model.visible = false
	badly_damaged_model.visible = false
	on_destroy.emit()
	GameManager.on_barricade_destroyed.emit()

func sell():
	on_destroy.emit()
	GameManager.on_barricade_destroyed.emit()
	super()
