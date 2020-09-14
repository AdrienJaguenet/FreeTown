function loadTiles()
	return {
		tile_select = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/tile-select.png'),
					extra_height = 0
				}
			},
		},
		water = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/water.png'),
					extra_height = 38
				}
			}
		},
		grass = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/grass_background.png'),
					extra_height = 38
				},
				{
					image = love.graphics.newImage('resources/gfx/grass_foreground.png'),
					extra_height = 38
				},
			},
		},
		road = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/grass_background.png'),
					extra_height = 38
				},
				{
					image = love.graphics.newImage('resources/gfx/road_horizontal.png'),
					extra_height = 38
				},
			},
		},
		trees = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/grass_background.png'),
					extra_height = 38
				},
				{
					image = love.graphics.newImage('resources/gfx/trees.png'),
					extra_height = 38
				},
			},
		},
		chimney = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/concrete_background.png'),
					extra_height = 38
				},
				{
					image = love.graphics.newImage('resources/gfx/chimney.png'),
					extra_height = 38
				},
			},
		},
		house = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/concrete_background.png'),
					extra_height = 38
				},
				{
					image = love.graphics.newImage('resources/gfx/house.png'),
					extra_height = 38
				},
			},
		},
		farm = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/concrete_background.png'),
					extra_height = 38
				},
				{
					image = love.graphics.newImage('resources/gfx/farm.png'),
					extra_height = 38
				},
			},
		},
		field = {
			layers = {
				{
					image = love.graphics.newImage('resources/gfx/field_background.png'),
					extra_height = 38
				},
				{
					image = love.graphics.newImage('resources/gfx/field_wheat.png'),
					extra_height = 38
				},
			},
		}
	}
end

Tile = { id = 'Tile' }
Tile.__index = Tile

function Tile:new(t)
	local this = {
		type = t,
		workers = 0
	}
	setmetatable(this, Tile)
	return this
end

function Tile:getSprite(layer)
	return gfx.tiles[self.type].layers[layer]
end

