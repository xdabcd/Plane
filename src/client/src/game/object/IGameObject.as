package game.object
{
	public interface IGameObject
	{
		function init(id: int): void;
		function sync(info: *): void;
		function update(): void;
		function recover(): void;
	}
}

