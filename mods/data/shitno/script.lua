function onCountdownStarted()
    setProperty('skipCountdown',true)
end

local cases = {
	[88] = function()
		triggerEvent("Play Animation", "talk", "BF")
	end,
	[416] = function()
		triggerEvent("Change Character", "BF", "Grey")
        triggerEvent("Play Animation", "turn", "BF", true)
        runTimer("gayturn", 0.86, 1)
        runTimer("becomehot", 2.06, 1)
	end,
	[563] = function()
		triggerEvent("Play Animation", "talk", "BF")
	end,
	[2055] = function()
		triggerEvent("Play Animation", "talk2", "BF")
	end
}

function onCreate()
	setProperty('boyfriendCameraOffset', {0, -145})
	setProperty("camGame.alpha", 0)
	setProperty("dad.alpha", 0.0001)
	cameraSetTarget("boyfriend")
	setProperty("ground.alpha", 0.0001)

	addLuaSprite('custom_events/HideOppNotes.lua')
end

function onCreatePost()
	setProperty("iconP2.visible", false)
end

function onStepHit()
	if cases[curStep] then cases[curStep]() end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "gayturn" then
        doTweenX("slide", "boyfriend", getProperty("boyfriend.x") + 350, 1.2, "quadInOut")
    elseif tag == "becomehot" then
        setProperty('boyfriendCameraOffset', {-200, -195})
    end
end