settings = {
	MAP_SIZE = 15,
	ISO_RATIO = 1,
	camera = {
		x = 0,
		y = 0
	},
	CAMERA_SPEED = 50
}

Tile = {}
function Tile:new(t)
end

function createMap()
	map = {}
	for i=1,settings.MAP_SIZE do
		map[i] = {}
		for j=1,settings.MAP_SIZE do
			map[i][j] = Tile:new()
		end
	end
end

function love.load()
	gfx = {	
		tiles = {
			grass = love.graphics.newImage('resources/gfx/grass.png')
		}
	}
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
		camera.y = camera.y - settings.CAMERA_SPEED * dt
	elseif my > 9 * love.graphics.getWidth() / 10 then
		camera.y = camera.y + settings.CAMERA_SPEED * dt
	end
end

function iso2screen(i, j)
	return {
		x = settings.ISO_ORIGIN.x + (i + j + 2) * settings.ISOTILE_WIDTH / 2,
		y = settings.ISO_ORIGIN.y + j * settings.ISOTILE_HEIGHT / 2 - i * settings.ISOTILE_HEIGHT / 2
	}
end

function love.draw()
	for i=1,settings.MAP_SIZE do
		for j=1,settings.MAP_SIZE do
			local draw_origin = iso2screen(i, j)
			local tile = map[i][j]
			love.graphics.draw(tile.gfx, draw_origin.x + camera.x, draw_origin.y + camera.y)
		end
	end
end

