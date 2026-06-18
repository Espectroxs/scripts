local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local sharedEnv = _G
sharedEnv.WalkyUISession = (sharedEnv.WalkyUISession or 0) + 1
local SCRIPT_SESSION = sharedEnv.WalkyUISession

local function isSessionActive()
	return sharedEnv.WalkyUISession == SCRIPT_SESSION
end

local KrassUI = {}

local DEFAULT_THEME = {
	Background = Color3.fromRGB(2, 7, 5),
	Panel = Color3.fromRGB(5, 14, 10),
	Panel2 = Color3.fromRGB(8, 22, 14),
	Panel3 = Color3.fromRGB(12, 34, 22),
	Text = Color3.fromRGB(210, 255, 220),
	Muted = Color3.fromRGB(88, 164, 112),
	Accent = Color3.fromRGB(0, 255, 116),
	Accent2 = Color3.fromRGB(0, 185, 255),
	Danger = Color3.fromRGB(255, 65, 85),
	Stroke = Color3.fromRGB(21, 92, 49),
	DarkText = Color3.fromRGB(1, 12, 6),
	Shadow = Color3.fromRGB(0, 0, 0),
}

local FONT_REGULAR = Enum.Font.Code
local FONT_BOLD = Enum.Font.Code

local THEME_PRESETS = {
	Hacker = {
		Background = Color3.fromRGB(2, 7, 5),
		Panel = Color3.fromRGB(5, 14, 10),
		Panel2 = Color3.fromRGB(8, 22, 14),
		Panel3 = Color3.fromRGB(12, 34, 22),
		Text = Color3.fromRGB(210, 255, 220),
		Muted = Color3.fromRGB(88, 164, 112),
		Accent = Color3.fromRGB(0, 255, 116),
		Accent2 = Color3.fromRGB(0, 185, 255),
		Danger = Color3.fromRGB(255, 65, 85),
		Stroke = Color3.fromRGB(21, 92, 49),
		DarkText = Color3.fromRGB(1, 12, 6),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Linux = {
		Background = Color3.fromRGB(3, 10, 8),
		Panel = Color3.fromRGB(7, 18, 14),
		Panel2 = Color3.fromRGB(10, 27, 19),
		Panel3 = Color3.fromRGB(16, 45, 30),
		Text = Color3.fromRGB(220, 255, 226),
		Muted = Color3.fromRGB(103, 176, 119),
		Accent = Color3.fromRGB(60, 255, 110),
		Accent2 = Color3.fromRGB(0, 205, 150),
		Danger = Color3.fromRGB(255, 75, 95),
		Stroke = Color3.fromRGB(28, 105, 58),
		DarkText = Color3.fromRGB(0, 16, 8),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Black = {
		Background = Color3.fromRGB(8, 9, 13),
		Panel = Color3.fromRGB(17, 19, 26),
		Panel2 = Color3.fromRGB(24, 27, 36),
		Panel3 = Color3.fromRGB(34, 38, 50),
		Text = Color3.fromRGB(244, 246, 250),
		Muted = Color3.fromRGB(145, 153, 166),
		Accent = Color3.fromRGB(145, 160, 255),
		Accent2 = Color3.fromRGB(95, 105, 255),
		Danger = Color3.fromRGB(255, 75, 95),
		Stroke = Color3.fromRGB(58, 64, 80),
		DarkText = Color3.fromRGB(5, 7, 10),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Pink = {
		Background = Color3.fromRGB(18, 10, 18),
		Panel = Color3.fromRGB(29, 17, 31),
		Panel2 = Color3.fromRGB(42, 24, 45),
		Panel3 = Color3.fromRGB(57, 31, 61),
		Text = Color3.fromRGB(255, 244, 252),
		Muted = Color3.fromRGB(211, 162, 199),
		Accent = Color3.fromRGB(255, 95, 190),
		Accent2 = Color3.fromRGB(195, 80, 255),
		Danger = Color3.fromRGB(255, 77, 119),
		Stroke = Color3.fromRGB(90, 52, 91),
		DarkText = Color3.fromRGB(24, 5, 18),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Red = {
		Background = Color3.fromRGB(18, 9, 10),
		Panel = Color3.fromRGB(31, 17, 18),
		Panel2 = Color3.fromRGB(43, 23, 25),
		Panel3 = Color3.fromRGB(61, 31, 34),
		Text = Color3.fromRGB(255, 245, 245),
		Muted = Color3.fromRGB(216, 157, 159),
		Accent = Color3.fromRGB(255, 70, 82),
		Accent2 = Color3.fromRGB(255, 135, 68),
		Danger = Color3.fromRGB(255, 58, 72),
		Stroke = Color3.fromRGB(93, 50, 53),
		DarkText = Color3.fromRGB(25, 4, 6),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	White = {
		Background = Color3.fromRGB(242, 244, 248),
		Panel = Color3.fromRGB(255, 255, 255),
		Panel2 = Color3.fromRGB(232, 236, 244),
		Panel3 = Color3.fromRGB(216, 222, 234),
		Text = Color3.fromRGB(22, 26, 34),
		Muted = Color3.fromRGB(94, 105, 123),
		Accent = Color3.fromRGB(75, 95, 245),
		Accent2 = Color3.fromRGB(150, 85, 255),
		Danger = Color3.fromRGB(230, 55, 73),
		Stroke = Color3.fromRGB(190, 198, 214),
		DarkText = Color3.fromRGB(255, 255, 255),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
}

KrassUI.Themes = THEME_PRESETS

local function mergeTheme(overrides)
	local theme = {}
	for key, value in pairs(DEFAULT_THEME) do
		theme[key] = value
	end
	for key, value in pairs(overrides or {}) do
		theme[key] = value
	end
	return theme
end

local function new(className, props, children)
	local instance = Instance.new(className)
	for key, value in pairs(props or {}) do
		instance[key] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = instance
	end
	return instance
end

local function tween(instance, goal, time, style, direction)
	local info = TweenInfo.new(
		time or 0.18,
		style or Enum.EasingStyle.Quint,
		direction or Enum.EasingDirection.Out
	)
	local active = TweenService:Create(instance, info, goal)
	active:Play()
	return active
end

local function corner(radius)
	return new("UICorner", {
		CornerRadius = UDim.new(0, radius),
	})
end

local function stroke(color, thickness, transparency)
	return new("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
	})
end

local function padding(value)
	return new("UIPadding", {
		PaddingBottom = UDim.new(0, value),
		PaddingLeft = UDim.new(0, value),
		PaddingRight = UDim.new(0, value),
		PaddingTop = UDim.new(0, value),
	})
end

local function list(spacing)
	return new("UIListLayout", {
		Padding = UDim.new(0, spacing),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
end

local function makeLabel(parent, text, size, color, bold)
	return new("TextLabel", {
		BackgroundTransparency = 1,
		Font = bold and FONT_BOLD or FONT_REGULAR,
		Parent = parent,
		Text = text,
		TextColor3 = color,
		TextSize = size,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	})
end

local function makeButton(parent, text, color, textColor)
	return new("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Font = FONT_BOLD,
		Parent = parent,
		Text = text or "",
		TextColor3 = textColor,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Center,
	})
end

local function gradient(parent, colorA, colorB, rotation)
	local item = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, colorA),
			ColorSequenceKeypoint.new(1, colorB),
		}),
		Rotation = rotation or 0,
		Parent = parent,
	})
	return item
end

local function animateGradient(item, speed)
	task.spawn(function()
		while item.Parent do
			item.Rotation = 0
			tween(item, { Rotation = 360 }, speed or 5, Enum.EasingStyle.Linear)
			task.wait(speed or 5)
		end
	end)
end

local function ripple(button, x, y, color)
	x = x or (button.AbsolutePosition.X + button.AbsoluteSize.X / 2)
	y = y or (button.AbsolutePosition.Y + button.AbsoluteSize.Y / 2)
	local localX = x - button.AbsolutePosition.X
	local localY = y - button.AbsolutePosition.Y
	local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.8

	local circle = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Parent = button,
		Position = UDim2.fromOffset(localX, localY),
		Size = UDim2.fromOffset(0, 0),
		ZIndex = button.ZIndex + 8,
	})
	corner(999).Parent = circle

	tween(circle, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(maxSize, maxSize),
	}, 0.42, Enum.EasingStyle.Quint).Completed:Once(function()
		circle:Destroy()
	end)
end

local function pressable(hit, visual, border, theme, callback)
	local normal = visual.BackgroundColor3
	local hover = theme.Panel3
	local visualScale = visual:FindFirstChildOfClass("UIScale")

	hit.MouseEnter:Connect(function()
		tween(visual, { BackgroundColor3 = hover }, 0.15)
		if border then
			tween(border, {
				Color = theme.Accent,
				Transparency = 0.25,
			}, 0.15)
		end
	end)

	hit.MouseLeave:Connect(function()
		tween(visual, { BackgroundColor3 = normal }, 0.15)
		if visualScale then
			tween(visualScale, { Scale = 1 }, 0.18, Enum.EasingStyle.Back)
		end
		if border then
			tween(border, {
				Color = theme.Stroke,
				Transparency = 0.45,
			}, 0.15)
		end
	end)

	hit.MouseButton1Down:Connect(function(x, y)
		if visualScale then
			tween(visualScale, { Scale = 0.985 }, 0.08, Enum.EasingStyle.Quad)
		end
		ripple(hit, x, y, theme.Accent)
	end)

	hit.MouseButton1Up:Connect(function()
		if visualScale then
			tween(visualScale, { Scale = 1 }, 0.24, Enum.EasingStyle.Back)
		end
	end)

	hit.MouseButton1Click:Connect(function()
		if callback then
			task.spawn(callback)
		end
	end)
end

local function makeDraggable(frame, handle, tracker)
	local dragging = false
	local dragStart = nil
	local startPos = nil

	local function connect(signal, callback)
		if tracker and tracker._connect then
			return tracker:_connect(signal, callback)
		end
		return signal:Connect(callback)
	end

	connect(handle.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end)

	connect(UserInputService.InputChanged, function(input)
		if not dragging or not dragStart or not startPos then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end)
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local Control = {}
Control.__index = Control

function Window:_connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(self.Connections, connection)
	return connection
end

function KrassUI.new(config)
	config = config or {}
	local selectedTheme = nil
	if type(config.Theme) == "string" then
		selectedTheme = THEME_PRESETS[config.Theme]
	elseif type(config.ThemeName) == "string" then
		selectedTheme = THEME_PRESETS[config.ThemeName]
	end
	local theme = mergeTheme(selectedTheme or (type(config.Theme) == "table" and config.Theme or THEME_PRESETS.Hacker))
	theme.Accent = config.Accent or theme.Accent
	theme.Accent2 = config.Accent2 or theme.Accent2

	local guiName = config.GuiName or "WalkyUI_Tycoon"
	local oldGui = PlayerGui:FindFirstChild(guiName)
	if oldGui and config.ClearOld ~= false then
		oldGui:Destroy()
	end
	local oldBlur = Lighting:FindFirstChild(guiName .. "_Blur")
	if oldBlur and config.ClearOld ~= false then
		oldBlur:Destroy()
	end

	local gui = new("ScreenGui", {
		DisplayOrder = config.DisplayOrder or 999,
		IgnoreGuiInset = true,
		Name = guiName,
		Parent = PlayerGui,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})

	local blur = nil
	local blurTarget = config.BlurSize or 12
	if config.Blur ~= false then
		blur = Lighting:FindFirstChild(guiName .. "_Blur")
		if not blur then
			blur = new("BlurEffect", {
				Name = guiName .. "_Blur",
				Size = 0,
				Parent = Lighting,
			})
		end
	end

	local baseSize = config.Size or UDim2.fromOffset(690, 450)
	local holder = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = gui,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = baseSize,
	})

	local scale = new("UIScale", {
		Parent = holder,
		Scale = 0.84,
	})

	local shadow = new("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = theme.Shadow or Color3.fromRGB(0, 0, 0),
		ImageTransparency = 1,
		Parent = holder,
		Position = UDim2.fromOffset(-48, -48),
		ScaleType = Enum.ScaleType.Slice,
		Size = UDim2.new(1, 96, 1, 96),
		SliceCenter = Rect.new(10, 10, 118, 118),
		Visible = false,
		ZIndex = 0,
	})

	local root = new("Frame", {
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = holder,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
	})
	corner(6).Parent = root
	local rootStroke = stroke(theme.Stroke, 2, 0.04)
	rootStroke.Parent = root

	-- Visual terminal/matrix grid. Apenas decoração; não altera callbacks nem lógica dos controles.
	local grid = new("Frame", {
		BackgroundTransparency = 1,
		Parent = root,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
	})
	for i = 1, 24 do
		local lineX = new("Frame", {
			BackgroundColor3 = theme.Stroke,
			BackgroundTransparency = 0.91,
			BorderSizePixel = 0,
			Parent = grid,
			Position = UDim2.new(i / 24, 0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
			ZIndex = 2,
		})
		local lineY = new("Frame", {
			BackgroundColor3 = theme.Stroke,
			BackgroundTransparency = 0.94,
			BorderSizePixel = 0,
			Parent = grid,
			Position = UDim2.new(0, 0, i / 24, 0),
			Size = UDim2.new(1, 0, 0, 1),
			ZIndex = 2,
		})
	end

	local accentRail = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = root,
		Size = UDim2.new(1, 0, 0, 2),
		ZIndex = 4,
	})
	local railGradient = gradient(accentRail, theme.Accent, theme.Accent2, 0)
	animateGradient(railGradient, 4)

	local shine = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Parent = root,
		Position = UDim2.new(-0.35, 0, 0, 0),
		Rotation = 16,
		Size = UDim2.new(0.18, 0, 1.35, 0),
		ZIndex = 6,
	})
	gradient(shine, theme.Accent2, theme.Accent, 90)
	task.spawn(function()
		while shine.Parent do
			shine.Position = UDim2.new(-0.35, 0, -0.18, 0)
			shine.BackgroundTransparency = 0.92
			tween(shine, {
				BackgroundTransparency = 1,
				Position = UDim2.new(1.18, 0, -0.18, 0),
			}, 1.15, Enum.EasingStyle.Quint)
			task.wait(4.4)
		end
	end)

	local topbar = new("Frame", {
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Parent = root,
		Position = UDim2.fromOffset(0, 3),
		Size = UDim2.new(1, 0, 0, 54),
		ZIndex = 3,
	})

	local terminalDots = { theme.Danger, Color3.fromRGB(255, 190, 75), theme.Accent }
	for i, dotColor in ipairs(terminalDots) do
		local dot = new("Frame", {
			BackgroundColor3 = dotColor,
			BorderSizePixel = 0,
			Parent = topbar,
			Position = UDim2.fromOffset(14 + ((i - 1) * 16), 18),
			Size = UDim2.fromOffset(9, 9),
			ZIndex = 5,
		})
		corner(999).Parent = dot
	end

	local title = makeLabel(topbar, config.Title or config.Name or "Krass Terminal", 17, theme.Text, true)
	title.Position = UDim2.fromOffset(64, 7)
	title.Size = UDim2.new(1, -205, 0, 24)
	title.ZIndex = 4

	local subtitle = makeLabel(topbar, config.Subtitle or "root@linux:~$ ./interface", 11, theme.Muted, false)
	subtitle.Position = UDim2.fromOffset(64, 29)
	subtitle.Size = UDim2.new(1, -205, 0, 18)
	subtitle.ZIndex = 4

	local close = makeButton(topbar, "X", theme.Panel2, theme.Muted)
	close.Position = UDim2.new(1, -44, 0, 11)
	close.Size = UDim2.fromOffset(32, 32)
	close.ZIndex = 5
	corner(4).Parent = close

	local minimize = makeButton(topbar, "-", theme.Panel2, theme.Muted)
	minimize.Position = UDim2.new(1, -82, 0, 11)
	minimize.Size = UDim2.fromOffset(32, 32)
	minimize.ZIndex = 5
	corner(4).Parent = minimize

	local sidebar = new("Frame", {
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Parent = root,
		Position = UDim2.fromOffset(0, 57),
		Size = UDim2.new(0, 166, 1, -57),
		ZIndex = 3,
	})
	local sidebarLine = new("Frame", {
		BackgroundColor3 = theme.Stroke,
		BackgroundTransparency = 0.25,
		BorderSizePixel = 0,
		Parent = sidebar,
		Position = UDim2.new(1, -1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		ZIndex = 4,
	})
	padding(12).Parent = sidebar
	list(8).Parent = sidebar

	local pageHolder = new("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = root,
		Position = UDim2.fromOffset(166, 57),
		Size = UDim2.new(1, -166, 1, -57),
		ZIndex = 3,
	})

	local toastHolder = new("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Parent = gui,
		Position = UDim2.new(1, -18, 0, 18),
		Size = UDim2.fromOffset(320, 330),
		ZIndex = 50,
	})
	list(9).Parent = toastHolder

	local openButton = new("ImageButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		AutoButtonColor = false,
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Image = "",
		Parent = gui,
		Position = UDim2.new(1, -14, 0.5, 0),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromOffset(58, 58),
		Visible = false,
		ZIndex = 61,
	})
	corner(999).Parent = openButton
	local openButtonStroke = stroke(theme.Accent, 2, 0.05)
	openButtonStroke.Parent = openButton
	local openButtonScale = new("UIScale", {
		Parent = openButton,
		Scale = 0.72,
	})
	local openButtonFallback = makeLabel(openButton, ">_", 22, theme.Text, true)
	openButtonFallback.Size = UDim2.fromScale(1, 1)
	openButtonFallback.TextXAlignment = Enum.TextXAlignment.Center
	openButtonFallback.ZIndex = 62
	local openButtonGloss = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Parent = openButton,
		Position = UDim2.fromScale(-0.15, -0.1),
		Rotation = 18,
		Size = UDim2.fromScale(0.28, 1.25),
		ZIndex = 63,
	})
	gradient(openButtonGloss, Color3.fromRGB(255, 255, 255), theme.Accent, 90)

	local self = setmetatable({
		Blur = blur,
		BlurTarget = blurTarget,
		Gui = gui,
		Holder = holder,
		Root = root,
		RootStroke = rootStroke,
		Scale = scale,
		Shadow = shadow,
		Topbar = topbar,
		Title = title,
		Subtitle = subtitle,
		CloseButton = close,
		MinimizeButton = minimize,
		Sidebar = sidebar,
		PageHolder = pageHolder,
		BaseSize = baseSize,
		OpenButton = openButton,
		OpenButtonScale = openButtonScale,
		OpenButtonStroke = openButtonStroke,
		OpenButtonFallback = openButtonFallback,
		OpenButtonGloss = openButtonGloss,
		ToastHolder = toastHolder,
		Theme = theme,
		Tabs = {},
		CurrentTab = nil,
		IsCompact = false,
		SidebarWidth = 166,
		TabButtonHeight = 40,
		TabTextSize = 13,
		ToggleKey = config.ToggleKey or Enum.KeyCode.LeftShift,
		Visible = true,
		AnimationToken = 0,
		Connections = {},
		OnClose = config.OnClose,
	}, Window)

	makeDraggable(holder, topbar, self)

	self:_connect(close.MouseEnter, function()
		tween(close, { BackgroundColor3 = theme.Danger, TextColor3 = Color3.new(1, 1, 1) }, 0.14)
	end)
	self:_connect(close.MouseLeave, function()
		tween(close, { BackgroundColor3 = theme.Panel2, TextColor3 = theme.Muted }, 0.14)
	end)
	self:_connect(close.MouseButton1Click, function()
		if self.OnClose then
			pcall(self.OnClose)
		end
		self:Destroy()
	end)

	self:_connect(minimize.MouseEnter, function()
		tween(minimize, { BackgroundColor3 = theme.Panel3, TextColor3 = theme.Text }, 0.14)
	end)
	self:_connect(minimize.MouseLeave, function()
		tween(minimize, { BackgroundColor3 = theme.Panel2, TextColor3 = theme.Muted }, 0.14)
	end)
	self:_connect(minimize.MouseButton1Click, function()
		self:SetVisible(false)
	end)

	self:_connect(openButton.MouseEnter, function()
		tween(openButton, { BackgroundColor3 = theme.Panel3 }, 0.14)
		tween(openButtonScale, { Scale = 1.06 }, 0.2, Enum.EasingStyle.Back)
		tween(openButtonStroke, { Transparency = 0, Thickness = 3 }, 0.14)
	end)
	self:_connect(openButton.MouseLeave, function()
		tween(openButton, { BackgroundColor3 = theme.Panel }, 0.14)
		tween(openButtonScale, { Scale = 1 }, 0.18, Enum.EasingStyle.Back)
		tween(openButtonStroke, { Transparency = 0.05, Thickness = 2 }, 0.14)
	end)
	self:_connect(openButton.MouseButton1Down, function()
		tween(openButtonScale, { Scale = 0.92 }, 0.08, Enum.EasingStyle.Quad)
	end)
	self:_connect(openButton.MouseButton1Up, function()
		tween(openButtonScale, { Scale = 1 }, 0.2, Enum.EasingStyle.Back)
	end)
	self:_connect(openButton.MouseButton1Click, function()
		self:SetVisible(true)
	end)

	holder.Visible = true
	holder.Position = UDim2.fromScale(0.5, 0.5)
	root.Rotation = -4
	root.BackgroundTransparency = 0.16
	rootStroke.Transparency = 0.85
	tween(root, { BackgroundTransparency = 0, Rotation = 0 }, 0.46, Enum.EasingStyle.Back)
	tween(rootStroke, { Transparency = 0.12, Color = theme.Accent }, 0.22, Enum.EasingStyle.Quint).Completed:Once(function()
		if rootStroke.Parent then
			tween(rootStroke, { Color = theme.Stroke }, 0.32, Enum.EasingStyle.Quint)
		end
	end)
	tween(scale, { Scale = 1 }, 0.5, Enum.EasingStyle.Back)
	tween(shadow, { ImageTransparency = 1 }, 0.18, Enum.EasingStyle.Quint)
	if blur then
		tween(blur, { Size = blurTarget }, 0.28, Enum.EasingStyle.Quint)
	end

	return self
end

function Window:GetViewportSize()
	local camera = Workspace.CurrentCamera
	if camera and camera.ViewportSize.X > 0 and camera.ViewportSize.Y > 0 then
		return camera.ViewportSize
	end
	if self.Gui and self.Gui.AbsoluteSize.X > 0 and self.Gui.AbsoluteSize.Y > 0 then
		return self.Gui.AbsoluteSize
	end
	return Vector2.new(1280, 720)
end

function Window:ApplyResponsiveLayout(skipAnimation)
	local viewport = self:GetViewportSize()
	local isTouch = UserInputService.TouchEnabled
	local compact = viewport.X < 760 or viewport.Y < 540 or (isTouch and viewport.X < 930)
	local sideWidth = compact and 118 or 166
	local windowWidth = compact and math.min(690, math.max(290, viewport.X - 22)) or self.BaseSize.X.Offset
	local windowHeight = compact and math.min(520, math.max(340, viewport.Y - 72)) or self.BaseSize.Y.Offset
	local topbarHeight = compact and 52 or 54
	local contentTop = topbarHeight + 3
	local sidebarPadding = compact and 8 or 12
	local tabHeight = compact and 36 or 40
	local tabTextSize = compact and 11 or 13
	local pagePadding = compact and 9 or 14
	local titleSize = compact and 15 or 17
	local subtitleSize = compact and 10 or 11

	self.IsCompact = compact
	self.SidebarWidth = sideWidth
	self.TabButtonHeight = tabHeight
	self.TabTextSize = tabTextSize

	local function applyOrTween(instance, goal, time)
		if skipAnimation then
			for key, value in pairs(goal) do
				instance[key] = value
			end
		else
			tween(instance, goal, time or 0.18)
		end
	end

	applyOrTween(self.Holder, {
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(windowWidth, windowHeight),
	}, 0.2)
	self.Topbar.Size = UDim2.new(1, 0, 0, topbarHeight)
	self.Title.Position = UDim2.fromOffset(compact and 50 or 64, compact and 6 or 7)
	self.Title.Size = UDim2.new(1, compact and -150 or -205, 0, 23)
	self.Title.TextSize = titleSize
	self.Subtitle.Position = UDim2.fromOffset(compact and 50 or 64, compact and 28 or 29)
	self.Subtitle.Size = UDim2.new(1, compact and -150 or -205, 0, 18)
	self.Subtitle.TextSize = subtitleSize

	local buttonSize = compact and 34 or 32
	local buttonTop = compact and 9 or 11
	self.CloseButton.Position = UDim2.new(1, compact and -42 or -44, 0, buttonTop)
	self.CloseButton.Size = UDim2.fromOffset(buttonSize, buttonSize)
	self.MinimizeButton.Position = UDim2.new(1, compact and -82 or -82, 0, buttonTop)
	self.MinimizeButton.Size = UDim2.fromOffset(buttonSize, buttonSize)

	self.Sidebar.Position = UDim2.fromOffset(0, contentTop)
	self.Sidebar.Size = UDim2.new(0, sideWidth, 1, -contentTop)
	local sidebarPad = self.Sidebar:FindFirstChildOfClass("UIPadding")
	if sidebarPad then
		sidebarPad.PaddingBottom = UDim.new(0, sidebarPadding)
		sidebarPad.PaddingLeft = UDim.new(0, sidebarPadding)
		sidebarPad.PaddingRight = UDim.new(0, sidebarPadding)
		sidebarPad.PaddingTop = UDim.new(0, sidebarPadding)
	end
	local sidebarList = self.Sidebar:FindFirstChildOfClass("UIListLayout")
	if sidebarList then
		sidebarList.Padding = UDim.new(0, compact and 6 or 8)
	end

	self.PageHolder.Position = UDim2.fromOffset(sideWidth, contentTop)
	self.PageHolder.Size = UDim2.new(1, -sideWidth, 1, -contentTop)

	for _, tab in ipairs(self.Tabs or {}) do
		tab.Button.Size = UDim2.new(1, 0, 0, tabHeight)
		tab.Label.Position = UDim2.fromOffset(compact and 9 or 14, 0)
		tab.Label.Size = UDim2.new(1, compact and -14 or -24, 1, 0)
		tab.Label.TextSize = tabTextSize
		tab.Page.Position = UDim2.fromOffset(0, 0)
		tab.Page.Size = UDim2.fromScale(1, 1)
		tab.Page.ScrollBarThickness = compact and 4 or 3
		local pad = tab.Page:FindFirstChildOfClass("UIPadding")
		if pad then
			pad.PaddingBottom = UDim.new(0, pagePadding)
			pad.PaddingLeft = UDim.new(0, pagePadding)
			pad.PaddingRight = UDim.new(0, pagePadding)
			pad.PaddingTop = UDim.new(0, pagePadding)
		end
	end

	self.OpenButton.Size = UDim2.fromOffset(compact and 64 or 58, compact and 64 or 58)
	self.OpenButton.Position = UDim2.new(1, compact and -10 or -14, 0.5, 0)
	self.OpenButtonFallback.TextSize = compact and 24 or 22
	self.ToastHolder.Position = UDim2.new(1, compact and -10 or -18, 0, compact and 10 or 18)
	self.ToastHolder.Size = UDim2.fromOffset(math.max(240, math.min(320, viewport.X - 20)), 330)
end

function Window:SetVisible(visible)
	self.AnimationToken = (self.AnimationToken or 0) + 1
	local token = self.AnimationToken
	self.Visible = visible

	if visible then
		self.Holder.Visible = true
		if self.OpenButton then
			tween(self.OpenButtonScale, { Scale = 0.72 }, 0.14, Enum.EasingStyle.Quad)
			tween(self.OpenButton, { ImageTransparency = 1, BackgroundTransparency = 1 }, 0.14, Enum.EasingStyle.Quad).Completed:Once(function()
				if token == self.AnimationToken and self.Visible then
					self.OpenButton.Visible = false
					self.OpenButton.BackgroundTransparency = 0
					self.OpenButton.ImageTransparency = 0
				end
			end)
		end
		self.PageHolder.Visible = false
		if self.CurrentTab then
			self.CurrentTab.Page.Visible = true
		end
		self.Scale.Scale = 0.78
		self.Root.Rotation = -4
		self.Root.BackgroundTransparency = 0.16
		self.RootStroke.Transparency = 0.85
		tween(self.Root, { BackgroundTransparency = 0, Rotation = 0 }, 0.4, Enum.EasingStyle.Back)
		tween(self.RootStroke, { Transparency = 0.12, Color = self.Theme.Accent }, 0.2, Enum.EasingStyle.Quint).Completed:Once(function()
			if self.Visible and self.RootStroke.Parent then
				tween(self.RootStroke, { Color = self.Theme.Stroke }, 0.3, Enum.EasingStyle.Quint)
			end
		end)
		tween(self.Scale, { Scale = 1 }, 0.46, Enum.EasingStyle.Back)
		tween(self.Shadow, { ImageTransparency = 1 }, 0.16, Enum.EasingStyle.Quint)
		if self.Blur then
			tween(self.Blur, { Size = self.BlurTarget }, 0.24, Enum.EasingStyle.Quint)
		end
		task.delay(0.24, function()
			if token == self.AnimationToken and self.Visible then
				self.PageHolder.Visible = true
			end
		end)
	else
		self.PageHolder.Visible = false
		tween(self.Root, { BackgroundTransparency = 0.18, Rotation = 4 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tween(self.RootStroke, { Transparency = 0.8 }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tween(self.Scale, { Scale = 0.76 }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		tween(self.Shadow, { ImageTransparency = 1 }, 0.16, Enum.EasingStyle.Quad)
		if self.Blur then
			tween(self.Blur, { Size = 0 }, 0.16, Enum.EasingStyle.Quad)
		end
		task.delay(0.21, function()
			if token == self.AnimationToken and not self.Visible then
				self.Holder.Visible = false
				self.Root.Rotation = 0
				self.Root.BackgroundTransparency = 0
				self.RootStroke.Color = self.Theme.Stroke
				self.RootStroke.Transparency = 0.12
				self.Scale.Scale = 1
				self.PageHolder.Visible = true
				if self.OpenButton then
					self.OpenButton.Visible = true
					self.OpenButton.ImageTransparency = 1
					self.OpenButton.BackgroundTransparency = 1
					self.OpenButtonScale.Scale = 0.72
					tween(self.OpenButton, { ImageTransparency = 0, BackgroundTransparency = 0 }, 0.2, Enum.EasingStyle.Quint)
					tween(self.OpenButtonScale, { Scale = 1 }, 0.32, Enum.EasingStyle.Back)
				end
			end
		end)
	end
end

function Window:Destroy()
	for _, connection in ipairs(self.Connections or {}) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	self.Connections = {}
	if self.Blur then
		self.Blur:Destroy()
	end
	self.Gui:Destroy()
end

function Window:Notify(titleText, bodyText, duration)
	local theme = self.Theme
	local lifetime = duration or 3

	local toast = new("Frame", {
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.ToastHolder,
		Size = UDim2.fromOffset(320, bodyText and 82 or 58),
		ZIndex = 51,
	})
	corner(10).Parent = toast
	stroke(theme.Stroke, 1, 0.2).Parent = toast

	local scale = new("UIScale", {
		Parent = toast,
		Scale = 0.86,
	})

	local accent = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = toast,
		Size = UDim2.new(0, 4, 1, 0),
		ZIndex = 52,
	})
	gradient(accent, theme.Accent, theme.Accent2, 90)

	local title = makeLabel(toast, titleText, 14, theme.Text, true)
	title.Position = UDim2.fromOffset(16, 8)
	title.Size = UDim2.new(1, -30, 0, 24)
	title.ZIndex = 53

	if bodyText then
		local body = makeLabel(toast, bodyText, 12, theme.Muted, false)
		body.Position = UDim2.fromOffset(16, 34)
		body.Size = UDim2.new(1, -30, 0, 34)
		body.TextWrapped = true
		body.TextYAlignment = Enum.TextYAlignment.Top
		body.ZIndex = 53
	end

	local progress = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = toast,
		Position = UDim2.new(0, 0, 1, -3),
		Size = UDim2.new(1, 0, 0, 3),
		ZIndex = 52,
	})
	gradient(progress, theme.Accent, theme.Accent2, 0)

	tween(scale, { Scale = 1 }, 0.32, Enum.EasingStyle.Back)
	tween(progress, { Size = UDim2.new(0, 0, 0, 3) }, lifetime, Enum.EasingStyle.Linear)

	task.delay(lifetime, function()
		if not toast.Parent then
			return
		end
		tween(scale, { Scale = 0.86 }, 0.18, Enum.EasingStyle.Quad)
		tween(toast, { BackgroundTransparency = 1 }, 0.18).Completed:Once(function()
			toast:Destroy()
		end)
	end)
end

function Window:Tab(name)
	local theme = self.Theme

	local page = new("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		ClipsDescendants = true,
		Parent = self.PageHolder,
		Position = UDim2.fromOffset(0, 0),
		ScrollBarImageColor3 = theme.Accent,
		ScrollBarThickness = 3,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 4,
	})
	padding(14).Parent = page
	list(12).Parent = page
	local pageScale = new("UIScale", {
		Parent = page,
		Scale = 1,
	})

	local button = makeButton(self.Sidebar, "", theme.Panel2, theme.Muted)
	button.Size = UDim2.new(1, 0, 0, 40)
	button.Text = ""
	button.ZIndex = 5
	corner(4).Parent = button
	local buttonStroke = stroke(theme.Stroke, 1, 0.5)
	buttonStroke.Parent = button
	local buttonScale = new("UIScale", {
		Parent = button,
		Scale = 1,
	})

	local activeRail = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = button,
		Position = UDim2.fromOffset(0, 20),
		Size = UDim2.fromOffset(3, 0),
		Visible = true,
		ZIndex = 6,
	})
	corner(4).Parent = activeRail
	gradient(activeRail, theme.Accent, theme.Accent2, 90)

	local text = makeLabel(button, name, 13, theme.Muted, true)
	text.Position = UDim2.fromOffset(14, 0)
	text.Size = UDim2.new(1, -24, 1, 0)
	text.ZIndex = 6

	local tab = setmetatable({
		Button = button,
		ButtonScale = buttonScale,
		ButtonStroke = buttonStroke,
		Label = text,
		Name = name,
		Page = page,
		PageScale = pageScale,
		Rail = activeRail,
		Sections = {},
		Window = self,
	}, Tab)

	table.insert(self.Tabs, tab)
	self:ApplyResponsiveLayout(true)

	button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	button.MouseEnter:Connect(function()
		if self.CurrentTab ~= tab then
			tween(button, { BackgroundColor3 = theme.Panel3 }, 0.14)
			tween(buttonStroke, { Transparency = 0.25 }, 0.14)
		end
	end)

	button.MouseLeave:Connect(function()
		if self.CurrentTab ~= tab then
			tween(button, { BackgroundColor3 = theme.Panel2 }, 0.14)
			tween(buttonStroke, { Transparency = 0.5 }, 0.14)
		end
	end)

	if not self.CurrentTab then
		self:SelectTab(tab)
	end

	return tab
end

function Window:SelectTab(tab)
	local theme = self.Theme

	for _, item in ipairs(self.Tabs) do
		local active = item == tab
		item.Page.Visible = active
		tween(item.Button, {
			BackgroundColor3 = active and theme.Accent or theme.Panel2,
		}, active and 0.2 or 0.16, Enum.EasingStyle.Quint)
		tween(item.ButtonScale, {
			Scale = active and 1.025 or 1,
		}, active and 0.28 or 0.16, active and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
		tween(item.ButtonStroke, {
			Color = active and theme.Accent or theme.Stroke,
			Transparency = active and 0.1 or 0.5,
		}, 0.18, Enum.EasingStyle.Quint)
		tween(item.Label, {
			TextColor3 = active and theme.DarkText or theme.Muted,
		}, 0.18, Enum.EasingStyle.Quint)
		tween(item.Rail, {
			BackgroundTransparency = active and 0 or 1,
			Position = active and UDim2.fromOffset(0, 9) or UDim2.fromOffset(0, 20),
			Size = active and UDim2.fromOffset(3, 22) or UDim2.fromOffset(3, 0),
		}, active and 0.26 or 0.14, Enum.EasingStyle.Quint)
	end

	tab.Page.CanvasPosition = Vector2.new(0, 0)
	local startOffset = self.IsCompact and 8 or 18
	tab.Page.Position = UDim2.fromOffset(startOffset, 0)
	tab.Page.Size = UDim2.new(1, -startOffset, 1, 0)
	tab.PageScale.Scale = 0.985
	tween(tab.Page, {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
	}, 0.32, Enum.EasingStyle.Quint)
	tween(tab.PageScale, {
		Scale = 1,
	}, 0.34, Enum.EasingStyle.Back)

	self.CurrentTab = tab
end

function Tab:Section(titleText)
	local theme = self.Window.Theme

	local frame = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.Page,
		Size = UDim2.new(1, 0, 0, 0),
		ZIndex = 4,
	})
	corner(5).Parent = frame
	stroke(theme.Stroke, 1, 0.25).Parent = frame
	padding(12).Parent = frame
	list(10).Parent = frame

	local header = new("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 24),
		ZIndex = 5,
	})

	local accent = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = header,
		Position = UDim2.fromOffset(0, 7),
		Size = UDim2.fromOffset(5, 14),
		ZIndex = 6,
	})
	corner(2).Parent = accent
	gradient(accent, theme.Accent, theme.Accent2, 90)

	local title = makeLabel(header, titleText, 14, theme.Text, true)
	title.Position = UDim2.fromOffset(12, 0)
	title.Size = UDim2.new(1, -12, 1, 0)
	title.ZIndex = 6

	local content = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 0),
		ZIndex = 5,
	})
	list(8).Parent = content

	local section = setmetatable({
		Content = content,
		Count = 0,
		Frame = frame,
		Window = self.Window,
	}, Section)

	table.insert(self.Sections, section)
	return section
end

function Section:_baseRow(height)
	local theme = self.Window.Theme
	self.Count = self.Count + 1

	local row = new("Frame", {
		BackgroundColor3 = theme.Panel2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.Content,
		Size = UDim2.new(1, 0, 0, height or 44),
		ZIndex = 6,
	})
	corner(4).Parent = row

	local rowStroke = stroke(theme.Stroke, 1, 0.85)
	rowStroke.Parent = row

	local rowScale = new("UIScale", {
		Parent = row,
		Scale = 0.96,
	})

	task.delay(self.Count * 0.025, function()
		if not row.Parent then
			return
		end
		tween(row, { BackgroundTransparency = 0 }, 0.18)
		tween(rowStroke, { Transparency = 0.45 }, 0.18)
		tween(rowScale, { Scale = 1 }, 0.36, Enum.EasingStyle.Back)
	end)

	return row, rowStroke
end

function Section:Label(text)
	local theme = self.Window.Theme
	local row = self:_baseRow(36)
	local label = makeLabel(row, text, 12, theme.Muted, false)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -24, 1, 0)
	label.ZIndex = 7
	return setmetatable({
		Instance = row,
		Label = label,
		Set = function(nextText, color)
			label.Text = nextText
			if color then
				label.TextColor3 = color
			end
		end,
	}, Control)
end

function Section:Button(text, callback)
	local theme = self.Window.Theme
	local row, rowStroke = self:_baseRow(44)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -44, 1, 0)
	label.ZIndex = 7

	local arrow = makeLabel(row, ">", 15, theme.Muted, true)
	arrow.Position = UDim2.new(1, -32, 0, 0)
	arrow.Size = UDim2.fromOffset(20, 44)
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.ZIndex = 7

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.fromScale(1, 1)
	hit.ZIndex = 8

	pressable(hit, row, rowStroke, theme, function()
		tween(arrow, { Position = UDim2.new(1, -26, 0, 0), TextColor3 = theme.Accent }, 0.08)
		task.delay(0.08, function()
			if arrow.Parent then
				tween(arrow, { Position = UDim2.new(1, -32, 0, 0), TextColor3 = theme.Muted }, 0.2)
			end
		end)
		if callback then
			callback()
		end
	end)

	return setmetatable({ Instance = row }, Control)
end

function Section:Toggle(text, default, callback)
	local theme = self.Window.Theme
	local enabled = default == true
	local row, rowStroke = self:_baseRow(46)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -82, 1, 0)
	label.ZIndex = 7

	local switch = new("Frame", {
		BackgroundColor3 = enabled and theme.Accent or theme.Panel3,
		BorderSizePixel = 0,
		Parent = row,
		Position = UDim2.new(1, -58, 0.5, -12),
		Size = UDim2.fromOffset(46, 24),
		ZIndex = 7,
	})
	corner(999).Parent = switch
	local switchGradient = gradient(switch, theme.Accent, theme.Accent2, 0)
	switchGradient.Enabled = enabled

	local knob = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = switch,
		Position = enabled and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(18, 18),
		ZIndex = 8,
	})
	corner(999).Parent = knob

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.fromScale(1, 1)
	hit.ZIndex = 9

	local function set(value, fire)
		enabled = value
		tween(switch, {
			BackgroundColor3 = enabled and theme.Accent or theme.Panel3,
		}, 0.16)
		switchGradient.Enabled = enabled
		tween(knob, {
			Position = enabled and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3),
		}, 0.25, Enum.EasingStyle.Back)
		tween(rowStroke, {
			Color = enabled and theme.Accent or theme.Stroke,
			Transparency = enabled and 0.18 or 0.45,
		}, 0.18)
		if callback and fire ~= false then
			task.spawn(callback, enabled)
		end
	end

	pressable(hit, row, rowStroke, theme, function()
		set(not enabled)
	end)

	if callback then
		task.spawn(callback, enabled)
	end

	return setmetatable({
		Instance = row,
		Get = function()
			return enabled
		end,
		Set = set,
	}, Control)
end

function Control:Destroy()
	if self.Instance then
		self.Instance:Destroy()
	end
end

function Section:Textbox(text, placeholder, callback)
	local theme = self.Window.Theme
	local row, rowStroke = self:_baseRow(46)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -82, 1, 0)
	label.ZIndex = 7

	local textbox = new("TextBox", {
		BackgroundColor3 = theme.Panel3,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		PlaceholderColor3 = theme.Muted,
		PlaceholderText = placeholder or "",
		Parent = row,
		Position = UDim2.new(1, -78, 0.5, -15),
		Size = UDim2.fromOffset(66, 30),
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 13,
		ZIndex = 8,
	})
	corner(4).Parent = textbox
	stroke(theme.Stroke, 1, 0.4).Parent = textbox

	textbox.FocusLost:Connect(function(enterPressed)
		if callback then
			task.spawn(callback, textbox.Text, enterPressed)
		end
	end)

	return setmetatable({
		Instance = row,
		Get = function()
			return textbox.Text
		end,
		Set = function(text)
			textbox.Text = text
		end,
	}, Control)
end

function Section:Slider(text, default, min, max, callback)
	local theme = self.Window.Theme
	local value = default or min
	local precision = 0
	local step = (max - min) / 100
	
	-- Auto-detect precision from default value
	if type(default) == "number" then
		local str = tostring(default)
		if str:find("%.") then
			precision = #str:split("%.") - 1
		end
	end
	
	local row, rowStroke = self:_baseRow(46)

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = UDim2.fromOffset(12, 0)
	label.Size = UDim2.new(1, -82, 1, 0)
	label.ZIndex = 7

	local valueLabel = makeLabel(row, tostring(value), 13, theme.Accent, true)
	valueLabel.Position = UDim2.new(1, -58, 0.5, -10)
	valueLabel.Size = UDim2.fromOffset(46, 20)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
	valueLabel.ZIndex = 7

	local sliderFrame = new("Frame", {
		BackgroundColor3 = theme.Panel3,
		BorderSizePixel = 0,
		Parent = row,
		Position = UDim2.fromOffset(12, 32),
		Size = UDim2.new(1, -24, 0, 6),
		ZIndex = 7,
	})
	corner(3).Parent = sliderFrame

	local fill = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = sliderFrame,
		Size = UDim2.fromScale((value - min) / (max - min), 1),
		ZIndex = 8,
	})
	corner(3).Parent = fill
	gradient(fill, theme.Accent, theme.Accent2, 0)

	local knob = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = sliderFrame,
		Position = UDim2.fromScale((value - min) / (max - min), 0.5),
		Size = UDim2.fromOffset(14, 14),
		ZIndex = 9,
	})
	corner(999).Parent = knob

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.fromScale(1, 1)
	hit.ZIndex = 10

	local function formatValue(v)
		if precision > 0 then
			return string.format("%." .. precision .. "f", v)
		end
		return tostring(math.floor(v))
	end

	local function setValue(newValue, fire)
		value = math.clamp(newValue, min, max)
		local ratio = (value - min) / (max - min)
		valueLabel.Text = formatValue(value)
		fill.Size = UDim2.fromScale(ratio, 1)
		knob.Position = UDim2.fromScale(ratio, 0.5)
		if callback and fire ~= false then
			task.spawn(callback, value)
		end
	end

	local function getValueFromMouse()
		local mousePos = UserInputService:GetMouseLocation()
		local sliderPos = sliderFrame.AbsolutePosition
		local sliderSize = sliderFrame.AbsoluteSize
		local ratio = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
		return min + ratio * (max - min)
	end

	local dragging = false
	local dragConnection = nil
	local upConnection = nil
	local leaveConnection = nil

	hit.MouseButton1Down:Connect(function()
		dragging = true
		setValue(getValueFromMouse(), false)
		
		dragConnection = UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				setValue(getValueFromMouse(), false)
			end
		end)
		
		upConnection = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if dragging then
					dragging = false
					setValue(getValueFromMouse(), true)
					if dragConnection then dragConnection:Disconnect() end
					if upConnection then upConnection:Disconnect() end
					if leaveConnection then leaveConnection:Disconnect() end
				end
			end
		end)
	end)

	-- Click to jump to position
	hit.MouseButton1Click:Connect(function()
		if not dragging then
			setValue(getValueFromMouse(), true)
		end
	end)

	if callback then
		task.spawn(callback, value)
	end

	return setmetatable({
		Instance = row,
		Get = function()
			return value
		end,
		Set = function(v, fire)
			setValue(v, fire)
		end,
	}, Control)
end

function Section:Dropdown(text, options, default, callback)
	local theme = self.Window.Theme
	local compact = self.Window.IsCompact
	local selected = (type(default) == "string" and default ~= "") and default or options[1] or ""
	local open = false
	local row, rowStroke = self:_baseRow(46)
	row.ClipsDescendants = true

	local label = makeLabel(row, text, 13, theme.Text, true)
	label.Position = compact and UDim2.fromOffset(12, 3) or UDim2.fromOffset(12, 0)
	label.Size = compact and UDim2.new(1, -52, 0, 20) or UDim2.new(1, -210, 0, 46)
	label.TextSize = compact and 12 or 13
	label.ZIndex = 7

	local selectedLabel = makeLabel(row, selected, 12, theme.Muted, true)
	selectedLabel.Position = compact and UDim2.fromOffset(12, 22) or UDim2.new(1, -176, 0, 0)
	selectedLabel.Size = compact and UDim2.new(1, -52, 0, 22) or UDim2.fromOffset(132, 46)
	selectedLabel.TextXAlignment = compact and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
	selectedLabel.ZIndex = 7

	local arrow = makeLabel(row, ">", 15, theme.Muted, true)
	arrow.Position = UDim2.new(1, -32, 0, 0)
	arrow.Size = UDim2.fromOffset(20, 46)
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.ZIndex = 7

	local holder = new("Frame", {
		BackgroundTransparency = 1,
		Parent = row,
		Position = UDim2.fromOffset(8, 48),
		Size = UDim2.new(1, -16, 0, math.max(1, #options) * 34),
		ZIndex = 7,
	})
	list(6).Parent = holder

	local function choose(option, fire)
		selected = option
		selectedLabel.Text = option
		if callback and fire ~= false then
			task.spawn(callback, selected)
		end
	end

	for _, option in ipairs(options) do
		local optionButton = makeButton(holder, option, theme.Panel3, theme.Text)
		optionButton.Size = UDim2.new(1, 0, 0, 30)
		optionButton.TextXAlignment = Enum.TextXAlignment.Left
		optionButton.ZIndex = 8
		corner(4).Parent = optionButton
		padding(10).Parent = optionButton

		optionButton.MouseEnter:Connect(function()
			tween(optionButton, { BackgroundColor3 = theme.Accent, TextColor3 = theme.DarkText }, 0.12)
		end)
		optionButton.MouseLeave:Connect(function()
			tween(optionButton, { BackgroundColor3 = theme.Panel3, TextColor3 = theme.Text }, 0.12)
		end)
		optionButton.MouseButton1Down:Connect(function(x, y)
			ripple(optionButton, x, y, Color3.fromRGB(255, 255, 255))
		end)
		optionButton.MouseButton1Click:Connect(function()
			choose(option)
			open = false
			tween(row, { Size = UDim2.new(1, 0, 0, 46) }, 0.2)
			tween(arrow, { Rotation = 0 }, 0.2)
		end)
	end

	local hit = makeButton(row, "", theme.Panel2, theme.Text)
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.new(1, 0, 0, 46)
	hit.ZIndex = 9

	pressable(hit, row, rowStroke, theme, function()
		open = not open
		local targetHeight = open and (54 + math.max(1, #options) * 36) or 46
		tween(row, { Size = UDim2.new(1, 0, 0, targetHeight) }, 0.22, Enum.EasingStyle.Quint)
		tween(arrow, { Rotation = open and 90 or 0 }, 0.22)
	end)

	if callback and selected ~= "" then
		task.spawn(callback, selected)
	end

	return setmetatable({
		Instance = row,
		Get = function()
			return selected
		end,
		Set = choose,
	}, Control)
end

-- Library pura: carregue este arquivo e crie sua UI em outro script.
return KrassUI
