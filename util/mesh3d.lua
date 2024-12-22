--[[pod_format="raw",created="2024-03-18 19:20:44",modified="2024-03-19 05:24:12",revision=1163]]
local utilpath = "https://raw.githubusercontent.com/piconet-picotron/piconet-home/main/util/"
webinclude(utilpath.."face.lua")
webinclude(utilpath.."obj3d.lua")
webinclude(utilpath.."util3d.lua")

function new_mesh(faces,transformation)
	local transformation = transformation or new_transform()
	o = new_obj(transformation)
	o.get_child = function(self,index)
		local c = self.children[index]
		local verts = {}
		local r_mat = rotate3d_udata(self.transformation.rot)
		for v in all(c.verts) do
			local u = v:add(self.transformation.pose)
			u:sub(self.transformation.pose,true)
			u:matmul3d(r_mat,true)
			u:add(self.transformation.pose,true)
			add(verts,u)
		end
		
		return new_face(verts[1],verts[2],verts[3])
	end
	o.children = faces or {}
	return o
end

function parse_obj_file(filename, scale)--very barebones for the time being
	local file = fetch(filename)
	local list = split(file,"\n")
	local verts = {}
	local faces = {}
	local scale = scale or 1
	for i=1,#list do
		local data = split(list[i]," ")
		if data[1] == "v" then
			add(verts,vec(data[2]*scale,data[3]*scale,data[4]*scale))
		elseif data[1] == "f" then
			local data1 = split(data[2],"/")[1]
			local data2 = split(data[3],"/")[1]
			local data3 = split(data[4],"/")[1]
			add(faces,new_face(verts[data1],verts[data2],verts[data3]))
		end
	end
	return faces
end

function get_mesh_faces_recursive(list,mesh)
	if not mesh.children then
		add(list,mesh)
		return
	end
	for i = 1,#mesh.children do
		get_mesh_faces_recursive(list,mesh:get_child(i))
	end
end

function draw_mesh(mesh)
	local queue = {}
	get_mesh_faces_recursive(queue,box)
	for i in all(queue) do
		draw_face_wireframe(i)
	end
end
