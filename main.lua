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
	workers = 1,
	used_workers = 0,
	food = 10,
	power = 0
}

date = os.time{year = 1953, month = 3, day = 5}
date_accu = 0

function createMap()
	map = {}
	for i=1,settings.MAP_SIZE do
		map[i] = {}
		for j=1,settings.MAP_SIZE do
			local t = 'grass'
			if math.random(1,5) < 4 then
				t = 'trees'
			end
			map[i][j] = Tile:new(t)
		end
	end
	local sx = math.random(1, settings.MAP_SIZE)
	for i=1,settings.MAP_SIZE do
		map[sx][i].type = 'river'
		if math.random(1, 3) == 1 then
			sx = math.max(1, sx - 1)
			map[sx][i].type = 'river'
		elseif math.random(1, 3) == 1 then
			sx = math.min(settings.MAP_SIZE, sx + 1)
			map[sx][i].type = 'river'
		end
	end
end

function love.load()
	love.graphics.setDefaultFilter('nearest')
	require('tiles')
	require('ui')
	require('tools')
	love.window.setMode(640, 480)
	love.window.setTitle('FreeTown')
	love.window.setFullscreen(true)
	gfx = {
		tiles = loadTiles()
	}
	sfx = {
		build = love.audio.newSource('resources/sfx/build.wav', 'static'),
		err = love.audio.newSource('resources/sfx/error.wav', 'static')
	}
	require('buildings')
	loadUI()
	createMap()
	love.mouse.setGrabbed(true)
end

function getTile(x, y)
	local row = map[x]
	if row then
		return map[x][y]
	end
end

function updateDate(dt)
	date_accu = dt + date_accu
	while date_accu > .5 do 
		date_accu = date_accu - .5
		local dateTable = os.date('*t', date)
		dateTable.day = dateTable.day + 1
		date = os.time(dateTable)
	end
end

function love.update(dt)
	updateDate(dt)
	for i=1,settings.MAP_SIZE do
		for j=1,settings.MAP_SIZE do
			local tile = map[i][j]
			local total_fields = 0
			if tile.building then
				tile.building:Update(dt)
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

	yui.update({ui.top_bar, ui.main_view, ui.building_view})
	ui.main_view:update(dt)
	ui.top_info:update(dt)
	if building_selected then
		ui.building_view:update(dt)
	end
	
	-- quit when ctrl + q pressed
	if love.keyboard.isDown('lctrl') and love.keyboard.isDown('q') then
		love.event.quit();
	end
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

function drawTool(i, j, tool)
	local color = {}
	if tool.canUse(i, j) then
		color = {.25, .75, .25}
	else
		color = {.75, .25, .25}
	end
	Tile:new(tool.hoverTile):draw(i, j, {color = color})
end

function love.draw()

	local hover_coords = screen2iso(love.mouse.getX(), love.mouse.getY())
	local tool = tools[current_tool]
	hover_coords.y = math.floor(hover_coords.y)
	hover_coords.x = math.floor(hover_coords.x)
	-- for every layer
	for layer=1,2 do
		-- draw the upper half
		for i=1,settings.MAP_SIZE do
			for j=1,i do
				local x = settings.MAP_SIZE - i + j
				local y = j
				local tile = map[x][y]
				tile:draw(x, y, {layer = layer})
				if tile.building then
					tile.building:Draw(layer)
				end	
				if hover_coords.x == x and hover_coords.y == y then
					-- draw the hover
					drawTool(x, y, tool)
				end
			end
		end
		-- draw the lower half 
		for i=settings.MAP_SIZE,1,-1 do
			for j=1,i do
				local x = j
				local y = settings.MAP_SIZE - i + j
				local tile = map[x][y]
				tile:draw(x, y, {layer = layer})
				if tile.building then
					tile.building:Draw(layer)
				end
				if hover_coords.x == x and hover_coords.y == y then
					-- draw the hover
					drawTool(x, y, tool)
				end
			end
		end
	end

	getFPSLabel():setText(love.timer.getFPS()..' FPS')
	getDateLabel():setText(os.date("%d.%m.%Y", date))


	getResourceLabel('workers'):setText('workers: '..resources.workers - resources.used_workers..'/'..resources.workers)
	getResourceLabel('power'):setText('power: '..resources.power)
	getResourceLabel('food'):setText('food: '..resources.food)


	ui.top_info:draw()
	ui.main_view:draw()
	if building_selected then
		ui.building_view:draw()
		getAssignedWorkersLabel():setText(building_selected.workers)
		getBuildingNameLabel():setText(building_selected.proto.name)
	end
end

function love.mousepressed(x, y, k)
	local iso = screen2iso(x, y)
	local tool = tools[current_tool]
	iso.x = math.floor(iso.x)
	iso.y = math.floor(iso.y)
	if not building_selected and iso.x > 0 and iso.x < settings.MAP_SIZE and iso.y > 0 and iso.y < settings.MAP_SIZE then
		if tool.canUse(iso.x, iso.y) then
			tool.use(iso.x, iso.y)
		else
			sfx.err:stop()
			sfx.err:play()
		end
	end

end

function love.mousereleased(x, y, k)
end

function love.keyreleased(k)
	if k == 'escape' then
		current_tool = 'info'
	end
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

