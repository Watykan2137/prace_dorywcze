local PlayerData                = {}
ESX                             = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)
local coord_x = -269.27
local coord_y = -955.44
local coord_z = 30.30

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(GetPlayerPed(-1))

			if(GetDistanceBetweenCoords(coords, coord_x, coord_y, coord_z, true) < 100.0) then
				DrawMarker(1, coord_x, coord_y, coord_z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 100, 100, 204, 100, false, true, 2, false, false, false, false)
			end
	end
end)



Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil
        if(GetDistanceBetweenCoords(coords, coord_x, coord_y, coord_z, true) < 1.2) then
			DisplayHelpText("Nacisnij ~INPUT_CONTEXT~ aby uzyskać prace dorywczą")
		end
		if(GetDistanceBetweenCoords(coords, coord_x, coord_y, coord_z, true) < 1.2) and IsControlJustReleased(0, 38) then
			isInMarker  = true
			second_job_menu()
		end
	end
end)

function second_job_menu()

	if PlayerData.job ~= nil then
		local data = PlayerData.job
		TriggerServerEvent("esx_secondjob:changejob", data)
	else
		ESX.ShowNotification("Nie możesz zmienić pracy")
	end

end