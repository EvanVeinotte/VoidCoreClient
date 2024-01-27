extends Node

func globalPosToWorldPos(globpos):
	#this was here to offset it by half a tile so that mouse
	#would be in the middle of the object while grabbing
	#do that before inputting
	#globpos = Vector2(globpos.x - TILE_WIDTH/2, globpos.y)
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
	var x = worldpos.x - floor(worldpos.x / Globs.CHUNK_SIZE)
	var y = worldpos.y - floor(worldpos.y / Globs.CHUNK_SIZE)
	var z = worldpos.z
	return {"chunkx": chunkx, "chunky": chunky, "x": x, "y": y, "z": z}
