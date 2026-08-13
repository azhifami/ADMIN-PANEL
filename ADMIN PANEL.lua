--========================================================--
--          ASTRONIXP ADMIN PANEL V2.1                  --
--       MOBILE RESPONSIVE + SCROLLING                  --
--                  SINGLE FILE                         --
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

local FACE_IMAGE_ID = "rbxassetid://122974943335311"
local PRANK_SOUND_ID = "rbxassetid://138890398994853"

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

local FlyVertical = 0

local Minimized = false
local Maximized = false

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

GUI.Name = "ASTRONIXP_ADMIN_V21"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true

GUI.Parent = Player:WaitForChild("PlayerGui")

--========================================================--
-- FACE PRANK
--========================================================--

local Face = Instance.new("ImageLabel")

Face.Name = "FACE_PRANK"

Face.Size = UDim2.fromScale(1, 1)
Face.Position = UDim2.fromScale(0, 0)

Face.BackgroundColor3 = Color3.new(0, 0, 0)
Face.BackgroundTransparency = 0

Face.Image = FACE_IMAGE_ID
Face.ScaleType = Enum.ScaleType.Stretch

Face.Visible = false
Face.ZIndex = 999

Face.Parent = GUI

--========================================================--
-- MAIN PANEL
--========================================================--

local Main = Instance.new("Frame")

Main.Name = "Main"

Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0

Main.AnchorPoint = Vector2.new(0.5, 0.5)

Main.Parent = GUI

local MainCorner = Instance.new("UICorner")

MainCorner.CornerRadius = UDim.new(0, 14)

MainCorner.Parent = Main

--========================================================--
-- RESPONSIVE SIZE
--========================================================--

local function SetNormalSize()

	local Camera = workspace.CurrentCamera

	if not Camera then
		return
	end

	local Viewport = Camera.ViewportSize

	local Width = math.min(350, Viewport.X - 20)
	local Height = math.min(520, Viewport.Y - 20)

	Main.Size = UDim2.fromOffset(Width, Height)
	Main.Position = UDim2.fromScale(0.5, 0.5)

end

local function SetMaxSize()

	local Camera = workspace.CurrentCamera

	if not Camera then
		return
	end

	local Viewport = Camera.ViewportSize

	Main.Size = UDim2.fromOffset(
		math.max(250, Viewport.X - 10),
		math.max(250, Viewport.Y - 10)
	)

	Main.Position = UDim2.fromScale(0.5, 0.5)

end

SetNormalSize()

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()

	if not Maximized then
		SetNormalSize()
	else
		SetMaxSize()
	end

end)

--========================================================--
-- TITLE BAR
--========================================================--

local TitleBar = Instance.new("Frame")

TitleBar.Size = UDim2.new(1, 0, 0, 52)

TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.BorderSizePixel = 0

TitleBar.Parent = Main

--========================================================--
-- TITLE
--========================================================--

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(1, -135, 1, 0)

Title.Position = UDim2.fromOffset(10, 0)

Title.BackgroundTransparency = 1

Title.Text = "⚡ ASTRONIXP ADMIN"

Title.TextColor3 = Color3.fromRGB(255, 255, 255)

Title.TextSize = 17

Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = TitleBar

--========================================================--
-- TITLE BUTTON
--========================================================--

local function TitleButton(Text, X, Color)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.fromOffset(36, 36)

	Button.Position = UDim2.new(1, X, 0, 8)

	Button.BackgroundColor3 = Color

	Button.BorderSizePixel = 0

	Button.Text = Text

	Button.TextColor3 = Color3.new(1, 1, 1)

	Button.TextSize = 20

	Button.Font = Enum.Font.GothamBold

	Button.Parent = TitleBar

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(0, 8)

	Corner.Parent = Button

	return Button

end

local MinButton = TitleButton(
	"—",
	-125,
	Color3.fromRGB(60, 60, 70)
)

local MaxButton = TitleButton(
	"□",
	-85,
	Color3.fromRGB(60, 60, 70)
)

local CloseButton = TitleButton(
	"×",
	-45,
	Color3.fromRGB(150, 45, 45)
)

--========================================================--
-- SCROLLING CONTENT
--========================================================--

local Content = Instance.new("ScrollingFrame")

Content.Name = "Content"

Content.Size = UDim2.new(1, 0, 1, -52)

Content.Position = UDim2.fromOffset(0, 52)

Content.BackgroundTransparency = 1

Content.BorderSizePixel = 0

Content.ScrollBarThickness = 6

Content.ScrollBarImageTransparency = 0.2

Content.ScrollingDirection = Enum.ScrollingDirection.Y

Content.CanvasSize = UDim2.new(0, 0, 0, 0)

Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

Content.Parent = Main

--========================================================--
-- LIST LAYOUT
--========================================================--

local Padding = Instance.new("UIPadding")

Padding.PaddingTop = UDim.new(0, 12)
Padding.PaddingBottom = UDim.new(0, 15)
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)

Padding.Parent = Content

local Layout = Instance.new("UIListLayout")

Layout.Padding = UDim.new(0, 10)

Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Layout.SortOrder = Enum.SortOrder.LayoutOrder

Layout.Parent = Content

--========================================================--
-- ELEMENT CREATOR
--========================================================--

local function CreateButton(Text)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, 0, 0, 44)

	Button.BackgroundColor3 = Color3.fromRGB(42, 42, 52)

	Button.BorderSizePixel = 0

	Button.Text = Text

	Button.TextColor3 = Color3.fromRGB(255, 255, 255)

	Button.TextSize = 15

	Button.Font = Enum.Font.GothamBold

	Button.LayoutOrder = #Content:GetChildren()

	Button.Parent = Content

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(0, 9)

	Corner.Parent = Button

	return Button

end

local function CreateBox(Placeholder, Default)

	local Box = Instance.new("TextBox")

	Box.Size = UDim2.new(1, 0, 0, 42)

	Box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

	Box.BorderSizePixel = 0

	Box.Text = Default or ""

	Box.PlaceholderText = Placeholder

	Box.TextColor3 = Color3.fromRGB(255, 255, 255)

	Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)

	Box.TextSize = 15

	Box.Font = Enum.Font.Gotham

	Box.ClearTextOnFocus = false

	Box.LayoutOrder = #Content:GetChildren()

	Box.Parent = Content

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(0, 9)

	Corner.Parent = Box

	return Box

end

--========================================================--
-- FLY
--========================================================--

local FlyButton = CreateButton("🪽 FLY : OFF")

local UpButton = CreateButton("⬆ FLY UP")

local DownButton = CreateButton("⬇ FLY DOWN")

UpButton.Visible = false
DownButton.Visible = false

--========================================================--
-- STOP FLY
--========================================================--

local function StopFly()

	Flying = false

	FlyVertical = 0

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

--========================================================--
-- START FLY
--========================================================--

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

	FlyAttachment = Instance.new("Attachment")

	FlyAttachment.Parent = RootPart

	FlyVelocity = Instance.new("LinearVelocity")

	FlyVelocity.Attachment0 = FlyAttachment

	FlyVelocity.MaxForce = math.huge

	FlyVelocity.VectorVelocity = Vector3.zero

	FlyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World

	FlyVelocity.Parent = RootPart

	FlyConnection = RunService.RenderStepped:Connect(function()

		if not Flying or not RootPart then
			return
		end

		local Camera = workspace.CurrentCamera

		local Direction = Vector3.zero

		-- Keyboard
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

--========================================================--
-- FLY UP/DOWN
--========================================================--

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

local SpeedBox = CreateBox(
	"Masukkan Speed",
	"50"
)

local SpeedButton = CreateButton(
	"⚡ SET SPEED"
)

SpeedButton.MouseButton1Click:Connect(function()

	local Value = tonumber(SpeedBox.Text)

	if not Value then
		return
	end

	WalkSpeed = math.clamp(Value, 0, 500)

	if Humanoid then

		Humanoid.WalkSpeed = WalkSpeed

	end

	SpeedButton.Text = "⚡ SPEED: " .. WalkSpeed

	task.delay(1, function()

		if SpeedButton then

			SpeedButton.Text = "⚡ SET SPEED"

		end

	end)

end)

--========================================================--
-- JUMP
--========================================================--

local JumpBox = CreateBox(
	"Masukkan Jump Power",
	"50"
)

local JumpButton = CreateButton(
	"🦘 SET JUMP"
)

JumpButton.MouseButton1Click:Connect(function()

	local Value = tonumber(JumpBox.Text)

	if not Value then
		return
	end

	JumpPower = math.clamp(Value, 0, 500)

	if Humanoid then

		Humanoid.UseJumpPower = true

		Humanoid.JumpPower = JumpPower

	end

	JumpButton.Text = "🦘 JUMP: " .. JumpPower

	task.delay(1, function()

		if JumpButton then

			JumpButton.Text = "🦘 SET JUMP"

		end

	end)

end)

--========================================================--
-- PLAYER TARGET
--========================================================--

local PlayerBox = CreateBox(
	"Nama player"
)

--========================================================--
-- KICK
--========================================================--

local KickButton = CreateButton(
	"👢 KICK PLAYER"
)

KickButton.MouseButton1Click:Connect(function()

	-- LocalScript tidak punya otoritas
	-- untuk benar-benar kick player lain.

	KickButton.Text = "⚠ SERVER REQUIRED"

	task.delay(2, function()

		KickButton.Text = "👢 KICK PLAYER"

	end)

end)

--========================================================--
-- BAN
--========================================================--

local BanButton = CreateButton(
	"🚫 BAN PLAYER"
)

BanButton.MouseButton1Click:Connect(function()

	-- LocalScript tidak bisa melakukan
	-- server-side ban yang sebenarnya.

	BanButton.Text = "⚠ SERVER REQUIRED"

	task.delay(2, function()

		BanButton.Text = "🚫 BAN PLAYER"

	end)

end)

--========================================================--
-- PRANK SOUND
--========================================================--

local SoundButton = CreateButton(
	"🔊 PRANK SOUND"
)

local PrankSound = Instance.new("Sound")

PrankSound.Name = "ASTRONIXP_PRANK"

PrankSound.SoundId = PRANK_SOUND_ID

PrankSound.Volume = 5

PrankSound.Parent = SoundService

SoundButton.MouseButton1Click:Connect(function()

	PrankSound:Stop()

	PrankSound.TimePosition = 0

	PrankSound:Play()

end)

--========================================================--
-- FACE PRANK
--========================================================--

local FaceButton = CreateButton(
	"😹 FACE PRANK"
)

FaceButton.MouseButton1Click:Connect(function()

	Face.Visible = true

	PrankSound:Stop()

	PrankSound.TimePosition = 0

	PrankSound:Play()

	task.delay(3, function()

		if Face then

			Face.Visible = false

		end

	end)

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
			math.min(350, workspace.CurrentCamera.ViewportSize.X - 20),
			0,
			52
		)

	else

		if Maximized then

			SetMaxSize()

		else

			SetNormalSize()

		end

	end

end)

--========================================================--
-- MAXIMIZE
--========================================================--

MaxButton.MouseButton1Click:Connect(function()

	Maximized = not Maximized

	Minimized = false

	Content.Visible = true

	if Maximized then

		SetMaxSize()

		MaxButton.Text = "❐"

	else

		SetNormalSize()

		MaxButton.Text = "□"

	end

end)

--========================================================--
-- CLOSE
--========================================================--

CloseButton.MouseButton1Click:Connect(function()

	StopFly()

	PrankSound:Destroy()

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
-- DEFAULT
--========================================================--

if Humanoid then

	Humanoid.WalkSpeed = WalkSpeed

	Humanoid.UseJumpPower = true

	Humanoid.JumpPower = JumpPower

end

print("======================================")
print(" ASTRONIXP ADMIN PANEL V2.1")
print(" MOBILE RESPONSIVE")
print(" SCROLL ENABLED")
print(" NO KEY")
print("======================================")
