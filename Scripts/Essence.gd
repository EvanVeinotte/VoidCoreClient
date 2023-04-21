extends WorldObject

onready var listofstacksprites = get_node("Body/Stack").get_children()
onready var mybody = get_node("Body")
var stackstate = 1
var settobeselectedonready = false
var stacktoupdate
onready var essenceobject = load("res://Scenes/Essence.tscn")
var lasthoveredover
var originstack

func setSouthCol(whattosetto):
	get_node("Body/StaticBody2D/southcol").disabled = false

func setNorthCol(whattosetto):
	get_node("Body/StaticBody2D/northcol").disabled = false

func setEastCol(whattosetto):
	get_node("Body/StaticBody2D/eastcol").disabled = false

func setWestCol(whattosetto):
	get_node("Body/StaticBody2D/westcol").disabled = false

func setCollidersBottom(settobottom):
	pass

func beSelected():
	if(stackstate == 1):
		get_node("Body/EssenceSprite").frame = 0
		myworld.themap[lastworldpos.z][lastworldpos.y][lastworldpos.x] = 0
		myworld.referencemap[lastworldpos.z][lastworldpos.y][lastworldpos.x] = 0
		myworld.objectPickedUp(self)
		selected = true
		MouseController.selectednode = self
	else:
		stackstate = stackstate - 1
		#have to keep the map updated with it's stackstate
		myworld.themap[worldpos.z][worldpos.y][worldpos.x] = Constants.encodeForMap(objecttypeid, objectid, stackstate)
		var newessenceobject = essenceobject.instance()
		newessenceobject.settobeselectedonready = true
		newessenceobject.stacktoupdate = self
		newessenceobject.originstack = self
		myworld.get_node("YSort/FloorYSort").add_child(newessenceobject)
		

func beDeselected():
	if(MouseController.thevoidcore.checkPointInside(get_node("Body/EssenceSprite").position + position)):
		MouseController.thevoidcore.get_node("Body/TheBall/Highlighter").scale = Vector2(1,1)
		MouseController.thevoidcore.updateEssence(MouseController.thevoidcore.howmuchessence + 1)
		self.queue_free()
	
	else:
	
		if(!canplace and originstack):
			originstack.setStackState(originstack.stackstate + 1)
			self.queue_free()
		if(!lasthoveredover):
			get_node("Body/EssenceSprite").frame = 1
			get_node("Body").modulate = Color(1,1,1)
			selected = false
			myworld.newObjectPlaced(self, !canplace)
			originstack = null
			
		else:
			lasthoveredover.setStackState(lasthoveredover.stackstate + 1)
			self.queue_free()

func _ready():
	objecttypeid = 5
	isplaceableon = false
	canrotate = false
	
	setStackState(stackstate)
	
	if(settobeselectedonready):
		beSelected()

func setObject(objectid):
	pass

func setStackState(newstate):
	stackstate = newstate
	for i in range(Constants.COIN_STACK_LIMIT-1):
		listofstacksprites[i].visible = false
		listofstacksprites[i].modulate = Color(1,1,1)
	for i in range(stackstate - 1):
		listofstacksprites[i].visible = true
	var newpoly = get_node("Body/Area2D/CollisionPolygon2D").get_polygon()
	newpoly[1] = Vector2(newpoly[1].x, 109 - (stackstate-1) * Constants.COIN_LYING_HEIGHT)
	newpoly[2] = Vector2(newpoly[2].x, 109 - (stackstate-1) * Constants.COIN_LYING_HEIGHT)
	get_node("Body/Area2D/CollisionPolygon2D").polygon = newpoly

func canBeStackedMore():
	return !(stackstate >= Constants.COIN_STACK_LIMIT)

func hoveredOver():
	listofstacksprites[stackstate - 1].modulate = Color(0,1,0)
	listofstacksprites[stackstate - 1].visible = true

func unhover():
	listofstacksprites[stackstate - 1].modulate = Color(1,1,1)
	listofstacksprites[stackstate - 1].visible = false

func _process(_delta):
	if(selected):
		
		if(MouseController.thevoidcore.checkPointInside(get_node("Body/EssenceSprite").position + position)):
			MouseController.thevoidcore.get_node("Body/TheBall/Highlighter").scale = Vector2(1.25,1.25)
			mybody.z_index = 999
		else:
			MouseController.thevoidcore.get_node("Body/TheBall/Highlighter").scale = Vector2(1,1)
			mybody.z_index = 0
		
		if(stacktoupdate):
			stacktoupdate.setStackState(stacktoupdate.stackstate)
			stacktoupdate = null
		
		var vectoritshouldbe = Vector2(Constants.WIDTH_IT_SHOULD_BE, Constants.HEIGHT_IT_SHOULD_BE)
		var newworldpos = Constants.globalPosToWorld(((get_viewport().get_mouse_position() - vectoritshouldbe/2) * camera.zoom) + vectoritshouldbe/2 + camera.position - vectoritshouldbe * 0.5)
		var zstacklevel = myworld.getZStackLevel(newworldpos)
		if(zstacklevel == -1):
			worldpos = Vector3(newworldpos.x, newworldpos.y, Constants.MAP_SIZE.z)
			get_node("Body").modulate = Color(1,0,0)

		else:
			worldpos = Vector3(newworldpos.x, newworldpos.y, zstacklevel)
			get_node("Body").modulate = Color(1,1,1)
		
		if(newworldpos.x < 0 or newworldpos.y < 0 or newworldpos.x > Constants.MAP_SIZE.x or newworldpos.y > Constants.MAP_SIZE.y):
			get_node("Body").modulate = Color(1,0,0)
		
		calculateposition(worldpos)
		var objectunder = getObjectUnder()
		#means its a coinstack
		if(objectunder and objectunder.objecttypeid == objecttypeid):
			if(objectunder.canBeStackedMore()):
				self.visible = false
				if(lasthoveredover and lasthoveredover != objectunder):
					lasthoveredover.unhover()
				lasthoveredover = objectunder
				objectunder.hoveredOver()
				canplace = true
			else:
				self.visible = true
				if(lasthoveredover):
					lasthoveredover.unhover()
				lasthoveredover = null
				canplace = false
		else:
			self.visible = true
			if(lasthoveredover):
				lasthoveredover.unhover()
			lasthoveredover = null
