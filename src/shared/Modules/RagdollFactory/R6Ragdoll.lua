local BaseRagdoll = require(script.Parent.BaseRagdoll)

local ARM_SOCKET_SETTINGS = { MaxFrictionTorque = 150, UpperAngle = 90, TwistLowerAngle = -45, TwistUpperAngle = 45 }
local LEG_SOCKET_SETTINGS = { MaxFrictionTorque = 150, UpperAngle = 40, TwistLowerAngle = -5, TwistUpperAngle = 20 }
local SOCKET_SETTINGS = {
	Head = { MaxFrictionTorque = 150, UpperAngle = 15, TwistLowerAngle = -15, TwistUpperAngle = 15 },
	Torso = { MaxFrictionTorque = 50, UpperAngle = 20, TwistLowerAngle = 0, TwistUpperAngle = 30 },
	["Right Arm"] = ARM_SOCKET_SETTINGS,
	["Left Arm"] = ARM_SOCKET_SETTINGS,
	["Right Leg"] = LEG_SOCKET_SETTINGS,
	["Left Leg"] = LEG_SOCKET_SETTINGS,
}

local RIGHT_SHOULDER_ATTACHMENT_CFRAME0 = CFrame.new(1, 0.763, 0)
local RIGHT_SHOULDER_ATTACHMENT_CFRAME1 = CFrame.new(-0.5, 0.763, 0)
local LEFT_SHOULDER_ATTACHMENT_CFRAME0 = CFrame.new(-1, 0.763, 0)
local LEFT_SHOULDER_ATTACHMENT_CFRAME1 = CFrame.new(0.5, 0.763, -0)
local RIGHT_HIP_ATTACHMENT_CFRAME0 = CFrame.new(0.5, -1, -0)
local LEFT_HIP_ATTACHMENT_CFRAME0 = CFrame.new(-0.5, -1, -0)
local HIP_ATTACHMENT_CFRAME1 = CFrame.new(0, 1, 0)

function setupLimbs(ragdoll)
	local torso = ragdoll.character.Torso
	local rootJoint: Motor6D = ragdoll.humanoidRootPart.RootJoint
	BaseRagdoll._setupLimb(ragdoll, SOCKET_SETTINGS, ragdoll.humanoidRootPart, torso, rootJoint.C0, rootJoint.C1)

	local head = ragdoll.character.Head
	local neckJoint: Motor6D = torso.Neck
	BaseRagdoll._setupLimb(ragdoll, SOCKET_SETTINGS, torso, head, neckJoint.C0, neckJoint.C1)

	local rightArm = ragdoll.character["Right Arm"]
	BaseRagdoll._setupLimb(
		ragdoll,
		SOCKET_SETTINGS,
		torso,
		rightArm,
		RIGHT_SHOULDER_ATTACHMENT_CFRAME0,
		RIGHT_SHOULDER_ATTACHMENT_CFRAME1
	)

	local leftArm = ragdoll.character["Left Arm"]
	BaseRagdoll._setupLimb(
		ragdoll,
		SOCKET_SETTINGS,
		torso,
		leftArm,
		LEFT_SHOULDER_ATTACHMENT_CFRAME0,
		LEFT_SHOULDER_ATTACHMENT_CFRAME1
	)

	local rightLeg = ragdoll.character["Right Leg"]
	BaseRagdoll._setupLimb(
		ragdoll,
		SOCKET_SETTINGS,
		torso,
		rightLeg,
		RIGHT_HIP_ATTACHMENT_CFRAME0,
		HIP_ATTACHMENT_CFRAME1
	)

	local leftLeg = ragdoll.character["Left Leg"]
	BaseRagdoll._setupLimb(
		ragdoll,
		SOCKET_SETTINGS,
		torso,
		leftLeg,
		LEFT_HIP_ATTACHMENT_CFRAME0,
		HIP_ATTACHMENT_CFRAME1
	)
end

local NUM_CONSTRAINTS = 14 -- number of constraints created on an R6 Rig

local R6Ragdoll = setmetatable({}, BaseRagdoll)
R6Ragdoll.__index = R6Ragdoll

function R6Ragdoll.new(character): BaseRagdoll.Ragdoll
	local self = setmetatable(BaseRagdoll.new(character, NUM_CONSTRAINTS), R6Ragdoll)
	setupLimbs(self)

	self._trove:Connect(self.humanoid.Died, function()
		self:enable()
	end)

	return self
end

return R6Ragdoll
