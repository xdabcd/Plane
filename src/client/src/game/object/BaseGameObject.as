package game.object
{
	import element.BaseElement;

	import laya.display.Sprite;
	import laya.maths.Point;

	public class BaseGameObject extends Sprite implements IGameObject
	{
		public var ele: BaseElement;

		public function BaseGameObject()
		{
		}

		public function init(id: int):void
		{
			ele.elementId = id;
		}

		public function update():void
		{
			var pos: Point = ele.getPos();
			x = pos.x;
			y = pos.y;
		}

		public function sync(info: *):void
		{
		}

		public function recover():void
		{
			parent && parent.removeChild(this);
		}

		public function get id(): int
		{
			return  ele.elementId;
		}
	}
}

