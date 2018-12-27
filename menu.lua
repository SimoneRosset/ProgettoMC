-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY

-- include Corona's "widget" library
local widget = require "widget"
local clouds = require "cloud"
local balloon = require "balloon"

--------------------------------------------

-- forward declarations and other locals
local playBtn
local highBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()

	-- go to game.lua scene
	composer.removeScene( "menu")

	composer.gotoScene( "game", "fade", 400 )

	return true	-- indicates successful touch
end
local function onHighBtnRelease()

	-- go to game.lua scene
	composer.removeScene( "menu")

	composer.gotoScene( "game", "fade", 400 )

	return true	-- indicates successful touch
end
function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local backgroundM = display.newImageRect( "background.png", display.actualContentWidth, display.actualContentHeight )
	backgroundM.anchorX = 0
	backgroundM.anchorY = 0
	backgroundM.x = 0 + display.screenOriginX
	backgroundM.y = 0 + display.screenOriginY
	backgroundM:setFillColor( .7 )

	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", 250, 60 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = display.contentCenterY*0.7
	


	-- local image = display.newImageRect( "balloon.png", 50, 50 )
	-- image.x, image.y = display.contentCenterX,  display.contentCenterY
	-- image.alpha= 0.7

-- 	cloud1 = display.newImageRect( "cloud.png", 100, 45 )
-- 	cloud1.x, cloud1.y = halfW*0.5, halfH*0.3
-- cloud1.alpha=0.7
-- cloud2 = display.newImageRect( "cloud2.png", 85, 25 )
-- cloud2.x, cloud2.y = halfW*1.5, halfH*0.5
-- cloud2.alpha=0.7
-- cloud3 = display.newImageRect( "cloud2.png", 150, 80 )
-- cloud3.x, cloud3.y = halfW*0.8, halfH*0.2
-- cloud3.alpha=0.7


	grass = display.newImageRect( "ground.png", screenW, screenH)
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight*1.7 + display.screenOriginY
  grass.alpha=0.7
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	--grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="play",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY*1.2

	highBtn = widget.newButton{
		label="highScore",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onHighBtnRelease	-- event listener function
	}
	highBtn.x = display.contentCenterX
	highBtn.y = display.contentCenterY*1.35

	-- all display objects must be inserted into group
	sceneGroup:insert( backgroundM )
	-- sceneGroup:insert( image )
	-- sceneGroup:insert( cloud1 )
	-- sceneGroup:insert( cloud2 )
	-- sceneGroup:insert( cloud3 )
	sceneGroup:insert( grass )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( highBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		for _=1,3 do
			clouds.new(sceneGroup, math.random(display.actualContentWidth), math.random(0, display.actualContentHeight/4.5))

		end
		balloon.new(sceneGroup, display.contentCenterX,  display.contentCenterY)


		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if highBtn then
		highBtn:removeSelf()	-- widgets must be manually removed
		highBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
