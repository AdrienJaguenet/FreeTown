function loadUI()
	yui.UI.registerEvents()
	ui = {
		fonts = {
			default = love.graphics.newFont('resources/fonts/VCR_OSD_MONO_1.001.ttf', 24),
		},
		main_view = yui.View(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), {
			yui.Flow({
				toolButton('road', 'road_horizontal'),
				toolButton('farm', 'farm'),
				toolButton('chimney', 'chimney'),
				toolButton('house', 'house')
			})
		})
	}
end

function toolButton(name, img_name)
	return yui.ImageButton({
		image = love.graphics.newImage('resources/gfx/'..img_name..'.png'),
		button = name
	})
end

