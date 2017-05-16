package manager
{
	import game.Client;
	import game.Room;

	import laya.utils.Byte;

	import sMsg.SMSGEnterRoom;
	import sMsg.SMSGUserChange;
	import sMsg.SMSGUserEnter;
	import sMsg.SMSGUserLeave;

	public class MessageSendManager
	{
		public static var I: MessageSendManager = new MessageSendManager;

		private var helpByte: Byte = new Byte;

		public function MessageSendManager()
		{
			helpByte.endian = Byte.LITTLE_ENDIAN;
		}

		public function enterRoomHanler(client: Client, room: Room):void
		{
			var msg: SMSGEnterRoom = getMessage(SMSGEnterRoom);
			msg.userId = client.id;
			msg.time = room.leftTime;
			msg.userList = room.userList;
			client.sendMessage(msg);
			trace("房间" + room.id + "当前用户人数:" + msg.userList.length);

			/** 广播给其他人 */
			var msg2: SMSGUserEnter = getMessage(SMSGUserEnter);
			msg2.time = Laya.timer.currTimer;
			msg2.userInfo = client.player.userInfo;
			room.sendToOtherClient(client.id, msg2);
		}

		public function changeDirectionHandler(client: Client, room: Room):void
		{
			var msg: SMSGUserChange = getMessage(SMSGUserChange);
			msg.time = room.leftTime;
			msg.userinfo = client.player.userInfo;
			room.sendAll(msg);
		}

		public function userLeaveHandler(client: Client, room: Room):void
		{
			var msg: SMSGUserLeave = getMessage(SMSGUserLeave);
			msg.userId = client.id;
			room.sendToOtherClient(client.id, msg);
		}


		private function getMessage(clz: Class): *
		{
			return MessageManager.I.getMessageByClass(clz);
		}
	}
}

