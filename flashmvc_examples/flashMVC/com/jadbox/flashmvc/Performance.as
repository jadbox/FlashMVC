/**
 * FLASHMVC
 * Copyright (c) 2008 Jonathan Dunlap, http://www.jadbox.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.jadbox.flashmvc
{
	/**
	 * SuperModel can process a Performance class that mocks up the command that needs to run, its params, and a callback for success and fail.
	 * 
	 */	
	public final class Performance {
		/** 
		 * Name of the action class 
		 */
		public var name:String;
		/**
		 * Paremeters for the action class 
		*/
		public var params:Array;
		/** 
		 * OnCompete function for when the class executes successfully. 
		*/
		public var onComplete:Function;
		/** 
		 * OnFail function for when the class designates that it failed. 
		*/
		public var onFail:Function;
		/**
		 * Internal only - DO NOT USE
		*/
		public var superModel:SuperModel;
		internal var status:String;
		/** 
		 * Main contructor that can take in all the class fields. 
		 */
		public function Performance(name:String="", onComplete:Function=null, onFail:Function=null, ...params) {
			this.name = name;
			if(onComplete !== null) this.onComplete = onComplete;
			if(onFail !== null) this.onFail = onFail;
			if(params) this.params = params;
			
		}
		
	}
}