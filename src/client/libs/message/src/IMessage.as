package
{
	import laya.utils.Byte;

	public interface IMessage
	{
		function get msgId(): int;
		function read(byte: Byte):void;
		function write(byte: Byte):void;
	}
}

