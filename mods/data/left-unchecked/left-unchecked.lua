function onCreatePost()
	for i = 0, 3 do--and not middlescroll then
		setPropertyFromGroup("playerStrums", i, "alpha", 0.7)
		setPropertyFromGroup("opponentStrums", i, "x", 1337)	
	end
end