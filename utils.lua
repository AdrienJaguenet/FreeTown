local utils = {}

function utils.iso2screen(i, j)
    return {
		x = (i + j + 2) * settings.ISOTILE_WIDTH / 2,
		y = -settings.ISOTILE_HEIGHT/2 + j * settings.ISOTILE_HEIGHT / 2 - i * settings.ISOTILE_HEIGHT / 2
	}
end

function utils.screen2iso(cx, cy)
	cx = (cx / camera.zoom - camera.x)
	cy = (cy / camera.zoom - camera.y)
	local x0 =  cx * (settings.ISOTILE_HEIGHT / settings.ISOTILE_WIDTH)
	local y0 =  -cx * (settings.ISOTILE_HEIGHT / settings.ISOTILE_WIDTH)

	return {
		x = (x0 - cy) / settings.ISOTILE_HEIGHT - 1,
		y = (cy - y0) / settings.ISOTILE_HEIGHT - 1
	}
end

function utils.updateDate(dt)
	date_accu = dt + date_accu
	while date_accu > .5 do 
		date_accu = date_accu - .5
		local dateTable = os.date('*t', date)
		dateTable.day = dateTable.day + 1
		date = os.time(dateTable)
	end
end

function utils.drawDebugInfo()
    local hover_coords = utils.screen2iso(love.mouse.getX(), love.mouse.getY())
    local tileAtCoords = map:GetTile(math.floor(hover_coords.x), math.floor(hover_coords.y))
    if tileAtCoords == nil then
        tileAtCoords = {type = "void"}
    end
    local debugText = love.graphics.newText(love.graphics.getFont(),
        'DEBUG INFO:\n'
        ..'\nCamera position: x:'..math.floor(camera.x*100)/100 .. ', y:' ..math.floor(camera.y*100)/100
        ..'\nCamera zoom: ' ..camera.zoom
        ..'\nMouse screen position: x:' ..love.mouse.getX() .. ', y:' ..love.mouse.getY()
        ..'\nMouse to ISO: x: ' ..math.floor(hover_coords.x*100)/100 ..', y: ' ..math.floor(hover_coords.y*100)/100
        ..'\nTile at coords: ' ..tileAtCoords.type
    )
    local width, height = debugText:getDimensions()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 5, 75, width + 10, height + 10)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(debugText, 10, 80)
end


return utils