local camera = {
    x = 0,
	y = 0,
	zoom = 2,
	currShakeAmount = 0,
	shakeThreshold = 0.2,
    shakeDamping = 20,
    offset = {x = 0, y = 0}
}

function camera.update(dt)
    camera.offset.x = love.math.random(-1, 1) * camera.currShakeAmount;
    camera.offset.y = love.math.random(-1, 1) * camera.currShakeAmount;
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