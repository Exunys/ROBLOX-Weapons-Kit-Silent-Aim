--[[

	ROBLOX Weapons Kit Silent Aim by Exunys © CC0 1.0 Universal (2023)
	https://github.com/Exunys
	Edited by Rtxyy

]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera


getgenv().FOVCricle , FOV = Drawing.new("Circle") , 160
FOVCricle.Visible = true
FOVCricle.Radius = FOV
FOVCricle.Filled = false
FOVCricle.Thickness = 1
FOVCricle.Color = Color3.new(1, 1, 1)
FOVCricle.Position = Vector2.new(Camera.ViewportSize.x / 2, Camera.ViewportSize.y / 2)



local function GetClosestPlayer()
	local RequiredDistance, Part, Target = FOV, "HumanoidRootPart"
	for _, v in next, Players.GetPlayers(Players) do
		if v ~= LocalPlayer and v.Character[Part] then
			local Vector, OnScreen = Camera.WorldToViewportPoint(Camera, v.Character[Part].Position)
			local Distance = (UserInputService.GetMouseLocation(UserInputService) - Vector2.new(Vector.X, Vector.Y)).Magnitude

			if Distance < RequiredDistance and OnScreen then
				RequiredDistance = Distance
				Target = v
			end
		end
	end

	return Target
end

local Old; Old = hookmetamethod(game, "__namecall", newcclosure(function(...)
	local Self, Arguments = ..., {select(2, ...)}

	if not checkcaller() and getnamecallmethod() == "FindPartOnRayWithIgnoreList" and getcallingscript().Name == "ClientWeaponsScript" then
		Arguments[1] = Ray.new(Arguments[1].Origin, (GetClosestPlayer().Character.Head.Position - Arguments[1].Origin))

		return Old(Self, table.unpack(Arguments))
	end

	return Old(...)
end))
