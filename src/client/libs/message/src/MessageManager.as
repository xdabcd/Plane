package
{
	import laya.utils.Byte;

	public class MessageManager
	{
		public static var I: MessageManager = new MessageManager;

		private var ids: int;
		private var clzArr: Array;
		private var msgArr: Array;

		public function MessageManager()
		{
		}

		public function readMessage(byte: Byte): IMessage
		{
			byte.pos = 0;
			var id: int = byte.getInt32();
			var msg: IMessage = getMessageById(id);
			msg.read(byte);
			return msg;
		}

		public function writeMessage(msg: IMessage, byte: Byte):void
		{
			byte.clear();
			byte.writeInt32(msg.msgId);
			msg.write(byte);
		}

		public function getMessageByClass(clz: Class): *
		{
			var id: int = clzArr.indexOf(clz);
			return getMessageById(id);
		}

		public function getMessageById(id: int): *
		{
			return msgArr[id];
		}

		private function regMessageList(clzList: Array):void
		{
			for (var i:int = 0; i < clzList.length; i++) 
			{
				regMessage(clzList[i]);
			}

		}

		private function regMessage(clz: Class):void
		{
			clz[BaseMessage.ID_SIGN] = ids;
			clzArr[ids] = clz;
			msgArr[ids] = new clz();
			ids++;
		}
	}
}

