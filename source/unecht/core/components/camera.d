﻿module unecht.core.components.camera;

import unecht.core.component;

import unecht.core.types;

import gl3n.linalg;
import std.math:PI_4;

//TODO: add properties and make matrix updates implicit
/// 
final class UECamera : UEComponent
{
	vec3 dir = vec3(0,0,1);
	vec3 up = vec3(0,1,0);

	mat4 matProjection;
	mat4 matLook;

	float fieldOfView = PI_4;
	float clipNear = 1;
	float clipFar = 1000;

	vec4 clearColor;
	bool clearBitColor = true;
	bool clearBitDepth = true;

	UERect viewport;

	override void onCreate() {
		super.onCreate;

		import unecht;
		viewport.size = ue.application.mainWindow.size;
	}

	void updateLook()
	{
		auto target = entity.sceneNode.position + dir;

		matLook = mat4.look_at(
			entity.sceneNode.position,
			target,
			up);
	}

	void updateProjection()
	{
		matProjection = mat4.perspective(1024,768,fieldOfView,clipNear,clipFar);
	}

	void render()
	{
		import unecht;
		import derelict.opengl3.gl3;
		import unecht.core.components.misc;

		auto renderers = ue.scene.gatherAllComponents!UERenderer;
		
		updateProjection();
		updateLook();
		
		auto clearBits = 0;
		if(clearBitColor) clearBits |= GL_COLOR_BUFFER_BIT;
		if(clearBitDepth) clearBits |= GL_DEPTH_BUFFER_BIT;
		
		glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
		glClear(clearBits);
		glViewport(viewport.pos.left,viewport.pos.top,viewport.size.width,viewport.size.height);
		
		foreach(r; renderers)
			r.render(this);
	}
}