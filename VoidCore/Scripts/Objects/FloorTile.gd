extends WorldObject

const listofskins = [null, "res://Images/Floors/tile.png","res://Images/Floors/cobbletile.png",
					"res://Images/Floors/dirttile.png", "res://Images/Floors/grasstile.png"]

func _ready():
	objecttypeid = 1

func setObject(newobjectid):
	objectid = newobjectid
	if(objectid < len(listofskins) and objectid > 0):
		get_node("Body/Sprite").texture = load(listofskins[objectid])


