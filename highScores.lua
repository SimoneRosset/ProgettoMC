local composer = require( "composer" )

local scene = composer.newScene()
local widget = require "widget"
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local clouds = require "cloud"
local balloon = require "balloon"
local corda={}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


-- Initialize variables
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

-- create()
local function gotoMenu()
  physics.stop()

  composer.removeScene( "highScores" )

    composer.gotoScene( "menu", { time=400, effect="fade" } )
end
function scene:create( event )

    local sceneGroup = self.view


    -- Code here runs when the scene is first created but has not yet appeared on screen
    -- Load the previous scores
        loadScores()
        -- Insert the saved score from the last game into the table, then reset it
   table.insert( scoresTable, composer.getVariable( "finalScore" ) )
   composer.setVariable( "finalScore", 0 )
   -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
        

    end
    table.sort( scoresTable, compare )
    -- Save the scores
    saveScores()
    composer.setVariable( "record", scoresTable[1] )


    local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
   background.x = display.contentCenterX
   background.y = display.contentCenterY
   background:setFillColor( 0.7)

   grass = display.newImageRect( sceneGroup, "ground.png", screenW, screenH)
  grass.anchorX = 0
  grass.anchorY = 1
  --  draw the grass at the very bottom of the screen
  grass.x, grass.y = display.screenOriginX, display.actualContentHeight*1.8 + display.screenOriginY
   grass.alpha=0.7
   for _=1,3 do
     clouds.new(sceneGroup, math.random(display.actualContentWidth), math.random(0, display.actualContentHeight/4.5))

   end
   local highScoresHeader = display.newText( sceneGroup, "highScores:", display.contentCenterX, 50, native.systemFont, 44 )
   highScoresHeader:setFillColor(0,0,0)
   for i = 1, 3 do
           if ( scoresTable[i] ) then
               local yPos = 60 + ( i * 56 )

               local rankNum = display.newText( sceneGroup, i .. ") ".. scoresTable[i], display.contentCenterX, yPos, native.systemFont, 30 )
                   rankNum:setFillColor( 0 )
                   -- rankNum.anchorX = 0


           end
       end

       local function onBackBtnRelease()
       	-- go to game.lua scene
        physics.stop()
       	composer.removeScene( "highScores")
       	composer.gotoScene( "menu", "fade", 400 )

       	return true	-- indicates successful touch
       end

       local backBtn = widget.newButton{
         label="back",
         labelColor = { default={ 0, 0, 0 }, over={ 1, 1, 1, 1 } },
         default="button.png",
         over="button-over.png",
         width=154, height=40,
         onRelease = onBackBtnRelease	-- event listener function
       }
       backBtn.x = display.contentCenterX*0.2
       backBtn.y = display.contentCenterY-display.contentCenterY*1.1
       sceneGroup:insert( backBtn )

       local balloon=balloon.new(sceneGroup, display.contentCenterX,  display.contentCenterY*1.3)
     	balloon.alpha=0.7
     -- for i=1,20 do
     	corda=display.newImageRect( sceneGroup, "corda.png", 2,grass.y-grass.height-balloon.y)
     -- 	physics.addBody( corda[i], "static" )
     --
     -- end
     corda.x,corda.y=balloon.x,balloon.y*1.23
     corda.alpha=0.7

     -- rope=physics.newJoint( "pivot", balloon, corda[1],0,2,0,2)
     --
     balloon:toFront()
     -- for i=2,#corda do
     -- 	corda[i].x,corda[i].y=corda[i-1].x,corda[i-1].y+4
     -- 	rope=physics.newJoint( "pivot", corda[i-1], corda[i],0,2,0,2)
     --
     -- end
       -- graph=display.newGroup()
       -- sceneGroup:insert(graph)
       -- graph:insert(grass)
       -- graph:insert(balloon)
       -- graph:insert(grass)

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)





    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen


    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        physics.stop()
        composer.removeScene( "highScores" )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen


    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view


end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
