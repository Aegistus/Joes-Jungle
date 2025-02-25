extends NavigationRegion3D

func _ready():
	GameManager.on_barricade_added.connect(add_obstacle)
	GameManager.on_barricade_destroyed.connect(rebake_navmesh)

func add_obstacle(added_obstacle : Node3D):
	added_obstacle.reparent(self)
	rebake_navmesh()

func rebake_navmesh():
	while is_baking():
		await bake_finished
	bake_navigation_mesh(true)
	print("REBAKING NAVMESH")
