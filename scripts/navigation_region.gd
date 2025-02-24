extends NavigationRegion3D

func _ready():
	GameManager.on_barricade_added.connect(add_obstacle)

func add_obstacle(added_obstacle : Node3D):
	added_obstacle.reparent(self)
	while is_baking():
		await bake_finished
	bake_navigation_mesh(true)
	print("REBAKING NAVMESH")
