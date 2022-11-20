-- Variables
local Config = require(game.ReplicatedStorage.Configuration).Main
local Main = script.Parent.FindUsername.Background2.Background1.Front
local Continue = Main.Continue
local Username = Main.Username
local UserTextBox = Username.TextBox
local close = script.Parent.FindUsername.Close
local close2 = script.Parent.Ordering.Close
local players = game:GetService("Players")
-- Darker Color
local function GetColorDelta(Color : Color3, Delta : number)
	local H,S,V = Color:ToHSV()
	return Color3.fromHSV(H,S,V+(Delta/255))
end
--Getting the username from the part username
function GFNFPN(PN)
	local foundPlr = nil
	local plrs = players:GetPlayers()
	-- Looping through the players
	for i = 1, #plrs do
		local current = plrs[i]
		-- Subbing their name
		if string.lower(current.Name):sub(1, #PN) == string.lower(PN) then
			foundPlr = current.Name
			break
		else
			foundPlr = "nil"
		end
	end
	return foundPlr
end
function SetSystemColor()
	-- Setting all the colors to matching colors
	for i, v in pairs(script.Parent.FindUsername:GetDescendants()) do
		if v.Name == "Background1" then
			v.BackgroundColor3 = Config.SystemColor
		end
		if v.Name == "Background2" then
			v.BackgroundColor3 = GetColorDelta(Config.SystemColor, -35)
		end
		if v:IsA("TextLabel") and v.Parent.Name == "Front" then	
			v.TextColor3 = Config.SystemColor
		end
		if v:IsA("TextBox") then	
			v.TextColor3 = Config.SystemColor
			v.PlaceholderColor3 = Config.SystemColor
		end
		if v:IsA("ImageButton") and v.Name == "Continue" then
			v.ImageColor3 = Config.SystemColor
		end
		if v.Name == "TextContinue" then
			v.TextColor3 = Config.SystemColor
		end
		if v.Name == "GroupName" then
			v.Text = game:GetService("GroupService"):GetGroupInfoAsync(Config.GroupId).Name
		end
		if v.Name == "Motto" then
			v.Text = '"'..Config.BottomText..'"'
		end
		if v.Name == "Frame" then
			v.BackgroundColor3 = Config.SystemColor
		end
		if v.Name == "Top" then
			v.Text = "Hello "..game.Players.LocalPlayer.Name..","
		end
	end
	-- Looping through all decedents in that parent
	for i,v in pairs(script.Parent.Ordering:GetDescendants()) do
		if v.Name == "LoadingCircle" then
			v.ImageColor3 = Config.SystemColor
		end
		if v.Name == "Background1" then
			v.BackgroundColor3 = Config.SystemColor
		end
		if v.Name == "Background2" then
			v.BackgroundColor3 = GetColorDelta(Config.SystemColor, -35)
		end
		if v.Name == "GroupName" then
			v.Text = game:GetService("GroupService"):GetGroupInfoAsync(Config.GroupId).Name
		end
		if v.Name == "Motto" then
			v.Text = '"'..Config.BottomText..'"'
		end
		if v.Name == "Load" then
			v.TextColor3 = Config.SystemColor
		end
		if v.Name == "Template" and v:IsA("TextLabel") and v.Parent.Name == "Items" then
			v.TextColor3 = Config.SystemColor
			v.Frame.BackgroundColor3 = Config.SystemColor
			v.Add.ImageColor3 = Config.SystemColor 
		end
		if v.Name == "Template" and v:IsA("ImageButton") then
			v.ImageColor3 = Config.SystemColor
			v.TextContinue.TextColor3 = Config.SystemColor
		end
	end	
end
function setUpOrderingSystem()
	SetSystemColor()
	-- Checking if player exists & tweening
	script.Parent.FindUsername:TweenPosition(UDim2.fromScale(0,0), "Out", "Back", 0.5)
	UserTextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if players:FindFirstChild(GFNFPN(UserTextBox.Text)) then
			Username.Text = GFNFPN(UserTextBox.Text)
		else
			Username.Text = ""
		end
		if UserTextBox.Text == "" or UserTextBox.Text == " " then
			Username.Text = ""
		end	
	end)
	-- Closing animations
	close.MouseButton1Click:Connect(function()
		script.Parent.FindUsername:TweenPosition(UDim2.fromScale(1.1, 0), "In", "Back", 0.5)
		wait(1)
		game.ReplicatedStorage.OrderingSystemHandler:FireServer("Destroy")
	end)
	close2.MouseButton1Click:Connect(function()
		script.Parent.Ordering:TweenPosition(UDim2.fromScale(1.1, 0), "In", "Back", 0.5)
		wait(1)
		game.ReplicatedStorage.OrderingSystemHandler:FireServer("Destroy")
	end)
	--Setting more variables
	local orderCount = script.Parent.Ordering.Background2.Background1.OrderCount
	local maxItems = Config.OrderLimit
	local currentItems = 0
	--Proceeding with the ordering and imputting the items from the config script
	script.Parent.Ordering.Continue.MouseButton1Click:Connect(function()
		if currentItems > 0 then
			local dasdasdsad = {}
			-- Putting the instances in a table
			for i, item in pairs(script.Parent.Ordering.Background2.Background1.Order:GetChildren()) do
				if item:IsA("TextLabel") and item.Name ~= "Template" then
					table.insert(dasdasdsad,i, item.Text)
				end
			end
			-- Tween out
			script.Parent.Ordering:TweenPosition(UDim2.fromScale(1.1, 0), "In", "Back", 0.5)
			wait(1)
			--Firing the server
			game.ReplicatedStorage.OrderingSystemHandler:FireServer("Destroy")
			game.ReplicatedStorage.OrderingSystemHandler:FireServer("CompletedOrder", dasdasdsad)
		end		
	end)
	--When the player clicks the continue button
	Continue.MouseButton1Click:Connect(function()
		if players:FindFirstChild(Username.Text) then
			--Fading
			for i = 1, 100, 3 do
				Main.Continue.ImageTransparency = i/100
				Main.Question.TextTransparency = i/100
				Main.Top.TextTransparency = i/100
				Main.Username.TextTransparency = i/100
				Main.Continue.TextContinue.TextTransparency = i/100
				Main.Top.Frame.BackgroundTransparency = i/100
				Main.Username.TextBox.TextTransparency = i/100
				wait(0.01)
			end
			script.Parent.FindUsername.Visible = false
			script.Parent.Ordering.Visible = true
			--Fading
			for i = 100, 1, -3 do
				script.Parent.Ordering.Background2.Background1.Front.LoadingCircle.ImageTransparency = i/100
				script.Parent.Ordering.Background2.Background1.Front.Load.TextTransparency = i/100
				wait(0.01)
			end
			wait(2)		
			--Fading	
			for i = 1, 100, 3 do
				script.Parent.Ordering.Background2.Background1.Front.Load.TextTransparency = i/100
				script.Parent.Ordering.Background2.Background1.Front.LoadingCircle.ImageTransparency = i/100
				wait(0.01)
			end
			--Setting the values
			orderCount.Text = currentItems.."/"..maxItems
			-- Cloning via config script
			for i, v in pairs(Config["Main Entrees"]) do
				local clone = script.Parent.Ordering.Background2.Background1.Front.Categories.Template:Clone()
				clone.Name = i
				clone.TextContinue.Text = i
				clone.Parent = script.Parent.Ordering.Background2.Background1.Front.Categories
				clone.Visible = true
			end
			--Fading
			for i = 100, 1, -3 do
				script.Parent.Ordering.Close.ImageTransparency = i/100
				script.Parent.Ordering.Close.X.TextTransparency = i/100
				script.Parent.Ordering.Continue.ImageTransparency = i/100
				script.Parent.Ordering.Continue.TextContinue.TextTransparency = i/100
				orderCount.TextTransparency = i/100
				--Setting each category to be equal on fade
				for _,v in pairs(script.Parent.Ordering.Background2.Background1.Front.Categories:GetChildren()) do
					if v:IsA("ImageButton") and v.Name ~= "Template" then
						v.ImageTransparency = i/100
						v.TextContinue.TextTransparency = i/100
					end
				end
				wait(0.01)
			end
			--Looping through each category
			for _,v in pairs(script.Parent.Ordering.Background2.Background1.Front.Categories:GetChildren()) do
				if v:IsA("ImageButton") and v.Name ~= "Template" then
					v.MouseButton1Click:Connect(function()
						--Setting color value
						v.ImageColor3 = GetColorDelta(Config.SystemColor, -40)
						--Destroying all the frames
						for dnas, fhsdjk in pairs(script.Parent.Ordering.Background2.Background1.Front.Items:GetChildren()) do
							if fhsdjk:IsA("TextLabel") and fhsdjk.Name ~= "Template" then
								fhsdjk:Destroy()
							end
						end
						--Looping through the items in the config script
						for number, item in pairs(Config["Main Entrees"][v.Name]) do
							-- Cloning the categories
							local clone = script.Parent.Ordering.Background2.Background1.Front.Items.Template:Clone()
							clone.Name = item
							clone.Text = item
							clone.Parent = script.Parent.Ordering.Background2.Background1.Front.Items
							clone.Visible = true
							clone.Add.MouseButton1Click:Connect(function()
								if currentItems <= maxItems-1 then
									--Cloning the order template & setting values
									local newClone = script.Parent.Ordering.Background2.Background1.Order.Template:Clone()
									newClone.Name = clone.Name
									newClone.Text = clone.Name
									newClone.Parent = script.Parent.Ordering.Background2.Background1.Order
									newClone.Visible = true
									currentItems += 1
									orderCount.Text = currentItems.."/"..maxItems
									-- More fade
									for i=100, 1, -3 do
										newClone.TextTransparency = i/100
										newClone.Frame.BackgroundTransparency = i/100
										newClone.Add.ImageTransparency = i/100
										newClone.Add.TextLabel.TextTransparency = i/100
										wait()
									end
									--Click function
									newClone.Add.MouseButton1Click:Connect(function()
										currentItems -= 1
										orderCount.Text = currentItems.."/"..maxItems
										--Making it fade
										for i=0, 100, 3 do
											newClone.TextTransparency = i/100
											newClone.Frame.BackgroundTransparency = i/100
											newClone.Add.ImageTransparency = i/100
											newClone.Add.TextLabel.TextTransparency = i/100
											wait()
										end
										newClone:Destroy()
									end)
								end
							end)
						end
					end)
				end
			end
		end		
	end)
end
--Startting it all up
setUpOrderingSystem()
