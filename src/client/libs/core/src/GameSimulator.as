package
{
	import element.PlayerElement;

	public class GameSimulator
	{
		private var players: Object = {};

		public function GameSimulator()
		{
		}

		public function update(delta: Number):void
		{
			delta /= 1000;
			for each (var player: PlayerElement in players) 
			{
				player.update(delta);
			}

		}

		public function addPlayer(player: PlayerElement):void
		{
			players[player.elementId] = player;
		}

		public function removePlayer(player: PlayerElement):void
		{
			delete players[player.elementId];
		}
	}
}

