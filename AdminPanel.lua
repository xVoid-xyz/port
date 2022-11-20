local ActionList = script.Parent.Actions
local config = require(game.ReplicatedStorage.ConfigurationAdminPanel)
-- Search function
function searchList(List, p)
	for i, v in pairs(List) do
		if v == p then
			return v
		end
	end 
end
--Runs to update the player list
function updatePlayerList()
--Destroy the labels
	for i, label in pairs(script.Parent.Ban_UnBan_Kick.PlayerList:GetChildren()) do
		if label:IsA("TextButton") and label.Name ~= "Template" then
			label:Destroy()
		end
	end	
  -- Make a new template for each player in game
	for i=0, game.Players.MaxPlayers do
		local clone = script.Parent.Ban_UnBan_Kick.PlayerList.Template:Clone()
		clone.Parent = script.Parent.Ban_UnBan_Kick.PlayerList
	end
  -- Color/Change the UI
	for i, v in pairs(script.Parent.Ban_UnBan_Kick.PlayerList:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Down:Connect(function()
				for i2, v2 in pairs(script.Parent.Ban_UnBan_Kick.PlayerList:GetChildren()) do
					if v2:IsA("TextButton") then
						v2.BackgroundColor3 = Color3.fromRGB(255,255,255)
					end					
				end
				v.BackgroundColor3 = Color3.fromRGB(170, 255, 127)
				script.Parent.Ban_UnBan_Kick.PlayerName.Text = v.Name or v.Text
				local players = game:GetService("Players")
				script.Parent.Ban_UnBan_Kick.Avatar.Image = players:GetUserThumbnailAsync(players[v.Name].UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
			end)
		end
	end
end
-- Just to set everything back
function setAllBack()
	script.Parent.Ban_UnBan_Kick.Reason.Text = ""
	script.Parent.Ban_UnBan_Kick.Duration.Text = ""
	script.Parent.Ban_UnBan_Kick.Avatar.Image = ""
	script.Parent.Ban_UnBan_Kick.PlayerName.Text = ""
	script.Parent.Ban_UnBan_Kick.Unban.Text = ""
end
--Set up the ban function
function SetUpAction_BAN_etc(Action)
-- Make it all invisible
	for _, v in pairs(script.Parent:GetChildren()) do
		if v:IsA("Frame") then
			v.Visible = false
		end
	end
	script.Parent.Ban_UnBan_Kick.Visible = true
	setAllBack()
	local BUK = script.Parent.Ban_UnBan_Kick
	BUK.Visible = true
	BUK.TITLE_ActionType.Text = Action
	if Action ~= "Ban" then
		BUK.Duration.Visible = false
		script.Parent.Ban_UnBan_Kick.PlayerList.Visible = true
		script.Parent.Ban_UnBan_Kick.PlayerName.Visible = true
		script.Parent.Ban_UnBan_Kick.Unban.Visible = false
	else
		BUK.Duration.Visible = true
		script.Parent.Ban_UnBan_Kick.PlayerList.Visible = true
		script.Parent.Ban_UnBan_Kick.PlayerName.Visible = true
		script.Parent.Ban_UnBan_Kick.Unban.Visible = false
	end
	if Action == "Unban" then
		script.Parent.Ban_UnBan_Kick.PlayerList.Visible = false
		script.Parent.Ban_UnBan_Kick.PlayerName.Visible = false		
		script.Parent.Ban_UnBan_Kick.Unban.Visible = true
	end
  -- Update ther player list every second
	while wait(1) do	
		updatePlayerList()
		for i, label in pairs(script.Parent.Ban_UnBan_Kick.PlayerList:GetChildren()) do
			if label:IsA("TextButton") then
      -- Whoever is not on the list that is new should be added
				for _, player in pairs(game.Players:GetPlayers()) do				
					if not script.Parent.Ban_UnBan_Kick.PlayerList:FindFirstChild(player.Name) then
						label.Text = player.Name
						label.Name = player.Name
						label.Visible = true
					end				
				end		
			end		
		end
	end
end
-- The announcements function
function setUpAnnouncement()
-- Make it all invisible
	for _, v in pairs(script.Parent:GetChildren()) do
		if v:IsA("Frame") then
			v.Visible = false
		end
	end
	script.Parent.Announce.Visible = true
  -- The click function
	script.Parent.Announce.Submit.MouseButton1Click:Connect(function()
		if script.Parent.Announce.TextBox.Text ~= "" then
			game.ReplicatedStorage.AnnouncementSystem:FireServer(script.Parent.Announce.TextBox.Text)
		end		
	end)
end
-- Setting up the teleport function
function setUpTeleport()
--Make it all invisible
	for _, v in pairs(script.Parent:GetChildren()) do
		if v:IsA("Frame") then
			v.Visible = false
		end
	end
	script.Parent.Teleport.Visible = true
	script.Parent.Teleport.TITLE_ActionType.Text = "Teleport Function"
  --Some more click fuctions
	script.Parent.Teleport.ToBtn.MouseButton1Click:Connect(function()
		script.Parent.Teleport.ToBtn.BackgroundColor3 = Color3.fromRGB(170, 255, 127)
		script.Parent.Teleport.BringBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
	script.Parent.Teleport.BringBtn.MouseButton1Click:Connect(function()
		script.Parent.Teleport.BringBtn.BackgroundColor3 = Color3.fromRGB(170, 255, 127)
		script.Parent.Teleport.ToBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
	script.Parent.Teleport.Done.MouseButton1Click:Connect(function()
		if script.Parent.Teleport.PlayerName.Text ~= "" and script.Parent.Teleport.Reason.Text ~= "" then
			if script.Parent.Teleport.ToBtn.BackgroundColor3 == Color3.fromRGB(170, 255, 127) then
				game.ReplicatedStorage.TeleprtFn:FireServer("To", script.Parent.Teleport.PlayerName.Text, script.Parent.Teleport.Reason.Text)
				script.Parent.Teleport.Reason.Text = ""
				script.Parent.Teleport.ToBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
				script.Parent.Teleport.BringBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
				script.Parent.Teleport.Avatar.Image = ""
				script.Parent.Teleport.PlayerName.Text = ""
			end
			if script.Parent.Teleport.BringBtn.BackgroundColor3 == Color3.fromRGB(170, 255, 127) then
				game.ReplicatedStorage.TeleprtFn:FireServer("Bring", script.Parent.Teleport.PlayerName.Text, script.Parent.Teleport.Reason.Text)
				script.Parent.Teleport.Reason.Text = ""
				script.Parent.Teleport.ToBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
				script.Parent.Teleport.BringBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
				script.Parent.Teleport.Avatar.Image = ""
				script.Parent.Teleport.PlayerName.Text = ""
			end
		end
	end)
  --Update every second
	while wait(1) do	
		for i, label in pairs(script.Parent.Teleport.PlayerList:GetChildren()) do
			if label:IsA("TextButton") and label.Name ~= "Template" then
				label:Destroy()
			end
		end	
		for i=0, game.Players.MaxPlayers do
			local clone = script.Parent.Teleport.PlayerList.Template:Clone()
			clone.Parent = script.Parent.Teleport.PlayerList
		end
		for i, v in pairs(script.Parent.Teleport.PlayerList:GetChildren()) do
			if v:IsA("TextButton") then
				v.MouseButton1Down:Connect(function()
					for i2, v2 in pairs(script.Parent.Teleport.PlayerList:GetChildren()) do
						if v2:IsA("TextButton") then
							v2.BackgroundColor3 = Color3.fromRGB(255,255,255)
						end					
					end
					v.BackgroundColor3 = Color3.fromRGB(170, 255, 127)
					script.Parent.Teleport.PlayerName.Text = v.Name or v.Text
					local players = game:GetService("Players")
					script.Parent.Teleport.Avatar.Image = players:GetUserThumbnailAsync(players[v.Name].UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
				end)
			end
		end
		for i, label in pairs(script.Parent.Teleport.PlayerList:GetChildren()) do
			if label:IsA("TextButton") then
				for _, player in pairs(game.Players:GetPlayers()) do				
					if not script.Parent.Teleport.PlayerList:FindFirstChild(player.Name) then
						label.Text = player.Name
						label.Name = player.Name
						label.Visible = true
					end				
				end		
			end		
		end
	end
end
-- Tools function
function setUpTools()
--Make it all invisible
	for _, v in pairs(script.Parent:GetChildren()) do
		if v:IsA("Frame") then
			v.Visible = false
		end
	end
	script.Parent.GiveTools.Visible = true
	script.Parent.GiveTools.TITLE_ActionType.Text = "Tools Giver"
	for _,v in pairs(game.ReplicatedStorage.Tools:GetChildren()) do
		if v:IsA("Tool") then
			local clone = script.Parent.GiveTools.Tools.Template:Clone()
			clone.Parent = script.Parent.GiveTools.Tools
		end
	end
  --Going through the tools for checking
	for i, label in pairs(script.Parent.GiveTools.Tools:GetChildren()) do
		if label:IsA("TextButton") then
			for i, v in pairs(game.ReplicatedStorage.Tools:GetChildren()) do	
				if not script.Parent.GiveTools.Tools:FindFirstChild(v.Name) then
					label.Text = v.Name
					label.Name = v.Name
					label.Visible = true
				end							
			end		
		end		
	end
	for i, v in pairs(script.Parent.GiveTools.Tools:GetChildren()) do
		if v:IsA("TextButton") then
    -- Click function
			v.MouseButton1Down:Connect(function()
				for i2, v2 in pairs(script.Parent.GiveTools.Tools:GetChildren()) do
					if v2:IsA("TextButton") then
						v2.BackgroundColor3 = Color3.fromRGB(255,255,255)						
					end					
				end
				v.BackgroundColor3 = Color3.fromRGB(170, 255, 127)
				script.Parent.GiveTools.Tool.Text = v.Name
				script.Parent.GiveTools.Tool.Text = v.Name or v.Text
			end)
		end
	end
  -- Set back
	script.Parent.GiveTools.Done.MouseButton1Click:Connect(function()
		if script.Parent.GiveTools.Reason.Text ~= "" and script.Parent.GiveTools.Tool.Text ~= "" and script.Parent.GiveTools.PlayerName.Text ~= "" then
			game.ReplicatedStorage.GiveTools:FireServer(script.Parent.GiveTools.PlayerName.Text, script.Parent.GiveTools.Reason.Text, script.Parent.GiveTools.Tool.Text)
			script.Parent.GiveTools.Avatar.Image = ""
			script.Parent.GiveTools.PlayerName.Text = ""
			script.Parent.GiveTools.Tool.Text = ""
			script.Parent.GiveTools.Reason.Text = ""
			for i, v in pairs(script.Parent.GiveTools.Tools:GetChildren()) do
				if v:IsA("TextButton") then
					v.BackgroundColor3 = Color3.new(255,255,255)
				end
			end
		end		
	end)
  --Go through the tools every second
	while wait(1) do	
		for i, label in pairs(script.Parent.GiveTools.PlayerList:GetChildren()) do
			if label:IsA("TextButton") and label.Name ~= "Template" then
				label:Destroy()
			end
		end	
		for i=0, game.Players.MaxPlayers do
			local clone = script.Parent.GiveTools.PlayerList.Template:Clone()
			clone.Parent = script.Parent.GiveTools.PlayerList
		end
		for i, v in pairs(script.Parent.GiveTools.PlayerList:GetChildren()) do
			if v:IsA("TextButton") then
				v.MouseButton1Down:Connect(function()
					for i2, v2 in pairs(script.Parent.GiveTools.PlayerList:GetChildren()) do
						if v2:IsA("TextButton") then
							v2.BackgroundColor3 = Color3.fromRGB(255,255,255)
						end					
					end
					v.BackgroundColor3 = Color3.fromRGB(170, 255, 127)
					script.Parent.GiveTools.PlayerName.Text = v.Name or v.Text
					local players = game:GetService("Players")
					script.Parent.GiveTools.Avatar.Image = players:GetUserThumbnailAsync(players[v.Name].UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
				end)
			end
		end
		for i, label in pairs(script.Parent.GiveTools.PlayerList:GetChildren()) do
			if label:IsA("TextButton") then
				for _, player in pairs(game.Players:GetPlayers()) do				
					if not script.Parent.GiveTools.PlayerList:FindFirstChild(player.Name) then
						label.Text = player.Name
						label.Name = player.Name
						label.Visible = true
					end				
				end		
			end		
		end
	end
end
-- When recieved from the server
game.ReplicatedStorage.AnnouncementSystem.OnClientEvent:Connect(function(senderName, msg)
	script.Parent.Parent.Announcement.Text = senderName..": "..msg
	script.Parent.Parent.Announcement:TweenPosition(UDim2.new(0.249, 0,0.05, 0), "In", "Sine", 1.5)
	wait(7)
	script.Parent.Parent.Announcement:TweenPosition(UDim2.new(0.249, 0,-2.4, 0), "In", "Sine", 1.5)
end)
script.Parent.Ban_UnBan_Kick.Done.MouseButton1Click:Connect(function()
	if script.Parent.Ban_UnBan_Kick.Reason.Text ~= "" and script.Parent.Ban_UnBan_Kick.Avatar.Image ~= "" and script.Parent.Ban_UnBan_Kick.TITLE_ActionType ~= "" and script.Parent.Ban_UnBan_Kick.PlayerName.Text ~= "" and script.Parent.Ban_UnBan_Kick.TITLE_ActionType.Text ~= "Unban" then
		game.ReplicatedStorage.BUK:FireServer(script.Parent.Ban_UnBan_Kick.TITLE_ActionType.Text, script.Parent.Ban_UnBan_Kick.Duration.Text, script.Parent.Ban_UnBan_Kick.Reason.Text, script.Parent.Ban_UnBan_Kick.PlayerName.Text)
		setAllBack()
	end
	if script.Parent.Ban_UnBan_Kick.Reason.Text ~= "" and script.Parent.Ban_UnBan_Kick.TITLE_ActionType ~= "" and script.Parent.Ban_UnBan_Kick.TITLE_ActionType.Text == "Unban" then
		game.ReplicatedStorage.BUK:FireServer(script.Parent.Ban_UnBan_Kick.TITLE_ActionType.Text, script.Parent.Ban_UnBan_Kick.Duration.Text, script.Parent.Ban_UnBan_Kick.Reason.Text, script.Parent.Ban_UnBan_Kick.Unban.Text)
		setAllBack()
		warn("fired")
	end
end)
-- All the click functions for the main display
ActionList.UNBAN.MouseButton1Click:Connect(function()
	SetUpAction_BAN_etc("Unban")
end)
ActionList.BAN.MouseButton1Click:Connect(function()
	SetUpAction_BAN_etc("Ban")
end)
ActionList.KICK.MouseButton1Click:Connect(function()
	SetUpAction_BAN_etc("Kick")
end)
ActionList.ANNOUNCE.MouseButton1Click:Connect(function()
	setUpAnnouncement()
end)
ActionList.TP.MouseButton1Click:Connect(function()
	setUpTeleport()
end)
ActionList.GT.MouseButton1Click:Connect(function()
	setUpTools()
end)
local o = true
-- Just an open/close function
script.Parent.Parent.TextButton.MouseButton1Click:Connect(function()
	if o == true then
		script.Parent.Visible = true
		script.Parent:TweenPosition(UDim2.new(0.267, 0,0.263, 0), "In", "Sine", 1.5)
		o = false
	else
		script.Parent:TweenPosition(UDim2.new(0.267, 0,-1, 0), "In", "Sine", 1.5)
		script.Parent.Visible = true
		o = true		
	end	
end)
