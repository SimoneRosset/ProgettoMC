-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY

----------------------------aggiunte da codice precedente-----------------------
local velocity=1
local disText = display.newText( 0, display.contentCenterX, 50, native.systemFont, 50 )
disText:setFillColor( 0, 0, 0 )


function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
  local imageGroup= display.newGroup()
	sceneGroup:insert(imageGroup)
	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	--physics.start()
	--physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newImageRect( "background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY
	background:setFillColor( .7 )

	-- make a crate (off-screen), position it, and rotate slightly
	local balloon = display.newImageRect( "balloon.png", 45, 45 )
	balloon.x, balloon.y = halfW, halfH*1.7 --questo coefficiente posiziona il palloncino ad un'altezza intermedia
	--crate.rotation = 15

	-- add physics to the crate
	--physics.addBody( balloon, { density=1.0, friction=0.3, bounce=0.3 } )

	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 20 )
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY

	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	--physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	-- all display objects must be inserted into group
	--sceneGroup:insert( background )
	--sceneGroup:insert( grass)
	--sceneGroup:insert( balloon )
	imageGroup:insert( background )
	imageGroup:insert( grass )
	imageGroup:insert( balloon )

	function background:touch(event)
	  if event.phase == "began" then
	        held=true;
	    elseif event.phase == "moved" and held then
	      if balloon.x<event.x then
	          balloon.x=balloon.x+velocity
	         end
	         if balloon.x>event.x then
	            balloon.x=balloon.x-velocity
	           end
	  disText.text = (balloon.y)/100-(balloon.y)%100/100

	    elseif event.phase == "ended" or event.phase == "cancelled" then

	        held=false;
	    end

	end

	--function move(event)
	  --back.y=back.y+velocity
	  --balloon.y=balloon.y-velocity
	--end


	--back:addEventListener( "touch", move )

	---------------------------------------------------------------------------------

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
background:addEventListener("touch")
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		--physics.start()
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
		--physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

	--package.loaded[physics] = nil
	--physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
