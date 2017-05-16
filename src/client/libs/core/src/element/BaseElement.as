package element
{
	import laya.maths.Point;
	import laya.maths.Rectangle;

	public class BaseElement implements IElement
	{
		public var elementId: int;
		public var rect: Rectangle;

		public function BaseElement()
		{
			super();
			rect = new Rectangle;
		}

		public function update(delta: Number):void
		{

		}

		public function setPos(x: Number, y: Number):void
		{
			rect.x = x;
			rect.y = y;
		}

		public function getPos(): Point
		{
			var tp : Point = Point.TEMP;
			tp.setTo(rect.x, rect.y);
			return tp;
		}

		public function setSize(w: Number, h: Number):void
		{
			rect.width = w;
			rect.height = h;
		}

	}
}

