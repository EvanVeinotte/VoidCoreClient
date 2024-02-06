extends WorldObject

@onready var listofstacksprites = get_node("Body/Stack").get_children()
@onready var mybody = get_node("Body")
var stackstate = 1
var settobeselectedonready = false
var stacktoupdate
@export var mycointype:int
var lasthoveredover
var originstack

func encodeSelf():
	myobjstate = stackstate
	return Utils.encodeObjectData(self)

func setObject(myid, mystate, myrot, worldpos, newspawnindata=null):
	myobjid = myid
	myobjstate = mystate
	stackstate = mystate
	myobjrot = myrot
	spawnindata = newspawnindata
	updatePosition(worldpos)

func beSelected():
	var chunkdata = WorldCalculations.worldPosToChunkPos(lastworldpos)
	if(stackstate == 1):
		playPickupSound()
		get_node("Body/EssenceSprite").frame = 0
		theworld.setValueToMap(chunkdata.chunkx, chunkdata.chunky, chunkdata.z, chunkdata.y, chunkdata.x, 0)
		theworld.setValueToReferenceMap(chunkdata.chunkx, chunkdata.chunky, chunkdata.z, chunkdata.y, chunkdata.x, 0)
		theworld.objectPickedUp(self)
		selected = true
		MouseController.selectednode = self
	else:
		stackstate = stackstate - 1
		#have to keep the map updated with it's stackstate
		myobjstate = stackstate
		theworld.setValueToMap(chunkdata.chunkx, chunkdata.chunky, chunkdata.z, chunkdata.y, chunkdata.x, encodeSelf())
		var newessenceobject = ObjectLoader.objectbyid[mycointype].instantiate()
		newessenceobject.settobeselectedonready = true
		newessenceobject.stacktoupdate = self
		newessenceobject.originstack = self
		newessenceobject.setObject(10, 1, false, myworldpos)
		newessenceobject.theworld = theworld
		theworld.chunkloader.add_child(newessenceobject)
		

func beDeselected():
	
	if(MouseController.thevoidcore.checkPointInside(get_node("Body/EssenceSprite").position + position)):
		MouseController.thevoidcore.get_node("Body/TheBall/Highlighter").scale = Vector2(1,1)
		MouseController.thevoidcore.updateEssence(MouseController.thevoidcore.howmuchessence + 1)
		self.queue_free()
	
	else:
		playPlaceSound()
		if(!canplace and originstack):
			originstack.setStackState(originstack.stackstate + 1)
			self.queue_free()
		if(!lasthoveredover):
			get_node("Body/EssenceSprite").frame = 1
			get_node("Body").modulate = Color(1,1,1)
			selected = false
			theworld.newObjectPlaced(self, !canplace)
			originstack = null
		else:
			lasthoveredover.setStackState(lasthoveredover.stackstate + 1)
			self.queue_free()

func playPlaceSound():
	SoundHandler.playSFX("Coinclink")

func playPickupSound():
	SoundHandler.playSFX("Coinclink")

func _ready():
	isplaceableon = false
	canrotate = false
	coinlike = true
	super()
	setStackState(stackstate)
	
	if(settobeselectedonready):
		beSelected()

func setStackState(newstate):
	var chunkdata = WorldCalculations.worldPosToChunkPos(myworldpos)
	stackstate = newstate
	for i in range(Globs.COIN_STACK_LIMIT-1):
		listofstacksprites[i].visible = false
		listofstacksprites[i].modulate = Color(1,1,1)
	for i in range(stackstate - 1):
		listofstacksprites[i].visible = true
	var newpoly = get_node("Body/Area2D/CollisionPolygon2D").get_polygon()
	newpoly[1] = Vector2(newpoly[1].x, 109 - (stackstate-1) * Globs.COIN_LYING_HEIGHT)
	newpoly[2] = Vector2(newpoly[2].x, 109 - (stackstate-1) * Globs.COIN_LYING_HEIGHT)
	get_node("Body/Area2D/CollisionPolygon2D").polygon = newpoly
	myobjstate = stackstate
	theworld.setValueToMap(chunkdata.chunkx, chunkdata.chunky, chunkdata.z, chunkdata.y, chunkdata.x, encodeSelf())
	FileHandler.saveWorldToFile(theworld, Globs.currentworldfileaddress)

func canBeStackedMore():
	return !(stackstate >= Globs.COIN_STACK_LIMIT)

func hoveredOver():
	listofstacksprites[stackstate - 1].modulate = Color(0,1,0)
	listofstacksprites[stackstate - 1].visible = true

func unhover():
	listofstacksprites[stackstate - 1].modulate = Color(1,1,1)
	listofstacksprites[stackstate - 1].visible = false

func _process(_delta):
	if(selected):
		
		if(MouseController.thevoidcore.checkPointInside(get_node("Body/EssenceSprite").position + position)):
			MouseController.thevoidcore.get_node("Body/TheBall/Hungry").scale = Vector2(1.25,1.25)
			mybody.z_index = 999
		else:
			MouseController.thevoidcore.get_node("Body/TheBall/Hungry").scale = Vector2(1,1)
			mybody.z_index = 0
		
		if(stacktoupdate):
			stacktoupdate.setStackState(stacktoupdate.stackstate)
			stacktoupdate = null
		
		var vectoritshouldbe = Vector2(Globs.WIDTH_IT_SHOULD_BE, Globs.HEIGHT_IT_SHOULD_BE)
		var newworldpos = WorldCalculations.globalPosToWorldPos(((get_viewport().get_mouse_position() - vectoritshouldbe/2) / camera.zoom) + vectoritshouldbe/2 + camera.position - vectoritshouldbe * 0.5, true)
		var zstacklevel = theworld.getZStackLevel(newworldpos)
		if(zstacklevel == -1):
			myworldpos = Vector3(newworldpos.x, newworldpos.y, Globs.MAP_SIZE.z)
			get_node("Body").modulate = Color(1,0,0)

		else:
			myworldpos = Vector3(newworldpos.x, newworldpos.y, zstacklevel)
			get_node("Body").modulate = Color(1,1,1)
		
		if(myworldpos == player.worldpos):
			canplace = false
		
		#if(newworldpos.x < 0 or newworldpos.y < 0 or newworldpos.x > Globs.MAP_SIZE.x or newworldpos.y > Globs.MAP_SIZE.y):
			#get_node("Body").modulate = Color(1,0,0)
		
		updatePosition(myworldpos)
		var objectunder = getObjectUnder()
		if(objectunder):
			#means it is same coin stack type
			if(objectunder.myobjid == myobjid):
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
				if(!objectunder.isplaceableon):
					canplace = false
					get_node("Body").modulate = Color(1,0,0)
				else:
					canplace = true
					get_node("Body").modulate = Color(1,1,1)
				if(lasthoveredover):
					lasthoveredover.unhover()
					lasthoveredover = null
		else:
			if(zstacklevel >= 0):
				if(lasthoveredover):
					self.visible = true
					lasthoveredover.unhover()
					lasthoveredover = null
		if(zstacklevel == -1):
			canplace = false
