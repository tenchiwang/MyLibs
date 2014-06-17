package com.tenchiwang.security
{
	import flash.utils.ByteArray;

	public class SecuritySimple
	{
		
		static public function deCode(code:String):String
		{
			var ary:Array = code.split(',');
			var bAry:ByteArray = new ByteArray();
			
			var len:int = ary.length;
			for(var i:int = 0 ; i < len; i++)
			{
				bAry.writeByte(int(ary[i]));
			}
			
			return bAry.toString();
		}
		
		static public function encrypt(code:String):String
		{
			var bAry:ByteArray = new ByteArray();
			bAry.writeUTFBytes(code);
			
			var len:int = bAry.length;
			var encrypt:String = '';
			for(var i:int = 0 ; i < len; i++)
			{
				encrypt += bAry[i];
				if(i < len-1)
					encrypt += ',';
			}
			
			return encrypt;
		}

	}
}