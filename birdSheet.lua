--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:cb100a9f0e443be4b1c7480752cd119e:9ce256d14ad36deeaa51c6cce856087b:9feadb688cda4c8b3252c2d455a26ec6$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- bird01
            x=1,
            y=1,
            width=700,
            height=700,

        },
        {
            -- bird02
            x=703,
            y=1,
            width=700,
            height=700,

        },
        {
            -- bird03
            x=1405,
            y=1,
            width=700,
            height=700,

        },
        {
            -- bird04
            x=2107,
            y=1,
            width=700,
            height=700,

        },
    },
    
    sheetContentWidth = 2808,
    sheetContentHeight = 702
}

SheetInfo.frameIndex =
{

    ["bird01"] = 1,
    ["bird02"] = 2,
    ["bird03"] = 3,
    ["bird04"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
