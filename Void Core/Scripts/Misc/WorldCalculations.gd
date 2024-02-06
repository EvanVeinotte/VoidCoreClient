extends Node

func globalPosToWorldPos(globpos, offsetbyhalftile=false):
	#this was here to offset it by half a tile so that mouse
	#would be in the middle of the object while grabbing
	#do that before inputting
	#^^^ this is old text but still explains it I guess
	#the player also uses this to check what world pos is
	if(offsetbyhalftile):
		globpos = Vector2(globpos.x - Globs.TILE_WIDTH/2.0, globpos.y)
	var worldxpos
	var worldypos
	worldxpos = (-globpos.x * Globs.WORLD_Y_OFFSET.y + Globs.WORLD_Y_OFFSET.x * globpos.y) / (Globs.WORLD_Y_OFFSET.x * Globs.WORLD_X_OFFSET.y - Globs.WORLD_Y_OFFSET.y * Globs.WORLD_X_OFFSET.x)
	worldypos = (-globpos.x * Globs.WORLD_X_OFFSET.y + Globs.WORLD_X_OFFSET.x * globpos.y) / (Globs.WORLD_X_OFFSET.x * Globs.WORLD_Y_OFFSET.y - Globs.WORLD_X_OFFSET.y * Globs.WORLD_Y_OFFSET.x)
	worldxpos = floor(worldxpos)
	worldypos = floor(worldypos)
	return Vector3(worldxpos, worldypos, 0)

func worldPosToChunkPos(worldpos):
	var chunkx = floor(worldpos.x / Globs.CHUNK_SIZE)
	var chunky = floor(worldpos.y / Globs.CHUNK_SIZE)
	var x = worldpos.x - floor(worldpos.x / Globs.CHUNK_SIZE) * Globs.CHUNK_SIZE
	if(chunkx < 0):
		x = Globs.CHUNK_SIZE - x
	var y = worldpos.y - floor(worldpos.y / Globs.CHUNK_SIZE) * Globs.CHUNK_SIZE
	if(chunky < 0):
		y = Globs.CHUNK_SIZE - y
	var z = worldpos.z
	return {"chunkx": str(chunkx), "chunky": str(chunky), "x": x, "y": y, "z": z}

func chunkPosToWorldPos(chunkx, chunky, x, y, z):
	x = x + int(chunkx) * Globs.CHUNK_SIZE
	y = y + int(chunky) * Globs.CHUNK_SIZE
	return Vector3(x,y,z)
