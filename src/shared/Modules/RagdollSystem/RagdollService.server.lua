local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local RagdollFactory = require(script.Parent.RagdollFactory)

local Remotes = script.Parent.Remotes
local ActivateRagdollRemote: RemoteEvent = Remotes.ActivateRagdollRemote
local DeactivateRagdollRemote: RemoteEvent = Remotes.DeactivateRagdollRemote
local CollapseRagdollRemote: RemoteEvent = Remotes.CollapseRagdollRemote
local ActivateRagdollBindable: BindableEvent = Remotes.ActivateRagdollBindable
local DeactivateRagdollBindable: BindableEvent = Remotes.DeactivateRagdollBindable
local CollapseRagdollBindable: BindableEvent = Remotes.CollapseRagdollBindable

local npcRagdolls: { [any]: RagdollFactory.Ragdoll? } = {}

function onNPCRagdollAdded(npcModel)
	npcRagdolls[npcModel] = RagdollFactory.new(npcModel)
end

function onNPCRagdollRemoved(npcModel)
	local ragdoll = npcRagdolls[npcModel]
	if not ragdoll then
		return
	end
	ragdoll:destroy()
end

for _, npcModel in CollectionService:GetTagged("NPCRagdoll") do
	onNPCRagdollAdded(npcModel)
end

CollectionService:GetInstanceAddedSignal("NPCRagdoll"):Connect(onNPCRagdollAdded)
CollectionService:GetInstanceRemovedSignal("NPCRagdoll"):Connect(onNPCRagdollRemoved)

local ragdolls: { [any]: RagdollFactory.Ragdoll? } = {}

function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(character)
		local ragdoll = ragdolls[player.UserId]
		if ragdoll then
			ragdoll:Destroy()
		end

		ragdoll = RagdollFactory.new(character)
		ragdolls[player.UserId] = ragdoll
	end)
end

function onPlayerRemoving(player: Player)
	local ragdoll = ragdolls[player.UserId]
	if ragdoll then
		ragdoll:destroy()
	end

	ragdolls[player.UserId] = nil
end

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

function activateRagdollPhysics(player: Player)
	local ragdoll = ragdolls[player.UserId]
	if ragdoll then
		ragdoll:activateRagdollPhysics()
	end
end

function deactivateRagdollPhysics(player: Player)
	local ragdoll = ragdolls[player.UserId]
	if ragdoll then
		ragdoll:deactivateRagdollPhysics()
	end
end

function collapseRagdoll(player: Player)
	local ragdoll = ragdolls[player.UserId]
	if ragdoll then
		ragdoll:collapse()
	end
end

ActivateRagdollRemote.OnServerEvent:Connect(activateRagdollPhysics)
ActivateRagdollBindable.Event:Connect(activateRagdollPhysics)
DeactivateRagdollRemote.OnServerEvent:Connect(deactivateRagdollPhysics)
DeactivateRagdollBindable.Event:Connect(deactivateRagdollPhysics)
CollapseRagdollRemote.OnServerEvent:Connect(collapseRagdoll)
CollapseRagdollBindable.Event:Connect(collapseRagdoll)