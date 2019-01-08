local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local pause, press=false, false
local backBtn
local pauseBtn
local restartBtn
local result
local pop = audio.loadSound( "pop.wav" )
local click = audio.loadSound( "click.wav" )
local tweet = audio.loadSound( "tweet.wav" )
audio.reserveChannels( 1 )
audio.setMaxVolume( 0.1, {channel=1})

-- include Corona's "physics" library
local physics = require "physics"
local birds = require "bird"
local clouds = require "cloud"
local balloon = require "balloon"
local json = require( "json" )


local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
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
composer.setVariable( "record", scoresTable[1] )
local function saveScores()

    for i = #scoresTable, 4, -1 do
        table.remove( scoresTable, i )
    end

    local file = io.open( filePath, "w" )

    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

    -- Code here runs when the scene is first created but has not yet appeared on screen
    -- Load the previous scores

   -- Sort the table entries from highest to lowest
    local function compare( a, b )

        return a > b

    end

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local actualScore=0
local actualRecord = composer.getVariable( "record" )
local tutorial={}
local filePath2 = system.pathForFile( "tutorial.json", system.DocumentsDirectory )
local function loadTutorial()

    local file = io.open( filePath2, "r" )

    if file then
        local contents = file:read( "*a" )
        io.close( file )
        tutorial = json.decode( contents )
    end

    if ( tutorial == nil or #tutorial == 0 ) then --or #tutorial == 0
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


----------------------------aggiunte da codice precedente-----------------------
local velocity=220
local move=velocity/70
local score = display.newText( 0, display.contentCenterX, 40, native.systemFont, 50 )
score:setFillColor( 0, 0, 0 )
local record = display.newText( "record: "..actualRecord, display.contentCenterX, 70, native.systemFont, 15 )
record:setFillColor( 0, 0, 0 )
record.alpha=0.6
local secondi=3
local time
local fog
local function bestScore()


		record.text="record: "..actualScore


end
local function onBackBtnRelease()
	audio.play( click )
	-- go to game.lua scene
	display.remove(fog)
 display.remove( time )
 display.remove(restartBtn)
 display.remove( result )
	physics.stop()
	timer.cancel( timerNewBird )

	composer.removeScene( "game")
	composer.gotoScene( "menu", "fade", 400 )

	return true	-- indicates successful touch
end
local function onRestartBtnRelease()
	audio.play( click )

	-- go to game.lua scene
  display.remove(restartBtn)

	display.remove(fog)
 display.remove( time )
 display.remove( result )

	physics.stop()
	loadScores()
	-- Insert the saved score from the last game into the table, then reset it
table.insert( scoresTable, composer.getVariable( "finalScore" ) )
composer.setVariable( "finalScore", 0 )
table.sort( scoresTable, compare )
-- Save the scores
saveScores()
composer.setVariable( "record", scoresTable[1] )

	composer.removeScene( "game")


	composer.gotoScene( "game", "fade", 400 )

	return true	-- indicates successful touch
end
local function shift(event)

	if event.phase == "began" then
				held=true;


		elseif event.phase == "moved" and held then

			if balloon.x<event.x then
					balloon.x=balloon.x+move
				end
					if balloon.x>event.x then
							balloon.x=balloon.x-move

						end
            corda.x=balloon.x
            finger.x=event.x
            finger.y=event.y
corda.height=math.sqrt((event.y-display.contentCenterY*1.3)^2+(event.x-balloon.x)^2)

              rotazioneRad=-math.atan2((event.y-display.contentCenterY*1.3),(event.x-balloon.x))
rotazione= math.deg(rotazioneRad+math.pi/2)

                  balloon.rotation = -rotazione--accompagna lo spostamento con una inclinazione
                  corda.rotation= -rotazione





		elseif event.phase == "ended" or event.phase == "cancelled" then
				held=false

				balloon.rotation = 0
        corda.rotation=0
        if corda.height<balloon.height then
        corda.height=balloon.height
        end
        if not (finger==nil or corda==nil) then
        finger.x,finger.y=corda.x, corda.y+corda.height
      end
		else
       held=false
		end
end

local function ready(event)
	-- if secondi==0 then
	pauseBtn:setLabel("pause")
	score:setFillColor( 0, 0, 0 )


display.remove( fog )
	timer.cancel(watch)
	timer.cancel(timerPause)
	physics.start()
 display.remove(time)
	timer.resume(timerNewBird)
	finger:addEventListener("touch", shift)
	press=false
	secondi=3

end


 local function clock(event)
	 if secondi>0 then
		 secondi=secondi-1

	 	time.text= secondi
	else 	timer.cancel(timerPause)

 end
end

local function onPauseBtnRelease()
	audio.play( click )

	if pause and not press then
		pauseBtn:setLabel("")

		 time.text= secondi
		watch=timer.performWithDelay( 1000, clock , secondi )
		timerPause=timer.performWithDelay( 3000, ready, secondi )
		pause, press=false, true
elseif not press then
	pauseBtn:setLabel("start")
	time = display.newText( "pause", display.contentCenterX, display.contentCenterY, native.systemFont, 100 )
	 time:setFillColor( 0, 0, 0 )
	 score:setFillColor( 0.3, 0.3, 0.3 )

fog=display.newImageRect( "background.png", display.actualContentWidth, display.actualContentHeight )
fog.anchorX = 0
fog.anchorY = 0
fog.x = 0 + display.screenOriginX
fog.y = 0 + display.screenOriginY
fog:setFillColor(0,0,0)
fog.alpha=0.5
	finger:removeEventListener("touch", shift)
timer.pause(timerNewBird)
physics.pause()
pause,press=true, false
end

		-- indicates successful touch
end


function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
loadScores()
loadTutorial()
	backBtn = widget.newButton{
		textOnly=true,
		label="back",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onBackBtnRelease	-- event listener function
	}
	backBtn.x = display.contentCenterX*0.2
	backBtn.y = display.contentCenterY-display.contentCenterY
	sceneGroup:insert( backBtn )

	pauseBtn = widget.newButton{
		textOnly=true,
		label="pause",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onPauseBtnRelease	-- event listener function
	}
	pauseBtn.x = display.contentCenterX*1.8
	pauseBtn.y = display.contentCenterY-display.contentCenterY
	sceneGroup:insert( pauseBtn )


	sky = display.newImageRect( "background.png", screenW, screenH )
	sky.anchorX = 0
	sky.anchorY = 0
	sky.x = 0 + display.screenOriginX
	sky.y = 0 + display.screenOriginY


	-- add physics to the crate
	-- create a grass object and add physics (with custom shape)
	grass = display.newImageRect( "ground.png", screenW, screenH)
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight*1.8 + display.screenOriginY

	-- all display objects must be inserted into group
	background= display.newGroup()
	sceneGroup:insert(background)
	background:insert( sky )
	background:insert( score )
	background:insert( record )

background:insert(backBtn)
background:insert(pauseBtn)

	world=display.newGroup()
	sceneGroup:insert(world)
	world:insert( grass )

	balloon=balloon.new(world, display.contentCenterX,  display.contentCenterY*1.3)

corda=display.newImageRect( background, "corda.png",  1, balloon.height )
corda.x=balloon.x
corda.y=balloon.y
corda.anchorX=0
corda.anchorY=0
corda.alpha=0.3

finger=display.newImageRect( background, "touch.png",60, 60 )
finger.x,finger.y=balloon.x, corda.y+corda.height
finger.alpha=0.4
	-- world:insert( balloon )

  birdg=display.newGroup()
  sceneGroup:insert(birdg)
  world:insert( birdg )

cloudg=display.newGroup()
sceneGroup:insert(cloudg)
world:insert( cloudg )


	for _= 1, 10 do
		
clouds.new(cloudg, math.random(display.actualContentWidth), math.random(0, display.actualContentHeight)*math.random(-3,-1))
		
	end

end

local function onCollisionBalloon(self,event)
	audio.play(pop)
  	finger:removeEventListener("touch", shift)
	Runtime:removeEventListener("enterFrame", enterFrame)
	balloon:setSequence("boom")
	balloon:play()
finger:toBack()
corda:toBack()



	physics.pause()
	timer.cancel( timerNewBird )
	fog=display.newImageRect( "background.png", display.actualContentWidth, display.actualContentHeight )
	fog.anchorX = 0
	fog.anchorY = 0
	fog.x = 0 + display.screenOriginX
	fog.y = 0 + display.screenOriginY
	fog:setFillColor(0,0,0)
	fog.alpha=0.5
	restartBtn = widget.newButton{
		textOnly=true,
		label="restart",
		labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=300, height=100,
		onRelease = onRestartBtnRelease	-- event listener function
	}

	restartBtn.x = display.contentCenterX
	restartBtn.y = display.contentCenterY*1.3

	display.remove(score)
  display.remove(record)

	time = display.newText( "score: " .. actualScore, display.contentCenterX, display.contentCenterY, native.systemFont, 50 )
	 time:setFillColor( 0, 0, 0 )
	 composer.setVariable( "finalScore", actualScore )
    result = display.newText( "record: " .. actualRecord, display.contentCenterX, display.contentCenterY*1.15, native.systemFont, 15 )
   result:setFillColor( 0, 0, 0 )

	 if actualScore>actualRecord then
		 result.text="newRecord: "..actualScore.."!"
		 composer.setVariable( "record", actualScore )


	 end

pauseBtn:toBack()





end
local function onOkBtnRelease()
	audio.play(click )

	physics.start()


	timer.resume( timerNewBird )
	background:addEventListener("touch", shift)
display.remove(fog)
background:remove( okBtn )

backBtn:toFront()
backBtn:setEnabled(true)




pauseBtn:toFront()
pauseBtn:setEnabled(true)



end

local function enterFrame(event)

	if not balloon.getLinearVelocity then return false end


vx,vy=balloon:getLinearVelocity()
if vy>=-velocity then
	vy=vy-(vy+velocity)/20
balloon:setLinearVelocity(0,vy)
else
	balloon:setLinearVelocity(0,-velocity)

end
for i=1, birdg.numChildren do
	if birdg[i].sequence=="flyToRight"    then
		-- birdg[i]:setSequence( "flyToRight" )
	birdg[i]:setLinearVelocity(velocity,0)

else
	-- birdg[i]:setSequence( "flyToLeft" )

	birdg[i]:setLinearVelocity(-velocity,0)

end
end
if -(balloon.y-halfH)/100>actualScore then
	score.text = -((balloon.y-halfH)/100-(balloon.y-halfH)%100/100)
	actualScore=-((balloon.y-halfH)/100-(balloon.y-halfH)%100/100)
else
	score.text=actualScore
end

	-- recycle old buildings (pass 1)
		for i = 1, cloudg.numChildren do
			local y = cloudg[i].y 
			if y > balloon.y+display.actualContentHeight then
				


				cloudg[i]:translate(0, math.random(display.actualContentHeight,display.actualContentHeight*2)*-2) --math.random(display.actualContentWidth), math.random(display.actualContentHeight)*-2
        cloudg[i].x=math.random(0, display.actualContentWidth)
			end
		end

		for i=1, birdg.numChildren do
if not birdg[i]==nil then
			if birdg[i].y> balloon.y+display.actualContentHeight then
        display.remove( birdg[i] )
			 birdg:remove(birdg[i])
			 birdg[i]=nil
		 end
	 end
 end
 if actualScore>=actualRecord then
	 bestScore()
 end
	
velocity=velocity+(actualScore/500)
move=velocity/70
	-- easiest way to scroll a map based on a character
	-- find the difference between the hero and the display center
	-- and move the world to compensate
	local hx, hy = balloon:localToContent(0,0)
	hx, hy = display.contentCenterX - hx, display.contentCenterY*1.3 - hy
	world.y = world.y + hy


end
local function newBird(event)
	audio.play(tweet, {channel=1})
	birds.new(birdg, (math.random(1,2)-1)*screenW, math.random(balloon.y-display.actualContentHeight/2,balloon.y))
	timerNewBird=timer.performWithDelay( math.random(1,4)*500, newBird )

end



function scene:show( event )
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		-- Called when the scene is now on screen

		physics.start()
		physics.setGravity(0,5)
		physics.addBody( grass,"static", {  density=0.1, friction=0.1, bounce=0.2 } ) --{ density=1.0, friction=1, bounce=0.3 }

		physics.addBody( balloon, "dynamic", { radius=15, density=0.1, friction=0.1, bounce=0.2 } ) --{ density=1.0, friction=1, bounce=0.3 }


 
		Runtime:addEventListener("enterFrame", enterFrame)
		finger:addEventListener("touch", shift)
		timerNewBird=timer.performWithDelay( math.random(1,2)*1500, newBird )
		balloon.collision=onCollisionBalloon
		balloon:addEventListener("collision")

		if tutorial[1] then

			fog=display.newImageRect( "tutorial.png", display.actualContentWidth, display.actualContentHeight )
			fog.anchorX = 0
			fog.anchorY = 0
			fog.x = 0 + display.screenOriginX
			fog.y = 0 + display.screenOriginY
			fog:setFillColor(0.5,0.5,0.5)
			fog.alpha=0.4
				finger:removeEventListener("touch", shift)
			timer.pause(timerNewBird)
		physics.pause()
		pauseBtn:toBack()
		pauseBtn:setEnabled(false)

		backBtn:toBack()
		backBtn:setEnabled(false)


		okBtn= widget.newButton{
			textOnly=true,
			label="ok!",
			labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
			default="button.png",
			over="button-over.png",
			width=200, height=50,
			onRelease = onOkBtnRelease	-- event listener function
		}
		okBtn.x = display.contentCenterX
		okBtn.y = display.contentCenterY
		background:insert( okBtn )




	loadTutorial()
table.insert( tutorial, 1, false )
saveTutorial()

		end
	end
end

function scene:hide( event )

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		timer.cancel(timerNewBird)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		
	end

end

function scene:destroy( event )
	if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
		pauseBtn:removeSelf()	-- widgets must be manually removed
		pauseBtn = nil
	end
	-- Called prior to the removal of scene's "view" (sceneGroup)
	
	audio.dispose(tweet)
	tweet=nil
	audio.dispose( pop )
	audio.dispose( click )
	click=nil
	pop=nil

	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
