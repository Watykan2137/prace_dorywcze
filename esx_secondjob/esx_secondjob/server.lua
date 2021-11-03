-- Skrypt od strony Serwera

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_secondjob:changejob')
AddEventHandler('esx_secondjob:changejob', function(data)
	local data = data
	local job = data.name
	local grade = data.grade
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local steamid = xPlayer["identifier"]
	local job_2 = "unemployed"
	local grade_2 = "0"
	if job == "offpolice" or job == "offambulance" or job == "offmecano" or job == "ballas" or job == "vagos" or job == "tortuga" or job == "mafia" then
		MySQL.Async.fetchAll('SELECT * FROM second_job WHERE `steamid` =  "' .. steamid .. '"', {}, function(result)
			if result[1] ~= nil then
				local wyniki = MySQL.Sync.fetchAll('UPDATE `second_job` SET `job` = @job,`grade`=@grade WHERE `steamid`=@steamid', {['@steamid'] = steamid,['@job'] = job,['@grade'] = grade})
				job_2 = result[1].job_2
				grade_2 = result[1].grade_2
				xPlayer.setJob(job_2, grade_2)
				TriggerClientEvent('FeedM:showNotification', _source, "Teraz możesz pracować dorywczo")
			else
				local wyniki = MySQL.Sync.fetchAll('INSERT INTO `second_job` (`id`, `steamid`, `job`, `grade`, `job_2`, `grade_2`) VALUES (NULL,@steamid,@job,@grade,@job_2,@grade_2)', {['@steamid'] = steamid,['@job'] = job,['@grade'] = grade,['@job_2'] = job_2,['@grade_2'] = grade_2})
				local xPlayer = ESX.GetPlayerFromId(_source)
				if xPlayer ~= nil then
					xPlayer.setJob(job_2, grade_2)
					TriggerClientEvent('FeedM:showNotification', _source, "Teraz możesz pracować dorywczo")
				else
					TriggerClientEvent('FeedM:showNotification', _source, "Wystapił błąd")
				end
			end
		end)
	elseif job == "police" or job == "ambulance" or job == "mecano" then
		TriggerClientEvent('FeedM:showNotification', _source, "Musisz być poza służbą aby pracować dorywczo")
	else
		MySQL.Async.fetchAll('SELECT * FROM second_job WHERE `steamid` =  "' .. steamid .. '"', {}, function(result)
			if result[1] ~= nil then
				job_1 = result[1].job
				grade_1 = result[1].grade
				xPlayer.setJob(job_1, grade_1)
				local wyniki = MySQL.Sync.fetchAll('UPDATE `second_job` SET `job_2` = @job,`grade_2`=@grade WHERE `steamid`=@steamid', {['@steamid'] = steamid,['@job'] = job,['@grade'] = grade})
				TriggerClientEvent('FeedM:showNotification', _source, "Kończysz prace dorywczą")
			else
				TriggerClientEvent('FeedM:showNotification', _source, "Tylko EMS/LSPD/LSCM może pracować dorywczo")
			end
		end)
	end
end)