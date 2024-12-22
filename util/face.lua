--[[pod_format="raw",created="2024-03-18 06:20:49",modified="2024-03-19 05:24:12",revision=2405]]

function new_face(v1,v2,v3,fill)
	local u = {v1, v2, v3}
	
	local texture, clr
	
	if type(fill) == "number" then
		clr = fill
	elseif fill then
		texture = fill
	end
	
	return {
		verts = u,
		clr = clr,
		texture = texture
	}
end

function draw_face_wireframe(face)
	local v = face.verts	
	assert(v[3])
	line(v[1]:get(0), v[1]:get(1), v[2]:get(0), v[2]:get(1),10)
	line(v[2]:get(0), v[2]:get(1), v[3]:get(0), v[3]:get(1),10)
	line(v[3]:get(0), v[3]:get(1), v[1]:get(0), v[1]:get(1),10)
end