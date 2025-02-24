class_name BarricadeEmplacement
extends Emplacement

signal on_destroy

@export var max_health := 100.0

@onready var actor_collision_shape = $ActorCollision/ActorCollisionShape
@onready var hurtbox = $Hurtbox
@onready var animation_player = %AnimationPlayer
@onready var model = %Model
@onready var navigation_region = %NavigationRegion
@onready var emplacement_seller = $EmplacementSeller

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
	model.visible = true
	actor_collision_shape.disabled = false
	navigation_region.enabled = false
	GameManager.on_barricade_added.emit(self)

func damage(amount):
	current_health -= amount
	if current_health <= 0:
		destroy()

func destroy():
	hurtbox.monitoring = false
	hurtbox.set_deferred("monitorable", false)
	actor_collision_shape.disabled = true
	model.visible = false
	on_destroy.emit()
	navigation_region.enabled = true
	GameManager.on_barricade_destroyed.emit()

func sell():
	on_destroy.emit()
	navigation_region.enabled = false
	GameManager.on_barricade_destroyed.emit()
	super()
