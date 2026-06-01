--// WAZIN GLITCH - INTERFAZ PREMIUM COMPLETA CON AUTO GET GUN
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService") 
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

pcall(function()
	if PlayerGui:FindFirstChild("WAZIN_GLITCH_BASE") then
		PlayerGui.WAZIN_GLITCH_BASE:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WAZIN_GLITCH_BASE"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- TRACKER DE ROLES (Esquinas superiores)
local MurderLabel = Instance.new("TextLabel")
MurderLabel.Name = "MurderTracker"
MurderLabel.Parent = ScreenGui
MurderLabel.Size = UDim2.new(0, 190, 0, 45)
MurderLabel.Position = UDim2.new(0, 15, 0, 15)
MurderLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MurderLabel.BackgroundTransparency = 0.65
MurderLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
MurderLabel.TextSize = 13
MurderLabel.Font = Enum.Font.GothamBold
MurderLabel.Text = "MURDER:\nBuscando..."
Instance.new("UICorner", MurderLabel).CornerRadius = UDim.new(0, 8)
local MurderLabelStroke = Instance.new("UIStroke", MurderLabel)
MurderLabelStroke.Color = Color3.fromRGB(255, 120, 120)
MurderLabelStroke.Thickness = 1.2
MurderLabelStroke.Transparency = 0.75

local SheriffLabel = Instance.new("TextLabel")
SheriffLabel.Name = "SheriffTracker"
SheriffLabel.Parent = ScreenGui
SheriffLabel.Size = UDim2.new(0, 190, 0, 45)
SheriffLabel.Position = UDim2.new(1, -205, 0, 15)
SheriffLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SheriffLabel.BackgroundTransparency = 0.65
SheriffLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
SheriffLabel.TextSize = 13
SheriffLabel.Font = Enum.Font.GothamBold
SheriffLabel.Text = "SHERIFF:\nBuscando..."
Instance.new("UICorner", SheriffLabel).CornerRadius = UDim.new(0, 8)
local SheriffLabelStroke = Instance.new("UIStroke", SheriffLabel)
SheriffLabelStroke.Color = Color3.fromRGB(120, 200, 255)
SheriffLabelStroke.Thickness = 1.2
SheriffLabelStroke.Transparency = 0.75

-- BOTÓN FLOTANTE "W"
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.Size = UDim2.new(0,70,0,70)
OpenButton.Position = UDim2.new(0,40,0,120)
OpenButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
OpenButton.BackgroundTransparency = 0.25
OpenButton.Text = "W"
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.TextSize = 28
OpenButton.Font = Enum.Font.GothamBold
OpenButton.BorderSizePixel = 0
OpenButton.AutoButtonColor = false
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1,0)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenButton
OpenStroke.Color = Color3.fromRGB(0, 215, 255)
OpenStroke.Thickness = 2
OpenStroke.Transparency = 0.3

-- PANEL PRINCIPAL
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,430,0,330)
Main.Position = UDim2.new(0.5,-215,0.5,-165)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Visible = true
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = Main
MainStroke.Color = Color3.fromRGB(0, 215, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.4

-- BOTÓN FLOTANTE AUTO SHOOT (VINCULADO A PESTAÑA PLAYER)
local ShootFloatBtn = Instance.new("TextButton")
ShootFloatBtn.Name = "ShootFloatBtn"
ShootFloatBtn.Parent = ScreenGui
ShootFloatBtn.Size = UDim2.new(0, 70, 0, 70)
ShootFloatBtn.Position = UDim2.new(0, 40, 0, 210)
ShootFloatBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ShootFloatBtn.BackgroundTransparency = 0.3
ShootFloatBtn.Text = "🎯"
ShootFloatBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ShootFloatBtn.TextSize = 30
ShootFloatBtn.Font = Enum.Font.GothamBold
ShootFloatBtn.BorderSizePixel = 0
ShootFloatBtn.AutoButtonColor = false
ShootFloatBtn.Visible = false
Instance.new("UICorner", ShootFloatBtn).CornerRadius = UDim.new(1, 0)

local ShootStroke = Instance.new("UIStroke")
ShootStroke.Parent = ShootFloatBtn
ShootStroke.Color = Color3.fromRGB(255, 50, 50)
ShootStroke.Thickness = 2
ShootStroke.Transparency = 0.4

-- MOTOR DE ARRASTRE
local function MakeButtonDraggableAndClickable(button, isShootButton)
	local dragging = false local dragInput local dragStart local startPos local dragDistance = 0
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true dragStart = input.Position startPos = button.Position dragDistance = 0
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if dragDistance < 8 then
						if isShootButton then
							local m, _ = _G.GetRolesInternal()
							local char = Player.Character
							local gun = char and (char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") or char:FindFirstChild("GoldRevolver"))
							if m and m.Character and gun then
								local targetPart = m.Character:FindFirstChild("HumanoidRootPart")
								if targetPart then
									Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
									task.wait(0.01)
									gun:Activate()
								end
							end
						else
							_G.ToggleGuiFunction()
						end
					end
				end
			end)
		end
	end)
	button.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart dragDistance = dragDistance + delta.Magnitude
			local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(button, TweenInfo.new(0.02, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
		end
	end)
end

MakeButtonDraggableAndClickable(OpenButton, false)
MakeButtonDraggableAndClickable(ShootFloatBtn, true)

local MainDragging = false local MainDragInput local MainDragStart local MainStartPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then MainDragging = true MainDragStart = input.Position MainStartPos = Main.Position end end)
Main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then MainDragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if MainDragging and MainDragInput then local delta = MainDragInput.Position - MainDragStart Main.Position = UDim2.new(MainStartPos.X.Scale, MainStartPos.X.Offset + delta.X, MainStartPos.Y.Scale, MainStartPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then MainDragging = false end end)

-- TOPBAR
local TopBar = Instance.new("Frame", Main) TopBar.Size = UDim2.new(1,0,0,45) TopBar.BackgroundTransparency = 1 TopBar.ZIndex = 5
local Title = Instance.new("TextLabel", TopBar) Title.Size = UDim2.new(0,240,0,35) Title.Position = UDim2.new(0,15,0,5) Title.BackgroundTransparency = 1 Title.Text = "WAZIN GLITCH" Title.TextColor3 = Color3.new(1,1,1) Title.TextSize = 24 Title.Font = Enum.Font.GothamBold Title.TextXAlignment = Enum.TextXAlignment.Left Title.ZIndex = 5
local Sub = Instance.new("TextLabel", TopBar) Sub.Size = UDim2.new(0,200,0,15) Sub.Position = UDim2.new(0,18,0,28) Sub.BackgroundTransparency = 1 Sub.Text = "PREMIUM MENU" Sub.TextColor3 = Color3.fromRGB(0, 215, 255) Sub.TextSize = 12 Sub.Font = Enum.Font.Gotham Sub.ZIndex = 5

local Minimize = Instance.new("TextButton", TopBar) Minimize.Size = UDim2.new(0,32,0,32) Minimize.Position = UDim2.new(1,-78,0,6) Minimize.BackgroundColor3 = Color3.fromRGB(60,60,60) Minimize.BackgroundTransparency = 0.3 Minimize.Text = "-" Minimize.TextColor3 = Color3.new(1,1,1) Minimize.TextSize = 24 Minimize.Font = Enum.Font.GothamBold Minimize.BorderSizePixel = 0 Minimize.ZIndex = 6 Instance.new("UICorner",Minimize).CornerRadius = UDim.new(1,0)
local Close = Instance.new("TextButton", TopBar) Close.Size = UDim2.new(0,32,0,32) Close.Position = UDim2.new(1,-40,0,6) Close.BackgroundColor3 = Color3.fromRGB(120,50,50) Close.BackgroundTransparency = 0.2 Close.Text = "X" Close.TextColor3 = Color3.new(1,1,1) Close.TextSize = 16 Close.Font = Enum.Font.GothamBold Close.BorderSizePixel = 0 Close.ZIndex = 6 Instance.new("UICorner",Close).CornerRadius = UDim.new(1,0)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- PESTAÑAS
local Tabs = Instance.new("Frame", Main) Tabs.Size = UDim2.new(1,-20,0,40) Tabs.Position = UDim2.new(0,10,0,55) Tabs.BackgroundTransparency = 1 Tabs.ZIndex = 5
local UIList = Instance.new("UIListLayout", Tabs) UIList.FillDirection = Enum.FillDirection.Horizontal UIList.Padding = UDim.new(0,5)

local Content = Instance.new("Frame", Main) Content.Size = UDim2.new(1,-20,1,-110) Content.Position = UDim2.new(0,10,0,100) Content.BackgroundColor3 = Color3.fromRGB(15,15,15) Content.BackgroundTransparency = 0.65 Content.BorderSizePixel = 0 Content.ZIndex = 2 Instance.new("UICorner",Content).CornerRadius = UDim.new(0,14)

-- EFECTO CÓSMICO
local function SpawnCosmicParticle()
	if not Main or not Main.Visible then return end
	local Particle = Instance.new("Frame") Particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Particle.BackgroundTransparency = 0.2 Instance.new("UICorner", Particle).CornerRadius = UDim.new(1, 0) local sizeValue = math.random(3, 6) Particle.Size = UDim2.new(0, sizeValue, 0, sizeValue)
	Particle.Parent = Main Particle.ZIndex = 1 local randomX = math.random(0, 100) / 100 Particle.Position = UDim2.new(randomX, 0, 1, 10)
	local moveTween = TweenService:Create(Particle, TweenInfo.new(math.random(25, 50) / 10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(randomX + (math.random(-20, 20) / 100), 0, math.random(-20, -5) / 100, 0), BackgroundTransparency = 1})
	moveTween:Play() moveTween.Completed:Connect(function() Particle:Destroy() end)
end
task.spawn(function() while task.wait(0.2) do if ScreenGui and ScreenGui.Parent then SpawnCosmicParticle() else break end end end)

task.spawn(function() while task.wait() do if OpenButton and OpenButton.Parent then TweenService:Create(OpenStroke, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Color = Color3.fromHSV((tick() % 5) / 5, 0.8, 1)}):Play() else break end end end)

local MainVisible = true OpenButton.Visible = false
_G.ToggleGuiFunction = function()
	MainVisible = not MainVisible
	if MainVisible then
		TweenService:Create(OpenButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
		task.wait(0.15) OpenButton.Visible = false Main.Visible = true
	else
		Main.Visible = false OpenButton.Visible = true OpenButton.Size = UDim2.new(0, 70, 0, 70) OpenButton.BackgroundTransparency = 0.25
	end
end
Minimize.MouseButton1Click:Connect(_G.ToggleGuiFunction)

local function CreateTab(Name)
	local Btn = Instance.new("TextButton", Tabs) Btn.Size = UDim2.new(0,75,0,34) Btn.BackgroundColor3 = Color3.fromRGB(55,55,55) Btn.BackgroundTransparency = 0.25 Btn.Text = Name Btn.TextColor3 = Color3.new(1,1,1) Btn.TextSize = 13 Btn.Font = Enum.Font.GothamBold Btn.BorderSizePixel = 0 Btn.ZIndex = 5 Instance.new("UICorner",Btn).CornerRadius = UDim.new(0,10)
	local Stroke = Instance.new("UIStroke", Btn) Stroke.Color = Color3.fromRGB(140,140,140) Stroke.Transparency = 0.6
	local Frame = Instance.new("Frame", Content) Frame.Size = UDim2.new(1,0,1,0) Frame.BackgroundTransparency = 1 Frame.Visible = false Frame.ZIndex = 3
	Btn.MouseButton1Click:Connect(function() for _, child in pairs(Content:GetChildren()) do if child:IsA("Frame") then child.Visible = false end end Frame.Visible = true end)
	return Btn,Frame
end

-- CREACIÓN DE LAS PESTAÑAS
local PlayerBtn, PlayerFrame = CreateTab("PLAYER")
local EspBtn, EspFrame = CreateTab("ESP")
local KnifeBtn, KnifeFrame = CreateTab("KNIFE")
local GunBtn, GunFrame = CreateTab("GUN")
local ConfiBtn, ConfiFrame = CreateTab("CONFI")
PlayerFrame.Visible = true

local function CreateTitle(Frame,Text)
	local Label = Instance.new("TextLabel", Frame) Label.Size = UDim2.new(0,200,0,30) Label.Position = UDim2.new(0,15,0,10) Label.BackgroundColor3 = Color3.fromRGB(50,50,50) Label.BackgroundTransparency = 0.3 Label.Text = Text Label.TextColor3 = Color3.new(1,1,1) Label.TextSize = 15 Label.Font = Enum.Font.GothamBold Label.BorderSizePixel = 0 Label.ZIndex = 4 Instance.new("UICorner",Label).CornerRadius = UDim.new(0,10)
end
CreateTitle(PlayerFrame,"PLAYER SETTINGS") CreateTitle(EspFrame,"ESP SETTINGS") CreateTitle(KnifeFrame,"KNIFE SETTINGS") CreateTitle(GunFrame,"GUN SETTINGS") CreateTitle(ConfiFrame,"GUI CONFIG")

local function CreateGridButton(Frame, Text, PosX, PosY)
	local Btn = Instance.new("TextButton", Frame) Btn.Size = UDim2.new(0, 185, 0, 35) Btn.Position = UDim2.new(0, PosX, 0, PosY) Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) Btn.Text = Text Btn.TextColor3 = Color3.fromRGB(255, 100, 100) Btn.TextSize = 13 Btn.Font = Enum.Font.GothamBold Btn.ZIndex = 4 Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
	return Btn
end

-- DETECTOR CORE DE ROLES
local function GetRoles()
	local foundMurder, foundSheriff = nil, nil
	for _, p in pairs(Players:GetPlayers()) do
		local mainGui = p:FindFirstChild("PlayerGui") and p.PlayerGui:FindFirstChild("MainGUI")
		if mainGui and mainGui:FindFirstChild("Game") and mainGui.Game:FindFirstChild("RoleData") then
			local rd = mainGui.Game.RoleData
			if rd:FindFirstChild("Murder") and rd.Murder:FindFirstChild(p.Name) then foundMurder = p end
			if (rd:FindFirstChild("Sheriff") and rd.Sheriff:FindFirstChild(p.Name)) or (rd:FindFirstChild("Hero") and rd.Hero:FindFirstChild(p.Name)) then foundSheriff = p end
		end
	end
	if not foundMurder or not foundSheriff then
		local knifeNames = {"Knife", "Blade", "RealKnife", "MurderKnife"}
		local gunNames = {"Gun", "Revolver", "GoldRevolver", "Pistol"}
		for _, p in pairs(Players:GetPlayers()) do
			local bpack = p:FindFirstChild("Backpack")
			local char = p.Character
			if not foundMurder then
				for _, k in pairs(knifeNames) do if (bpack and bpack:FindFirstChild(k)) or (char and char:FindFirstChild(k)) then foundMurder = p break end end
			end
			if not foundSheriff then
				for _, g in pairs(gunNames) do if (bpack and bpack:FindFirstChild(g)) or (char and char:FindFirstChild(g)) then foundSheriff = p break end end
			end
		end
	end
	return foundMurder, foundSheriff
end
_G.GetRolesInternal = GetRoles

-- ACTUALIZACIÓN DE LABELS EN VIVO
local AutoShootActive = false
RunService.Heartbeat:Connect(function()
	local m, s = GetRoles()
	if MurderLabel and MurderLabel.Parent then MurderLabel.Text = m and "MURDER:\n" .. m.Name or "MURDER:\nBuscando..." end
	if SheriffLabel and SheriffLabel.Parent then SheriffLabel.Text = s and "SHERIFF:\n" .. s.Name or "SHERIFF:\nBuscando..." end
	if s == Player and AutoShootActive then ShootFloatBtn.Visible = true else ShootFloatBtn.Visible = false end
end)

-- ==========================================================
-- PESTAÑA 1: PLAYER
-- ==========================================================
local WalkSpeedEnabled, JumpPowerEnabled, HitboxEnabled = false, false, false
local BtnWalkSpeed = CreateGridButton(PlayerFrame, "WALKSPEED : OFF", 15, 55)
local SpeedBox = Instance.new("TextBox", PlayerFrame) SpeedBox.Size = UDim2.new(0,185,0,35) SpeedBox.Position = UDim2.new(0,15,0,95) SpeedBox.BackgroundColor3 = Color3.fromRGB(30,30,30) SpeedBox.PlaceholderText = "Speed (ej: 32)" SpeedBox.Text = "32" SpeedBox.TextColor3 = Color3.new(1,1,1) SpeedBox.TextSize = 13 SpeedBox.Font = Enum.Font.GothamBold Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0,8)

local BtnJumpPower = CreateGridButton(PlayerFrame, "JUMPPOWER : OFF", 210, 55)
local JumpBox = Instance.new("TextBox", PlayerFrame) JumpBox.Size = UDim2.new(0,185,0,35) JumpBox.Position = UDim2.new(0,210,0,95) JumpBox.BackgroundColor3 = Color3.fromRGB(30,30,30) JumpBox.PlaceholderText = "JumpPower (ej: 50)" JumpBox.Text = "50" JumpBox.TextColor3 = Color3.new(1,1,1) JumpBox.TextSize = 13 JumpBox.Font = Enum.Font.GothamBold Instance.new("UICorner", JumpBox).CornerRadius = UDim.new(0,8)

local BtnShootBtn = CreateGridButton(PlayerFrame, "BOTÓN DISPARO : OFF", 15, 145)
local BtnHitbox = CreateGridButton(PlayerFrame, "HITBOX : OFF", 210, 145)
local HitboxBox = Instance.new("TextBox", PlayerFrame) HitboxBox.Size = UDim2.new(0,185,0,35) HitboxBox.Position = UDim2.new(0,210,0,185) HitboxBox.BackgroundColor3 = Color3.fromRGB(30,30,30) HitboxBox.PlaceholderText = "Tamaño Hitbox (ej: 8)" HitboxBox.Text = "8" HitboxBox.TextColor3 = Color3.new(1,1,1) HitboxBox.TextSize = 13 HitboxBox.Font = Enum.Font.GothamBold Instance.new("UICorner", HitboxBox).CornerRadius = UDim.new(0,8)

BtnWalkSpeed.MouseButton1Click:Connect(function()
	WalkSpeedEnabled = not WalkSpeedEnabled
	BtnWalkSpeed.Text = WalkSpeedEnabled and "WALKSPEED : ON" or "WALKSPEED : OFF"
	BtnWalkSpeed.TextColor3 = WalkSpeedEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
	local char = Player.Character local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = WalkSpeedEnabled and tonumber(SpeedBox.Text) or 16 end
end)

Player.CharacterAdded:Connect(function(c)
	task.wait(0.5) local h = c:WaitForChild("Humanoid", 5)
	if h and WalkSpeedEnabled then h.WalkSpeed = tonumber(SpeedBox.Text) or 32 end
	if h and JumpPowerEnabled then h.JumpPower = tonumber(JumpBox.Text) or 50 end
end)

BtnJumpPower.MouseButton1Click:Connect(function()
	JumpPowerEnabled = not JumpPowerEnabled
	BtnJumpPower.Text = JumpPowerEnabled and "JUMPPOWER : ON" or "JUMPPOWER : OFF"
	BtnJumpPower.TextColor3 = JumpPowerEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
	local char = Player.Character local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.JumpPower = JumpPowerEnabled and (tonumber(JumpBox.Text) or 50) or 50 end
end)

BtnShootBtn.MouseButton1Click:Connect(function()
	AutoShootActive = not AutoShootActive
	BtnShootBtn.Text = AutoShootActive and "BOTÓN DISPARO : ON" or "BOTÓN DISPARO : OFF"
	BtnShootBtn.TextColor3 = AutoShootActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

BtnHitbox.MouseButton1Click:Connect(function()
	HitboxEnabled = not HitboxEnabled
	BtnHitbox.Text = HitboxEnabled and "HITBOX : ON" or "HITBOX : OFF"
	BtnHitbox.TextColor3 = HitboxEnabled and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
end)

RunService.Heartbeat:Connect(function()
	local hitboxSize = tonumber(HitboxBox.Text) or 8
	for _,v in pairs(Players:GetPlayers()) do
		if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = v.Character.HumanoidRootPart
			if HitboxEnabled then 
				if hrp.Size ~= Vector3.new(hitboxSize, hitboxSize, hitboxSize) then hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize) hrp.Transparency = 0.4 hrp.CanCollide = false end
			else 
				if hrp.Size ~= Vector3.new(2, 2, 1) then hrp.Size = Vector3.new(2, 2, 1) hrp.Transparency = 1 end
			end
		end
	end
end)

-- ==========================================================
-- PESTAÑA 2: ESP
-- ==========================================================
local EspSheriffEnabled, EspMurderEnabled, EspPlayersEnabled, EspDroppedGunEnabled = false, false, false, false

local BtnEspPlayers = Create
