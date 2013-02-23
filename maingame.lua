---------------------------------------------------------------------------------
-- maingame.lua
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local sprite = require("sprite")
local ui = require ("ui")

local background
local pauseBtn
local pauseMenuBtn
local pauseBG
local menuBtn

system.setAccelerometerInterval( 100 )

local eggCaughtSound = audio.loadSound( "friedEgg.wav" )
local btnSound = audio.loadSound( "btnSound.wav" )

local saveValue = function( strFilename, strValue )
	local theFile = strFilename
	local theValue = strValue
	
	local path = system.pathForFile( theFile, system.DocumentsDirectory )

	local file = io.open( path, "w+" )
	if file then
	   file:write( theValue )
	   io.close( file )
	end
end

local loadValue = function( strFilename )
	
	local theFile = strFilename
	local path = system.pathForFile( theFile, system.DocumentsDirectory )
	
	local file = io.open( path, "r" )
	if file then
	   local contents = file:read( "*a" )
	   io.close( file )
	   return contents
	else
	   file = io.open( path, "w" )
	   file:write( "0" )
	   io.close( file )
	   return "0"
	end
end

function scene:createScene( event )
	local gameGroup = self.view
	storyboard.removeScene( "loadgame" )
	print( "\nmaingame: createScene event")
end

function scene:enterScene( event )
	local gameGroup = self.view
	local gameActivate = function()		
		pauseBtn.isVisible = true
		pauseBtn.isActive = true
	
			charObject.x = display.contentCenterX - (display.contentCenterX * (event.yGravity*3))
			
			if((charObject.x - charObject.width * 0.5) < 0) then
		
	local setScore = function( scoreNum )
		local newScore = scoreNum
		scoreText.text = "Score: " .. gameScore 
		scoreText.xScale = 0.5; scoreText.yScale = 0.5	
		
	local callGameOver = function()
		audio.play( gameOverSound )
		pauseBtn.isVisible = false
		pauseBtn.isActive = false		
		shade = display.newRect( 0, 0, 570, 320 )
		
		gameOverScreen = display.newImageRect( "gameOver.png", 400, 300 )
		
		gameGroup:insert( shade )
		gameGroup:insert( gameOverScreen )
	
		transition.to( shade, { time=200, alpha=0.65 } )
		transition.to( gameOverScreen, { time=500, alpha=1 } )
		
		scoreText.isVisible = false
		
		if gameScore > highScore then
			highScore = gameScore
			local highScoreFilename = "highScore.data"
			saveValue( highScoreFilename, tostring(highScore) )
			gameNetwork.request( "setHighScore", { leaderboardID="Unique ID Displayed Here", score=gameScore } )
		end

		highScoreText = display.newText( "Best Game Score: " .. highScore, 0, 0, "Arial", 30 )
		highScoreText:setTextColor( 255, 255, 255, 255 )	
		highScoreText.xScale = 0.5; highScoreText.yScale = 0.5	
		highScoreText.x = 240
		highScoreText.y = 120
		
		gameGroup:insert( highScoreText )
		
		local onMenuTouch = function( event )
			if event.phase == "release" then				
				audio.play( buttonSound )
				storyboard.gotoScene( "mainmenu", "fade", 500  )				
			end
		end
		
		menuBtn = ui.newButton{
			defaultSrc = "menubtn.png",
			defaultX = 60,
			defaultY = 60,
			overSrc = "menubtn-over.png",
			overX = 60,
			overY = 60,
			onEvent = onMenuTouch,
			id = "MenuButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}		
		menuBtn.x = 100; menuBtn.y = 260		
		gameGroup:insert( menuBtn )
	
	local drawBackground = function()
	
		background = display.newImageRect( "bg.png", 480, 320 )
		
		ground = display.newImageRect( "grass.png", 480, 75 )
		
	local hud = function()
		
		eggText = display.newText( "Caught: " .. eggCount, 0, 0, "Arial", 45 )
		
		livesText = display.newText( "Lives: " .. gameLives, 0, 0, "Arial", 45 )
		
		scoreText = display.newText( "Score: " .. gameScore, 0, 0, "Arial", 45 )
		
		local onPauseTouch = function( event )
			if event.phase == "release" and pauseBtn.isActive then
				audio.play( buttonSound )
				
				if gameIsActive then
				
					gameIsActive = false
					physics.pause()
					
					local function pauseGame()
		                timer.pause( startDrop )
		                print("timer has been paused")
		            end
		            timer.performWithDelay(1, pauseGame)

					if not shade then
						shade = display.newRect( 0, 0, 570, 380 )
						shade:setFillColor( 0, 0, 0, 255 )
						shade.x = 240; shade.y = 160
						gameGroup:insert( shade )
					end
					shade.alpha = 0.5
					
					if pauseBG then
						pauseBG.isVisible = true
						pauseBG.isActive = true
						pauseBG:toFront()
					end
					
					pauseBtn:toFront()

				else
					
					if shade then
						display.remove( shade )
						shade = nil
					end
					
					
					if pauseBG then
						pauseBG.isVisible = false
						pauseBG.isActive = false
					end
					
					gameIsActive = true
					physics.start()
					
					local function resumeGame()
		                timer.resume( startDrop )
		                print("timer has been resumed")
		            end
		            timer.performWithDelay(1, resumeGame)		
				end
			end
		end
		
		pauseBtn = ui.newButton{
			defaultSrc = "pausebtn.png",
			defaultX = 44,
			defaultY = 44,
			overSrc = "pausebtn-over.png",
			overX = 44,
			overY = 44,
			onEvent = onPauseTouch,
			id = "PauseButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}
		
		pauseBtn.x = 38; pauseBtn.y = 288
		pauseBtn.isVisible = false
		pauseBtn.isActive = false
		
		gameGroup:insert( pauseBtn )
		
		pauseBG = display.newImageRect( "pauseoverlay.png", 480, 320 )
		pauseBG.x = 240; pauseBG.y = 160
		pauseBG.isVisible = false
		pauseBG.isActive = false
		
		gameGroup:insert( pauseBG )
	
	local livesCount = function()
		
	  gameLives = gameLives - 1
	    
	    if gameLives < 1 then
	    		callGameOver()
	    end
	
	local createChar = function()
	
		local characterSheet = sprite.newSpriteSheet( "charSprite.png", 128, 128 )
		
		charObject.x = 240; charObject.y = 250
		
		friedEgg = display.newImageRect( "friedEgg.png", 40, 23 )
	
	local onEggCollision = function( self, event )
	
		if event.force > 1 and not self.isHit then
				
			self.isHit = true
			
			local fadeEgg = function()
			
			if event.other.myName == "character" then
			
			if gameLives < 1 then
			
			if eggCount == 1 then
				gameNetwork.request( "unlockAchievement", "Unique ID Displayed Here" ) 
			end
		
	local eggDrop = function()
		
		local egg = display.newImageRect( "egg.png", 30, 30 )
		
		egg.postCollision = onEggCollision
		
	local eggTimer = function()
			startDrop = timer.performWithDelay( 1000, eggDrop, 0 )
	
	local gameStart = function()
		physics.start( true )
		
		drawBackground()
		
		local highScoreFilename = "highScore.data"
		local loadedHighScore = loadValue( highScoreFilename )
		
		highScore = tonumber(loadedHighScore)
			
	gameStart()
	
	print( "maingame: enterScene event" )
	
end

function scene:exitScene( event )
	
	print( "maingame: exitScene event" )

end

function scene:destroyScene( event )
	print( "((destroying maingame's view))" )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene