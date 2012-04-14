package com.utils
{
	import flash.events.Event;
	
	public class InterfaceEvent extends Event
	{
		public static const PAUSE:String = "pause";
		public static const UNPAUSE:String = "unpause";
		public static const CUSTOMIZE:String = "customize";
		public static const UPDATEAVATAR:String = "updateAvatar";
		public static const SHAKEBABY:String = "shakeBaby";
		public static const SHAKEBABYSOUND:String = "shakeBabySound";
		public static const SHRINKBABY:String = "shrinkBaby";
		public static const ZAPAVATAR:String = "zapAvatar";
		public static const FOUNDSECRET:String = "foundSecret";
		public static const DOSCREAM:String = "doScream";
		//
		public static const UPDATEHUD:String = "updateHUD";
		//
		public static const WIN:String = "youWin";
		public static const LOSE:String = "youLose";
		public static const RESTART:String = "doRestart";
		public static const GAMESTART:String = "gameStart";
		public static const NEXTLEVEL:String = "doNextLevel";
		public static const REACHEDGOAL:String = "reachedGoal";
		
		
		public function InterfaceEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
		}
	}
}