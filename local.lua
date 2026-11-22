print("[Full Access] LocalScript запустился")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Защита от дубля (после смерти/респавна)
if playerGui:FindFirstChild("FullAccessGui") then
	return
end

local remote = ReplicatedStorage:WaitForChild("ExecuteCode")

-- Авторизация через сервер (список на GitHub)
local checkAccess = ReplicatedStorage:WaitForChild("CheckAccess")
local okAccess, allowed = pcall(function()
	return checkAccess:InvokeServer()
end)
if not okAccess or not allowed then
	warn("[Full Access] Нет доступа: тебя нет в списке на GitHub")
	return
end
print("[Full Access] Доступ разрешён")

----------------------------------------------------------------
-- ЦВЕТОВАЯ СХЕМА
----------------------------------------------------------------
local COL_BG        = Color3.fromRGB(26, 27, 31)
local COL_PANEL     = Color3.fromRGB(34, 36, 41)
local COL_HEADER_1  = Color3.fromRGB(45, 48, 56)
local COL_HEADER_2  = Color3.fromRGB(30, 32, 37)
local COL_ACCENT    = Color3.fromRGB(94, 129, 244)
local COL_TEXT      = Color3.fromRGB(235, 236, 240)
local COL_SUBTEXT   = Color3.fromRGB(150, 153, 161)
local COL_STROKE    = Color3.fromRGB(55, 58, 66)
local COL_CLEAR     = Color3.fromRGB(52, 55, 62)
local COL_CLEAR_HV  = Color3.fromRGB(64, 67, 76)
local COL_EXEC      = Color3.fromRGB(94, 129, 244)
local COL_EXEC_HV   = Color3.fromRGB(112, 144, 250)

----------------------------------------------------------------
-- ScreenGui
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FullAccessGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

----------------------------------------------------------------
-- Главное окно
----------------------------------------------------------------
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(540, 320)
main.BackgroundColor3 = COL_PANEL
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = COL_STROKE
mainStroke.Thickness = 1

-- Шапка с градиентом
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = COL_HEADER_1
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local headerFix = Instance.new("Frame") -- скрывает скругление снизу шапки
headerFix.Size = UDim2.new(1, 0, 0, 16)
headerFix.Position = UDim2.new(0, 0, 1, -16)
headerFix.BackgroundColor3 = COL_HEADER_1
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 0
headerFix.Parent = header

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new(COL_HEADER_1, COL_HEADER_2)
headerGradient.Rotation = 90
headerGradient.Parent = header

local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0, 4, 0, 22)
accentBar.Position = UDim2.fromOffset(18, 14)
accentBar.BackgroundColor3 = COL_ACCENT
accentBar.BorderSizePixel = 0
accentBar.Parent = header
Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(32, 0)
title.Size = UDim2.new(1, -140, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "Full Access"
title.TextSize = 20
title.TextColor3 = COL_TEXT
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local hideBtn = Instance.new("TextButton")
hideBtn.AnchorPoint = Vector2.new(1, 0.5)
hideBtn.Position = UDim2.new(1, -52, 0.5, 0)
hideBtn.Size = UDim2.fromOffset(88, 28)
hideBtn.BackgroundColor3 = COL_CLEAR
hideBtn.BorderSizePixel = 0
hideBtn.AutoButtonColor = false
hideBtn.Font = Enum.Font.GothamSemibold
hideBtn.Text = "Hide"
hideBtn.TextSize = 13
hideBtn.TextColor3 = COL_TEXT
hideBtn.Parent = header
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -14, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(32, 32)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.TextSize = 18
closeBtn.TextColor3 = COL_SUBTEXT
closeBtn.Parent = header

----------------------------------------------------------------
-- Поле для кода
----------------------------------------------------------------
local editorFrame = Instance.new("Frame")
editorFrame.Position = UDim2.fromOffset(16, 64)
editorFrame.Size = UDim2.new(1, -32, 0, 186)
editorFrame.BackgroundColor3 = COL_BG
editorFrame.BorderSizePixel = 0
editorFrame.Parent = main
Instance.new("UICorner", editorFrame).CornerRadius = UDim.new(0, 10)
local editorStroke = Instance.new("UIStroke", editorFrame)
editorStroke.Color = COL_STROKE
editorStroke.Thickness = 1

local editor = Instance.new("ScrollingFrame")
editor.Position = UDim2.fromOffset(1, 1)
editor.Size = UDim2.new(1, -2, 1, -2)
editor.BackgroundTransparency = 1
editor.BorderSizePixel = 0
editor.ScrollBarThickness = 4
editor.ScrollBarImageColor3 = COL_STROKE
editor.AutomaticCanvasSize = Enum.AutomaticSize.XY
editor.CanvasSize = UDim2.new()
editor.ClipsDescendants = true
editor.Parent = editorFrame

local editorPad = Instance.new("UIPadding")
editorPad.PaddingTop = UDim.new(0, 10)
editorPad.PaddingLeft = UDim.new(0, 10)
editorPad.Parent = editor

local lineNumbers = Instance.new("TextLabel")
lineNumbers.BackgroundTransparency = 1
lineNumbers.Position = UDim2.fromOffset(0, 0)
lineNumbers.Size = UDim2.fromOffset(30, 0)
lineNumbers.AutomaticSize = Enum.AutomaticSize.Y
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = 16
lineNumbers.LineHeight = 1.15
lineNumbers.Text = "1"
lineNumbers.TextColor3 = Color3.fromRGB(90, 93, 102)
lineNumbers.TextXAlignment = Enum.TextXAlignment.Right
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Parent = editor

local box = Instance.new("TextBox")
box.BackgroundTransparency = 1
box.Position = UDim2.fromOffset(40, 0)
box.Size = UDim2.new(1, -50, 0, 0)
box.AutomaticSize = Enum.AutomaticSize.XY
box.Font = Enum.Font.Code
box.TextSize = 16
box.LineHeight = 1.15
box.Text = ""
box.PlaceholderText = "Write your code here..."
box.PlaceholderColor3 = Color3.fromRGB(110, 113, 122)
box.TextColor3 = COL_TEXT
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextWrapped = false
box.Parent = editor

local function updateLines()
	local _, count = string.gsub(box.Text, "\n", "\n")
	local nums = table.create(count + 1)
	for i = 1, count + 1 do
		nums[i] = tostring(i)
	end
	lineNumbers.Text = table.concat(nums, "\n")
end
box:GetPropertyChangedSignal("Text"):Connect(updateLines)

----------------------------------------------------------------
-- Кнопки CLEAR / EXECUTE
----------------------------------------------------------------
local function makeButton(text, anchorRight, offsetX, idleColor, hoverColor, textColor)
	local b = Instance.new("TextButton")
	b.AnchorPoint = anchorRight and Vector2.new(1, 0) or Vector2.new(0, 0)
	b.Position = UDim2.new(anchorRight and 1 or 0, offsetX, 0, 266)
	b.Size = UDim2.fromOffset(170, 38)
	b.BackgroundColor3 = idleColor
	b.BorderSizePixel = 0
	b.AutoButtonColor = false
	b.Font = Enum.Font.GothamBold
	b.Text = text
	b.TextSize = 15
	b.TextColor3 = textColor
	b.Parent = main
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)

	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = hoverColor }):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = idleColor }):Play()
	end)
	return b
end

local clearBtn = makeButton("CLEAR", false, 16, COL_CLEAR, COL_CLEAR_HV, COL_TEXT)
local executeBtn = makeButton("EXECUTE", true, -16, COL_EXEC, COL_EXEC_HV, Color3.fromRGB(255, 255, 255))

----------------------------------------------------------------
-- Круглая кнопка (когда GUI спрятан)
----------------------------------------------------------------
local ICON_TEXT = "👁"
local ICON_IMAGE_ID = ""

local bubble = Instance.new("TextButton")
bubble.Name = "Bubble"
bubble.Visible = false
bubble.AnchorPoint = Vector2.new(0.5, 0.5)
bubble.Position = UDim2.new(0, 50, 0.5, 0)
bubble.Size = UDim2.fromOffset(56, 56)
bubble.BackgroundColor3 = COL_PANEL
bubble.BorderSizePixel = 0
bubble.AutoButtonColor = false
bubble.Font = Enum.Font.GothamBold
bubble.Text = ICON_TEXT
bubble.TextSize = 26
bubble.TextColor3 = COL_TEXT
bubble.ZIndex = 10
bubble.Parent = gui
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)
local bubbleStroke = Instance.new("UIStroke", bubble)
bubbleStroke.Color = COL_ACCENT
bubbleStroke.Thickness = 2

if ICON_IMAGE_ID ~= "" then
	bubble.Text = ""
	local icon = Instance.new("ImageLabel")
	icon.BackgroundTransparency = 1
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.fromScale(0.5, 0.5)
	icon.Size = UDim2.fromScale(0.65, 0.65)
	icon.Image = "rbxassetid://" .. ICON_IMAGE_ID
	icon.ZIndex = 11
	icon.Active = false
	icon.Parent = bubble
end

----------------------------------------------------------------
-- Логика
----------------------------------------------------------------
clearBtn.MouseButton1Click:Connect(function()
	box.Text = ""
end)

executeBtn.MouseButton1Click:Connect(function()
	local code = box.Text
	if code ~= "" then
		remote:FireServer(code)
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local function showMain()
	bubble.Visible = false
	main.Visible = true
end

local function hideMain()
	main.Visible = false
	bubble.Visible = true
end

hideBtn.MouseButton1Click:Connect(hideMain)

-- Открыть/спрятать GUI по клавише P
-- (физически это та же клавиша, что и "З" на русской раскладке ЙЦУКЕН)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- не срабатывает, пока печатаешь в поле кода
	if input.KeyCode == Enum.KeyCode.P then
		if main.Visible then
			hideMain()
		else
			showMain()
		end
	end
end)

-- Перетаскивание круглой кнопки (клик без движения = открыть GUI)
local dragging, moved = false, false
local startInputPos, startBubblePos

bubble.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging, moved = true, false
		startInputPos = input.Position
		startBubblePos = bubble.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				if not moved then
					showMain()
				end
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - startInputPos
		if delta.Magnitude > 6 then
			moved = true
		end
		if moved then
			bubble.Position = UDim2.new(
				startBubblePos.X.Scale, startBubblePos.X.Offset + delta.X,
				startBubblePos.Y.Scale, startBubblePos.Y.Offset + delta.Y
			)
		end
	end
end)
