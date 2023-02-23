function onCreatePost()
    makeLuaSprite('silly','',0,0)
    setObjectCamera('silly','hud')
    makeGraphic('silly',1280,720,'ffffff')
    addLuaSprite('silly',true)

    runTimer('color1',2)
end

local times = {
    ['color1'] = function()
        doTweenColor('sillycolor','silly','000000',1,'linear')
        runTimer('color2',2)
    end,
    ['color2'] = function()
        doTweenColor('sillycolor','silly','ffffff',1,'linear')
    end
}

function onTimerCompleted(tag)
    if times[tag] ~= nil then times[tag]() end
end