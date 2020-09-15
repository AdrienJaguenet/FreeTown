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
					oriented = {
						['00'] = {
							image = love.graphics.newImage('resources/gfx/road_crossing.png'),
							extra_height = 38
						},
						['01'] = {
							image = love.graphics.newImage('resources/gfx/road_horizontal.png'),
							extra_height = 38
						},
						['10'] = {
							image = love.graphics.newImage('resources/gfx/road_vertical.png'),
							extra_height = 38
						}
					}
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
	}
	setmetatable(this, Tile)
	return this
end

function Tile:getSprite(layer)
	return gfx.tiles[self.type].layers[layer]
end

function Tile:draw(i, j, settings)
	local layer = settings.layer or #gfx.tiles[self.type].layers
	local color = settings.color or {1, 1, 1}
	local sprite = self:getSprite(layer)
	if not sprite then
		return
	end
	local draw_origin = iso2screen(i, j)
	draw_origin.y = draw_origin.y - sprite.extra_height
	local c1, c2, c3 = love.graphics.getColor()
	love.graphics.setColor(color[1], color[2], color[3])
	love.graphics.draw(sprite.image, (draw_origin.x + camera.x) * camera.zoom, (draw_origin.y + camera.y) * camera.zoom,
		0, camera.zoom, camera.zoom)
	love.graphics.setColor(c1, c2, c3)
end

