settings = {
	MAP_SIZE = 40,
	CAMERA_SPEED = 500,
	ISOTILE_HEIGHT = 20,
	ISOTILE_WIDTH = 32,
	VERSION = '0.0.1-afarensis',
	DEBUG = true,
	FULLSCREEN = true
}

camera = require('camera')
ui = require('ui')
utils = require('utils')

resources = {
	workers = 1,
	used_workers = 0,
	food = 1000,
	power = 0
}

date = os.time{year = 1953, month = 3, day = 5}
date_accu = 0

function love.load()
	love.graphics.setDefaultFilter('nearest')
	require('tiles')
	require('tools')
	require('map')
	love.window.setMode(640, 480)
	love.window.setTitle('FreeTown')
	love.window.setFullscreen(settings.FULLSCREEN)
	ui.initialize()
	gfx = {
		tiles = loadTiles()
	}
	sfx = {
		build = love.audio.newSource('resources/sfx/build.wav', 'static'),
		err = love.audio.newSource('resources/sfx/error.wav', 'static')
	}
	require('buildings')
	map = Map:new(settings.MAP_SIZE)
	love.mouse.setGrabbed(true)
end

function love.update(dt)
	utils.updateDate(dt)
	map:Update(dt)
	camera.update(dt)
	ui.update(dt)

	-- quit when ctrl + q pressed
	if love.keyboard.isDown('lctrl') and love.keyboard.isDown('q') then
		love.event.quit();
	end
end

function love.draw()
	local hover_coords = utils.screen2iso(love.mouse.getX(), love.mouse.getY())
	hover_coords.y = math.floor(hover_coords.y)
	hover_coords.x = math.floor(hover_coords.x)

	map:Draw(hover_coords)
	ui.draw()

	-- DEBUG INFO
	if settings.DEBUG then
		utils.drawDebugInfo()
	end
end

function love.mousepressed(x, y, k)
	local iso = utils.screen2iso(x, y)
	local tool = tools[current_tool]
	iso.x = math.floor(iso.x)
	iso.y = math.floor(iso.y)
	if not building_selected and iso.x > 0 and iso.x <= settings.MAP_SIZE and iso.y > 0 and iso.y <= settings.MAP_SIZE then
		if tool.canUse(iso.x, iso.y) then
			tool.use(iso.x, iso.y)
		else
			sfx.err:stop()
			sfx.err:play()
			camera.shake(2)
		end
	end

end

function love.mousereleased(x, y, k)
end

function love.keyreleased(k)
	if k == 'escape' then
		current_tool = 'info'
	end

	if k == 'd' then
		settings.DEBUG = not settings.DEBUG
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

