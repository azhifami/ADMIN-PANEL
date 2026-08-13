--========================================================--
--              ASTRONIXP ADMIN PANEL V2                  --
--                    SINGLE FILE                         --
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer

--========================================================--
-- CONFIG
--========================================================--

local ADMIN_NAME = "ASTRONIXP"

-- MASUKKAN ASSET ID GAMBAR MUKA LU DI SINI
-- Contoh: rbxassetid://123456789
local FACE_IMAGE_ID = "rbxassetid://MASUKKAN_ID_GAMBAR"

-- MASUKKAN ASSET ID SUARA PRANK
local PRANK_SOUND_ID = "rbxassetid://MASUKKAN_ID_SUARA"

--========================================================--
-- ADMIN CHECK
--========================================================--

if Player.Name ~= ADMIN_NAME then
	return
end

--========================================================--
-- VARIABLES
--========================================================--

local Character
local Humanoid
local RootPart

local Flying = false
local FlySpeed = 60
local WalkSpeed = 16
local JumpPower = 50

local FlyConnection
local FlyVelocity
local FlyAttachment

local Minimized = false
local Maximized = false
local Closed = false

local NormalSize = UDim2.new(0, 350, 0, 520)
local NormalPosition = UDim2.new(0.5, -175, 0.5, -260)

local MaxSize = UDim2.new(0, 600, 0, 650)
local MaxPosition = UDim2.new(0.5, -300, 0.5, -325)

--========================================================--
-- CHARACTER
--========================================================--

local function UpdateCharacter()

	Character = Player.Character or Player.CharacterAdded:Wait()

	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")

end

UpdateCharacter()

Player.CharacterAdded:Connect(function()

	task.wait(0.5)

	UpdateCharacter()

	if Humanoid then
		Humanoid.WalkSpeed = WalkSpeed
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = JumpPower
	end

end)

--========================================================--
-- GUI
--========================================================--

local GUI = Instance.new("ScreenGui")

GUI.Name = "ASTRONIXP_ADMIN_PANEL_V2"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.Parent = Player:WaitForChild("PlayerGui")

--========================================================--
-- FACE PRANK
--========================================================--

local Face = Instance.new("ImageLabel")

Face.Name = "FACE_PRANK"

Face.Size = UDim2.new(1, 0, 1, 0)
Face.Position = UDim2.new(0, 0, 0, 0)

Face.BackgroundTransparency = 1
Face.Image = FACE_IMAGE_ID

Face.Visible = false
Face.ZIndex = 999

Face.Parent = GUI

--========================================================--
-- MAIN PANEL
--========================================================--

local Main = Instance.new("Frame")

Main.Name = "Main"

Main.Size = NormalSize
Main.Position = NormalPosition

Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0

Main.Parent = GUI

local MainCorner = Instance.new("UICorner")

MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

--========================================================--
-- TITLE BAR
--========================================================--

local TitleBar = Instance.new("Frame")

TitleBar.Size = UDim2.new(1, 0, 0, 55)

TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.BorderSizePixel = 0

TitleBar.Parent = Main

--========================================================--
-- TITLE
--========================================================--

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(1, -150, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)

Title.BackgroundTransparency = 1

Title.Text = "⚡ ASTRONIXP ADMIN V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

Title.TextSize = 19
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = TitleBar

--========================================================--
-- MINIMIZE
--========================================================--

local MinButton = Instance.new("TextButton")

MinButton.Size = UDim2.new(0, 40, 0, 40)
MinButton.Position = UDim2.new(1, -135, 0, 7)

MinButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinButton.Text = "—"

MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.TextSize = 22

MinButton.Font = Enum.Font.GothamBold

MinButton.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinButton

--========================================================--
-- MAXIMIZE
--========================================================--

local MaxButton = Instance.new("TextButton")

MaxButton.Size = UDim2.new(0, 40, 0, 40)
MaxButton.Position = UDim2.new(1, -90, 0, 7)

MaxButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)

MaxButton.Text = "□"

MaxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxButton.TextSize = 18

MaxButton.Font = Enum.Font.GothamBold

MaxButton.Parent = TitleBar

local MaxCorner = Instance.new("UICorner")
MaxCorner.CornerRadius = UDim.new(0, 8)
MaxCorner.Parent = MaxButton

--========================================================--
-- CLOSE
--========================================================--

local CloseButton = Instance.new("TextButton")

CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 7)

CloseButton.BackgroundColor3 = Color3.fromRGB(150, 45, 45)

CloseButton.Text = "×"

CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 25

CloseButton.Font = Enum.Font.GothamBold

CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

--========================================================--
-- CONTENT
--========================================================--

local Content = Instance.new("Frame")

Content.Size = UDim2.new(1, 0, 1, -55)
Content.Position = UDim2.new(0, 0, 0, 55)

Content.BackgroundTransparency = 1

Content.Parent = Main

--========================================================--
-- BUTTON CREATOR
--========================================================--

local function CreateButton(Text, Y)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -30, 0, 42)

	Button.Position = UDim2.new(0, 15, 0, Y)

	Button.BackgroundColor3 = Color3.fromRGB(42, 42, 52)

	Button.BorderSizePixel = 0

	Button.Text = Text

	Button.TextColor3 = Color3.fromRGB(255, 255, 255)

	Button.TextSize = 16

	Button.Font = Enum.Font.GothamBold

	Button.Parent = Content

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(0, 8)

	Corner.Parent = Button

	return Button

end

--========================================================--
-- FLY BUTTON
--========================================================--

local FlyButton = CreateButton(
	"🪽 FLY : OFF",
	20
)

--========================================================--
-- FLY UP/DOWN MOBILE
--========================================================--

local UpButton = CreateButton(
	"⬆ FLY UP",
	70
)

local DownButton = CreateButton(
	"⬇ FLY DOWN",
	120
)

UpButton.Visible = false
DownButton.Visible = false

--========================================================--
-- FLY SYSTEM V2
--========================================================--

local function StopFly()

	Flying = false

	FlyButton.Text = "🪽 FLY : OFF"

	UpButton.Visible = false
	DownButton.Visible = false

	if FlyConnection then

		FlyConnection:Disconnect()

		FlyConnection = nil

	end

	if FlyVelocity then

		FlyVelocity:Destroy()

		FlyVelocity = nil

	end

	if FlyAttachment then

		FlyAttachment:Destroy()

		FlyAttachment = nil

	end

	if Humanoid then

		Humanoid.PlatformStand = false

	end

end

local FlyVertical = 0

local function StartFly()

	if Flying then
		return
	end

	UpdateCharacter()

	if not RootPart or not Humanoid then
		return
	end

	Flying = true

	FlyButton.Text = "🪽 FLY : ON"

	UpButton.Visible = true
	DownButton.Visible = true

	Humanoid.PlatformStand = true

	-- Attachment
	FlyAttachment = Instance.new("Attachment")

	FlyAttachment.Parent = RootPart

	-- Linear velocity
	FlyVelocity = Instance.new("LinearVelocity")

	FlyVelocity.Attachment0 = FlyAttachment

	FlyVelocity.MaxForce = math.huge

	FlyVelocity.VectorVelocity = Vector3.zero

	FlyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World

	FlyVelocity.Parent = RootPart

	FlyConnection = RunService.RenderStepped:Connect(function()

		if not Flying then
			return
		end

		if not RootPart then
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

		-- Mobile / keyboard vertical
		Direction += Vector3.new(
			0,
			FlyVertical,
			0
		)

		if Direction.Magnitude > 0 then

			Direction = Direction.Unit * FlySpeed

		end

		FlyVelocity.VectorVelocity = Direction

	end)

end

FlyButton.MouseButton1Click:Connect(function()

	if Flying then

		StopFly()

	else

		StartFly()

	end

end)

UpButton.MouseButton1Down:Connect(function()

	FlyVertical = 1

end)

UpButton.MouseButton1Up:Connect(function()

	FlyVertical = 0

end)

DownButton.MouseButton1Down:Connect(function()

	FlyVertical = -1

end)

DownButton.MouseButton1Up:Connect(function()

	FlyVertical = 0

end)

--========================================================--
-- SPEED
--========================================================--

local SpeedBox = Instance.new("TextBox")

SpeedBox.Size = UDim2.new(1, -30, 0, 40)

SpeedBox.Position = UDim2.new(0, 15, 0, 180)

SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

SpeedBox.BorderSizePixel = 0

SpeedBox.Text = "50"

SpeedBox.PlaceholderText = "Speed"

SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)

SpeedBox.TextSize = 16

SpeedBox.Font = Enum.Font.Gotham

SpeedBox.Parent = Content

local SpeedCorner = Instance.new("UICorner")

SpeedCorner.CornerRadius = UDim.new(0, 8)

SpeedCorner.Parent = SpeedBox

local SpeedButton = CreateButton(
	"⚡ SET SPEED",
	230
)

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

--========================================================--
-- JUMP
--========================================================--

local JumpBox = Instance.new("TextBox")

JumpBox.Size = UDim2.new(1, -30, 0, 40)

JumpBox.Position = UDim2.new(0, 15, 0, 280)

JumpBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

JumpBox.BorderSizePixel = 0

JumpBox.Text = "50"

JumpBox.PlaceholderText = "Jump Power"

JumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)

JumpBox.TextSize = 16

JumpBox.Font = Enum.Font.Gotham

JumpBox.Parent = Content

local JumpCorner = Instance.new("UICorner")

JumpCorner.CornerRadius = UDim.new(0, 8)

JumpCorner.Parent = JumpBox

local JumpButton = CreateButton(
	"🦘 SET JUMP",
	330
)

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

--========================================================--
-- PRANK SOUND
--========================================================--

local SoundButton = CreateButton(
	"🔊 PRANK SOUND",
	380
)

local PrankSound = Instance.new("Sound")

PrankSound.Name = "ASTRONIXP_PRANK_SOUND"

PrankSound.SoundId = PRANK_SOUND_ID

PrankSound.Volume = 5

PrankSound.Parent = SoundService

SoundButton.MouseButton1Click:Connect(function()

	if PrankSound.SoundId ~= "" then

		PrankSound:Play()

	end

end)

--========================================================--
-- FACE PRANK
--========================================================--

local FaceButton = CreateButton(
	"😹 FACE PRANK",
	430
)

FaceButton.MouseButton1Click:Connect(function()

	if FACE_IMAGE_ID == "rbxassetid://MASUKKAN_ID_GAMBAR" then

		warn("Masukkan asset ID gambar muka lu terlebih dahulu.")

		return

	end

	Face.Visible = true

	-- Main panel tetap berada di atas sedikit
	Main.ZIndex = 1000

	task.wait(3)

	Face.Visible = false

end)

--========================================================--
-- MINIMIZE
--========================================================--

MinButton.MouseButton1Click:Connect(function()

	Minimized = not Minimized

	Content.Visible = not Minimized

	if Minimized then

		Main.Size = UDim2.new(
			0,
			350,
			0,
			55
		)

	else

		if Maximized then

			Main.Size = MaxSize

		else

			Main.Size = NormalSize

		end

	end

end)

--========================================================--
-- MAXIMIZE
--========================================================--

MaxButton.MouseButton1Click:Connect(function()

	Maximized = not Maximized

	if Maximized then

		Main.Size = MaxSize

		Main.Position = MaxPosition

		MaxButton.Text = "❐"

	else

		Main.Size = NormalSize

		Main.Position = NormalPosition

		MaxButton.Text = "□"

	end

end)

--========================================================--
-- CLOSE
--========================================================--

CloseButton.MouseButton1Click:Connect(function()

	Closed = true

	StopFly()

	GUI:Destroy()

end)

--========================================================--
-- DRAG PANEL
--========================================================--

local Dragging = false

local DragStart

local StartPosition

TitleBar.InputBegan:Connect(function(Input)

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

--========================================================--
-- DEFAULT CHARACTER
--========================================================--

if Humanoid then

	Humanoid.WalkSpeed = WalkSpeed

	Humanoid.UseJumpPower = true

	Humanoid.JumpPower = JumpPower

end

print("====================================")
print(" ASTRONIXP ADMIN PANEL V2 LOADED")
print(" SINGLE FILE")
print(" NO KEY")
print("====================================")local DragStart
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
