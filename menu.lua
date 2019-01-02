-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local bestScore
-- include Corona's "widget" library
local widget = require "widget"
local clouds = require "cloud"
local birds = require "bird"

local balloon = require "balloon"
local click = audio.loadSound( "click.wav" )
local tweet = audio.loadSound( "tweet.wav" )
audio.reserveChannels( 1 )
audio.setMaxVolume( 0.2, {channel=1})

-- local corda={}
local json = require( "json" )

local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local tutorial={}
local filePath2 = system.pathForFile( "tutorial.json", system.DocumentsDirectory )
local function loadScores()
    local file = io.open( filePath, "r" )

    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end

    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 0, 0, 0}
    end
end

	local function loadTutorial()

	    local file = io.open( filePath2, "r" )

	    if file then
	        local contents = file:read( "*a" )
	        io.close( file )
	        tutorial = json.decode( contents )
	    end

	    if ( tutorial == nil or #tutorial == 0) then --or #tutorial == 0
	        tutorial = {true}
	    end
	end
	local function saveTutorial()

	        table.remove( tutorial )

	    local file = io.open( filePath2, "w" )

	    if file then
	        file:write( json.encode( tutorial ) )
	        io.close( file )
	    end
	end
--------------------------------------------

-- forward declarations and other locals
local playBtn
local highBtn
local tutorialBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
audio.play(click)
	-- go to game.lua scene
	physics.stop()

	timer.cancel(timerNewBird)

	Runtime:removeEventListener("enterFrame", enterFrame)

	composer.removeScene( "menu")

	composer.gotoScene( "game", "fade", 400 )

	return true	-- indicates successful touch
end
local function onTutorialBtnRelease()
	audio.play(click)

	-- go to game.lua scene
	physics.stop()

	loadTutorial()

	table.insert( tutorial, 1, true )

	saveTutorial()

	timer.cancel(timerNewBird)

	Runtime:removeEventListener("enterFrame", enterFrame)

composer.removeScene( "menu")

	composer.gotoScene( "game", "fade", 400 )

	return true	-- indicates successful touch
end
local function onHighBtnRelease()
	audio.play(click)

	-- go to game.lua scene
	physics.stop()

	timer.cancel(timerNewBird)

	Runtime:removeEventListener("enterFrame", enterFrame)

	composer.removeScene( "menu")

	composer.gotoScene( "highScores", "fade", 400 )

	return true	-- indicates successful touch
end
function scene:create( event )
	local sceneGroup = self.view
	loadScores()
	loadTutorial()
	composer.setVariable( "record", scoresTable[1] )


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
	titleLogo.y = display.contentCenterY*0.6



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
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight*1.8 + display.screenOriginY
  grass.alpha=0.7
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	--grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		textOnly=true,
		label="play",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY*0.8

	highBtn = widget.newButton{
		textOnly=true,
		label="highScore",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onHighBtnRelease	-- event listener function
	}
	highBtn.x = display.contentCenterX
	highBtn.y = display.contentCenterY*0.95

	tutorialBtn = widget.newButton{
		textOnly=true,
		label="tutorial",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onTutorialBtnRelease	-- event listener function
	}
	tutorialBtn.x = display.contentCenterX
	tutorialBtn.y = display.contentCenterY*1.1

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
	sceneGroup:insert( tutorialBtn )

	birdgroup=display.newGroup()

		sceneGroup:insert( birdgroup )
end
local function newBird(event)
audio.play(tweet, {channel=1})
	birds.new(birdgroup, (math.random(1,2)-1)*screenW, math.random(0,display.actualContentHeight/4)).alpha=0.8
	timerNewBird=timer.performWithDelay( math.random(1,2)*3000, newBird )

end
local function offScreen(object)
	local bounds = object.contentBounds
	local sox = display.screenOriginX
	if bounds.xMax < sox then return true end
	if bounds.xMin > display.actualContentWidth - sox then return true end
	return false
end
local function enterFrame(event)
			for i=1, birdgroup.numChildren do
				if birdgroup[i].sequence=="flyToRight"    then
					-- birdg[i]:setSequence( "flyToRight" )
					birdgroup[i]:setLinearVelocity(200,0)

			else
				-- birdg[i]:setSequence( "flyToLeft" )
				birdgroup[i]:setLinearVelocity(-200,0)

			end
			if not birdgroup[i]==nil then

			if offScreen(birdgroup[i])==true then
				display.remove( birdgroup[i] )
				birdgroup:remove(birdg[i])

	 end
end
		end

			-- INSERT code here to make the scene come alive
			-- e.g. start timers, begin animation, play audio, etc.


end
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		physics.start()

		for _=1,3 do
			clouds.new(sceneGroup, math.random(display.actualContentWidth), math.random(0, display.actualContentHeight/4.5))

		end

	local balloon=balloon.new(sceneGroup, display.contentCenterX,  display.contentCenterY*1.3)
-- for i=1,20 do
	corda=display.newImageRect( sceneGroup, "corda.png", 2,grass.y-grass.height-balloon.y)
-- 	physics.addBody( corda[i], "static" )
--
-- end
corda.x,corda.y=balloon.x,balloon.y+balloon.height
corda.alpha=0.6

-- rope=physics.newJoint( "pivot", balloon, corda[1],0,2,0,2)
--
balloon:toFront()
-- for i=2,#corda do
-- 	corda[i].x,corda[i].y=corda[i-1].x,corda[i-1].y+4
-- 	rope=physics.newJoint( "pivot", corda[i-1], corda[i],0,2,0,2)
--
-- end




		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--



		-- physics.setGravity(0,0)
		timerNewBird=timer.performWithDelay( math.random(1,2)*2000, newBird )

		Runtime:addEventListener("enterFrame", enterFrame)

end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--

		timer.cancel(timerNewBird)
		physics.stop()

		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		Runtime:removeEventListener("enterFrame", enterFrame)

	composer.removeScene("menu")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	audio.dispose(click)
	click=nil
	audio.dispose(tweet)
	tweet=nil
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	Runtime:removeEventListener("enterFrame", enterFrame)

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
