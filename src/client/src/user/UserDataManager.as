package user
{
	import laya.net.LocalStorage;

	public class UserDataManager
	{
		public static var I: UserDataManager = new UserDataManager;

		private const KEY: String = "ship_user";
		private var userData: Object;

		public function UserDataManager()
		{
			userData = LocalStorage.getJSON(KEY) || {};
		}

		public function setUserData(key: String, value: *):void
		{
			userData[key] = value;
			save();
		}

		public function getUserData(key: String): *
		{
			return userData[key];
		}

		private function save():void
		{
			LocalStorage.setJSON(KEY, userData);
		}
	}
}

