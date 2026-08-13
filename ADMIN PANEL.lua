--// ADMIN PANEL.lua
--// ASTRONIXP - ADMIN PANEL V1
--// SINGLE FILE / LOCAL SCRIPT / NO KEY

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

--==================================================
-- ADMIN
--==================================================

local ADMIN_NAME = "ASTRONIXP"

if Player.Name ~= ADMIN_NAME then
	return
end

--==================================================
-- VARIABLES
--==================================================

local Character
local Humanoid
local RootPart

local Flying = false
local FlySpeed = 60
local WalkSpeed = 16
local JumpPower = 50

local FlyConnection
local BodyVelocity

local function GetCharacter()
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
end

GetCharacter()

Player.CharacterAdded:Connect(function()
	task.wait(0.5)
	GetCharacter()

	if Humanoid then
		Humanoid.WalkSpeed = WalkSpeed
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = JumpPower
	end
end)

--==================================================
-- GUI
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "ASTRONIXP_ADMIN_PANEL"
GUI.ResetOnSpawn = false
GUI.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 330, 0, 470)
Main.Position = UDim2.new(0.5, -165, 0.5, -235)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = GUI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ASTRONIXP ADMIN"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 0, 25)
Version.Position = UDim2.new(0, 0, 0, 45)
Version.BackgroundTransparency = 1
Version.Text = "ADMIN PANEL V1 • NO KEY"
Version.TextColor3 = Color3.fromRGB(150, 150, 150)
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.Parent = Main

--==================================================
-- DRAG
--==================================================

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
	or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position
	end
end)

UIS.InputChanged:Connect(function(Input)
	if not Dragging then
		return
	end

	if Input.UserInputType == Enum.UserInputType.MouseMovement
	or Input.UserInputType == Enum.UserInputType.Touch then

		local Delta = Input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
	or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = false
	end
end)

--==================================================
-- BUTTON FUNCTION
--==================================================

local function Button(Text, PositionY)

	local B = Instance.new("TextButton")

	B.Size = UDim2.new(1, -30, 0, 42)
	B.Position = UDim2.new(0, 15, 0, PositionY)

	B.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	B.BorderSizePixel = 0

	B.Text = Text
	B.TextColor3 = Color3.fromRGB(255, 255, 255)
	B.TextSize = 16
	B.Font = Enum.Font.GothamBold

	B.Parent = Main

	local C = Instance.new("UICorner")
	C.CornerRadius = UDim.new(0, 8)
	C.Parent = B

	return B
end

--==================================================
-- FLY
--==================================================

local FlyButton = Button("🪽 FLY : OFF", 80)

local function StopFly()

	Flying = false

	FlyButton.Text = "🪽 FLY : OFF"

	if FlyConnection then
		FlyConnection:Disconnect()
		FlyConnection = nil
	end

	if BodyVelocity then
		BodyVelocity:Destroy()
		BodyVelocity = nil
	end
end

local function StartFly()

	if Flying then
		return
	end

	GetCharacter()

	Flying = true
	FlyButton.Text = "🪽 FLY : ON"

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(
		math.huge,
		math.huge,
		math.huge
	)
	BodyVelocity.Velocity = Vector3.zero
	BodyVelocity.Parent = RootPart

	FlyConnection = RunService.RenderStepped:Connect(function()

		if not Flying or not RootPart then
			return
		end

		local Camera = workspace.CurrentCamera
		local Direction = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then
			Direction += Camera.CFrame.LookVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.S) then
			Direction -= Camera.CFrame.LookVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.A) then
			Direction -= Camera.CFrame.RightVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.D) then
			Direction += Camera.CFrame.RightVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			Direction += Vector3.new(0, 1, 0)
		end

		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			Direction -= Vector3.new(0, 1, 0)
		end

		if Direction.Magnitude > 0 then
			Direction = Direction.Unit * FlySpeed
		end

		BodyVelocity.Velocity = Direction
	end)
end

FlyButton.MouseButton1Click:Connect(function()

	if Flying then
		StopFly()
	else
		StartFly()
	end

end)

--==================================================
-- SPEED
--==================================================

local SpeedBox = Instance.new("TextBox")

SpeedBox.Size = UDim2.new(1, -30, 0, 40)
SpeedBox.Position = UDim2.new(0, 15, 0, 135)

SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SpeedBox.BorderSizePixel = 0

SpeedBox.Text = "50"
SpeedBox.PlaceholderText = "Speed"
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextSize = 16
SpeedBox.Font = Enum.Font.Gotham

SpeedBox.Parent = Main

local SC = Instance.new("UICorner")
SC.CornerRadius = UDim.new(0, 8)
SC.Parent = SpeedBox

local SpeedButton = Button("⚡ SET SPEED", 180)

SpeedButton.MouseButton1Click:Connect(function()

	local Value = tonumber(SpeedBox.Text)

	if Value then

		WalkSpeed = math.clamp(Value, 0, 500)

		if Humanoid then
			Humanoid.WalkSpeed = WalkSpeed
		end

		SpeedButton.Text = "⚡ SPEED: " .. WalkSpeed

		task.wait(1)

		SpeedButton.Text = "⚡ SET SPEED"
	end

end)

--==================================================
-- JUMP
--==================================================

local JumpBox = Instance.new("TextBox")

JumpBox.Size = UDim2.new(1, -30, 0, 40)
JumpBox.Position = UDim2.new(0, 15, 0, 235)

JumpBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
JumpBox.BorderSizePixel = 0

JumpBox.Text = "50"
JumpBox.PlaceholderText = "Jump Power"
JumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpBox.TextSize = 16
JumpBox.Font = Enum.Font.Gotham

JumpBox.Parent = Main

local JC = Instance.new("UICorner")
JC.CornerRadius = UDim.new(0, 8)
JC.Parent = JumpBox

local JumpButton = Button("🦘 SET JUMP", 280)

JumpButton.MouseButton1Click:Connect(function()

	local Value = tonumber(JumpBox.Text)

	if Value then

		JumpPower = math.clamp(Value, 0, 500)

		if Humanoid then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = JumpPower
		end

		JumpButton.Text = "🦘 JUMP: " .. JumpPower

		task.wait(1)

		JumpButton.Text = "🦘 SET JUMP"
	end

end)

--==================================================
-- PLAYER TARGET
--==================================================

local PlayerBox = Instance.new("TextBox")

PlayerBox.Size = UDim2.new(1, -30, 0, 40)
PlayerBox.Position = UDim2.new(0, 15, 0, 335)

PlayerBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PlayerBox.BorderSizePixel = 0

PlayerBox.Text = ""
PlayerBox.PlaceholderText = "Nama player..."
PlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerBox.TextSize = 16
PlayerBox.Font = Enum.Font.Gotham

PlayerBox.Parent = Main

local PC = Instance.new("UICorner")
PC.CornerRadius = UDim.new(0, 8)
PC.Parent = PlayerBox

--==================================================
-- FIND PLAYER
--==================================================

local function FindPlayer(Name)

	Name = Name:lower()

	for _, P in ipairs(Players:GetPlayers()) do

		if P ~= Player then

			if P.Name:lower():sub(1, #Name) == Name
			or P.DisplayName:lower():sub(1, #Name) == Name then

				return P
			end

		end
	end

	return nil
end

--==================================================
-- KICK
--==================================================

local KickButton = Button("👢 KICK PLAYER", 385)

KickButton.MouseButton1Click:Connect(function()

	local Target = FindPlayer(PlayerBox.Text)

	if Target then

		-- V1 LocalScript
		-- Hanya mencoba kick dari sisi client

		Target:Kick("Kicked by ASTRONIXP")

		PlayerBox.Text = ""
	end

end)

--==================================================
-- BAN
--==================================================

local BanButton = Button("🚫 BAN PLAYER", 435)

BanButton.MouseButton1Click:Connect(function()

	local Target = FindPlayer(PlayerBox.Text)

	if Target then

		-- Ban lokal V1
		-- Belum permanent/server-side

		Target:Kick("Banned by ASTRONIXP")

		PlayerBox.Text = ""
	end

end)

--==================================================
-- DEFAULT
--==================================================

if Humanoid then

	Humanoid.WalkSpeed = WalkSpeed

	Humanoid.UseJumpPower = true
	Humanoid.JumpPower = JumpPower

end

print("================================")
print("ASTRONIXP ADMIN PANEL V1")
print("NO KEY")
print("ADMIN: ASTRONIXP")
print("================================")
