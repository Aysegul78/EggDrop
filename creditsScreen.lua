---------------------------------------------------------------------------------
-- creditsScreen.lua
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local backgroundImage

function scene:createScene( event )
	local screenGroup = self.view
	storyboard.removeScene( "options" )
	print( "\ncreditsScreen: createScene event" )
end

function scene:enterScene( event )
	local screenGroup = self.view
	
	print( "creditsScreen: enterScene event" )
	
	backgroundImage = display.newImageRect( "creditsScreen.png", 480, 320 )
	backgroundImage.x = 240; backgroundImage.y = 160
	screenGroup:insert( backgroundImage )
	
	local changeToOptions = function( event )
		if event.phase == "began" then
			storyboard.gotoScene( "options", "crossFade", 500  )
		end
	end
	backgroundImage:addEventListener( "touch", changeToOptions)
	
end

function scene:exitScene()
	print( "creditsScreen: exitScene event" )
end

function scene:destroyScene( event )
	print( "((destroying creditsScreen's view))" )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene