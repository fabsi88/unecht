module app;

import unecht;

///
final class TestControls : UEComponent
{
    mixin(UERegisterComponent!());

    override void onCreate() {
        super.onCreate;

        registerEvent(UEEventType.key, &OnKeyEvent);
    }

    void OnKeyEvent(UEEvent _ev)
    {
        if(_ev.keyEvent.action == UEEvent.KeyEvent.Action.Down)
        {
            if(_ev.keyEvent.key == UEKey.esc)
                ue.application.terminate();
            
            if(_ev.keyEvent.key == UEKey.num1)
            {
                spawnBox();
            }
            if(_ev.keyEvent.key == UEKey.num2)
            {
                spawnBall();
            }
        }
    }

    static void spawnBall()
    {
        auto newE = UEEntity.create("ode ball");
        import std.random:uniform;
        newE.sceneNode.position = vec3(uniform(0.0f,1),15,uniform(0.0f,1));

        newE.addComponent!UEShapeSphere;
        newE.addComponent!UEPhysicsBody;
        newE.addComponent!UEPhysicsColliderSphere;
    }

    static void spawnBox()
    {
        auto newE = UEEntity.create("ode box");
        import std.random:uniform;
        newE.sceneNode.position = vec3(uniform(0.0f,1),15,uniform(0.0f,1));
        newE.sceneNode.scaling = vec3(1,1,2);

        newE.addComponent!UEShapeBox;
        newE.addComponent!UEPhysicsBody;
        newE.addComponent!UEPhysicsColliderBox;
    }
}

final class GameBorders : UEComponent
{
    mixin(UERegisterComponent!());
    
    override void onCreate() {
        super.onCreate;
      
        enum z = 10;
        enum x = 15;

        enum h = 2;
        {
            auto newE = UEEntity.create("border",sceneNode);
            newE.sceneNode.position = vec3(0,h/2,-z);
            newE.sceneNode.scaling = vec3(x,h,1);
            newE.addComponent!UEShapeBox;
            newE.addComponent!UEPhysicsColliderBox;
        }
        {
            auto newE = UEEntity.create("border",sceneNode);
            newE.sceneNode.position = vec3(0,h/2,z);
            newE.sceneNode.scaling = vec3(x,h,1);
            newE.addComponent!UEShapeBox;
            newE.addComponent!UEPhysicsColliderBox;
        }
        {
            auto newE = UEEntity.create("border",sceneNode);
            newE.sceneNode.position = vec3(-x,h/2,0);
            newE.sceneNode.scaling = vec3(1,h,z);
            newE.addComponent!UEShapeBox;
            newE.addComponent!UEPhysicsColliderBox;
        }
        {
            auto newE = UEEntity.create("border",sceneNode);
            newE.sceneNode.position = vec3(x,h/2,0);
            newE.sceneNode.scaling = vec3(1,h,z);
            newE.addComponent!UEShapeBox;
            newE.addComponent!UEPhysicsColliderBox;
        }
    }
}

shared static this()
{
	ue.windowSettings.size.width = 1024;
	ue.windowSettings.size.height = 768;
	ue.windowSettings.title = "unecht - hello world sample";

	ue.hookStartup = () {
		auto newE = UEEntity.create("game");
        newE.addComponent!TestControls;
        newE.addComponent!UEPhysicsColliderPlane;

        newE = UEEntity.create("borders");
        newE.addComponent!GameBorders;

        //TestControls.spawnBox();

		auto newE2 = UEEntity.create("app test entity 2");
		newE2.sceneNode.position = vec3(0,3,-20);

		import unecht.core.components.camera;
		auto cam = newE2.addComponent!UECamera;
		cam.clearColor = vec4(0,0,0,1);

		auto newEs = UEEntity.create("sub entity ");
        newEs.sceneNode.position = vec3(1,0,-5);
		newEs.sceneNode.parent = newE.sceneNode;
	};
}