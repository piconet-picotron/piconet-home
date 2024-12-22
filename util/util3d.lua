--[[pod_format="raw",created="2024-03-18 06:21:03",modified="2024-03-19 05:24:12",revision=2265]]

function new_transform(pose, rot)
	return {
		rot = rot or vec(0,0,0),
		pose = pose or vec(0,0,0)
	}
end

function rotate3d_udata(r)
	local x = r:get(0) % (math.pi*2)
	local y = r:get(1) % (math.pi*2)
	local z = r:get(2) % (math.pi*2)
	local cx,cy,cz = math.cos(x),math.cos(y),math.cos(z)
	local sx,sy,sz = math.sin(x),math.sin(y),math.sin(z)
	local mat = userdata("f64",4,4)
	--here I try to save resources by multiplying the matrices beforehand
	mat:set(0,0,
		cy*cz,						-sz*cy,					sy,			0,
		(sx*sy*cz)+(sz*cx),		(cx*cz)-(sx*sy*sz),		-sx*cy,	0,
		(sx*sz)-(sy*cx*cz),		(sx*cz)+(sy*sz*cx),		cx*cy,		0,
		0,							0,							0,			1
	)
	return mat
end

function x_rot_udata(rad)
	local m = userdata("f64",4,4)
	local c = math.cos(rad)
	local s = math.sin(rad)
	m:set(0,0,
		1,	0,	0,	0,
		0,	c,	-s,	0,
		0,	s,	c,	0,
		0,	0,	0,	1
	)
	
	return m
end

function y_rot_udata(rad)
	local m = userdata("f64",4,4)
	local c = math.cos(rad)
	local s = math.sin(rad)
	m:set(0,0,
		c,	0,	s,	0,
		0,	1,	0,	0,
		-s,	0,	c,	0,
		0,	0,	0,	1
	)
	return m
end

function z_rot_udata(rad)
	local m = userdata("f64",4,4)
	local c = math.cos(rad)
	local s = math.sin(rad)
	m:set(0,0,
		c,	-s,	0,	0,
		s,	c,	0,	0,
		0, 	0, 	1,	0,
		0,	0,	0,	1
	)
	return m
end

--			if v==nil then
--				assert(false,b:__tostring())--[[
--				c:__tostring()..
--				"\n"..b:get(0,0).." "..b:get(1,0).." "..b:get(2,0).." "..b:get(3,0)..
--				"\n"..b:get(0,1).." "..b:get(1,1).." "..b:get(2,1).." "..b:get(3,1)..
--				"\n"..b:get(0,2).." "..b:get(1,2).." "..b:get(2,2).." "..b:get(3,2)..
--				"\n"..b:get(0,3).." "..b:get(1,3).." "..b:get(2,3).." "..b:get(3,3)
--				)--]]
--			end