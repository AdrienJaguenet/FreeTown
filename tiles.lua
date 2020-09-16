terrain_tilemap = love.graphics.newImage('resources/gfx/terrain.png')

function isoTile(tilemap, x, y)
	return {
		extra_height = 38,
		tilemap = tilemap,
		quad = love.graphics.newQuad((x-1) * 32, (y-1) * 64, 32, 64, tilemap:getDimensions())
	}
end

function loadTiles()
	return {
		tile_select = {
			layers = {
				isoTile(terrain_tilemap, 1, 1)
			},
		},
		concrete = {
			layers = {
				isoTile(terrain_tilemap, 1, 2)
			}
		},
		river = {
			layers = {
				{
					oriented = {
						['0000'] = isoTile(terrain_tilemap, 1, 4),
						['0001'] = isoTile(terrain_tilemap, 5, 4),
						['0010'] = isoTile(terrain_tilemap, 6, 4),
						['0011'] = isoTile(terrain_tilemap, 7, 4),
						['0100'] = isoTile(terrain_tilemap, 3, 4),
						['0101'] = isoTile(terrain_tilemap, 1, 4),
						['0110'] = isoTile(terrain_tilemap, 1, 4),
						['0111'] = isoTile(terrain_tilemap, 1, 4),
						['1000'] = isoTile(terrain_tilemap, 2, 4),
						['1001'] = isoTile(terrain_tilemap, 1, 4),
						['1010'] = isoTile(terrain_tilemap, 1, 4),
						['1011'] = isoTile(terrain_tilemap, 1, 4),
						['1100'] = isoTile(terrain_tilemap, 4, 4),
						['1101'] = isoTile(terrain_tilemap, 1, 4),
						['1110'] = isoTile(terrain_tilemap, 1, 4),
						['1111'] = isoTile(terrain_tilemap, 1, 4),
					}
				}
			}
		},
		grass = {
			layers = {
				isoTile(terrain_tilemap, 1, 2)
			},
		},
		road = {
			layers = {
				{
					oriented = {
						['0000'] = isoTile(terrain_tilemap, 1, 5),
						['0001'] = isoTile(terrain_tilemap, 1, 5),
						['0010'] = isoTile(terrain_tilemap, 1, 5),
						['0011'] = isoTile(terrain_tilemap, 2, 5),
						['0100'] = isoTile(terrain_tilemap, 1, 5),
						['0101'] = isoTile(terrain_tilemap, 1, 5),
						['0110'] = isoTile(terrain_tilemap, 1, 5),
						['0111'] = isoTile(terrain_tilemap, 1, 5),
						['1000'] = isoTile(terrain_tilemap, 1, 5),
						['1001'] = isoTile(terrain_tilemap, 1, 5),
						['1010'] = isoTile(terrain_tilemap, 1, 5),
						['1011'] = isoTile(terrain_tilemap, 1, 5),
						['1100'] = isoTile(terrain_tilemap, 3, 5),
						['1101'] = isoTile(terrain_tilemap, 1, 5),
						['1110'] = isoTile(terrain_tilemap, 1, 5),
						['1111'] = isoTile(terrain_tilemap, 1, 5),
					}
				},
			},
		},
		trees = {
			layers = {
				{
					variations = {
						isoTile(terrain_tilemap, 2, 2),
						isoTile(terrain_tilemap, 3, 2),
						isoTile(terrain_tilemap, 4, 2),
						isoTile(terrain_tilemap, 5, 2),
					}
				},
			},
		},
		chimney = {
			layers = {
				isoTile(terrain_tilemap, 3, 3),
			},
		},
		house = {
			layers = {
				isoTile(terrain_tilemap, 2, 3),
			},
		},
	}
end

Tile = { id = 'Tile' }
Tile.__index = Tile

function Tile:new(t)
	local this = {
		type = t,
		variation = math.random(100)
	}
	setmetatable(this, Tile)
	return this
end

function Tile:getSprite(i, j, layer)
	local obj = gfx.tiles[self.type].layers[layer]
	if obj and obj.oriented then
		local north, south, west, east = map:GetMooreNeighbourhood(i, j)

		local str = ''
		if (north and north.type == self.type) then
			str = str..'1'
		else
			str = str..'0'
		end

		if (south and south.type == self.type) then
			str = str..'1'
		else
			str = str..'0'
		end

		if (west and west.type == self.type) then
			str = str..'1'
		else
			str = str..'0'
		end

		if (east and east.type == self.type) then
			str = str..'1'
		else
			str = str..'0'
		end
		return obj.oriented[str]
	elseif obj and obj.variations then
		return obj.variations[math.floor(self.variation % #obj.variations) + 1]
	else
		return obj
	end
end

function Tile:draw(i, j, settings)
	local layer = settings.layer or #gfx.tiles[self.type].layers
	local color = settings.color or {1, 1, 1}
	local sprite = self:getSprite(i, j, layer)
	if not sprite then
		return
	end
	local draw_origin = iso2screen(i, j)
	draw_origin.y = draw_origin.y - sprite.extra_height
	local c1, c2, c3 = love.graphics.getColor()
	love.graphics.setColor(color[1], color[2], color[3])
	love.graphics.draw(sprite.tilemap, sprite.quad, (draw_origin.x + camera.x + camera.offset.x) * camera.zoom, (draw_origin.y + camera.y + camera.offset.y) * camera.zoom,
		0, camera.zoom, camera.zoom)
	love.graphics.setColor(c1, c2, c3)
end

