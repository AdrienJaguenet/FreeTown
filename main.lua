settings = {
	MAP_SIZE = 15,
	CAMERA_SPEED = 50,
	ISOTILE_HEIGHT = 20,
	ISOTILE_WIDTH = 32,
}
camera = {
	x = 0,
	y = 0
}

Tile = { id = 'Tile' }
Tile.__index = Tile

function Tile:new(t)
	local this = {
		gfx = gfx.tiles[t]
	}
	setmetatable(this, Tile)
	return this
end

function createMap()
	map = {}
	for i=1,settings.MAP_SIZE do
		map[i] = {}
		for j=1,settings.MAP_SIZE do
			map[i][j] = Tile:new('grass')
		end
	end
end

function love.load()
	gfx = {	
		tiles = {
			tile_select = {
				image = love.graphics.newImage('resources/gfx/tile-select.png'),
				extra_height = 0
			},
			grass = {
				image = love.graphics.newImage('resources/gfx/grass.png'),
				extra_height = 38
			},
			road = {
				image = love.graphics.newImage('resources/gfx/road-horizontal.png'),
				extra_height = 38
			}
		}
	}
	createMap()
end

function love.update(dt)
	-- handle camera movement
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
	if mx < love.graphics.getWidth() / 10 then
		camera.x = camera.x + settings.CAMERA_SPEED * dt
	elseif mx > 9 * love.graphics.getWidth() / 10 then
		camera.x = camera.x - settings.CAMERA_SPEED * dt
	end

	if my < love.graphics.getHeight() / 10 then
		camera.y = camera.y + settings.CAMERA_SPEED * dt
	elseif my > 9 * love.graphics.getHeight() / 10 then
		camera.y = camera.y - settings.CAMERA_SPEED * dt
	end
end

function iso2screen(i, j)
	return {
		x = (i + j + 2) * settings.ISOTILE_WIDTH / 2 + 1,
		y = - settings.ISOTILE_HEIGHT/2 + j * settings.ISOTILE_HEIGHT / 2 - i * settings.ISOTILE_HEIGHT / 2 + 1
	}
end

function screen2iso(cx, cy)
	cx = cx - camera.x
	cy = cy - camera.y
	local x0 = settings.ISOTILE_HEIGHT / 2 + cx * (settings.ISOTILE_HEIGHT / settings.ISOTILE_WIDTH)
	local y0 = settings.ISOTILE_HEIGHT / 2 - cx * (settings.ISOTILE_HEIGHT / settings.ISOTILE_WIDTH)

	return {
		x = (x0 - cy) / settings.ISOTILE_HEIGHT - 1,
		y = (cy - y0) / settings.ISOTILE_HEIGHT - 1
	}
end

function drawIsoTile(i, j, tile)
	local draw_origin = iso2screen(i, j)
	draw_origin.y = draw_origin.y - tile.gfx.extra_height
	love.graphics.draw(tile.gfx.image, draw_origin.x + camera.x, draw_origin.y + camera.y)
end

function love.draw()

	-- draw the upper half
	for i=1,settings.MAP_SIZE do
		for j=1,i do
			local x = settings.MAP_SIZE - i + j
			local y = j
			local tile = map[x][y]
			drawIsoTile(x, y, tile)
		end
	end
	-- draw the lower half 
	for i=settings.MAP_SIZE,1,-1 do
		for j=1,i do
			local x = j
			local y = settings.MAP_SIZE - i + j
			local tile = map[x][y]
			drawIsoTile(x, y, tile)
		end
	end

	-- draw the hover
	local hover_coords = screen2iso(love.mouse.getX(), love.mouse.getY())
	hover_coords.y = math.floor(hover_coords.y)
	hover_coords.x = math.floor(hover_coords.x)
	drawIsoTile(hover_coords.x, hover_coords.y, {gfx = gfx.tiles.tile_select})
end

function love.mousepressed(x, y, k)
	local iso = screen2iso(x, y)
	iso.x = math.floor(iso.x)
	iso.y = math.floor(iso.y)
	if iso.x > 0 and iso.x < settings.MAP_SIZE and iso.y > 0 and iso.y < settings.MAP_SIZE then
		map[iso.x][iso.y].gfx = gfx.tiles.road
	end
end

