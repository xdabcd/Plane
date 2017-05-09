package
{
	import laya.utils.Byte;

	public class BaseMessage implements IMessage
	{
		public static const NUMBER: int = 1;
		public static const INT: int = 2;
		public static const STRING: int = 3;
		public static const ARRAY: int = 4;
		public static const CLASS: int = 5;

		public static const DES_SIGN:String = "DES";
		public static const ID_SIGN:String = "MSG_ID";

		public function BaseMessage()
		{
		}

		public function get msgId():int
		{
			return this["__class"][ID_SIGN];
		}

		public function read(byte:Byte):void
		{
			var temp: Array;
			var des: Array = this[DES_SIGN];
			for (var i:int = 0; i < des.length; i++) 
			{
				temp = des[i];
				this[temp[0]] = readObj(byte, temp[1], temp[2]);
			}
		}

		public function write(byte:Byte):void
		{
			var temp: Array;
			var des: Array = this[DES_SIGN];
			for (var i:int = 0; i < des.length; i++) 
			{
				temp = des[i];
				writeObj(this[temp[0]], byte, temp[1], temp[1]);
			}
		}

		private function readObj(byte: Byte, type: int, des: *): *		
		{
			var value: *;
			switch(type)
			{
				case NUMBER:
					value = byte.getFloat64();
					break;
				case INT:
					value = byte.getInt32();
					break;
				case STRING:
					value = byte.readUTFString();
					break;
				case ARRAY:
					value = readArray(byte, des);
					break;
				case CLASS:
					value = readClass(byte, des);
					break;
			}
			return value;
		}

		private function readArray(byte: Byte, des: Array): Array
		{
			var length: int = byte.getInt32();
			var rst: Array = [];
			for (var i:int = 0; i < length; i++) 
			{
				rst[i] = readObj(byte, des[0], des[1]);
			}
			return rst;
		}

		private function readClass(byte: Byte, clz: Class): BaseMessage
		{	
			var rst: BaseMessage = new clz();
			rst.read(byte);
			return rst;
		}

		private function writeObj(value: *, byte: Byte, type: int, des: *):void
		{
			switch(type)
			{
				case NUMBER:
					byte.writeFloat64(value);
					break;
				case INT:
					byte.writeInt32(value);
					break;
				case STRING:
					byte.writeUTFString(value);
					break;
				case ARRAY:
					writeArray(value, byte, des);
					break;
				case CLASS:
					writeClass(value, byte, des);
					break;
			}
		}

		private function writeArray(arr: Array, byte: Byte, des: Array):void
		{
			byte.writeInt32(arr.length);
			for (var i:int = 0; i < arr.length; i++) 
			{
				writeObj(arr[i], byte, des[0], des[1]);
			}
		}

		private function writeClass(msg: BaseMessage, byte: Byte, clz: Class):void
		{
			msg.write(byte);
		}
	}
}

