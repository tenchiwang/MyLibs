package com.tenchiwang.unitTest
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.describeType;
	import flash.utils.setTimeout;

	public class BasicUnitTestCase extends EventDispatcher
	{
		static public const UNIT_TEST_END:String = 'UNIT_TEST_END';
		
		private var _testCaseList:Vector.<TestCaseVo>;
		private var _detail:String = '';
		private var _log:String = '';
		private var _ErrorCount:int;
		private var _PassCount :int;
		private var _isPass:Boolean = false;
		
		// 基本的測試類別!
		public function BasicUnitTestCase()
		{
			_testCaseList = new Vector.<TestCaseVo>();
			
			saveDetail('Analyze Unit Test....');
			
			var accessorsList:XMLList = describeType(this).method; 
			var fun:Function;
			var vo:TestCaseVo;
			var acces:XML;
			var metadataName:String;
			
			for(var i:int = 0;i<accessorsList.length();i++)
			{
				acces = accessorsList[i];
				
				var le:int = acces.metadata.length();
				
				if(le==0)
					continue;
				
				metadataName = acces.metadata[0].@name;
				metadataName = metadataName.toLocaleLowerCase();
				
				switch(metadataName)
				{
					case 'test':
						fun = this[acces['@name']] as Function;
						
						if(fun != null)
						{
							vo = new TestCaseVo();
							vo.name = acces['@name'];
							vo.fun = fun;
							 _testCaseList.push(vo);
						}
						break;
					
					default:
				}
			}
			
			saveDetail('Analyze Unit Test End. Get ' + _testCaseList.length + ' tests');
			//
		}
		
		final public function runTest():void
		{
			showLog('Unit Test Start.');
			
			saveDetail('Unit Test Start ....');
			saveDetail('=======================');
			runTest2();			
		}
		
		private var _waitList:Vector.<uint> = new Vector.<uint>();
		final public function waitTime(closure:Function, delay:int, ...args:Array):int
		{
			args.unshift(closure, delay);
			var id:int = setTimeout.apply(this, args);
			_waitList.push(id);
			return id;
		}
		
		private function clearWaitTime():void
		{
			var len:int = _waitList.length;
			for(var i:int = 0; i < len; i++)
			{
				clearTimeout(_waitList.pop());
			}
		}
		
		final public function assertEquals(a:*, b:*):void
		{
			if( a === b)
			{
				_PassCount++;
				_isPass = true;
			}else{
				var len:int = _testCaseList.length;
				if(_idx < len)
				{
					var vo:TestCaseVo = _testCaseList[_idx];
					showLog('Test Case ' + vo.name + ' Assert Error.');
					saveDetail('Test Case ' + vo.name + ' Assert Error.');
				}
			}
			
			testCallBack();
		}
		
		final public function get ErrorCount():int
		{
			return _testCaseList.length - _PassCount;
		}
		
		//========================================================
		private var _idx:int = 0;
		private function runTest2():void
		{
			var len:int = _testCaseList.length;
			if(_idx < len)
			{
				var vo:TestCaseVo = _testCaseList[_idx];
				_isPass = false;
				
				saveDetail( vo.name + ' Start.' );
				
				startUp();
				
				try
				{
					vo.fun.call();
				}
				catch(error:Error)
				{
					showLog('Test Case ' + vo.name + ' Error.');
					saveDetail('Test Case ' + vo.name + ' Error.');
					_ErrorCount++;
				}
				catch(evt:ErrorEvent)
				{
					showLog('Test Case ' + vo.name + ' Error.');
					saveDetail('Test Case ' + vo.name + ' Error.');
					_ErrorCount++;
				}
				
			}else{
				showLog('Unit Test End.');
				
				showLog('Test Case ' + len);
				showLog('Pass Case '  + _PassCount );
				showLog('Error Case ' + _ErrorCount);
				
				//
				saveDetail('=======================');
				saveDetail('Unit Test End.');
				
				saveDetail('Test Case ' + len);
				saveDetail('Pass Case '  + _PassCount );
				saveDetail('Error Case ' + _ErrorCount);
				
				this.dispatchEvent(new Event(UNIT_TEST_END));
			}
		}
		
		private function testCallBack():void
		{
			var len:int = _testCaseList.length;
			if(_idx < len)
			{
				var vo:TestCaseVo = _testCaseList[_idx];
				clearWaitTime();
				shutdown();
				saveDetail(vo.name + ' End. ' );
				_idx++;
				setTimeout(runTest2, 100);
			}else{
				_ErrorCount++;
			}
		}
		
		private function saveDetail(msg:String):void
		{
			_detail += getDate() + msg + '\n';
		}
		
		private function getDate():String
		{
			var date:Date = new Date();
			var dateStr:String = '[' + date.getUTCHours() + ' : ' + date.getUTCMinutes() + ' : ' + 
				date.getUTCSeconds() + ' ' + date.getUTCMilliseconds() +'] ' ;
			
			return dateStr;
		}
		
		/**
		 *  每次 unit test 前須要做的事
		 */
		protected function startUp():void
		{
			throw new Error('Plz override startUp.');
		}
		
		/**
		 *  每次 unit test 後須要做的事
		 */
		protected function shutdown():void
		{
			throw new Error('Plz override shutdown.');
		}
		
		/**
		 * 預設的顯示 Log 的通用函數
		 * @param msg
		 * 
		 */		
		protected function showLog(msg:String):void
		{
			trace(getDate() + msg);
		}
		
		/**
		 * 顯示詳細的測試資料.
		 */
		public function get Detail():String
		{
			return _detail;
		}
		
	}
}

internal class TestCaseVo
{
	public var name:String;
	public var fun:Function;
}