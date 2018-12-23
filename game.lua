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
local velocity=2
local move=1
local score = display.newText( 0, display.contentCenterX, 50, native.systemFont, 50 )
score:setFillColor( 0, 0, 0 )





local function offScreen(object)
	local bounds = object.contentBounds
	local sox, soy = display.screenOriginX, display.screenOriginY
	if bounds.xMax < sox then return true end
	if bounds.yMax < soy then return true end
	if bounds.xMin > display.actualContentWidth - sox then return true end
	if bounds.yMin > display.actualContentHeight - soy then return true end
	return false
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view


	-- We need physics started to add bodies, but we don't want the simulaton
 	-- running until the scene is on the screen.
	--physics.start()
	--physics.pause()
	physics.start()
	physics.setGravity(0,-1)

	sky = display.newImageRect( "background.png", screenW, screenH )
	sky.anchorX = 0
	sky.anchorY = 0
	sky.x = 0 + display.screenOriginX
	sky.y = 0 + display.screenOriginY
	sky:setFillColor( 0.9)

	cloud1 = display.newImageRect( "cloud.png", 100, 45 )
	cloud1.x, cloud1.y = halfW*0.5, halfH*0.3
cloud1.alpha=0.7
cloud2 = display.newImageRect( "cloud2.png", 85, 25 )
cloud2.x, cloud2.y = halfW*1.5, halfH*0.5
cloud2.alpha=0.7
cloud3 = display.newImageRect( "cloud2.png", 150, 80 )
cloud3.x, cloud3.y = halfW*0.8, halfH*0.2
cloud3.alpha=0.7

	-- make a crate (off-screen), position it, and rotate slightly
	balloon = display.newImageRect( "balloon.png", 45, 45 )
	balloon.x, balloon.y = halfW, halfH --questo coefficiente posiziona il palloncino ad un'altezza intermedia
	physics.addBody( balloon  ) --{ density=1.0, friction=1, bounce=0.3 }

	--crate.rotation = 15

	-- add physics to the crate
	-- create a grass object and add physics (with custom shape)
	grass = display.newImageRect( "ground.png", screenW, screenH*0.3 )
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY

	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	--grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	--physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	-- all display objects must be inserted into group
	--sceneGroup:insert( background )
	--sceneGroup:insert( grass)
	--sceneGroup:insert( balloon )
	background= display.newGroup()
	sceneGroup:insert(background)
	world=display.newGroup()
	sceneGroup:insert(world)
	background:insert( sky )
	background:insert( score )

	world:insert( grass )
	world:insert( balloon )
	world:insert( cloud1 )
	world:insert( cloud2 )
	world:insert( cloud3 )


	for _= 1, 6 do
		local cloudImages = { "cloud.png", "cloud2.png" }
		local temp=math.random(20,150)
		local cloud = display.newImageRect(world, cloudImages[math.random(#cloudImages)],temp,temp/2)
		cloud.anchorX, cloud.anchorY = 0.5, 1
		cloud.x, cloud.y = math.random(display.actualContentWidth), math.random(0, display.actualContentHeight*2)*-1


		 --cloud._xScale = math.random()/2 + 0.75
		 --cloud.xScale, cloud.yScale = cloud._xScale, cloud._xScale
		--cloud:setFillColor(color.hex2rgb("6D9DC5"))
	end


--terrain={}
--terrain[1] = sky
-- function spawnAir()
-- 	local x,y = terrain[#terrain][1].x, terrain[#terrain][1].y
-- 	sky2 = display.newImageRect( "background.png", screenW, screenH )
-- 	sky2.anchorX = 0
-- 	sky2.anchorY = 0
-- 	sky2.x = x
-- 	sky2.y = y
-- 	sky2:setFillColor( 1 )
-- 		terrain[#terrain+1] = sky2
-- 		terrain[#terrain]:toBack()
-- end

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.




	--function move(event)
	  --back.y=back.y+velocity
	  --balloon.y=balloon.y-velocity
	--end


	--back:addEventListener( "touch", move )

	---------------------------------------------------------------------------------

end
local function enterFrame(event)
	if not balloon.getLinearVelocity then return false end
	score.text = -((balloon.y-halfH)/100-(balloon.y-halfH)%100/100)

local vx,vy=balloon:getLinearVelocity()
if -vy > velocity*100 then
	physics.setGravity( 0, 0 )

end -- terminal velocity
	--balloon:setLinearVelocity(0,vy)
	-- recycle old buildings (pass 1)
		for i = 3, world.numChildren do
			local y = world[i].y --and world[i].contentBounds.xMax or 0
			--if buildings[i] then buildings[i]:translate(-vx/topSpeed*6,0) end
			if y > balloon.y+display.actualContentHeight then
				--display.remove(world[i])
				world[i]:translate(math.random(-50, 50), math.random(display.actualContentHeight, display.actualContentHeight*3)*-2) --math.random(display.actualContentWidth), math.random(display.actualContentHeight)*-2
			end
		end
	-- -- recycle old buildings (pass 2)
	-- 	for i = 1, background.numChildren do
	-- 		-- background[i].rotation = world.rotation * 0.85
	-- 		-- background[i].xScale, background[i].yScale = background[i]._xScale + (worldScale / 2),background[i]._xScale + (worldScale / 2)
	-- 		-- background[i].x = background[i].x - (6 * (vx / topSpeed) * background[i].xScale )
	-- 		local x = background[i].contentBounds.xMax
	-- 		if x < -display.actualContentWidth then
	-- 			background[i]:translate(display.actualContentWidth*3,0)
	-- 		end
	-- 	end

	-- easiest way to scroll a map based on a character
	-- find the difference between the hero and the display center
	-- and move the world to compensate
	local hx, hy = balloon:localToContent(0,0)
	hx, hy = display.contentCenterX - hx, display.contentCenterY - hy
	world.y = world.y + hy

end
local function shift(event)

	if event.phase == "began" then
				held=true;

		elseif event.phase == "moved" and held then
			if balloon.x==event.x then
						balloon.rotation = 0
				end
			if balloon.x<event.x then
					balloon.x=balloon.x+move
						balloon.rotation = (event.x-balloon.x)/5 --accompagna lo spostamento con una inclinazione
				end
					if balloon.x>event.x then
							balloon.x=balloon.x-move
							balloon.rotation = (event.x-balloon.x)/5

						end

		elseif event.phase == "ended" or event.phase == "cancelled" then
				held=false
				balloon.rotation = 0

		else held=false
		end
end


function scene:show( event )
--local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		Runtime:addEventListener("enterFrame", enterFrame)
		background:addEventListener("touch", shift)
	elseif phase == "did" then
		-- Called when the scene is now on screen

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		--physics.start()
	end
end

function scene:hide( event )
	--local sceneGroup = self.view

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
	--local sceneGroup = self.view

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
