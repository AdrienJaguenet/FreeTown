settings = {
	MAP_SIZE = 15,
	CAMERA_SPEED = 50,
	ISOTILE_HEIGHT = 20,
	ISOTILE_WIDTH = 32,
}
camera = {
	x = 0,
	y = 0,
	zoom = 2
}

current_tool = 'road'

Tile = { id = 'Tile' }
Tile.__index = Tile

function Tile:new(t)
	local this = {
		type = t
	}
	setmetatable(this, Tile)
	return this
end

function createMap()
	map = {}
	for i=1,settings.MAP_SIZE do
		map[i] = {}
		for j=1,settings.MAP_SIZE do
			local t = 'grass'
			if math.random(1,3) == 1 then
				t = 'trees'
			end
			map[i][j] = Tile:new(t)
		end
	end
end

function loadUI()
	ui = {
		toolgrid = loveframes.Create('grid'),
	}
	ui.toolgrid:SetPos(0, love.graphics.getHeight() - 100)
	ui.toolgrid:SetRows(1)
	ui.toolgrid:SetColumns(3)

	createToolButton('roadbutton', 'resources/gfx/road-horizontal.png', 'road')
	createToolButton('housebutton', 'resources/gfx/house.png', 'house')
	createToolButton('chimneybutton', 'resources/gfx/chimney.png', 'chimney')

	ui.toolgrid:AddItem(ui.roadbutton, 1, 1)
	ui.toolgrid:AddItem(ui.chimneybutton, 1, 2)
	ui.toolgrid:AddItem(ui.housebutton, 1, 3)
	ui.toolgrid:SetItemAutoSize(true)
end

function createToolButton(name, image_path, tool_name)
	ui[name] = loveframes.Create('imagebutton')
	ui[name]:SetImage(image_path)
	ui[name]:SetText('')
	ui[name]:SizeToImage()
	ui[name].OnClick = function(object)
		current_tool = tool_name
	end
end

function love.load()
	loveframes = require('libs.loveframes')
	love.graphics.setDefaultFilter('nearest')
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
			},
			trees = {
				image = love.graphics.newImage('resources/gfx/trees.png'),
				extra_height = 38
			},
			chimney = {
				image = love.graphics.newImage('resources/gfx/chimney.png'),
				extra_height = 38
			},
			house = {
				image = love.graphics.newImage('resources/gfx/house.png'),
				extra_height = 38
			}
		}
	}
	loadUI()
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

	loveframes.update(dt)
end

function iso2screen(i, j)
	return {
		x = (i + j + 2) * settings.ISOTILE_WIDTH / 2,
		y = -settings.ISOTILE_HEIGHT/2 + j * settings.ISOTILE_HEIGHT / 2 - i * settings.ISOTILE_HEIGHT / 2
	}
end

function screen2iso(cx, cy)
	cx = (cx / camera.zoom - camera.x)
	cy = (cy / camera.zoom - camera.y)
	local x0 =  cx * (settings.ISOTILE_HEIGHT / settings.ISOTILE_WIDTH)
	local y0 =  -cx * (settings.ISOTILE_HEIGHT / settings.ISOTILE_WIDTH)

	return {
		x = (x0 - cy) / settings.ISOTILE_HEIGHT - 1,
		y = (cy - y0) / settings.ISOTILE_HEIGHT - 1
	}
end

function drawIsoTile(i, j, tile)
	local draw_origin = iso2screen(i, j)
	local gfx = gfx.tiles[tile.type]
	draw_origin.y = draw_origin.y - gfx.extra_height
	love.graphics.draw(gfx.image, (draw_origin.x + camera.x) * camera.zoom, (draw_origin.y + camera.y) * camera.zoom,
		0, camera.zoom, camera.zoom)
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
	drawIsoTile(hover_coords.x, hover_coords.y, {type = 'tile_select'})

	loveframes.draw()
end

function love.mousepressed(x, y, k)
	local iso = screen2iso(x, y)
	iso.x = math.floor(iso.x)
	iso.y = math.floor(iso.y)
	if iso.x > 0 and iso.x < settings.MAP_SIZE and iso.y > 0 and iso.y < settings.MAP_SIZE then
		map[iso.x][iso.y].type = current_tool
	end

	loveframes.mousepressed(x, y, k)
end

function love.mousereleased(x, y, k)
	loveframes.mousereleased(x, y, k)
end

function love.keyreleased(k)
	loveframes.keyreleased(k)
end

function love.keypressed(k)
	loveframes.keypressed(k)
end

function love.wheelmoved(x, y)
	if y == -1 then
		camera.zoom = camera.zoom / 2
	elseif y == 1 then
		camera.zoom = camera.zoom * 2
	end
end

