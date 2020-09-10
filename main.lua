settings = {
	MAP_SIZE = 40,
	CAMERA_SPEED = 500,
	ISOTILE_HEIGHT = 20,
	ISOTILE_WIDTH = 32,
	VERSION = '0.0.1-afarensis'
}
camera = {
	x = 0,
	y = 0,
	zoom = 2
}

resources = {
	population = 1,
	food = 10,
	power = 0,
	minerals = 0
}

Tile = { id = 'Tile' }
Tile.__index = Tile

function Tile:new(t)
	local this = {
		type = t,
		assigned_workers = 0
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

function love.load()
	yui = require('libs.yaoui.yaoui')
	require('tiles')
	require('ui')
	require('tools')
	love.window.setMode(640, 480)
	love.window.setTitle('FreeTown')
	love.window.setFullscreen(true)
	love.graphics.setDefaultFilter('nearest')
	gfx = {
		tiles = loadTiles()
	}
	loadUI()
	createMap()
end

function getTile(x, y)
	local row = map[x]
	if row then
		return map[x][y]
	end
end

function countTilesAround(i, j, radius, fn)
	local acc = 0
	for x=i-radius,i+radius do
		for y=j-radius,j+radius do
			local ftile = getTile(x, y)
			if ftile and fn(ftile) then
				acc = acc + 1
			end
		end
	end
	return acc
end

update_funcs = {
	['farm'] = function(i, j, dt)
		total_fields = countTilesAround(i, j, 2, function(t) return t.type == 'field' end)
		if total_fields < 10 and math.random(1, 20) == 1 then
			local x = math.random(i-2, i+3)
			local y = math.random(j-2, j+3)
			local ftile = getTile(x, y)
			if ftile and (ftile.type == 'grass' or ftile.type == 'trees') then
				ftile.type = 'field'
			end
		end
	end,
	['grass'] = function(i, j, dt)
		total_forest = countTilesAround(i, j, 2, function(t) return t.type == 'trees' end)
		if math.random(1, 100000) < total_forest then
			map[i][j].type = 'trees'
		end
	end
}

function love.update(dt)
	for i=1,settings.MAP_SIZE do
		for j=1,settings.MAP_SIZE do
			local tile = map[i][j]
			local total_fields = 0
			if update_funcs[tile.type] then
				update_funcs[tile.type](i, j, dt)
			end
		end
	end

	-- handle camera movement
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
	if mx < love.graphics.getWidth() / 100 then
		camera.x = camera.x + settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	elseif mx > 99 * love.graphics.getWidth() / 100 then
		camera.x = camera.x - settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	end

	if my < love.graphics.getHeight() / 100 then
		camera.y = camera.y + settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	elseif my > 99 * love.graphics.getHeight() / 100 then
		camera.y = camera.y - settings.CAMERA_SPEED * dt * (1 / camera.zoom)
	end

	yui.update({ui.main_view})
	ui.main_view:update(dt)
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

function drawIsoTile(i, j, tile, layer)
	local sprite = gfx.tiles[tile.type].layers[layer]
	if not sprite then
		return
	end
	local draw_origin = iso2screen(i, j)
	draw_origin.y = draw_origin.y - sprite.extra_height
	love.graphics.draw(sprite.image, (draw_origin.x + camera.x) * camera.zoom, (draw_origin.y + camera.y) * camera.zoom,
		0, camera.zoom, camera.zoom)
end

function love.draw()

	-- for every layer
	for layer=1,2 do
		-- draw the upper half
		for i=1,settings.MAP_SIZE do
			for j=1,i do
				local x = settings.MAP_SIZE - i + j
				local y = j
				local tile = map[x][y]
				drawIsoTile(x, y, tile, layer)
			end
		end
		-- draw the lower half 
		for i=settings.MAP_SIZE,1,-1 do
			for j=1,i do
				local x = j
				local y = settings.MAP_SIZE - i + j
				local tile = map[x][y]
				drawIsoTile(x, y, tile, layer)
			end
		end
		if layer == 1 then
			-- draw the hover
			local hover_coords = screen2iso(love.mouse.getX(), love.mouse.getY())
			hover_coords.y = math.floor(hover_coords.y)
			hover_coords.x = math.floor(hover_coords.x)
			drawIsoTile(hover_coords.x, hover_coords.y, {type = 'tile_select'}, 1)
		end
	end


	local str=''
	for k,v in pairs(resources) do
		str = str..' | '..k..': '..v
	end
	
	ui.main_view:draw()
end

function love.mousepressed(x, y, k)
	local iso = screen2iso(x, y)
	iso.x = math.floor(iso.x)
	iso.y = math.floor(iso.y)
	if iso.x > 0 and iso.x < settings.MAP_SIZE and iso.y > 0 and iso.y < settings.MAP_SIZE then
		tools[current_tool].use(iso.x, iso.y)
	end

end

function love.mousereleased(x, y, k)
end

function love.keyreleased(k)
end

function love.keypressed(k)
end

function love.wheelmoved(x, y)
	if y == -1 then
		camera.zoom = camera.zoom / 2
		camera.x = camera.x * 2
		camera.y = camera.y * 2
	elseif y == 1 then
		camera.zoom = camera.zoom * 2
		camera.x = camera.x / 2
		camera.y = camera.y / 2
	end
end

