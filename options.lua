---------------------------------------------------------------------------------
-- options.lua
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require("ui")

local btnAnim

local btnSound = audio.loadSound( "btnSound.wav" )

function scene:createScene( event )
	local screenGroup = self.view

	storyboard.removeScene( "mainmenu" )
	storyboard.removeScene( "creditsScreen" )
	print( "\noptions: createScene event" )
end

function scene:enterScene( event )
	local screenGroup = self.view
	
	print( "options: enterScene event" )
	
	local backgroundImage = display.newImageRect( "optionsBG.png", 480, 320 )
	backgroundImage.x = 240; backgroundImage.y = 160
	screenGroup:insert( backgroundImage )
	
	local creditsBtn
	
	local onCreditsTouch = function( event )
		if event.phase == "release" then		
			audio.play( btnSound )
			storyboard.gotoScene( "creditsScreen", "crossFade", 300  )
		end
	end
	
	creditsBtn = ui.newButton{
		defaultSrc = "creditsbtn.png",
		defaultX = 100,
		defaultY = 100,
		overSrc = "creditsbtn-over.png",
		overX = 100,
		overY = 100,
		onEvent = onCreditsTouch,
		id = "CreditsButton",
		text = "",
		font = "Helvetica",
		textColor = { 255, 255, 255, 255 },
		size = 16,
		emboss = false
	}
	
	creditsBtn.x = 240; creditsBtn.y = 440
	screenGroup:insert( creditsBtn )
	
	btnAnim = transition.to( creditsBtn, { time=500, y=260, transition=easing.inOutExpo } )	
	
	local closeBtn
	
	local onCloseTouch = function( event )
		if event.phase == "release" then
			audio.play( tapSound )
			storyboard.gotoScene( "mainmenu", "zoomInOutFadeRotate", 500  )
		end
	end
	
	closeBtn = ui.newButton{
		defaultSrc = "closebtn.png",
		defaultX = 60,
		defaultY = 60,
		overSrc = "closebtn-over.png",
		overX = 60,
		overY = 60,
		onEvent = onCloseTouch,
		id = "CloseButton",
		text = "",
		font = "Helvetica",
		textColor = { 255, 255, 255, 255 },
		size = 16,
		emboss = false
	}
	
	closeBtn.x = 50; closeBtn.y = 280
	screenGroup:insert( closeBtn )
	
end

function scene:exitScene()

	if btnAnim then transition.cancel( btnAnim ); end
	
	print( "options: exitScene event" )

end

function scene:destroyScene( event )
	
	print( "((destroying options's view))" )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene