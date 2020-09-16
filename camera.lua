local camera = {
    x = 0,
	y = 0,
	zoom = 2,
	currShakeAmount = 0,
	shakeThreshold = 0.2,
    shakeDamping = 20,
    offset = {x = 0, y = 0}
}

function handleMovement(dt)
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
end

function camera.update(dt)
    handleMovement(dt)
    camera.offset = {x = love.math.random(-1, 1) * camera.currShakeAmount, y = love.math.random(-1, 1) * camera.currShakeAmount}
    if camera.currShakeAmount > camera.shakeThreshold then
        camera.currShakeAmount = camera.currShakeAmount - camera.currShakeAmount * camera.shakeDamping * dt
    else
        camera.currShakeAmount = 0
    end
end

function camera.shake(amount)
    camera.currShakeAmount = amount
end


return camera