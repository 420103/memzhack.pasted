local blood = getsenv(game.Players.LocalPlayer.PlayerGui.Client)blood.splatterBlood = function() end
local user = "Memz"
local camera = workspace.CurrentCamera
local clr = Color3.fromRGB
local v2 = Vector2.new
local runService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GetName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local uis = game:GetService('UserInputService')
local changelogys = "03/28/22 Logs:\n1. New elements:\n A. Spectators list,\n B. Watermark,\n C. Loader.\n2. Ragebot Improvements:\n A. Knifebot,\n B. Prediction,\n C. Kill All.\n03/29/22 Logs:\n1. Ragebot Improvements:\n A. Knifebot (Faster.)\n03/31/22 Logs:\n1. UI Element Improvements:\n A. Watermark,\n B. Spectators List,\n C. Status Indicators,\n D. Information.\n04/02/22 Logs:\n1. Ragebot expploits:\n A. God Mode.\n2. UI Element Improvements:\n A. Event Logs(Drawing.)"
local runService = game:GetService('RunService')    
local Stepped
local val = true
local utility = {}
local suffixx = ""
local suffixx2 = ""

local cheatnamel = "Memzhack.pasted"

local currentAngle = 0
local pi = math.pi

local cos = math.cos
local sin = math.sin
local floor = math.floor
local rad = math.rad
local newRay = Ray.new

local crosshair = {
    Visible = true,
    Color = clr(255, 255, 0),
    Speed = 20,
    Size = 60,
    Gap = 8,
    Thickness = 3,
    Outline = true
}

local screenCenter = camera.ViewportSize / 2; do
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        screenCenter = camera.ViewportSize / 2;
    end);
end

local theme = {
	accent = clr(7, 129, 227)
}

local LerpCIELUV
--
do -- CIELUV color space lerping
	-- Combines two colors in CIELUV space.
	-- function<function<Color3 result>(float t)>(Color3 fromColor, Color3 toColor)

	-- https://www.w3.org/Graphics/Color/srgb
	
	local clamp = math.clamp
	local C3 = Color3.new
	local black = C3(0, 0, 0)

	-- Convert from linear RGB to scaled CIELUV
	local function RgbToLuv13(c)
		local r, g, b = c.r, c.g, c.b
		-- Apply inverse gamma correction
		r = r < 0.0404482362771076 and r/12.92 or 0.87941546140213*(r + 0.055)^2.4
		g = g < 0.0404482362771076 and g/12.92 or 0.87941546140213*(g + 0.055)^2.4
		b = b < 0.0404482362771076 and b/12.92 or 0.87941546140213*(b + 0.055)^2.4
		-- sRGB->XYZ->CIELUV
		local y = 0.2125862307855956*r + 0.71517030370341085*g + 0.0722004986433362*b
		local z = 3.6590806972265883*r + 11.4426895800574232*g + 4.1149915024264843*b
		local l = y > 0.008856451679035631 and 116*y^(1/3) - 16 or 903.296296296296*y
		if z > 1e-15 then
			local x = 0.9257063972951867*r - 0.8333736323779866*g - 0.09209820666085898*b
			return l, l*x/z, l*(9*y/z - 0.46832)
		else
			return l, -0.19783*l, -0.46832*l
		end
	end

	function LerpCIELUV(c0, c1)
		local l0, u0, v0 = RgbToLuv13(c0)
		local l1, u1, v1 = RgbToLuv13(c1)

		return function(t)
			-- Interpolate
			local l = (1 - t)*l0 + t*l1
			if l < 0.0197955 then
				return black
			end
			local u = ((1 - t)*u0 + t*u1)/l + 0.19783
			local v = ((1 - t)*v0 + t*v1)/l + 0.46832

			-- CIELUV->XYZ
			local y = (l + 16)/116
			y = y > 0.206896551724137931 and y*y*y or 0.12841854934601665*y - 0.01771290335807126
			local x = y*u/v
			local z = y*((3 - 0.75*u)/v - 5)

			-- XYZ->linear sRGB
			local r =  7.2914074*x - 1.5372080*y - 0.4986286*z
			local g = -2.1800940*x + 1.8757561*y + 0.0415175*z
			local b =  0.1253477*x - 0.2040211*y + 1.0569959*z

			-- Adjust for the lowest out-of-bounds component
			if r < 0 and r < g and r < b then
				r, g, b = 0, g - r, b - r
			elseif g < 0 and g < b then
				r, g, b = r - g, 0, b - g
			elseif b < 0 then
				r, g, b = r - b, g - b, 0
			end

			return C3(
				-- Apply gamma correction and clamp the result
				clamp(r < 3.1306684425e-3 and 12.92*r or 1.055*r^(1/2.4) - 0.055, 0, 1),
				clamp(g < 3.1306684425e-3 and 12.92*g or 1.055*g^(1/2.4) - 0.055, 0, 1),
				clamp(b < 3.1306684425e-3 and 12.92*b or 1.055*b^(1/2.4) - 0.055, 0, 1)
			)
		end
	end
end
-- // Variables
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
--
-- // Functions
function TweenDrawing(Render, RenderInfo, RenderTo)
    local Start = {}
    local CurrentTime = 0
    --
    local Connection
    --
    for Index, Value in pairs(RenderTo) do
        Start[Index] = Render[Index]
        RenderTo[Index] = (typeof(Value) == "Color3" and LerpCIELUV(Start[Index], Value) or (Value - Start[Index]))
    end
    --
    Connection = RunService.RenderStepped:Connect(function(Delta)
        if CurrentTime < RenderInfo.Time then
            CurrentTime = CurrentTime + Delta
            --
            local TweenedValue = TweenService:GetValue((CurrentTime / RenderInfo.Time), RenderInfo.EasingStyle, RenderInfo.EasingDirection)
            --
            for Index, Value in pairs(RenderTo) do
                if typeof(Value) == "number" then
                    Render[Index] = (Value * TweenedValue) + Start[Index]
                elseif typeof(Value) == "Vector2" then
                    Render[Index] = Vector2.new((Value.X * TweenedValue) + Start[Index].X, (Value.Y * TweenedValue) + Start[Index].Y)
                elseif typeof(Value) == "function" then
                    Render[Index] = Value(TweenedValue)
                end
            end
        else
            Connection:Disconnect()
        end
    end)
end 

function mouseLocation()
	return uis:GetMouseLocation()
end
--
function mouseOver(Values)
	local X1, Y1, X2, Y2 = Values[1], Values[2], Values[3], Values[4]
	local ml = mouseLocation()
	return (ml.x >= X1 and ml.x <= (X1 + (X2 - X1))) and (ml.y >= Y1 and ml.y <= (Y1 + (Y2 - Y1)))
end

local drawingPool = {}
local function newDrawing(type, prop) -- just newdrawing instead of Drawing.new
    local obj = Drawing.new(type)
    if prop then
        for i,v in next, prop do
                obj[i] = v
        end
    end
    return obj  
end

for i,v in next, drawingPool do
    if not v.used then
        v.used = true
        drawing = v
        break
    end
end

loader = {}

loader.Border = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(0, 0, 0),
    Position = v2(800, 500),
    Size = v2(424, 158),
})
loader.Border2 = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(801, 501),
    Size = v2(422, 156),
})
loader.Background = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(31, 31, 41),
    Position = v2(802, 502),
    Size = v2(420, 154),
})
loader.BackgroundGradient = newDrawing("Image", {
    Position = v2(802, 502),
    Visible = true,
    Transparency = 0.5,
    Data = game:HttpGet("https://i.imgur.com/5hmlrjX.png"),
    Size = v2(420, 154),
})
loader.TopBorder = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(802, 502),
    Size = v2(420, 16),
})
loader.TopBackground = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(25, 25, 25),
    Position = v2(802, 502),
    Size = v2(420, 15),
})
loader.TopText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(806, 502),
    Text = "Memzhack.pasted REWRITE - Loader",
})
loader.UserText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(928, 519),
    Text = "Welcome, " ..LocalPlayer.Name.. ".",
})
loader.VersionText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(928, 532),
    Text = "Version - 3.0",
})
loader.UpdateText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(928, 545),
    Text = "Updated: 03/28/22",
})

loader.ChangelogsText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(928, 570),
    Text = "Changelogs   >-",
})
loader.UsersText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(928, 583),
    Text = "Users        >-",
})
loader.Changelogbutton = newDrawing("Square", {
    Visible = false,
    Filled = true,
    Color = clr(125, 125, 125),
    Position = v2(928, 570),
})
loader.Userbutton = newDrawing("Square", {
    Visible = false,
    Filled = true,
    Color = clr(25, 25, 25),
    Position = v2(928, 583),
})
loader.Icon = newDrawing("Image", {
    Position = v2(808, 522),
    Visible = true,
    Transparency = 0.8,
    Data = game:HttpGet("https://i.imgur.com/twYzGgA.png"),
    Size = v2(115, 100),
})

loader.BottomBorder = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(812, 630),
    Size = v2(400, 22),
})
loader.BottomBackground = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(25, 25, 25),
    Position = v2(813, 631),
    Size = v2(398, 20),
})
loader.LoadButtonBorder = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(815, 633),
    Size = v2(192, 16),
})
loader.LoadButtonBackground = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(25, 25, 25),
    Position = v2(816, 634),
    Size = v2(190, 14),
})
loader.LoadButtonGradient = newDrawing("Image", {
    Position = v2(816, 634),
    Visible = true,
    Transparency = 0.5,
    Data = game:HttpGet("https://i.imgur.com/5hmlrjX.png"),
    Size = v2(190, 14),
})
loader.LoadButtonText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Center = true,
    Color = clr(255, 255, 255),
    Position = v2(911, 634),
    Text = "Load",
})
loader.CloseButtonBorder = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(1017, 633),
    Size = v2(192, 16),
})
loader.CloseButtonBackground = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(25, 25, 25),
    Position = v2(1018, 634),
    Size = v2(190, 14),
})
loader.CloseButtonGradient = newDrawing("Image", {
    Position = v2(1018, 634),
    Visible = true,
    Transparency = 0.5,
    Data = game:HttpGet("https://i.imgur.com/5hmlrjX.png"),
    Size = v2(190, 14),
})
loader.CloseButtonText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Center = true,
    Color = clr(255, 255, 255),
    Position = v2(1113, 634),
    Text = "Close",
})

changelog = {}

changelog.Border = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(0, 0, 0),
    Position = v2(1230, 500),
    Size = v2(284, 129),
})
changelog.Border2 = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(1231, 501),
    Size = v2(282, 127),
})
changelog.Background = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(31, 31, 41),
    Position = v2(1232, 502),
    Size = v2(280, 125),
})
changelog.BackgroundGradient = newDrawing("Image", {
    Position = v2(1232, 502),
    Visible = true,
    Transparency = 0.5,
    Data = game:HttpGet("https://i.imgur.com/5hmlrjX.png"),
    Size = v2(280, 125),
})
changelog.TopBorder = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(1232, 502),
    Size = v2(280, 16),
})
changelog.TopBackground = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(25, 25, 25),
    Position = v2(1232, 502),
    Size = v2(280, 15),
})
changelog.TopText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(1236, 502),
    Text = "Changelogs",
})
changelog.Text = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(1236, 520),
    Text = changelogys,
})

Users = {}

Users.Border = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(0, 0, 0),
    Position = v2(500, 500),
    Size = v2(284, 129),
})
Users.Border2 = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(501, 501),
    Size = v2(282, 127),
})
Users.Background = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(31, 31, 41),
    Position = v2(502, 502),
    Size = v2(280, 125),
})
Users.BackgroundGradient = newDrawing("Image", {
    Position = v2(502, 502),
    Visible = true,
    Transparency = 0.5,
    Data = game:HttpGet("https://i.imgur.com/5hmlrjX.png"),
    Size = v2(280, 125),
})
Users.TopBorder = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(15, 15, 15),
    Position = v2(502, 502),
    Size = v2(280, 16),
})
Users.TopBackground = newDrawing("Square", {
    Visible = true,
    Filled = true,
    Color = clr(25, 25, 25),
    Position = v2(502, 502),
    Size = v2(280, 15),
})
Users.TopText = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(506, 502),
    Text = "Users",
})
Users.Text = newDrawing("Text", {
    Visible = true,
    Size = 13,
    Font = 2,
    Outline = true,
    Color = clr(255, 255, 255),
    Position = v2(506, 520),
    Text = "Memz - Developer, Founder.\nRyan - User.",
})


cursor = {}

cursor.Icon = newDrawing("Image", {
    Visible = true,
    Transparency = 1,
    Data = game:HttpGet("https://tr.rbxcdn.com/64bab312014a57cc37289f70cff37383/420/420/Decal/Png"),
    Size = v2(18, 24),
})

for i,v in next, changelog do 
    v.Visible = false
end
for i,v in next, Users do 
    v.Visible = false
end

function utility:MouseLocation()
    return uis:GetMouseLocation()
end

function utility:MouseOverDrawing(values, valuesAdd)
    local valuesAdd = valuesAdd or {}
    local values = {
        (values[1] or 0) + (valuesAdd[1] or 0),
        (values[2] or 0) + (valuesAdd[2] or 0),
        (values[3] or 0) + (valuesAdd[3] or 0),
        (values[4] or 0) + (valuesAdd[4] or 0)
    }
    --
    local mouseLocation = utility:MouseLocation()
    return (mouseLocation.x >= values[1] and mouseLocation.x <= (values[1] + (values[3] - values[1]))) and (mouseLocation.y >= values[2] and mouseLocation.y <= (values[2] + (values[4] - values[2])))
end
local connection
connection = uis.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if utility:MouseOverDrawing({loader.LoadButtonBackground.Position.X, loader.LoadButtonBackground.Position.Y, loader.LoadButtonBackground.Position.X + loader.LoadButtonBackground.Size.X, loader.LoadButtonBackground.Position.Y + 14}) then
			getgenv().values = {} 
			local library = {tabs = {}}
			local Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Signal.lua"))() 
			local ConfigSave = Signal.new("ConfigSave") 
			local ConfigLoad = Signal.new("ConfigLoad") 

			local txt = game:GetService("TextService") 
			local TweenService = game:GetService("TweenService") 
			function library:Tween(...) TweenService:Create(...):Play() end 
			local cfglocation = "Stormycfg/" 
			makefolder("Stormycfg") 

			local Vec2 = Vector2.new 
			local Vec3 = Vector3.new 
			local CF = CFrame.new 
			local INST = Instance.new 
			local COL3 = Color3.new 
			local COL3RGB = Color3.fromRGB 
			local COL3HSV = Color3.fromHSV 
			local CLAMP = math.clamp 
			local DEG = math.deg 
			local FLOOR = math.floor 
			local ACOS = math.acos 
			local RANDOM = math.random 
			local ATAN2 = math.atan2 
			local HUGE = math.huge 
			local RAD = math.rad 
			local MIN = math.min 
			local POW = math.pow 
			local UDIM2 = UDim2.new 
			local CFAngles = CFrame.Angles 

			local FIND = string.find 
			local LEN = string.len 
			local SUB = string.sub 
			local GSUB = string.gsub 
			local RAY = Ray.new 

			local INSERT = table.insert 
			local TBLFIND = table.find 
			local TBLREMOVE = table.remove 
			local TBLSORT = table.sort 

			eventLogs = {}

			function createEventLog(text, time)
				local eventLog = {
					text = text,
					startTick = tick(),
					lifeTime = time,
					Border = newDrawing("Square", {
						Visible = true,
						Filled = true,
						Color = clr(5, 5, 5),
						Position = v2(0, 0),
					}),
					Border2 = newDrawing("Square", {
						Visible = true,
						Filled = true,
						Color = clr(60, 60, 60),
						Position = v2(0, 0),
					}),
					Background = newDrawing("Square", {
						Visible = true,
						Filled = true,
						Color = clr(18, 18, 18),
						Position = v2(0, 0),
					}),
					HitlogText = newDrawing("Text", {
						Visible = true,
						Outline = true,
						Font = 2,
						Size = 13,
						Text = " "..text,
						Color = clr(255, 255, 255),
						Position = v2(0, 0),
					}),
					Gradient = newDrawing("Square", {
						Visible = true,
						Filled = true,
						Color = theme.accent,
						Position = v2(0, 0),
					}),
				}
			
				function eventLog:Destroy()
					TweenDrawing(self.HitlogText, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = v2(self.HitlogText.Position.X, self.HitlogText.Position.Y) - v2(300, 0), Transparency = 0})
					TweenDrawing(self.Gradient, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = v2(self.Gradient.Position.X, self.Gradient.Position.Y) - v2(300, 0), Transparency = 0})
					TweenDrawing(self.Background, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = v2(self.Background.Position.X, self.Background.Position.Y) - v2(300, 0), Transparency = 0})
					TweenDrawing(self.Border2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = v2(self.Border2.Position.X, self.Border2.Position.Y) - v2(300, 0), Transparency = 0})
					TweenDrawing(self.Border, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = v2(self.Border.Position.X, self.Border.Position.Y) - v2(300, 0), Transparency = 0})       
					wait(0.400000001)
					self.HitlogText:Remove()
					self.Gradient:Remove()
					self.Background:Remove()
					self.Border2:Remove()
					self.Border:Remove()
					self.Border = nil
					self.Border2 = nil
					self.HitlogText = nil
					self.Gradient = nil
					self.Background = nil
					table.clear(self)
					self = nil
				end
			
				table.insert(eventLogs, eventLog)
				return eventLog
			end
			
			runService.RenderStepped:Connect(function(deltaTime)
				local count = #eventLogs
				local removedFirst = false
				for i = 1, count do
					local curTick = tick()
					local eventLog = eventLogs[i]
					if eventLog then
						if curTick - eventLog.startTick > eventLog.lifeTime then
							task.spawn(eventLog.Destroy, eventLog)
							table.remove(eventLogs, i)
						elseif count > 10 and not removedFirst then
							removedFirst = true
							local first = table.remove(eventLogs, 1)
							task.spawn(first.Destroy, first)
						else
							local previousEventLog = eventLogs[i - 1]
							local basePosition
							if previousEventLog then
								basePosition = Vector2.new(50, previousEventLog.HitlogText.Position.y + previousEventLog.HitlogText.TextBounds.y + 12)
							else
								basePosition = Vector2.new(50, 74)
							end
							--[[TweenDrawing(eventLog.HitlogText, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
							TweenDrawing(eventLog.Gradient, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
							TweenDrawing(eventLog.Border, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
							TweenDrawing(eventLog.Border2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
							TweenDrawing(eventLog.Background, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})]]--
							eventLog.Gradient.Color = theme.accent
							eventLog.HitlogText.Position = basePosition + v2(2, 0)
							eventLog.Gradient.Position = basePosition - v2(0, 2) + v2(2, 0)
							eventLog.Gradient.Size = v2(2, eventLog.HitlogText.TextBounds.Y) + v2(0, 6)
							eventLog.Background.Position = basePosition - v2(0, 0) + v2(4, 0)
							eventLog.Background.Size = v2(eventLog.HitlogText.TextBounds.X, eventLog.HitlogText.TextBounds.Y) + v2(2, 2)
							eventLog.Border2.Position = basePosition - v2(0, 1) + v2(3, 0)
							eventLog.Border2.Size = v2(eventLog.HitlogText.TextBounds.X, eventLog.HitlogText.TextBounds.Y) + v2(4, 4)
							eventLog.Border.Position = basePosition - v2(0, 2) + v2(2, 0)
							eventLog.Border.Size = v2(eventLog.HitlogText.TextBounds.X, eventLog.HitlogText.TextBounds.Y) + v2(6, 6)
							eventLog.HitlogText.Visible = true
							eventLog.Gradient.Visible = true
							eventLog.Background.Visible = true
							eventLog.Border2.Visible = true
							eventLog.Border.Visible = true
						end
					end
				end
			end)
			
			getgenv().createEventLog = createEventLog

			function rgbtotbl(rgb) 
				return {R = rgb.R, G = rgb.G, B = rgb.B} 
			end 
			function tbltorgb(tbl) 
				return COL3(tbl.R, tbl.G, tbl.B) 
			end 
			local function deepCopy(original) 
				local copy = {} 
				for k, v in pairs(original) do 
					if type(v) == "table" then 
						v = deepCopy(v) 
					end 
					copy[k] = v 
				end 
				return copy 
			end 
			function library:ConfigFix(cfg) 
				local copy = game:GetService("HttpService"):JSONDecode(readfile(cfglocation..cfg..".txt")) 
				for i,Tabs in pairs(copy) do 
					for i,Sectors in pairs(Tabs) do 
						for i,Elements in pairs(Sectors) do 
							if Elements.Color ~= nil then 
								local a = Elements.Color 
								Elements.Color = tbltorgb(a) 
							end 
						end 
					end 
				end 
				return copy 
			end 
				function library:SaveConfig(cfg) 
					local copy = deepCopy(values) 
					for i,Tabs in pairs(copy) do 
						for i,Sectors in pairs(Tabs) do 
							for i,Elements in pairs(Sectors) do 
								if Elements.Color ~= nil then 
									Elements.Color = {R=Elements.Color.R, G=Elements.Color.G, B=Elements.Color.B} 
								end 
							end 
						end 
					end 
					writefile(cfglocation..cfg..".txt", game:GetService("HttpService"):JSONEncode(copy)) 
					createEventLog("Saved ("..cfg..".txt) !", 3)
				end 

			function library:New(name)
						
				local menu = {} 
				local floppa = INST("ScreenGui") 
				local Menu = Instance.new("Frame")
				local top = Instance.new("Frame")
				local cheatname = Instance.new("TextLabel")
				local gradient = Instance.new("Frame")
				local Tabs = INST("Frame") 
				local UIListLayout55 = Instance.new("UIListLayout")			

				floppa.Name = "electric boogalo" 
				floppa.ResetOnSpawn = false 
				floppa.ZIndexBehavior = "Global" 
				floppa.DisplayOrder = 420133769 

				local UIScale = INST("UIScale") 
				UIScale.Parent = floppa 

				function menu:SetScale(scale) 
					UIScale.Scale = scale 
				end 

				local but = INST("TextButton") 
				but.Modal = true 
				but.Text = "" 
				but.BackgroundTransparency = 1 
				but.Parent = floppa 

				local Players = game:GetService("Players") 
				local LocalPlayer = Players.LocalPlayer 
				local Mouse = LocalPlayer:GetMouse() 

				Menu.Name = "Menu"
				Menu.Parent = floppa
				Menu.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
				Menu.BorderSizePixel = 0
				Menu.Position = UDim2.new(0.247666463, 0, 0.310421288, 0)
				Menu.Size = UDim2.new(0, 670, 0, 400)
				
				top.Name = "top"
				top.Parent = Menu
				top.BackgroundColor3 = Color3.fromRGB(41, 41, 52)
				top.BorderSizePixel = 0
				top.Size = UDim2.new(0, 670, 0, 20)
				
				cheatname.Name = "cheatname"
				cheatname.Parent = top
				cheatname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				cheatname.BackgroundTransparency = 1.000
				cheatname.Size = UDim2.new(0, 670, 0, 18)
				cheatname.Font = Enum.Font.Ubuntu
				cheatname.Text = "  "..cheatnamel
				cheatname.TextColor3 = Color3.fromRGB(255, 255, 255)
				cheatname.TextSize = 12.000
				cheatname.TextXAlignment = Enum.TextXAlignment.Left
				
				gradient.Name = "gradient"
				gradient.Parent = top
				game:GetService('RunService').RenderStepped:Connect(function()
					gradient.BackgroundColor3 = theme.accent
				end)
				gradient.BorderSizePixel = 0
				gradient.Position = UDim2.new(0, 0, 1, 0)
				gradient.Size = UDim2.new(0, 670, 0, 4)

				library.uiopen = true 

				game:GetService("UserInputService").InputBegan:Connect(function(key) 
					if key.KeyCode == Enum.KeyCode.Insert then 
						floppa.Enabled = not floppa.Enabled 
						library.uiopen = floppa.Enabled 
					end 
				end) 
				
					local KeybindList = Instance.new("ScreenGui")
					do
						local BKR = Instance.new("TextLabel")
						local UIGradient = Instance.new("UIGradient")
						local Grad = Instance.new("Frame")
						local ABC = Instance.new("Frame")
						local TextLabel = Instance.new("TextLabel")
						local UIListLayout = Instance.new("UIListLayout")
						local Frame = Instance.new("Frame")
						local UIListLayout_2 = Instance.new("UIListLayout")
						local SpecList = Instance.new("Frame")
						local PlayerNames = Instance.new("TextLabel")
						local UIListLayout3 = Instance.new("UIListLayout")
						local TextLabel_2 = Instance.new("TextLabel")

						KeybindList.Name = "KeybindList"
						KeybindList.ZIndexBehavior = Enum.ZIndexBehavior.Global 
						KeybindList.Enabled = false

						BKR.Name = "BKR"
						BKR.Parent = KeybindList
						BKR.AutomaticSize = Enum.AutomaticSize.X
						BKR.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						BKR.BorderColor3 = Color3.fromRGB(14, 29, 32)
						BKR.Position = UDim2.new(0.0883182585, 0, 0.437578738, 0)
						BKR.Size = UDim2.new(0, 0, 0, 20)
						BKR.Font = Enum.Font.Ubuntu
						BKR.Text = ""
						BKR.BorderSizePixel = 0
						BKR.TextColor3 = Color3.fromRGB(255, 255, 255)
						BKR.TextSize = 10.000
						BKR.TextStrokeTransparency = 1
						BKR.TextXAlignment = Enum.TextXAlignment.Left

						UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(46, 43, 44)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 24, 24))}
						UIGradient.Rotation = 90
						UIGradient.Parent = BKR

						Grad.Name = "Grad"
						Grad.Parent = BKR
						Grad.AutomaticSize = Enum.AutomaticSize.X
						game:GetService('RunService').RenderStepped:Connect(function()
							Grad.BackgroundColor3 = theme.accent
						end)
						Grad.BorderSizePixel = 0
						Grad.Size = UDim2.new(0, 0, 0, 1)

						TextLabel.Parent = Grad
						TextLabel.AutomaticSize = Enum.AutomaticSize.X
						TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel.BackgroundTransparency = 1.000
						TextLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
						TextLabel.Position = UDim2.new(0, 0, 1, 0)
						TextLabel.Size = UDim2.new(0, 0, 0, 19)
						TextLabel.Font = Enum.Font.Ubuntu
						TextLabel.Text = "   Status List   "
						TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel.TextSize = 10.000
						TextLabel.TextStrokeTransparency = 1
						TextLabel.TextXAlignment = Enum.TextXAlignment.Left
						
						UIListLayout.Parent = Grad  
						UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
						UIListLayout.Padding = UDim.new(0, 0)

						Frame.Parent = Grad
						Frame.AutomaticSize = Enum.AutomaticSize.XY
						Frame.BackgroundColor3 = Color3.fromRGB(25, 24, 24)
						Frame.BorderSizePixel = 0
						Frame.BackgroundTransparency = 0.000
						Frame.BorderColor3 = Color3.fromRGB(25, 24, 24)
						Frame.AutomaticSize = Enum.AutomaticSize.XY
						Frame.Position = UDim2.new(0, 0, 0, 0)
						Frame.Size = UDim2.new(0, 0, 0, 0)

						ABC.Name = "ABC"
						ABC.Parent = Frame
						ABC.AutomaticSize = Enum.AutomaticSize.XY
						ABC.BackgroundTransparency = 1.000
						ABC.BackgroundColor3 = Color3.fromRGB(25, 24, 24)
						ABC.BorderColor3 = Color3.fromRGB(25, 24, 24)
						ABC.Position = UDim2.new(0, 0, -0.0909090936, 2)
						ABC.Size = UDim2.new(0, 0, 0, 0)

						local AFAKELAG = Instance.new("TextLabel")
						AFAKELAG.Name = "AFAKELAG"				
						AFAKELAG.Parent = ABC
						AFAKELAG.BackgroundColor3 = Color3.fromRGB(25, 24, 24)
						AFAKELAG.ZIndex = 2
						AFAKELAG.BackgroundTransparency = 0.000
						AFAKELAG.BorderSizePixel = 0
						AFAKELAG.BorderColor3 = Color3.fromRGB(27, 42, 53)
						AFAKELAG.Position = UDim2.new(0, 0, 0, 0)
						AFAKELAG.Text = "   Fakelag: off   "
						AFAKELAG.Size = UDim2.new(0, 0, 0, 19)
						AFAKELAG.Font = Enum.Font.Ubuntu
						AFAKELAG.TextColor3 = Color3.fromRGB(255, 255, 255)
						AFAKELAG.TextSize = 10.000
						AFAKELAG.TextStrokeTransparency = 1
						AFAKELAG.TextXAlignment = Enum.TextXAlignment.Left
						AFAKELAG.AutomaticSize = Enum.AutomaticSize.X
						
						UIListLayout3.Parent = ABC
						UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder

						UIListLayout_2.Parent = Frame

						KeybindList.Parent = game.CoreGui

						local function WKZPSUV_fake_script() -- BKR.LocalScript 
							local script = Instance.new('LocalScript', BKR)

							local status = script.Parent
							status.Draggable = true
							status.Active = true
						end
						coroutine.wrap(WKZPSUV_fake_script)()
					end

					function keybindadd(text)
						if not KeybindList.BKR.Grad.Frame.ABC:FindFirstChild(text) then
							local ABC = Instance.new("TextLabel")
							ABC.Name = text				
							ABC.Parent = KeybindList.BKR.Grad.Frame.ABC
							ABC.BackgroundColor3 = Color3.fromRGB(25, 24, 24)
							ABC.ZIndex = 2
							ABC.BackgroundTransparency = 0.000
							ABC.BorderSizePixel = 0
							ABC.BorderColor3 = Color3.fromRGB(27, 42, 53)
							ABC.Position = UDim2.new(0, 0, 0, 0)
							ABC.Text = "   " ..text.. ":  Enabled   "
							ABC.Size = UDim2.new(0, 0, 0, 19)
							ABC.Font = Enum.Font.Ubuntu
							ABC.TextColor3 = Color3.fromRGB(255, 255, 255)
							ABC.TextSize = 10.000
							ABC.TextStrokeTransparency = 1
							ABC.TextXAlignment = Enum.TextXAlignment.Left
							ABC.AutomaticSize = Enum.AutomaticSize.X
						end
					end

					function keybindhold(text)
						if not KeybindList.BKR.Grad.Frame.ABC:FindFirstChild(text) then
							local ABC = Instance.new("TextLabel")	
							ABC.Parent = KeybindList.BKR.Grad.Frame.ABC
							ABC.Name = text
							ABC.BackgroundColor3 = Color3.fromRGB(25, 24, 24)
							ABC.ZIndex = 2
							ABC.BorderSizePixel = 0
							ABC.BackgroundTransparency = 0.000
							ABC.BorderColor3 = Color3.fromRGB(27, 42, 53)
							ABC.Position = UDim2.new(0, 0, 0, 0)
							ABC.Text = "   " ..text.. ":  Held   "
							ABC.Size = UDim2.new(0, 0, 0, 19)
							ABC.Font = Enum.Font.Ubuntu
							ABC.TextColor3 = Color3.fromRGB(255, 255, 255)
							ABC.TextSize = 10.000
							ABC.TextStrokeTransparency = 1
							ABC.TextXAlignment = Enum.TextXAlignment.Left
							ABC.AutomaticSize = Enum.AutomaticSize.X
						end
					end



					function keybindremove(text)
						if KeybindList.BKR.Grad.Frame.ABC:FindFirstChild(text) then
							KeybindList.BKR.Grad.Frame.ABC:FindFirstChild(text):Destroy()
						end
					end

					function library:SetKeybindVisible(Joe)
						KeybindList.Enabled = Joe
					end

				library.dragging = false 
				do 
					local UserInputService = game:GetService("UserInputService") 
					local a = Menu 
					local dragInput 
					local dragStart 
					local startPos 
					local function update(input) 
						local delta = input.Position - dragStart 
						a.Position = UDIM2(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
					end 
					a.InputBegan:Connect(function(input) 
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
							library.dragging = true 
							dragStart = input.Position 
							startPos = a.Position 

							input.Changed:Connect(function() 
								if input.UserInputState == Enum.UserInputState.End then 
									library.dragging = false 
								end 
							end) 
						end 
					end) 
					a.InputChanged:Connect(function(input) 
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
							dragInput = input 
						end 
					end) 
					UserInputService.InputChanged:Connect(function(input) 
						if input == dragInput and library.dragging then 
							update(input) 
						end 
					end) 
				end 


				local holder = Instance.new("Frame")
				holder.Name = "holder"
				holder.Parent = Menu
				holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				holder.BackgroundTransparency = 1.000
				holder.BorderSizePixel = 0
				holder.Position = UDim2.new(0, 0, 0.0599999987, 0)
				holder.Size = UDim2.new(0, 167, 0, 376)

				Tabs.Name = "Tabs"
				Tabs.Parent = Menu
				Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Tabs.BackgroundTransparency = 1.000
				Tabs.BorderSizePixel = 0
				Tabs.Position = UDim2.new(0.239000008, 0, 0.0719999671, 0)
				Tabs.Size = UDim2.new(0, 505, 0, 366)	 
				
				local tabbuttons = Instance.new("Frame")
				tabbuttons.Name = "tabbuttons"
				tabbuttons.Parent = holder
				tabbuttons.BackgroundColor3 = Color3.fromRGB(31, 31, 41)
				tabbuttons.BorderColor3 = Color3.fromRGB(27, 42, 53)
				tabbuttons.BorderSizePixel = 0
				tabbuttons.Position = UDim2.new(0, 5, 0, 5)
				tabbuttons.Size = UDim2.new(0, 150, 0, 366)

				UIListLayout55.Parent = tabbuttons
				UIListLayout55.SortOrder = Enum.SortOrder.LayoutOrder


				local first = true 
				local currenttab 

				function menu:Tab(text) 
					local tabname 
					tabname = text 
					local Tab = {} 
					values[tabname] = {} 

					local gradient_2 = Instance.new("Frame")
					gradient_2.Name = "gradient"
					gradient_2.Parent = tabbuttons
					gradient_2.BackgroundColor3 = theme.accent
					gradient_2.BorderSizePixel = 0
					gradient_2.Size = UDim2.new(0, 4, 0, 25)


					local TextButton = Instance.new("TextButton") 
					TextButton.Parent = gradient_2
					TextButton.BackgroundColor3 = Color3.fromRGB(31, 31, 41)
					TextButton.BorderSizePixel = 0
					TextButton.AutoButtonColor = false
					TextButton.Position = UDim2.new(0, 4, 0, 0)
					TextButton.Size = UDim2.new(0, 146, 0, 25)
					TextButton.Font = Enum.Font.Ubuntu
					TextButton.Text = "  "..text
					TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextButton.TextSize = 12.000
					TextButton.TextXAlignment = Enum.TextXAlignment.Left

					local TabGui = INST("ScrollingFrame") 
					local Left = INST("Frame") 
					local UIListLayout = INST("UIListLayout") 
					local Right = INST("Frame") 
					local UIListLayout_2 = INST("UIListLayout") 

					TabGui.Name = "TabGui" 
					TabGui.Parent = Tabs 
					TabGui.BackgroundColor3 = COL3RGB(255, 255, 255) 
					TabGui.BackgroundTransparency = 1.000 
					TabGui.Size = UDIM2(0, 505, 0, 366) 
					TabGui.Position = UDIM2(0, 0, 0, 0)
					TabGui.AutomaticCanvasSize = Enum.AutomaticSize.Y
					TabGui.Visible = false 
					TabGui.ScrollBarThickness = 0

					Left.Name = "Left" 
					Left.Parent = TabGui 
					Left.BackgroundColor3 = COL3RGB(255, 255, 255) 
					Left.BackgroundTransparency = 1.000 
					Left.Position = UDIM2(0, 0, 0, 0) 
					Left.Size = UDIM2(0, 250, 0, 543) 

					UIListLayout.Parent = Left 
					UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
					UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 
					UIListLayout.Padding = UDim.new(0, 30) 

					Right.Name = "Right" 
					Right.Parent = TabGui 
					Right.BackgroundColor3 = COL3RGB(255, 255, 255) 
					Right.BackgroundTransparency = 1.000 
					Right.Position = UDIM2(0, 253, 0, 0) 
					Right.Size = UDIM2(0, 250, 0, 543) 

					UIListLayout_2.Parent = Right 
					UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center 
					UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder 
					UIListLayout_2.Padding = UDim.new(0, 30) 

					if first then 
						TextButton.TextColor3 = COL3RGB(255, 255, 255) 
						currenttab = text 
						TabGui.Visible = true 
						first = false 
					end 

					TextButton.MouseButton1Down:Connect(function() 
						if currenttab ~= text then 
							for i,v in pairs(tabbuttons:GetChildren()) do 
								if v:IsA("Frame") then 
									library:Tween(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
									library:Tween(v.TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
									library:Tween(v.TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(180, 180, 180)}) 
								end 
							end 
							for i,v in pairs(Tabs:GetChildren()) do 
								v.Visible = false 
							end 
							library:Tween(gradient_2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
							library:Tween(gradient_2.TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(37, 37, 51), TextColor3 = COL3RGB(255, 255, 255)}) 
							library:Tween(gradient_2.TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
							currenttab = text 
							TabGui.Visible = true 
						end 
					end) 

					function Tab:MSector(text, side) 
						local sectorname = text 
						local MSector = {} 
						values[tabname][text] = {} 


						local Section = INST("Frame") 
						local SectionText = INST("TextLabel") 
						local Inner = INST("Frame") 
						local sectiontabs = INST("Frame") 
						local UIListLayout_2 = INST("UIListLayout") 

						Section.Name = "Section" 
						Section.Parent = TabGui[side] 
						Section.BackgroundColor3 = COL3RGB(31, 31, 41) 
						Section.BorderColor3 = COL3RGB(57, 57, 68) 
						Section.BorderSizePixel = 0 
						Section.Size = UDIM2(1, 0, 0, 33) 

						local holder2 = Instance.new("Frame")
						local texty = Instance.new("TextLabel")
						local thing = Instance.new("Frame")

						holder2.Name = "holder2"
						holder2.Parent = Section
						holder2.BackgroundColor3 = Color3.fromRGB(41, 41, 52)
						holder2.BorderSizePixel = 0
						holder2.Position = UDim2.new(0, 0, 0, 0)
						holder2.Size = UDim2.new(0, 250, 0, 20)

						texty.Name = "texty"
						texty.Parent = holder2
						texty.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						texty.BackgroundTransparency = 1.000
						texty.Size = UDim2.new(0, 250, 0, 18)
						texty.Font = Enum.Font.Ubuntu
						texty.Text = "  "..text
						texty.TextColor3 = Color3.fromRGB(255, 255, 255)
						texty.TextSize = 12.000
						texty.TextXAlignment = Enum.TextXAlignment.Left

						thing.Name = "thing"
						thing.Parent = holder2
						game:GetService('RunService').RenderStepped:Connect(function()
							thing.BackgroundColor3 = theme.accent
						end)
						thing.BorderSizePixel = 0
						thing.Position = UDim2.new(0, 0, 1, 0)
						thing.Size = UDim2.new(0, 250, 0, 4)

						Inner.Name = "Inner" 
						Inner.Parent = Section 
						Inner.BackgroundColor3 = COL3RGB(31, 31, 41) 
						Inner.BorderColor3 = COL3RGB(255, 255, 255) 
						Inner.BorderSizePixel = 0 
						Inner.Position = UDIM2(0, 1, 0, 24) 
						Inner.Size = UDIM2(1, -2, 1, -2) 

						sectiontabs.Name = "sectiontabs" 
						sectiontabs.Parent = Section 
						sectiontabs.BackgroundColor3 = COL3RGB(255, 255, 255) 
						sectiontabs.BackgroundTransparency = 1.000 
						sectiontabs.Position = UDIM2(0, 0, 0, 25) 
						sectiontabs.Size = UDIM2(1, 0, 0, 22) 

						UIListLayout_2.Parent = sectiontabs 
						UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal 
						UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center 
						UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder 
						UIListLayout_2.Padding = UDim.new(0, 4) 

						local firs = true 
						local selected 
						function MSector:Tab(text) 
							local tab = {} 
							values[tabname][sectorname][text] = {} 
							local tabtext = text 

							local tabsize = UDIM2(1, 0, 0, 44) 

							local tab1 = INST("Frame") 
							local UIPadding = INST("UIPadding") 
							local UIListLayout = INST("UIListLayout") 
							local TextButton = INST("TextButton") 

							tab1.Name = text 
							tab1.Parent = Inner 
							tab1.BackgroundColor3 = COL3RGB(31, 31, 41) 
							tab1.BorderColor3 = COL3RGB(57, 57, 68) 
							tab1.BorderSizePixel = 0 
							tab1.Position = UDIM2(0, 0, 0, 20) 
							tab1.Size = UDIM2(1, 0, 1, -21) 
							tab1.Name = text 
							tab1.Visible = false 

							UIPadding.Parent = tab1 
							UIPadding.PaddingTop = UDim.new(0, 0) 

							UIListLayout.Parent = tab1 
							UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
							UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 
							UIListLayout.Padding = UDim.new(0, 1) 

							TextButton.Parent = sectiontabs 
							TextButton.BackgroundColor3 = COL3RGB(255, 255, 255) 
							TextButton.BackgroundTransparency = 1.000 
							TextButton.Size = UDIM2(0, txt:GetTextSize(text, 14, Enum.Font.Gotham, Vec2(700,700)).X + 2, 1, 0) 
							TextButton.Font = Enum.Font.Gotham 
							TextButton.Text = text 
							TextButton.TextColor3 = COL3RGB(255, 255, 255) 
							TextButton.TextSize = 11.000
							TextButton.Name = text 

							TextButton.MouseButton1Down:Connect(function() 
								for i,v in pairs(Inner:GetChildren()) do 
									v.Visible = false 
								end 
								for i,v in pairs(sectiontabs:GetChildren()) do 
									if v:IsA("TextButton") then 
										library:Tween(v, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
									end 
								end 
								Section.Size = tabsize 
								tab1.Visible = true 
								library:Tween(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
							end) 

							function tab:Element(type, text, data, callback) 
								local Element = {} 
								data = data or {} 
								callback = callback or function() end 
								values[tabname][sectorname][tabtext][text] = {} 

								if type == "Jumbobox" then 
									tabsize = tabsize + UDIM2(0,0,0, 39) 
									Element.value = {Jumbobox = {}} 
									data.options = data.options or {} 

									local Dropdown = INST("Frame") 
									local Button = INST("TextButton") 
									local TextLabel = INST("TextLabel") 
									local Drop = INST("ScrollingFrame") 
									local Button_2 = INST("TextButton") 
									local TextLabel_2 = INST("TextLabel") 
									local UIListLayout = INST("UIListLayout") 
									local ImageLabel = INST("ImageLabel") 
									local TextLabel_3 = INST("TextLabel") 

									Dropdown.Name = "Dropdown" 
									Dropdown.Parent = tab1 
									Dropdown.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Dropdown.BackgroundTransparency = 1.000 
									Dropdown.Position = UDIM2(0, 0, 0.255102038, 0) 
									Dropdown.Size = UDIM2(1, 0, 0, 39) 

									Button.Name = "Button" 
									Button.Parent = Dropdown 
									Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Button.BorderColor3 = COL3RGB(57, 57, 68) 
									Button.Position = UDIM2(0, 15, 0, 16) 
									Button.Size = UDIM2(0, 175, 0, 17) 
									Button.AutoButtonColor = false 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									TextLabel.Parent = Button 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
									TextLabel.Position = UDIM2(0, 5, 0, 0) 
									TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = "..." 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

									local abcd = TextLabel 

									Drop.Name = "Drop" 
									Drop.Parent = Button 
									Drop.Active = true 
									Drop.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Drop.BorderColor3 = COL3RGB(57, 57, 68) 
									Drop.Position = UDIM2(0, 0, 1, 1) 
									Drop.Size = UDIM2(1, 0, 0, 20) 
									Drop.Visible = false 
									Drop.BottomImage = "http://www.roblox.com/asset/?id=6724808282" 
									Drop.CanvasSize = UDIM2(1, 1, 1, 1) 
									Drop.ScrollBarThickness = 4 
									Drop.TopImage = "http://www.roblox.com/asset/?id=6724808282" 
									Drop.MidImage = "http://www.roblox.com/asset/?id=6724808282" 
									Drop.AutomaticCanvasSize = "Y" 
									Drop.ZIndex = 5 
									Drop.ScrollBarImageColor3 = COL3RGB(172, 208, 255) 

									UIListLayout.Parent = Drop 
									UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
									UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 

									values[tabname][sectorname][tabtext][text] = Element.value 
									local num = #data.options 
									if num > 5 then 
										Drop.Size = UDIM2(1, 0, 0, 85) 
									else 
										Drop.Size = UDIM2(1, 0, 0, 17*num) 
									end 
									local first = true 

									local function updatetext() 
										local old = {} 
										for i,v in ipairs(data.options) do 
											if TBLFIND(Element.value.Jumbobox, v) then 
												INSERT(old, v) 
											else 
											end 
										end 
										local str = "" 


										if #old == 0 then 
											str = "..." 
										else 
											if #old == 1 then 
												str = old[1] 
											else 
												for i,v in ipairs(old) do 
													if i == 1 then 
														str = v 
													else 
														if i > 2 then 
															if i < 4 then 
																str = str..",  ..." 
															end 
														else 
															str = str..",  "..v 
														end 
													end 
												end 
											end 
										end 

										abcd.Text = str 
									end 
									for i,v in ipairs(data.options) do 
										do 
											local Button = INST("TextButton") 
											local TextLabel = INST("TextLabel") 

											Button.Name = v 
											Button.Parent = Drop 
											Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
											Button.BorderColor3 = COL3RGB(57, 57, 68) 
											Button.Position = UDIM2(0, 15, 0, 16) 
											Button.Size = UDIM2(0, 175, 0, 17) 
											Button.AutoButtonColor = false 
											Button.Font = Enum.Font.SourceSans 
											Button.Text = "" 
											Button.TextColor3 = COL3RGB(0, 0, 0) 
											Button.TextSize = 11.000
											Button.BorderSizePixel = 0 
											Button.ZIndex = 6 

											TextLabel.Parent = Button 
											TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
											TextLabel.BackgroundTransparency = 1.000 
											TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
											TextLabel.Position = UDIM2(0, 5, 0, -1) 
											TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
											TextLabel.Font = Enum.Font.Gotham 
											TextLabel.Text = v 
											TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
											TextLabel.TextSize = 11.000
											TextLabel.TextXAlignment = Enum.TextXAlignment.Left 
											TextLabel.ZIndex = 6 

											Button.MouseButton1Down:Connect(function() 
												if TBLFIND(Element.value.Jumbobox, v) then 
													for i,a in pairs(Element.value.Jumbobox) do 
														if a == v then 
															TBLREMOVE(Element.value.Jumbobox, i) 
														end 
													end 
													library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
												else 
													INSERT(Element.value.Jumbobox, v) 
													library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(172, 208, 255)}) 
												end 
												updatetext() 

												values[tabname][sectorname][tabtext][text] = Element.value 
												callback(Element.value) 
											end) 
											Button.MouseEnter:Connect(function() 
												if not TBLFIND(Element.value.Jumbobox, v) then 
													library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
												end 
											end) 
											Button.MouseLeave:Connect(function() 
												if not TBLFIND(Element.value.Jumbobox, v) then 
													library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
												end 
											end) 

											first = false 
										end 
									end 
									function Element:SetValue(val) 
										Element.value = val 
										for i,v in pairs(Drop:GetChildren()) do 
											if v.Name ~= "UIListLayout" then 
												if TBLFIND(val.Jumbobox, v.Name) then 
													v.TextLabel.TextColor3 = COL3RGB(175, 175, 175) 
												else 
													v.TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
												end 
											end 
										end 
										updatetext() 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(val) 
									end 
									if data.default then 
										Element:SetValue(data.default) 
									end 

									ImageLabel.Parent = Button 
									ImageLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									ImageLabel.BackgroundTransparency = 1.000 
									ImageLabel.Position = UDIM2(0, 165, 0, 6) 
									ImageLabel.Size = UDIM2(0, 6, 0, 4) 
									ImageLabel.Image = "http://www.roblox.com/asset/?id=9335638990" 

									TextLabel_3.Parent = Dropdown 
									TextLabel_3.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel_3.BackgroundTransparency = 1.000 
									TextLabel_3.Position = UDIM2(0, 17, 0, -1) 
									TextLabel_3.Size = UDIM2(0.111913361, 208, 0.382215232, 0) 
									TextLabel_3.Font = Enum.Font.Gotham 
									TextLabel_3.Text = text 
									TextLabel_3.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel_3.TextSize = 11.000
									TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left 

									Button.MouseButton1Down:Connect(function() 
										Drop.Visible = not Drop.Visible 
										if not Drop.Visible then 
											Drop.CanvasPosition = Vec2(0,0) 
										end 
									end) 
									local indrop = false 
									local ind = false 
									Drop.MouseEnter:Connect(function() 
										indrop = true 
									end) 
									Drop.MouseLeave:Connect(function() 
										indrop = false 
									end) 
									Button.MouseEnter:Connect(function() 
										ind = true 
									end) 
									Button.MouseLeave:Connect(function() 
										ind = false 
									end) 
									game:GetService("UserInputService").InputBegan:Connect(function(input) 
										if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
											if Drop.Visible == true and not indrop and not ind then 
												Drop.Visible = false 
												Drop.CanvasPosition = Vec2(0,0) 
											end 
										end 
									end) 
								elseif type == "TextBox" then 

								elseif type == "ToggleKeybind" then 
									tabsize = tabsize + UDIM2(0,0,0,16) 
									Element.value = {Toggle = data.default and data.default.Toggle or false, Key, Type = "Always", Active = true} 

									local Toggle = INST("Frame") 
									local Button = INST("TextButton") 
									local Color = INST("Frame") 
									local TextLabel = INST("TextLabel") 

									Toggle.Name = "Toggle" 
									Toggle.Parent = tab1 
									Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Toggle.BackgroundTransparency = 1.000 
									Toggle.Size = UDIM2(1, 0, 0, 15) 

									Button.Name = "Button" 
									Button.Parent = Toggle 
									Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Button.BackgroundTransparency = 1.000 
									Button.Size = UDIM2(1, 0, 1, 0) 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									Color.Name = "Color" 
									Color.Parent = Button 
									Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Color.BorderColor3 = COL3RGB(27, 3275, 35) 
									Color.Position = UDIM2(0, 15, 0.5, -5) 
									Color.Size = UDIM2(0, 8, 0, 8) 
									local binding = false 
									TextLabel.Parent = Button 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.Position = UDIM2(0, 32, 0, -1) 
									TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = text 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

									local function update() 
										game:GetService('RunService').RenderStepped:Connect(function()
											if Element.value.Toggle then
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											else
												keybindremove(text) 
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											end
										end)
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
									end 

									Button.MouseButton1Down:Connect(function() 
										if not binding then 
											Element.value.Toggle = not Element.value.Toggle 
											update() 
											values[tabname][sectorname][tabtext][text] = Element.value 
											callback(Element.value) 
										end 
									end) 
									if data.default then 
										update() 
									end 
									values[tabname][sectorname][tabtext][text] = Element.value 
									do 
										local Keybind = INST("TextButton") 
										local Frame = INST("Frame") 
										local Always = INST("TextButton") 
										local UIListLayout = INST("UIListLayout") 
										local Hold = INST("TextButton") 
										local Toggle = INST("TextButton") 

										Keybind.Name = "Keybind" 
										Keybind.Parent = Button 
										Keybind.BackgroundColor3 = COL3RGB(31, 31, 31) 
										Keybind.BorderColor3 = COL3RGB(57, 57, 68) 
										Keybind.BackgroundTransparency = 1.000 
										Keybind.Position = UDIM2(0, 235, 0.5, -6) 
										Keybind.Text = "-" 
										Keybind.Size = UDIM2(0, 43, 0, 12) 
										Keybind.Size = UDIM2(0,txt:GetTextSize("-", 14, Enum.Font.Gotham, Vec2(700, 12)).X + 5,0, 12) 
										Keybind.AutoButtonColor = false 
										Keybind.Font = Enum.Font.Gotham 
										Keybind.TextColor3 = COL3RGB(255, 255, 255) 
										Keybind.TextSize = 11.000
										Keybind.AnchorPoint = Vec2(1,0) 
										Keybind.ZIndex = 3 

										Frame.Parent = Keybind 
										Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Frame.BorderColor3 = COL3RGB(57, 57, 68) 
										Frame.Position = UDIM2(1, -49, 0, 1) 
										Frame.Size = UDIM2(0, 49, 0, 49) 
										Frame.Visible = false 
										Frame.ZIndex = 3 

										Always.Name = "Always" 
										Always.Parent = Frame 
										Always.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Always.BackgroundTransparency = 1.000 
										Always.BorderColor3 = COL3RGB(57, 57, 68) 
										Always.Position = UDIM2(-3.03289485, 231, 0.115384616, -6) 
										Always.Size = UDIM2(1, 0, 0, 16) 
										Always.AutoButtonColor = false 
										Always.Font = Enum.Font.SourceSansBold 
										Always.Text = "Always" 
										Always.TextColor3 = COL3RGB(173, 24, 74) 
										Always.TextSize = 11.000
										Always.ZIndex = 3 

										UIListLayout.Parent = Frame 
										UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
										UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 

										Hold.Name = "Hold" 
										Hold.Parent = Frame 
										Hold.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Hold.BackgroundTransparency = 1.000 
										Hold.BorderColor3 = COL3RGB(57, 57, 68) 
										Hold.Position = UDIM2(-3.03289485, 231, 0.115384616, -6) 
										Hold.Size = UDIM2(1, 0, 0, 16) 
										Hold.AutoButtonColor = false 
										Hold.Font = Enum.Font.Gotham 
										Hold.Text = "Hold" 
										Hold.TextColor3 = COL3RGB(255, 255, 255) 
										Hold.TextSize = 11.000
										Hold.ZIndex = 3 

										Toggle.Name = "Toggle" 
										Toggle.Parent = Frame 
										Toggle.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Toggle.BackgroundTransparency = 1.000 
										Toggle.BorderColor3 = COL3RGB(57, 57, 68) 
										Toggle.Position = UDIM2(-3.03289485, 231, 0.115384616, -6) 
										Toggle.Size = UDIM2(1, 0, 0, 16) 
										Toggle.AutoButtonColor = false 
										Toggle.Font = Enum.Font.Gotham 
										Toggle.Text = "Toggle" 
										Toggle.TextColor3 = COL3RGB(255, 255, 255) 
										Toggle.TextSize = 11.000
										Toggle.ZIndex = 3 

										for _,button in pairs(Frame:GetChildren()) do 
											if button:IsA("TextButton") then 
												button.MouseButton1Down:Connect(function() 
													Element.value.Type = button.Text 
													Frame.Visible = false 
													Element.value.Active = Element.value.Type == "Always" and true or false 
													if Element.value.Type == "Always" then 
														keybindremove(text) 
													end 
													for _,button in pairs(Frame:GetChildren()) do 
														if button:IsA("TextButton") and button.Text ~= Element.value.Type then 
															button.Font = Enum.Font.Gotham 
															library:Tween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
														end 
													end 
													button.Font = Enum.Font.SourceSansBold 
													button.TextColor3 = COL3RGB(60, 0, 90) 
													values[tabname][sectorname][tabtext][text] = Element.value 
													callback(Element.value) 
												end) 
												button.MouseEnter:Connect(function() 
													if Element.value.Type ~= button.Text then 
														library:Tween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255,255,255)}) 
													end 
												end) 
												button.MouseLeave:Connect(function() 
													if Element.value.Type ~= button.Text then 
														library:Tween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
													end 
												end) 
											end 
										end 
										Keybind.MouseButton1Down:Connect(function() 
											if not binding then 
												wait() 
												binding = true 
												Keybind.Text = "..." 
												Keybind.Size = UDIM2(0,txt:GetTextSize("...", 14, Enum.Font.Gotham, Vec2(700, 12)).X + 4,0, 12) 
											end 
										end) 
										Keybind.MouseButton2Down:Connect(function() 
											if not binding then 
												Frame.Visible = not Frame.Visible 
											end 
										end) 
										local Player = game.Players.LocalPlayer 
										local Mouse = Player:GetMouse() 
										local InFrame = false 
										Frame.MouseEnter:Connect(function() 
											InFrame = true 
										end) 
										Frame.MouseLeave:Connect(function() 
											InFrame = false 
										end) 
										local InFrame2 = false 
										Keybind.MouseEnter:Connect(function() 
											InFrame2 = true 
										end) 
										Keybind.MouseLeave:Connect(function() 
											InFrame2 = false 
										end) 
										game:GetService("UserInputService").InputBegan:Connect(function(input) 
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 and not binding then 
												if Frame.Visible == true and not InFrame and not InFrame2 then 
													Frame.Visible = false 
												end 
											end 
											if binding then 
												binding = false 
												Keybind.Text = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name:upper() or input.UserInputType.Name:upper() 
												Keybind.Size = UDIM2(0,txt:GetTextSize(Keybind.Text, 14, Enum.Font.Gotham, Vec2(700, 12)).X + 5,0, 12) 
												Element.value.Key = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name 
												if input.KeyCode.Name == "Backspace" then 
													Keybind.Text = "-" 
													Keybind.Size = UDIM2(0,txt:GetTextSize(Keybind.Text, 14, Enum.Font.Gotham, Vec2(700, 12)).X + 4,0, 12) 
													Element.value.Key = nil 
												end 
											else 
												if Element.value.Key ~= nil then 
													if FIND(Element.value.Key, "Mouse") then 
														if input.UserInputType == Enum.UserInputType[Element.value.Key] then 
															if Element.value.Type == "Hold" then 
																Element.value.Active = true 
																if Element.value.Active and Element.value.Toggle then 
																	keybindhold(text) 
																else 
																	keybindremove(text) 
																end 
															elseif Element.value.Type == "Toggle" then 
																Element.value.Active = not Element.value.Active 
																if Element.value.Active and Element.value.Toggle then 
																	keybindadd(text) 
																else 
																	keybindremove(text) 
																end 
															end 
														end 
													else 
														if input.KeyCode == Enum.KeyCode[Element.value.Key] then 
															if Element.value.Type == "Hold" then 
																Element.value.Active = true 
																if Element.value.Active and Element.value.Toggle then 
																	keybindhold(text) 
																else 
																	keybindremove(text) 
																end 
															elseif Element.value.Type == "Toggle" then 
																Element.value.Active = not Element.value.Active 
																if Element.value.Active and Element.value.Toggle then 
																	keybindadd(text) 
																else 
																	keybindremove(text) 
																end 
															end 
														end 
													end 
												else 
													Element.value.Active = true 
												end 
											end 
											values[tabname][sectorname][tabtext][text] = Element.value 
											callback(Element.value) 
										end) 
										game:GetService("UserInputService").InputEnded:Connect(function(input) 
											if Element.value.Key ~= nil then 
												if FIND(Element.value.Key, "Mouse") then 
													if input.UserInputType == Enum.UserInputType[Element.value.Key] then 
														if Element.value.Type == "Hold" then 
															Element.value.Active = false 
															if Element.value.Active and Element.value.Toggle then 
																keybindhold(text) 
															else 
																keybindremove(text) 
															end 
														end 
													end 
												else 
													if input.KeyCode == Enum.KeyCode[Element.value.Key] then 
														if Element.value.Type == "Hold" then 
															Element.value.Active = false 
															if Element.value.Active and Element.value.Toggle then 
																keybindhold(text)
															else 
																keybindremove(text) 
															end 
														end 
													end 
												end 
											end 
											values[tabname][sectorname][tabtext][text] = Element.value 
											callback(Element.value) 
										end) 
									end 
									function Element:SetValue(value) 
										Element.value = value 
										update() 
									end 
								elseif type == "Toggle" then 
									tabsize = tabsize + UDIM2(0,0,0,16) 
									Element.value = {Toggle = data.default and data.default.Toggle or false} 

									local Toggle = INST("Frame") 
									local Button = INST("TextButton") 
									local Color = INST("Frame") 
									local TextLabel = INST("TextLabel") 

									Toggle.Name = "Toggle" 
									Toggle.Parent = tab1 
									Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Toggle.BackgroundTransparency = 1.000 
									Toggle.Size = UDIM2(1, 0, 0, 15) 

									Button.Name = "Button" 
									Button.Parent = Toggle 
									Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Button.BackgroundTransparency = 1.000 
									Button.Size = UDIM2(1, 0, 1, 0) 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									Color.Name = "Color" 
									Color.Parent = Button 
									Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Color.BorderColor3 = COL3RGB(57, 57, 68) 
									Color.Position = UDIM2(0, 15, 0.5, -5) 
									Color.Size = UDIM2(0, 8, 0, 8) 

									TextLabel.Parent = Button 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.Position = UDIM2(0, 32, 0, -1) 
									TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = text 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

									local function update() 
										game:GetService('RunService').RenderStepped:Connect(function()
											if Element.value.Toggle then
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											else 
												keybindremove(text) 
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											end 
										end)
										values[tabname][sectorname][tabtext][text] = Element.value 
									end 

									Button.MouseButton1Down:Connect(function() 
										Element.value.Toggle = not Element.value.Toggle 
										update() 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
									end) 
									if data.default then 
										update() 
									end 
									values[tabname][sectorname][tabtext][text] = Element.value 
									function Element:SetValue(value) 
										Element.value = value 
										values[tabname][sectorname][tabtext][text] = Element.value 
										update() 
										callback(Element.value) 
									end 
								elseif type == "ToggleColor" then 
									tabsize = tabsize + UDIM2(0,0,0,16) 
									Element.value = {Toggle = data.default and data.default.Toggle or false, Color = data.default and data.default.Color or COL3RGB(255,255,255)} 

									local Toggle = INST("Frame") 
									local Button = INST("TextButton") 
									local Color = INST("Frame") 
									local TextLabel = INST("TextLabel") 

									Toggle.Name = "Toggle" 
									Toggle.Parent = tab1 
									Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Toggle.BackgroundTransparency = 1.000 
									Toggle.Size = UDIM2(1, 0, 0, 15) 

									Button.Name = "Button" 
									Button.Parent = Toggle 
									Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Button.BackgroundTransparency = 1.000 
									Button.Size = UDIM2(1, 0, 1, 0) 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									Color.Name = "Color" 
									Color.Parent = Button 
									Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Color.BorderColor3 = COL3RGB(57, 57, 68) 
									Color.Position = UDIM2(0, 15, 0.5, -5) 
									Color.Size = UDIM2(0, 8, 0, 8) 

									TextLabel.Parent = Button 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.Position = UDIM2(0, 32, 0, -1) 
									TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = text 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

									local function update() 
										game:GetService('RunService').RenderStepped:Connect(function()
											if Element.value.Toggle then 
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											else 
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											end 
										end)
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
									end 

									local ColorH,ColorS,ColorV 

									local ColorP = INST("TextButton") 
									local Frame = INST("Frame") 
									local Colorpick = INST("ImageButton") 
									local ColorDrag = INST("Frame") 
									local Huepick = INST("ImageButton") 
									local Huedrag = INST("Frame") 

									ColorP.Name = "ColorP" 
									ColorP.Parent = Button 
									ColorP.AnchorPoint = Vec2(1, 0) 
									ColorP.BackgroundColor3 = COL3RGB(255, 0, 0) 
									ColorP.BorderColor3 = COL3RGB(57, 57, 68) 
									ColorP.Position = UDIM2(0, 235, 0.5, -4) 
									ColorP.Size = UDIM2(0, 18, 0, 8) 
									ColorP.AutoButtonColor = false 
									ColorP.Font = Enum.Font.Gotham 
									ColorP.Text = "" 
									ColorP.TextColor3 = COL3RGB(255, 255, 255) 
									ColorP.TextSize = 11.000

									Frame.Parent = ColorP 
									Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Frame.BorderColor3 = COL3RGB(57, 57, 68) 
									Frame.Position = UDIM2(-0.666666687, -170, 1.375, 0) 
									Frame.Size = UDIM2(0, 200, 0, 170) 
									Frame.Visible = false 
									Frame.ZIndex = 3 

									Colorpick.Name = "Colorpick" 
									Colorpick.Parent = Frame 
									Colorpick.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Colorpick.BorderColor3 = COL3RGB(57, 57, 68) 
									Colorpick.ClipsDescendants = false 
									Colorpick.Position = UDIM2(0, 40, 0, 10) 
									Colorpick.Size = UDIM2(0, 150, 0, 150) 
									Colorpick.AutoButtonColor = false 
									Colorpick.Image = "rbxassetid://4155801252" 
									Colorpick.ImageColor3 = COL3RGB(255, 0, 0) 
									Colorpick.ZIndex = 3 

									ColorDrag.Name = "ColorDrag" 
									ColorDrag.Parent = Colorpick 
									ColorDrag.AnchorPoint = Vec2(0.5, 0.5) 
									ColorDrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
									ColorDrag.BorderColor3 = COL3RGB(57, 57, 68) 
									ColorDrag.Size = UDIM2(0, 4, 0, 4) 
									ColorDrag.ZIndex = 3 

									Huepick.Name = "Huepick" 
									Huepick.Parent = Frame 
									Huepick.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Huepick.BorderColor3 = COL3RGB(57, 57, 68) 
									Huepick.ClipsDescendants = false 
									Huepick.Position = UDIM2(0, 10, 0, 10) 
									Huepick.Size = UDIM2(0, 20, 0, 150) 
									Huepick.AutoButtonColor = false 
									Huepick.Image = "rbxassetid://3641079629" 
									Huepick.ImageColor3 = COL3RGB(255, 0, 0) 
									Huepick.ImageTransparency = 1 
									Huepick.BackgroundTransparency = 0 
									Huepick.ZIndex = 3 

									local HueFrameGradient = INST("UIGradient") 
									HueFrameGradient.Rotation = 90 
									HueFrameGradient.Name = "HueFrameGradient" 
									HueFrameGradient.Parent = Huepick 
									HueFrameGradient.Color = ColorSequence.new { 
										ColorSequenceKeypoint.new(0.00, COL3RGB(255, 0, 0)), 
										ColorSequenceKeypoint.new(0.17, COL3RGB(255, 0, 255)), 
										ColorSequenceKeypoint.new(0.33, COL3RGB(0, 0, 255)), 
										ColorSequenceKeypoint.new(0.50, COL3RGB(0, 255, 255)), 
										ColorSequenceKeypoint.new(0.67, COL3RGB(0, 255, 0)), 
										ColorSequenceKeypoint.new(0.83, COL3RGB(255, 255, 0)), 
										ColorSequenceKeypoint.new(1.00, COL3RGB(255, 0, 0)) 
									}	 

									Huedrag.Name = "Huedrag" 
									Huedrag.Parent = Huepick 
									Huedrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Huedrag.BorderColor3 = COL3RGB(57, 57, 68) 
									Huedrag.Size = UDIM2(1, 0, 0, 2) 
									Huedrag.ZIndex = 3 

									ColorP.MouseButton1Down:Connect(function() 
										Frame.Visible = not Frame.Visible 
									end) 
									local abc = false 
									local inCP = false 
									ColorP.MouseEnter:Connect(function() 
										abc = true 
									end) 
									ColorP.MouseLeave:Connect(function() 
										abc = false 
									end) 
									Frame.MouseEnter:Connect(function() 
										inCP = true 
									end) 
									Frame.MouseLeave:Connect(function() 
										inCP = false 
									end) 

									ColorH = (CLAMP(Huedrag.AbsolutePosition.Y-Huepick.AbsolutePosition.Y, 0, Huepick.AbsoluteSize.Y)/Huepick.AbsoluteSize.Y) 
									ColorS = 1-(CLAMP(ColorDrag.AbsolutePosition.X-Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
									ColorV = 1-(CLAMP(ColorDrag.AbsolutePosition.Y-Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 

									if data.default.Color ~= nil then 
										ColorH, ColorS, ColorV = data.default.Color:ToHSV() 

										ColorH = CLAMP(ColorH,0,1) 
										ColorS = CLAMP(ColorS,0,1) 
										ColorV = CLAMP(ColorV,0,1) 
										ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 

										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 
									end 

									local mouse = LocalPlayer:GetMouse() 
									game:GetService("UserInputService").InputBegan:Connect(function(input) 
										if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
											if not dragging and not abc and not inCP then 
												Frame.Visible = false 
											end 
										end 
									end) 

									local function updateColor() 
										local ColorX = (CLAMP(mouse.X - Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
										local ColorY = (CLAMP(mouse.Y - Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 
										ColorDrag.Position = UDIM2(ColorX, 0, ColorY, 0) 
										ColorS = 1-ColorX 
										ColorV = 1-ColorY 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										values[tabname][sectorname][tabtext][text] = Element.value 
										Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
										callback(Element.value) 
									end 
									local function updateHue() 
										local y = CLAMP(mouse.Y - Huepick.AbsolutePosition.Y, 0, 148) 
										Huedrag.Position = UDIM2(0, 0, 0, y) 
										hue = y/148 
										ColorH = 1-hue 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										values[tabname][sectorname][tabtext][text] = Element.value 
										Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
										callback(Element.value) 
									end 
									Colorpick.MouseButton1Down:Connect(function() 
										updateColor() 
										moveconnection = mouse.Move:Connect(function() 
											updateColor() 
										end) 
										releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
											if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
												updateColor() 
												moveconnection:Disconnect() 
												releaseconnection:Disconnect() 
											end 
										end) 
									end) 
									Huepick.MouseButton1Down:Connect(function() 
										updateHue() 
										moveconnection = mouse.Move:Connect(function() 
											updateHue() 
										end) 
										releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
											if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
												updateHue() 
												moveconnection:Disconnect() 
												releaseconnection:Disconnect() 
											end 
										end) 
									end) 

									Button.MouseButton1Down:Connect(function() 
										Element.value.Toggle = not Element.value.Toggle 
										update() 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
									end) 
									if data.default then 
										update() 
									end 
									values[tabname][sectorname][tabtext][text] = Element.value 
									function Element:SetValue(value) 
										Element.value = value 
										local duplicate = COL3(value.Color.R, value.Color.G, value.Color.B) 
										ColorH, ColorS, ColorV = duplicate:ToHSV() 
										ColorH = CLAMP(ColorH,0,1) 
										ColorS = CLAMP(ColorS,0,1) 
										ColorV = CLAMP(ColorV,0,1) 

										ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										update() 
										Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 
									end 
								elseif type == "ToggleTrans" then 
									tabsize = tabsize + UDIM2(0,0,0,16) 
									Element.value = {Toggle = data.default and data.default.Toggle or false, Color = data.default and data.default.Color or COL3RGB(255,255,255), Transparency = data.default and data.default.Transparency or 0} 

									local Toggle = INST("Frame") 
									local Button = INST("TextButton") 
									local Color = INST("Frame") 
									local TextLabel = INST("TextLabel") 

									Toggle.Name = "Toggle" 
									Toggle.Parent = tab1 
									Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Toggle.BackgroundTransparency = 1.000 
									Toggle.Size = UDIM2(1, 0, 0, 15) 

									Button.Name = "Button" 
									Button.Parent = Toggle 
									Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Button.BackgroundTransparency = 1.000 
									Button.Size = UDIM2(1, 0, 1, 0) 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									Color.Name = "Color" 
									Color.Parent = Button 
									Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Color.BorderColor3 = COL3RGB(57, 57, 68) 
									Color.Position = UDIM2(0, 15, 0.5, -5) 
									Color.Size = UDIM2(0, 8, 0, 8) 

									TextLabel.Parent = Button 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.Position = UDIM2(0, 32, 0, -1) 
									TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = text 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

									local function update() 
										game:GetService('RunService').RenderStepped:Connect(function()
											if Element.value.Toggle then
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											else 
												tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											end 
										end)
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
									end 

									local ColorH,ColorS,ColorV 

									local ColorP = INST("TextButton") 
									local Frame = INST("Frame") 
									local Colorpick = INST("ImageButton") 
									local ColorDrag = INST("Frame") 
									local Huepick = INST("ImageButton") 
									local Huedrag = INST("Frame") 

									ColorP.Name = "ColorP" 
									ColorP.Parent = Button 
									ColorP.AnchorPoint = Vec2(1, 0) 
									ColorP.BackgroundColor3 = COL3RGB(255, 0, 0) 
									ColorP.BorderColor3 = COL3RGB(57, 57, 68) 
									ColorP.Position = UDIM2(0, 235, 0.5, -4) 
									ColorP.Size = UDIM2(0, 18, 0, 8) 
									ColorP.AutoButtonColor = false 
									ColorP.Font = Enum.Font.Gotham 
									ColorP.Text = "" 
									ColorP.TextColor3 = COL3RGB(255, 255, 255) 
									ColorP.TextSize = 11.000

									Frame.Parent = ColorP 
									Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Frame.BorderColor3 = COL3RGB(57, 57, 68) 
									Frame.Position = UDIM2(-0.666666687, -170, 1.375, 0) 
									Frame.Size = UDIM2(0, 200, 0, 190) 
									Frame.Visible = false 
									Frame.ZIndex = 3 

									Colorpick.Name = "Colorpick" 
									Colorpick.Parent = Frame 
									Colorpick.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Colorpick.BorderColor3 = COL3RGB(57, 57, 68) 
									Colorpick.ClipsDescendants = false 
									Colorpick.Position = UDIM2(0, 40, 0, 10) 
									Colorpick.Size = UDIM2(0, 150, 0, 150) 
									Colorpick.AutoButtonColor = false 
									Colorpick.Image = "rbxassetid://4155801252" 
									Colorpick.ImageColor3 = COL3RGB(255, 0, 0) 
									Colorpick.ZIndex = 3 

									ColorDrag.Name = "ColorDrag" 
									ColorDrag.Parent = Colorpick 
									ColorDrag.AnchorPoint = Vec2(0.5, 0.5) 
									ColorDrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
									ColorDrag.BorderColor3 = COL3RGB(57, 57, 68) 
									ColorDrag.Size = UDIM2(0, 4, 0, 4) 
									ColorDrag.ZIndex = 3 

									Huepick.Name = "Huepick" 
									Huepick.Parent = Frame 
									Huepick.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Huepick.BorderColor3 = COL3RGB(57, 57, 68) 
									Huepick.ClipsDescendants = true 
									Huepick.Position = UDIM2(0, 10, 0, 10) 
									Huepick.Size = UDIM2(0, 20, 0, 150) 
									Huepick.AutoButtonColor = false 
									Huepick.Image = "rbxassetid://3641079629" 
									Huepick.ImageColor3 = COL3RGB(255, 0, 0) 
									Huepick.ImageTransparency = 1 
									Huepick.BackgroundTransparency = 0 
									Huepick.ZIndex = 3 

									local HueFrameGradient = INST("UIGradient") 
									HueFrameGradient.Rotation = 90 
									HueFrameGradient.Name = "HueFrameGradient" 
									HueFrameGradient.Parent = Huepick 
									HueFrameGradient.Color = ColorSequence.new { 
										ColorSequenceKeypoint.new(0.00, COL3RGB(255, 0, 0)), 
										ColorSequenceKeypoint.new(0.17, COL3RGB(255, 0, 255)), 
										ColorSequenceKeypoint.new(0.33, COL3RGB(0, 0, 255)), 
										ColorSequenceKeypoint.new(0.50, COL3RGB(0, 255, 255)), 
										ColorSequenceKeypoint.new(0.67, COL3RGB(0, 255, 0)), 
										ColorSequenceKeypoint.new(0.83, COL3RGB(255, 255, 0)), 
										ColorSequenceKeypoint.new(1.00, COL3RGB(255, 0, 0)) 
									}	 

									Huedrag.Name = "Huedrag" 
									Huedrag.Parent = Huepick 
									Huedrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Huedrag.BorderColor3 = COL3RGB(57, 57, 68) 
									Huedrag.Size = UDIM2(1, 0, 0, 2) 
									Huedrag.ZIndex = 3 

									local Transpick = INST("ImageButton") 
									local Transcolor = INST("ImageLabel") 
									local Transdrag = INST("Frame") 

									Transpick.Name = "Transpick" 
									Transpick.Parent = Frame 
									Transpick.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Transpick.BorderColor3 = COL3RGB(57, 57, 68) 
									Transpick.Position = UDIM2(0, 10, 0, 167) 
									Transpick.Size = UDIM2(0, 180, 0, 15) 
									Transpick.AutoButtonColor = false 
									Transpick.Image = "rbxassetid://3887014957" 
									Transpick.ScaleType = Enum.ScaleType.Tile 
									Transpick.TileSize = UDIM2(0, 10, 0, 10) 
									Transpick.ZIndex = 3 

									Transcolor.Name = "Transcolor" 
									Transcolor.Parent = Transpick 
									Transcolor.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Transcolor.BackgroundTransparency = 1.000 
									Transcolor.Size = UDIM2(1, 0, 1, 0) 
									Transcolor.Image = "rbxassetid://3887017050" 
									Transcolor.ImageColor3 = COL3RGB(255, 0, 4) 
									Transcolor.ZIndex = 3 

									Transdrag.Name = "Transdrag" 
									Transdrag.Parent = Transcolor 
									Transdrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Transdrag.BorderColor3 = COL3RGB(57, 57, 68) 
									Transdrag.Position = UDIM2(0, -1, 0, 0) 
									Transdrag.Size = UDIM2(0, 2, 1, 0) 
									Transdrag.ZIndex = 3 

									ColorP.MouseButton1Down:Connect(function() 
										Frame.Visible = not Frame.Visible 
									end) 
									local abc = false 
									local inCP = false 
									ColorP.MouseEnter:Connect(function() 
										abc = true 
									end) 
									ColorP.MouseLeave:Connect(function() 
										abc = false 
									end) 
									Frame.MouseEnter:Connect(function() 
										inCP = true 
									end) 
									Frame.MouseLeave:Connect(function() 
										inCP = false 
									end) 

									ColorH = (CLAMP(Huedrag.AbsolutePosition.Y-Huepick.AbsolutePosition.Y, 0, Huepick.AbsoluteSize.Y)/Huepick.AbsoluteSize.Y) 
									ColorS = 1-(CLAMP(ColorDrag.AbsolutePosition.X-Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
									ColorV = 1-(CLAMP(ColorDrag.AbsolutePosition.Y-Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 

									if data.default.Color ~= nil then 
										ColorH, ColorS, ColorV = data.default.Color:ToHSV() 

										ColorH = CLAMP(ColorH,0,1) 
										ColorS = CLAMP(ColorS,0,1) 
										ColorV = CLAMP(ColorV,0,1) 
										ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 

										Transcolor.ImageColor3 = COL3HSV(ColorH, 1, 1) 

										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 
									end 
									if data.default.Transparency ~= nil then 
										Transdrag.Position = UDIM2(data.default.Transparency, -1, 0, 0) 
									end 
									local mouse = LocalPlayer:GetMouse() 
									game:GetService("UserInputService").InputBegan:Connect(function(input) 
										if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
											if not dragging and not abc and not inCP then 
												Frame.Visible = false 
											end 
										end 
									end) 

									local function updateColor() 
										local ColorX = (CLAMP(mouse.X - Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
										local ColorY = (CLAMP(mouse.Y - Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 
										ColorDrag.Position = UDIM2(ColorX, 0, ColorY, 0) 
										ColorS = 1-ColorX 
										ColorV = 1-ColorY 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										Transcolor.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										values[tabname][sectorname][tabtext][text] = Element.value 
										Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
										callback(Element.value) 
									end 
									local function updateHue() 
										local y = CLAMP(mouse.Y - Huepick.AbsolutePosition.Y, 0, 148) 
										Huedrag.Position = UDIM2(0, 0, 0, y) 
										hue = y/148 
										ColorH = 1-hue 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										Transcolor.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										values[tabname][sectorname][tabtext][text] = Element.value 
										Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
										callback(Element.value) 
									end 
									local function updateTrans() 
										local x = CLAMP(mouse.X - Transpick.AbsolutePosition.X, 0, 178) 
										Transdrag.Position = UDIM2(0, x, 0, 0) 
										Element.value.Transparency = (x/178) 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
									end 
									Transpick.MouseButton1Down:Connect(function() 
										updateTrans() 
										moveconnection = mouse.Move:Connect(function() 
											updateTrans() 
										end) 
										releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
											if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
												updateTrans() 
												moveconnection:Disconnect() 
												releaseconnection:Disconnect() 
											end 
										end) 
									end) 
									Colorpick.MouseButton1Down:Connect(function() 
										updateColor() 
										moveconnection = mouse.Move:Connect(function() 
											updateColor() 
										end) 
										releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
											if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
												updateColor() 
												moveconnection:Disconnect() 
												releaseconnection:Disconnect() 
											end 
										end) 
									end) 
									Huepick.MouseButton1Down:Connect(function() 
										updateHue() 
										moveconnection = mouse.Move:Connect(function() 
											updateHue() 
										end) 
										releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
											if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
												updateHue() 
												moveconnection:Disconnect() 
												releaseconnection:Disconnect() 
											end 
										end) 
									end) 

									Button.MouseButton1Down:Connect(function() 
										Element.value.Toggle = not Element.value.Toggle 
										update() 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
									end) 
									if data.default then 
										update() 
									end 
									values[tabname][sectorname][tabtext][text] = Element.value 
									function Element:SetValue(value) 
										Element.value = value 
										local duplicate = COL3(value.Color.R, value.Color.G, value.Color.B) 
										ColorH, ColorS, ColorV = duplicate:ToHSV() 
										ColorH = CLAMP(ColorH,0,1) 
										ColorS = CLAMP(ColorS,0,1) 
										ColorV = CLAMP(ColorV,0,1) 

										ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
										Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
										ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
										update() 
										Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 
									end 
								elseif type == "Dropdown" then 
									tabsize = tabsize + UDIM2(0,0,0,39) 
									Element.value = {Dropdown = data.options[1]} 

									local Dropdown = INST("Frame") 
									local Button = INST("TextButton") 
									local TextLabel = INST("TextLabel") 
									local Drop = INST("ScrollingFrame") 
									local Button_2 = INST("TextButton") 
									local TextLabel_2 = INST("TextLabel") 
									local UIListLayout = INST("UIListLayout") 
									local ImageLabel = INST("ImageLabel") 
									local TextLabel_3 = INST("TextLabel") 

									Dropdown.Name = "Dropdown" 
									Dropdown.Parent = tab1 
									Dropdown.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Dropdown.BackgroundTransparency = 1.000 
									Dropdown.Position = UDIM2(0, 0, 0.255102038, 0) 
									Dropdown.Size = UDIM2(1, 0, 0, 39) 

									Button.Name = "Button" 
									Button.Parent = Dropdown 
									Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Button.BorderColor3 = COL3RGB(57, 57, 68) 
									Button.Position = UDIM2(0, 15, 0, 16)
									Button.Size = UDIM2(0, 175, 0, 17) 
									Button.AutoButtonColor = false 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									TextLabel.Parent = Button 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
									TextLabel.Position = UDIM2(0, 5, 0, 0) 
									TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = Element.value.Dropdown 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

									local abcd = TextLabel 

									Drop.Name = "Drop" 
									Drop.Parent = Button 
									Drop.Active = true 
									Drop.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Drop.BorderColor3 = COL3RGB(57, 57, 68) 
									Drop.Position = UDIM2(0, 0, 1, 1) 
									Drop.Size = UDIM2(1, 0, 0, 20) 
									Drop.Visible = false 
									Drop.BottomImage = "http://www.roblox.com/asset/?id=6724808282" 
									Drop.CanvasSize = UDIM2(0, 0, 0, 0) 
									Drop.ScrollBarThickness = 4 
									Drop.MidImage = "http://www.roblox.com/asset/?id=6724808282" 
									Drop.TopImage = "http://www.roblox.com/asset/?id=6724808282" 
									Drop.AutomaticCanvasSize = "Y" 
									Drop.ZIndex = 5 
									Drop.ScrollBarImageColor3 = COL3RGB(172, 208, 255) 

									UIListLayout.Parent = Drop 
									UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
									UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 

									local num = #data.options 
									if num > 5 then 
										Drop.Size = UDIM2(1, 0, 0, 85) 
									else 
										Drop.Size = UDIM2(1, 0, 0, 17*num) 
									end 
									Drop.CanvasSize = UDIM2(1, 0, 0, 17*num) 
									local first = true 
									for i,v in ipairs(data.options) do 
										do 
											local Button = INST("TextButton") 
											local TextLabel = INST("TextLabel") 

											Button.Name = v 
											Button.Parent = Drop 
											Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
											Button.BorderColor3 = COL3RGB(57, 57, 68) 
											Button.Position = UDIM2(0, 15, 0, 16) 
											Button.Size = UDIM2(0, 175, 0, 17) 
											Button.AutoButtonColor = false 
											Button.Font = Enum.Font.SourceSans 
											Button.Text = "" 
											Button.TextColor3 = COL3RGB(0, 0, 0) 
											Button.TextSize = 11.000
											Button.BorderSizePixel = 0 
											Button.ZIndex = 6 

											TextLabel.Parent = Button 
											TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
											TextLabel.BackgroundTransparency = 1.000 
											TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
											TextLabel.Position = UDIM2(0, 5, 0, -1) 
											TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
											TextLabel.Font = Enum.Font.Gotham 
											TextLabel.Text = v 
											TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
											TextLabel.TextSize = 11.000
											TextLabel.TextXAlignment = Enum.TextXAlignment.Left 
											TextLabel.ZIndex = 6 

											Button.MouseButton1Down:Connect(function() 
												Drop.Visible = false 
												Element.value.Dropdown = v 
												abcd.Text = v 
												values[tabname][sectorname][tabtext][text] = Element.value 
												callback(Element.value) 
												Drop.CanvasPosition = Vec2(0,0) 
											end) 
											Button.MouseEnter:Connect(function() 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 =  COL3RGB(255, 255, 255)}) 
											end) 
											Button.MouseLeave:Connect(function() 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 =  COL3RGB(255, 255, 255)}) 
											end) 

											first = false 
										end 
									end 

									function Element:SetValue(val) 
										Element.value = val 
										abcd.Text = val.Dropdown 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(val) 
									end 

									ImageLabel.Parent = Button 
									ImageLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									ImageLabel.BackgroundTransparency = 1.000 
									ImageLabel.Position = UDIM2(0, 165, 0, 6) 
									ImageLabel.Size = UDIM2(0, 6, 0, 4) 
									ImageLabel.Image = "http://www.roblox.com/asset/?id=9335638990" 

									TextLabel_3.Parent = Dropdown 
									TextLabel_3.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel_3.BackgroundTransparency = 1.000 
									TextLabel_3.Position = UDIM2(0, 32, 0, -1) 
									TextLabel_3.Size = UDIM2(0.111913361, 208, 0.382215232, 0) 
									TextLabel_3.Font = Enum.Font.Gotham 
									TextLabel_3.Text = text 
									TextLabel_3.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel_3.TextSize = 11.000
									TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left 

									Button.MouseButton1Down:Connect(function() 
										Drop.Visible = not Drop.Visible 
										if not Drop.Visible then 
											Drop.CanvasPosition = Vec2(0,0) 
										end 
									end) 
									local indrop = false 
									local ind = false 
									Drop.MouseEnter:Connect(function() 
										indrop = true 
									end) 
									Drop.MouseLeave:Connect(function() 
										indrop = false 
									end) 
									Button.MouseEnter:Connect(function() 
										ind = true 
									end) 
									Button.MouseLeave:Connect(function() 
										ind = false 
									end) 
									game:GetService("UserInputService").InputBegan:Connect(function(input) 
										if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
											if Drop.Visible == true and not indrop and not ind then 
												Drop.Visible = false 
												Drop.CanvasPosition = Vec2(0,0) 
											end 
										end 
									end) 
									values[tabname][sectorname][tabtext][text] = Element.value 
								elseif type == "Slider" then 

									tabsize = tabsize + UDIM2(0,0,0,25) 

									local Slider = INST("Frame") 
									local TextLabel = INST("TextLabel") 
									local Button = INST("TextButton") 
									local Frame = INST("Frame") 
									local Value = INST("TextLabel") 

									Slider.Name = "Slider" 
									Slider.Parent = tab1 
									Slider.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Slider.BackgroundTransparency = 1.000 
									Slider.Position = UDIM2(0, 0, 0.653061211, 0) 
									Slider.Size = UDIM2(1, 0, 0, 25) 

									TextLabel.Parent = Slider 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.Position = UDIM2(0, 15, 0, -2) 
									TextLabel.Size = UDIM2(0, 100, 0, 15) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = text 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

									Button.Name = "Button" 
									Button.Parent = Slider 
									Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Button.BorderColor3 = COL3RGB(57, 57, 68) 
									Button.Position = UDIM2(0, 15, 0, 15) 
									Button.Size = UDIM2(0, 175, 0, 5) 
									Button.AutoButtonColor = false 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									Frame.Parent = Button 
									game:GetService('RunService').RenderStepped:Connect(function()
										Frame.BackgroundColor3 = theme.accent
									end)
									Frame.BorderSizePixel = 0 
									Frame.Size = UDIM2(0.5, 0, 1, 0) 

									Value.Name = "Value" 
									Value.Parent = Slider 
									Value.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Value.BackgroundTransparency = 1.000 
									Value.Position = UDim2.new(0, 135, 0, -1)
									Value.Size = UDim2.new(0, 55, 0, 15)
									Value.Font = Enum.Font.Gotham 
									Value.Text = "50" 
									Value.TextStrokeTransparency = 1
									Value.TextColor3 = COL3RGB(255, 255, 255) 
									Value.TextSize = 11.000
									Value.TextXAlignment = Enum.TextXAlignment.Right
									local min, max, default = data.min or 0, data.max or 100, data.default or 0 
									Element.value = {Slider = default} 

									function Element:SetValue(value) 
										Element.value = value 
										local a 
										if min > 0 then 
											a = ((Element.value.Slider - min)) / (max-min) 
										else 
											a = (Element.value.Slider-min)/(max-min) 
										end 
										Value.Text = Element.value.Slider 
										Frame.Size = UDIM2(a,0,1,0) 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(value) 
									end 
									local a 
									if min > 0 then 
										a = ((Element.value.Slider - min)) / (max-min) 
									else 
										a = (Element.value.Slider-min)/(max-min) 
									end 
									Value.Text = Element.value.Slider 
									Frame.Size = UDIM2(a,0,1,0) 
									values[tabname][sectorname][tabtext][text] = Element.value 
									local uis = game:GetService("UserInputService") 
									local mouse = game.Players.LocalPlayer:GetMouse() 
									local val 
									Button.MouseButton1Down:Connect(function() 
										Frame.Size = UDIM2(0, CLAMP(mouse.X - Frame.AbsolutePosition.X, 0, 175), 0, 5) 
										val = FLOOR((((tonumber(max) - tonumber(min)) / 175) * Frame.AbsoluteSize.X) + tonumber(min)) or 0 
										Value.Text = val 
										Element.value.Slider = val 
										values[tabname][sectorname][tabtext][text] = Element.value 
										callback(Element.value) 
										moveconnection = mouse.Move:Connect(function() 
											Frame.Size = UDIM2(0, CLAMP(mouse.X - Frame.AbsolutePosition.X, 0, 175), 0, 5) 
											val = FLOOR((((tonumber(max) - tonumber(min)) / 175) * Frame.AbsoluteSize.X) + tonumber(min)) 
											Value.Text = val 
											Element.value.Slider = val 
											values[tabname][sectorname][tabtext][text] = Element.value 
											callback(Element.value) 
										end) 
										releaseconnection = uis.InputEnded:Connect(function(Mouse) 
											if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
												Frame.Size = UDIM2(0, CLAMP(mouse.X - Frame.AbsolutePosition.X, 0, 175), 0, 5) 
												val = FLOOR((((tonumber(max) - tonumber(min)) / 175) * Frame.AbsoluteSize.X) + tonumber(min)) 
												values[tabname][sectorname][tabtext][text] = Element.value 
												callback(Element.value) 
												moveconnection:Disconnect() 
												releaseconnection:Disconnect() 
											end 
										end) 
									end) 
								elseif type == "Button" then 

									tabsize = tabsize + UDIM2(0,0,0,24) 
									local Button = INST("Frame") 
									local Button_2 = INST("TextButton") 
									local TextLabel = INST("TextLabel") 

									Button.Name = "Button" 
									Button.Parent = tab1 
									Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
									Button.BackgroundTransparency = 1.000 
									Button.Position = UDIM2(0, 0, 0.236059487, 0) 
									Button.Size = UDIM2(1, 0, 0, 24) 

									Button_2.Name = "Button" 
									Button_2.Parent = Button 
									Button_2.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Button_2.BorderColor3 = COL3RGB(57, 57, 68) 
									Button_2.Position = UDIM2(0, 15, 0.5, -9) 
									Button_2.Size = UDIM2(0, 175, 0, 18) 
									Button_2.AutoButtonColor = false 
									Button_2.Font = Enum.Font.SourceSans 
									Button_2.Text = "" 
									Button_2.TextColor3 = COL3RGB(0, 0, 0) 
									Button_2.TextSize = 11.000

									TextLabel.Parent = Button_2 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
									TextLabel.Size = UDIM2(1, 0, 1, 0) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = text 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000

									function Element:SetValue() 
									end 

									Button_2.MouseButton1Down:Connect(function() 
										TextLabel.TextColor3 = COL3RGB(172, 208, 255) 
										library:Tween(TextLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										callback() 
									end) 
									Button_2.MouseEnter:Connect(function() 
										library:Tween(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
									end) 
									Button_2.MouseLeave:Connect(function() 
										library:Tween(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
									end) 
								end 
								ConfigLoad:Connect(function(cfg) 
									local fix = library:ConfigFix(cfg) 
									if fix[tabname][sectorname][tabtext][text] ~= nil then 
										Element:SetValue(fix[tabname][sectorname][tabtext][text]) 
									end 
								end) 

								return Element 
							end 


							if firs then 
								coroutine.wrap(function() 
									game:GetService("RunService").RenderStepped:Wait() 
									Section.Size = tabsize 
								end)() 
								selected = text 
								TextButton.TextColor3 = COL3RGB(255,255,255) 
								tab1.Visible = true 
								firs = false 
							end 

							return tab 
						end 
						return MSector 
					end 
					function Tab:Sector(text, side) 
						local sectorname = text 
						local Sector = {} 
						values[tabname][text] = {} 
						local Section = INST("Frame") 
						local SectionText = INST("TextLabel") 
						local Inner = INST("Frame") 
						local UIListLayout = INST("UIListLayout") 

						Section.Name = "Section" 
						Section.Parent = TabGui[side] 
						Section.BackgroundColor3 = COL3RGB(31, 31, 41) 
						Section.BorderColor3 = COL3RGB(57, 57, 68) 
						Section.BorderSizePixel = 0 
						Section.Position = UDIM2(0, 0, 0, 0) 
						Section.Size = UDIM2(1, 0, 0, 22) 

						local holder2 = Instance.new("Frame")
						local texty = Instance.new("TextLabel")
						local thing = Instance.new("Frame")

						holder2.Name = "holder2"
						holder2.Parent = Section
						holder2.BackgroundColor3 = Color3.fromRGB(41, 41, 52)
						holder2.BorderSizePixel = 0
						holder2.Position = UDim2.new(0, 0, 0, 0)
						holder2.Size = UDim2.new(0, 250, 0, 20)

						texty.Name = "texty"
						texty.Parent = holder2
						texty.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						texty.BackgroundTransparency = 1.000
						texty.Size = UDim2.new(0, 250, 0, 18)
						texty.Font = Enum.Font.Ubuntu
						texty.Text = "  "..text
						texty.TextColor3 = Color3.fromRGB(255, 255, 255)
						texty.TextSize = 12.000
						texty.TextXAlignment = Enum.TextXAlignment.Left

						thing.Name = "thing"
						thing.Parent = holder2
						game:GetService('RunService').RenderStepped:Connect(function()
							thing.BackgroundColor3 = theme.accent
						end)
						thing.BorderSizePixel = 0
						thing.Position = UDim2.new(0, 0, 1, 0)
						thing.Size = UDim2.new(0, 250, 0, 4)

						Inner.Name = "Inner" 
						Inner.Parent = Section 
						Inner.BackgroundColor3 = COL3RGB(31, 31, 41) 
						Inner.BorderColor3 = COL3RGB(255, 255, 255) 
						Inner.BorderSizePixel = 0 
						Inner.Position = UDIM2(0, 1, 0, 24) 
						Inner.Size = UDIM2(1, -2, 1, -2) 

						local UIPadding = INST("UIPadding") 

						UIPadding.Parent = Inner 
						UIPadding.PaddingTop = UDim.new(0, 10) 

						UIListLayout.Parent = Inner 
						UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
						UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 
						UIListLayout.Padding = UDim.new(0,1) 

						function Sector:Element(type, text, data, callback) 
							local Element = {} 
							data = data or {} 
							callback = callback or function() end 
							values[tabname][sectorname][text] = {} 
							if type == "ScrollDrop" then 
								Section.Size = Section.Size + UDIM2(0,0,0,39) 
								Element.value = {Scroll = {}, Dropdown = ""} 

								for i,v in pairs(data.options) do 
									Element.value.Scroll[i] = v[1] 
								end 

								local joe = {} 
								if data.alphabet then 
									local copy = {} 
									for i,v in pairs(data.options) do 
										INSERT(copy, i) 
									end 
									TBLSORT(copy, function(a,b) 
										return a < b 
									end) 
									joe = copy 
								else 
									for i,v in pairs(data.options) do 
										INSERT(joe, i) 
									end 
								end 

								local Dropdown = INST("Frame") 
								local Button = INST("TextButton") 
								local TextLabel = INST("TextLabel") 
								local Drop = INST("ScrollingFrame") 
								local Button_2 = INST("TextButton") 
								local TextLabel_2 = INST("TextLabel") 
								local UIListLayout = INST("UIListLayout") 
								local ImageLabel = INST("ImageLabel") 
								local TextLabel_3 = INST("TextLabel") 

								Dropdown.Name = "Dropdown" 
								Dropdown.Parent = Inner 
								Dropdown.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Dropdown.BackgroundTransparency = 1.000 
								Dropdown.Position = UDIM2(0, 0, 0, 0) 
								Dropdown.Size = UDIM2(1, 0, 0, 39) 

								Button.Name = "Button" 
								Button.Parent = Dropdown 
								Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Button.BorderColor3 = COL3RGB(57, 57, 68) 
								Button.Position = UDIM2(0, 30, 0, 16) 
								Button.Size = UDIM2(0, 175, 0, 17) 
								Button.AutoButtonColor = false 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								local TextLabel = INST("TextLabel") 

								TextLabel.Parent = Button 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
								TextLabel.Position = UDIM2(0, 5, 0, 0) 
								TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = "lol" 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								local abcd = TextLabel 

								Drop.Name = "Drop" 
								Drop.Parent = Button 
								Drop.Active = true 
								Drop.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Drop.BorderColor3 = COL3RGB(57, 57, 68) 
								Drop.Position = UDIM2(0, 0, 1, 1) 
								Drop.Size = UDIM2(1, 0, 0, 20) 
								Drop.Visible = false 
								Drop.BottomImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.CanvasSize = UDIM2(0, 0, 0, 0) 
								Drop.ScrollBarThickness = 4 
								Drop.TopImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.MidImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.AutomaticCanvasSize = "Y" 
								Drop.ZIndex = 5 
								Drop.ScrollBarImageColor3 = COL3RGB(172, 208, 255) 

								UIListLayout.Parent = Drop 
								UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
								UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 


								local amount = data.Amount or 6 
								Section.Size = Section.Size + UDIM2(0,0,0,amount * 16 + 8) 

								local num = #joe 
								if num > 5 then 
									Drop.Size = UDIM2(1, 0, 0, 85) 
								else 
									Drop.Size = UDIM2(1, 0, 0, 17*num) 
								end 
								local first = true 
								for i,v in ipairs(joe) do 
									do 
										local joell = v 
										local Scroll = INST("Frame") 
										local joe2 = data.options[v] 
										local Button = INST("TextButton") 
										local TextLabel = INST("TextLabel") 

										Button.Name = v 
										Button.Parent = Drop 
										Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Button.BorderColor3 = COL3RGB(57, 57, 68) 
										Button.Position = UDIM2(0, 30, 0, 16) 
										Button.Size = UDIM2(0, 175, 0, 17) 
										Button.AutoButtonColor = false 
										Button.Font = Enum.Font.SourceSans 
										Button.Text = "" 
										Button.TextColor3 = COL3RGB(0, 0, 0) 
										Button.TextSize = 11.000
										Button.BorderSizePixel = 0 
										Button.ZIndex = 6 

										TextLabel.Parent = Button 
										TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
										TextLabel.BackgroundTransparency = 1.000 
										TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
										TextLabel.Position = UDIM2(0, 5, 0, -1) 
										TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
										TextLabel.Font = Enum.Font.Gotham 
										TextLabel.Text = v 
										TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
										TextLabel.TextSize = 11.000
										TextLabel.TextXAlignment = Enum.TextXAlignment.Left 
										TextLabel.ZIndex = 6 

										Button.MouseButton1Down:Connect(function() 
											Drop.Visible = false 
											Drop.CanvasPosition = Vec2(0,0) 
											abcd.Text = v 
											for i,v in pairs(Scroll.Parent:GetChildren()) do 
												if v:IsA("Frame") then 
													v.Visible = false 
												end 
											end 
											Element.value.Dropdown = v 
											Scroll.Visible = true 
											callback(Element.value) 
										end) 
										Button.MouseEnter:Connect(function() 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 =  COL3RGB(255, 255, 255)}) 
										end) 
										Button.MouseLeave:Connect(function() 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 =  COL3RGB(255, 255, 255)}) 
										end) 

										if first then 
											abcd.Text = v 
											Element.value.Dropdown = v 
										end 
										local Frame = INST("ScrollingFrame") 
										local UIListLayout = INST("UIListLayout") 

										Scroll.Name = "Scroll" 
										Scroll.Parent = Dropdown 
										Scroll.BackgroundColor3 = COL3RGB(255, 255, 255) 
										Scroll.BackgroundTransparency = 1.000 
										Scroll.Position = UDIM2(0, 0, 0, 0) 
										Scroll.Size = UDIM2(1, 0, 0, amount * 16 + 8) 
										Scroll.Visible = first 
										Scroll.Name = v 

										Frame.Name = "Frame" 
										Frame.Parent = Scroll 
										Frame.Active = true 
										Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Frame.BorderColor3 = COL3RGB(57, 57, 68) 
										Frame.Position = UDIM2(0, 30, 0, 40) 
										Frame.Size = UDIM2(0, 175, 0, 16 * amount) 
										Frame.BottomImage = "http://www.roblox.com/asset/?id=6724808282" 
										Frame.CanvasSize = UDIM2(0, 0, 0, 0) 
										Frame.MidImage = "http://www.roblox.com/asset/?id=6724808282" 
										Frame.ScrollBarThickness = 4 
										Frame.TopImage = "http://www.roblox.com/asset/?id=6724808282" 
										Frame.AutomaticCanvasSize = "Y" 
										Frame.ScrollBarImageColor3 = COL3RGB(172, 208, 255) 

										UIListLayout.Parent = Frame 
										UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
										UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 
										local joll = true 
										for i,v in ipairs(joe2) do 
											local Button = INST("TextButton") 
											local TextLabel = INST("TextLabel") 

											Button.Name = v 
											Button.Parent = Frame 
											Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
											Button.BorderColor3 = COL3RGB(57, 57, 68) 
											Button.BorderSizePixel = 0 
											Button.Position = UDIM2(0, 30, 0, 16) 
											Button.Size = UDIM2(1, 0, 0, 16) 
											Button.AutoButtonColor = false 
											Button.Font = Enum.Font.SourceSans 
											Button.Text = "" 
											Button.TextColor3 = COL3RGB(0, 0, 0) 
											Button.TextSize = 11.000

											TextLabel.Parent = Button 
											TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
											TextLabel.BackgroundTransparency = 1.000 
											TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
											TextLabel.Position = UDIM2(0, 4, 0, -1) 
											TextLabel.Size = UDIM2(1, 1, 1, 1) 
											TextLabel.Font = Enum.Font.Gotham 
											TextLabel.Text = v 
											TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
											TextLabel.TextSize = 11.000
											TextLabel.TextXAlignment = Enum.TextXAlignment.Left 
											if joll then 
												joll = false 
												TextLabel.TextColor3 = COL3RGB(172, 208, 255) 
											end 

											Button.MouseButton1Down:Connect(function() 

												for i,v in pairs(Frame:GetChildren()) do 
													if v:IsA("TextButton") then 
														library:Tween(v.TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
													end 
												end 

												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 

												Element.value.Scroll[joell] = v 

												values[tabname][sectorname][text] = Element.value 
												callback(Element.value) 
											end) 
											Button.MouseEnter:Connect(function() 
												if Element.value.Scroll[joell] ~= v then 
													library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
												end 
											end) 
											Button.MouseLeave:Connect(function() 
												if Element.value.Scroll[joell] ~= v then 
													library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
												end 
											end) 
										end 
										first = false 
									end 
								end 

								ImageLabel.Parent = Button 
								ImageLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								ImageLabel.BackgroundTransparency = 1.000 
								ImageLabel.Position = UDIM2(0, 165, 0, 6) 
								ImageLabel.Size = UDIM2(0, 6, 0, 4) 
								ImageLabel.Image = "http://www.roblox.com/asset/?id=9335638990" 

								TextLabel_3.Parent = Dropdown 
								TextLabel_3.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel_3.BackgroundTransparency = 1.000 
								TextLabel_3.Position = UDIM2(0, 17, 0, -1) 
								TextLabel_3.Size = UDIM2(0.111913361, 208, 0.382215232, 0) 
								TextLabel_3.Font = Enum.Font.Gotham 
								TextLabel_3.Text = text 
								TextLabel_3.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel_3.TextSize = 11.000
								TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left 

								Button.MouseButton1Down:Connect(function() 
									Drop.Visible = not Drop.Visible 
									if not Drop.Visible then 
										Drop.CanvasPosition = Vec2(0,0) 
									end 
								end) 
								local indrop = false 
								local ind = false 
								Drop.MouseEnter:Connect(function() 
									indrop = true 
								end) 
								Drop.MouseLeave:Connect(function() 
									indrop = false 
								end) 
								Button.MouseEnter:Connect(function() 
									ind = true 
								end) 
								Button.MouseLeave:Connect(function() 
									ind = false 
								end) 
								game:GetService("UserInputService").InputBegan:Connect(function(input) 
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
										if Drop.Visible == true and not indrop and not ind then 
											Drop.Visible = false 
											Drop.CanvasPosition = Vec2(0,0) 
										end 
									end 
								end) 

								function Element:SetValue(tbl) 
									Element.value = tbl 
									abcd.Text = tbl.Dropdown 
									values[tabname][sectorname][text] = Element.value 
									for i,v in pairs(Dropdown:GetChildren()) do 
										if v:IsA("Frame") then 
											if v.Name == Element.value.Dropdown then 
												v.Visible = true 
											else 
												v.Visible = false 
											end 
											for _,bad in pairs(v.Frame:GetChildren()) do 
												if bad:IsA("TextButton") then 
													bad.TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
													if bad.Name == Element.value.Scroll[v.Name] then 
														bad.TextLabel.TextColor3 = COL3RGB(172, 208, 255) 
													end 
												end 
											end 
										end 
									end 
								end 

								if data.default then 
									Element:SetValue(data.default) 
								end 

								values[tabname][sectorname][text] = Element.value 

							elseif type == "Scroll" then 
								local amount = data.Amount or 6 
								Section.Size = Section.Size + UDIM2(0,0,0,amount * 16 + 8) 
								if data.alphabet then 
									TBLSORT(data.options, function(a,b) 
										return a < b 
									end) 
								end 
								Element.value = {Scroll = data.default and data.default.Scroll or data.options[1]} 

								local Scroll = INST("Frame") 
								local Frame = INST("ScrollingFrame") 
								local UIListLayout = INST("UIListLayout") 

								Scroll.Name = "Scroll" 
								Scroll.Parent = Inner 
								Scroll.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Scroll.BackgroundTransparency = 1.000 
								Scroll.Position = UDIM2(0, 0, 00, 0) 
								Scroll.Size = UDIM2(1, 0, 0, amount * 16 + 8) 


								Frame.Name = "Frame" 
								Frame.Parent = Scroll 
								Frame.Active = true 
								Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Frame.BorderColor3 = COL3RGB(57, 57, 68) 
								Frame.Position = UDIM2(0, 30, 0, 0) 
								Frame.Size = UDIM2(0, 175, 0, 16 * amount) 
								Frame.BottomImage = "http://www.roblox.com/asset/?id=6724808282" 
								Frame.CanvasSize = UDIM2(0, 0, 0, 0) 
								Frame.MidImage = "http://www.roblox.com/asset/?id=6724808282" 
								Frame.ScrollBarThickness = 4 
								Frame.TopImage = "http://www.roblox.com/asset/?id=6724808282" 
								Frame.AutomaticCanvasSize = "Y" 
								Frame.ScrollBarImageColor3 = COL3RGB(172, 208, 255) 

								UIListLayout.Parent = Frame 
								UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
								UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 
								local first = true 
								for i,v in ipairs(data.options) do 
									local Button = INST("TextButton") 
									local TextLabel = INST("TextLabel") 

									Button.Name = v 
									Button.Parent = Frame 
									Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Button.BorderColor3 = COL3RGB(57, 57, 68) 
									Button.BorderSizePixel = 0 
									Button.Position = UDIM2(0, 30, 0, 16) 
									Button.Size = UDIM2(1, 0, 0, 16) 
									Button.AutoButtonColor = false 
									Button.Font = Enum.Font.SourceSans 
									Button.Text = "" 
									Button.TextColor3 = COL3RGB(0, 0, 0) 
									Button.TextSize = 11.000

									TextLabel.Parent = Button 
									TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
									TextLabel.BackgroundTransparency = 1.000 
									TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
									TextLabel.Position = UDIM2(0, 4, 0, -1) 
									TextLabel.Size = UDIM2(1, 1, 1, 1) 
									TextLabel.Font = Enum.Font.Gotham 
									TextLabel.Text = v 
									TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
									TextLabel.TextSize = 11.000
									TextLabel.TextXAlignment = Enum.TextXAlignment.Left 
									if first then first = false 
										TextLabel.TextColor3 = COL3RGB(172, 208, 255) 
									end 

									Button.MouseButton1Down:Connect(function() 

										for i,v in pairs(Frame:GetChildren()) do 
											if v:IsA("TextButton") then 
												library:Tween(v.TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											end 
										end 

										library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 

										Element.value.Scroll = v 

										values[tabname][sectorname][text] = Element.value 
										callback(Element.value) 
									end) 
									Button.MouseEnter:Connect(function() 
										if Element.value.Scroll ~= v then 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										end 
									end) 
									Button.MouseLeave:Connect(function() 
										if Element.value.Scroll ~= v then 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										end 
									end) 
								end 

								function Element:SetValue(val) 
									Element.value = val 

									for i,v in pairs(Frame:GetChildren()) do 
										if v:IsA("TextButton") then 
											library:Tween(v.TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										end 
									end 

									library:Tween(Frame[Element.value.Scroll].TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
								end 
								values[tabname][sectorname][text] = Element.value 
							elseif type == "Jumbobox" then 
								Section.Size = Section.Size + UDIM2(0,0,0,39) 
								Element.value = {Jumbobox = {}} 
								data.options = data.options or {} 

								local Dropdown = INST("Frame") 
								local Button = INST("TextButton") 
								local TextLabel = INST("TextLabel") 
								local Drop = INST("ScrollingFrame") 
								local Button_2 = INST("TextButton") 
								local TextLabel_2 = INST("TextLabel") 
								local UIListLayout = INST("UIListLayout") 
								local ImageLabel = INST("ImageLabel") 
								local TextLabel_3 = INST("TextLabel") 

								Dropdown.Name = "Dropdown" 
								Dropdown.Parent = Inner 
								Dropdown.BackgroundColor3 = COL3RGB(33, 35, 255) 
								Dropdown.BackgroundTransparency = 1.000 
								Dropdown.Position = UDIM2(0, 0, 0.255102038, 0) 
								Dropdown.Size = UDIM2(1, 0, 0, 39) 

								Button.Name = "Button" 
								Button.Parent = Dropdown 
								Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Button.BorderColor3 = COL3RGB(57, 57, 68) 
								Button.Position = UDIM2(0, 15, 0, 16) 
								Button.Size = UDIM2(0, 175, 0, 17) 
								Button.AutoButtonColor = false 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								TextLabel.Parent = Button 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
								TextLabel.Position = UDIM2(0, 5, 0, 0) 
								TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = "..." 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								local abcd = TextLabel 

								Drop.Name = "Drop" 
								Drop.Parent = Button 
								Drop.Active = true 
								Drop.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Drop.BorderColor3 = COL3RGB(57, 57, 68) 
								Drop.Position = UDIM2(0, 0, 1, 1) 
								Drop.Size = UDIM2(1, 0, 0, 20) 
								Drop.Visible = false 
								Drop.BottomImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.CanvasSize = UDIM2(0, 0, 0, 0) 
								Drop.ScrollBarThickness = 4 
								Drop.TopImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.MidImage = "http://www.roblox.com/asset/?id=6724808282" 
								--Drop.AutomaticCanvasSize = "Y" 
								for i,v in pairs(data.options) do 
									Drop.CanvasSize = Drop.CanvasSize + UDIM2(0, 0, 0, 17) 
								end 
								Drop.ZIndex = 5 
								Drop.ScrollBarImageColor3 = COL3RGB(172, 208, 255) 

								UIListLayout.Parent = Drop 
								UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
								UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 

								values[tabname][sectorname][text] = Element.value 

								local num = #data.options 
								if num > 5 then 
									Drop.Size = UDIM2(1, 0, 0, 85) 
								else 
									Drop.Size = UDIM2(1, 0, 0, 17*num) 
								end 
								local first = true 

								local function updatetext() 
									local old = {} 
									for i,v in ipairs(data.options) do 
										if TBLFIND(Element.value.Jumbobox, v) then 
											INSERT(old, v) 
										else 
										end 
									end 
									local str = "" 


									if #old == 0 then 
										str = "..." 
									else 
										if #old == 1 then 
											str = old[1] 
										else 
											for i,v in ipairs(old) do 
												if i == 1 then 
													str = v 
												else 
													if i > 2 then 
														if i < 4 then 
															str = str..",  ..." 
														end 
													else 
														str = str..",  "..v 
													end 
												end 
											end 
										end 
									end 

									abcd.Text = str 
								end 
								for i,v in ipairs(data.options) do 
									do 
										local Button = INST("TextButton") 
										local TextLabel = INST("TextLabel") 

										Button.Name = v 
										Button.Parent = Drop 
										Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Button.BorderColor3 = COL3RGB(57, 57, 68) 
										Button.Position = UDIM2(0, 15, 0, 16) 
										Button.Size = UDIM2(0, 175, 0, 17) 
										Button.AutoButtonColor = false 
										Button.Font = Enum.Font.SourceSans 
										Button.Text = "" 
										Button.TextColor3 = COL3RGB(0, 0, 0) 
										Button.TextSize = 11.000
										Button.BorderSizePixel = 0 
										Button.ZIndex = 6 

										TextLabel.Parent = Button 
										TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
										TextLabel.BackgroundTransparency = 1.000 
										TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
										TextLabel.Position = UDIM2(0, 5, 0, -1) 
										TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
										TextLabel.Font = Enum.Font.Gotham 
										TextLabel.Text = v 
										TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
										TextLabel.TextSize = 11.000
										TextLabel.TextXAlignment = Enum.TextXAlignment.Left 
										TextLabel.ZIndex = 6 

										Button.MouseButton1Down:Connect(function() 
											if TBLFIND(Element.value.Jumbobox, v) then 
												for i,a in pairs(Element.value.Jumbobox) do 
													if a == v then 
														TBLREMOVE(Element.value.Jumbobox, i) 
													end 
												end 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											else 
												INSERT(Element.value.Jumbobox, v) 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(172, 208, 255)}) 
											end 
											updatetext() 

											values[tabname][sectorname][text] = Element.value 
											callback(Element.value) 
										end) 
										Button.MouseEnter:Connect(function() 
											if not TBLFIND(Element.value.Jumbobox, v) then 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											end 
										end) 
										Button.MouseLeave:Connect(function() 
											if not TBLFIND(Element.value.Jumbobox, v) then 
												library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
											end 
										end) 

										first = false 
									end 
								end 
								function Element:SetValue(val) 
									Element.value = val 
									for i,v in pairs(Drop:GetChildren()) do 
										if v.Name ~= "UIListLayout" then 
											if TBLFIND(val.Jumbobox, v.Name) then 
												v.TextLabel.TextColor3 = COL3RGB(172, 208, 255) 
											else 
												v.TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
											end 
										end 
									end 
									updatetext() 
									values[tabname][sectorname][text] = Element.value 
									callback(val) 
								end 
								if data.default then 
									Element:SetValue(data.default) 
								end 

								ImageLabel.Parent = Button 
								ImageLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								ImageLabel.BackgroundTransparency = 1.000 
								ImageLabel.Position = UDIM2(0, 165, 0, 6) 
								ImageLabel.Size = UDIM2(0, 6, 0, 4) 
								ImageLabel.Image = "http://www.roblox.com/asset/?id=9335638990" 

								TextLabel_3.Parent = Dropdown 
								TextLabel_3.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel_3.BackgroundTransparency = 1.000 
								TextLabel_3.Position = UDIM2(0, 17, 0, -1) 
								TextLabel_3.Size = UDIM2(0.111913361, 208, 0.382215232, 0) 
								TextLabel_3.Font = Enum.Font.Gotham 
								TextLabel_3.Text = text 
								TextLabel_3.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel_3.TextSize = 11.000
								TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left 

								Button.MouseButton1Down:Connect(function() 
									Drop.Visible = not Drop.Visible 
									if not Drop.Visible then 
										Drop.CanvasPosition = Vec2(0,0) 
									end 
								end) 
								local indrop = false 
								local ind = false 
								Drop.MouseEnter:Connect(function() 
									indrop = true 
								end) 
								Drop.MouseLeave:Connect(function() 
									indrop = false 
								end) 
								Button.MouseEnter:Connect(function() 
									ind = true 
								end) 
								Button.MouseLeave:Connect(function() 
									ind = false 
								end) 
								game:GetService("UserInputService").InputBegan:Connect(function(input) 
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
										if Drop.Visible == true and not indrop and not ind then 
											Drop.Visible = false 
											Drop.CanvasPosition = Vec2(0,0) 
										end 
									end 
								end) 
							elseif type == "ToggleKeybind" then 
								Section.Size = Section.Size + UDIM2(0,0,0,16) 
								Element.value = {Toggle = data.default and data.default.Toggle or false, Key, Type = "Always", Active = true} 

								local Toggle = INST("Frame") 
								local Button = INST("TextButton") 
								local Color = INST("Frame") 
								local TextLabel = INST("TextLabel") 

								Toggle.Name = "Toggle" 
								Toggle.Parent = Inner 
								Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Toggle.BackgroundTransparency = 1.000 
								Toggle.Size = UDIM2(1, 0, 0, 15) 

								Button.Name = "Button" 
								Button.Parent = Toggle 
								Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Button.BackgroundTransparency = 1.000 
								Button.Size = UDIM2(1, 0, 1, 0) 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								Color.Name = "Color" 
								Color.Parent = Button 
								Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Color.BorderColor3 = COL3RGB(57, 57, 68) 
								Color.Position = UDIM2(0, 15, 0.5, -5) 
								Color.Size = UDIM2(0, 8, 0, 8) 
								local binding = false 
								TextLabel.Parent = Button 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.Position = UDIM2(0, 32, 0, -1) 
								TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = text 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								local function update() 
									game:GetService('RunService').RenderStepped:Connect(function()
										if Element.value.Toggle then
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										else 
											keybindremove(text) 
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										end 
									end)
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
								end 

								Button.MouseButton1Down:Connect(function() 
									if not binding then 
										Element.value.Toggle = not Element.value.Toggle 
										update() 
										values[tabname][sectorname][text] = Element.value 
										callback(Element.value) 
									end 
								end) 
								if data.default then 
									update() 
								end 
								values[tabname][sectorname][text] = Element.value 
								do 
									local Keybind = INST("TextButton") 
									local Frame = INST("Frame") 
									local Always = INST("TextButton") 
									local UIListLayout = INST("UIListLayout") 
									local Hold = INST("TextButton") 
									local Toggle = INST("TextButton") 

									Keybind.Name = "Keybind" 
									Keybind.Parent = Button 
									Keybind.BackgroundColor3 = COL3RGB(31, 31, 31) 
									Keybind.BackgroundTransparency = 1.000 
									Keybind.BorderColor3 = COL3RGB(57, 57, 68) 
									Keybind.Position = UDIM2(0, 235, 0.5, -6) 
									Keybind.Text = "-" 
									Keybind.Size = UDIM2(0, 43, 0, 12) 
									Keybind.Size = UDIM2(0,txt:GetTextSize("-", 14, Enum.Font.Gotham, Vec2(700, 12)).X + 5,0, 12) 
									Keybind.AutoButtonColor = false 
									Keybind.Font = Enum.Font.Gotham 
									Keybind.TextColor3 = COL3RGB(255, 255, 255) 
									Keybind.TextSize = 11.000
									Keybind.AnchorPoint = Vec2(1,0) 
									Keybind.ZIndex = 3 

									Frame.Parent = Keybind 
									Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Frame.BorderColor3 = COL3RGB(57, 57, 68) 
									Frame.Position = UDIM2(1, -49, 0, 1) 
									Frame.Size = UDIM2(0, 49, 0, 49) 
									Frame.Visible = false 
									Frame.ZIndex = 3 

									Always.Name = "Always" 
									Always.Parent = Frame 
									Always.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Always.BackgroundTransparency = 1.000 
									Always.BorderColor3 = COL3RGB(57, 57, 68) 
									Always.Position = UDIM2(-3.03289485, 231, 0.115384616, -6) 
									Always.Size = UDIM2(1, 0, 0, 16) 
									Always.AutoButtonColor = false 
									Always.Font = Enum.Font.SourceSansBold 
									Always.Text = "Always" 
									Always.TextColor3 = COL3RGB(173, 24, 72) 
									Always.TextSize = 11.000
									Always.ZIndex = 3 

									UIListLayout.Parent = Frame 
									UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
									UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 

									Hold.Name = "Hold" 
									Hold.Parent = Frame 
									Hold.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Hold.BackgroundTransparency = 1.000 
									Hold.BorderColor3 = COL3RGB(57, 57, 68) 
									Hold.Position = UDIM2(-3.03289485, 231, 0.115384616, -6) 
									Hold.Size = UDIM2(1, 0, 0, 16) 
									Hold.AutoButtonColor = false 
									Hold.Font = Enum.Font.Gotham 
									Hold.Text = "Hold" 
									Hold.TextColor3 = COL3RGB(255, 255, 255) 
									Hold.TextSize = 11.000
									Hold.ZIndex = 3 

									Toggle.Name = "Toggle" 
									Toggle.Parent = Frame 
									Toggle.BackgroundColor3 = COL3RGB(31, 31, 41) 
									Toggle.BackgroundTransparency = 1.000 
									Toggle.BorderColor3 = COL3RGB(57, 57, 68) 
									Toggle.Position = UDIM2(-3.03289485, 231, 0.115384616, -6) 
									Toggle.Size = UDIM2(1, 0, 0, 16) 
									Toggle.AutoButtonColor = false 
									Toggle.Font = Enum.Font.Gotham 
									Toggle.Text = "Toggle" 
									Toggle.TextColor3 = COL3RGB(255, 255, 255) 
									Toggle.TextSize = 11.000
									Toggle.ZIndex = 3 

									for _,button in pairs(Frame:GetChildren()) do 
										if button:IsA("TextButton") then 
											button.MouseButton1Down:Connect(function() 
												Element.value.Type = button.Text 
												Frame.Visible = false 
												if Element.value.Active ~= (Element.value.Type == "Always" and true or false) then 
													Element.value.Active = Element.value.Type == "Always" and true or false 
													callback(Element.value) 
												end 
												if button.Text == "Always" then 
													keybindremove(text) 
												end 
												for _,button in pairs(Frame:GetChildren()) do 
													if button:IsA("TextButton") and button.Text ~= Element.value.Type then 
														button.Font = Enum.Font.Gotham 
														library:Tween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
													end 
												end 
												button.Font = Enum.Font.SourceSansBold 
												button.TextColor3 = COL3RGB(173, 24, 74) 
												values[tabname][sectorname][text] = Element.value 
											end) 
											button.MouseEnter:Connect(function() 
												if Element.value.Type ~= button.Text then 
													library:Tween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255,255,255)}) 
												end 
											end) 
											button.MouseLeave:Connect(function() 
												if Element.value.Type ~= button.Text then 
													library:Tween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
												end 
											end) 
										end 
									end 
									Keybind.MouseButton1Down:Connect(function() 
										if not binding then 
											wait() 
											binding = true 
											Keybind.Text = "..." 
											Keybind.Size = UDIM2(0,txt:GetTextSize("...", 14, Enum.Font.Gotham, Vec2(700, 12)).X + 4,0, 12) 
										end 
									end) 
									Keybind.MouseButton2Down:Connect(function() 
										if not binding then 
											Frame.Visible = not Frame.Visible 
										end 
									end) 
									local Player = game.Players.LocalPlayer 
									local Mouse = Player:GetMouse() 
									local InFrame = false 
									Frame.MouseEnter:Connect(function() 
										InFrame = true 
									end) 
									Frame.MouseLeave:Connect(function() 
										InFrame = false 
									end) 
									local InFrame2 = false 
									Keybind.MouseEnter:Connect(function() 
										InFrame2 = true 
									end) 
									Keybind.MouseLeave:Connect(function() 
										InFrame2 = false 
									end) 
									game:GetService("UserInputService").InputBegan:Connect(function(input) 
										if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 and not binding then 
											if Frame.Visible == true and not InFrame and not InFrame2 then 
												Frame.Visible = false 
											end 
										end 
										if binding then 
											binding = false 
											Keybind.Text = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name:upper() or input.UserInputType.Name:upper() 
											Keybind.Size = UDIM2(0,txt:GetTextSize(Keybind.Text, 14, Enum.Font.Gotham, Vec2(700, 12)).X + 5,0, 12) 
											Element.value.Key = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name 
											if input.KeyCode.Name == "Backspace" then 
												Keybind.Text = "-" 
												Keybind.Size = UDIM2(0,txt:GetTextSize(Keybind.Text, 14, Enum.Font.Gotham, Vec2(700, 12)).X + 4,0, 12) 
												Element.value.Key = nil 
												Element.value.Active = true 
											end 
											callback(Element.value) 
										else 
											if Element.value.Key ~= nil then 
												if FIND(Element.value.Key, "Mouse") then 
													if input.UserInputType == Enum.UserInputType[Element.value.Key] then 
														if Element.value.Type == "Hold" then 
															Element.value.Active = true 
															callback(Element.value) 
															if Element.value.Active and Element.value.Toggle then 
																keybindhold(text)
															else 
																keybindremove(text) 
															end 
														elseif Element.value.Type == "Toggle" then 
															Element.value.Active = not Element.value.Active 
															callback(Element.value) 
															if Element.value.Active and Element.value.Toggle then 
																keybindadd(text) 
															else 
																keybindremove(text) 
															end 
														end 
													end 
												else 
													if input.KeyCode == Enum.KeyCode[Element.value.Key] then 
														if Element.value.Type == "Hold" then 
															Element.value.Active = true 
															callback(Element.value) 
															if Element.value.Active and Element.value.Toggle then 
																keybindhold(text)
															else 
																keybindremove(text) 
															end 
														elseif Element.value.Type == "Toggle" then 
															Element.value.Active = not Element.value.Active 
															callback(Element.value) 
															if Element.value.Active and Element.value.Toggle then 
																keybindadd(text) 
															else 
																keybindremove(text) 
															end 
														end 
													end 
												end 
											else 
												Element.value.Active = true 
											end 
										end 
										values[tabname][sectorname][text] = Element.value 
									end) 
									game:GetService("UserInputService").InputEnded:Connect(function(input) 
										if Element.value.Key ~= nil then 
											if FIND(Element.value.Key, "Mouse") then 
												if input.UserInputType == Enum.UserInputType[Element.value.Key] then 
													if Element.value.Type == "Hold" then 
														Element.value.Active = false 
														callback(Element.value) 
														if Element.value.Active then 
															keybindhold(text)
														else 
															keybindremove(text) 
														end 
													end 
												end 
											else 
												if input.KeyCode == Enum.KeyCode[Element.value.Key] then 
													if Element.value.Type == "Hold" then 
														Element.value.Active = false 
														callback(Element.value) 
														if Element.value.Active then 
															keybindhold(text)
														else 
															keybindremove(text) 
														end 
													end 
												end 
											end 
										end 
										values[tabname][sectorname][text] = Element.value 
									end) 
								end 
								function Element:SetValue(value) 
									Element.value = value 
									update() 
								end 
							elseif type == "Toggle" then 
								Section.Size = Section.Size + UDIM2(0,0,0,16) 
								Element.value = {Toggle = data.default and data.default.Toggle or false} 

								local Toggle = INST("Frame") 
								local Button = INST("TextButton") 
								local Color = INST("Frame") 
								local TextLabel = INST("TextLabel") 

								Toggle.Name = "Toggle" 
								Toggle.Parent = Inner 
								Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Toggle.BackgroundTransparency = 1.000 
								Toggle.Size = UDIM2(1, 0, 0, 15) 

								Button.Name = "Button" 
								Button.Parent = Toggle 
								Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Button.BackgroundTransparency = 1.000 
								Button.Size = UDIM2(1, 0, 1, 0) 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								Color.Name = "Color" 
								Color.Parent = Button 
								Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Color.BorderColor3 = COL3RGB(57, 57, 68) 
								Color.Position = UDIM2(0, 15, 0.5, -5) 
								Color.Size = UDIM2(0, 8, 0, 8) 

								TextLabel.Parent = Button 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.Position = UDIM2(0, 32, 0, -1) 
								TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = text 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								local function update() 
									game:GetService('RunService').RenderStepped:Connect(function()
										if Element.value.Toggle then 
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										else 
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										end 
									end)
									values[tabname][sectorname][text] = Element.value 
								end 

								Button.MouseButton1Down:Connect(function() 
									Element.value.Toggle = not Element.value.Toggle 
									update() 
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
								end) 
								if data.default then 
									update() 
								end 
								values[tabname][sectorname][text] = Element.value 
								function Element:SetValue(value) 
									Element.value = value 
									values[tabname][sectorname][text] = Element.value 
									update() 
									callback(Element.value) 
								end 
							elseif type == "ToggleColor" then 
								Section.Size = Section.Size + UDIM2(0,0,0,16) 
								Element.value = {Toggle = data.default and data.default.Toggle or false, Color = data.default and data.default.Color or COL3RGB(255,255,255)} 

								local Toggle = INST("Frame") 
								local Button = INST("TextButton") 
								local Color = INST("Frame") 
								local TextLabel = INST("TextLabel") 

								Toggle.Name = "Toggle" 
								Toggle.Parent = Inner 
								Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Toggle.BackgroundTransparency = 1.000 
								Toggle.Size = UDIM2(1, 0, 0, 15) 

								Button.Name = "Button" 
								Button.Parent = Toggle 
								Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Button.BackgroundTransparency = 1.000 
								Button.Size = UDIM2(1, 0, 1, 0) 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								Color.Name = "Color" 
								Color.Parent = Button 
								Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Color.BorderColor3 = COL3RGB(57, 57, 68) 
								Color.Position = UDIM2(0, 15, 0.5, -5) 
								Color.Size = UDIM2(0, 8, 0, 8) 

								TextLabel.Parent = Button 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.Position = UDIM2(0, 32, 0, -1) 
								TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = text 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								local function update() 
									game:GetService('RunService').RenderStepped:Connect(function()
										if Element.value.Toggle then 
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										else 
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										end 
									end)
									values[tabname][sectorname][text] = Element.value 
								end 

								local ColorH,ColorS,ColorV 

								local ColorP = INST("TextButton") 
								local Frame = INST("Frame") 
								local Colorpick = INST("ImageButton") 
								local ColorDrag = INST("Frame") 
								local Huepick = INST("ImageButton") 
								local Huedrag = INST("Frame") 

								ColorP.Name = "ColorP" 
								ColorP.Parent = Button 
								ColorP.AnchorPoint = Vec2(1, 0) 
								ColorP.BackgroundColor3 = COL3RGB(255, 0, 0) 
								ColorP.BorderColor3 = COL3RGB(57, 57, 68) 
								ColorP.Position = UDIM2(0, 235, 0.5, -4) 
								ColorP.Size = UDIM2(0, 18, 0, 8) 
								ColorP.AutoButtonColor = false 
								ColorP.Font = Enum.Font.Gotham 
								ColorP.Text = "" 
								ColorP.TextColor3 = COL3RGB(255, 255, 255) 
								ColorP.TextSize = 11.000

								Frame.Parent = ColorP 
								Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Frame.BorderColor3 = COL3RGB(57, 57, 68) 
								Frame.Position = UDIM2(-0.666666687, -170, 1.375, 0) 
								Frame.Size = UDIM2(0, 200, 0, 170) 
								Frame.Visible = false 
								Frame.ZIndex = 3 

								Colorpick.Name = "Colorpick" 
								Colorpick.Parent = Frame 
								Colorpick.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Colorpick.BorderColor3 = COL3RGB(57, 57, 68) 
								Colorpick.ClipsDescendants = false 
								Colorpick.Position = UDIM2(0, 40, 0, 10) 
								Colorpick.Size = UDIM2(0, 150, 0, 150) 
								Colorpick.AutoButtonColor = false 
								Colorpick.Image = "rbxassetid://4155801252" 
								Colorpick.ImageColor3 = COL3RGB(255, 0, 0) 
								Colorpick.ZIndex = 3 

								ColorDrag.Name = "ColorDrag" 
								ColorDrag.Parent = Colorpick 
								ColorDrag.AnchorPoint = Vec2(0.5, 0.5) 
								ColorDrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
								ColorDrag.BorderColor3 = COL3RGB(57, 57, 68) 
								ColorDrag.Size = UDIM2(0, 4, 0, 4) 
								ColorDrag.ZIndex = 3 

								Huepick.Name = "Huepick" 
								Huepick.Parent = Frame 
								Huepick.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Huepick.BorderColor3 = COL3RGB(57, 57, 68) 
								Huepick.ClipsDescendants = false 
								Huepick.Position = UDIM2(0, 10, 0, 10) 
								Huepick.Size = UDIM2(0, 20, 0, 150) 
								Huepick.AutoButtonColor = false 
								Huepick.Image = "rbxassetid://3641079629" 
								Huepick.ImageColor3 = COL3RGB(255, 0, 0) 
								Huepick.ImageTransparency = 1 
								Huepick.BackgroundTransparency = 0 
								Huepick.ZIndex = 3 

								local HueFrameGradient = INST("UIGradient") 
								HueFrameGradient.Rotation = 90 
								HueFrameGradient.Name = "HueFrameGradient" 
								HueFrameGradient.Parent = Huepick 
								HueFrameGradient.Color = ColorSequence.new { 
									ColorSequenceKeypoint.new(0.00, COL3RGB(255, 0, 0)), 
									ColorSequenceKeypoint.new(0.17, COL3RGB(255, 0, 255)), 
									ColorSequenceKeypoint.new(0.33, COL3RGB(0, 0, 255)), 
									ColorSequenceKeypoint.new(0.50, COL3RGB(0, 255, 255)), 
									ColorSequenceKeypoint.new(0.67, COL3RGB(0, 255, 0)), 
									ColorSequenceKeypoint.new(0.83, COL3RGB(255, 255, 0)), 
									ColorSequenceKeypoint.new(1.00, COL3RGB(255, 0, 0)) 
								}	 

								Huedrag.Name = "Huedrag" 
								Huedrag.Parent = Huepick 
								Huedrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Huedrag.BorderColor3 = COL3RGB(57, 57, 68) 
								Huedrag.Size = UDIM2(1, 0, 0, 2) 
								Huedrag.ZIndex = 3 

								ColorP.MouseButton1Down:Connect(function() 
									Frame.Visible = not Frame.Visible 
								end) 
								local abc = false 
								local inCP = false 
								ColorP.MouseEnter:Connect(function() 
									abc = true 
								end) 
								ColorP.MouseLeave:Connect(function() 
									abc = false 
								end) 
								Frame.MouseEnter:Connect(function() 
									inCP = true 
								end) 
								Frame.MouseLeave:Connect(function() 
									inCP = false 
								end) 

								ColorH = (CLAMP(Huedrag.AbsolutePosition.Y-Huepick.AbsolutePosition.Y, 0, Huepick.AbsoluteSize.Y)/Huepick.AbsoluteSize.Y) 
								ColorS = 1-(CLAMP(ColorDrag.AbsolutePosition.X-Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
								ColorV = 1-(CLAMP(ColorDrag.AbsolutePosition.Y-Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 

								if data.default and data.default.Color ~= nil then 
									ColorH, ColorS, ColorV = data.default.Color:ToHSV() 

									ColorH = CLAMP(ColorH,0,1) 
									ColorS = CLAMP(ColorS,0,1) 
									ColorV = CLAMP(ColorV,0,1) 
									ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 

									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 

									values[tabname][sectorname][text] = data.default.Color 
								end 

								local mouse = LocalPlayer:GetMouse() 
								game:GetService("UserInputService").InputBegan:Connect(function(input) 
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
										if not dragging and not abc and not inCP then 
											Frame.Visible = false 
										end 
									end 
								end) 

								local function updateColor() 
									local ColorX = (CLAMP(mouse.X - Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
									local ColorY = (CLAMP(mouse.Y - Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 
									ColorDrag.Position = UDIM2(ColorX, 0, ColorY, 0) 
									ColorS = 1-ColorX 
									ColorV = 1-ColorY 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									values[tabname][sectorname][text] = Element.value 
									Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
									callback(Element.value) 
								end 
								local function updateHue() 
									local y = CLAMP(mouse.Y - Huepick.AbsolutePosition.Y, 0, 148) 
									Huedrag.Position = UDIM2(0, 0, 0, y) 
									hue = y/148 
									ColorH = 1-hue 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									values[tabname][sectorname][text] = Element.value 
									Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
									callback(Element.value) 
								end 
								Colorpick.MouseButton1Down:Connect(function() 
									updateColor() 
									moveconnection = mouse.Move:Connect(function() 
										updateColor() 
									end) 
									releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
										if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
											updateColor() 
											moveconnection:Disconnect() 
											releaseconnection:Disconnect() 
										end 
									end) 
								end) 
								Huepick.MouseButton1Down:Connect(function() 
									updateHue() 
									moveconnection = mouse.Move:Connect(function() 
										updateHue() 
									end) 
									releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
										if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
											updateHue() 
											moveconnection:Disconnect() 
											releaseconnection:Disconnect() 
										end 
									end) 
								end) 

								Button.MouseButton1Down:Connect(function() 
									Element.value.Toggle = not Element.value.Toggle 
									update() 
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
								end) 
								if data.default then 
									update() 
								end 
								values[tabname][sectorname][text] = Element.value 
								function Element:SetValue(value) 
									Element.value = value 
									local duplicate = COL3(value.Color.R, value.Color.G, value.Color.B) 
									ColorH, ColorS, ColorV = duplicate:ToHSV() 
									ColorH = CLAMP(ColorH,0,1) 
									ColorS = CLAMP(ColorS,0,1) 
									ColorV = CLAMP(ColorV,0,1) 

									ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									update() 
									Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 

									callback(value) 
								end 
							elseif type == "ToggleTrans" then 
								Section.Size = Section.Size + UDIM2(0,0,0,16) 
								Element.value = {Toggle = data.default and data.default.Toggle or false, Color = data.default and data.default.Color or COL3RGB(255,255,255), Transparency = data.default and data.default.Transparency or 0} 

								local Toggle = INST("Frame") 
								local Button = INST("TextButton") 
								local Color = INST("Frame") 
								local TextLabel = INST("TextLabel") 

								Toggle.Name = "Toggle" 
								Toggle.Parent = Inner 
								Toggle.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Toggle.BackgroundTransparency = 1.000 
								Toggle.Size = UDIM2(1, 0, 0, 15) 

								Button.Name = "Button" 
								Button.Parent = Toggle 
								Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Button.BackgroundTransparency = 1.000 
								Button.Size = UDIM2(1, 0, 1, 0) 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								Color.Name = "Color" 
								Color.Parent = Button 
								Color.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Color.BorderColor3 = COL3RGB(57, 57, 68) 
								Color.Position = UDIM2(0, 15, 0.5, -5) 
								Color.Size = UDIM2(0, 8, 0, 8) 

								TextLabel.Parent = Button 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.Position = UDIM2(0, 32, 0, -1) 
								TextLabel.Size = UDIM2(0.111913361, 208, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = text 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								local function update() 
									game:GetService('RunService').RenderStepped:Connect(function()
										if Element.value.Toggle then 
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.accent}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										else 
											tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
										end
									end)
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
								end 

								local ColorH,ColorS,ColorV 

								local ColorP = INST("TextButton") 
								local Frame = INST("Frame") 
								local Colorpick = INST("ImageButton") 
								local ColorDrag = INST("Frame") 
								local Huepick = INST("ImageButton") 
								local Huedrag = INST("Frame") 

								ColorP.Name = "ColorP" 
								ColorP.Parent = Button 
								ColorP.AnchorPoint = Vec2(1, 0) 
								ColorP.BackgroundColor3 = COL3RGB(255, 0, 0) 
								ColorP.BorderColor3 = COL3RGB(57, 57, 68) 
								ColorP.Position = UDIM2(0, 235, 0.5, -4) 
								ColorP.Size = UDIM2(0, 18, 0, 8) 
								ColorP.AutoButtonColor = false 
								ColorP.Font = Enum.Font.Gotham 
								ColorP.Text = "" 
								ColorP.TextColor3 = COL3RGB(255, 255, 255) 
								ColorP.TextSize = 11.000

								Frame.Parent = ColorP 
								Frame.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Frame.BorderColor3 = COL3RGB(57, 57, 68) 
								Frame.Position = UDIM2(-0.666666687, -170, 1.375, 0) 
								Frame.Size = UDIM2(0, 200, 0, 190) 
								Frame.Visible = false 
								Frame.ZIndex = 3 

								Colorpick.Name = "Colorpick" 
								Colorpick.Parent = Frame 
								Colorpick.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Colorpick.BorderColor3 = COL3RGB(57, 57, 68) 
								Colorpick.ClipsDescendants = false 
								Colorpick.Position = UDIM2(0, 40, 0, 10) 
								Colorpick.Size = UDIM2(0, 150, 0, 150) 
								Colorpick.AutoButtonColor = false 
								Colorpick.Image = "rbxassetid://4155801252" 
								Colorpick.ImageColor3 = COL3RGB(255, 0, 0) 
								Colorpick.ZIndex = 3 

								ColorDrag.Name = "ColorDrag" 
								ColorDrag.Parent = Colorpick 
								ColorDrag.AnchorPoint = Vec2(0.5, 0.5) 
								ColorDrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
								ColorDrag.BorderColor3 = COL3RGB(57, 57, 68) 
								ColorDrag.Size = UDIM2(0, 4, 0, 4) 
								ColorDrag.ZIndex = 3 

								Huepick.Name = "Huepick" 
								Huepick.Parent = Frame 
								Huepick.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Huepick.BorderColor3 = COL3RGB(57, 57, 68) 
								Huepick.ClipsDescendants = true 
								Huepick.Position = UDIM2(0, 10, 0, 10) 
								Huepick.Size = UDIM2(0, 20, 0, 150) 
								Huepick.AutoButtonColor = false 
								Huepick.Image = "rbxassetid://3641079629" 
								Huepick.ImageColor3 = COL3RGB(255, 0, 0) 
								Huepick.ImageTransparency = 1 
								Huepick.BackgroundTransparency = 0 
								Huepick.ZIndex = 3 

								local HueFrameGradient = INST("UIGradient") 
								HueFrameGradient.Rotation = 90 
								HueFrameGradient.Name = "HueFrameGradient" 
								HueFrameGradient.Parent = Huepick 
								HueFrameGradient.Color = ColorSequence.new { 
									ColorSequenceKeypoint.new(0.00, COL3RGB(255, 0, 0)), 
									ColorSequenceKeypoint.new(0.17, COL3RGB(255, 0, 255)), 
									ColorSequenceKeypoint.new(0.33, COL3RGB(0, 0, 255)), 
									ColorSequenceKeypoint.new(0.50, COL3RGB(0, 255, 255)), 
									ColorSequenceKeypoint.new(0.67, COL3RGB(0, 255, 0)), 
									ColorSequenceKeypoint.new(0.83, COL3RGB(255, 255, 0)), 
									ColorSequenceKeypoint.new(1.00, COL3RGB(255, 0, 0)) 
								}	 

								Huedrag.Name = "Huedrag" 
								Huedrag.Parent = Huepick 
								Huedrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Huedrag.BorderColor3 = COL3RGB(57, 57, 68) 
								Huedrag.Size = UDIM2(1, 0, 0, 2) 
								Huedrag.ZIndex = 3 

								local Transpick = INST("ImageButton") 
								local Transcolor = INST("ImageLabel") 
								local Transdrag = INST("Frame") 

								Transpick.Name = "Transpick" 
								Transpick.Parent = Frame 
								Transpick.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Transpick.BorderColor3 = COL3RGB(57, 57, 68) 
								Transpick.Position = UDIM2(0, 10, 0, 167) 
								Transpick.Size = UDIM2(0, 180, 0, 15) 
								Transpick.AutoButtonColor = false 
								Transpick.Image = "rbxassetid://3887014957" 
								Transpick.ScaleType = Enum.ScaleType.Tile 
								Transpick.TileSize = UDIM2(0, 10, 0, 10) 
								Transpick.ZIndex = 3 

								Transcolor.Name = "Transcolor" 
								Transcolor.Parent = Transpick 
								Transcolor.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Transcolor.BackgroundTransparency = 1.000 
								Transcolor.Size = UDIM2(1, 0, 1, 0) 
								Transcolor.Image = "rbxassetid://3887017050" 
								Transcolor.ImageColor3 = COL3RGB(255, 0, 4) 
								Transcolor.ZIndex = 3 

								Transdrag.Name = "Transdrag" 
								Transdrag.Parent = Transcolor 
								Transdrag.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Transdrag.BorderColor3 = COL3RGB(57, 57, 68) 
								Transdrag.Position = UDIM2(0, -1, 0, 0) 
								Transdrag.Size = UDIM2(0, 2, 1, 0) 
								Transdrag.ZIndex = 3 

								ColorP.MouseButton1Down:Connect(function() 
									Frame.Visible = not Frame.Visible 
								end) 
								local abc = false 
								local inCP = false 
								ColorP.MouseEnter:Connect(function() 
									abc = true 
								end) 
								ColorP.MouseLeave:Connect(function() 
									abc = false 
								end) 
								Frame.MouseEnter:Connect(function() 
									inCP = true 
								end) 
								Frame.MouseLeave:Connect(function() 
									inCP = false 
								end) 

								ColorH = (CLAMP(Huedrag.AbsolutePosition.Y-Huepick.AbsolutePosition.Y, 0, Huepick.AbsoluteSize.Y)/Huepick.AbsoluteSize.Y) 
								ColorS = 1-(CLAMP(ColorDrag.AbsolutePosition.X-Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
								ColorV = 1-(CLAMP(ColorDrag.AbsolutePosition.Y-Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 

								if data.default and data.default.Color ~= nil then 
									ColorH, ColorS, ColorV = data.default.Color:ToHSV() 

									ColorH = CLAMP(ColorH,0,1) 
									ColorS = CLAMP(ColorS,0,1) 
									ColorV = CLAMP(ColorV,0,1) 
									ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 

									Transcolor.ImageColor3 = COL3HSV(ColorH, 1, 1) 

									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 
								end 
								if data.default and data.default.Transparency ~= nil then 
									Transdrag.Position = UDIM2(data.default.Transparency, -1, 0, 0) 
								end 
								local mouse = LocalPlayer:GetMouse() 
								game:GetService("UserInputService").InputBegan:Connect(function(input) 
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
										if not dragging and not abc and not inCP then 
											Frame.Visible = false 
										end 
									end 
								end) 

								local function updateColor() 
									local ColorX = (CLAMP(mouse.X - Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X) 
									local ColorY = (CLAMP(mouse.Y - Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y) 
									ColorDrag.Position = UDIM2(ColorX, 0, ColorY, 0) 
									ColorS = 1-ColorX 
									ColorV = 1-ColorY 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									Transcolor.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									values[tabname][sectorname][text] = Element.value 
									Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
									callback(Element.value) 
								end 
								local function updateHue() 
									local y = CLAMP(mouse.Y - Huepick.AbsolutePosition.Y, 0, 148) 
									Huedrag.Position = UDIM2(0, 0, 0, y) 
									hue = y/148 
									ColorH = 1-hue 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									Transcolor.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									values[tabname][sectorname][text] = Element.value 
									Element.value.Color = COL3HSV(ColorH, ColorS, ColorV) 
									callback(Element.value) 
								end 
								local function updateTrans() 
									local x = CLAMP(mouse.X - Transpick.AbsolutePosition.X, 0, 178) 
									Transdrag.Position = UDIM2(0, x, 0, 0) 
									Element.value.Transparency = (x/178) 
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
								end 
								Transpick.MouseButton1Down:Connect(function() 
									updateTrans() 
									moveconnection = mouse.Move:Connect(function() 
										updateTrans() 
									end) 
									releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
										if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
											updateTrans() 
											moveconnection:Disconnect() 
											releaseconnection:Disconnect() 
										end 
									end) 
								end) 
								Colorpick.MouseButton1Down:Connect(function() 
									updateColor() 
									moveconnection = mouse.Move:Connect(function() 
										updateColor() 
									end) 
									releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
										if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
											updateColor() 
											moveconnection:Disconnect() 
											releaseconnection:Disconnect() 
										end 
									end) 
								end) 
								Huepick.MouseButton1Down:Connect(function() 
									updateHue() 
									moveconnection = mouse.Move:Connect(function() 
										updateHue() 
									end) 
									releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(Mouse) 
										if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
											updateHue() 
											moveconnection:Disconnect() 
											releaseconnection:Disconnect() 
										end 
									end) 
								end) 

								Button.MouseButton1Down:Connect(function() 
									Element.value.Toggle = not Element.value.Toggle 
									update() 
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
								end) 
								if data.default then 
									if Element.value.Toggle then 
										tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(172, 208, 255)}) 
										library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
									else 
										tween = library:Tween(Color, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = COL3RGB(31, 31, 41)}) 
										library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
									end 
									values[tabname][sectorname][text] = Element.value 
								end 
								values[tabname][sectorname][text] = Element.value 
								function Element:SetValue(value) 
									Element.value = value 
									local duplicate = COL3(value.Color.R, value.Color.G, value.Color.B) 
									ColorH, ColorS, ColorV = duplicate:ToHSV() 
									ColorH = CLAMP(ColorH,0,1) 
									ColorS = CLAMP(ColorS,0,1) 
									ColorV = CLAMP(ColorV,0,1) 

									ColorDrag.Position = UDIM2(1-ColorS,0,1-ColorV,0) 
									Colorpick.ImageColor3 = COL3HSV(ColorH, 1, 1) 
									ColorP.BackgroundColor3 = COL3HSV(ColorH, ColorS, ColorV) 
									update() 
									Huedrag.Position = UDIM2(0, 0, 1-ColorH, -1) 
								end 
								elseif type == "TextBox" then 
									Section.Size = Section.Size + UDIM2(0,0,0,30) 
									Element.value = {Text = data.default and data.default.text or ""} 

									local Box = INST("Frame") 
									local TextBox = INST("TextBox") 

									Box.Name = "Box"
									Box.Parent = Inner
									Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									Box.BackgroundTransparency = 1.000
									Box.Position = UDim2.new(0, 0, 0.542059898, 0)
									Box.Size = UDim2.new(1, 0, 0, 30)
	
									TextBox.Parent = Box
									TextBox.BackgroundColor3 = Color3.fromRGB(31, 31, 41)
									TextBox.BorderColor3 = Color3.fromRGB(57, 57, 68)
									TextBox.Position = UDim2.new(0.108303241, 0, 0.224465579, 0)
									TextBox.Size = UDim2.new(0, 175, 0, 20)
									TextBox.Font = Enum.Font.Ubuntu
									TextBox.ClearTextOnFocus = false
									TextBox.PlaceholderText = data.placeholder
									TextBox.Text = Element.value.Text
									TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
									TextBox.TextSize = 12.000

									values[tabname][sectorname][text] = Element.value 

									TextBox:GetPropertyChangedSignal("Text"):Connect(function() 
										Element.value.Text = TextBox.Text 
										values[tabname][sectorname][text] = Element.value 
										callback(Element.value) 
									end) 

									function Element:SetValue(value) 
										Element.value = value 
										values[tabname][sectorname][text] = Element.value 
										TextBox.Text = Element.value.Text 
									end 

							elseif type == "Dropdown" then 
								Section.Size = Section.Size + UDIM2(0,0,0,39) 
								Element.value = {Dropdown = data.options[1]} 

								local Dropdown = INST("Frame") 
								local Button = INST("TextButton") 
								local TextLabel = INST("TextLabel") 
								local Drop = INST("ScrollingFrame") 
								local Button_2 = INST("TextButton") 
								local TextLabel_2 = INST("TextLabel") 
								local UIListLayout = INST("UIListLayout") 
								local ImageLabel = INST("ImageLabel") 
								local TextLabel_3 = INST("TextLabel") 

								Dropdown.Name = "Dropdown" 
								Dropdown.Parent = Inner 
								Dropdown.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Dropdown.BackgroundTransparency = 1.000 
								Dropdown.Position = UDIM2(0, 0, 0.255102038, 0) 
								Dropdown.Size = UDIM2(1, 0, 0, 39) 

								Button.Name = "Button" 
								Button.Parent = Dropdown 
								Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Button.BorderColor3 = COL3RGB(57, 57, 68) 
								Button.Position = UDIM2(0, 15, 0, 16) 
								Button.Size = UDIM2(0, 175, 0, 17) 
								Button.AutoButtonColor = false 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								TextLabel.Parent = Button 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
								TextLabel.Position = UDIM2(0, 5, 0, 0) 
								TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = Element.value.Dropdown 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								local abcd = TextLabel 

								Drop.Name = "Drop" 
								Drop.Parent = Button 
								Drop.Active = true 
								Drop.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Drop.BorderColor3 = COL3RGB(57, 57, 68) 
								Drop.Position = UDIM2(0, 0, 1, 1) 
								Drop.Size = UDIM2(1, 0, 0, 20) 
								Drop.Visible = false 
								Drop.BottomImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.CanvasSize = UDIM2(0, 0, 0, 0) 
								Drop.ScrollBarThickness = 4 
								Drop.TopImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.MidImage = "http://www.roblox.com/asset/?id=6724808282" 
								Drop.AutomaticCanvasSize = "Y" 
								Drop.ZIndex = 5 
								Drop.ScrollBarImageColor3 = COL3RGB(172, 208, 255) 

								UIListLayout.Parent = Drop 
								UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center 
								UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder 

								local num = #data.options 
								if num > 5 then 
									Drop.Size = UDIM2(1, 0, 0, 85) 
								else 
									Drop.Size = UDIM2(1, 0, 0, 17*num) 
								end 
								local first = true 
								for i,v in ipairs(data.options) do 
									do 
										local Button = INST("TextButton") 
										local TextLabel = INST("TextLabel") 

										Button.Name = v 
										Button.Parent = Drop 
										Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
										Button.BorderColor3 = COL3RGB(57, 57, 68) 
										Button.Position = UDIM2(0, 15, 0, 16) 
										Button.Size = UDIM2(0, 175, 0, 17) 
										Button.AutoButtonColor = false 
										Button.Font = Enum.Font.SourceSans 
										Button.Text = "" 
										Button.TextColor3 = COL3RGB(0, 0, 0) 
										Button.TextSize = 11.000
										Button.BorderSizePixel = 0 
										Button.ZIndex = 6 

										TextLabel.Parent = Button 
										TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
										TextLabel.BackgroundTransparency = 1.000 
										TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
										TextLabel.Position = UDIM2(0, 5, 0, -1) 
										TextLabel.Size = UDIM2(-0.21714285, 208, 1, 0) 
										TextLabel.Font = Enum.Font.Gotham 
										TextLabel.Text = v 
										TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
										TextLabel.TextSize = 11.000
										TextLabel.TextXAlignment = Enum.TextXAlignment.Left 
										TextLabel.ZIndex = 6 

										Button.MouseButton1Down:Connect(function() 
											Drop.Visible = false 
											Element.value.Dropdown = v 
											abcd.Text = v 
											values[tabname][sectorname][text] = Element.value 
											callback(Element.value) 
											Drop.CanvasPosition = Vec2(0,0) 
										end) 
										Button.MouseEnter:Connect(function() 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 =  COL3RGB(255, 255, 255)}) 
										end) 
										Button.MouseLeave:Connect(function() 
											library:Tween(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 =  COL3RGB(255, 255, 255)}) 
										end) 

										first = false 
									end 
								end 

								function Element:SetValue(val) 
									Element.value = val 
									abcd.Text = val.Dropdown 
									values[tabname][sectorname][text] = Element.value 
									callback(val) 
								end 

								ImageLabel.Parent = Button 
								ImageLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								ImageLabel.BackgroundTransparency = 1.000 
								ImageLabel.Position = UDIM2(0, 165, 0, 6) 
								ImageLabel.Size = UDIM2(0, 6, 0, 4) 
								ImageLabel.Image = "http://www.roblox.com/asset/?id=9335638990" 

								TextLabel_3.Parent = Dropdown 
								TextLabel_3.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel_3.BackgroundTransparency = 1.000 
								TextLabel_3.Position = UDIM2(0, 17, 0, -1) 
								TextLabel_3.Size = UDIM2(0.111913361, 208, 0.382215232, 0) 
								TextLabel_3.Font = Enum.Font.Gotham 
								TextLabel_3.Text = text 
								TextLabel_3.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel_3.TextSize = 11.000
								TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left 

								Button.MouseButton1Down:Connect(function() 
									Drop.Visible = not Drop.Visible 
									if not Drop.Visible then 
										Drop.CanvasPosition = Vec2(0,0) 
									end 
								end) 
								local indrop = false 
								local ind = false 
								Drop.MouseEnter:Connect(function() 
									indrop = true 
								end) 
								Drop.MouseLeave:Connect(function() 
									indrop = false 
								end) 
								Button.MouseEnter:Connect(function() 
									ind = true 
								end) 
								Button.MouseLeave:Connect(function() 
									ind = false 
								end) 
								game:GetService("UserInputService").InputBegan:Connect(function(input) 
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then 
										if Drop.Visible == true and not indrop and not ind then 
											Drop.Visible = false 
											Drop.CanvasPosition = Vec2(0,0) 
										end 
									end 
								end) 
								values[tabname][sectorname][text] = Element.value 
							elseif type == "Slider" then 

								Section.Size = Section.Size + UDIM2(0,0,0,25) 

								local Slider = INST("Frame") 
								local TextLabel = INST("TextLabel") 
								local Button = INST("TextButton") 
								local Frame = INST("Frame") 
								local Value = INST("TextLabel") 

								Slider.Name = "Slider" 
								Slider.Parent = Inner 
								Slider.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Slider.BackgroundTransparency = 1.000 
								Slider.Position = UDIM2(0, 0, 0.653061211, 0) 
								Slider.Size = UDIM2(1, 0, 0, 25) 

								TextLabel.Parent = Slider 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.Position = UDIM2(0, 15, 0, -2) 
								TextLabel.Size = UDIM2(0, 100, 0, 15) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = text 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left 

								Button.Name = "Button" 
								Button.Parent = Slider 
								Button.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Button.BorderColor3 = COL3RGB(57, 57, 68) 
								Button.Position = UDIM2(0, 15, 0, 15) 
								Button.Size = UDIM2(0, 175, 0, 5) 
								Button.AutoButtonColor = false 
								Button.Font = Enum.Font.SourceSans 
								Button.Text = "" 
								Button.TextColor3 = COL3RGB(0, 0, 0) 
								Button.TextSize = 11.000

								Frame.Parent = Button 
								game:GetService('RunService').RenderStepped:Connect(function()
									Frame.BackgroundColor3 = theme.accent
								end)
								Frame.BorderSizePixel = 0 
								Frame.Size = UDIM2(0.5, 0, 1, 0) 

								Value.Name = "Value" 
								Value.Parent = Slider 
								Value.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Value.BackgroundTransparency = 1.000 
								Value.Position = UDim2.new(0, 135, 0, -1)
								Value.Size = UDim2.new(0, 55, 0, 15)
								Value.Font = Enum.Font.Gotham 
								Value.Text = "50" 
								Value.TextStrokeTransparency = 1
								Value.TextColor3 = COL3RGB(255, 255, 255) 
								Value.TextSize = 11.000 
								Value.TextXAlignment = Enum.TextXAlignment.Right
								local min, max, default = data.min or 0, data.max or 100, data.default or 0 
								Element.value = {Slider = default} 

								function Element:SetValue(value) 
									Element.value = value 
									local a 
									if min > 0 then 
										a = ((Element.value.Slider - min)) / (max-min) 
									else 
										a = (Element.value.Slider-min)/(max-min) 
									end 
									Value.Text = Element.value.Slider 
									Frame.Size = UDIM2(a,0,1,0) 
									values[tabname][sectorname][text] = Element.value 
									callback(value) 
								end 
								local a 
								if min > 0 then 
									a = ((Element.value.Slider - min)) / (max-min) 
								else 
									a = (Element.value.Slider-min)/(max-min) 
								end 
								Value.Text = Element.value.Slider 
								Frame.Size = UDIM2(a,0,1,0) 
								values[tabname][sectorname][text] = Element.value 
								local uis = game:GetService("UserInputService") 
								local mouse = game.Players.LocalPlayer:GetMouse() 
								local val 
								Button.MouseButton1Down:Connect(function() 
									Frame.Size = UDIM2(0, CLAMP(mouse.X - Frame.AbsolutePosition.X, 0, 175), 0, 5) 
									val = FLOOR((((tonumber(max) - tonumber(min)) / 175) * Frame.AbsoluteSize.X) + tonumber(min)) or 0 
									Value.Text = val 
									Element.value.Slider = val 
									values[tabname][sectorname][text] = Element.value 
									callback(Element.value) 
									moveconnection = mouse.Move:Connect(function() 
										Frame.Size = UDIM2(0, CLAMP(mouse.X - Frame.AbsolutePosition.X, 0, 175), 0, 5) 
										val = FLOOR((((tonumber(max) - tonumber(min)) / 175) * Frame.AbsoluteSize.X) + tonumber(min)) 
										Value.Text = val 
										Element.value.Slider = val 
										values[tabname][sectorname][text] = Element.value 
										callback(Element.value) 
									end) 
									releaseconnection = uis.InputEnded:Connect(function(Mouse) 
										if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then 
											Frame.Size = UDIM2(0, CLAMP(mouse.X - Frame.AbsolutePosition.X, 0, 175), 0, 5) 
											val = FLOOR((((tonumber(max) - tonumber(min)) / 175) * Frame.AbsoluteSize.X) + tonumber(min)) 
											values[tabname][sectorname][text] = Element.value 
											callback(Element.value) 
											moveconnection:Disconnect() 
											releaseconnection:Disconnect() 
										end 
									end) 
								end) 
							elseif type == "Button" then 

								Section.Size = Section.Size + UDIM2(0,0,0,24) 
								local Button = INST("Frame") 
								local Button_2 = INST("TextButton") 
								local TextLabel = INST("TextLabel") 

								Button.Name = "Button" 
								Button.Parent = Inner 
								Button.BackgroundColor3 = COL3RGB(255, 255, 255) 
								Button.BackgroundTransparency = 1.000 
								Button.Position = UDIM2(0, 0, 0.236059487, 0) 
								Button.Size = UDIM2(1, 0, 0, 24) 

								Button_2.Name = "Button" 
								Button_2.Parent = Button 
								Button_2.BackgroundColor3 = COL3RGB(31, 31, 41) 
								Button_2.BorderColor3 = COL3RGB(57, 57, 68) 
								Button_2.Position = UDIM2(0, 15, 0.5, -9) 
								Button_2.Size = UDIM2(0, 175, 0, 18) 
								Button_2.AutoButtonColor = false 
								Button_2.Font = Enum.Font.SourceSans 
								Button_2.Text = "" 
								Button_2.TextColor3 = COL3RGB(0, 0, 0) 
								Button_2.TextSize = 11.000

								TextLabel.Parent = Button_2 
								TextLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
								TextLabel.BackgroundTransparency = 1.000 
								TextLabel.BorderColor3 = COL3RGB(27, 42, 53) 
								TextLabel.Size = UDIM2(1, 0, 1, 0) 
								TextLabel.Font = Enum.Font.Gotham 
								TextLabel.Text = text 
								TextLabel.TextColor3 = COL3RGB(255, 255, 255) 
								TextLabel.TextSize = 11.000

								function Element:SetValue() 
								end 

								Button_2.MouseButton1Down:Connect(function() 
									TextLabel.TextColor3 = COL3RGB(172, 208, 255) 
									library:Tween(TextLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
									callback() 
								end) 
								Button_2.MouseEnter:Connect(function() 
									library:Tween(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
								end) 
								Button_2.MouseLeave:Connect(function() 
									library:Tween(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = COL3RGB(255, 255, 255)}) 
								end) 
							end 
							ConfigLoad:Connect(function(cfg) 
								pcall(function() 
									local fix = library:ConfigFix(cfg) 
									if fix[tabname][sectorname][text] ~= nil then 
										Element:SetValue(fix[tabname][sectorname][text]) 
									end 
								end) 
							end) 

							return Element 
						end 
				return Sector 
			end 
			return Tab 
		end 

		floppa.Parent = game.CoreGui 
		return menu 
	end 
			local somethings = {
			    killallisworking = false
			}

			local UserInputService = game:GetService("UserInputService") 
			local ReplicatedStorage = game:GetService("ReplicatedStorage") 
			local RunService = game:GetService("RunService") 
			local Lighting = game:GetService("Lighting") 
			local Players = game:GetService("Players") 
			local LocalPlayer = Players.LocalPlayer 
			local PlayerGui = LocalPlayer.PlayerGui 
			local Mouse = LocalPlayer:GetMouse() 
			local Camera = workspace.CurrentCamera 
			local ClientScript = LocalPlayer.PlayerGui.Client 
			local Client = getsenv(ClientScript) 

			repeat RunService.RenderStepped:Wait() until game:IsLoaded() 

			local Crosshairs = PlayerGui.GUI.Crosshairs 
			local Crosshair = PlayerGui.GUI.Crosshairs.Crosshair 
			local oldcreatebullethole = Client.createbullethole 
			local LGlove, RGlove, LSleeve, RSleeve, RArm, LArm 
			local WeaponObj = {} 
			local SelfObj = {} 
			local Viewmodels =  ReplicatedStorage.Viewmodels 
			local Weapons =  ReplicatedStorage.Weapons 
			local ViewmodelOffset = CF(0,0,0) 
			local Smokes = {} 
			local Mollies = {} 
			local RayIgnore = workspace.Ray_Ignore 
			local RageTarget 
			local GetIcon = require(game.ReplicatedStorage.GetIcon) 
			local BodyVelocity = INST("BodyVelocity") 
			BodyVelocity.MaxForce = Vec3(HUGE, 0, HUGE) 
			local Collision = {Camera, workspace.Ray_Ignore, workspace.Debris} 
			local FakelagFolder = INST('Folder', workspace.Camera)
			FakelagFolder.Name = 'Fakelag'
			local FakeAnim = INST("Animation", workspace) 
			FakeAnim.AnimationId = "rbxassetid://0" 
			local Gloves = ReplicatedStorage.Gloves 
			if Gloves:FindFirstChild("ImageLabel") then 
				Gloves.ImageLabel:Destroy() 
			end 
			local GloveModels = Gloves.Models 
			local Multipliers = { 
				["Head"] = 4, 
				["FakeHead"] = 4, 
				["HeadHB"] = 4, 
				["UpperTorso"] = 1, 
				["LowerTorso"] = 1.25, 
				["LeftUpperArm"] = 1, 
				["LeftLowerArm"] = 1, 
				["LeftHand"] = 1, 
				["RightUpperArm"] = 1, 
				["RightLowerArm"] = 1, 
				["RightHand"] = 1, 
				["LeftUpperLeg"] = 0.75, 
				["LeftLowerLeg"] = 0.75, 
				["LeftFoot"] = 0.75, 
				["RightUpperLeg"] = 0.75, 
				["RightLowerLeg"] = 0.75, 
				["RightFoot"] = 0.75, 
			} 
			local ChamItems = {} 
			local Skyboxes = { 
				["nebula"] = { 
					SkyboxLf = "rbxassetid://159454286", 
					SkyboxBk = "rbxassetid://159454299", 
					SkyboxDn = "rbxassetid://159454296", 
					SkyboxFt = "rbxassetid://159454293", 
					SkyboxLf = "rbxassetid://159454286", 
					SkyboxRt = "rbxassetid://159454300", 
					SkyboxUp = "rbxassetid://159454288", 
				}, 
				["vaporwave"] = { 
					SkyboxLf = "rbxassetid://1417494402", 
					SkyboxBk = "rbxassetid://1417494030", 
					SkyboxDn = "rbxassetid://1417494146", 
					SkyboxFt = "rbxassetid://1417494253", 
					SkyboxLf = "rbxassetid://1417494402", 
					SkyboxRt = "rbxassetid://1417494499", 
					SkyboxUp = "rbxassetid://1417494643", 
				}, 
				["clouds"] = { 
					SkyboxLf = "rbxassetid://570557620", 
					SkyboxBk = "rbxassetid://570557514", 
					SkyboxDn = "rbxassetid://570557775", 
					SkyboxFt = "rbxassetid://570557559", 
					SkyboxLf = "rbxassetid://570557620", 
					SkyboxRt = "rbxassetid://570557672", 
					SkyboxUp = "rbxassetid://570557727", 
				}, 
				["twilight"] = { 
					SkyboxLf = "rbxassetid://264909758", 
					SkyboxBk = "rbxassetid://264908339", 
					SkyboxDn = "rbxassetid://264907909", 
					SkyboxFt = "rbxassetid://264909420", 
					SkyboxLf = "rbxassetid://264909758", 
					SkyboxRt = "rbxassetid://264908886", 
					SkyboxUp = "rbxassetid://264907379", 
				}, 
			} 
			local NewScope 
            do
				local ScreenGui = Instance.new("ScreenGui")
				local Frame = Instance.new("Frame")
				local UIGradient = Instance.new("UIGradient")
				local Frame_2 = Instance.new("Frame")
				local UIGradient_2 = Instance.new("UIGradient")
				local Frame_3 = Instance.new("Frame")
				local UIGradient_3 = Instance.new("UIGradient")
				local Frame_4 = Instance.new("Frame")
				local UIGradient_4 = Instance.new("UIGradient")

				ScreenGui.Enabled = false 
				ScreenGui.IgnoreGuiInset = true 
				ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global 

				Frame.Parent = ScreenGui
				Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Frame.BackgroundTransparency = 0.200
				Frame.BorderColor3 = Color3.fromRGB(26, 29, 40)
				Frame.BorderSizePixel = 0
				Frame.Position = UDim2.new(0.427604169, 0, 0.498901099, 0)
				Frame.Size = UDim2.new(0.0549999997, 0, 0, 2)

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(219, 224, 255)), ColorSequenceKeypoint.new(0.65, Color3.fromRGB(171, 187, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(70, 125, 255))}
				UIGradient.Parent = Frame

				Frame_2.Parent = ScreenGui
				Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Frame_2.BackgroundTransparency = 0.200
				Frame_2.BorderColor3 = Color3.fromRGB(26, 29, 40)
				Frame_2.BorderSizePixel = 0
				Frame_2.Position = UDim2.new(0.5, 0, 0.35164836, 0)
				Frame_2.Size = UDim2.new(0, 2, 0.115999997, 0)

				UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(219, 224, 255)), ColorSequenceKeypoint.new(0.65, Color3.fromRGB(171, 187, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(70, 125, 255))}
				UIGradient_2.Rotation = 86
				UIGradient_2.Parent = Frame_2

				Frame_3.Parent = ScreenGui
				Frame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Frame_3.BackgroundTransparency = 0.200
				Frame_3.BorderColor3 = Color3.fromRGB(26, 29, 40)
				Frame_3.BorderSizePixel = 0
				Frame_3.Position = UDim2.new(0.517187476, 0, 0.498901099, 0)
				Frame_3.Size = UDim2.new(0.0549999997, 0, 0, 2)

				UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(219, 224, 255)), ColorSequenceKeypoint.new(0.65, Color3.fromRGB(171, 187, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(70, 125, 255))}
				UIGradient_3.Rotation = 180
				UIGradient_3.Parent = Frame_3

				Frame_4.Parent = ScreenGui
				Frame_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Frame_4.BackgroundTransparency = 0.200
				Frame_4.BorderColor3 = Color3.fromRGB(26, 29, 40)
				Frame_4.BorderSizePixel = 0
				Frame_4.Position = UDim2.new(0.5, 0, 0.531868219, 0)
				Frame_4.Size = UDim2.new(0, 2, 0.115999997, 0)

				UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(219, 224, 255)), ColorSequenceKeypoint.new(0.65, Color3.fromRGB(171, 187, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(70, 125, 255))}
				UIGradient_4.Rotation = 270
				UIGradient_4.Parent = Frame_4

				ScreenGui.Parent = game.CoreGui 

				NewScope = ScreenGui
			end 
			local oldSkybox 

			local function VectorRGB(RGB) 
				return Vec3(RGB.R, RGB.G, RGB.B) 
			end 
			local function new(name, prop) 
				local obj = INST(name) 
				for i,v in pairs(prop) do 
					if i ~= "Parent" then 
						obj[i] = v 
					end 
				end 
				if prop["Parent"] ~= nil then 
					obj.Parent = prop["Parent"] 
				end 
			end 
			local function UpdateAccessory(Accessory) 
				Accessory.Material = values.visuals.effects["accessory material"].Dropdown == "Smooth" and "SmoothPlastic" or "ForceField" 
				Accessory.Mesh.VertexColor = VectorRGB(values.visuals.effects["accessory chams"].Color) 
				Accessory.Color = values.visuals.effects["accessory chams"].Color 
				Accessory.Transparency = values.visuals.effects["accessory chams"].Transparency 
				if values.visuals.effects["accessory material"].Dropdown ~= "ForceField" then 
					Accessory.Mesh.TextureId = "" 
				else 
					Accessory.Mesh.TextureId = Accessory.StringValue.Value 
				end 
			end 
			local function ReverseAccessory(Accessory) 
				Accessory.Material = "SmoothPlastic" 
				Accessory.Mesh.VertexColor = Vec3(1,1,1) 
				Accessory.Mesh.TextureId = Accessory.StringValue.Value 
				Accessory.Transparency = 0 
			end 
			local function UpdateWeapon(obj) 
				local selected = values.visuals.effects["weapon material"].Dropdown 

				if obj:IsA("MeshPart") then obj.TextureID = "" end 
				if obj:IsA("Part") and obj:FindFirstChild("Mesh") and not obj:IsA("BlockMesh") then 
					obj.Mesh.VertexColor = VectorRGB(values.visuals.effects["weapon chams"].Color) 
					if selected == "Smooth" or selected == "Glass" then 
						obj.Mesh.TextureId = "" 
					else 
						pcall(function() 
							obj.Mesh.TextureId = obj.Mesh.OriginalTexture.Value 
							obj.Mesh.TextureID = obj.Mesh.OriginalTexture.Value 
						end) 
					end 
				end 
				obj.Color = values.visuals.effects["weapon chams"].Color 
				obj.Material = selected == "Smooth" and "SmoothPlastic" or selected == "Flat" and "Neon" or selected == "ForceField" and "ForceField" or "Glass" 
				obj.Reflectance = values.visuals.effects["reflectance"].Slider/10 
				obj.Transparency = values.visuals.effects["weapon chams"].Transparency 
			end 
			local Skins = ReplicatedStorage.Skins 
			local function MapSkin(Gun, Skin, CustomSkin) 
				if CustomSkin ~= nil then 
					for _,Data in pairs(CustomSkin) do 
						local Obj = Camera.Arms:FindFirstChild(Data.Name) 
						if Obj ~= nil and Obj.Transparency ~= 1 then 
							Obj.TextureId = Data.Value 
						end 
					end 
				else 
					local SkinData = Skins:FindFirstChild(Gun):FindFirstChild(Skin) 
					if not SkinData:FindFirstChild("Animated") then 
						for _,Data in pairs(SkinData:GetChildren()) do 
							local Obj = Camera.Arms:FindFirstChild(Data.Name) 
							if Obj ~= nil and Obj.Transparency ~= 1 then 
								if Obj:FindFirstChild("Mesh") then 
									Obj.Mesh.TextureId = v.Value 
								elseif not Obj:FindFirstChild("Mesh") then 
									Obj.TextureID = Data.Value 
								end 
							end 
						end 
					end 
				end 
			end 
			local function ChangeCharacter(NewCharacter) 
				for _,Part in pairs (LocalPlayer.Character:GetChildren()) do 
					if Part:IsA("Accessory") then 
						Part:Destroy() 
					end 
					if Part:IsA("BasePart") then 
						if NewCharacter:FindFirstChild(Part.Name) then 
							Part.Color = NewCharacter:FindFirstChild(Part.Name).Color 
							Part.Transparency = NewCharacter:FindFirstChild(Part.Name).Transparency 
						end 
						if Part.Name == "FakeHead" then 
							Part.Color = NewCharacter:FindFirstChild("Head").Color 
							Part.Transparency = NewCharacter:FindFirstChild("Head").Transparency 
						end 
					end 

					if (Part.Name == "Head" or Part.Name == "FakeHead") and Part:FindFirstChildOfClass("Decal") and NewCharacter.Head:FindFirstChildOfClass("Decal") then 
						Part:FindFirstChildOfClass("Decal").Texture = NewCharacter.Head:FindFirstChildOfClass("Decal").Texture 
					end 
				end 

				if NewCharacter:FindFirstChildOfClass("Shirt") then 
					if LocalPlayer.Character:FindFirstChildOfClass("Shirt") then 
						LocalPlayer.Character:FindFirstChildOfClass("Shirt"):Destroy() 
					end 
					local Clone = NewCharacter:FindFirstChildOfClass("Shirt"):Clone() 
					Clone.Parent = LocalPlayer.Character 
				end 

				if NewCharacter:FindFirstChildOfClass("Pants") then 
					if LocalPlayer.Character:FindFirstChildOfClass("Pants") then 
						LocalPlayer.Character:FindFirstChildOfClass("Pants"):Destroy() 
					end 
					local Clone = NewCharacter:FindFirstChildOfClass("Pants"):Clone() 
					Clone.Parent = LocalPlayer.Character 
				end 

				for _,Part in pairs (NewCharacter:GetChildren()) do 
					if Part:IsA("Accessory") then 
						local Clone = Part:Clone() 
						for _,Weld in pairs (Clone.Handle:GetChildren()) do 
							if Weld:IsA("Weld") and Weld.Part1 ~= nil then 
								Weld.Part1 = LocalPlayer.Character[Weld.Part1.Name] 
							end 
						end 
						Clone.Parent = LocalPlayer.Character 
					end 
				end 

				if LocalPlayer.Character:FindFirstChildOfClass("Shirt") then 
					local String = INST("StringValue") 
					String.Name = "OriginalTexture" 
					String.Value = LocalPlayer.Character:FindFirstChildOfClass("Shirt").ShirtTemplate 
					String.Parent = LocalPlayer.Character:FindFirstChildOfClass("Shirt") 

					if TBLFIND(values.visuals.effects.removals.Jumbobox, "clothes") then 
						LocalPlayer.Character:FindFirstChildOfClass("Shirt").ShirtTemplate = "" 
					end 
				end 
				if LocalPlayer.Character:FindFirstChildOfClass("Pants") then 
					local String = INST("StringValue") 
					String.Name = "OriginalTexture" 
					String.Value = LocalPlayer.Character:FindFirstChildOfClass("Pants").PantsTemplate 
					String.Parent = LocalPlayer.Character:FindFirstChildOfClass("Pants") 

					if TBLFIND(values.visuals.effects.removals.Jumbobox, "clothes") then 
						LocalPlayer.Character:FindFirstChildOfClass("Pants").PantsTemplate = "" 
					end 
				end 
				for i,v in pairs(LocalPlayer.Character:GetChildren()) do 
					if v:IsA("BasePart") and v.Transparency ~= 1 then 
						INSERT(SelfObj, v) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = v.Color 
						Color.Parent = v 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = v.Material.Name 
						String.Parent = v 
					elseif v:IsA("Accessory") and v.Handle.Transparency ~= 1 then 
						INSERT(SelfObj, v.Handle) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = v.Handle.Color 
						Color.Parent = v.Handle 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = v.Handle.Material.Name 
						String.Parent = v.Handle 
					end 
				end 

				if values.visuals.self["self chams"].Toggle then 
					for _,obj in pairs(SelfObj) do 
						if obj.Parent ~= nil then 
							obj.Material = Enum.Material.ForceField 
							obj.Color = values.visuals.self["self chams"].Color 
						end 
					end 
				end 
			end 
			local function GetDeg(pos1, pos2) 
				local start = pos1.LookVector 
				local vector = CF(pos1.Position, pos2).LookVector 
				local angle = ACOS(start:Dot(vector)) 
				local deg = DEG(angle) 
				return deg 
			end 
			local Ping = game.Stats.PerformanceStats.Ping:GetValue() 

			for i,v in pairs(Viewmodels:GetChildren()) do 
				if v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.Transparency ~= 1 then 
					v.HumanoidRootPart.Transparency = 1 
				end 
			end 

			local Models = game:GetObjects("rbxassetid://7285197035")[1] 
			repeat wait() until Models ~= nil 
			local ChrModels = game:GetObjects("rbxassetid://7265740528")[1] 
			repeat wait() until ChrModels ~= nil 


			local AllKnives = { 
				"CT Knife", 
				"T Knife", 
				"Banana", 
				"Bayonet", 
				"Bearded Axe", 
				"Butterfly Knife", 
				"Cleaver", 
				"Crowbar", 
				"Falchion Knife", 
				"Flip Knife", 
				"Gut Knife", 
				"Huntsman Knife", 
				"Karambit", 
				"Sickle", 
			} 

			local AllGloves = {} 


			for _,fldr in pairs(Gloves:GetChildren()) do 
				if fldr ~= GloveModels and fldr.Name ~= "Racer" then 
					AllGloves[fldr.Name] = {} 
					for _2,modl in pairs(fldr:GetChildren()) do 
						INSERT(AllGloves[fldr.Name], modl.Name) 
					end 
				end 
			end 

			for i,v in pairs(Models.Knives:GetChildren()) do 
				INSERT(AllKnives, v.Name) 
			end 

			local AllSkins = {} 
			local AllWeapons = {} 
			local AllCharacters = {} 

			for i,v in pairs(ChrModels:GetChildren()) do 
				INSERT(AllCharacters, v.Name) 
			end 

			local skins = { 
				{["Weapon"] = "AWP", ["SkinName"] = "Bot", ["Skin"] = {["Scope"] = "6572594838", ["Handle"] = "6572594077"}} 
			} 

			for _,skin in pairs (skins) do 
				local Folder = INST("Folder") 
				Folder.Name = skin["SkinName"] 
				Folder.Parent = Skins[skin["Weapon"]] 

				for _,model in pairs (skin["Skin"]) do 
					local val = INST("StringValue") 
					val.Name = _ 
					val.Value = "rbxassetid://"..model 
					val.Parent = Folder 
				end 
			end 

			for i,v in pairs(Skins:GetChildren()) do 
				INSERT(AllWeapons, v.Name) 
			end 

			TBLSORT(AllWeapons, function(a,b) 
				return a < b 
			end) 

			for i,v in ipairs(AllWeapons) do 
				AllSkins[v] = {} 
				INSERT(AllSkins[v], "Inventory") 
				for _,v2 in pairs(Skins[v]:GetChildren()) do 
					if not v2:FindFirstChild("Animated") then 
						INSERT(AllSkins[v], v2.Name) 
					end 
				end 
			end 

			RunService.RenderStepped:Wait() 

			local gui = library:New("Memzhack.pasted REWRITE") 
			local rage = gui:Tab("rage") 
			local visuals = gui:Tab("visuals") 
			local misc = gui:Tab("misc") 
			local skins = gui:Tab("skins") 

			getgenv().api = {} 
			api.newtab = function(name) 
				return gui:Tab(name) 
			end 
			api.newsection = function(tab, name, side) 
				return tab:Sector(name, side) 
			end 
			api.newelement = function(section, type, name, data, callback) 
				section:Element(type, name, data, callback) 
			end 

			local knife = skins:Sector("knife", "Left") 
			knife:Element("Toggle", "knife changer") 
			knife:Element("Scroll", "model", {options = AllKnives, Amount = 15}) 

			local glove = skins:Sector("glove", "Left") 
			glove:Element("Toggle", "glove changer") 
			glove:Element("ScrollDrop", "model", {options = AllGloves, Amount = 9}) 

			local skin = skins:Sector("skins", "Right") 
			skin:Element("Toggle", "skin changer") 
			skin:Element("ScrollDrop", "skin", {options = AllSkins, Amount = 15, alphabet = true}) 

			local characters = skins:Sector("characters", "Right") 
			characters:Element("Toggle", "character changer", nil, function(tbl) 
				if tbl.Toggle then 
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then 
						ChangeCharacter(ChrModels:FindFirstChild(values.skins.characters.skin.Scroll)) 
					end 
				end 
			end) 
			characters:Element("Scroll", "skin", {options = AllCharacters, Amount = 9, alphabet = true}, function(tbl) 
				if values.skins.characters["character changer"].Toggle then 
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then 
						ChangeCharacter(ChrModels:FindFirstChild(tbl.Scroll)) 
					end 
				end 
			end) 

			local aimbot = rage:Sector("aimbot", "Left")
			aimbot:Element("Toggle", "enabled") 
			aimbot:Element("Dropdown", "origin", {options = {"character", "camera"}}) 
			aimbot:Element("Dropdown", "automatic fire", {options = {"off", "standard", "hitpart"}})
			aimbot:Element("Toggle", "wallbang")
			aimbot:Element('Dropdown', 'wallbang method', {options = {"none", "true", "force"}})
			aimbot:Element('Slider', 'wallbang amount', {min = 1, max = 100, default = 1})
			aimbot:Element('Toggle', 'forward track')
			aimbot:Element('Jumbobox', 'resolver', {options = {'pitch', 'roll', 'arms', 'animation'}})
			aimbot:Element('Dropdown', 'localscan method', {options = {"test", "new", "old"}})
			aimbot:Element('Dropdown', 'hitscan method', {options = {'new', 'old', 'test', 'bs.gay', 'idk'}})
			aimbot:Element('Slider', 'scan speed', {min = 1, max = 100, default = 57})
			aimbot:Element('Slider', 'points adding', {min = 1, max = 50, default = 12})
			aimbot:Element('Slider', 'forward track distance', {min = 6, max = 1000, default = 6})
			aimbot:Element("Toggle", "prediction") 
			aimbot:Element('Toggle', 'force hit')
			aimbot:Element('Dropdown', 'force mode', {options = {'hit', 'head'}})
			aimbot:Element("Toggle", "teammates") 
			aimbot:Element("Toggle", "ragebot logs")
			aimbot:Element('Slider', 'log time', {min = 1, max = 10, default = 2})
            aimbot:Element("Toggle", "information", {default = {Toggle = false}}, function(tbl)
                for i,v in next, indicators do 
                    v.Visible = tbl.Toggle
                end
            end)
			aimbot:Element("Toggle", "status", {}, function(tbl)    
				for i,v in next, statusshit do 
					v.Visible = tbl.Toggle
				end				
			end)
			aimbot:Element("Slider", "Pos X", {min = 0, max = 1800, default = 55}) 
			aimbot:Element("Slider", "Pos Y", {min = 0, max = 1800, default = 308})
			aimbot:Element("Toggle", "knifebot")
			aimbot:Element("Dropdown", "type", {options = {"normal", "rapid"}}) 
			aimbot:Element("Slider", "Radius", {min = -1, max = 9000, default = 20})
			aimbot:Element("Toggle", "wallcheck", {default = {Toggle = true}})

			local weapons = rage:MSector("weapons", "Left") 
			local default = weapons:Tab("default") 
			local pistol = weapons:Tab("pistol") 
			local rifle = weapons:Tab("rifle") 
			local scout = weapons:Tab("scout") 
			local awp = weapons:Tab("awp") 
			local auto = weapons:Tab("auto") 

			local function AddRage(Tab) 
				Tab:Element("Jumbobox", "hitboxes", {options = {"head", "torso", "pelvis", 'arms'}}) 
				Tab:Element("Slider", "minimum damage", {min = 1, max = 100, default = 20}) 
				Tab:Element("Slider", "max fov", {min = 1, max = 180, default = 180}) 
			end 

			AddRage(default) 

			pistol:Element("Toggle", "override default") 
			AddRage(pistol) 

			rifle:Element("Toggle", "override default") 
			AddRage(rifle) 

			scout:Element("Toggle", "override default") 
			AddRage(scout) 

			awp:Element("Toggle", "override default") 
			AddRage(awp) 

			auto:Element("Toggle", "override default") 
			AddRage(auto) 

			local antiaim = rage:Sector("angles", "Right") 
			antiaim:Element("Toggle", "enabled") 
			antiaim:Element("Dropdown", "yaw base", {options = {"camera", "targets", "spin", "random"}}) 
			antiaim:Element("Slider", "yaw offset", {min = -180, max = 180, default = 0}) 
			antiaim:Element("Toggle", "jitter") 
			antiaim:Element("Slider", "jitter offset", {min = -180, max = 180, default = 0}) 
			antiaim:Element("Dropdown", "pitch", {options = {"zero", "up", "down", "180", "180v2", "180v3", "random", "random2", "totally normal", "totally normal2", "custom", "down2", "up2", "sucking dick", "fake headless", "huge"}})
			antiaim:Element("Slider", "pitch angle", {min = -100, max = 100, default = 0})  
			antiaim:Element("Toggle", "extend pitch") 
			antiaim:Element("Dropdown", "body roll", {options = {"off", "180"}}) 
			antiaim:Element("Slider", "spin speed", {min = 1, max = 48, default = 4}) 
			antiaim:Element("Toggle", "Fake flick")
			antiaim:Element("Slider", "offset", {min = -180, max = 180, default = 0})
			antiaim:Element("Slider", "wait (ms)", {min = 1, max = 100, default = 1})
			local shotthingy = false
			game:GetService("Workspace").FunFacts["Shots were fired"].Changed:Connect(function()
				if not shotthingy then
					shotthingy = true 
			
					if values.rage.angles["Fake flick"].Toggle then
						spawn(function()
							for i=1,10 do wait()
								pcall(function()
									game.ReplicatedStorage.Events.ControlTurn:FireServer(values.rage.angles["pitch"].Slider/7, game.Players.LocalPlayer.Character:FindFirstChild("Climbing") and true or false)
								end)
							end
						end)
					end
			
					wait(values.rage.angles["wait (ms)"].Slider/100)
			
					shotthingy = false
				end
			end)
			
			local others = rage:Sector("others", "Right") 
			others:Element("ToggleKeybind", "fake duck")
			others:Element("Toggle", "remove head") 
			others:Element("Toggle", "no animations") 
			others:Element("Dropdown", "leg movement", {options = {"off", "slide"}}) 

			local LagTick = 0
			local fakelag = rage:Sector('fakelag', 'Right')

			fakelag:Element('Toggle', 'DDOS', {Type = "Toggle", Key = "T"},function(tbl)
				if tbl.Toggle then
					spawn(function()
						while values.rage.fakelag["DDOS"].Toggle   do
							pcall(function()
								game:GetService("RunService").RenderStepped:Wait()
								game:GetService("RunService").RenderStepped:Wait()
								for i = 1,values.rage.fakelag["DDOS Amount"].Slider,1 do
									local ohInstance1 = LocalPlayer.Character.Gun.Mag              
									game:GetService("ReplicatedStorage").Events.DropMag:FireServer(ohInstance1)
									for i,v in pairs(workspace["Ray_Ignore"]:GetChildren()) do
										if v.Name == "MagDrop" then
											v:Destroy()
										end
									end
								end
							end)       
						end 
					end)
				end
			end)
			fakelag:Element('Slider', 'DDOS Amount', {min = 1, max = 10, default = 1})

			fakelag:Element('Slider', 'set ping', {min = -100, max = 100, default = 0})
			game:GetService('Players').LocalPlayer.Ping.Changed:Connect(function()
				if values.rage.fakelag['set ping'].Slider ~= 0 then 
					game:GetService('ReplicatedStorage').Events.UpdatePing:FireServer( values.rage.fakelag['set ping'].Slider/10)
				end
			end)
			fakelag:Element('ToggleKeybind', 'enabled', {default = {Toggle = false}}, function(tbl)
				if tbl.Toggle then
				else
					FakelagFolder:ClearAllChildren()
					game:GetService('NetworkClient'):SetOutgoingKBPSLimit(9e9)
				end
			end)
			fakelag:Element('Dropdown', 'amount', {options = {'static', 'freeze', 'tfreeze', 'underfreeze'}})
			fakelag:Element('Slider', 'limit', {min = 1, max = 106, default = 8})
			fakelag:Element('Slider', 'under y', {min = 1, max = 50, default = 8})
			fakelag:Element('Toggle', 'random')
			fakelag:Element('ToggleColor', 'visualize lag', {default = {Toggle = false, Color = COL3RGB(255,255,255)}}, function(tbl)
				if tbl.Toggle then
					for _,obj in pairs(FakelagFolder:GetChildren()) do
						obj.Color = tbl.Color
					end
				else
					FakelagFolder:ClearAllChildren()
				end
			end)

			local savedcamerapart = Instance.new('Part', RayIgnore)
			savedcamerapart.Anchored = true
			savedcamerapart.CanCollide = false
			savedcamerapart.Size = Vector3.new(1, 1, 1)
			savedcamerapart.Transparency = 1
			fakelag:Element('ToggleKeybind', 'ping spike')
			coroutine.wrap(function()
				while wait(1/16) do
					LagTick = CLAMP(LagTick + 1, 0, values.rage.fakelag.limit.Slider)
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('UpperTorso') and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and values.rage.fakelag.enabled.Toggle and values.rage.fakelag.enabled.Active then
						if LagTick >= (values.rage.fakelag.random.Toggle and math.random(0, values.rage.fakelag.limit.Slider) or values.rage.fakelag.limit.Slider)  then
							if values.rage.fakelag.amount.Dropdown == 'static' then 
								game:GetService('NetworkClient'):SetOutgoingKBPSLimit(9e9)
								FakelagFolder:ClearAllChildren()
								LagTick = 0
								if values.rage.fakelag['visualize lag'].Toggle then
									game:GetService("CoreGui").KeybindList.BKR.Grad.Frame.ABC.AFAKELAG.Text = "   Fakelag: static   "
									for _,hitbox in pairs(LocalPlayer.Character:GetChildren()) do
										if hitbox:IsA('BasePart') and hitbox.Name ~= 'HumanoidRootPart' then
											local Part = Instance.new("Part")
											Part.BottomSurface = Enum.SurfaceType.Smooth
											Part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
											Part.Color = values.rage.fakelag['visualize lag'].Color
											Part.Material = Enum.Material.ForceField
											Part.Shape = Enum.PartType.Ball
											Part.Size = Vector3.new(2, 2, 2)
											Part.TopSurface = Enum.SurfaceType.Smooth
											Part.Parent = FakelagFolder
											Part.Anchored = true
											Part.CanCollide = false
											Part.Position = LocalPlayer.Character.HumanoidRootPart.Position
										end
									end
								end
							elseif values.rage.fakelag.amount.Dropdown == 'freeze' and allowedtofreeze then 
								game:GetService("CoreGui").KeybindList.BKR.Grad.Frame.ABC.AFAKELAG.Text = "   Fakelag: freeze   "
								LagTick = 0
								FakelagFolder:ClearAllChildren()

								pcall(function()
									workspace.FreezeCharacter2:Remove()
								end)
								wait(0.1)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(138, 9)})
								pcall(function()
									local part = INST('Part', workspace)

									part.Size = Vector3.new(30, 1, 30) 


									part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
									part.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
									part.CanCollide = false
									part.Transparency = 1
									part.Name = 'FreezeCharacter2'


									local weld = INST('Weld',part)
									weld.Part0 = part
									weld.Part1 = game.Players.LocalPlayer.Character.HumanoidRootPart


									if values.rage.fakelag['visualize lag'].Toggle then
										for _,hitbox in pairs(LocalPlayer.Character:GetChildren()) do
											if hitbox:IsA('BasePart') and hitbox.Name ~= 'HumanoidRootPart' then
												local Part = Instance.new("Part")
												Part.Anchored = true
												Part.BottomSurface = Enum.SurfaceType.Smooth
												Part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
												Part.Color = values.rage.fakelag['visualize lag'].Color
												Part.Material = Enum.Material.ForceField
												Part.Reflectance = 1
												Part.Shape = Enum.PartType.Ball
												Part.Size = Vector3.new(2, 2, 2)
												Part.Transparency = 0.8
												Part.CanCollide = false
												Part.Parent = FakelagFolder
												Part.Position = LocalPlayer.Character.HumanoidRootPart.Position

											end
										end
									end
								end)

								wait(0.1)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(0, 9)})
							elseif values.rage.fakelag.amount.Dropdown == 'tfreeze' and allowedtofreeze then 
								game:GetService("CoreGui").KeybindList.BKR.Grad.Frame.ABC.AFAKELAG.Text = "   Fakelag: tfreeze   "
								LagTick = 0
								FakelagFolder:ClearAllChildren()
								pcall(function()

								end)
								pcall(function()
									workspace.FreezeCharacter2:Remove()
								end)
								local loopstuff
								pcall(function()
									saved = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
									savedcamerapart.CFrame = workspace.Camera.Focus
									workspace.Camera.CameraSubject = savedcamerapart
									loopstuff = game:GetService('RunService').Stepped:Connect(function()
										savedcamerapart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.x, savedcamerapart.CFrame.y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.z)
									end)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -values.rage.fakelag['under y'].Slider, 0)
								end)

								wait(0.15)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(138, 9)})
								pcall(function()
									local part = INST('Part', workspace)

									part.Size = Vector3.new(30, 1, 30) 


									part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
									part.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
									part.CanCollide = false
									part.Transparency = 1
									part.Name = 'FreezeCharacter2'


									local weld = INST('Weld',part)
									weld.Part0 = part
									weld.Part1 = game.Players.LocalPlayer.Character.HumanoidRootPart


									if values.rage.fakelag['visualize lag'].Toggle then
										for _,hitbox in pairs(LocalPlayer.Character:GetChildren()) do
											if hitbox:IsA('BasePart') and hitbox.Name ~= 'HumanoidRootPart' then
												local part = INST('Part')
												part.CFrame = hitbox.CFrame
												part.Anchored = true
												part.CanCollide = false
												part.Material = Enum.Material.ForceField
												part.Color = values.rage.fakelag['visualize lag'].Color
												part.Name = hitbox.Name
												part.Transparency = 0
												part.Size = hitbox.Size
												part.Parent = FakelagFolder
											end
										end
									end
								end)

								wait(0.01)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(0, 9)})
								pcall(function()
									loopstuff:Disconnect()
									workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
									workspace.FreezeCharacter2.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.x, saved.y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.z)
								end)


								wait(0.1)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(138, 9)})
							elseif values.rage.fakelag.amount.Dropdown == 'underfreeze'  and allowedtofreeze then 
								game:GetService("CoreGui").KeybindList.BKR.Grad.Frame.ABC.AFAKELAG.Text = "   Fakelag: underfreeze   "
								LagTick = 0
								FakelagFolder:ClearAllChildren()

								pcall(function()
									workspace.FreezeCharacter2:Remove()
								end)
								local loopstuff
								pcall(function()
									saved = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
									savedcamerapart.CFrame = workspace.Camera.Focus
									workspace.Camera.CameraSubject = savedcamerapart
									loopstuff = game:GetService('RunService').Stepped:Connect(function()
										savedcamerapart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.x, savedcamerapart.CFrame.y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.z)
									end)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -values.rage.fakelag['under y'].Slider, 0)
								end)

								wait(0.15)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(0, 9)})
								pcall(function()
									local part = INST('Part', workspace)

									part.Size = Vector3.new(30, 1, 30) 


									part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
									part.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
									part.CanCollide = false
									part.Transparency = 1
									part.Name = 'FreezeCharacter2'


									local weld = INST('Weld',part)
									weld.Part0 = part
									weld.Part1 = game.Players.LocalPlayer.Character.HumanoidRootPart


									if values.rage.fakelag['visualize lag'].Toggle then
										for _,hitbox in pairs(LocalPlayer.Character:GetChildren()) do
											if hitbox:IsA('BasePart') and hitbox.Name ~= 'HumanoidRootPart' then
												local part = INST('Part')
												part.CFrame = hitbox.CFrame
												part.Anchored = true
												part.CanCollide = false
												part.Material = Enum.Material.ForceField
												part.Color = values.rage.fakelag['visualize lag'].Color
												part.Name = hitbox.Name
												part.Transparency = 0
												part.Size = hitbox.Size
												part.Parent = FakelagFolder
											end
										end
									end
								end)

								wait(0.01)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(138, 9)})
								pcall(function()
									loopstuff:Disconnect()
									workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
									workspace.FreezeCharacter2.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.x, saved.y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.z)
								end)


								wait(0.1)
								TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(0, 9)})
							end
						else
							TweenDrawing(statusshit.FakelagStatus, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = v2(0, 9)})
							if values.rage.fakelag.enabled.Toggle and values.rage.fakelag.amount.Dropdown == 'static' then
								game:GetService("CoreGui").KeybindList.BKR.Grad.Frame.ABC.AFAKELAG.Text = "   Fakelag: static   "
								game:GetService('NetworkClient'):SetOutgoingKBPSLimit(1)
							end
						end
					else
						game:GetService("CoreGui").KeybindList.BKR.Grad.Frame.ABC.AFAKELAG.Text = "   Fakelag: off   "
						pcall(function()
							workspace.FreezeCharacter2:Remove()
						end)
						FakelagFolder:ClearAllChildren()
						game:GetService('NetworkClient'):SetOutgoingKBPSLimit(9e9)
					end
				end
			end)()
			fakelag:Element('ToggleKeybind', 'FreezeLOL!', nil, function(tbl)
				if tbl.Toggle and tbl.Active then
					local Freto = Instance.new("Part")
					Freto.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
					Freto.CanCollide = false

					Freto.BottomSurface = Enum.SurfaceType.Smooth
					Freto.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
					Freto.Name = "Freto"
					Freto.Size = Vector3.new(30, 1, 30)
					Freto.TopSurface = Enum.SurfaceType.Smooth
					Freto.Parent = game:GetService("Workspace")
					Freto.Transparency = 1

					local Part = Instance.new("Part")
					Part.CanCollide = false
					Part.Anchored = true
					Part.BottomSurface = Enum.SurfaceType.Smooth
					Part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
					Part.Material = Enum.Material.ForceField
					Part.Shape = Enum.PartType.Ball
					Part.Size = Vector3.new(2, 2, 2)
					Part.TopSurface = Enum.SurfaceType.Smooth
					Part.Transparency = 0.3
					Part.Parent = Freto
					Part.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

					local Weld = Instance.new("Weld", Freto)
					Weld.Parent = Freto
					Weld.Part0 = Freto
					Weld.Part1 = game.Players.LocalPlayer.Character.HumanoidRootPart
				else
					game.Workspace.Freto:Destroy()
				end
			end)
			freezebusy1 = false
			freezebusy2 = false

			local exploits = rage:Sector("exploits", "Left") 
			exploits:Element("ToggleKeybind", "double tap")
			exploits:Element("ToggleKeybind", "kill all") 
			exploits:Element("ToggleKeybind", "Funny moment") 
			exploits:Element("ToggleKeybind", "otw knife")

			exploits:Element("TextBox", "Player", {placeholder = "player name"}) 
			exploits:Element("Toggle", "Loop kill", nil, function(tbl)
				if tbl.Toggle then
				_G.Disable1 = false
				local step1
					step1 = game:GetService("RunService").RenderStepped:Connect(function()
					if _G.Disable1 then step1:Disconnect() return end
						if Players[values.rage["exploits"].Player.Text].Character and Players[values.rage["exploits"].Player.Text].Team ~= LocalPlayer.Team and Players[values.rage["exploits"].Player.Text].Character:FindFirstChild("UpperTorso") then
							local oh1 = Players[values.rage["exploits"].Player.Text].Character.Head
							local oh2 = Players[values.rage["exploits"].Player.Text].Character.Head.CFrame.p
							local oh3 = Client.gun.Name
							local oh4 = 1
							local oh5 = nil
							local oh8 = 54524542
							local oh9 = true
							local oh10 = true
							local oh11 = Vector3.new()
						    local oh12 = 1
							local oh13 = Vector3.new()
							game:GetService("ReplicatedStorage").Events.HitPart:FireServer(oh1, oh2, oh3, oh4, oh5, oh6, oh7, oh8, oh9, oh10, oh11, oh12, oh13)
						end
					end)
					else
					_G.Disable1 = true

					end
				end)
				exploits:Element("Button", "God Mode", {}, function() 
					local ReplicatedStorage = game:GetService("ReplicatedStorage");
					local ApplyGun = ReplicatedStorage.Events.ApplyGun;
					ApplyGun:FireServer({
						Model = ReplicatedStorage.Hostage.Hostage,
						Name = "USP"
					}, game.Players.LocalPlayer);
				end) 

			local players = visuals:Sector("players", "Left") 
			players:Element("Toggle", "teammates") 
			players:Element("ToggleColor", "box", {default = {Color = COL3RGB(255,255,255)}}) 
			players:Element("ToggleColor", "name", {default = {Color = COL3RGB(255,255,255)}}) 
			players:Element("Dropdown", "suffix", {options = {"[]", "()", "nothing"}}) 
			players:Element("Toggle", "health") 
			players:Element("ToggleColor", "weapon", {default = {Color = COL3RGB(255,255,255)}}) 
			players:Element("ToggleColor", "weapon icon", {default = {Color = COL3RGB(255,255,255)}}) 
			players:Element("Jumbobox", "indicators", {options = {"armor"}}) 
			players:Element("Jumbobox", "outlines", {options = {"drawings", "text"}, default = {Jumbobox = {"drawings", "text"}}}) 
			players:Element("Dropdown", "font", {options = {"Plex", "Monospace", "System", "UI"}}) 
			players:Element("Slider", "size", {min = 12, max = 16, default = 13}) 
            players:Element("Slider", "cham thickness", {min = 0, max = 10, default = 0})

			game:GetService('RunService').RenderStepped:Connect(function()
				if values.visuals.players["suffix"].Dropdown == "[]" then
					suffixx = "["
					suffixx2 = "]"
				elseif values.visuals.players["suffix"].Dropdown == "()" then
					suffixx = "("
					suffixx2 = ")"
				elseif values.visuals.players["suffix"].Dropdown == "nothing" then
					suffixx = ""
					suffixx2 = ""
				end
			end)

            players:Element("ToggleTrans", "chams", {default = {Color = COL3RGB(255,255,255), Transparency = 0}}, function(tbl)
                for _,Player in pairs(Players:GetPlayers()) do
                    if Player.Character then
                        for _2,Obj in pairs(Player.Character:GetDescendants()) do
                            if Obj.Name == "WallCham" then
                                if tbl.Toggle then
                                    if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then
                                        Obj.Visible = true
                                        
                                    else
                                        Obj.Visible = false
                                    end
                                else
                                    Obj.Visible = false
                                end
                                Obj.Color3 = tbl.Color
                                Obj.Transparency = values.visuals.players["chams"].Transparency
                            end
                        end
                    end
                end
            end)
            
            players:Element("ToggleTrans", "visible chams",  {default = {Color = COL3RGB(255,255,255), Transparency = 0}}, function(tbl)
                for _,Player in pairs(Players:GetPlayers()) do
                    if Player.Character then
                        for _2,Obj in pairs(Player.Character:GetDescendants()) do
                            if Obj.Name == "VisibleCham" then
                                if tbl.Toggle then
                                    if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then
                                        Obj.Visible = true
                                    else
                                        Obj.Visible = false
                                    end
                                else
                                    Obj.Visible = false
                                end
                                Obj.Color3 = tbl.Color
                                Obj.Transparency = values.visuals.players["visible chams"].Transparency
                            end
                        end
                    end
                end
            end)
			local effects = visuals:Sector("effects", "Right") 
			effects:Element("ToggleTrans", "weapon chams", {default = {Color = COL3RGB(255,255,255), Transparency = 0}}, function(tbl) 
				if WeaponObj == nil then return end 
				if tbl.Toggle then 
					for i,v in pairs(WeaponObj) do 
						UpdateWeapon(v) 
					end 
				else 
					for i,v in pairs(WeaponObj) do 
						if v:IsA("MeshPart") then v.TextureID = v.OriginalTexture.Value end 
						if v:IsA("Part") and v:FindFirstChild("Mesh") and not v:IsA("BlockMesh") then 
							v.Mesh.TextureId = v.Mesh.OriginalTexture.Value 
							v.Mesh.VertexColor = Vec3(1,1,1) 
						end 
						v.Color = v.OriginalColor.Value 
						v.Material = v.OriginalMaterial.Value 
						v.Transparency = 0 
					end 
				end 
			end) 
			effects:Element("Dropdown", "weapon material", {options = {"Smooth", "Flat", "ForceField", "Glass"}}, function(tbl) 
				if WeaponObj == nil then return end 
				if values.visuals.effects["weapon chams"].Toggle then 
					for i,v in pairs(WeaponObj) do 
						UpdateWeapon(v) 
					end 
				end 
			end) 
			effects:Element("Slider", "reflectance", {min = 0, max = 100, default = 0}, function(tbl) 
				if values.visuals.effects["weapon chams"].Toggle then 
					for i,v in pairs(WeaponObj) do 
						UpdateWeapon(v) 
					end 
				end 
			end) 
			effects:Element("ToggleTrans", "accessory chams", {default = {Color = COL3RGB(255,255,255)}}, function(val) 
				if RArm == nil or LArm == nil then return end 
				if val.Toggle then 
					if RGlove ~= nil then 
						UpdateAccessory(RGlove) 
					end 
					if RSleeve ~= nil then 
						UpdateAccessory(RSleeve) 
					end 
					if LGlove ~= nil then 
						UpdateAccessory(LGlove) 
					end 
					if LSleeve ~= nil then 
						UpdateAccessory(LSleeve) 
					end 
				else 
					if RGlove then 
						ReverseAccessory(RGlove) 
					end 
					if LGlove then 
						ReverseAccessory(LGlove) 
					end 
					if RSleeve then 
						ReverseAccessory(RSleeve) 
					end 
					if LSleeve then 
						ReverseAccessory(LSleeve) 
					end 
				end 
			end) 
			effects:Element("Dropdown", "accessory material", {options = {"Smooth","ForceField"}}, function(val) 
				if RArm == nil or LArm == nil then return end 
				if values.visuals.effects["accessory chams"].Toggle then 
					if RGlove ~= nil then 
						UpdateAccessory(RGlove) 
					end 
					if RSleeve ~= nil then 
						UpdateAccessory(RSleeve) 
					end 
					if LGlove ~= nil then 
						UpdateAccessory(LGlove) 
					end 
					if LSleeve ~= nil then 
						UpdateAccessory(LSleeve) 
					end 
				end 
			end) 
			
			effects:Element("ToggleTrans", "arm chams", {default = {Color = COL3RGB(255,255,255)}}, function(val) 
				if RArm == nil then return end 
				if LArm == nil then return end 
				if val.Toggle then 
					RArm.Color = val.Color 
					LArm.Color = val.Color 
					RArm.Transparency = val.Transparency 
					LArm.Transparency = val.Transparency 
				else 
					RArm.Color = RArm.Color3Value.Value 
					LArm.Color = RArm.Color3Value.Value 
					RArm.Transparency = 0 
					LArm.Transparency = 0 
				end 
			end) 
			effects:Element("Jumbobox", "removals", {options = {"scope", "scope lines", "flash", "smoke", "decals", "shadows", "clothes", "Sleeves"}}, function(val) 
				local tbl = val.Jumbobox 
				if TBLFIND(tbl, "decals") then 
					Client.createbullethole = function() end 
					for i,v in pairs(workspace.Debris:GetChildren()) do 
						if v.Name == "Bullet" or v.Name == "SurfaceGui" then 
							v:Destroy() 
						end 
					end 
				else 
					Client.createbullethole = oldcreatebullethole 
				end 
				if TBLFIND(tbl, "clothes") then 
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("UpperTorso") then 
						if LocalPlayer.Character:FindFirstChild("Shirt") then 
							LocalPlayer.Character:FindFirstChild("Shirt").ShirtTemplate = "" 
						end 
						if LocalPlayer.Character:FindFirstChild("Pants") then 
							LocalPlayer.Character:FindFirstChild("Pants").PantsTemplate = "" 
						end 
					end 
				else 
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("UpperTorso") then 
						if LocalPlayer.Character:FindFirstChild("Shirt") then 
							LocalPlayer.Character:FindFirstChild("Shirt").ShirtTemplate = LocalPlayer.Character:FindFirstChild("Shirt").OriginalTexture.Value 
						end 
						if LocalPlayer.Character:FindFirstChild("Pants") then 
							LocalPlayer.Character:FindFirstChild("Pants").PantsTemplate = LocalPlayer.Character:FindFirstChild("Pants").OriginalTexture.Value 
						end 
					end 
				end 
				if TBLFIND(tbl, "scope") then 
					Crosshairs.Scope.ImageTransparency = 1 
					Crosshairs.Scope.Scope.ImageTransparency = 1 
					Crosshairs.Frame1.Transparency = 1 
					Crosshairs.Frame2.Transparency = 1 
					Crosshairs.Frame3.Transparency = 1 
					Crosshairs.Frame4.Transparency = 1 
				else 
					Crosshairs.Scope.ImageTransparency = 0 
					Crosshairs.Scope.Scope.ImageTransparency = 0 
					Crosshairs.Frame1.Transparency = 0 
					Crosshairs.Frame2.Transparency = 0 
					Crosshairs.Frame3.Transparency = 0 
					Crosshairs.Frame4.Transparency = 0 
				end 
				PlayerGui.Blnd.Enabled = not TBLFIND(tbl, "flash") and true or false 
				Lighting.GlobalShadows = not TBLFIND(tbl, "shadows") and true or false 
				if RayIgnore:FindFirstChild("Smokes") then 
					if TBLFIND(tbl, "smoke") then 
						for i,smoke in pairs(RayIgnore.Smokes:GetChildren()) do 
							smoke.ParticleEmitter.Rate = 0 
						end 
					else 
						for i,smoke in pairs(RayIgnore.Smokes:GetChildren()) do 
							smoke.ParticleEmitter.Rate = smoke.OriginalRate.Value 
						end 
					end 
				end 
			end) 
			effects:Element("Toggle", "force crosshair")
			effects:Element("ToggleColor", "world color", {default = {Color = COL3RGB(255,255,255)}}, function(val) 
				if val.Toggle then 
					Camera.ColorCorrection.TintColor = val.Color 
				else 
					Camera.ColorCorrection.TintColor = COL3RGB(255,255,255) 
				end 
			end) 
			effects:Element("Toggle", "shadowmap technology", nil, function(val) sethiddenproperty(Lighting, "Technology", val.Toggle and "ShadowMap" or "Legacy") end) 

			local self = visuals:Sector("self", "Right") 
			self:Element("ToggleKeybind", "third person", {}, function(tbl) 
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
					if tbl.Toggle then 
						if tbl.Active then 
							LocalPlayer.CameraMaxZoomDistance = values.visuals.self.distance.Slider 
							LocalPlayer.CameraMinZoomDistance = values.visuals.self.distance.Slider 
							LocalPlayer.CameraMaxZoomDistance = values.visuals.self.distance.Slider 
							LocalPlayer.CameraMinZoomDistance = values.visuals.self.distance.Slider 
						else 
							LocalPlayer.CameraMaxZoomDistance = 0 
							LocalPlayer.CameraMinZoomDistance = 0 
							LocalPlayer.CameraMaxZoomDistance = 0 
							LocalPlayer.CameraMinZoomDistance = 0 
						end 
					else 
						LocalPlayer.CameraMaxZoomDistance = 0 
						LocalPlayer.CameraMinZoomDistance = 0 
					end 
				end 
			end) 
			self:Element("Slider", "distance", {min = 6, max = 18, default = 12}, function(tbl) 
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
					if values.visuals.self["third person"].Toggle then 
						if values.visuals.self["third person"].Active then 
							LocalPlayer.CameraMaxZoomDistance = tbl.Slider 
							LocalPlayer.CameraMinZoomDistance = tbl.Slider 
							LocalPlayer.CameraMaxZoomDistance = tbl.Slider 
							LocalPlayer.CameraMinZoomDistance = tbl.Slider 
						else 
							LocalPlayer.CameraMaxZoomDistance = 0 
							LocalPlayer.CameraMinZoomDistance = 0 
						end 
					else 
						LocalPlayer.CameraMaxZoomDistance = 0 
						LocalPlayer.CameraMinZoomDistance = 0 
					end 
				end 
			end) 
			LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function(current) 
				if values.visuals.self["third person"].Toggle then 
					if values.visuals.self["third person"].Active then 
						if current ~= values.visuals.self.distance.Slider then 
							LocalPlayer.CameraMinZoomDistance = values.visuals.self.distance.Slider 
						end 
					end 
				end 
			end)
			self:Element("Toggle", "visualize silent angle")
			self:Element("Slider", "silent angle speed", {min = 0, max = 10, default = 5}) 
			self:Element("Slider", "fov changer", {min = 0, max = 120, default = 80}, function(value) 
				RunService.RenderStepped:Wait() 
				if LocalPlayer.Character == nil then return end 
				if fov == value.Slider then return end 
				if values.visuals.self["on scope"].Toggle or not LocalPlayer.Character:FindFirstChild("AIMING") then 
					Camera.FieldOfView = value.Slider 
				end 
			end) 
			self:Element("Toggle", "on scope") 
			self:Element("Toggle", "viewmodel changer") 
			self:Element("Slider", "viewmodel x", {min = -10, max = 10}, function(val) 
				ViewmodelOffset = CF(values.visuals.self["viewmodel x"].Slider/7, values.visuals.self["viewmodel y"].Slider/7, values.visuals.self["viewmodel z"].Slider/7) * CFAngles(0, 0, values.visuals.self.roll.Slider/50) 
			end) 
			self:Element("Slider", "viewmodel y", {min = -10, max = 10}, function(val) 
				ViewmodelOffset = CF(values.visuals.self["viewmodel x"].Slider/7, values.visuals.self["viewmodel y"].Slider/7, values.visuals.self["viewmodel z"].Slider/7) * CFAngles(0, 0, values.visuals.self.roll.Slider/50) 
			end) 
			self:Element("Slider", "viewmodel z", {min = -10, max = 10}, function(val) 
				ViewmodelOffset = CF(values.visuals.self["viewmodel x"].Slider/7, values.visuals.self["viewmodel y"].Slider/7, values.visuals.self["viewmodel z"].Slider/7) * CFAngles(0, 0, values.visuals.self.roll.Slider/50) 
			end) 
			self:Element("Slider", "roll", {min = -100, max = 100}, function(val) 
				ViewmodelOffset = CF(values.visuals.self["viewmodel x"].Slider/7, values.visuals.self["viewmodel y"].Slider/7, values.visuals.self["viewmodel z"].Slider/7) * CFAngles(0, 0, values.visuals.self.roll.Slider/50) 
			end) 
			self:Element("ToggleColor", "self chams", {default = {Color = COL3RGB(255,255,255)}}, function(tbl) 
				if tbl.Toggle then 
					for _,obj in pairs(SelfObj) do 
						if obj.Parent ~= nil then 
							obj.Material = Enum.Material.ForceField 
							obj.Color = tbl.Color 
						end 
					end 
				else 
					for _,obj in pairs(SelfObj) do 
						if obj.Parent ~= nil then 
							obj.Material = obj.OriginalMaterial.Value 
							obj.Color = obj.OriginalColor.Value 
						end 
					end 
				end 
			end) 
			self:Element("Slider", "scope blend", {min = 0, max = 100, default = 0}) 

			local ads = Client.updateads 
			Client.updateads = function(self, ...) 
				local args = {...} 
				coroutine.wrap(function() 
					wait() 
					if LocalPlayer.Character ~= nil then 
						for _,part in pairs(LocalPlayer.Character:GetDescendants()) do 
							if part:IsA("Part") or part:IsA("MeshPart") then 
								if part.Transparency ~= 1 then 
									part.Transparency = LocalPlayer.Character:FindFirstChild("AIMING") and values.visuals.self["scope blend"].Slider/100 or 0 
								end 
							end 
							if part:IsA("Accessory") then 
								part.Handle.Transparency = LocalPlayer.Character:FindFirstChild("AIMING") and values.visuals.self["scope blend"].Slider/100 or 0 
							end 
						end 
					end 
				end)() 
				return ads(self, ...) 
			end 

			local world = visuals:Sector("world", "Left") 
			world:Element("ToggleTrans", "molly radius", {default = {Color = COL3RGB(255,0,0)}}, function(tbl) 
				if RayIgnore:FindFirstChild("Fires") == nil then return end 
				if tbl.Toggle then 
					for i,fire in pairs(RayIgnore:FindFirstChild("Fires"):GetChildren()) do 
						fire.Transparency = tbl.Transparency 
						fire.Color = tbl.Color 
					end 
				else 
					for i,fire in pairs(RayIgnore:FindFirstChild("Fires"):GetChildren()) do 
						fire.Transparency = 1 
					end 
				end 
			end) 
			world:Element("ToggleColor", "smoke radius", {default = {Color = COL3RGB(0, 255, 0)}}, function(tbl) 
				if RayIgnore:FindFirstChild("Smokes") == nil then return end 
				if tbl.Toggle then 
					for i,smoke in pairs(RayIgnore:FindFirstChild("Smokes"):GetChildren()) do 
						smoke.Transparency = 0 
						smoke.Color = tbl.Color 
					end 
				else 
					for i,smoke in pairs(RayIgnore:FindFirstChild("Smokes"):GetChildren()) do 
						smoke.Transparency = 1 
					end 
				end 
			end)        
			
			world:Element("Dropdown", "hitsound", {options = {"-", "skeet", "neverlose", "rust", "bag", "baimware", "rit", "1nn", "oni-chan", "Bonk", "Welcome", "Semi", "osu", "Tf2", "Tf2 pan", "M55solix", "Slap","Minecraft", "jojo", "vibe", "supersmash", "epic", "retro", "quek"}}) 
			world:Element("Dropdown", "killsound", {options = {"-", "skeet", "neverlose", "rust", "bag", "baimware", "rit", "1nn", "oni-chan", "Bonk", "Welcome", "Semi", "osu", "Tf2", "Tf2 pan", "M55solix", "Slap","Minecraft", "jojo", "vibe", "supersmash", "epic", "retro", "quek"}}) 			
			world:Element("Slider", "sound volume", {min = 1, max = 1000000, default = 3}) 
			world:Element("Dropdown", "skybox", {options = {"-", "nebula", "vaporwave", "clouds"}}, function(tbl) 
				local sky = tbl.Dropdown 
				if sky ~= "-" then 
					if Lighting:FindFirstChildOfClass("Sky") then Lighting:FindFirstChildOfClass("Sky"):Destroy() end 
					local skybox = INST("Sky") 
					skybox.SkyboxLf = Skyboxes[sky].SkyboxLf 
					skybox.SkyboxBk = Skyboxes[sky].SkyboxBk 
					skybox.SkyboxDn = Skyboxes[sky].SkyboxDn 
					skybox.SkyboxFt = Skyboxes[sky].SkyboxFt 
					skybox.SkyboxRt = Skyboxes[sky].SkyboxRt 
					skybox.SkyboxUp = Skyboxes[sky].SkyboxUp 
					skybox.Name = "override" 
					skybox.Parent = Lighting 
				else 
					if Lighting:FindFirstChildOfClass("Sky") then Lighting:FindFirstChildOfClass("Sky"):Destroy() end 
					if oldSkybox ~= nil then oldSkybox:Clone().Parent = Lighting end 
				end 
			end) 
			world:Element("ToggleColor", "item esp", {default = {Color = COL3RGB(255, 255, 255)}}, function(tbl) 
				for i,weapon in pairs(workspace.Debris:GetChildren()) do 
					if weapon:IsA("BasePart") and Weapons:FindFirstChild(weapon.Name) then 
						weapon.BillboardGui.ImageLabel.Visible = tbl.Toggle and TBLFIND(values.visuals.world["types"].Jumbobox, "icon") and true or false 
					end 
				end 
			end) 
			world:Element("Jumbobox", "types", {options = {"icon"}}, function(tbl) 
				for i,weapon in pairs(workspace.Debris:GetChildren()) do 
					if weapon:IsA("BasePart") and Weapons:FindFirstChild(weapon.Name) then 
						weapon.BillboardGui.ImageLabel.Visible = values.visuals.world["item esp"].Toggle and TBLFIND(tbl.Jumbobox, "icon") and true or false 
						weapon.BillboardGui.ImageLabel.ImageColor3 = values.visuals.world["item esp"].Color 
					end 
				end 
			end) 
			local configs = misc:Sector("configs", "Left") 
			configs:Element("TextBox", "config", {placeholder = "config name"}) 
			configs:Element("Button", "save", {}, function() 
				if values.misc.configs.config.Text ~= "" then 
					library:SaveConfig(values.misc.configs.config.Text) 
				end 
			end) 
			configs:Element("Button", "load", {}, function() 
				if values.misc.configs.config.Text ~= "" then 
					ConfigLoad:Fire(values.misc.configs.config.Text) 
					createEventLog("Loaded ("..values.misc.configs.config.Text..".txt) !", 3)
				end 
			end) 
			local Crosshairss = misc:Sector("Crosshairss", "Right") 
			Crosshairss:Element("ToggleColor", "Enabled", {default = {Color = COL3RGB(255, 255, 0), Toggle = false}}, function(tbl)
				for i,v in next, crosshair2 do 
					v.Visible = tbl.Toggle
				end
				for i,v in next, crosshair2o do 
					v.Visible = tbl.Toggle
				end
				game:GetService("RunService").RenderStepped:Connect(function()
					PlayerGui.GUI.Crosshairs.Crosshair.Visible = false
				end)
				if tbl.Toggle then
					crosshair.Color = tbl.Color
				else
					crosshair.Color = clr(255, 255, 0)
				end
			end)
			Crosshairss:Element("Slider", "Speed", {min = 0, max = 800, default = 30}, function(tbl) 
				crosshair.Speed = tbl.Slider
			end)
			Crosshairss:Element("Slider", "Size", {min = 1, max = 400, default = 12}, function(tbl) 
				crosshair.Size = tbl.Slider
			end)
			Crosshairss:Element("Slider", "Gap", {min = 1, max = 400, default = 8}, function(tbl) 
				crosshair.Gap = tbl.Slider
			end)
			Crosshairss:Element("Slider", "Thickness", {min = 1, max = 55, default = 1}, function(tbl) 
				crosshair.Thickness = tbl.Slider
			end)

			local client = misc:Sector("client", "Right") 
            client:Element("Toggle", "auto join team")
            client:Element("Dropdown", "team", {options = {"CT", "T"}})

			client:Element("Toggle", "infinite cash", nil, function(tbl) 
				if tbl.Toggle then 
					LocalPlayer.Cash.Value = 8000 
				end 
			end) 
			client:Element("Toggle", "infinite crouch") 
			client:Element("Jumbobox", "damage bypass", {options = {"fire", "fall"}}) 
			client:Element("Jumbobox", "gun modifiers", {options = {"recoil", "spread", "reload", "equip", "ammo", "automatic", "penetration", "firerate", "kniferate"}}) 
			client:Element("Toggle", "remove killers", {}, function(tbl) 
				if tbl.Toggle then 
					if workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Killers") then 
						local clone = workspace:FindFirstChild("Map"):FindFirstChild("Killers"):Clone() 
						clone.Name = "KillersClone" 
						clone.Parent = workspace:FindFirstChild("Map") 

						workspace:FindFirstChild("Map"):FindFirstChild("Killers"):Destroy() 
					end 
				else 
					if workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("KillersClone") then 
						workspace:FindFirstChild("Map"):FindFirstChild("KillersClone").Name = "Killers" 
					end 
				end 
			end) 
			client:Element("ToggleColor", "hitmarker", {default = {Color = COL3RGB(255,255,255)}}) 
			client:Element("Toggle", "buy any grenade") 
			client:Element("Toggle", "chat alive") 
			client:Element("Jumbobox", "shop", {options = {"inf time", "anywhere"}}) 
			client:Element("Toggle", "anti spectate") 

			local oldgrenadeallowed = Client.grenadeallowed 
			Client.grenadeallowed = function(...) 
				if values.misc.client["buy any grenade"].Toggle then 
					return true 
				end 

				return oldgrenadeallowed(...) 
			end 

			local runService = game:GetService('RunService')
			local Stepped

			local movement = misc:Sector("movement", "Left") 
			movement:Element("Toggle", "bunny hop") 
			movement:Element("Dropdown", "direction", {options = {"forward", "directional", "directional 2"}}) 
			movement:Element("Dropdown", "type", {options = {"gyro", "cframe"}}) 
			movement:Element("Slider", "speed", {min = 15, max = 100, default = 40}) 
			movement:Element("ToggleKeybind", "jump bug") 
			movement:Element("ToggleKeybind", "edge jump") 
			movement:Element("ToggleKeybind", "edge bug") 
			movement:Element("ToggleKeybind", "walkspeed") 
			movement:Element("Slider", "walkspeed speed", {min = 15, max = 250, default = 40}) 
			movement:Element('ToggleKeybind', 'no launch')
			movement:Element('Slider', 'launch block (y velocity)', {min = 0, max = 100, default = 40})
            movement:Element("ToggleKeybind", "noclip", {}, function(tbl)
                if tbl.Toggle and tbl.Active and LocalPlayer.Character then
                    Fly = game:GetService("RunService").Stepped:Connect(function()
                        spawn(function()
                            pcall(function()
                                local speed = values.misc.movement["noclip speed"].Slider * 8
                                local velocity = Vector3.new(0, 1, 0)
            
                                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                    velocity = velocity + (Camera.CoordinateFrame.lookVector * speed)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                    velocity = velocity + (Camera.CoordinateFrame.rightVector * -speed)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                    velocity = velocity + (Camera.CoordinateFrame.lookVector * -speed)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                    velocity = velocity + (Camera.CoordinateFrame.rightVector * speed)
                                end
                                    
                                LocalPlayer.Character.HumanoidRootPart.Velocity = velocity
                                LocalPlayer.Character.Humanoid.PlatformStand = true
                            end)
                        end)
                    end)
            
                    Noclip = game:GetService("RunService").Stepped:Connect(function()
                        for i,v in pairs(LocalPlayer.Character:GetChildren()) do
                            if v:IsA("BasePart") and v.CanCollide == true then
                                v.CanCollide = false
                            end
                        end
                    end)
                else
                    pcall(function()
                        Fly:Disconnect()
                        Noclip:Disconnect()
                        LocalPlayer.Character.HumanoidRootPart.Velocity = -2.90707, 0.00781632, -11.7204
                        LocalPlayer.Character.Humanoid.PlatformStand = false
                        for i,v in pairs(LocalPlayer.Character:GetChildren()) do
                            if v:IsA("BasePart") and v.CanCollide == false then
                                v.CanCollide = true
                            end
                        end
                    end)
                end
            end)
            
            movement:Element("Slider", "noclip speed", {min = 1, max = 25, default = 1})

			local chat = misc:Sector("chat", "Left") 
			chat:Element('Toggle', 'chat spam', nil, function(tbl)
				if tbl.Toggle then
					while values.misc.chat['chat spam'].Toggle do
						game:GetService('ReplicatedStorage').Events.PlayerChatted:FireServer(textboxtriggers(values.misc.chat['spam message'].Text), false, 'Innocent', false, true)
						wait(values.misc.chat['speed (ms)'].Slider/1000)
					end
				end
			end)
			chat:Element('TextBox', 'spam message', {placeholder = 'message'})
			chat:Element('Slider', 'speed (ms)', {min = 150, max = 1000, default = 500})
			chat:Element('Toggle', 'random killsay', nil, function(tbl)
				if tbl.Toggle then
					local thing = tbl.Toggle


					if thing == true then
						wait(0.1)
						local chatmessages = {
							"Memzhack.pasted REWRITE on top!",
							"bro i hate this game so much",
							"this game is so ass",
							"honk kong lookin ass",
						}
						

						LocalPlayer.Status.Kills:GetPropertyChangedSignal("Value"):Connect(function(current)
							if current == 0 then return end
							game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer( chatmessages[math.random(1,table.getn(chatmessages))],false, "Innocent", false, true)
						end)
					end
				else
					thing = false
				end

			end) 
			chat:Element("Toggle", "kill say") 
			chat:Element("TextBox", "message", {placeholder = "message"}) 
			chat:Element("Toggle", "no filter") 


			local grenades = misc:Sector("grenades", "Right") 
			grenades:Element("ToggleKeybind", "spam grenades") 
			coroutine.wrap(function() 
				while true do 
					wait(0.5) 
					if values.misc.grenades["spam grenades"].Toggle and values.misc.grenades["spam grenades"].Active then 
						local oh1 = game:GetService("ReplicatedStorage").Weapons[values.misc.grenades.grenade.Dropdown].Model 
						local oh3 = 25 
						local oh4 = 35 
						local oh6 = "" 
						local oh7 = "" 
						game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(oh1, nil, oh3, oh4, Vec3(0,-100,0), oh6, oh7) 
					end 
				end 
			end)() 
			grenades:Element("Dropdown", "grenade", {options = {"Flashbang", "Smoke Grenade", "Molotov", "HE Grenade", "Decoy Grenade"}}) 
			grenades:Element("Button", "crash server", {}, function() 
				while true do
					pcall(function()
						game:GetService("RunService").RenderStepped:Wait()
						for i = 1,100,1 do	
							game:GetService("ReplicatedStorage").Events.DropMag:FireServer(LocalPlayer.Character.Gun.Mag)
						end
					end)
				end   
			end)  
			grenades:Element("Toggle", "anti-ping", {}, function(tbl)      
				spawn(function()
					while values.misc.grenades["anti-ping"].Toggle do
						pcall(function()
							game:GetService("RunService").RenderStepped:Wait()
							for i,v in pairs(workspace["Ray_Ignore"]:GetChildren()) do
								if v.Name == "MagDrop" then
									v:Destroy()
								end
							end
						end)
					end 
				end)    
			end) 

			local Dance = INST("Animation") 
			Dance.AnimationId = "rbxassetid://5917459365" 

			local LoadedAnim 

			local animations = misc:Sector("animations", "Right") 
			animations:Element("ToggleKeybind", "enabled", nil, function(tbl) 
				pcall(function() 
					LoadedAnim:Stop() 
				end) 
				if not tbl.Toggle or tbl.Toggle and not tbl.Active then 
				else 
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
						LoadedAnim = LocalPlayer.Character.Humanoid:LoadAnimation(Dance) 
						LoadedAnim.Priority = Enum.AnimationPriority.Action 
						LoadedAnim:Play() 
					end 
				end 
			end) 
			animations:Element("Dropdown", "animation", {options = {"floss", "default", "lil nas x", "dolphin", "monkey"}}, function(tbl) 
				Dance.AnimationId = tbl.Dropdown == "floss" and "rbxassetid://5917459365" or tbl.Dropdown == "default" and "rbxassetid://3732699835" or tbl.Dropdown == "lil nas x" and "rbxassetid://5938396308" or tbl.Dropdown == "dolphin" and "rbxassetid://5938365243" or tbl.Dropdown == "monkey" and "rbxassetid://3716636630" 

				pcall(function() 
					LoadedAnim:Stop() 
				end) 

				if values.misc.animations.enabled.Toggle and values.misc.animations.enabled.Active then 
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
						LoadedAnim = LocalPlayer.Character.Humanoid:LoadAnimation(Dance) 
						LoadedAnim.Priority = Enum.AnimationPriority.Action 
						LoadedAnim:Play() 
					end 
				end 
			end) 

				local addons = misc:Sector("addons", "Left") 

				addons:Element("Toggle", "status list", nil, function(tbl) 
					library:SetKeybindVisible(tbl.Toggle) 
				end)

				addons:Element("Toggle", "watermark", {default = {Toggle = true}}, function(tbl)
					for i,v in next, watermark do 
						v.Visible = tbl.Toggle
					end
				end)
				
				addons:Element("Slider", "Pos X", {min = 0, max = 1800, default = 55}) 
				addons:Element("Slider", "Pos Y", {min = 0, max = 1800, default = 15})

				addons:Element("Toggle", "spectators list", {default = {Toggle = false}}, function(tbl)
					for i,v in next, spectator do 
						v.Visible = tbl.Toggle
					end
				end)

				addons:Element("Slider", "Pos X2", {min = 0, max = 1800, default = 55}) 
				addons:Element("Slider", "Pos Y2", {min = 0, max = 1800, default = 180}) 					
				
				addons:Element('ToggleColor', 'Menu Accent', {default = {Toggle = true, Color = COL3RGB(172, 208, 255)}}, function(tbl)
					if tbl.Toggle then
						theme.accent = tbl.Color
					else
						theme.accent = Color3.fromRGB(172, 208, 255)
					end
				end)
				
				addons:Element("TextBox", "mnt", {placeholder = "Custom cheat name"}, function()
					game:GetService("CoreGui")["electric boogalo"].Menu.top.cheatname.Text = "  " ..values.misc.addons.mnt.Text
					cheatnamel = values.misc.addons.mnt.Text
				end)

				local ui = misc:Sector("ui", "Right") 
				ui:Element("Toggle", "scaling") 
				ui:Element("Slider", "amount", {min = 5, max = 11, default = 10}) 

				createEventLog("Welcome to Memzhack.pasted!", 3)
				wait(0.5)
				createEventLog("Press INSERT to open and close the menu!", 3)
				createEventLog("!!!  IMPORTANT  !!!\n This script is in beta version,\n there may be a lot of cheat bugs!\n Report any issues to Memz!", 25)

			local objects = {} 
			local utility = {} 
			do 
				utility.default = { 
					Line = { 
						Thickness = 1.5, 
						Color = COL3RGB(255, 255, 255), 
						Visible = false 
					}, 
					Text = { 
						Size = 13, 
						Center = true, 
						Outline = true, 
						Font = Drawing.Fonts.Plex, 
						Color = COL3RGB(255, 255, 255), 
						Visible = false 
					}, 
					Square = { 
						Thickness = 1.5, 
						Filled = false, 
						Color = COL3RGB(255, 255, 255), 
						Visible = false 
					}, 
				} 
				function utility.create(type, isOutline) 
					local drawing = Drawing.new(type) 
					for i, v in pairs(utility.default[type]) do 
						drawing[i] = v 
					end 
					if isOutline then 
						drawing.Color = COL3(0,0,0) 
						drawing.Thickness = 3 
					end 
					return drawing 
				end 
				function utility.add(plr) 
					if not objects[plr] then 
						objects[plr] = { 
							Name = utility.create("Text"), 
							Weapon = utility.create("Text"), 
							Armor = utility.create("Text"), 
							BoxOutline = utility.create("Square", true), 
							Box = utility.create("Square"), 
							HealthOutline = utility.create("Line", true), 
							Health = utility.create("Line"), 
						} 
					end 
				end 
				for _,plr in pairs(Players:GetPlayers()) do 
					if Player ~= LocalPlayer then 
						utility.add(plr) 
					end 
				end 
				Players.PlayerAdded:Connect(utility.add) 
				Players.PlayerRemoving:Connect(function(plr) 
					wait() 
					if objects[plr] then 
						for i,v in pairs(objects[plr]) do 
							for i2,v2 in pairs(v) do 
								if v then 
									v:Remove() 
								end 
							end 
						end 

						objects[plr] = nil 
					end 
				end) 
			end 
			local Items = INST("ScreenGui") 
			Items.Name = "Items" 
			Items.Parent = game.CoreGui 
			Items.ResetOnSpawn = false 
			Items.ZIndexBehavior = "Global" 
			do 
				function add(plr) 
					local ImageLabel = INST("ImageLabel") 
					ImageLabel.BackgroundColor3 = COL3RGB(255, 255, 255) 
					ImageLabel.BackgroundTransparency = 1.000 
					ImageLabel.Size = UDIM2(0, 62, 0, 25) 
					ImageLabel.Visible = false 
					ImageLabel.Image = "rbxassetid://1784884358" 
					ImageLabel.ScaleType = Enum.ScaleType.Fit 
					ImageLabel.Name = plr.Name 
					ImageLabel.AnchorPoint = Vec2(0.5,0.5) 
					ImageLabel.Parent = Items 
				end 
				for _,plr in pairs(Players:GetPlayers()) do 
					if Player ~= LocalPlayer then 
						add(plr) 
					end 
				end 
				Players.PlayerAdded:Connect(add) 
				Players.PlayerRemoving:Connect(function(plr) 
					wait() 
					Items[plr.Name]:Destroy() 
				end) 
			end 
			local debrisitems = {} 
			workspace.Debris.ChildAdded:Connect(function(obj) 
				if obj:IsA("BasePart") and Weapons:FindFirstChild(obj.Name) then 
					RunService.RenderStepped:Wait() 

					local BillboardGui = INST("BillboardGui") 
					BillboardGui.AlwaysOnTop = true 
					BillboardGui.Size = UDIM2(0, 40, 0, 40) 
					BillboardGui.Adornee = obj 

					local ImageLabel = INST("ImageLabel") 
					ImageLabel.Parent = BillboardGui 
					ImageLabel.BackgroundTransparency = 1 
					ImageLabel.Size = UDIM2(1, 0, 1, 0) 
					ImageLabel.ImageColor3 = values.visuals.world["item esp"].Color 
					ImageLabel.Image = GetIcon.getWeaponOfKiller(obj.Name) 
					ImageLabel.ScaleType = Enum.ScaleType.Fit 
					ImageLabel.Visible = values.visuals.world["item esp"].Toggle and TBLFIND(values.visuals.world["types"].Jumbobox, "icon") and true or false 

					BillboardGui.Parent = obj 
				end 
			end) 
			for _, obj in pairs(workspace.Debris:GetChildren()) do 
				if obj:IsA("BasePart") and Weapons:FindFirstChild(obj.Name) then 
					RunService.RenderStepped:Wait() 

					local BillboardGui = INST("BillboardGui") 
					BillboardGui.AlwaysOnTop = true 
					BillboardGui.Size = UDIM2(0, 40, 0, 40) 
					BillboardGui.Adornee = obj 

					local ImageLabel = INST("ImageLabel") 
					ImageLabel.Parent = BillboardGui 
					ImageLabel.BackgroundTransparency = 1 
					ImageLabel.Size = UDIM2(1, 0, 1, 0) 
					ImageLabel.ImageColor3 = values.visuals.world["item esp"].Color 
					ImageLabel.Image = GetIcon.getWeaponOfKiller(obj.Name) 
					ImageLabel.ScaleType = Enum.ScaleType.Fit 
					ImageLabel.Visible = values.visuals.world["item esp"].Toggle and TBLFIND(values.visuals.world["types"].Jumbobox, "icon") and true or false 

					BillboardGui.Parent = obj 
				end 
			end 
			local function YROTATION(cframe) 
				local x, y, z = cframe:ToOrientation() 
				return CF(cframe.Position) * CFAngles(0,y,0) 
			end 
			local function XYROTATION(cframe) 
				local x, y, z = cframe:ToOrientation() 
				return CF(cframe.Position) * CFAngles(x,y,0) 
			end 
			local weps = { 
				Pistol = {"USP", "P2000", "Glock", "DualBerettas", "P250", "FiveSeven", "Tec9", "CZ", "DesertEagle", "R8"}, 
				SMG = {"MP9", "MAC10", "MP7", "UMP", "P90", "Bizon"}, 
				Rifle = {"M4A4", "M4A1", "AK47", "Famas", "Galil", "AUG", "SG"}, 
				Sniper = {"AWP", "Scout", "G3SG1"} 
			} 
			local weps2 = { 
				Pistol = {"USP", "P2000", "Glock", "DualBerettas", "P250", "FiveSeven", "Tec9", "CZ", "DesertEagle", "R8"}, 
				SMG = {"MP9", "MAC10", "MP7", "UMP", "P90", "Bizon"}, 
				Rifle = {"M4A4", "M4A1", "AK47", "Famas", "Galil", "AUG", "SG"}, 
				Sniper = {"AWP", "Scout", "G3SG1"} 
			} 
			local function GetWeaponRage(weapon) 
				return TBLFIND(weps.Pistol, weapon) and "pistol" or TBLFIND(weps.Rifle, weapon) and "rifle" or weapon == "AWP" and "awp" or weapon == "G3SG1"  and "auto" or weapon == "Scout" and "scout" or "default" 
			end 
			local function GetStatsRage(weapon) 
				if weapon == "default" then 
					return values.rage.weapons.default 
				else 
					if values.rage.weapons[weapon]["override default"].Toggle then 
						return values.rage.weapons[weapon] 
					else 
						return values.rage.weapons.default 
					end 
				end 
			end 
			local Jitter = false 
			allowedtofreeze = true
			local Spin = 0 
			local RageTarget 
			local Filter = false 
			local LastStep 
			local TriggerDebounce = false 
			local DisableAA = false 
			aroundtheworld_value = 0

			RunService.RenderStepped:Connect(function(step) 
				LastStep = step 
				Ping = game.Stats.PerformanceStats.Ping:GetValue() 
				RageTarget = nil 
				local CamCFrame = Camera.CFrame 
				local CamLook = CamCFrame.LookVector 
				local PlayerIsAlive = false 
				local Character = LocalPlayer.Character 
				RageTarget = nil 
				Spin = CLAMP(Spin + values.rage.angles["spin speed"].Slider, 0, 360) 
				if Spin == 360 then Spin = 0 end 
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 and LocalPlayer.Character:FindFirstChild("UpperTorso") then 
					PlayerIsAlive = true 
				end 
				for i,v in pairs(ChamItems) do 
					if v.Parent == nil then 
						TBLREMOVE(ChamItems, i) 
					end 
				end 
				if values.rage.others["fake duck"].Toggle then
						for i,v in pairs(debug.getupvalues(Client.setcharacter)) do
							if type(v) == "userdata" and v.ClassName == "AnimationTrack" and v.Name == "Idle" then
								CrouchAnim = v
							end
						end
						if values.rage.others["fake duck"].Active then
							CrouchAnim:Play()
						else
							CrouchAnim:Stop()
						end
					end
				if PlayerIsAlive then 
					local SelfVelocity = LocalPlayer.Character.HumanoidRootPart.Velocity 
					if values.rage.fakelag["ping spike"].Toggle and values.rage.fakelag["ping spike"].Active then 
						for count = 1, 20  do 
							game:GetService("ReplicatedStorage").Events.RemoteEvent:FireServer({[1] = "createparticle", [2] = "bullethole", [3] = LocalPlayer.Character.Head, [4] = Vec3(0,0,0)}) 
						end 
					end 
					local Root = LocalPlayer.Character.HumanoidRootPart 
					if values.misc.client["infinite crouch"].Toggle then 
						Client.crouchcooldown = 0 
					end 
                    if values.misc.client["auto join team"].Toggle then
                        game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer(values.misc.client["team"].Dropdown)
                    end
					if TBLFIND(values.misc.client["gun modifiers"].Jumbobox, "firerate") then 
						Client.DISABLED = false 
					end 
					if values.rage.exploits["kill all"].Toggle and values.rage.exploits["kill all"].Active and LocalPlayer.Character:FindFirstChild("UpperTorso") and LocalPlayer.Character:FindFirstChild("Gun") then
						for b2, b3 in pairs(game:GetService("Players"):GetChildren()) do
                            if b3.Team ~= b3.Parent.LocalPlayer.Team then
                                if b3.Character and b3.Character:FindFirstChild("UpperTorso") and b3.Parent.LocalPlayer.Character and b3.Parent.LocalPlayer.Character:FindFirstChild("EquippedTool") then
                                    if b3.Character:FindFirstChild("Humanoid") and b3.Character.Humanoid.Health > 0 then
                                        killallisworking = true
                                        local b4 = {
                                            [1] = b3.Character.Head,
                                            [2] = b3.Character.Head.Position,
                                            [3] = LocalPlayer.Character.EquippedTool.Value,
                                            [4] = 1,
                                            [5] = nil,
                                            [8] = 10,
                                            [9] = true,
                                            [10] = false,
                                            [11] = Vector3.new(),
                                            [12] = 1,
                                            [13] = Vector3.new()
                                        }
                                        game.ReplicatedStorage.Events.HitPart:FireServer(unpack(b4))
                                    else killallisworking = false end
                                end
                            end
                        end
					else killallisworking = false end
									
					if TBLFIND(values.misc.client["gun modifiers"].Jumbobox, "kniferate") and Client.gun:FindFirstChild("Melee") then
            		    Client.DISABLED = false 
                	end
					if values.rage.exploits["Funny moment"].Toggle and LocalPlayer.Character:FindFirstChild("Gun") then
						for _,Player in pairs(Players:GetPlayers()) do
							game:GetService("ReplicatedStorage").Events.Whizz:FireServer(Player)
						end
					end
					if TBLFIND(values.visuals.effects.removals.Jumbobox, "scope lines") then 
						NewScope.Enabled = LocalPlayer.Character:FindFirstChild("AIMING") and true or false 
						Crosshairs.Scope.Visible = false 
					else 
						NewScope.Enabled = false 
					end 
					local RageGuy 
					if workspace:FindFirstChild("Map") and Client.gun ~= nil and Client.gun ~= "-" and Client.gun.Name ~= "C4" then
						if values.rage.aimbot.enabled.Toggle then 
							local Origin = values.rage.aimbot.origin.Dropdown == "character" and LocalPlayer.Character.LowerTorso.Position + Vec3(0, 2.5, 0) or CamCFrame.p 
							local Stats = GetStatsRage(GetWeaponRage(Client.gun.Name)) 
							for _,Player in pairs(Players:GetPlayers()) do 
								if TBLFIND(values.misc.client["gun modifiers"].Jumbobox, "firerate") then 
									Client.DISABLED = false 
								end
								if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Humanoid").Health > 0 and Player.Team ~= "TTT" and Player ~= LocalPlayer then      
									if TBLFIND(values.rage.aimbot.resolver.Jumbobox, 'pitch') then
										Player.Character.UpperTorso.Waist.C0 = CFrame.new(0, 0.5 * (values.rage.aimbot['forward track distance'].Slider / 10), 0)
										Player.Character.Head.Neck.C0 = CFrame.new(0, 0.7 * (values.rage.aimbot['forward track distance'].Slider / 10), 0)
									end
									if TBLFIND(values.rage.aimbot.resolver.Jumbobox, 'roll') then
										Player.Character.Humanoid.MaxSlopeAngle = 0
									end
									if TBLFIND(values.rage.aimbot.resolver.Jumbobox, 'arms') then
										Player.Character.RightUpperArm:FindFirstChildWhichIsA('Motor6D').C0 = CFrame.new(1.5 * (values.rage.aimbot['forward track distance'].Slider / 10), 0.549999952, -0.2)
										Player.Character.LeftUpperArm:FindFirstChildWhichIsA('Motor6D').C0 = CFrame.new(-(1.5 * (values.rage.aimbot['forward track distance'].Slider / 10)), 0.549999952, -0.2)
									end
									if TBLFIND(values.rage.aimbot.resolver.Jumbobox, 'animation') then
										for a, b in next, Player.Character.Humanoid:GetPlayingAnimationTracks() do
											b:Stop()
										end
									end
								end      
                                if Player.Character and Player.Character:FindFirstChild("Humanoid") and not Client.DISABLED and Player.Character:FindFirstChild("Humanoid").Health > 0 and Player.Team ~= "TTT" and not Player.Character:FindFirstChildOfClass("ForceField") and GetDeg(CamCFrame, Player.Character.Head.Position) <= Stats["max fov"].Slider and Player ~= LocalPlayer then 
									if Player.Team ~= LocalPlayer.Team or values.rage.aimbot.teammates.Toggle and Player:FindFirstChild("Status") and Player.Status.Team.Value ~= LocalPlayer.Status.Team.Value and Player.Status.Alive.Value then 
										if Client.gun:FindFirstChild("Melee") and values.rage.aimbot["knifebot"].Toggle then
											local AutoPeek = {OldPeekPosition = CFrame.new()}
											AutoPeek.OldPeekPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
											if values.rage.exploits["otw knife"].Toggle and values.rage.exploits["otw knife"].Active then 
												for i,v in next, Players:GetChildren() do
													if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team then
														if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
															aroundtheworld_value=aroundtheworld_value + (0.01 * 2)
															LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame*CFrame.Angles(0, aroundtheworld_value, 0)*CFrame.new(0, 0, 500)
															break
														end
													end
												end
											else
												LocalPlayer.Character.HumanoidRootPart.CFrame = AutoPeek.OldPeekPosition
											end
											local Ignore = {unpack(Collision)}
											if values.rage.aimbot["type"].Dropdown == "rapid" then
												Client.DISABLED = false
											end
											if not values.rage.aimbot["wallcheck"].Toggle then
												table.insert(Ignore, game.Workspace.Map)
											end
											INSERT(Ignore, workspace.Map.Clips)
											INSERT(Ignore, workspace.Map.SpawnPoints)
											INSERT(Ignore, LocalPlayer.Character)
											INSERT(Ignore, Player.Character.HumanoidRootPart)
											if Player.Character:FindFirstChild("BackC4") then
												INSERT(Ignore, Player.Character.BackC4)
											end
											if Player.Character:FindFirstChild("Gun") then
												INSERT(Ignore, Player.Character.Gun)
											end

											local Ray = Ray.new(Origin, (Player.Character.HumanoidRootPart.Position - Origin).unit * values.rage.aimbot["Radius"].Slider)
											local Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Ray, Ignore, false, true)

											if Hit and Hit.Parent == Player.Character then                                    
												RageGuy = Hit
												RageTarget = Hit
												Filter = true
												local oh1 = Hit
												local oh2 = Hit.Position
												local oh3 = Client.gun.Name
												local oh4 = 1
												local oh5 = nil
												local oh8 = 100
												local oh9 = true
												local oh10 = false
												local oh11 = Vector3.new()
												local oh12 = 1
												local oh13 = Vector3.new()
												game:GetService("ReplicatedStorage").Events.HitPart:FireServer(oh1, oh2, oh3, oh4, oh5, oh6, oh7, oh8, oh9, oh10, oh11, oh12, oh13)
											end
										else
											local Ignore = {unpack(Collision)}
											INSERT(Ignore, workspace.Map.Clips)
											INSERT(Ignore, workspace.Map.SpawnPoints)
											INSERT(Ignore, LocalPlayer.Character)
											INSERT(Ignore, Player.Character.HumanoidRootPart)
											if Player.Character:FindFirstChild("BackC4") then
												INSERT(Ignore, Player.Character.BackC4)
											end
											if Player.Character:FindFirstChild("Gun") then
												INSERT(Ignore, Player.Character.Gun)
											end
			
											local Hitboxes = {}
											for _,Hitbox in ipairs(Stats.hitboxes.Jumbobox) do
													if Hitbox == "head" then
														INSERT(Hitboxes, Player.Character:FindFirstChild("Head"))
													elseif Hitbox == "torso" then
														INSERT(Hitboxes, Player.Character.UpperTorso)
													elseif Hitbox == "arms" then
														INSERT(Hitboxes, Player.Character.LeftUpperArm)
														INSERT(Hitboxes, Player.Character.RightUpperArm)
													elseif Hitbox == "hand" then
														INSERT(Hitboxes, Player.Character.LeftHand)
														INSERT(Hitboxes, Player.Character.RightHand)
													else
														INSERT(Hitboxes, Player.Character.LowerTorso) 
												end
											end
			
											for _,Hitbox in ipairs(Hitboxes) do
												local wallbang = false
												local Ignore2 = {unpack(Ignore)}
												for _,Part in next, Player.Character:GetChildren() do
													if Part ~= Hitbox then INSERT(Ignore2, Part) end
												end
			
												for a,b in next, game.Players:GetChildren() do 
													if b ~= Player and b.Character then
														for i, h in next, b.Character:GetChildren() do 
															INSERT(Ignore2, h)
														end
													end 
												end
			
												if values.rage.aimbot["wallbang"].Toggle then
													local Hits = {}
													local EndHit, Hit, Pos
													
													local Ray1 = RAY(Origin, (Hitbox.Position  - Origin).unit * (Hitbox.Position - Origin).magnitude)
													repeat
														Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Ray1, Ignore2, false, true)
														if Hit ~= nil and Hit.Parent ~= nil then
															if Hit and Multipliers[Hit.Name] ~= nil then
																EndHit = Hit
															else
																INSERT(Ignore2, Hit)
																INSERT(Hits, {["Position"] = Pos,["Hit"] = Hit})
															end
														end
													until EndHit ~= nil or #Hits >= 4 or Hit == nil 
													
													if EndHit ~= nil and Multipliers[EndHit.Name] ~= nil and #Hits <= 4 then
														if #Hits == 0 then
															local Damage = Client.gun.DMG.Value * Multipliers[EndHit.Name]
															if Player:FindFirstChild("Kevlar") then
																if FIND(EndHit.Name, "Head") then
																	if Player:FindFirstChild("Helmet") then
																		Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value
																	end
																else
																	Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value
																end
															end
															Damage = Damage * (Client.gun.RangeModifier.Value/100 ^ ((Origin - EndHit.Position).Magnitude/500))/100
															if Damage >= Stats["minimum damage"].Slider then
																RageGuy = EndHit
																RageTarget = EndHit
																if values.rage.aimbot["automatic fire"].Dropdown == "standard" then 
																	Client.firebullet() 
                                                                    if values.rage.exploits["double tap"].Toggle and values.rage.exploits["double tap"].Active then 
                                                                        Client.firebullet() 
                                                                    end 
																	if values.rage.aimbot["ragebot logs"].Toggle then
																		createEventLog("Shot at "..EndHit.Parent.Name.." in the "..EndHit.Name, values.rage.aimbot["log time"].Slider)
																	end
																	elseif values.rage.aimbot["automatic fire"].Dropdown == "hitpart" then
																	if values.rage.aimbot["ragebot logs"].Toggle then
																		createEventLog("Shot at "..EndHit.Parent.Name.." in the "..EndHit.Name, values.rage.aimbot["log time"].Slider)
																	end
																	Client.firebullet()
																	local Arguments = {
																		[1] = EndHit,
																		[2] = EndHit.Position,
																		[3] = LocalPlayer.Character.EquippedTool.Value,
																		[4] = 100,
																		[5] = LocalPlayer.Character.Gun,
																		[8] = 1,
																		[9] = false,
																		[10] = false,
																		[11] = Vec3(),
																		[12] = 100,
																		[13] = Vec3()
																	}
																	game.ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments))
                                                                    if values.rage.exploits["double tap"].Toggle and values.rage.exploits["double tap"].Active then 
                                                                        Client.firebullet() 
                                                                        local Arguments = { 
                                                                            [1] = EndHit, 
                                                                            [2] = EndHit.Position, 
                                                                            [3] = LocalPlayer.Character.EquippedTool.Value, 
                                                                            [4] = 100, 
                                                                            [5] = LocalPlayer.Character.Gun, 
                                                                            [8] = 1, 
                                                                            [9] = false, 
                                                                            [10] = false, 
                                                                            [11] = Vec3(), 
                                                                            [12] = 100, 
                                                                            [13] = Vec3() 
                                                                        } 
                                                                        game.ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments)) 
                                                                    end  
																end
																Filter = false
																break
															end
														else 
															local penetration = Client.gun.Penetration.Value * (0.01 * values.rage.aimbot["wallbang amount"].Slider)
															local limit = 0 
															local dmgmodifier = 1 
															for i = 1, #Hits do 
																local data = Hits[i] 
																local part = data["Hit"] 
																local pos = data["Position"] 
																local modifier = 1 
																if part.Material == Enum.Material.DiamondPlate then 
																	modifier = 3 
																end 
																if part.Material == Enum.Material.CorrodedMetal or part.Material == Enum.Material.Metal or part.Material == Enum.Material.Concrete or part.Material == Enum.Material.Brick then 
																	modifier = 2 
																end 
																if part.Name == "Grate" or part.Material == Enum.Material.Wood or part.Material == Enum.Material.WoodPlanks then 
																	modifier = 0.1 
																end 
																if part.Name == "nowallbang" then 
																	modifier = 100 
																end 
																if part:FindFirstChild("PartModifier") then 
																	modifier = part.PartModifier.Value 
																end 
																if part.Transparency == 1 or part.CanCollide == false or part.Name == "Glass" or part.Name == "Cardboard" then 
																	modifier = 0 
																end 
																local direction = (Hitbox.Position - pos).unit * CLAMP(Client.gun.Range.Value, 1, 100) 
																local ray = RAY(pos + direction * 1, direction * -2) 
																local _,endpos = workspace:FindPartOnRayWithWhitelist(ray, {part}, true) 
																local thickness = (endpos - pos).Magnitude 
																thickness = thickness * modifier 
																limit = MIN(penetration, limit + thickness) 
																dmgmodifier = 1 - limit / penetration 
															end 
															local Damage = Client.gun.DMG.Value * Multipliers[EndHit.Name] * dmgmodifier 
															if Player:FindFirstChild("Kevlar") then 
																if FIND(EndHit.Name, "Head") then 
																	if Player:FindFirstChild("Helmet") then 
																		Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value 
																	end 
																else 
																	Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value 
																end 
															end 
															Damage = Damage * (Client.gun.RangeModifier.Value/100 ^ ((Origin - EndHit.Position).Magnitude/500))/100 
															if Damage >= Stats["minimum damage"].Slider then 
																RageGuy = EndHit 
																RageTarget = EndHit 
																Filter = true 
																if values.rage.aimbot["automatic fire"].Dropdown == "standard" then 
																	Client.firebullet() 
                                                                    if values.rage.exploits["double tap"].Toggle and values.rage.exploits["double tap"].Active then 
                                                                        Client.firebullet() 
                                                                    end 
																	if values.rage.aimbot["ragebot logs"].Toggle then
																		createEventLog("Shot at "..EndHit.Parent.Name.." in the "..EndHit.Name, values.rage.aimbot["log time"].Slider)
																	end
																	elseif values.rage.aimbot["automatic fire"].Dropdown == "hitpart" then
																	if values.rage.aimbot["ragebot logs"].Toggle then
																		createEventLog("Shot at "..EndHit.Parent.Name.." in the "..EndHit.Name, values.rage.aimbot["log time"].Slider)
																	end
																	Client.firebullet() 
																	local Arguments = { 
																		[1] = EndHit, 
																		[2] = EndHit.Position, 
																		[3] = LocalPlayer.Character.EquippedTool.Value, 
																		[4] = 100, 
																		[5] = LocalPlayer.Character.Gun, 
																		[8] = 1, 
																		[9] = false, 
																		[10] = false, 
																		[11] = Vec3(), 
																		[12] = 100, 
																		[13] = Vec3() 
																	} 
																	game.ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments)) 
                                                                    if values.rage.exploits["double tap"].Toggle and values.rage.exploits["double tap"].Active then 
                                                                        Client.firebullet() 
                                                                        local Arguments = { 
                                                                            [1] = EndHit, 
                                                                            [2] = EndHit.Position, 
                                                                            [3] = LocalPlayer.Character.EquippedTool.Value, 
                                                                            [4] = 100, 
                                                                            [5] = LocalPlayer.Character.Gun, 
                                                                            [8] = 1, 
                                                                            [9] = false, 
                                                                            [10] = false, 
                                                                            [11] = Vec3(), 
                                                                            [12] = 100, 
                                                                            [13] = Vec3() 
                                                                        } 
                                                                        game.ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments)) 
                                                                    end 
																end
																Filter = false 
																break 
															end 
														end 
													end 
												else 
													local Ray = RAY(Origin, (Hitbox.Position - Origin).unit * (Hitbox.Position - Origin).magnitude) 
													local Hit, Pos = workspace:FindPartOnRayWithIgnoreList(Ray, Ignore2, false, true) 
													if Hit and Multipliers[Hit.Name] ~= nil then 
														local Damage = Client.gun.DMG.Value * Multipliers[Hit.Name] 
														if Player:FindFirstChild("Kevlar") then 
															if FIND(Hit.Name, "Head") then 
																if Player:FindFirstChild("Helmet") then 
																	Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value 
																end 
															else 
																Damage = (Damage / 100) * Client.gun.ArmorPenetration.Value 
															end 
														end 
														Damage = Damage * (Client.gun.RangeModifier.Value/100 ^ ((Origin - Hit.Position).Magnitude/500)) 
														if Damage >= Stats["minimum damage"].Slider then 
															RageGuy = Hit 
															RageTarget = Hit 
															Filter = true 
															if values.rage.aimbot["automatic fire"].Dropdown == "standard" then 
																Client.firebullet() 
																if values.rage.exploits["double tap"].Toggle and values.rage.exploits["double tap"].Active then 
																	Client.firebullet() 
																end 
																if values.rage.aimbot["ragebot logs"].Toggle then
																		createEventLog("Shot at "..EndHit.Parent.Name.." in the "..EndHit.Name, values.rage.aimbot["log time"].Slider)
																	end
																	elseif values.rage.aimbot["automatic fire"].Dropdown == "hitpart" then
																	if values.rage.aimbot["ragebot logs"].Toggle then
																		createEventLog("Shot at "..EndHit.Parent.Name.." in the "..EndHit.Name, values.rage.aimbot["log time"].Slider)
																	end 
																Client.firebullet() 
																local Arguments = { 
																	[1] = EndHit, 
																	[2] = EndHit.Position, 
																	[3] = LocalPlayer.Character.EquippedTool.Value, 
																	[4] = 100, 
																	[5] = LocalPlayer.Character.Gun, 
																	[8] = 1, 
																	[9] = false, 
																	[10] = false, 
																	[11] = Vec3(), 
																	[12] = 100, 
																	[13] = Vec3() 
																} 
																game.ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments)) 
																if values.rage.exploits["double tap"].Toggle and values.rage.exploits["double tap"].Active then 
																	Client.firebullet() 
																	local Arguments = { 
																		[1] = EndHit, 
																		[2] = EndHit.Position, 
																		[3] = LocalPlayer.Character.EquippedTool.Value, 
																		[4] = 100, 
																		[5] = LocalPlayer.Character.Gun, 
																		[8] = 1, 
																		[9] = false, 
																		[10] = false, 
																		[11] = Vec3(), 
																		[12] = 100, 
																		[13] = Vec3() 
																	} 
																	game.ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments)) 
																end 
															end 
															Filter = false 
															break 
														end 
													end 
												end 
											end 
										end 
									end 
								end 
							end 
						end 
					end 
					BodyVelocity:Destroy() 
					BodyVelocity = INST("BodyVelocity") 
					BodyVelocity.MaxForce = Vec3(HUGE,0,HUGE) 
					if UserInputService:IsKeyDown("Space") and values.misc.movement["bunny hop"].Toggle then 
						local add = 0 
						if values.misc.movement.direction.Dropdown == "directional" or values.misc.movement.direction.Dropdown == "directional 2" then 
							if UserInputService:IsKeyDown("A") then add = 90 end 
							if UserInputService:IsKeyDown("S") then add = 180 end 
							if UserInputService:IsKeyDown("D") then add = 270 end 
							if UserInputService:IsKeyDown("A") and UserInputService:IsKeyDown("W") then add = 45 end 
							if UserInputService:IsKeyDown("D") and UserInputService:IsKeyDown("W") then add = 315 end 
							if UserInputService:IsKeyDown("D") and UserInputService:IsKeyDown("S") then add = 225 end 
							if UserInputService:IsKeyDown("A") and UserInputService:IsKeyDown("S") then add = 145 end 
						end 
						local rot = YROTATION(CamCFrame) * CFAngles(0,RAD(add),0) 
						BodyVelocity.Parent = LocalPlayer.Character.UpperTorso 
						LocalPlayer.Character.Humanoid.Jump = true 
						BodyVelocity.Velocity = Vec3(rot.LookVector.X,0,rot.LookVector.Z) * (values.misc.movement["speed"].Slider * 2) 
						if add == 0 and values.misc.movement.direction.Dropdown == "directional" and not UserInputService:IsKeyDown("W") then 
							BodyVelocity:Destroy() 
						else 
							if values.misc.movement.type.Dropdown == "cframe" then 
								BodyVelocity:Destroy() 
								Root.CFrame = Root.CFrame + Vec3(rot.LookVector.X,0,rot.LookVector.Z) * values.misc.movement["speed"].Slider/50 
							end 
						end 
					end 
					if values.misc.movement['no launch'].Toggle and values.misc.movement['no launch'].Active then 
						if Root.Velocity.Y > values.misc.movement['launch block (y velocity)'].Slider then 
							Root.Velocity = Vector3.new(Root.Velocity.x, 0, Root.Velocity.z)
						end
					end
					if values.misc.movement["edge jump"].Toggle and values.misc.movement["edge jump"].Active then 
						if LocalPlayer.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and LocalPlayer.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then 
							coroutine.wrap(function() 
								RunService.RenderStepped:Wait() 
								if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and LocalPlayer.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then 
									LocalPlayer.Character.Humanoid:ChangeState("Jumping") 
								end 
							end)() 
						end 
					end 
					Jitter = not Jitter 
					LocalPlayer.Character.Humanoid.AutoRotate = false 
					if values.rage.angles.enabled.Toggle and not DisableAA then 
						local Angle = -ATAN2(CamLook.Z, CamLook.X) + RAD(-90) 
						if values.rage.angles["yaw base"].Dropdown == "spin" then 
							Angle = Angle + RAD(Spin) 
						end 
						if values.rage.angles["yaw base"].Dropdown == "random" then 
							Angle = Angle + RAD(RANDOM(0, 360)) 
						end 
						local Offset = RAD(-values.rage.angles["yaw offset"].Slider - (values.rage.angles.jitter.Toggle and Jitter and values.rage.angles["jitter offset"].Slider or values.rage.angles["Fake flick"].Toggle and shotthingy and values.rage.angles["offset"].Slider or 0))
						local CFramePos = CF(Root.Position) * CFAngles(0, Angle + Offset, 0) 
						if values.rage.angles["yaw base"].Dropdown == "targets" then 
							local part 
							local closest = 9999 
							for _,plr in pairs(Players:GetPlayers()) do 
								if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Humanoid").Health > 0 and plr.Team ~= LocalPlayer.Team then 
									local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position) 
									local magnitude = (Vec2(pos.X, pos.Y) - Vec2(Mouse.X, Mouse.Y)).Magnitude 
									if closest > magnitude then 
										part = plr.Character.HumanoidRootPart 
										closest = magnitude 
									end 
								end 
							end 
							if part ~= nil then 
								CFramePos = CF(Root.Position, part.Position) * CFAngles(0, Offset, 0) 
							end 
						end 

						Root.CFrame = YROTATION(CFramePos) 
						if values.rage.angles["body roll"].Dropdown == "180" then 
							Root.CFrame = Root.CFrame * CFAngles(values.rage.angles["body roll"].Dropdown == "180" and RAD(180) or 0, 1, 0) 
							LocalPlayer.Character.Humanoid.HipHeight = 4 
						else 
							LocalPlayer.Character.Humanoid.HipHeight = 2 
						end 

						local Pitch = values.rage.angles["pitch"].Dropdown == "zero" and 0 or values.rage.angles["pitch"].Dropdown == "up" and 1 or values.rage.angles["pitch"].Dropdown == "down" and -1 or values.rage.angles["pitch"].Dropdown == "180v2" and 2 or values.rage.angles["pitch"].Dropdown == "180v3" and -9 or values.rage.angles["pitch"].Dropdown == "random" and RANDOM(-25, 25)/25 or values.rage.angles["pitch"].Dropdown == "random2" and RANDOM(-99999999, 100)/100 or values.rage.angles["pitch"].Dropdown == "totally normal" and -71 or values.rage.angles["pitch"].Dropdown == "totally normal2" and 71 or values.rage.angles["pitch"].Dropdown == "custom" and values.rage.angles["pitch angle"].Slider or values.rage.angles["pitch"].Dropdown == "up2" and 12 or values.rage.angles["pitch"].Dropdown == "down2" and -12 or values.rage.angles["pitch"].Dropdown == "fake headless" and -99 or values.rage.angles["pitch"].Dropdown == "sucking dick" and -62 or values.rage.angles["pitch"].Dropdown == "huge" and math.huge or 2.5 
						if values.rage.angles["extend pitch"].Toggle and (values.rage.angles["pitch"].Dropdown == "up" or values.rage.angles["pitch"].Dropdown == "down" or values.rage.angles["pitch"].Dropdown == "180" or values.rage.angles["pitch"].Dropdown == "fake headless" or values.rage.angles["pitch"].Dropdown == "sucking dick") then 
							Pitch = (Pitch*2)/1.6 
						end
						game.ReplicatedStorage.Events.ControlTurn:FireServer(Pitch, LocalPlayer.Character:FindFirstChild("Climbing") and true or false) 
					else 
						LocalPlayer.Character.Humanoid.HipHeight = 2 
						Root.CFrame = CF(Root.Position) * CFAngles(0, -ATAN2(CamLook.Z, CamLook.X) + RAD(270), 0) 
						game.ReplicatedStorage.Events.ControlTurn:FireServer(CamLook.Y, LocalPlayer.Character:FindFirstChild("Climbing") and true or false) 
					end 
					if values.rage.others["remove head"].Toggle then 
						if LocalPlayer.Character:FindFirstChild("FakeHead") then 
							LocalPlayer.Character.FakeHead:Destroy() 
						end 
						if LocalPlayer.Character:FindFirstChild("HeadHB") then 
							LocalPlayer.Character.HeadHB:Destroy() 
						end 
					end 
					if TBLFIND(values.misc.client["gun modifiers"].Jumbobox, "recoil") then 
						Client.resetaccuracy() 
						Client.RecoilX = 0 
						Client.RecoilY = 0 
					end 
				end 
				for _,Player in pairs(Players:GetPlayers()) do 
					if Player.Character and Player ~= LocalPlayer and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart:FindFirstChild("OldPosition") then 
						coroutine.wrap(function() 
							local Position = Player.Character.HumanoidRootPart.Position 
							RunService.RenderStepped:Wait() 
							if Player.Character and Player ~= LocalPlayer and Player.Character:FindFirstChild("HumanoidRootPart") then 
								if Player.Character.HumanoidRootPart:FindFirstChild("OldPosition") then 
									Player.Character.HumanoidRootPart.OldPosition.Value = Position 
								else 
									local Value = INST("Vector3Value") 
									Value.Name = "OldPosition" 
									Value.Value = Position 
									Value.Parent = Player.Character.HumanoidRootPart 
								end 
							end 
						end)() 
					end 
				end 
				for _,Player in pairs(Players:GetPlayers()) do 
					local tbl = objects[Player] 
					if tbl == nil then return end 
					if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Team ~= "TTT" and (Player.Team ~= LocalPlayer.Team or values.visuals.players.teammates.Toggle) and Player.Character:FindFirstChild("Gun") and Player.Character:FindFirstChild("Humanoid") and Player ~= LocalPlayer then 
						local HumanoidRootPart = Player.Character.HumanoidRootPart 
						local RootPosition = HumanoidRootPart.Position 
						local Pos, OnScreen = Camera:WorldToViewportPoint(RootPosition) 
						local Size = (Camera:WorldToViewportPoint(RootPosition - Vec3(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPosition + Vec3(0, 2.6, 0)).Y) / 2 

						local Drawings, Text = TBLFIND(values.visuals.players.outlines.Jumbobox, "drawings") ~= nil, TBLFIND(values.visuals.players.outlines.Jumbobox, "text") ~= nil 

						tbl.Box.Color = values.visuals.players.box.Color 
						tbl.Box.Size = Vec2(Size * 1.2, Size * 1.9) 
						tbl.Box.Position = Vec2(Pos.X - Size*1.5 / 2, (Pos.Y - Size*1.6 / 2)) 

						if values.visuals.players.box.Toggle then 
							tbl.Box.Visible = OnScreen 
							if Drawings then 
								tbl.BoxOutline.Size = tbl.Box.Size 
								tbl.BoxOutline.Position = tbl.Box.Position 
								tbl.BoxOutline.Visible = OnScreen 
							else 
								tbl.BoxOutline.Visible = false 
							end 
						else 
							tbl.Box.Visible = false 
							tbl.BoxOutline.Visible = false 
						end 

						if values.visuals.players.health.Toggle then 
							tbl.Health.Color = COL3(0,1,0) 
							tbl.Health.From = Vec2((tbl.Box.Position.X - 5), tbl.Box.Position.Y + tbl.Box.Size.Y) 
							tbl.Health.To = Vec2(tbl.Health.From.X, tbl.Health.From.Y - CLAMP(Player.Character.Humanoid.Health / Player.Character.Humanoid.MaxHealth, 0, 1) * tbl.Box.Size.Y) 
							tbl.Health.Visible = OnScreen 
							if Drawings then 
								tbl.HealthOutline.From = Vec2(tbl.Health.From.X, tbl.Box.Position.Y + tbl.Box.Size.Y + 1) 
								tbl.HealthOutline.To = Vec2(tbl.Health.From.X, (tbl.Health.From.Y - 1 * tbl.Box.Size.Y) -1) 
								tbl.HealthOutline.Visible = OnScreen 
							else 
								tbl.HealthOutline.Visible = false 
							end 
						else 
							tbl.Health.Visible = false 
							tbl.HealthOutline.Visible = false 
						end 

						if values.visuals.players.weapon.Toggle then 
							tbl.Weapon.Color = values.visuals.players.weapon.Color 
							tbl.Weapon.Text = suffixx..""..Player.Character.EquippedTool.Value.. "" ..suffixx2
							tbl.Weapon.Position = Vec2(tbl.Box.Size.X/2 + tbl.Box.Position.X, tbl.Box.Size.Y + tbl.Box.Position.Y + 1) 
							tbl.Weapon.Font = Drawing.Fonts[values.visuals.players.font.Dropdown] 
							tbl.Weapon.Outline = Text 
							tbl.Weapon.Size = values.visuals.players.size.Slider 
							tbl.Weapon.Visible = OnScreen 
						else 
							tbl.Weapon.Visible = false 
						end 

						if values.visuals.players["weapon icon"].Toggle then 
							Items[Player.Name].ImageColor3 = values.visuals.players["weapon icon"].Color 
							Items[Player.Name].Image = GetIcon.getWeaponOfKiller(Player.Character.EquippedTool.Value) 
							Items[Player.Name].Position = UDIM2(0, tbl.Box.Size.X/2 + tbl.Box.Position.X, 0, tbl.Box.Size.Y + tbl.Box.Position.Y + (values.visuals.players.weapon.Toggle and -10 or -22)) 
							Items[Player.Name].Visible = OnScreen 
						else 
							Items[Player.Name].Visible = false 
						end 

						if values.visuals.players.name.Toggle then 
							tbl.Name.Color = values.visuals.players.name.Color 
							tbl.Name.Text = suffixx..""..Player.Name.. "" ..suffixx2
							tbl.Name.Position = Vec2(tbl.Box.Size.X/2 + tbl.Box.Position.X,  tbl.Box.Position.Y - 16) 
							tbl.Name.Font = Drawing.Fonts[values.visuals.players.font.Dropdown] 
							tbl.Name.Outline = Text 
							tbl.Name.Size = values.visuals.players.size.Slider 
							tbl.Name.Visible = OnScreen 
						else 
							tbl.Name.Visible = false 
						end 
						local LastInfoPos = tbl.Box.Position.Y - 1 
						if TBLFIND(values.visuals.players.indicators.Jumbobox, "armor") and Player:FindFirstChild("Kevlar") then 
							tbl.Armor.Color = COL3RGB(0, 150, 255) 
							tbl.Armor.Text = Player:FindFirstChild("Helmet") and "HK" or "K" 
							tbl.Armor.Position = Vec2(tbl.Box.Size.X + tbl.Box.Position.X + 12, LastInfoPos) 
							tbl.Armor.Font = Drawing.Fonts[values.visuals.players.font.Dropdown] 
							tbl.Armor.Outline = Text 
							tbl.Armor.Size = values.visuals.players.size.Slider 
							tbl.Armor.Visible = OnScreen 

							LastInfoPos = LastInfoPos + values.visuals.players.size.Slider 
						else 
							tbl.Armor.Visible = false 
						end 
					else 
						if Player.Name ~= LocalPlayer.Name then 
							Items[Player.Name].Visible = false 
							for i,v in pairs(tbl) do 
								v.Visible = false 
							end 
						end 
					end 
				end 

				if (values.misc.ui.scaling.Toggle) then 
					gui:SetScale(values.misc.ui.amount.Slider / 10) 
				else 
					gui:SetScale(1) 
				end 
			end) 

			local visualsilentangle = nil
			local speed = values.visuals.self["silent angle speed"].Slider/50
			local last = tick()
			RunService.RenderStepped:Connect(function()
				if RageTarget then
					visualsilentangle = RageTarget.Position
					last = tick()
				else
					if tick() - last > speed then
						visualsilentangle = nil
					end
				end
			end)

			local mt = getrawmetatable(game) 
			local oldNamecall = mt.__namecall 
			local oldIndex = mt.__index 
			local oldNewIndex = mt.__newindex 
			setreadonly(mt,false) 
			mt.__namecall = function(self, ...) 
				local method = tostring(getnamecallmethod()) 
				local args = {...} 

				if method == "SetPrimaryPartCFrame" and self.Name == "Arms" then 
					if values.visuals.self["third person"].Toggle and values.visuals.self["third person"].Active and LocalPlayer.Character then 
						args[1] = args[1] * CF(99, 99, 99) 
					else 
						if values.visuals.self["viewmodel changer"].Toggle then 
							args[1] = args[1] * ViewmodelOffset 
						end 
						if values.visuals.self["visualize silent angle"].Toggle and visualsilentangle then
							args[1] = CFrame.lookAt(args[1].p, visualsilentangle)
						end 
					end 
				end 
				if method == "SetPrimaryPartCFrame" and self.Name ~= "Arms" then 
					args[1] = args[1] + Vec3(0, 3, 0) 
					coroutine.wrap(function() 
						DisableAA = true 
						wait(2) 
						DisableAA = false 
					end)() 
				end 
				if method == "Kick" then 
					return 
				end 
				if method == "FireServer" then 
					if LEN(self.Name) == 38 then 
						return 
					elseif self.Name == "FallDamage" and TBLFIND(values.misc.client["damage bypass"].Jumbobox, "fall") or values.misc.movement["jump bug"].Toggle and values.misc.movement["jump bug"].Active then 
						return 
					elseif self.Name == "BURNME" and TBLFIND(values.misc.client["damage bypass"].Jumbobox, "fire") then 
						return 
					elseif self.Name == "ControlTurn" and not checkcaller() then 
						return 
					end 
					if self.Name == "PlayerChatted" and values.misc.client["chat alive"].Toggle then 
						args[2] = false 
						args[3] = "Innocent" 
						args[4] = false 
						args[5] = false 
					end 
					if self.Name == "ReplicateCamera" and values.misc.client["anti spectate"].Toggle then 
						args[1] = CF() 
					end 
				end 

				if method == "FindPartOnRayWithWhitelist" and not checkcaller() and Client.gun ~= "-" and Client.gun.Name ~= "C4" then 
					if #args[2] == 1 and args[2][1].Name == "SpawnPoints" then 
						local Team = LocalPlayer.Status.Team.Value 

						if TBLFIND(values.misc.client.shop.Jumbobox, "anywhere") then 
							return Team == "T" and args[2][1].BuyArea or args[2][1].BuyArea2 
						end 
					end 
				end 

				if method == "FindPartOnRayWithIgnoreList" and args[2][1] == workspace.Debris then 
					if not checkcaller() or Filter then 
						if TBLFIND(values.misc.client["gun modifiers"].Jumbobox, "penetration") then 
							INSERT(args[2], workspace.Map) 
						end 
						if TBLFIND(values.misc.client["gun modifiers"].Jumbobox, "spread") then 
							args[1] = RAY(Camera.CFrame.p, Camera.CFrame.LookVector * Client.gun.Range.Value) 
						end 
					end 
				end 
				if method == "InvokeServer" then 
					if self.Name == "Moolah" then 
						return 
					elseif self.Name == "Hugh" then 
						return 
					elseif self.Name == "Filter" and values.misc.chat["no filter"].Toggle then 
						return args[1] 
					end 
				end 

				if method == "LoadAnimation" and self.Name == "Humanoid" then 
					if values.rage.others["leg movement"].Dropdown == "slide" then 
						if FIND(args[1].Name, "Run") or FIND(args[1].Name, "Jump") then
							args[1] = FakeAnim
						end
					end 
					if values.rage.others["no animations"].Toggle then 
						args[1] = FakeAnim 
					end 
				end 
				if method == "FireServer" and self.Name == "HitPart" then
					if values.rage.aimbot["force mode"].Dropdown == "hit" and values.rage.aimbot['force hit'].Toggle and RageTarget ~= nil then
						args[1] = RageTarget
						args[2] = RageTarget.Position
					end
					if values.rage.aimbot["force mode"].Dropdown == "head" and values.rage.aimbot['force hit'].Toggle and RageTarget ~= nil then
						args[1] = RageTarget.Parent.Head
						args[2] = RageTarget.Position
					end
					if (values.rage.aimbot["prediction"].Toggle and RageTarget ~= nil) then
						coroutine.wrap(function()
							if Players:GetPlayerFromCharacter(args[1].Parent) or args[1] == RageTarget then 
							local hrp = RageTarget.Parent.HumanoidRootPart.Position
							local oldHrp = RageTarget.Parent.HumanoidRootPart.OldPosition.Value
							local vel = (Vec3(hrp.X, 0, hrp.Z) - Vec3(oldHrp.X, 0, oldHrp.Z)) / LastStep
							local dir = Vec3(vel.X / vel.magnitude, 0, vel.Z / vel.magnitude)
							args[2] = args[2] + dir * (Ping / (POW(Ping, (1.5))) * (dir / (dir / 2)))
							args[12]= args[12] - 500
							end
						end)()
					end
				end
				return oldNamecall(self, unpack(args)) 
			end 
			mt.__index = newcclosure(function(self, key)
				local CallingScript = getcallingscript()
				if not checkcaller() and self == Viewmodels and LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("UpperTorso") then
					local WeaponName = string.gsub(key, "v_", "")
					if not string.find(WeaponName, "Arms") then
						if Weapons[WeaponName]:FindFirstChild("Melee") and values.skins.knife["knife changer"].Toggle then
							if Viewmodels:FindFirstChild("v_"..values.skins.knife.model.Scroll) then
								return Viewmodels:FindFirstChild("v_"..values.skins.knife.model.Scroll)
							else
								local Clone = Models.Knives[values.skins.knife.model.Scroll]:Clone()
								return Clone
							end
						end
					end
				end
				if key == "Value" then
					if self.Name == "Auto" and table.find(values.misc.client["gun modifiers"].Jumbobox, "automatic") then
						return true
					elseif self.Name == "ReloadTime" and table.find(values.misc.client["gun modifiers"].Jumbobox, "reload") then
						return 0.001
					elseif self.Name == "EquipTime" and table.find(values.misc.client["gun modifiers"].Jumbobox, "equip") then
						return 0.001
					elseif self.Name == "BuyTime" and table.find(values.misc.client.shop.Jumbobox, "inf time") then
						return 5
					end
				end
				return oldIndex(self, key)
			end)
			local perf__ = LocalPlayer.PlayerGui.Performance.Perf 

			mt.__newindex = function(self, i, v) 
				if self:IsA("Humanoid") and i == "JumpPower" and not checkcaller() then 
					if values.misc.movement["jump bug"].Toggle and values.misc.movement["jump bug"].Active then 
						v = 24 
					end 
					if values.misc.movement["edge bug"].Toggle and values.misc.movement["edge bug"].Active then 
						v = 0 
					end 
					elseif self:IsA("Humanoid") and i == "WalkSpeed" and not checkcaller() then 
					if values.misc.movement["walkspeed"].Toggle and values.misc.movement["walkspeed"].Active then 
						v = values.misc.movement["walkspeed speed"].Slider
					end 
				elseif self:IsA("Humanoid") and i == "CameraOffset" then 
					if values.rage.angles.enabled.Toggle and values.rage.angles["body roll"].Dropdown == "180" and not DisableAA then 
						v = v + Vec3(0, -3.5, 0) 
					end 
					if values.rage.others["fake duck"].Toggle and values.rage.others["fake duck"].Active then
						v = Vec3(0, 0.1, 0)
					end
				end 

				return oldNewIndex(self, i, v) 
			end 
			Crosshairs.Scope:GetPropertyChangedSignal("Visible"):Connect(function(current) 
				if not TBLFIND(values.visuals.effects.removals.Jumbobox, "scope lines") then return end 

				if current ~= false then 
					Crosshairs.Scope.Visible = false 
				end 
			end) 
			Crosshair:GetPropertyChangedSignal("Visible"):Connect(function(current) 
				if not LocalPlayer.Character then return end 
				if not values.visuals.effects["force crosshair"].Toggle then return end 
				if LocalPlayer.Character:FindFirstChild("AIMING") then return end 

				Crosshair.Visible = true 
			end) 

			LocalPlayer.Additionals.TotalDamage:GetPropertyChangedSignal("Value"):Connect(function(current) 
				if current == 0 then return end 
				coroutine.wrap(function() 
					if values.misc.client.hitmarker.Toggle then 
						local Line = Drawing.new("Line") 
						local Line2 = Drawing.new("Line") 
						local Line3 = Drawing.new("Line") 
						local Line4 = Drawing.new("Line") 

						local x, y = Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 

						Line.From = Vec2(x + 4, y + 4) 
						Line.To = Vec2(x + 10, y + 10) 
						Line.Color = values.misc.client.hitmarker.Color 
						Line.Visible = true 

						Line2.From = Vec2(x + 4, y - 4) 
						Line2.To = Vec2(x + 10, y - 10) 
						Line2.Color = values.misc.client.hitmarker.Color 
						Line2.Visible = true 

						Line3.From = Vec2(x - 4, y - 4) 
						Line3.To = Vec2(x - 10, y - 10) 
						Line3.Color = values.misc.client.hitmarker.Color 
						Line3.Visible = true 

						Line4.From = Vec2(x - 4, y + 4) 
						Line4.To = Vec2(x - 10, y + 10) 
						Line4.Color = values.misc.client.hitmarker.Color 
						Line4.Visible = true 

						Line.Transparency = 1 
						Line2.Transparency = 1 
						Line3.Transparency = 1 
						Line4.Transparency = 1 

						Line.Thickness = 1 
						Line2.Thickness = 1 
						Line3.Thickness = 1 
						Line4.Thickness = 1 

						wait(0.3) 
						for i = 1,0,-0.1 do 
							wait() 
							Line.Transparency = i 
							Line2.Transparency = i 
							Line3.Transparency = i 
							Line4.Transparency = i 
						end 
						Line:Remove() 
						Line2:Remove() 
						Line3:Remove() 
						Line4:Remove() 
					end 
				end)() 
					if values.visuals.world.hitsound.Dropdown == "-" then return end 

					local sound = INST("Sound") 
					sound.Parent = game:GetService("SoundService") 
					sound.SoundId = values.visuals.world.hitsound.Dropdown == "skeet" and "rbxassetid://5447626464" or "rit" and "rbxassetid://9249999516" or values.visuals.world.hitsound.Dropdown == "rust" and "rbxassetid://5043539486" or values.visuals.world.hitsound.Dropdown == "bag" and "rbxassetid://364942410" or values.visuals.world.hitsound.Dropdown == "baimware" and "rbxassetid://6607339542" or values.visuals.world.hitsound.Dropdown == "1nn" and "rbxassetid://7349055654" or values.visuals.world.hitsound.Dropdown == "oni-chan" and "rbxassetid://130822574" or values.visuals.world.hitsound.Dropdown == "Bonk" and "rbxassetid://3765689841" or values.visuals.world.hitsound.Dropdown == "cod" and "rbxassetid://5447626464" or values.visuals.world.hitsound.Dropdown =="Semi" and "rbxassetid://7791675603" or values.visuals.world.hitsound.Dropdown == "osu" and "rbxassetid://7149919358" or values.visuals.world.hitsound.Dropdown == "Tf2" and "rbxassetid://296102734" or values.visuals.world.hitsound.Dropdown == "Tf2 pan" and "rbxassetid://3431749479" or values.visuals.world.hitsound.Dropdown  == "M55solix" and "rbxassetid://364942410" or values.visuals.world.hitsound.Dropdown == "Slap" and "rbxassetid://4888372697" or values.visuals.world.hitsound.Dropdown  == "1" and "rbxassetid://7349055654" or values.visuals.world.hitsound.Dropdown == "Minecraft" and "rbxassetid://7273736372" or values.visuals.world.hitsound.Dropdown == "jojo" and "rbxassetid://6787514780" or values.visuals.world.hitsound.Dropdown == "vibe" and "rbxassetid://1848288500" or values.visuals.world.hitsound.Dropdown == "supersmash" and "rbxassetid://2039907664" or values.visuals.world.hitsound.Dropdown == "epic" and "rbxassetid://7344303740" or values.visuals.world.hitsound.Dropdown == "retro" and "rbxassetid://3466984142" or values.visuals.world.hitsound.Dropdown == "quek" and "rbxassetid://4868633804" or values.visuals.world.hitsound.Dropdown == "Welcome" and "rbxassetid://5149595745" or "rbxassetid://5447626464" 
					sound.Volume = values.visuals.world["sound volume"].Slider 
					sound.PlayOnRemove = true 
					sound:Destroy() 
				end) 
			LocalPlayer.Status.Kills:GetPropertyChangedSignal("Value"):Connect(function(current) 
				if current == 0 then return end 
				if values.misc.chat["kill say"].Toggle then 
					game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(values.misc.chat["message"].Text ~= "" and values.misc.chat["message"].Text or "Hey atleast you tried ;D 👍", false, "Innocent", false, true) 
				end 
			end) 
			lastcurrent = LocalPlayer.Status.Kills.Value
				LocalPlayer.Status.Kills:GetPropertyChangedSignal('Value'):Connect(function(current)
					if current == 0 then return end

					if values.visuals.world.killsound.Dropdown == '-' then return end
					local sound = INST('Sound')
					sound.Parent = game:GetService('SoundService')
					sound.SoundId = values.visuals.world.killsound.Dropdown == "skeet" and "rbxassetid://5447626464" or "rit" and "rbxassetid://9249999516" or values.visuals.world.killsound.Dropdown == "rust" and "rbxassetid://5043539486" or values.visuals.world.killsound.Dropdown == "bag" and "rbxassetid://364942410" or values.visuals.world.killsound.Dropdown == "baimware" and "rbxassetid://6607339542" or values.visuals.world.killsound.Dropdown == "1nn" and "rbxassetid://7349055654" or values.visuals.world.killsound.Dropdown == "oni-chan" and "rbxassetid://130822574" or values.visuals.world.killsound.Dropdown == "Bonk" and "rbxassetid://3765689841" or values.visuals.world.killsound.Dropdown == "cod" and "rbxassetid://5447626464" or values.visuals.world.killsound.Dropdown =="Semi" and "rbxassetid://7791675603" or values.visuals.world.killsound.Dropdown == "osu" and "rbxassetid://7149919358" or values.visuals.world.killsound.Dropdown == "Tf2" and "rbxassetid://296102734" or values.visuals.world.killsound.Dropdown == "Tf2 pan" and "rbxassetid://3431749479" or values.visuals.world.killsound.Dropdown  == "M55solix" and "rbxassetid://364942410" or values.visuals.world.killsound.Dropdown == "Slap" and "rbxassetid://4888372697" or values.visuals.world.killsound.Dropdown  == "1" and "rbxassetid://7349055654" or values.visuals.world.killsound.Dropdown == "Minecraft" and "rbxassetid://7273736372" or values.visuals.world.killsound.Dropdown == "jojo" and "rbxassetid://6787514780" or values.visuals.world.killsound.Dropdown == "vibe" and "rbxassetid://1848288500" or values.visuals.world.killsound.Dropdown == "supersmash" and "rbxassetid://2039907664" or values.visuals.world.killsound.Dropdown == "epic" and "rbxassetid://7344303740" or values.visuals.world.killsound.Dropdown == "retro" and "rbxassetid://3466984142" or values.visuals.world.killsound.Dropdown == "quek" and "rbxassetid://4868633804" or values.visuals.world.killsound.Dropdown == "Welcome" and "rbxassetid://5149595745" or "rbxassetid://5447626464" 
					sound.Volume = values.visuals.world['sound volume'].Slider
					sound.PlayOnRemove = true
					sound:Destroy()
					lastcurrent = LocalPlayer.Status.Kills.Value
				end)
			RayIgnore.ChildAdded:Connect(function(obj) 
				if obj.Name == "Fires" then 
					obj.ChildAdded:Connect(function(fire) 
						if values.visuals.world["molly radius"].Toggle then 
							fire.Transparency = values.visuals.world["molly radius"].Transparency 
							fire.Color = values.visuals.world["molly radius"].Color 
						end 
					end) 
				end 
				if obj.Name == "Smokes" then 
					obj.ChildAdded:Connect(function(smoke) 
						RunService.RenderStepped:Wait() 
						local OriginalRate = INST("NumberValue") 
						OriginalRate.Value = smoke.ParticleEmitter.Rate 
						OriginalRate.Name = "OriginalRate" 
						OriginalRate.Parent = smoke 
						if TBLFIND(values.visuals.effects.removals.Jumbobox, "smokes") then 
							smoke.ParticleEmitter.Rate = 0 
						end 
						smoke.Material = Enum.Material.ForceField 
						if values.visuals.world["smoke radius"].Toggle then 
							smoke.Transparency = 0 
							smoke.Color = values.visuals.world["smoke radius"].Color 
						end 
					end) 
				end 
			end) 
			if RayIgnore:FindFirstChild("Fires") then 
				RayIgnore:FindFirstChild("Fires").ChildAdded:Connect(function(fire) 
					if values.visuals.world["molly radius"].Toggle then 
						fire.Transparency = values.visuals.world["molly radius"].Transparency 
						fire.Color = values.visuals.world["molly radius"].Color 
					end 
				end) 
			end 
			if RayIgnore:FindFirstChild("Smokes") then 
				for _,smoke in pairs(RayIgnore:FindFirstChild("Smokes"):GetChildren()) do 
					local OriginalRate = INST("NumberValue") 
					OriginalRate.Value = smoke.ParticleEmitter.Rate 
					OriginalRate.Name = "OriginalRate" 
					OriginalRate.Parent = smoke 
					smoke.Material = Enum.Material.ForceField 
				end 
				RayIgnore:FindFirstChild("Smokes").ChildAdded:Connect(function(smoke) 
					RunService.RenderStepped:Wait() 
					local OriginalRate = INST("NumberValue") 
					OriginalRate.Value = smoke.ParticleEmitter.Rate 
					OriginalRate.Name = "OriginalRate" 
					OriginalRate.Parent = smoke 
					if TBLFIND(values.visuals.effects.removals.Jumbobox, "smokes") then 
						smoke.ParticleEmitter.Rate = 0 
					end 
					smoke.Material = Enum.Material.ForceField 
					if values.visuals.world["smoke radius"].Toggle then 
						smoke.Transparency = 0 
						smoke.Color = values.visuals.world["smoke radius"].Color 
					end 
				end) 
			end 
			Camera.ChildAdded:Connect(function(obj) 
				if TBLFIND(values.misc.client["gun modifiers"].Jumbobox, "ammo") then 
					Client.ammocount = 999999 
					Client.primarystored = 999999 
					Client.ammocount2 = 999999 
					Client.secondarystored = 999999 
				end 
				RunService.RenderStepped:Wait() 
				if obj.Name ~= "Arms" then return end 
				local Model 
				for i,v in pairs(obj:GetChildren()) do 
					if v:IsA("Model") and (v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm")) then 
						Model = v 
					end 
				end 
				if Model == nil then return end 
				for i,v in pairs(obj:GetChildren()) do 
					if (v:IsA("BasePart") or v:IsA("Part")) and v.Transparency ~= 1 and v.Name ~= "Flash" then 
						local valid = true 
						if v:IsA("Part") and v:FindFirstChild("Mesh") and not v:IsA("BlockMesh") then 
							valid = false 
							local success, err = pcall(function() 
								local OriginalTexture = INST("StringValue") 
								OriginalTexture.Value = v.Mesh.TextureId 
								OriginalTexture.Name = "OriginalTexture" 
								OriginalTexture.Parent = v.Mesh 
							end) 
							local success2, err2 = pcall(function() 
								local OriginalTexture = INST("StringValue") 
								OriginalTexture.Value = v.Mesh.TextureID 
								OriginalTexture.Name = "OriginalTexture" 
								OriginalTexture.Parent = v.Mesh 
							end) 
							if success or success2 then valid = true end 
						end 

						for i2,v2 in pairs(v:GetChildren()) do 
							if (v2:IsA("BasePart") or v2:IsA("Part")) then 
								INSERT(WeaponObj, v2) 
							end 
						end 

						if valid then 
							INSERT(WeaponObj, v) 
						end 
					end 
				end 

				local gunname = Client.gun ~= "-" and values.skins.knife["knife changer"].Toggle and Client.gun:FindFirstChild("Melee") and values.skins.knife.model.Scroll or Client.gun ~= "-" and Client.gun.Name 
				if values.skins.skins["skin changer"].Toggle and gunname ~= nil and Skins:FindFirstChild(gunname) then 
					if values.skins.skins.skin.Scroll[gunname] ~= "Inventory" then 
						MapSkin(gunname, values.skins.skins.skin.Scroll[gunname]) 
					end 
				end 
				for _,v in pairs(WeaponObj) do 
					if v:IsA("MeshPart") then 
						local OriginalTexture = INST("StringValue") 
						OriginalTexture.Value = v.TextureID 
						OriginalTexture.Name = "OriginalTexture" 
						OriginalTexture.Parent = v 
					end 

					local OriginalColor = INST("Color3Value") 
					OriginalColor.Value = v.Color 
					OriginalColor.Name = "OriginalColor" 
					OriginalColor.Parent = v 

					local OriginalMaterial = INST("StringValue") 
					OriginalMaterial.Value = v.Material.Name 
					OriginalMaterial.Name = "OriginalMaterial" 
					OriginalMaterial.Parent = v 

					if values.visuals.effects["weapon chams"].Toggle then 
						UpdateWeapon(v) 
					end 
				end 
				RArm = Model:FindFirstChild("Right Arm"); LArm = Model:FindFirstChild("Left Arm") 
				if RArm then 
					local OriginalColor = INST("Color3Value") 
					OriginalColor.Value = RArm.Color 
					OriginalColor.Name = "Color3Value" 
					OriginalColor.Parent = RArm 
					if values.visuals.effects["arm chams"].Toggle then 
						RArm.Color = values.visuals.effects["arm chams"].Color 
						RArm.Transparency = values.visuals.effects["arm chams"].Transparency 
					end 
					RGlove = RArm:FindFirstChild("Glove") or RArm:FindFirstChild("RGlove") 
					if values.skins.glove["glove changer"].Toggle and Client.gun ~= "-" then 
						if RGlove then RGlove:Destroy() end 
						RGlove = GloveModels[values.skins.glove.model.Dropdown].RGlove:Clone() 
						RGlove.Mesh.TextureId = Gloves[values.skins.glove.model.Dropdown][values.skins.glove.model.Scroll[values.skins.glove.model.Dropdown]].Textures.TextureId 
						RGlove.Parent = RArm 
						RGlove.Transparency = 0 
						RGlove.Welded.Part0 = RArm 
					end 
					if RGlove.Transparency == 1 then 
						RGlove:Destroy() 
						RGlove = nil 
					else 
						local GloveTexture = INST("StringValue") 
						GloveTexture.Value = RGlove.Mesh.TextureId 
						GloveTexture.Name = "StringValue" 
						GloveTexture.Parent = RGlove 

						if values.visuals.effects["accessory chams"].Toggle then 
							UpdateAccessory(RGlove) 
						end 
					end 
					RSleeve = RArm:FindFirstChild("Sleeve") 
					if RSleeve ~= nil then 
						local SleeveTexture = INST("StringValue") 
						SleeveTexture.Value = RSleeve.Mesh.TextureId 
						SleeveTexture.Name = "StringValue" 
						SleeveTexture.Parent = RSleeve 
						if values.visuals.effects["arm chams"].Toggle then 
							LArm.Color = values.visuals.effects["arm chams"].Color 
						end 
						if values.visuals.effects["accessory chams"].Toggle then 
							UpdateAccessory(RSleeve) 
						end 
					end 
				end 
				if LArm then 
					local OriginalColor = INST("Color3Value") 
					OriginalColor.Value = LArm.Color 
					OriginalColor.Name = "Color3Value" 
					OriginalColor.Parent = LArm 
					if values.visuals.effects["arm chams"].Toggle then 
						LArm.Color = values.visuals.effects["arm chams"].Color 
						LArm.Transparency = values.visuals.effects["arm chams"].Transparency 
					end 
					LGlove = LArm:FindFirstChild("Glove") or LArm:FindFirstChild("LGlove") 
					if values.skins.glove["glove changer"].Toggle and Client.gun ~= "-" then 
						if LGlove then LGlove:Destroy() end 
						LGlove = GloveModels[values.skins.glove.model.Dropdown].LGlove:Clone() 
						LGlove.Mesh.TextureId = Gloves[values.skins.glove.model.Dropdown][values.skins.glove.model.Scroll[values.skins.glove.model.Dropdown]].Textures.TextureId 
						LGlove.Transparency = 0 
						LGlove.Parent = LArm 
						LGlove.Welded.Part0 = LArm 
					end 
					if LGlove.Transparency == 1 then 
						LGlove:Destroy() 
						LGlove =  nil 
					else 
						local GloveTexture = INST("StringValue") 
						GloveTexture.Value = LGlove.Mesh.TextureId 
						GloveTexture.Name = "StringValue" 
						GloveTexture.Parent = LGlove 

						if values.visuals.effects["accessory chams"].Toggle then 
							UpdateAccessory(LGlove) 
						end 
					end 
					LSleeve = LArm:FindFirstChild("Sleeve") 
					if LSleeve ~= nil then 
						local SleeveTexture = INST("StringValue") 
						SleeveTexture.Value = LSleeve.Mesh.TextureId 
						SleeveTexture.Name = "StringValue" 
						SleeveTexture.Parent = LSleeve 

						if values.visuals.effects["accessory chams"].Toggle then 
							UpdateAccessory(LSleeve) 
						end 
					end 
				end 
			end) 
			Camera.ChildAdded:Connect(function(obj) 
				if obj.Name == "Arms" then 
					RArm, LArm, RGlove, RSleeve, LGlove, LSleeve = nil, nil, nil, nil, nil, nil 
					WeaponObj = {} 
				end 
			end) 
			Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function(fov) 
				if LocalPlayer.Character == nil then return end 
				if fov == values.visuals.self["fov changer"].Slider then return end 
				if values.visuals.self["on scope"].Toggle or not LocalPlayer.Character:FindFirstChild("AIMING") then 
					Camera.FieldOfView = values.visuals.self["fov changer"].Slider 
				end 
			end) 
			LocalPlayer.Cash:GetPropertyChangedSignal("Value"):Connect(function(cash) 
				if values.misc.client["infinite cash"].Toggle and cash ~= 8000 then 
					LocalPlayer.Cash.Value = 8000 
				end 
			end) 
			if workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Origin") then 
				if workspace.Map.Origin.Value == "de_cache" or workspace.Map.Origin.Value == "de_vertigo" or workspace.Map.Origin.Value == "de_nuke" or workspace.Map.Origin.Value == "de_aztec" then 
					oldSkybox = Lighting:FindFirstChildOfClass("Sky"):Clone() 
				end 
			end 
			workspace.ChildAdded:Connect(function(obj) 
				if obj.Name == "Map" then 
					wait(5) 
					if values.misc.client["remove killers"].Toggle then 
						if workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Killers") then 
							local clone = workspace:FindFirstChild("Map"):FindFirstChild("Killers"):Clone() 
							clone.Name = "KillersClone" 
							clone.Parent = workspace:FindFirstChild("Map") 

							workspace:FindFirstChild("Map"):FindFirstChild("Killers"):Destroy() 
						end 
					end 
					if oldSkybox ~= nil then 
						oldSkybox:Destroy() 
						oldSkybox = nil 
					end 
					local Origin = workspace.Map:WaitForChild("Origin") 
					if workspace.Map.Origin.Value == "de_cache" or workspace.Map.Origin.Value == "de_vertigo" or workspace.Map.Origin.Value == "de_nuke" or workspace.Map.Origin.Value == "de_aztec" then 
						oldSkybox = Lighting:FindFirstChildOfClass("Sky"):Clone() 

						local sky = values.visuals.world.skybox.Dropdown 
						if sky ~= "-" then 
							Lighting:FindFirstChildOfClass("Sky"):Destroy() 
							local skybox = INST("Sky") 
							skybox.SkyboxLf = Skyboxes[sky].SkyboxLf 
							skybox.SkyboxBk = Skyboxes[sky].SkyboxBk 
							skybox.SkyboxDn = Skyboxes[sky].SkyboxDn 
							skybox.SkyboxFt = Skyboxes[sky].SkyboxFt 
							skybox.SkyboxRt = Skyboxes[sky].SkyboxRt 
							skybox.SkyboxUp = Skyboxes[sky].SkyboxUp 
							skybox.Name = "override" 
							skybox.Parent = Lighting 
						end 
					else 
						local sky = values.visuals.world.skybox.Dropdown 
						if sky ~= "-" then 
							local skybox = INST("Sky") 
							skybox.SkyboxLf = Skyboxes[sky].SkyboxLf 
							skybox.SkyboxBk = Skyboxes[sky].SkyboxBk 
							skybox.SkyboxDn = Skyboxes[sky].SkyboxDn 
							skybox.SkyboxFt = Skyboxes[sky].SkyboxFt 
							skybox.SkyboxRt = Skyboxes[sky].SkyboxRt 
							skybox.SkyboxUp = Skyboxes[sky].SkyboxUp 
							skybox.Name = "override" 
							skybox.Parent = Lighting 
						end 
					end 
				end 
			end) 
			Lighting.ChildAdded:Connect(function(obj) 
				if obj:IsA("Sky") and obj.Name ~= "override" then 
					oldSkybox = obj:Clone() 
				end 
			end) 

			local function CollisionTBL(obj) 
				if obj:IsA("Accessory") then 
					INSERT(Collision, obj) 
				end 
				if obj:IsA("Part") then 
					if obj.Name == "HeadHB" or obj.Name == "FakeHead" then 
						INSERT(Collision, obj) 
					end 
				end 
			end 
			LocalPlayer.CharacterAdded:Connect(function(char) 
				repeat RunService.RenderStepped:Wait() 
				until char:FindFirstChild("Gun") 
				SelfObj = {} 
				if values.skins.characters["character changer"].Toggle then 
					ChangeCharacter(ChrModels:FindFirstChild(values.skins.characters.skin.Scroll)) 
				end 
				if char:FindFirstChildOfClass("Shirt") then 
					local String = INST("StringValue") 
					String.Name = "OriginalTexture" 
					String.Value = char:FindFirstChildOfClass("Shirt").ShirtTemplate 
					String.Parent = char:FindFirstChildOfClass("Shirt") 

					if TBLFIND(values.visuals.effects.removals.Jumbobox, "clothes") then 
						char:FindFirstChildOfClass("Shirt").ShirtTemplate = "" 
					end 
				end 
				if char:FindFirstChildOfClass("Pants") then 
					local String = INST("StringValue") 
					String.Name = "OriginalTexture" 
					String.Value = char:FindFirstChildOfClass("Pants").PantsTemplate 
					String.Parent = char:FindFirstChildOfClass("Pants") 
					
					if TBLFIND(values.visuals.effects.removals.Jumbobox, "clothes") then 
						char:FindFirstChildOfClass("Pants").PantsTemplate = "" 
					end 
				end 
				for i,v in pairs(char:GetChildren()) do 
					if v:IsA("BasePart") and v.Transparency ~= 1 then 
						INSERT(SelfObj, v) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = v.Color 
						Color.Parent = v 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = v.Material.Name 
						String.Parent = v 
					elseif v:IsA("Accessory") and v.Handle.Transparency ~= 1 then 
						INSERT(SelfObj, v.Handle) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = v.Handle.Color 
						Color.Parent = v.Handle 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = v.Handle.Material.Name 
						String.Parent = v.Handle 
					end 
				end 

				if values.visuals.self["self chams"].Toggle then 
					for _,obj in pairs(SelfObj) do 
						if obj.Parent ~= nil then 
							obj.Material = Enum.Material.ForceField 
							obj.Color = values.visuals.self["self chams"].Color 
						end 
					end 
				end 

				LocalPlayer.Character.ChildAdded:Connect(function(Child) 
					if Child:IsA("Accessory") and Child.Handle.Transparency ~= 1 then 
						INSERT(SelfObj, Child.Handle) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = Child.Handle.Color 
						Color.Parent = Child.Handle 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = Child.Handle.Material.Name 
						String.Parent = Child.Handle 

						if values.visuals.self["self chams"].Toggle then 
							for _,obj in pairs(SelfObj) do 
								if obj.Parent ~= nil then 
									obj.Material = Enum.Material.ForceField 
									obj.Color = values.visuals.self["self chams"].Color 
								end 
							end 
						end 
					end 
				end) 

				if values.misc.animations.enabled.Toggle and values.misc.animations.enabled.Active then 
					LoadedAnim = LocalPlayer.Character.Humanoid:LoadAnimation(Dance) 
					LoadedAnim.Priority = Enum.AnimationPriority.Action 
					LoadedAnim:Play() 
				end 
			end) 
			if LocalPlayer.Character ~= nil then 
				for i,v in pairs(LocalPlayer.Character:GetChildren()) do 
					if v:IsA("BasePart") and v.Transparency ~= 1 then 
						INSERT(SelfObj, v) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = v.Color 
						Color.Parent = v 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = v.Material.Name 
						String.Parent = v 
					elseif v:IsA("Accessory") and v.Handle.Transparency ~= 1 then 
						INSERT(SelfObj, v.Handle) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = v.Handle.Color 
						Color.Parent = v.Handle 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = v.Handle.Material.Name 
						String.Parent = v.Handle 
					end 
				end 
				if values.visuals.self["self chams"].Toggle then 
					for _,obj in pairs(SelfObj) do 
						if obj.Parent ~= nil then 
							obj.Material = Enum.Material.ForceField 
							obj.Color = values.visuals.self["self chams"].Color 
						end 
					end 
				end 
				LocalPlayer.Character.ChildAdded:Connect(function(Child) 
					if Child:IsA("Accessory") and Child.Handle.Transparency ~= 1 then 
						INSERT(SelfObj, Child.Handle) 
						local Color = INST("Color3Value") 
						Color.Name = "OriginalColor" 
						Color.Value = Child.Handle.Color 
						Color.Parent = Child.Handle 

						local String = INST("StringValue") 
						String.Name = "OriginalMaterial" 
						String.Value = Child.Handle.Material.Name 
						String.Parent = Child.Handle 

						if values.visuals.self["self chams"].Toggle then 
							for _,obj in pairs(SelfObj) do 
								if obj.Parent ~= nil then 
									obj.Material = Enum.Material.ForceField 
									obj.Color = values.visuals.self["self chams"].Color 
								end 
							end 
						end 
					end 
				end) 
			end 
			Players.PlayerAdded:Connect(function(Player) 
				Player:GetPropertyChangedSignal("Team"):Connect(function(new) 
					wait() 
					if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then 
						for _2,Obj in pairs(Player.Character:GetDescendants()) do 
							if Obj.Name == "VisibleCham" or Obj.Name == "WallCham" then 
								if values.visuals.players.chams.Toggle then 
									if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then 
										Obj.Visible = true 
									else 
										Obj.Visible = false 
									end 
								else 
									Obj.Visible = false 
								end 
								Obj.Color3 = values.visuals.players.chams.Color 
							end 
						end 
					end 
				end) 
				Player.CharacterAdded:Connect(function(Character) 
					Character.ChildAdded:Connect(function(obj) 
						wait(1) 
						CollisionTBL(obj) 
					end) 
					wait(1) 
					if Character ~= nil then 
						local Value = INST("Vector3Value") 
						Value.Name = "OldPosition" 
						Value.Value = Character.HumanoidRootPart.Position 
						Value.Parent = Character.HumanoidRootPart 
						for _,obj in pairs(Character:GetChildren()) do 
							if obj:IsA("BasePart") and Player ~= LocalPlayer and obj.Name ~= "HumanoidRootPart" and obj.Name ~= "Head" and obj.Name ~= "BackC4" and obj.Name ~= "HeadHB" then 
								local VisibleCham = INST("BoxHandleAdornment") 
								VisibleCham.Name = "VisibleCham" 
								VisibleCham.AlwaysOnTop = false 
								VisibleCham.ZIndex = 8 
								VisibleCham.Size = obj.Size + Vec3(0.1,0.1,0.1) 
								VisibleCham.AlwaysOnTop = false 
								VisibleCham.Transparency = 0 

								local WallCham = INST("BoxHandleAdornment") 
								WallCham.Name = "WallCham" 
								WallCham.AlwaysOnTop = true 
								WallCham.ZIndex = 5 
								WallCham.Size = obj.Size + Vec3(0.1,0.1,0.1) 
								WallCham.AlwaysOnTop = true 
								WallCham.Transparency = 0.7 

								if values.visuals.players.chams.Toggle then 
									if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then 
										VisibleCham.Visible = true 
										WallCham.Visible = true 
									else 
										VisibleCham.Visible = false 
										WallCham.Visible = false 
									end 
								else 
									VisibleCham.Visible = false 
									WallCham.Visible = false 
								end 

								INSERT(ChamItems, VisibleCham) 
								INSERT(ChamItems, WallCham) 

								VisibleCham.Color3 = values.visuals.players.chams.Color 
								WallCham.Color3 = values.visuals.players.chams.Color 

								VisibleCham.AdornCullingMode = "Never" 
								WallCham.AdornCullingMode = "Never" 

								VisibleCham.Adornee = obj 
								VisibleCham.Parent = obj 

								WallCham.Adornee = obj 
								WallCham.Parent = obj 
							end 
						end 
					end 
				end) 
			end) 
			for _,Player in pairs(Players:GetPlayers()) do 
				if Player ~= LocalPlayer then 
					Player:GetPropertyChangedSignal("Team"):Connect(function(new) 
						wait() 
						if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then 
							for _2,Obj in pairs(Player.Character:GetDescendants()) do 
								if Obj.Name == "VisibleCham" or Obj.Name == "WallCham" then 
									if values.visuals.players.chams.Toggle then 
										if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then 
											Obj.Visible = true 
										else 
											Obj.Visible = false 
										end 
									else 
										Obj.Visible = false 
									end 
									Obj.Color3 = values.visuals.players.chams.Color 
								end 
							end 
						end 
					end) 
				else 
					LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function(new) 
						wait() 
						for _,Player in pairs(Players:GetPlayers()) do 
							if Player.Character then 
								for _2,Obj in pairs(Player.Character:GetDescendants()) do 
									if Obj.Name == "VisibleCham" or Obj.Name == "WallCham" then 
										if values.visuals.players.chams.Toggle then 
											if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then 
												Obj.Visible = true 
											else 
												Obj.Visible = false 
											end 
										else 
											Obj.Visible = false 
										end 
										Obj.Color3 = values.visuals.players.chams.Color 
									end 
								end 
							end 
						end 
					end) 
				end 
				Player.CharacterAdded:Connect(function(Character) 
					Character.ChildAdded:Connect(function(obj) 
						wait(1) 
						CollisionTBL(obj) 
					end) 
					wait(1) 
					if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then 
						local Value = INST("Vector3Value") 
						Value.Value = Player.Character.HumanoidRootPart.Position 
						Value.Name = "OldPosition" 
						Value.Parent = Player.Character.HumanoidRootPart 
						for _,obj in pairs(Player.Character:GetChildren()) do 
							if obj:IsA("BasePart") and Player ~= LocalPlayer and obj.Name ~= "HumanoidRootPart" and obj.Name ~= "Head" and obj.Name ~= "BackC4" and obj.Name ~= "HeadHB" then 
								local VisibleCham = INST("BoxHandleAdornment") 
								VisibleCham.Name = "VisibleCham" 
								VisibleCham.AlwaysOnTop = false 
								VisibleCham.ZIndex = 5 
								VisibleCham.Size = obj.Size + Vec3(0.1,0.1,0.1) 
								VisibleCham.AlwaysOnTop = false 
								VisibleCham.Transparency = 0 

								local WallCham = INST("BoxHandleAdornment") 
								WallCham.Name = "WallCham" 
								WallCham.AlwaysOnTop = true 
								WallCham.ZIndex = 5 
								WallCham.Size = obj.Size + Vec3(0.1,0.1,0.1) 
								WallCham.AlwaysOnTop = true 
								WallCham.Transparency = 0.7 

								if values.visuals.players.chams.Toggle then 
									if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then 
										VisibleCham.Visible = true 
										WallCham.Visible = true 
									else 
										VisibleCham.Visible = false 
										WallCham.Visible = false 
									end 
								else 
									VisibleCham.Visible = false 
									WallCham.Visible = false 
								end 

								INSERT(ChamItems, VisibleCham) 
								INSERT(ChamItems, WallCham) 

								VisibleCham.Color3 = values.visuals.players.chams.Color 
								WallCham.Color3 = values.visuals.players.chams.Color 

								VisibleCham.AdornCullingMode = "Never" 
								WallCham.AdornCullingMode = "Never" 

								VisibleCham.Adornee = obj 
								VisibleCham.Parent = obj 

								WallCham.Adornee = obj 
								WallCham.Parent = obj 
							end 
						end 
					end 
				end) 
				if Player.Character ~= nil and Player.Character:FindFirstChild("UpperTorso") then 
					local Value = INST("Vector3Value") 
					Value.Name = "OldPosition" 
					Value.Value = Player.Character.HumanoidRootPart.Position 
					Value.Parent = Player.Character.HumanoidRootPart 
					for _,obj in pairs(Player.Character:GetChildren()) do 
						CollisionTBL(obj) 
						if obj:IsA("BasePart") and Player ~= LocalPlayer and obj.Name ~= "HumanoidRootPart" and obj.Name ~= "Head" and obj.Name ~= "BackC4" and obj.Name ~= "HeadHB" then 
							local VisibleCham = INST("BoxHandleAdornment") 
							VisibleCham.Name = "VisibleCham" 
							VisibleCham.AlwaysOnTop = false 
							VisibleCham.ZIndex = 5 
							VisibleCham.Size = obj.Size + Vec3(0.1,0.1,0.1) 
							VisibleCham.AlwaysOnTop = false 
							VisibleCham.Transparency = 0 

							local WallCham = INST("BoxHandleAdornment") 
							WallCham.Name = "WallCham" 
							WallCham.AlwaysOnTop = true 
							WallCham.ZIndex = 5 
							WallCham.Size = obj.Size + Vec3(0.1,0.1,0.1) 
							WallCham.AlwaysOnTop = true 
							WallCham.Transparency = 0.7 

							if values.visuals.players.chams.Toggle then 
								if values.visuals.players.teammates.Toggle or Player.Team ~= LocalPlayer.Team then 
									VisibleCham.Visible = true 
									WallCham.Visible = true 
								else 
									VisibleCham.Visible = false 
									WallCham.Visible = false 
								end 
							else 
								VisibleCham.Visible = false 
								WallCham.Visible = false 
							end 

							INSERT(ChamItems, VisibleCham) 
							INSERT(ChamItems, WallCham) 

							VisibleCham.Color3 = values.visuals.players.chams.Color 
							WallCham.Color3 = values.visuals.players.chams.Color 

							VisibleCham.AdornCullingMode = "Never" 
							WallCham.AdornCullingMode = "Never" 

							VisibleCham.Adornee = obj 
							VisibleCham.Parent = obj 

							WallCham.Adornee = obj 
							WallCham.Parent = obj 
						end 
					end 
				end 
			end
 
			watermark = {}

			watermark.Background = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(41, 41, 52),
				Position = v2(1520, 10),
			})
			watermark.Gradient = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(255, 0, 255),
				Position = v2(1520, 29),
			})
			watermark.BackgroundGradient = newDrawing("Image", {
				Position = v2(1540, 29),
				Visible = true,
				Transparency = 0.3,
				Data = game:HttpGet("https://i.imgur.com/sr6JZs6.png"),
				Size = v2(25, 4),
			})
			watermark.Text = newDrawing("Text", {
				Visible = true,
				Center = false,
				Font = 2,
				Outline = true,
				Text = "  ",
				Size = 13,
				Color = clr(255, 255, 255),
				Position = v2(1520, 12)
			})

			spectator = {}

			spectator.Background = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(41, 41, 52),
				Position = v2(1520, 40),
			})
			spectator.Gradient = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(255, 0, 255),
				Position = v2(1520, 59),
			})
			spectator.Background2 = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(25, 25, 33),
				Position = v2(1520, 63),
			})
			spectator.BackgroundGradient = newDrawing("Image", {
				Position = v2(1540, 59),
				Visible = true,
				Transparency = 0.3,
				Data = game:HttpGet("https://i.imgur.com/sr6JZs6.png"),
				Size = v2(25, 4),
			})
			spectator.Text2 = newDrawing("Text", {
				Visible = true,
				Center = false,
				Font = 2,
				Outline = true,
				Text = " no spectators ",
				Size = 13,
				Color = clr(255, 255, 255),
				Position = v2(1520, 65)
			})
			spectator.Text = newDrawing("Text", {
				Visible = true,
				Center = false,
				Font = 2,
				Outline = true,
				Text = " spectators list                ",
				Size = 13,
				Color = clr(255, 255, 255),
				Position = v2(1520, 42)
			})

			local lasttick = tick()
			game:GetService('RunService').RenderStepped:Connect(function(step)
				if (tick()-lasttick)*1000 > 25 then
					lasttick = tick()
					watermark.Text.Text = " " ..cheatnamel.. " | " ..user.. " | "  ..math.floor(1/step).. " fps | latency: " ..math.floor(game:GetService('Stats').Network.ServerStatsItem["Data Ping"]:GetValue()).. " ms "
				end
			end)

			game:GetService('RunService').RenderStepped:Connect(function()
				local WatermarkTextBoundsX = watermark.Text.TextBounds.X
				local WatermarkTextBoundsY = watermark.Text.TextBounds.Y

				local SpectatorTextBoundsX = spectator.Text.TextBounds.X
				local SpectatorTextBoundsY = spectator.Text.TextBounds.Y
				local SpectatorText2BoundsX = spectator.Text2.TextBounds.X
				local SpectatorText2BoundsY = spectator.Text2.TextBounds.Y

				watermark.Background.Size = v2(WatermarkTextBoundsX, WatermarkTextBoundsY) + v2(0, 6)
				watermark.Gradient.Size = v2(WatermarkTextBoundsX, 4)

				spectator.Background.Size = v2(SpectatorTextBoundsX, SpectatorTextBoundsY) + v2(0, 6)
				spectator.Background2.Size = v2(SpectatorTextBoundsX, SpectatorText2BoundsY) + v2(0, 6)
				spectator.Gradient.Size = v2(SpectatorTextBoundsX, 4)

				if SpectatorTextBoundsX <= SpectatorText2BoundsX then
					spectator.Gradient.Size = v2(SpectatorText2BoundsX, 4)
					spectator.Background.Size = v2(SpectatorText2BoundsX, SpectatorTextBoundsY) + v2(0, 6)
					spectator.Background2.Size = v2(SpectatorText2BoundsX, SpectatorText2BoundsY) + v2(0, 6)
				else
					spectator.Gradient.Size = v2(SpectatorTextBoundsX, 4)
					spectator.Background.Size = v2(SpectatorTextBoundsX, SpectatorTextBoundsY) + v2(0, 6)
					spectator.Background2.Size = v2(SpectatorTextBoundsX, SpectatorText2BoundsY) + v2(0, 6)
				end

				spectator.Background.Position = v2(values.misc.addons["Pos X2"].Slider, values.misc.addons["Pos Y2"].Slider) 
				spectator.Gradient.Position = v2(values.misc.addons["Pos X2"].Slider, values.misc.addons["Pos Y2"].Slider) + v2(0, 19)
				spectator.BackgroundGradient.Position = v2(values.misc.addons["Pos X2"].Slider, values.misc.addons["Pos Y2"].Slider) + v2(20, 19)
				spectator.Background2.Position = v2(values.misc.addons["Pos X2"].Slider, values.misc.addons["Pos Y2"].Slider) + v2(0, 23)
				spectator.Text2.Position = v2(values.misc.addons["Pos X2"].Slider, values.misc.addons["Pos Y2"].Slider) + v2(0, 25)
				spectator.Text.Position = v2(values.misc.addons["Pos X2"].Slider, values.misc.addons["Pos Y2"].Slider) + v2(0, 2)

				watermark.Background.Position = v2(values.misc.addons["Pos X"].Slider, values.misc.addons["Pos Y"].Slider)
				watermark.Gradient.Position = v2(values.misc.addons["Pos X"].Slider, values.misc.addons["Pos Y"].Slider) + v2(0, 19)
				watermark.BackgroundGradient.Position = v2(values.misc.addons["Pos X"].Slider, values.misc.addons["Pos Y"].Slider) + v2(20, 19)
				watermark.Text.Position = v2(values.misc.addons["Pos X"].Slider, values.misc.addons["Pos Y"].Slider) + v2(0, 2)

				watermark.Gradient.Color = theme.accent
				spectator.Gradient.Color = theme.accent
				indicators.lines.Color = theme.accent
				statusshit.FakelagStatus.Color = theme.accent
			end)

			function GetSpectators()
				local CurrentSpectators = ""
				for i,v in pairs(game.Players:GetChildren()) do 
					pcall(function()
						if v ~= game.Players.LocalPlayer then
							if not v.Character then 
								if (v.CameraCF.Value.p - game.Workspace.CurrentCamera.CFrame.p).Magnitude < 10 then 
										if CurrentSpectators == "" then
											CurrentSpectators = " "..v.Name
										else
											CurrentSpectators = CurrentSpectators.. " \n " ..v.Name
										end
									end
								end
							end
						end)
					end
				return CurrentSpectators
			end

			spawn(function()
				game:GetService('RunService').RenderStepped:Connect(function()
					spectator.Text2.Text = GetSpectators()
				end)
			end)
                
            for i,v in next, spectator do 
                v.Visible = false
            end
            
            indicators = {}

            indicators.cheatname = newDrawing("Text", {
                Visible = true,
                Outline = true,
                Font = 2,
                Size = 13,
                Center = true,
                Text = "Memzhack.pasted",
                Color = clr(255, 255, 255),
                Position = v2(960, 550),
            })
            indicators.lines = newDrawing("Square", {
                Visible = true,
                Filled = true,
                Color = clr(172, 208, 255),
                Position = v2(920, 567),
                Size = v2(80, 2)
            })
            indicators.doubletaptext = newDrawing("Text", {
                Visible = true,
                Outline = true,
                Font = 2,
                Size = 13,
                Center = true,
                Text = "dt",
                Color = clr(255, 59, 59),
                Position = v2(960, 571),
            })
            indicators.killalltext = newDrawing("Text", {
                Visible = true,
                Outline = true,
                Font = 2,
                Size = 13,
                Center = true,
                Text = "kill-all",
                Color = clr(255, 59, 59),
                Position = v2(960, 585),
            })
            indicators.knifebottext = newDrawing("Text", {
                Visible = true,
                Outline = true,
                Font = 2,
                Size = 13,
                Center = true,
                Text = "knife-bot",
                Color = clr(255, 59, 59),
                Position = v2(960, 601),
            })
            game:GetService('RunService').RenderStepped:Connect(function()
                if values.rage.aimbot.knifebot.Toggle then
                    indicators.knifebottext.Color = values.misc.addons["Menu Accent"].Color
                else
                    indicators.knifebottext.Color = clr(255, 255, 255)
                end

                if values.rage.exploits["kill all"].Toggle then
                    indicators.killalltext.Color = values.misc.addons["Menu Accent"].Color
                else
                    indicators.killalltext.Color = clr(255, 255, 255)
                end

                if values.rage.exploits["double tap"].Toggle then
                    indicators.doubletaptext.Color = values.misc.addons["Menu Accent"].Color
                else
                    indicators.doubletaptext.Color = clr(255, 255, 255)
                end
            end)

            for i,v in next, indicators do 
                v.Visible = false
            end

			statusshit = {}

			statusshit.Border = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(5, 5, 5),
				Position = v2(250, 750),
			})
			statusshit.Border2 = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(60, 60, 60),
				Position = v2(251, 751),
			})
			statusshit.Background = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(18, 18, 18),
				Position = v2(252, 752),
			})
			statusshit.IndicatorText = newDrawing("Text", {
				Visible = true,
				Outline = true,
				Font = 2,
				Size = 13,
				Text = "          Indicators          ",
				Color = clr(255, 255, 255),
				Position = v2(252, 752),
			})
			statusshit.Statuses = newDrawing("Text", {
				Visible = true,
				Outline = true,
				Font = 2,
				Size = 13,
				Text = " Fakelag:",
				Color = clr(255, 255, 255),
				Position = v2(252, 768),
			})
			statusshit.FakelagBorder = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(60, 60, 60),
				Position = v2(320, 771),
				Size = v2(140, 11)
			})
			statusshit.FakelagBackground = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(18, 18, 18),
				Position = v2(321, 772),
				Size = v2(138, 9)
			})
			statusshit.FakelagStatus = newDrawing("Square", {
				Visible = true,
				Filled = true,
				Color = clr(172, 208, 255),
				Position = v2(321, 772),
				Size = v2(0, 9)
			})

			game:GetService('RunService').RenderStepped:Connect(function()
				statusshit.Border.Size = v2(statusshit.IndicatorText.TextBounds.X, statusshit.Statuses.TextBounds.Y) + v2(4, 26)
				statusshit.Border2.Size = v2(statusshit.IndicatorText.TextBounds.X, statusshit.Statuses.TextBounds.Y) + v2(2, 24)
				statusshit.Background.Size = v2(statusshit.IndicatorText.TextBounds.X, statusshit.Statuses.TextBounds.Y) + v2(0, 22)

				statusshit.Border.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider)
				statusshit.Border2.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider) + v2(1, 1)
				statusshit.Background.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider) + v2(2, 2)
				statusshit.IndicatorText.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider) + v2(2, 2)
				statusshit.Statuses.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider) + v2(2, 18)
				statusshit.FakelagBorder.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider) + v2(70, 21)
				statusshit.FakelagBackground.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider) + v2(71, 22)
				statusshit.FakelagStatus.Position = v2(values.rage.aimbot["Pos X"].Slider, values.rage.aimbot["Pos Y"].Slider) + v2(71, 22)
			end)

			for i,v in next, statusshit do 
				v.Visible = false
			end		
			
			crosshair2o = {}

			crosshair2o.Line1o = newDrawing("Line", {
				Visible = true
			})
			crosshair2o.Line2o = newDrawing("Line", {
				Visible = true
			})
			crosshair2o.Line3o = newDrawing("Line", {
				Visible = true
			})
			crosshair2o.Line4o = newDrawing("Line", {
				Visible = true
			})  

			crosshair2 = {}

			crosshair2.Line1 = newDrawing("Line", {
				Visible = true
			})
			crosshair2.Line2 = newDrawing("Line", {
				Visible = true
			})
			crosshair2.Line3 = newDrawing("Line", {
				Visible = true
			})
			crosshair2.Line4 = newDrawing("Line", {
				Visible = true
			})  

			crosshair2o.Line1o.ZIndex = 1
			crosshair2o.Line2o.ZIndex = 1
			crosshair2o.Line3o.ZIndex = 1
			crosshair2o.Line4o.ZIndex = 1

			crosshair2.Line1.ZIndex = 2
			crosshair2.Line2.ZIndex = 2
			crosshair2.Line3.ZIndex = 2
			crosshair2.Line4.ZIndex = 2

			runService.Heartbeat:Connect(function(deltaTime)
				local crosshairCenter = screenCenter
				currentAngle = currentAngle + rad(crosshair.Speed*deltaTime)
				crosshair2.Line1.Thickness = crosshair.Thickness
				crosshair2.Line1.From = crosshairCenter + (v2(cos(currentAngle), sin(currentAngle))*crosshair.Gap)
				crosshair2.Line1.To = crosshair2.Line1.From + (v2(cos(currentAngle), sin(currentAngle))*crosshair.Size)
				crosshair2.Line1.Color = crosshair.Color

				crosshair2.Line2.Thickness = crosshair.Thickness
				crosshair2.Line2.From = crosshairCenter + (v2(cos(currentAngle + pi/2), sin(currentAngle + pi/2))*crosshair.Gap)
				crosshair2.Line2.To = crosshair2.Line2.From + (v2(cos(currentAngle + pi/2), sin(currentAngle + pi/2))*crosshair.Size)
				crosshair2.Line2.Color = crosshair.Color

				crosshair2.Line3.Thickness = crosshair.Thickness
				crosshair2.Line3.From = crosshairCenter + (v2(cos(currentAngle + pi), sin(currentAngle + pi))*crosshair.Gap)
				crosshair2.Line3.To = crosshair2.Line3.From + (v2(cos(currentAngle + pi), sin(currentAngle + pi))*crosshair.Size)
				crosshair2.Line3.Color = crosshair.Color

				crosshair2.Line4.Thickness = crosshair.Thickness
				crosshair2.Line4.From = crosshairCenter + (v2(cos(currentAngle + pi/2*3), sin(currentAngle + pi/2*3))*crosshair.Gap)
				crosshair2.Line4.To = crosshair2.Line4.From + (v2(cos(currentAngle + pi/2*3), sin(currentAngle + pi/2*3))*crosshair.Size)
				crosshair2.Line4.Color = crosshair.Color
				
				crosshair2o.Line1o.Thickness = crosshair.Thickness + 2
				crosshair2o.Line2o.Thickness = crosshair.Thickness + 2
				crosshair2o.Line3o.Thickness = crosshair.Thickness + 2
				crosshair2o.Line4o.Thickness = crosshair.Thickness + 2

				if crosshair.Outline == true then
				crosshair2o.Line1o.From = crosshair2.Line1.From
				crosshair2o.Line2o.From = crosshair2.Line2.From
				crosshair2o.Line3o.From = crosshair2.Line3.From
				crosshair2o.Line4o.From = crosshair2.Line4.From
				crosshair2o.Line1o.To = crosshair2.Line1.To
				crosshair2o.Line2o.To = crosshair2.Line2.To
				crosshair2o.Line3o.To = crosshair2.Line3.To
				crosshair2o.Line4o.To = crosshair2.Line4.To
				else
					for i,v in next, crosshair2o do 
						v.Visible = false
					end
				end
			end)

			for i,v in next, crosshair2 do 
				v.Visible = false
			end
			for i,v in next, crosshair2o do 
				v.Visible = false
			end	
			
			game:GetService('RunService').RenderStepped:Connect(function()
                for i,v in next, loader do 
                    v.Visible = false
                end
                for i,v in next, changelog do 
                    v.Visible = false
                end
                for i,v in next, Users do 
                    v.Visible = false
                end
				for i,v in next, cursor do 
                    v.Visible = false
                end
            end)
			connection:Disconnect()
        end
        if utility:MouseOverDrawing({loader.CloseButtonBackground.Position.X, loader.CloseButtonBackground.Position.Y, loader.CloseButtonBackground.Position.X + loader.CloseButtonBackground.Size.X, loader.CloseButtonBackground.Position.Y + 14}) then
            game:GetService('RunService').RenderStepped:Connect(function()
                for i,v in next, loader do 
                    v.Visible = false
                end
                for i,v in next, changelog do 
                    v.Visible = false
                end
                for i,v in next, Users do 
                    v.Visible = false
                end
				for i,v in next, cursor do 
                    v.Visible = false
                end
            end)
			connection:Disconnect()
        end
        if utility:MouseOverDrawing({loader.Changelogbutton.Position.X, loader.Changelogbutton.Position.Y, loader.Changelogbutton.Position.X + loader.Changelogbutton.Size.X, loader.Changelogbutton.Position.Y + loader.ChangelogsText.TextBounds.Y}) then
            for i,v in next, changelog do 
                if v.Visible == true then
                    v.Visible = false
                elseif v.Visible == false then
                    v.Visible = true
                end
            end
        end
        if utility:MouseOverDrawing({loader.Userbutton.Position.X, loader.Userbutton.Position.Y, loader.Userbutton.Position.X + loader.Userbutton.Size.X, loader.Userbutton.Position.Y + loader.ChangelogsText.TextBounds.Y}) then
            for i,v in next, Users do 
                if v.Visible == true then
                    v.Visible = false
                elseif v.Visible == false then
                    v.Visible = true
                end
            end
        end
    end
end)

game:GetService('RunService').RenderStepped:Connect(function()
    changelog.Border.Size = v2(284, changelog.Text.TextBounds.Y) + v2(0, 26)
    changelog.Border2.Size = v2(282, changelog.Text.TextBounds.Y) + v2(0, 24)
    changelog.Background.Size = v2(280, changelog.Text.TextBounds.Y) + v2(0, 22)
    changelog.BackgroundGradient.Size = v2(280, changelog.Text.TextBounds.Y) + v2(0, 22)

    Users.Border.Size = v2(284, Users.Text.TextBounds.Y) + v2(0, 26)
    Users.Border2.Size = v2(282, Users.Text.TextBounds.Y) + v2(0, 24)
    Users.Background.Size = v2(280, Users.Text.TextBounds.Y) + v2(0, 22)
    Users.BackgroundGradient.Size = v2(280, Users.Text.TextBounds.Y) + v2(0, 22)

    loader.Changelogbutton.Size = v2(loader.ChangelogsText.TextBounds.X, loader.ChangelogsText.TextBounds.Y)
    loader.Userbutton.Size = v2(loader.UsersText.TextBounds.X, loader.UsersText.TextBounds.Y)

    local mousePosition = uis:GetMouseLocation()
    cursor.Icon.Position = v2(mousePosition.X, mousePosition.Y)
end)