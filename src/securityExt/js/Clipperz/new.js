if (typeof(Clipperz) == 'undefined') { Clipperz = {}; }
if (typeof(Clipperz.Base) == 'undefined') { Clipperz.Base = {}; }

Clipperz.Base.VERSION = "0.1";
Clipperz.Base.NAME = "Clipperz.Base";

MochiKit.Base.update(Clipperz.Base, {

	//-------------------------------------------------------------------------

	'__repr__': function () {
		return "[" + this.NAME + " " + this.VERSION + "]";
	},

	//-------------------------------------------------------------------------

	'toString': function () {
		return this.__repr__();
	},

	//-------------------------------------------------------------------------

	'trim': function (aValue) {
		return aValue.replace(/^\s+|\s+$/g, "");
	},

	//-------------------------------------------------------------------------

	'stringToByteArray': function (aValue) {
		var	result;
		var i, c;

		result = [];
		
		c = aValue.length;
		for (i=0; i<c; i++) {
			result[i] = aValue.charCodeAt(i);
		}
		
		return result;
	},
	
	//.........................................................................
	
	'byteArrayToString': function (anArrayOfBytes) {
		var	result;
		var i, c;

		result = "";

		c = anArrayOfBytes.length;
		for (i=0; i<c; i++) {
			result += String.fromCharCode(anArrayOfBytes[i]);
		}
		
		return result;
	},

	//-------------------------------------------------------------------------

	'getValueForKeyInFormContent': function (aFormContent, aKey) {
		return aFormContent[1][MochiKit.Base.find(aFormContent[0], aKey)];
	},

	//-------------------------------------------------------------------------

	'indexOfObjectInArray': function(anObject, anArray) {
		var	result;
		var	i, c;
		
		result = -1;

		c = anArray.length;
		for (i=0; ((i<c) && (result < 0)); i++) {
			if (anArray[i] === anObject) {
				result = i;
			}
		}

		return result;
	},

	'removeObjectAtIndexFromArray': function(anIndex, anArray) {
		anArray.splice(anIndex, 1);
	},
	
	'removeObjectFromArray': function(anObject, anArray) {
		var	objectIndex;
		
		objectIndex = Clipperz.Base.indexOfObjectInArray(anObject, anArray);
		if (objectIndex > -1) {
			Clipperz.Base.removeObjectAtIndexFromArray(objectIndex, anArray);
		} else {
//			jslog.error("Trying to remove an object not present in the array");
			//	TODO: raise an exception
		}
	},
	
	'removeFromArray': function(anArray, anObject) {
		return Clipperz.Base.removeObjectFromArray(anObject, anArray);
	},

	//-------------------------------------------------------------------------

	'splitStringAtFixedTokenSize': function(aString, aTokenSize) {
		var result;
		var	stringToProcess;
		
		stringToProcess = aString;
		result = [];
		if (stringToProcess != null) {
			while (stringToProcess.length > aTokenSize) {
				result.push(stringToProcess.substring(0, aTokenSize));
				stringToProcess = stringToProcess.substring(aTokenSize);
			}
			
			result.push(stringToProcess);
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'objectType': function(anObject) {
		var result;

		if (anObject == null) {
			result = null;
		} else {
			result = typeof(anObject);
			
			if (result == "object") {
				if (anObject instanceof Array) {
					result = 'array'
				} else if (anObject.constructor == Boolean) {
					result = 'boolean'
				} else if (anObject instanceof Date) {
					result = 'date'
				} else if (anObject instanceof Error) {
					result = 'error'
				} else if (anObject instanceof Function) {
					result = 'function'
				} else if (anObject.constructor == Number) {
					result = 'number'
				} else if (anObject.constructor == String) {
					result = 'string'
				} else if (anObject instanceof Object) {
					result = 'object'
				} else {
					throw Clipperz.Base.exception.UnknownType;
				}
			}
		}
		
		return result;
	},

	//-------------------------------------------------------------------------

	'escapeHTML': function(aValue) {
		var result;

		result = aValue;
		result = result.replace(/</g, "&lt;");
		result = result.replace(/>/g, "&gt;");
		
		return result;
	},

	//-------------------------------------------------------------------------

	'deepClone': function(anObject) {
		var result;
		
		result = MochiKit.Base.evalJSON(MochiKit.Base.serializeJSON(anObject));
		
		return result;
	},

	//-------------------------------------------------------------------------

	'exception': {
		'AbstractMethod': new MochiKit.Base.NamedError("Clipperz.Base.exception.AbstractMethod"),
		'UnknownType':    new MochiKit.Base.NamedError("Clipperz.Base.exception.UnknownType") 
	},

	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"

});



MochiKit.Base.registerComparator('Object dummy comparator',
	function(a, b) {
		return ((a.constructor == Object) && (b.constructor == Object));
	},
	function(a, b) {
		var result;
		var aKeys;
		var bKeys;
		
//MochiKit.Logging.logDebug(">>> comparator");
//MochiKit.Logging.logDebug("- a: " + MochiKit.Base.serializeJSON(a));
//MochiKit.Logging.logDebug("- b: " + MochiKit.Base.serializeJSON(a));
		aKeys = MochiKit.Base.keys(a).sort();
		bKeys = MochiKit.Base.keys(b).sort();
		
		result = MochiKit.Base.compare(aKeys, bKeys);
//if (result != 0) {
//	MochiKit.Logging.logDebug("- comparator 'keys':");
//	MochiKit.Logging.logDebug("- comparator aKeys: " + MochiKit.Base.serializeJSON(aKeys));
//	MochiKit.Logging.logDebug("- comparator bKeys: " + MochiKit.Base.serializeJSON(bKeys));
//}
		if (result == 0) {
			var	i, c;
			
			c = aKeys.length;
			for (i=0; (i<c) && (result == 0); i++) {
				result = MochiKit.Base.compare(a[aKeys[i]], b[bKeys[i]]);
//if (result != 0) {
//	MochiKit.Logging.logDebug("- comparator 'values':");
//	MochiKit.Logging.logDebug("- comparator a[aKeys[i]]: " + MochiKit.Base.serializeJSON(a[aKeys[i]]));
//	MochiKit.Logging.logDebug("- comparator b[bKeys[i]]: " + MochiKit.Base.serializeJSON(b[bKeys[i]]));
//}
			}
		}		
		
//MochiKit.Logging.logDebug("<<< comparator - result: " + result);
		return result;
	},
	true
);
if (typeof(Clipperz) == 'undefined') { Clipperz = {}; }

//=============================================================================

Clipperz.ByteArray_abstract = function(args) {
	return this;
}

Clipperz.ByteArray_abstract.prototype = MochiKit.Base.update(null, {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.ByteArray_abstract";
	},
	
	//-------------------------------------------------------------------------

	'equals': function(aValue) {
		return (this.compare(aValue) == 0);
	},
	
	//-------------------------------------------------------------------------

	'compare': function(aValue) {
		var result;
		var i;
		
		result = MochiKit.Base.compare(this.length(), aValue.length());
		i = this.length();
		
		while ((result == 0) && (i>0)) {
			i--;
			result = MochiKit.Base.compare(this.byteAtIndex(i), aValue.byteAtIndex(i));
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'clone': function() {
		throw Clipperz.Base.exception.AbstractMethod;
	},

	//-------------------------------------------------------------------------

	'newInstance': function() {
		throw Clipperz.Base.exception.AbstractMethod;
	},
	
	//-------------------------------------------------------------------------

	'reset': function() {
		throw Clipperz.Base.exception.AbstractMethod;
	},
	
	//-------------------------------------------------------------------------
	
	'length': function() {
		throw Clipperz.Base.exception.AbstractMethod;
	},
	
	//-------------------------------------------------------------------------

	'checkValue': function(aValue) {
		if ((aValue & 0xff) != aValue) {
			MochiKit.Logging.logError("Clipperz.ByteArray.appendByte: the provided value (0x" + aValue.toString(16) + ") is not a byte value.");
			throw Clipperz.ByteArray.exception.InvalidValue;
		}
	},
	
	//-------------------------------------------------------------------------

	'xorMergeWithBlock': function(aBlock, anAllignment, paddingMode) {
		var result;
		var a, b;
		var aLength;
		var bLength;			
		var i, c;
		
		if (this.length() > aBlock.length()) {
			a = this;
			b = aBlock;
		} else {
			a = aBlock;
			b = this;
		}

		aLength = a.length();
		bLength = b.length();

		if (aLength != bLength) {
			if (paddingMode == 'truncate') {
				if (anAllignment == 'left') {
					a = a.split(0, bLength);
				} else {
					a = a.split(aLength - bLength);
				}
			} else {
				var ii, cc;
				var padding;
				
//				padding = new Clipperz.ByteArray();
				padding = this.newInstance();
				cc = aLength - bLength;
				for (ii=0; ii<cc; ii++) {
					padding.appendByte(0);
				}
				
				if (anAllignment == 'left') {
					b = b.appendBlock(padding);
				} else {
					b = padding.appendBlock(b);
				}
			}
		}


//		result = new Clipperz.ByteArray();
		result = this.newInstance();
		c = a.length();
		for (i=0; i<c; i++) {
			result.appendByte(a.byteAtIndex(i) ^ b.byteAtIndex(i));
		}

		return result;
	},

	//-------------------------------------------------------------------------
/*
	'shiftLeft': function(aNumberOfBitsToShift) {
		var result;

		result = this.clone();	//	???????????
		
		return result;
	},
*/	
	//-------------------------------------------------------------------------

	'appendBlock': function(aBlock) {
		throw Clipperz.Base.exception.AbstractMethod;
	},

	//-------------------------------------------------------------------------

	'appendByte': function(aValue) {
		throw Clipperz.Base.exception.AbstractMethod;
	},

	'appendBytes': function(args) {
		var	values;
		var	i,c;

		if (args.constructor == Array) {
			values = args;
		} else {
			values = arguments;
		}

		c = values.length;
		for (i=0; i<c; i++) {
			this.appendByte(values[i]);
		}
		
		return this;
	},
	
	//-------------------------------------------------------------------------

	'appendWord': function(aValue, isLittleEndian) {
		var result;
		var processAsLittleEndian;
		
		processAsLittleEndian = isLittleEndian === true ? true : false;
		
		if (processAsLittleEndian) {
			result = this.appendBytes(	(aValue) & 0xff, (aValue >> 8) & 0xff, (aValue >> 16) & 0xff, (aValue >> 24) & 0xff	);	//	little endian
		} else {
			result = this.appendBytes(	(aValue >> 24) & 0xff, (aValue >> 16) & 0xff, (aValue >> 8) & 0xff, (aValue) & 0xff	);	//	big endian - DEFAULT
		}
		
		return result;
	},

	'appendWords': function(args) {
		var	values;
		var	i,c;

		if (args.constructor == Array) {
			values = args;
		} else {
			values = arguments;
		}

		c = values.length;
		for (i=0; i<c; i++) {
			this.appendWord(values[i], false);
		}
		
		return this;
	},

	//-------------------------------------------------------------------------

	'appendBigEndianWords': function(args) {
		var	values;
		var	i,c;

		if (args.constructor == Array) {
			values = args;
		} else {
			values = arguments;
		}

		c = values.length;
		for (i=0; i<c; i++) {
			this.appendWord(values[i], true);
		}
		
		return this;
	},

	//-------------------------------------------------------------------------

	'byteAtIndex': function(anIndex) {
		throw Clipperz.Base.exception.AbstractMethod;
	},
	
	'setByteAtIndex': function(aValue, anIndex) {
		throw Clipperz.Base.exception.AbstractMethod;
	},

	//-------------------------------------------------------------------------

	'bitAtIndex': function(aBitPosition) {
		var result;
		var	bytePosition;
		var bitPositionInSelectedByte;
		var selectedByte;
		var selectedByteMask;
		
		bytePosition = this.length() - Math.ceil((aBitPosition + 1)/ 8);
		bitPositionInSelectedByte = aBitPosition % 8;
		selectedByte = this.byteAtIndex(bytePosition);

		if (bitPositionInSelectedByte > 0) {
			selectedByteMask = (1 << bitPositionInSelectedByte);
		} else {
			selectedByteMask = 1;
		}
		result = selectedByte & selectedByteMask ? 1 : 0;
//console.log("aBitPosition: " + aBitPosition + ", length: " + this.length() + ", bytePosition: " + bytePosition + ", bitPositionInSelectedByte: " + bitPositionInSelectedByte + ", selectedByteMask: " + selectedByteMask);
		
		return result;
	},

	//-------------------------------------------------------------------------

	'bitBlockAtIndexWithSize': function(aBitPosition, aSize) {
		var result;
		var bitValue;
		var i,c;
		
		result = 0;
		c = aSize;
		for (i=0; i<c; i++) {
			bitValue = this.bitAtIndex(aBitPosition + i);
			result = result | bitValue << i;
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'asString': function() {
		var	result;
		var	length;
		var	i;

//var startTime = new Date();

//#		result = "";
		result = [];
		
		i = 0;
		length = this.length();
		
		while (i < length) {
			var	currentCharacter;
			var	currentByte;
			var	unicode;
			
			currentByte = this.byteAtIndex(i);
			
			if ((currentByte & 0x80) == 0x00 ) {		//	0xxxxxxx
				unicode = currentByte;
				currentCharacter = String.fromCharCode(unicode);
			} else if ((currentByte & 0xe0) == 0xc0 ) {	//	110xxxxx 10xxxxxx
				unicode = (currentByte & 0x1f) << 6;
				i++; currentByte = this.byteAtIndex(i);
				unicode = unicode | (currentByte & 0x3f);

				currentCharacter = String.fromCharCode(unicode);
			} else if ((currentByte & 0xf0) == 0xe0 ) {	//	1110xxxx 10xxxxxx 10xxxxxx
				unicode = (currentByte & 0x0f) << (6+6);
				i++; currentByte = this.byteAtIndex(i);
				unicode = unicode | ((currentByte & 0x3f) << 6);
				i++; currentByte = this.byteAtIndex(i);
				unicode = unicode | (currentByte & 0x3f);
				
				currentCharacter = String.fromCharCode(unicode);
			} else {									//	11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				unicode = (currentByte & 0x07) << (6+6+6);
				i++; currentByte = this.byteAtIndex(i);
				unicode = unicode | ((currentByte & 0x3f) << (6+6));
				i++; currentByte = this.byteAtIndex(i);
				unicode = unicode | ((currentByte & 0x3f) << 6);
				i++; currentByte = this.byteAtIndex(i);
				unicode = unicode | (currentByte & 0x3f);
				
				currentCharacter = String.fromCharCode(unicode);
			}
			
//			result += currentCharacter;
			result.push(currentCharacter);
			i++;
		}

//MochiKit.Logging.logDebug("[" + (new Date() - startTime) + "] ByteArray.asString");

//		return result;
		return result.join("");
	},

	//-------------------------------------------------------------------------

	'toHexString': function() {
		throw Clipperz.Base.exception.AbstractMethod;
	},
	
	//-------------------------------------------------------------------------
	
	'base64map': "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
	'base64mapIndex': "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split(''),
//	'base64mapInvertedIndex': {
//		'A':  0, 'B':  1, 'C':  2, 'D':  3, 'E':  4, 'F':  5, 'G':  6, 'H':  7, 'I':  8, 'J':  9,
//		'K': 10, 'L': 11, 'M': 12, 'N': 13, 'O': 14, 'P': 15, 'Q': 16, 'R': 17, 'S': 18, 'T': 19,
//		'U': 20, 'V': 21, 'W': 22, 'X': 23, 'Y': 24, 'Z': 25, 'a': 26, 'b': 27, 'c': 28, 'd': 29,
//		'e': 30, 'f': 31, 'g': 32, 'h': 33, 'i': 34, 'j': 35, 'k': 36, 'l': 37, 'm': 38, 'n': 39,
//		'o': 40, 'p': 41, 'q': 42, 'r': 43, 's': 44, 't': 45, 'u': 46, 'v': 47, 'w': 48, 'x': 49,
//		'y': 50, 'z': 51, '0': 52, '1': 53, '2': 54, '3': 55, '4': 56, '5': 57, '6': 58, '7': 59,
//		'8': 60, '9': 61, '+': 62, '/': 63,
//		"=": -1},

	//-------------------------------------------------------------------------
	
	'appendBase64String': function(aValue) {
		var i;
		var length;

		length = aValue.length;
		
		if ((length % 4) != 0) {
			MochiKit.Logging.logError("the value passed to the 'ByteArray.setBase64Value' is not correct");
			throw Clipperz.ByteArray.exception.InvalidValue;
		}

		i = 0;
		while (i<length) {
			var value1, value2, value3, value4;
			var byte1, byte2, byte3;
			
			value1 = this.base64map.indexOf(aValue.charAt(i));
			value2 = this.base64map.indexOf(aValue.charAt(i+1));
			value3 = this.base64map.indexOf(aValue.charAt(i+2));
			value4 = this.base64map.indexOf(aValue.charAt(i+3));

//			value1 = this.base64mapInvertedIndex[aValue.charAt(i)];
//			value2 = this.base64mapInvertedIndex[aValue.charAt(i+1)];
//			value3 = this.base64mapInvertedIndex[aValue.charAt(i+2)];
//			value4 = this.base64mapInvertedIndex[aValue.charAt(i+3)];

			byte1 = (value1 << 2) | ((value2 & 0x30) >> 4);
			if (value3 != -1) {
				byte2 = ((value2 & 0x0f) << 4) | ((value3 & 0x3c) >> 2);

				if (value4 != -1) {
					byte3 = ((value3 & 0x03) << 6) | (value4);
				} else {
					byte3 = null;
				}
			} else {
				byte2 = null;
				byte3 = null;
			}

			this.appendByte(byte1);
			this.appendByte(byte2);
			this.appendByte(byte3);

			i += 4;
		}
		
		return this;
	},

	//-------------------------------------------------------------------------
	
	'toBase64String': function() {
		var result;
		var length;
		var i;
		var byte1, byte2, byte3;
		var char1, char2, char3, char4;
		
		i = 0;
		length = this.length();
		result = new Array(Math.ceil(length/3));
		
		while (i < length) {
			byte1 = this.byteAtIndex(i);
			if ((i+2) < length) {
				byte2 = this.byteAtIndex(i+1);
				byte3 = this.byteAtIndex(i+2);
			} else if ((i+2) == length) {
				byte2 = this.byteAtIndex(i+1);
				byte3 = null;
			} else {
				byte2 = null;
				byte3 = null;
			}
			
			char1 = this.base64mapIndex[byte1 >> 2];
			if (byte2 != null) {
				char2 = this.base64mapIndex[((byte1 & 0x03) << 4) | ((byte2 & 0xf0) >> 4)];
				if (byte3 != null) {
					char3 = this.base64mapIndex[((byte2 & 0x0f) << 2) | ((byte3 & 0xc0) >> 6)];
					char4 = this.base64mapIndex[(byte3 & 0x3f)];
				} else {
					char3 = this.base64mapIndex[(byte2 & 0x0f) << 2];
					char4 = "=";
				}
			} else {
				char2 = this.base64mapIndex[(byte1 & 0x03) << 4];
				char3 = "=";
				char4 = "=";
			}

			result.push(char1 + char2 + char3 + char4);
			
			i += 3;
		}

		return result.join("");
	},

	//-------------------------------------------------------------------------

	'base32map': "0123456789abcdefghjkmnpqrstvwxyz",
	'base32mapIndex': "0123456789abcdefghjkmnpqrstvwxyz".split(''),

	//-------------------------------------------------------------------------
	
	'appendBase32String': function(aValue) {
		var value;
		var i;
		var length;
		var value1, value2, value3, value4, value5, value6, value7, value8;
		var byte1, byte2, byte3, byte4, byte5;

		value = aValue.toLowerCase();
		value = value.replace(/[\s\-]/g, '');
		value = value.replace(/[0o]/g, '0');
		value = value.replace(/[1il]/g, '1');

		length = value.length;
		
		if ((length % 8) != 0) {
			MochiKit.Logging.logError("the value passed to the 'ByteArray.setBase32Value' is not correct");
			throw Clipperz.ByteArray.exception.InvalidValue;
		}

		i = 0;
		while (i<length) {
			value1 = this.base32map.indexOf(value.charAt(i));
			value2 = this.base32map.indexOf(value.charAt(i+1));
			value3 = this.base32map.indexOf(value.charAt(i+2));
			value4 = this.base32map.indexOf(value.charAt(i+3));
			value5 = this.base32map.indexOf(value.charAt(i+4));
			value6 = this.base32map.indexOf(value.charAt(i+5));
			value7 = this.base32map.indexOf(value.charAt(i+6));
			value8 = this.base32map.indexOf(value.charAt(i+7));

			byte1 = byte2 = byte3 = byte4 = byte5 = null;
			
			byte1 = (value1 << 3) | ((value2 & 0x1c) >> 2);
			if (value3 != -1) {
				byte2 = ((value2 & 0x03) << 6) | (value3 << 1) | ((value4 & 0x10) >> 4);
				if (value5 != -1) {
					byte3 = ((value4 & 0x0f) << 4) | ((value5 & 0x1e) >> 1);
					if (value6 != -1) {
						byte4 = ((value5 & 0x01) << 7) | (value6 << 2) | ((value7 & 0x18) >> 3);
						if (value8 != -1) {
							byte5 = ((value7 & 0x07) << 5) | (value8);
						}
					}
				}
			}

			this.appendByte(byte1);
			this.appendByte(byte2);
			this.appendByte(byte3);
			this.appendByte(byte4);
			this.appendByte(byte5);

			i += 8;
		}

		return this;
	},

	//-------------------------------------------------------------------------

	'toBase32String': function() {
		var result;
		var length;
		var i;
		var byte1, byte2, byte3, byte4, byte5;
		var char1, char2, char3, char4, char5, char6, char7, char8;
		
		i = 0;
		length = this.length();
		result = new Array(Math.ceil(length/5));
		
		while (i < length) {
			byte1 = this.byteAtIndex(i);
			
			if ((i+4) < length) {
				byte2 = this.byteAtIndex(i+1);
				byte3 = this.byteAtIndex(i+2);
				byte4 = this.byteAtIndex(i+3);
				byte5 = this.byteAtIndex(i+4);
			} else if ((i+4) == length) {
				byte2 = this.byteAtIndex(i+1);
				byte3 = this.byteAtIndex(i+2);
				byte4 = this.byteAtIndex(i+3);
				byte5 = null;
			} else if ((i+3) == length) {
				byte2 = this.byteAtIndex(i+1);
				byte3 = this.byteAtIndex(i+2);
				byte4 = null;
				byte5 = null;
			} else if ((i+2) == length) {
				byte2 = this.byteAtIndex(i+1);
				byte3 = null;
				byte4 = null;
				byte5 = null;
			} else {
				byte2 = null;
				byte3 = null;
				byte4 = null;
				byte5 = null;
			}

			
			char1 = this.base32mapIndex[byte1 >> 3];
			char2 = char3 = char4 = char5 = char6 = char7 = char8 = "=";
			
			if (byte2 != null) {
				char2 = this.base32mapIndex[((byte1 & 0x07) << 2) | ((byte2 & 0xc0) >> 6)];
				char3 = this.base32mapIndex[((byte2 & 0x3e) >> 1)];
				if (byte3 != null) {
					char4 = this.base32mapIndex[((byte2 & 0x01) << 4) | ((byte3 & 0xf0) >> 4)];
					if (byte4 != null) {
						char5 = this.base32mapIndex[((byte3 & 0x0f) << 1) | ((byte4 & 0x80) >> 7)];
						char6 = this.base32mapIndex[(byte4 & 0x7c) >> 2];
						if (byte5 != null) {
							char7 = this.base32mapIndex[((byte4 & 0x03) << 3) | ((byte5 & 0xe0) >> 5)];
							char8 = this.base32mapIndex[(byte5 & 0x1f)];
						} else {
							char7 = this.base32mapIndex[(byte4 & 0x03) << 3];
						}
					} else {
						char5 = this.base32mapIndex[(byte3 & 0x0f) << 1];
					}

				} else {
					char4 = this.base32mapIndex[(byte2 & 0x01) << 4];
				}
			} else {
				char2 = this.base32mapIndex[(byte1 & 0x07) << 2];
			}

			result.push(char1 + char2 + char3 + char4 + char5 + char6 + char7 + char8);
			i += 5;
		}

		return result.join("");
	},
	
	//-------------------------------------------------------------------------

	'split': function(aStartingIndex, anEndingIndex) {
		throw Clipperz.Base.exception.AbstractMethod;
	},

	//-------------------------------------------------------------------------

	'increment': function() {
		var i;
		var done;
		
		done = false;
		i = this.length() - 1;
		
		while ((i>=0) && (done == false)) {
			var currentByteValue;
			
			currentByteValue = this.byteAtIndex(i);
			
			if (currentByteValue == 0xff) {
				this.setByteAtIndex(0, i);
				if (i>= 0) {
					i --;
				} else {
					done = true;
				}
			} else {
				this.setByteAtIndex(currentByteValue + 1, i);
				done = true;
			}
		}
	},
	
	//-------------------------------------------------------------------------

	'arrayValues': function() {
		throw Clipperz.Base.exception.AbstractMethod;
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
	
});

//=============================================================================
//
//	Clipperz.ByteArray_hex
//
//=============================================================================
Clipperz.ByteArray_hex = function (args) {
	this._value = "";

	if (typeof(args) != 'undefined') {
		if (args.constructor == Array) {
			this.appendBytes(args);
		} else if (args.constructor == String) {
			if (args.indexOf("0x") == 0) {
				var	value;
			
				value = args.substring(2).toLowerCase();
				if (/[0123456789abcdef]*/.test(value)) {
					if ((value.length % 2) == 0) {
						this._value = value;
					} else {
						this._value = "0" + value;
					}
				} else {
MochiKit.Logging.logError("Clipperz.ByteArray should be inizialized with an hex string.");
					throw Clipperz.ByteArray.exception.InvalidValue;
				}
			} else {
				var	value;
				var	i,c;

				c = args.length;
				value = new Array(c);
				for (i=0; i<c; i++) {
					value.push(Clipperz.ByteArray.unicodeToUtf8HexString(args.charCodeAt(i)));
				}

				this._value = value.join("");
			}
		} else {
			this.appendBytes(MochiKit.Base.extend(null, arguments));
		}
	}
	return this;
}

Clipperz.ByteArray_hex.prototype = MochiKit.Base.update(new Clipperz.ByteArray_abstract(), {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.ByteArray_hex";
	},
	
	//-------------------------------------------------------------------------

	'clone': function() {
		var result;
		
		result = this.newInstance();
		result._value = this._value;
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'newInstance': function() {
		return new Clipperz.ByteArray_hex();
	},
	
	//-------------------------------------------------------------------------

	'reset': function() {
		this._value = "";
	},
	
	//-------------------------------------------------------------------------
	
	'length': function() {
		return (this._value.length / 2);
	},
	
	//-------------------------------------------------------------------------

	'appendBlock': function(aBlock) {
		this._value = this._value += aBlock.toHexString().substring(2);

		return this;
	},

	//-------------------------------------------------------------------------

	'appendByte': function(aValue) {
		if (aValue != null) {
			this.checkValue(aValue);
			this._value += Clipperz.ByteArray.byteToHex(aValue);
		}
		
		return this;
	},

	//-------------------------------------------------------------------------

	'byteAtIndex': function(anIndex) {
		return parseInt(this._value.substr(anIndex*2, 2), 16);
	},
	
	'setByteAtIndex': function(aValue, anIndex) {
		var	missingBytes;
		
		this.checkValue(aValue);

		missingBytes = anIndex - this.length();
		
		if (missingBytes < 0) {
			var	currentValue;
			var	firstCutIndex;
			var secondCutIndex;

			firstCutIndex = anIndex * 2;
			secondCutIndex = firstCutIndex + 2;
			currentValue = this._value;
			this._value =	currentValue.substring(0, firstCutIndex) +
							Clipperz.ByteArray.byteToHex(aValue) +
							currentValue.substring(secondCutIndex);
		} else if (missingBytes == 0) {
			this.appendByte(aValue);
		} else {
			var i,c;
			
			c = missingBytes;
			for (i=0; i<c; i++) {
				this.appendByte(0);
			}
			
			this.appendByte(aValue);
		}
	},

	//-------------------------------------------------------------------------

	'toHexString': function() {
		return "0x" + this._value;
	},
	
	//-------------------------------------------------------------------------

	'split': function(aStartingIndex, anEndingIndex) {
		var result;
		var	startingIndex;
		var endingIndex;

		result = this.newInstance();

		startingIndex = aStartingIndex * 2;
		if (typeof(anEndingIndex) != 'undefined') {
			endingIndex = anEndingIndex * 2;
			result._value = this._value.substring(startingIndex, endingIndex);
		} else {
			result._value = this._value.substring(startingIndex);
		}
		
		return result;
	},

	//-------------------------------------------------------------------------

	'arrayValues': function() {
		var result;
		var i,c;
		
		c = this.length();

		result = new Array(c);
		for (i=0; i<c; i++) {
			result[i] = this.byteAtIndex(i);
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//=============================================================================
//
//	Clipperz.ByteArray_array
//
//=============================================================================

Clipperz.ByteArray_array = function (args) {
	if (typeof(args) != 'undefined') {
		if (args.constructor == Array) {
			this._value = args.slice(0);
		} else if (args.constructor == String) {
			var result;
			var	value;
			var i, c;
			
			if (args.indexOf("0x") == 0) {
			
				value = args.substring(2).toLowerCase();
				if (/[0123456789abcdef]*/.test(value)) {
					if ((value.length % 2) != 0) {
						value = "0" + value;
					}
				} else {
MochiKit.Logging.logError("Clipperz.ByteArray should be inizialized with an hex string.");
					throw Clipperz.ByteArray.exception.InvalidValue;
				}

				c = value.length / 2
				result = new Array(c);
				for (i=0; i<c; i++) {
					result[i] = parseInt(value.substr(i*2, 2), 16);
				}

			} else {
				var unicode;
				result = [];
				c = args.length;
				for (i=0; i<c; i++) {
//					Clipperz.ByteArray.pushUtf8BytesOfUnicodeChar(result, args.charCodeAt(i));

					unicode = args.charCodeAt(i);
					if (unicode <= 0x7f) {										//	0x00000000 - 0x0000007f -> 0xxxxxxx
						result.push(unicode);
				//	} else if ((unicode >= 0x80) && (unicode <= 0x7ff)) {		//	0x00000080 - 0x000007ff -> 110xxxxx 10xxxxxx
					} else if (unicode <= 0x7ff) {		//	0x00000080 - 0x000007ff -> 110xxxxx 10xxxxxx
						result.push((unicode >> 6) | 0xc0);
						result.push((unicode & 0x3F) | 0x80);
				//	} else if ((unicode >= 0x0800) && (unicode <= 0xffff)) {	//	0x00000800 - 0x0000ffff -> 1110xxxx 10xxxxxx 10xxxxxx
					} else if (unicode <= 0xffff) {	//	0x00000800 - 0x0000ffff -> 1110xxxx 10xxxxxx 10xxxxxx
						result.push((unicode >> 12) | 0xe0);
						result.push(((unicode >> 6) & 0x3f) | 0x80);
						result.push((unicode & 0x3f) | 0x80);
					} else {													//	0x00010000 - 0x001fffff -> 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
						result.push((unicode >> 18) | 0xf0);
						result.push(((unicode >> 12) & 0x3f) | 0x80);
						result.push(((unicode >> 6) & 0x3f) | 0x80);
						result.push((unicode & 0x3f) | 0x80);
					}
				}
			}
			
		
			this._value = result;
		} else {
			this._value = [];
			this.appendBytes(MochiKit.Base.extend(null, arguments));
		}
	} else {
		this._value = [];
	}
	
	return this;
}

Clipperz.ByteArray_array.prototype = MochiKit.Base.update(new Clipperz.ByteArray_abstract(), {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.ByteArray_array";
	},
	
	//-------------------------------------------------------------------------

	'clone': function() {
		var result;
		
		result = this.newInstance();
		result.appendBytes(this._value);
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'newInstance': function() {
		return new Clipperz.ByteArray_array();
	},
	
	//-------------------------------------------------------------------------

	'reset': function() {
		this._value = [];
	},
	
	//-------------------------------------------------------------------------
	
	'length': function() {
		return (this._value.length);
	},
	
	//-------------------------------------------------------------------------

	'appendBlock': function(aBlock) {
		MochiKit.Base.extend(this._value, aBlock._value);
		
		return this;
	},

	//-------------------------------------------------------------------------

	'appendByte': function(aValue) {
		if (aValue != null) {
			this.checkValue(aValue);
			this._value.push(aValue);
		}
		
		return this;
	},

	//-------------------------------------------------------------------------

	'byteAtIndex': function(anIndex) {
		return this._value[anIndex];
	},
	
	'setByteAtIndex': function(aValue, anIndex) {
		var	missingBytes;
		
		this.checkValue(aValue);

		missingBytes = anIndex - this.length();
		
		if (missingBytes < 0) {
			this._value[anIndex] = aValue;
		} else if (missingBytes == 0) {
			this._value.push(aValue);
		} else {
			var i,c;
			
			c = missingBytes;
			for (i=0; i<c; i++) {
				this._value.push(0);
			}
			
			this._value.push(aValue);
		}
	},

	//-------------------------------------------------------------------------

	'toHexString': function() {
		var result;
		var i, c;
		
		result = "0x";
		c = this.length();
		for (i=0; i<c; i++) {
			result += Clipperz.ByteArray.byteToHex(this._value[i]);
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'split': function(aStartingIndex, anEndingIndex) {
		var result;
		
		result = this.newInstance();
		result._value = this._value.slice(aStartingIndex, anEndingIndex ? anEndingIndex : this.length());
		
		return result;
	},

	//-------------------------------------------------------------------------

	'arrayValues': function() {
		return this._value.slice(0);
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});





//=============================================================================
//
//	Clipperz.ByteArray_string
//
//=============================================================================

Clipperz.ByteArray_string = function (args) {
	this._value = "";

	if (typeof(args) != 'undefined') {
		if (args.constructor == Array) {
			this.appendBytes(args);
		} else if (args.constructor == String) {
			var result;
			var	value;
			var i, c;
			
			if (args.indexOf("0x") == 0) {
			
				value = args.substring(2).toLowerCase();
				if (/[0123456789abcdef]*/.test(value)) {
					if ((value.length % 2) != 0) {
						value = "0" + value;
					}
				} else {
MochiKit.Logging.logError("Clipperz.ByteArray should be inizialized with an hex string.");
					throw Clipperz.ByteArray.exception.InvalidValue;
				}
			} else {
				value = "";
				c = args.length;
				for (i=0; i<c; i++) {
					value += Clipperz.ByteArray.unicodeToUtf8HexString(args.charCodeAt(i));
				}
			}
			
			c = value.length / 2
			for (i=0; i<c; i++) {
				this.appendByte(parseInt(value.substr(i*2, 2), 16));
			}
		} else {
			this.appendBytes(MochiKit.Base.extend(null, arguments));
		}
	}
	
	return this;
}

Clipperz.ByteArray_string.prototype = MochiKit.Base.update(new Clipperz.ByteArray_abstract(), {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.ByteArray_string";
	},
	
	//-------------------------------------------------------------------------

	'clone': function() {
		var result;
		
		result = this.newInstance();
		result._value = this._value;
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'newInstance': function() {
		return new Clipperz.ByteArray_string();
	},
	
	//-------------------------------------------------------------------------

	'reset': function() {
		this._value = "";
	},
	
	//-------------------------------------------------------------------------
	
	'length': function() {
		return (this._value.length);
	},
	
	//-------------------------------------------------------------------------

	'appendBlock': function(aBlock) {
		this._value += aBlock._value;
		
		return this;
	},

	//-------------------------------------------------------------------------

	'appendByte': function(aValue) {
		if (aValue != null) {
			this.checkValue(aValue);
			this._value += String.fromCharCode(aValue);
		}
		
		return this;
	},

	//-------------------------------------------------------------------------

	'byteAtIndex': function(anIndex) {
		return this._value.charCodeAt(anIndex);
	},
	
	'setByteAtIndex': function(aValue, anIndex) {
		var	missingBytes;
		
		this.checkValue(aValue);

		missingBytes = anIndex - this.length();
		
		if (missingBytes < 0) {
			this._value = this._value.substring(0, anIndex) + String.fromCharCode(aValue) + this._value.substring(anIndex + 1);
		} else if (missingBytes == 0) {
			this.appendByte(aValue);
		} else {
			var i,c;
			
			c = missingBytes;
			for (i=0; i<c; i++) {
				this.appendByte(0);
			}
			
			this.appendByte(aValue);
		}
	},

	//-------------------------------------------------------------------------

	'toHexString': function() {
		var result;
		var i, c;
		
		result = "0x";
		c = this.length();
		for (i=0; i<c; i++) {
			result += Clipperz.ByteArray.byteToHex(this.byteAtIndex(i));
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'split': function(aStartingIndex, anEndingIndex) {
		var result;
		result = this.newInstance();
		result._value = this._value.substring(aStartingIndex, anEndingIndex ? anEndingIndex : this.length());
		
		return result;
	},

	//-------------------------------------------------------------------------

	'arrayValues': function() {
		var result;
		var i,c;
		
		c = this.length();

		result = new Array(c);
		for (i=0; i<c; i++) {
			result[i] = this.byteAtIndex(i);
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});


//=============================================================================
//
//	Clipperz.ByteArray
//
//=============================================================================

Clipperz.ByteArray = Clipperz.ByteArray_array;
//Clipperz.ByteArray = Clipperz.ByteArray_string;
//Clipperz.ByteArray = Clipperz.ByteArray_hex;

//#############################################################################

Clipperz.ByteArray.byteToHex = function(aByte) {
	return ((aByte < 16) ? "0" : "") + aByte.toString(16);
}


Clipperz.ByteArray.unicodeToUtf8HexString = function(aUnicode) {
	var result;
	var	self;
	
	self = Clipperz.ByteArray;
	
	if (aUnicode <= 0x7f) {										//	0x00000000 - 0x0000007f -> 0xxxxxxx
		result = self.byteToHex(aUnicode);
//	} else if ((aUnicode >= 0x80) && (aUnicode <= 0x7ff)) {		//	0x00000080 - 0x000007ff -> 110xxxxx 10xxxxxx
	} else if (aUnicode <= 0x7ff) {		//	0x00000080 - 0x000007ff -> 110xxxxx 10xxxxxx
		result = self.byteToHex((aUnicode >> 6) | 0xc0);
		result += self.byteToHex((aUnicode & 0x3F) | 0x80);
//	} else if ((aUnicode >= 0x0800) && (aUnicode <= 0xffff)) {	//	0x00000800 - 0x0000ffff -> 1110xxxx 10xxxxxx 10xxxxxx
	} else if (aUnicode <= 0xffff) {	//	0x00000800 - 0x0000ffff -> 1110xxxx 10xxxxxx 10xxxxxx
		result = self.byteToHex((aUnicode >> 12) | 0xe0);
		result += self.byteToHex(((aUnicode >> 6) & 0x3f) | 0x80);
		result += self.byteToHex((aUnicode & 0x3f) | 0x80);
	} else {													//	0x00010000 - 0x001fffff -> 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
		result = self.byteToHex((aUnicode >> 18) | 0xf0);
		result += self.byteToHex(((aUnicode >> 12) & 0x3f) | 0x80);
		result += self.byteToHex(((aUnicode >> 6) & 0x3f) | 0x80);
		result += self.byteToHex((aUnicode & 0x3f) | 0x80);
	}

	return result;
}

Clipperz.ByteArray.pushUtf8BytesOfUnicodeChar = function(anArray, aUnicode) {
	var	self;
	
	self = Clipperz.ByteArray;
	
	if (aUnicode <= 0x7f) {										//	0x00000000 - 0x0000007f -> 0xxxxxxx
		anArray.push(aUnicode);
//	} else if ((aUnicode >= 0x80) && (aUnicode <= 0x7ff)) {		//	0x00000080 - 0x000007ff -> 110xxxxx 10xxxxxx
	} else if (aUnicode <= 0x7ff) {		//	0x00000080 - 0x000007ff -> 110xxxxx 10xxxxxx
		anArray.push((aUnicode >> 6) | 0xc0);
		anArray.push((aUnicode & 0x3F) | 0x80);
//	} else if ((aUnicode >= 0x0800) && (aUnicode <= 0xffff)) {	//	0x00000800 - 0x0000ffff -> 1110xxxx 10xxxxxx 10xxxxxx
	} else if (aUnicode <= 0xffff) {	//	0x00000800 - 0x0000ffff -> 1110xxxx 10xxxxxx 10xxxxxx
		anArray.push((aUnicode >> 12) | 0xe0);
		anArray.push(((aUnicode >> 6) & 0x3f) | 0x80);
		anArray.push((aUnicode & 0x3f) | 0x80);
	} else {													//	0x00010000 - 0x001fffff -> 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
		anArray.push((aUnicode >> 18) | 0xf0);
		anArray.push(((aUnicode >> 12) & 0x3f) | 0x80);
		anArray.push(((aUnicode >> 6) & 0x3f) | 0x80);
		anArray.push((aUnicode & 0x3f) | 0x80);
	}
}

Clipperz.ByteArray.exception = {
	InvalidValue: new MochiKit.Base.NamedError("Clipperz.ByteArray.exception.InvalidValue")
};

//#############################################################################

Clipperz.ByteArrayIterator = function(args) {
	args = args || {};

	this._byteArray = args.byteArray;
	this._blockSize = args.blockSize;
	this._finalPadding = args.finalPadding || false;
	
	this._currentPosition = 0;
	
	return this;
}

Clipperz.ByteArrayIterator.prototype = MochiKit.Base.update(null, {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.ByteArrayIterator";
	},

	//-------------------------------------------------------------------------

	'blockSize': function() {
		var result;
		
		result = this._blockSize;
		
		return result;
	},

	//-------------------------------------------------------------------------

	'currentPosition': function() {
		var result;
		
		result = this._currentPosition;
		
		return result;
	},

	//-------------------------------------------------------------------------

	'byteArray': function() {
		var result;
		
		result = this._byteArray;
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'finalPadding': function() {
		var result;
		
		result = this._finalPadding;
		
		return result;
	},
	
	//-------------------------------------------------------------------------
		
	'nextBlock': function() {
		var result;
		var currentPosition;
		var	byteArrayLength;
		
		currentPosition = this._currentPosition;
		byteArrayLength = this.byteArray().length();
		
		if (currentPosition < byteArrayLength) {
			var i,c;

			c = this.blockSize();
			result = new Array(c);
			for (i=0; i<c; i++) {
				if (currentPosition < byteArrayLength) {
					result[i] = this.byteArray().byteAtIndex(currentPosition);
					currentPosition++;
				} else if (this.finalPadding() == true) {
					result[i] = 0;
				}
			}
			
			this._currentPosition = currentPosition;
		} else {
			result = null;
		}
		
		return result;
	},	

	//-------------------------------------------------------------------------

	'nextBlockArray': function() {
		var result;
		var nextBlock;

		nextBlock = this.nextBlock();
		
		if (nextBlock != null) {
			result = new Clipperz.ByteArray(nextBlock);
		} else {
			result = null;
		}
		
		return result;
	},
	
	//-----------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
	
});
if (typeof(Clipperz) == 'undefined') { Clipperz = {}; }
if (typeof(Clipperz.NotificationCenter) == 'undefined') { Clipperz.NotificationCenter = {}; }


//#############################################################################

Clipperz.NotificationCenterEvent = function(args) {
	args = args || {};
//	MochiKit.Base.bindMethods(this);

	this._source = args.source || null;
	this._event = args.event || null;
	this._parameters = args.parameters || null;
	this._isSynchronous = args.isSynchronous || false;
	
	return this;
}

//=============================================================================

Clipperz.NotificationCenterEvent.prototype = MochiKit.Base.update(null, {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.NotificationCenterEvent";
		//return "Clipperz.NotificationCenterEvent {source: " + this.source() + ", event: " + this.event() + ", parameters: " + this.parameters() + "}";
	},

	//-------------------------------------------------------------------------

	'source': function() {
		return this._source;
	},
	
	'setSource': function(aValue) {
		this._source = aValue;
	},

	//-------------------------------------------------------------------------

	'event': function() {
		return this._event;
	},
	
	'setEvent': function(aValue) {
		this._event = aValue;
	},
	
	//-------------------------------------------------------------------------

	'parameters': function() {
		return this._parameters;
	},
	
	'setParameters': function(aValue) {
		this._parameters = aValue;
	},
	
	//-------------------------------------------------------------------------

	'isSynchronous': function() {
		return this._isSynchronous;
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});


//#############################################################################
//#############################################################################

Clipperz.NotificationCenter = function(args) {
	args = args || {};
//	MochiKit.Base.bindMethods(this);

	this._listeners = {};
	this._useSynchronousListenerInvocation = args.useSynchronousListenerInvocation || false;
	this._timeoutDelay = args.timeoutDelay || 0.1;

	return this;
}

//=============================================================================

Clipperz.NotificationCenter.prototype = MochiKit.Base.update(null, {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.NotificationCenter";
	},

	//-------------------------------------------------------------------------

	'useSynchronousListenerInvocation': function() {
		return this._useSynchronousListenerInvocation;
	},
	
	'setUseSynchronousListenerInvocation': function(aValue) {
		this._useSynchronousListenerInvocation = aValue;
	},

	//-------------------------------------------------------------------------

	'timeoutDelay': function() {
		return this._timeoutDelay;
	},
	
	'setTimeoutDelay': function(aValue) {
		this._timeoutDelay = aValue;
	},

	//-------------------------------------------------------------------------

	'listeners': function() {
		return this._listeners;
	},

	//-------------------------------------------------------------------------

	'register': function(aSource, anEvent, aListener, aMethod) {
		var	eventListeners;
		var	listenerInfo;
		var	eventKey;

		if (anEvent != null) {
			eventKey = anEvent;
		} else {
			eventKey = '_notificationCenter_matchAnyEvent_key_';
		}
		
		eventListeners = this.listeners()[eventKey];
		
		if (eventListeners == null) {
			eventListeners = [];
			this.listeners()[eventKey] = eventListeners;
		}

		listenerInfo = {};
		if (aSource != null) {
			listenerInfo['source'] = aSource;
		} else {
			listenerInfo['source'] = 'any';
		}
		
		listenerInfo['listener'] = aListener;
		listenerInfo['method'] = aMethod;

		eventListeners.push(listenerInfo);

		return listenerInfo;
	},

	//-------------------------------------------------------------------------

	'removeListenerInfoFromListeners': function(aListener, someListeners) {
		var	listenerIndex;
		var	i,c;
		
		if (someListeners != null) {
			listenerIndex = -1;
			c = someListeners.length;
			for (i=0; i<c; i++) {
				var	listenerInfo;
			
				listenerInfo = someListeners[i];
				if (listenerInfo['listener'] === aListener) {
					listenerIndex = i;
				}
			}

			if (listenerIndex != -1) {
				Clipperz.Base.removeObjectAtIndexFromArray(listenerIndex, someListeners);
			}
		}
	},
	
	//-------------------------------------------------------------------------

	'unregister': function(aListener, anEvent) {
		if (anEvent == null) {
			var	allListenerList;
			var	i, c;
			
//			allListenerList = Clipperz.Base.values(this.listeners());
			allListenerList = MochiKit.Base.values(this.listeners());
			c = allListenerList.length;
			for (i=0; i<c; i++) {
				this.removeListenerInfoFromListeners(aListener, allListenerList[i]);
			}
		} else {
			this.removeListenerInfoFromListeners(aListener, this.listeners()[anEvent]);
		}
	},
	
	//-------------------------------------------------------------------------

	'asysnchronousListenerNotification': function(anEventInfo, aMethod, aListener) {
		MochiKit.Async.callLater(this.timeoutDelay(), MochiKit.Base.partial(MochiKit.Base.methodcaller(aMethod, anEventInfo), aListener));
//		setTimeout(MochiKit.Base.partial(MochiKit.Base.methodcaller(aMethod, anEventInfo), aListener), this.timeoutDelay());
	},

	//-------------------------------------------------------------------------

	'processListenerInfo': function(anEventInfo, aListenerInfo) {
		var	shouldInvokeListenerMethod;

		if (aListenerInfo['source'] == 'any') {
			shouldInvokeListenerMethod = true;
		} else {
			if (aListenerInfo['source'] === anEventInfo.source()) {
				shouldInvokeListenerMethod = true;
			} else {
				shouldInvokeListenerMethod = false;
			}
		}

		if (shouldInvokeListenerMethod) {
			if (this.useSynchronousListenerInvocation() || anEventInfo.isSynchronous()) {
//MochiKit.Logging.logDebug("syncrhronous listener invocation");
				try {
//					MochiKit.Base.map(MochiKit.Base.methodcaller(aListenerInfo['method'], anEventInfo), [aListenerInfo['listener']]);
//console.log("notification: ", aListenerInfo['listener'], aListenerInfo['method'], anEventInfo);
					MochiKit.Base.method(aListenerInfo['listener'], aListenerInfo['method'], anEventInfo)();
				} catch(exception) {
					MochiKit.Logging.logError('NotificationCenter ERROR: unable to invoke method \'' + aListenerInfo['method'] + '\' on object ' + aListenerInfo['listener']);
				}
			} else {
				var asyncMethod;
				
//MochiKit.Logging.logDebug("asyncrhronous listener invocation");
				asyncMethod = MochiKit.Base.bind(this.asysnchronousListenerNotification, this)
				MochiKit.Base.map(MochiKit.Base.partial(asyncMethod, anEventInfo, aListenerInfo['method']), [aListenerInfo['listener']]);
			}
		}
	},

	//-------------------------------------------------------------------------

	'notify': function(aSource, anEvent, someEventParameters, isSynchronous) {
		var	eventInfo;
		var processInfoMethod;

//MochiKit.Logging.logDebug(">>> NotificationCenter.notify");
		eventInfo = new Clipperz.NotificationCenterEvent({source:aSource, event:anEvent, parameters:someEventParameters, isSynchronous:isSynchronous});
//MochiKit.Logging.logDebug("--- NotificationCenter.notify - 1");
		processInfoMethod = MochiKit.Base.bind(this.processListenerInfo, this);
//MochiKit.Logging.logDebug("--- NotificationCenter.notify - 2");

		MochiKit.Base.map(MochiKit.Base.partial(processInfoMethod, eventInfo), this.listeners()[anEvent] || []);
//MochiKit.Logging.logDebug("--- NotificationCenter.notify - 3");
		MochiKit.Base.map(MochiKit.Base.partial(processInfoMethod, eventInfo), this.listeners()['_notificationCenter_matchAnyEvent_key_'] || []);
//MochiKit.Logging.logDebug("<<< NotificationCenter.notify");
	},

	//-------------------------------------------------------------------------

	'deferredNotification': function(aSource, anEvent, someEventParameters, aDeferredResult) {
		
		this.notify(aSource, anEvent, someEventParameters, true);
		
		return aDeferredResult;
//		return MochiKit.Async.wait(1, aDeferredResult);
	},
	
	//-------------------------------------------------------------------------

	'resetStatus': function() {
		this._listeners = {};
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
	
});

//#############################################################################

Clipperz.NotificationCenter.defaultNotificationCenter = new Clipperz.NotificationCenter();

Clipperz.NotificationCenter.notify = MochiKit.Base.method(Clipperz.NotificationCenter.defaultNotificationCenter, 'notify');
Clipperz.NotificationCenter.register = MochiKit.Base.method(Clipperz.NotificationCenter.defaultNotificationCenter, 'register');
Clipperz.NotificationCenter.unregister = MochiKit.Base.method(Clipperz.NotificationCenter.defaultNotificationCenter, 'unregister');
Clipperz.NotificationCenter.deferredNotification = MochiKit.Base.method(Clipperz.NotificationCenter.defaultNotificationCenter, 'deferredNotification');
/*
_clipperz_notificationCenter_defaultNotificationCenter = null;

Clipperz.NotificationCenter.defaultNotificationCenter = function() {
	if (_clipperz_notificationCenter_defaultNotificationCenter == null) {
		_clipperz_notificationCenter_defaultNotificationCenter = new Clipperz.NotificationCenter();
	}

	return _clipperz_notificationCenter_defaultNotificationCenter;
};
*/

if (typeof(Clipperz) == 'undefined') {
	Clipperz = {};
}

//#############################################################################

Clipperz.Set = function(args) {
	args = args || {};
//	MochiKit.Base.bindMethods(this);

	if (args.items != null) {
		this._items = args.items.slice();
	} else {
		this._items = [];
	}

	return this;
}

//=============================================================================

Clipperz.Set.prototype = MochiKit.Base.update(null, {

	//-------------------------------------------------------------------------

	'toString': function() {
		return "Clipperz.Set";
	},

	//-------------------------------------------------------------------------

	'items': function() {
		return this._items;
	},

	//-------------------------------------------------------------------------

	'popAnItem': function() {
		var result;
	
		if (this.size() > 0) {
			result = this.items().pop();
		} else {
			result = null;
		}
		
		return result;
	},

	//-------------------------------------------------------------------------

	'allItems': function() {
		return this.items();
	},

	//-------------------------------------------------------------------------

	'contains': function(anItem) {
		return (this.indexOf(anItem) != -1);
	},
	
	//-------------------------------------------------------------------------

	'indexOf': function(anItem) {
		var	result;
		var	i, c;
		
		result = -1;

		c = this.items().length;
		for (i=0; (i<c) && (result == -1); i++) {
			if (this.items()[i] === anItem) {
				result = i;
			}
		}
		
		return result;
	},

	//-------------------------------------------------------------------------

	'add': function(anItem) {
		if (anItem.constructor == Array) {
			MochiKit.Base.map(MochiKit.Base.bind(this,add, this), anItem);
		} else {
			if (! this.contains(anItem)) {
				this.items().push(anItem);
			}
		}
	},

	//-------------------------------------------------------------------------

	'debug': function() {
		var	i, c;
		
		result = -1;

		c = this.items().length;
		for (i=0; i<c; i++) {
			alert("[" + i + "] " + this.items()[i].label);
		}
	},

	//-------------------------------------------------------------------------

	'remove': function(anItem) {
		if (anItem.constructor == Array) {
			MochiKit.Base.map(MochiKit.Base.bind(this.remove, this), anItem);
		} else {
			var	itemIndex;

			itemIndex = this.indexOf(anItem);
			if (itemIndex != -1) {
				this.items().splice(itemIndex, 1);
			}
		}
	},

	//-------------------------------------------------------------------------

	'size': function() {
		return this.items().length;
	},

	//-------------------------------------------------------------------------

	'empty': function() {
		this.items().splice(0, this.items().length);
	},
	
	//-------------------------------------------------------------------------

	__syntaxFix__: "syntax fix"
	
	//-------------------------------------------------------------------------
});

AES.js BigInt.js new.js PRNG.js SHA.js SRP.js
try { if (typeof(Clipperz.ByteArray) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.AES depends on Clipperz.ByteArray!";
}  

//	Dependency commented to avoid a circular reference
//try { if (typeof(Clipperz.Crypto.PRNG) == 'undefined') { throw ""; }} catch (e) {
//	throw "Clipperz.Crypto.AES depends on Clipperz.Crypto.PRNG!";
//}  

if (typeof(Clipperz.Crypto.AES) == 'undefined') { Clipperz.Crypto.AES = {}; }

//#############################################################################

Clipperz.Crypto.AES.DeferredExecutionContext = function(args) {
	args = args || {};

	this._key = args.key;
	this._message = args.message;
	this._result = args.message.clone();
	this._nonce = args.nonce;
	this._messageLength = this._message.length();
	
	this._messageArray = this._message.arrayValues();
	this._resultArray = this._result.arrayValues();
	this._nonceArray = this._nonce.arrayValues();
	
	this._executionStep = 0;
	
	return this;
}

Clipperz.Crypto.AES.DeferredExecutionContext.prototype = MochiKit.Base.update(null, {

	'key': function() {
		return this._key;
	},
	
	'message': function() {
		return this._message;
	},
	
	'messageLength': function() {
		return this._messageLength;
	},
	
	'result': function() {
		return new Clipperz.ByteArray(this.resultArray());
	},
	
	'nonce': function() {
		return this._nonce;
	},

	'messageArray': function() {
		return this._messageArray;
	},
	
	'resultArray': function() {
		return this._resultArray;
	},
	
	'nonceArray': function() {
		return this._nonceArray;
	},

	'elaborationChunkSize': function() {
		return Clipperz.Crypto.AES.DeferredExecution.chunkSize;
	},
	
	'executionStep': function() {
		return this._executionStep;
	},
	
	'setExecutionStep': function(aValue) {
		this._executionStep = aValue;
	},
	
	'pause': function(aValue) {
		return MochiKit.Async.wait(Clipperz.Crypto.AES.DeferredExecution.pauseTime, aValue);
	},
	
	//-----------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"

});

//#############################################################################

Clipperz.Crypto.AES.Key = function(args) {
	args = args || {};

	this._key = args.key;
	this._keySize = args.keySize || this.key().length();
	
	if (this.keySize() == 128/8) {
		this._b = 176;
		this._numberOfRounds = 10;
 	} else if (this.keySize() == 256/8) {
		this._b = 240;
		this._numberOfRounds = 14;
	} else {
		MochiKit.Logging.logError("AES unsupported key size: " + (this.keySize() * 8) + " bits");
		throw Clipperz.Crypto.AES.exception.UnsupportedKeySize;
	}
	
	this._stretchedKey = null;
	
	return this;
}

Clipperz.Crypto.AES.Key.prototype = MochiKit.Base.update(null, {

	'asString': function() {
		return "Clipperz.Crypto.AES.Key (" + this.key().toHexString() + ")";
	},
	
	//-----------------------------------------------------------------------------

	'key': function() {
		return this._key;
	},

	'keySize': function() {
		return this._keySize;
	},
	
	'b': function() {
		return this._b;
	},
	
	'numberOfRounds': function() {
		return this._numberOfRounds;
	},
	//=========================================================================

	'keyScheduleCore': function(aWord, aRoundConstantsIndex) {
		var	result;
		var sbox;

		sbox = Clipperz.Crypto.AES.sbox();

		result = [	sbox[aWord[1]] ^ Clipperz.Crypto.AES.roundConstants()[aRoundConstantsIndex],
					sbox[aWord[2]],
					sbox[aWord[3]],
					sbox[aWord[0]]	];

		return result;
	},

	//-----------------------------------------------------------------------------

	'xorWithPreviousStretchValues': function(aKey, aWord, aPreviousWordIndex) {
		var	result;
		var i,c;
		
		result = [];
		c = 4;
		for (i=0; i<c; i++) {
			result[i] = aWord[i] ^ aKey.byteAtIndex(aPreviousWordIndex + i);
		}
		
		return result;
	},

	//-----------------------------------------------------------------------------

	'sboxShakeup': function(aWord) {
		var result;
		var sbox;
		var i,c;
		
		result = [];
		sbox = Clipperz.Crypto.AES.sbox();
		c =4;
		for (i=0; i<c; i++) {
			result[i] = sbox[aWord[i]];
		}
		
		return result;
	},

	//-----------------------------------------------------------------------------

	'stretchKey': function(aKey) {
		var	currentWord;
		var	keyLength;
		var	previousStretchIndex;
		var i,c;
		
		keyLength = aKey.length();
		previousStretchIndex = keyLength - this.keySize();

		currentWord = [	aKey.byteAtIndex(keyLength - 4),
						aKey.byteAtIndex(keyLength - 3),
						aKey.byteAtIndex(keyLength - 2),
						aKey.byteAtIndex(keyLength - 1)	];
		currentWord = this.keyScheduleCore(currentWord, keyLength / this.keySize());

		if (this.keySize() == 256/8) {
			c = 8;
		} else if (this.keySize() == 128/8){
			c = 4;
		}
		
		for (i=0; i<c; i++) {
			if (i == 4) {
				//	fifth streatch word
				currentWord = this.sboxShakeup(currentWord);
			}

			currentWord = this.xorWithPreviousStretchValues(aKey, currentWord, previousStretchIndex + (i*4));
			aKey.appendBytes(currentWord);
		}

		return aKey;
	},

	//-----------------------------------------------------------------------------

	'stretchedKey': function() {
		if (this._stretchedKey == null) {
			var stretchedKey;
			
			stretchedKey = this.key().clone();

			while (stretchedKey.length() < this.keySize()) {
				stretchedKey.appendByte(0);
			}

			while (stretchedKey.length() < this.b()) {
				stretchedKey = this.stretchKey(stretchedKey);
			}
			
			this._stretchedKey = stretchedKey.split(0, this.b());
		}
		
		return this._stretchedKey;
	},

	//=========================================================================
	__syntaxFix__: "syntax fix"
});

//#############################################################################

Clipperz.Crypto.AES.State = function(args) {
	args = args || {};

	this._data = args.block;
	this._key = args.key;
	
	return this;
}

Clipperz.Crypto.AES.State.prototype = MochiKit.Base.update(null, {

	'key': function() {
		return this._key;
	},
	
	//-----------------------------------------------------------------------------

	'data': function() {
		return this._data;
	},

	'setData': function(aValue) {
		this._data = aValue;
	},

	//=========================================================================

	'addRoundKey': function(aRoundNumber) {
	 	//	each byte of the state is combined with the round key; each round key is derived from the cipher key using a key schedule.
		var	data;
		var	stretchedKey;
		var	firstStretchedKeyIndex;
		var i,c;

		data = this.data();
		stretchedKey = this.key().stretchedKey();
		firstStretchedKeyIndex = aRoundNumber * (128/8);
		c = 128/8;
		for (i=0; i<c; i++) {
			data[i] = data[i] ^ stretchedKey.byteAtIndex(firstStretchedKeyIndex + i);
		}
	},
	
	//-----------------------------------------------------------------------------

	'subBytes': function() {
		//	 a non-linear substitution step where each byte is replaced with another according to a lookup table.
		var i,c;
		var	data;
		var sbox;
		
		data = this.data();
		sbox = Clipperz.Crypto.AES.sbox();
		
		c = 16;
		for (i=0; i<c; i++) {
			data[i] = sbox[data[i]];
		}
	},

	//-----------------------------------------------------------------------------

	'shiftRows': function() {
		//	a transposition step where each row of the state is shifted cyclically a certain number of steps.
		var	newValue;
		var	data;
		var	shiftMapping;
		var	i,c;
		
		newValue = new Array(16);
		data = this.data();
		shiftMapping = Clipperz.Crypto.AES.shiftRowMapping();
//		[0, 5, 10, 15, 4, 9, 14, 3, 8, 13, 2, 7, 12, 1, 6, 11];
		c = 16;
		for (i=0; i<c; i++) {
			newValue[i] = data[shiftMapping[i]];
		}
		for (i=0; i<c; i++) {
			data[i] = newValue[i];
		}
	},

	//-----------------------------------------------------------------------------
/*
	'mixColumnsWithValues': function(someValues) {
		var	result;
		var	a;
		var i,c;
		
		c = 4;
		result = [];
		a = [];
		for (i=0; i<c; i++) {
			a[i] = [];
			a[i][1] = someValues[i]
			if ((a[i][1] & 0x80) == 0x80) {
				a[i][2] = (a[i][1] << 1) ^ 0x11b;
			} else {
				a[i][2] = a[i][1] << 1;
			}
			
			a[i][3] = a[i][2] ^ a[i][1];
		}
	
		for (i=0; i<c; i++) {
			var	x;

			x = Clipperz.Crypto.AES.mixColumnsMatrix()[i];
			result[i] = a[0][x[0]] ^ a[1][x[1]] ^ a[2][x[2]] ^ a[3][x[3]];
		}

		return result;
	},
	
	'mixColumns': function() {
		//	a mixing operation which operates on the columns of the state, combining the four bytes in each column using a linear transformation.
		var data;
		var i, c;
		
		data = this.data();
		c = 4;
		for(i=0; i<c; i++) {
			var	blockIndex;
			var mixedValues;
			
			blockIndex = i * 4;
			mixedValues = this.mixColumnsWithValues([	data[blockIndex + 0],
														data[blockIndex + 1],
														data[blockIndex + 2],
														data[blockIndex + 3]]);
			data[blockIndex + 0] = mixedValues[0];
			data[blockIndex + 1] = mixedValues[1];
			data[blockIndex + 2] = mixedValues[2];
			data[blockIndex + 3] = mixedValues[3];
		}
	},
*/

	'mixColumns': function() {
		//	a mixing operation which operates on the columns of the state, combining the four bytes in each column using a linear transformation.
		var data;
		var i, c;
		var a_1;
		var a_2;

		a_1 = new Array(4);
		a_2 = new Array(4);
		
		data = this.data();
		c = 4;
		for(i=0; i<c; i++) {
			var	blockIndex;
			var ii, cc;
			
			blockIndex = i * 4;

			cc = 4;
			for (ii=0; ii<cc; ii++) {
				var value;
				
				value = data[blockIndex + ii];
				a_1[ii] = value;
				a_2[ii] = (value & 0x80) ? ((value << 1) ^ 0x011b) : (value << 1);
			}

			data[blockIndex + 0] = a_2[0] ^ a_1[1] ^ a_2[1] ^ a_1[2] ^ a_1[3];
			data[blockIndex + 1] = a_1[0] ^ a_2[1] ^ a_1[2] ^ a_2[2] ^ a_1[3];
			data[blockIndex + 2] = a_1[0] ^ a_1[1] ^ a_2[2] ^ a_1[3] ^ a_2[3];
			data[blockIndex + 3] = a_1[0] ^ a_2[0] ^ a_1[1] ^ a_1[2] ^ a_2[3];
		}
	},

	//=========================================================================
	
	'spinRound': function(aRoundNumber) {
		this.addRoundKey(aRoundNumber);
		this.subBytes();
		this.shiftRows();
		this.mixColumns();
	},

	'spinLastRound': function() {
		this.addRoundKey(this.key().numberOfRounds() - 1);
		this.subBytes();
		this.shiftRows();
		this.addRoundKey(this.key().numberOfRounds());
	},

	//=========================================================================

	'encrypt': function() {
		var	i,c;

		c = this.key().numberOfRounds() - 1;
		for (i=0; i<c; i++) {
			this.spinRound(i);
		}

		this.spinLastRound();
	},
	
	//=========================================================================
	__syntaxFix__: "syntax fix"
});

//#############################################################################

Clipperz.Crypto.AES.VERSION = "0.1";
Clipperz.Crypto.AES.NAME = "Clipperz.Crypto.AES";

MochiKit.Base.update(Clipperz.Crypto.AES, {

//	http://www.cs.eku.edu/faculty/styer/460/Encrypt/JS-AES.html
//	http://en.wikipedia.org/wiki/Advanced_Encryption_Standard
//	http://en.wikipedia.org/wiki/Rijndael_key_schedule 
//	http://en.wikipedia.org/wiki/Rijndael_S-box
		
	'__repr__': function () {
		return "[" + this.NAME + " " + this.VERSION + "]";
	},

	'toString': function () {
		return this.__repr__();
	},

	//=============================================================================
	
	'_sbox': null,
	'sbox': function() {
		if (Clipperz.Crypto.AES._sbox == null) {
			Clipperz.Crypto.AES._sbox = [
0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
			];
		}
		
		return Clipperz.Crypto.AES._sbox;
	},

	//-----------------------------------------------------------------------------
	//
	//		0	4	8	12				0	4	8	12
	//		1	5	9	13		=>		5	9	13	1
	//		2	6	10	14				10	14	2	6
	//		3	7	11	15				15	3	7	11
	//
	'_shiftRowMapping': null,
	'shiftRowMapping': function() {
		if (Clipperz.Crypto.AES._shiftRowMapping == null) {
			Clipperz.Crypto.AES._shiftRowMapping = [0, 5, 10, 15, 4, 9, 14, 3, 8, 13, 2, 7, 12, 1, 6, 11];
		}
		
		return Clipperz.Crypto.AES._shiftRowMapping;
	},

	//-----------------------------------------------------------------------------

	'_mixColumnsMatrix': null,
	'mixColumnsMatrix': function() {
		if (Clipperz.Crypto.AES._mixColumnsMatrix == null) {
			Clipperz.Crypto.AES._mixColumnsMatrix = [	[2, 3, 1 ,1],
														[1, 2, 3, 1],
														[1, 1, 2, 3],
														[3, 1, 1, 2]   ];
		}
		
		return Clipperz.Crypto.AES._mixColumnsMatrix;
	},

	'_roundConstants': null,
	'roundConstants': function() {
		if (Clipperz.Crypto.AES._roundConstants == null) {
			Clipperz.Crypto.AES._roundConstants = [ , 1, 2, 4, 8, 16, 32, 64, 128, 27, 54, 108, 216, 171, 77, 154];
//			Clipperz.Crypto.AES._roundConstants = [ , 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a];
		}
		
		return Clipperz.Crypto.AES._roundConstants;
	},
	
	//=============================================================================

	'incrementNonce': function(aNonce) {
//Clipperz.Profile.start("Clipperz.Crypto.AES.incrementNonce");
		var i;
		var done;
		
		done = false;
		i = aNonce.length - 1;
		
		while ((i>=0) && (done == false)) {
			var currentByteValue;
			
			currentByteValue = aNonce[i];
			
			if (currentByteValue == 0xff) {
				aNonce[i] = 0;
				if (i>= 0) {
					i --;
				} else {
					done = true;
				}
			} else {
				aNonce[i] = currentByteValue + 1;
				done = true;
			}
		}
//Clipperz.Profile.stop("Clipperz.Crypto.AES.incrementNonce");
	},
	
	//-----------------------------------------------------------------------------

	'encryptBlock': function(aKey, aBlock) {
		var	result;
		var	state;

		state = new Clipperz.Crypto.AES.State({block:aBlock, key:aKey});
//is(state.data(), 'before');
		state.encrypt();
		result = state.data(); 
		
		return result;
	},

	//-----------------------------------------------------------------------------

	'encryptBlocks': function(aKey, aMessage, aNonce) {
		var	result;
		var nonce;
		var self;
		var	messageIndex;
		var	messageLength;
		var blockSize;		
		
		self = Clipperz.Crypto.AES;
		blockSize = 128/8;
		messageLength = aMessage.length;
		nonce = aNonce;

		result = aMessage;
		messageIndex = 0;
		while (messageIndex < messageLength) {
			var encryptedBlock;
			var i,c;
			
			self.incrementNonce(nonce);
			encryptedBlock = self.encryptBlock(aKey, nonce);
			
			if ((messageLength - messageIndex) > blockSize) {
				c = blockSize;
			} else {
				c = messageLength - messageIndex;
			}
			
			for (i=0; i<c; i++) {
				result[messageIndex + i] = result[messageIndex + i] ^ encryptedBlock[i];
			}
			
			messageIndex += blockSize;
		}
		
		return result;
	},
	
	//-----------------------------------------------------------------------------

	'encrypt': function(aKey, someData, aNonce) {
		var result;
		var nonce;
		var	encryptedData;
		var key;

		key = new Clipperz.Crypto.AES.Key({key:aKey});
		nonce = aNonce ? aNonce.clone() : Clipperz.Crypto.PRNG.defaultRandomGenerator().getRandomBytes(128/8);

		encryptedData = Clipperz.Crypto.AES.encryptBlocks(key, someData.arrayValues(), nonce.arrayValues());

		result = nonce.appendBytes(encryptedData);
		
		return result;
	},

	//-----------------------------------------------------------------------------

	'decrypt': function(aKey, someData) {
		var result;
		var nonce;
		var encryptedData;
		var decryptedData;
		var	dataIterator;
		var key;

		key = new Clipperz.Crypto.AES.Key({key:aKey});

		encryptedData = someData.arrayValues();
		nonce = encryptedData.slice(0, (128/8));
		encryptedData = encryptedData.slice(128/8);
		decryptedData = Clipperz.Crypto.AES.encryptBlocks(key, encryptedData, nonce);

		result = new Clipperz.ByteArray(decryptedData);
		
		return result;
	},
	
	//=============================================================================

	'deferredEncryptExecutionChunk': function(anExecutionContext) {
		var	result;
		var nonce;
		var self;
		var	messageIndex;
		var	messageLength;
		var blockSize;	
		var executionLimit;

		self = Clipperz.Crypto.AES;
		blockSize = 128/8;
		messageLength = anExecutionContext.messageArray().length;
		nonce = anExecutionContext.nonceArray();
		result = anExecutionContext.resultArray();

		messageIndex = anExecutionContext.executionStep();
		executionLimit = messageIndex + anExecutionContext.elaborationChunkSize();
		executionLimit = Math.min(executionLimit, messageLength);
		
		while (messageIndex < executionLimit) {
			var encryptedBlock;
			var i,c;
			
			self.incrementNonce(nonce);
			encryptedBlock = self.encryptBlock(anExecutionContext.key(), nonce);
			
			if ((executionLimit - messageIndex) > blockSize) {
				c = blockSize;
			} else {
				c = executionLimit - messageIndex;
			}
			
			for (i=0; i<c; i++) {
				result[messageIndex + i] = result[messageIndex + i] ^ encryptedBlock[i];
			}
			
			messageIndex += blockSize;
		}
		anExecutionContext.setExecutionStep(messageIndex);
		
		return anExecutionContext;
	},

	//-----------------------------------------------------------------------------
	
	'deferredEncryptBlocks': function(anExecutionContext) {
		var	deferredResult;
		var	messageSize;
		var i,c;
		var now;
		
		messageSize = anExecutionContext.messageLength();		
		
		deferredResult = new MochiKit.Async.Deferred();
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncryptBlocks - START: " + res); return res;});
//		deferredResult.addCallback(MochiKit.Base.method(anExecutionContext, 'pause'));

		c = Math.ceil(messageSize / anExecutionContext.elaborationChunkSize());
		for (i=0; i<c; i++) {
//deferredResult.addBoth(function(res) {now = new Date(); return res;});
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncryptBlocks - : (" + i + ") - " + res); return res;});
			deferredResult.addCallback(Clipperz.Crypto.AES.deferredEncryptExecutionChunk);
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("[" + (new Date() - now) + "]Clipperz.Crypto.AES.deferredEncryptBlocks"); return res;});
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncryptBlocks - : (" + i + ") -- " + res); return res;});
			deferredResult.addCallback(MochiKit.Base.method(anExecutionContext, 'pause'));
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncryptBlocks - : (" + i + ") --- " + res); return res;});
		}
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncryptBlocks - END: " + res); return res;});
		
		deferredResult.callback(anExecutionContext);
		
		return deferredResult;
	},

	//-----------------------------------------------------------------------------
	
	'deferredEncrypt': function(aKey, someData, aNonce) {
		var deferredResult;
		var	executionContext;
		var result;
		var nonce;
		var key;

		key = new Clipperz.Crypto.AES.Key({key:aKey});
		nonce = aNonce ? aNonce.clone() : Clipperz.Crypto.PRNG.defaultRandomGenerator().getRandomBytes(128/8);

		executionContext = new Clipperz.Crypto.AES.DeferredExecutionContext({key:key, message:someData, nonce:nonce});

		deferredResult = new MochiKit.Async.Deferred();
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncrypt - 1: " + res); return res;});
		deferredResult.addCallback(Clipperz.Crypto.AES.deferredEncryptBlocks);
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncrypt - 2: " + res); return res;});
		deferredResult.addCallback(function(anExecutionContext) {
			var result;
			
			result = anExecutionContext.nonce().clone();
			result.appendBytes(anExecutionContext.resultArray());

			return result;
		});
//deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("Clipperz.Crypto.AES.deferredEncrypt - 3: " + res); return res;});
		deferredResult.callback(executionContext)

		return deferredResult;
	},

	//-----------------------------------------------------------------------------

	'deferredDecrypt': function(aKey, someData) {
		var deferredResult
		var nonce;
		var message;
		var key;

		key = new Clipperz.Crypto.AES.Key({key:aKey});
		nonce = someData.split(0, (128/8));
		message = someData.split(128/8);
		executionContext = new Clipperz.Crypto.AES.DeferredExecutionContext({key:key, message:message, nonce:nonce});

		deferredResult = new MochiKit.Async.Deferred();
		deferredResult.addCallback(Clipperz.Crypto.AES.deferredEncryptBlocks);
		deferredResult.addCallback(function(anExecutionContext) {
			return anExecutionContext.result();
		});
		deferredResult.callback(executionContext);

		return deferredResult;
	},
	
	//-----------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
	
});

//#############################################################################

Clipperz.Crypto.AES.DeferredExecution = {
	'chunkSize': 4096,	//	1024	4096	8192	16384	32768;
	'pauseTime': 0.2
}

Clipperz.Crypto.AES.exception = {
	'UnsupportedKeySize':    new MochiKit.Base.NamedError("Clipperz.Crypto.AES.exception.UnsupportedKeySize") 
};
if (typeof(Clipperz) == 'undefined') { Clipperz = {}; }
if (typeof(Clipperz.Crypto) == 'undefined') { Clipperz.Crypto = {}; }

//#############################################################################
//	Downloaded on March 05, 2007 from http://www.leemon.com/crypto/BigInt.js
//#############################################################################


////////////////////////////////////////////////////////////////////////////////////////
// Big Integer Library v. 5.0
// Created 2000, last modified 2006
// Leemon Baird
// www.leemon.com
//
// This file is public domain.   You can use it for any purpose without restriction.
// I do not guarantee that it is correct, so use it at your own risk.  If you use 
// it for something interesting, I'd appreciate hearing about it.  If you find 
// any bugs or make any improvements, I'd appreciate hearing about those too.
// It would also be nice if my name and address were left in the comments.
// But none of that is required.
//
// This code defines a bigInt library for arbitrary-precision integers.
// A bigInt is an array of integers storing the value in chunks of bpe bits, 
// little endian (buff[0] is the least significant word).
// Negative bigInts are stored two's complement.
// Some functions assume their parameters have at least one leading zero element.
// Functions with an underscore at the end of the name have unpredictable behavior in case of overflow, 
// so the caller must make sure overflow won't happen.
// For each function where a parameter is modified, that same 
// variable must not be used as another argument too.
// So, you cannot square x by doing multMod_(x,x,n).  
// You must use squareMod_(x,n) instead, or do y=dup(x); multMod_(x,y,n).
//
// These functions are designed to avoid frequent dynamic memory allocation in the inner loop.
// For most functions, if it needs a BigInt as a local variable it will actually use
// a global, and will only allocate to it when it's not the right size.  This ensures
// that when a function is called repeatedly with same-sized parameters, it only allocates
// memory on the first call.
//
// Note that for cryptographic purposes, the calls to Math.random() must 
// be replaced with calls to a better pseudorandom number generator.
//
// In the following, "bigInt" means a bigInt with at least one leading zero element,
// and "integer" means a nonnegative integer less than radix.  In some cases, integer 
// can be negative.  Negative bigInts are 2s complement.
// 
// The following functions do not modify their inputs, but dynamically allocate memory every time they are called:
// 
// function bigInt2str(x,base)     //convert a bigInt into a string in a given base, from base 2 up to base 95
// function dup(x)                 //returns a copy of bigInt x
// function findPrimes(n)          //return array of all primes less than integer n
// function int2bigInt(t,n,m)      //convert integer t to a bigInt with at least n bits and m array elements
// function int2bigInt(s,b,n,m)    //convert string s in base b to a bigInt with at least n bits and m array elements
// function trim(x,k)              //return a copy of x with exactly k leading zero elements
//
// The following functions do not modify their inputs, so there is never a problem with the result being too big:
//
// function bitSize(x)             //returns how many bits long the bigInt x is, not counting leading zeros
// function equals(x,y)            //is the bigInt x equal to the bigint y?
// function equalsInt(x,y)         //is bigint x equal to integer y?
// function greater(x,y)           //is x>y?  (x and y are nonnegative bigInts)
// function greaterShift(x,y,shift)//is (x <<(shift*bpe)) > y?
// function isZero(x)              //is the bigInt x equal to zero?
// function millerRabin(x,b)       //does one round of Miller-Rabin base integer b say that bigInt x is possibly prime (as opposed to definitely composite)?
// function modInt(x,n)            //return x mod n for bigInt x and integer n.
// function negative(x)            //is bigInt x negative?
//
// The following functions do not modify their inputs, but allocate memory and call functions with underscores
//
// function add(x,y)                //return (x+y) for bigInts x and y.  
// function addInt(x,n)             //return (x+n) where x is a bigInt and n is an integer.
// function expand(x,n)             //return a copy of x with at least n elements, adding leading zeros if needed
// function inverseMod(x,n)         //return (x**(-1) mod n) for bigInts x and n.  If no inverse exists, it returns null
// function mod(x,n)                //return a new bigInt equal to (x mod n) for bigInts x and n.
// function mult(x,y)               //return x*y for bigInts x and y. This is faster when y<x.
// function multMod(x,y,n)          //return (x*y mod n) for bigInts x,y,n.  For greater speed, let y<x.
// function powMod(x,y,n)           //return (x**y mod n) where x,y,n are bigInts and ** is exponentiation.  0**0=1. Faster for odd n.
// function randTruePrime(k)        //return a new, random, k-bit, true prime using Maurer's algorithm.
// function sub(x,y)                //return (x-y) for bigInts x and y.  Negative answers will be 2s complement
//
// The following functions write a bigInt result to one of the parameters, but
// the result is never bigger than the original, so there can't be overflow problems:
//
// function divInt_(x,n)            //do x=floor(x/n) for bigInt x and integer n, and return the remainder
// function GCD_(x,y)               //set x to the greatest common divisor of bigInts x and y, (y is destroyed).
// function halve_(x)               //do x=floor(|x|/2)*sgn(x) for bigInt x in 2's complement
// function mod_(x,n)               //do x=x mod n for bigInts x and n.
// function rightShift_(x,n)        //right shift bigInt x by n bits.  0 <= n < bpe.
//
// The following functions write a bigInt result to one of the parameters.  The caller is responsible for
// ensuring it is large enough to hold the result.
// 
// function addInt_(x,n)            //do x=x+n where x is a bigInt and n is an integer
// function add_(x,y)               //do x=x+y for bigInts x and y
// function addShift_(x,y,ys)       //do x=x+(y<<(ys*bpe))
// function copy_(x,y)              //do x=y on bigInts x and y
// function copyInt_(x,n)           //do x=n on bigInt x and integer n
// function carry_(x)               //do carries and borrows so each element of the bigInt x fits in bpe bits.
// function divide_(x,y,q,r)        //divide_ x by y giving quotient q and remainder r
// function eGCD_(x,y,d,a,b)        //sets a,b,d to positive big integers such that d = GCD_(x,y) = a*x-b*y
// function inverseMod_(x,n)        //do x=x**(-1) mod n, for bigInts x and n. Returns 1 (0) if inverse does (doesn't) exist
// function inverseModInt_(x,n)     //return x**(-1) mod n, for integers x and n.  Return 0 if there is no inverse
// function leftShift_(x,n)         //left shift bigInt x by n bits.  n<bpe.
// function linComb_(x,y,a,b)       //do x=a*x+b*y for bigInts x and y and integers a and b
// function linCombShift_(x,y,b,ys) //do x=x+b*(y<<(ys*bpe)) for bigInts x and y, and integers b and ys
// function mont_(x,y,n,np)         //Montgomery multiplication (see comments where the function is defined)
// function mult_(x,y)              //do x=x*y for bigInts x and y.
// function multInt_(x,n)           //do x=x*n where x is a bigInt and n is an integer.
// function multMod_(x,y,n)         //do x=x*y  mod n for bigInts x,y,n.
// function powMod_(x,y,n)          //do x=x**y mod n, where x,y,n are bigInts (n is odd) and ** is exponentiation.  0**0=1.
// function randBigInt_(b,n,s)      //do b = an n-bit random BigInt. if s=1, then nth bit (most significant bit) is set to 1. n>=1.
// function randTruePrime_(ans,k)   //do ans = a random k-bit true random prime (not just probable prime) with 1 in the msb.
// function squareMod_(x,n)         //do x=x*x  mod n for bigInts x,n
// function sub_(x,y)               //do x=x-y for bigInts x and y. Negative answers will be 2s complement.
// function subShift_(x,y,ys)       //do x=x-(y<<(ys*bpe)). Negative answers will be 2s complement.
//
// The following functions are based on algorithms from the _Handbook of Applied Cryptography_
//    powMod_()           = algorithm 14.94, Montgomery exponentiation
//    eGCD_,inverseMod_() = algorithm 14.61, Binary extended GCD_
//    GCD_()              = algorothm 14.57, Lehmer's algorithm
//    mont_()             = algorithm 14.36, Montgomery multiplication
//    divide_()           = algorithm 14.20  Multiple-precision division
//    squareMod_()        = algorithm 14.16  Multiple-precision squaring
//    randTruePrime_()    = algorithm  4.62, Maurer's algorithm
//    millerRabin()       = algorithm  4.24, Miller-Rabin algorithm
//
// Profiling shows:
//     randTruePrime_() spends:
//         10% of its time in calls to powMod_()
//         85% of its time in calls to millerRabin()
//     millerRabin() spends:
//         99% of its time in calls to powMod_()   (always with a base of 2)
//     powMod_() spends:
//         94% of its time in calls to mont_()  (almost always with x==y)
//
// This suggests there are several ways to speed up this library slightly:
//     - convert powMod_ to use a Montgomery form of k-ary window (or maybe a Montgomery form of sliding window)
//         -- this should especially focus on being fast when raising 2 to a power mod n
//     - convert randTruePrime_() to use a minimum r of 1/3 instead of 1/2 with the appropriate change to the test
//     - tune the parameters in randTruePrime_(), including c, m, and recLimit
//     - speed up the single loop in mont_() that takes 95% of the runtime, perhaps by reducing checking
//       within the loop when all the parameters are the same length.
//
// There are several ideas that look like they wouldn't help much at all:
//     - replacing trial division in randTruePrime_() with a sieve (that speeds up something taking almost no time anyway)
//     - increase bpe from 15 to 30 (that would help if we had a 32*32->64 multiplier, but not with JavaScript's 32*32->32)
//     - speeding up mont_(x,y,n,np) when x==y by doing a non-modular, non-Montgomery square
//       followed by a Montgomery reduction.  The intermediate answer will be twice as long as x, so that
//       method would be slower.  This is unfortunate because the code currently spends almost all of its time
//       doing mont_(x,x,...), both for randTruePrime_() and powMod_().  A faster method for Montgomery squaring
//       would have a large impact on the speed of randTruePrime_() and powMod_().  HAC has a couple of poorly-worded
//       sentences that seem to imply it's faster to do a non-modular square followed by a single
//       Montgomery reduction, but that's obviously wrong.
////////////////////////////////////////////////////////////////////////////////////////

//globals
bpe=0;         //bits stored per array element
mask=0;        //AND this with an array element to chop it down to bpe bits
radix=mask+1;  //equals 2^bpe.  A single 1 bit to the left of the last bit of mask.

//the digits for converting to different bases
digitsStr='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_=!@#$%^&*()[]{}|;:,.<>/?`~ \\\'\"+-';

//initialize the global variables
for (bpe=0; (1<<(bpe+1)) > (1<<bpe); bpe++);  //bpe=number of bits in the mantissa on this platform
bpe>>=1;                   //bpe=number of bits in one element of the array representing the bigInt
mask=(1<<bpe)-1;           //AND the mask with an integer to get its bpe least significant bits
radix=mask+1;              //2^bpe.  a single 1 bit to the left of the first bit of mask
one=int2bigInt(1,1,1);     //constant used in powMod_()

//the following global variables are scratchpad memory to 
//reduce dynamic memory allocation in the inner loop
t=new Array(0);
ss=t;       //used in mult_()
s0=t;       //used in multMod_(), squareMod_() 
s1=t;       //used in powMod_(), multMod_(), squareMod_() 
s2=t;       //used in powMod_(), multMod_()
s3=t;       //used in powMod_()
s4=t; s5=t; //used in mod_()
s6=t;       //used in bigInt2str()
s7=t;       //used in powMod_()
T=t;        //used in GCD_()
sa=t;       //used in mont_()
mr_x1=t; mr_r=t; mr_a=t;                                      //used in millerRabin()
eg_v=t; eg_u=t; eg_A=t; eg_B=t; eg_C=t; eg_D=t;               //used in eGCD_(), inverseMod_()
md_q1=t; md_q2=t; md_q3=t; md_r=t; md_r1=t; md_r2=t; md_tt=t; //used in mod_()

primes=t; pows=t; s_i=t; s_i2=t; s_R=t; s_rm=t; s_q=t; s_n1=t; 
  s_a=t; s_r2=t; s_n=t; s_b=t; s_d=t; s_x1=t; s_x2=t, s_aa=t; //used in randTruePrime_()

////////////////////////////////////////////////////////////////////////////////////////

//return array of all primes less than integer n
function findPrimes(n) {
  var i,s,p,ans;
  s=new Array(n);
  for (i=0;i<n;i++)
    s[i]=0;
  s[0]=2;
  p=0;    //first p elements of s are primes, the rest are a sieve
  for(;s[p]<n;) {                  //s[p] is the pth prime
    for(i=s[p]*s[p]; i<n; i+=s[p]) //mark multiples of s[p]
      s[i]=1;
    p++;
    s[p]=s[p-1]+1;
    for(; s[p]<n && s[s[p]]; s[p]++); //find next prime (where s[p]==0)
  }
  ans=new Array(p);
  for(i=0;i<p;i++)
    ans[i]=s[i];
  return ans;
}

//does a single round of Miller-Rabin base b consider x to be a possible prime?
//x is a bigInt, and b is an integer
function millerRabin(x,b) {
  var i,j,k,s;

  if (mr_x1.length!=x.length) {
    mr_x1=dup(x);
    mr_r=dup(x);
    mr_a=dup(x);
  }

  copyInt_(mr_a,b);
  copy_(mr_r,x);
  copy_(mr_x1,x);

  addInt_(mr_r,-1);
  addInt_(mr_x1,-1);

  //s=the highest power of two that divides mr_r
  k=0;
  for (i=0;i<mr_r.length;i++)
    for (j=1;j<mask;j<<=1)
      if (x[i] & j) {
        s=(k<mr_r.length+bpe ? k : 0); 
         i=mr_r.length;
         j=mask;
      } else
        k++;

  if (s)                
    rightShift_(mr_r,s);

  powMod_(mr_a,mr_r,x);

  if (!equalsInt(mr_a,1) && !equals(mr_a,mr_x1)) {
    j=1;
    while (j<=s-1 && !equals(mr_a,mr_x1)) {
      squareMod_(mr_a,x);
      if (equalsInt(mr_a,1)) {
        return 0;
      }
      j++;
    }
    if (!equals(mr_a,mr_x1)) {
      return 0;
    }
  }
  return 1;  
}

//returns how many bits long the bigInt is, not counting leading zeros.
function bitSize(x) {
  var j,z,w;
  for (j=x.length-1; (x[j]==0) && (j>0); j--);
  for (z=0,w=x[j]; w; (w>>=1),z++);
  z+=bpe*j;
  return z;
}

//return a copy of x with at least n elements, adding leading zeros if needed
function expand(x,n) {
  var ans=int2bigInt(0,(x.length>n ? x.length : n)*bpe,0);
  copy_(ans,x);
  return ans;
}

//return a k-bit true random prime using Maurer's algorithm.
function randTruePrime(k) {
  var ans=int2bigInt(0,k,0);
  randTruePrime_(ans,k);
  return trim(ans,1);
}

//return a new bigInt equal to (x mod n) for bigInts x and n.
function mod(x,n) {
  var ans=dup(x);
  mod_(ans,n);
  return trim(ans,1);
}

//return (x+n) where x is a bigInt and n is an integer.
function addInt(x,n) {
  var ans=expand(x,x.length+1);
  addInt_(ans,n);
  return trim(ans,1);
}

//return x*y for bigInts x and y. This is faster when y<x.
function mult(x,y) {
  var ans=expand(x,x.length+y.length);
  mult_(ans,y);
  return trim(ans,1);
}

//return (x**y mod n) where x,y,n are bigInts and ** is exponentiation.  0**0=1. Faster for odd n.
function powMod(x,y,n) {
  var ans=expand(x,n.length);  
  powMod_(ans,trim(y,2),trim(n,2),0);  //this should work without the trim, but doesn't
  return trim(ans,1);
}

//return (x-y) for bigInts x and y.  Negative answers will be 2s complement
function sub(x,y) {
  var ans=expand(x,(x.length>y.length ? x.length+1 : y.length+1)); 
  sub_(ans,y);
  return trim(ans,1);
}

//return (x+y) for bigInts x and y.  
function add(x,y) {
  var ans=expand(x,(x.length>y.length ? x.length+1 : y.length+1)); 
  add_(ans,y);
  return trim(ans,1);
}

//return (x**(-1) mod n) for bigInts x and n.  If no inverse exists, it returns null
function inverseMod(x,n) {
  var ans=expand(x,n.length); 
  var s;
  s=inverseMod_(ans,n);
  return s ? trim(ans,1) : null;
}

//return (x*y mod n) for bigInts x,y,n.  For greater speed, let y<x.
function multMod(x,y,n) {
  var ans=expand(x,n.length);
  multMod_(ans,y,n);
  return trim(ans,1);
}

//generate a k-bit true random prime using Maurer's algorithm,
//and put it into ans.  The bigInt ans must be large enough to hold it.
function randTruePrime_(ans,k) {
  var c,m,pm,dd,j,r,B,divisible,z,zz,recSize;

  if (primes.length==0)
    primes=findPrimes(30000);  //check for divisibility by primes <=30000

  if (pows.length==0) {
    pows=new Array(512);
    for (j=0;j<512;j++) {
      pows[j]=Math.pow(2,j/511.-1.);
    }
  }

  //c and m should be tuned for a particular machine and value of k, to maximize speed
  //this was:   c=primes[primes.length-1]/k/k;  //check using all the small primes.  (c=0.1 in HAC)
  c=0.1;  
  m=20;   //generate this k-bit number by first recursively generating a number that has between k/2 and k-m bits
  recLimit=20; /*must be at least 2 (was 29)*/   //stop recursion when k <=recLimit

  if (s_i2.length!=ans.length) {
    s_i2=dup(ans);
    s_R =dup(ans);
    s_n1=dup(ans);
    s_r2=dup(ans);
    s_d =dup(ans);
    s_x1=dup(ans);
    s_x2=dup(ans);
    s_b =dup(ans);
    s_n =dup(ans);
    s_i =dup(ans);
    s_rm=dup(ans);
    s_q =dup(ans);
    s_a =dup(ans);
    s_aa=dup(ans);
  }

  if (k <= recLimit) {  //generate small random primes by trial division up to its square root
    pm=(1<<((k+2)>>1))-1; //pm is binary number with all ones, just over sqrt(2^k)
    copyInt_(ans,0);
    for (dd=1;dd;) {
      dd=0;
      ans[0]= 1 | (1<<(k-1)) | Math.floor(Math.random()*(1<<k));  //random, k-bit, odd integer, with msb 1
      for (j=1;(j<primes.length) && ((primes[j]&pm)==primes[j]);j++) { //trial division by all primes 3...sqrt(2^k)
        if (0==(ans[0]%primes[j])) {
          dd=1;
          break;
        }
      }
    }
    carry_(ans);
    return;
  }

  B=c*k*k;    //try small primes up to B (or all the primes[] array if the largest is less than B).
  if (k>2*m)  //generate this k-bit number by first recursively generating a number that has between k/2 and k-m bits
    for (r=1; k-k*r<=m; )
      r=pows[Math.floor(Math.random()*512)];   //r=Math.pow(2,Math.random()-1);
  else
    r=.5;

  //simulation suggests the more complex algorithm using r=.333 is only slightly faster.

  recSize=Math.floor(r*k)+1;

  randTruePrime_(s_q,recSize);
  copyInt_(s_i2,0);
  s_i2[Math.floor((k-2)/bpe)] |= (1<<((k-2)%bpe));   //s_i2=2^(k-2)
  divide_(s_i2,s_q,s_i,s_rm);                         //s_i=floor((2^(k-1))/(2q))

  z=bitSize(s_i);

  for (;;) {
    for (;;) {  //generate z-bit numbers until one falls in the range [0,s_i-1]
      randBigInt_(s_R,z,0);
      if (greater(s_i,s_R))
        break;
    }               //now s_R is in the range [0,s_i-1]
    addInt_(s_R,1);  //now s_R is in the range [1,s_i]
    add_(s_R,s_i);   //now s_R is in the range [s_i+1,2*s_i]

    copy_(s_n,s_q);
    mult_(s_n,s_R); 
    multInt_(s_n,2);
    addInt_(s_n,1);    //s_n=2*s_R*s_q+1
    
    copy_(s_r2,s_R);
    multInt_(s_r2,2);  //s_r2=2*s_R

    //check s_n for divisibility by small primes up to B
    for (divisible=0,j=0; (j<primes.length) && (primes[j]<B); j++)
      if (modInt(s_n,primes[j])==0) {
        divisible=1;
        break;
      }      

    if (!divisible)    //if it passes small primes check, then try a single Miller-Rabin base 2
      if (!millerRabin(s_n,2)) //this line represents 75% of the total runtime for randTruePrime_ 
        divisible=1;

    if (!divisible) {  //if it passes that test, continue checking s_n
      addInt_(s_n,-3);
      for (j=s_n.length-1;(s_n[j]==0) && (j>0); j--);  //strip leading zeros
      for (zz=0,w=s_n[j]; w; (w>>=1),zz++);
      zz+=bpe*j;                             //zz=number of bits in s_n, ignoring leading zeros
      for (;;) {  //generate z-bit numbers until one falls in the range [0,s_n-1]
        randBigInt_(s_a,zz,0);
        if (greater(s_n,s_a))
          break;
      }               //now s_a is in the range [0,s_n-1]
      addInt_(s_n,3);  //now s_a is in the range [0,s_n-4]
      addInt_(s_a,2);  //now s_a is in the range [2,s_n-2]
      copy_(s_b,s_a);
      copy_(s_n1,s_n);
      addInt_(s_n1,-1);
      powMod_(s_b,s_n1,s_n);   //s_b=s_a^(s_n-1) modulo s_n
      addInt_(s_b,-1);
      if (isZero(s_b)) {
        copy_(s_b,s_a);
        powMod_(s_b,s_r2,s_n);
        addInt_(s_b,-1);
        copy_(s_aa,s_n);
        copy_(s_d,s_b);
        GCD_(s_d,s_n);  //if s_b and s_n are relatively prime, then s_n is a prime
        if (equalsInt(s_d,1)) {
          copy_(ans,s_aa);
          return;     //if we've made it this far, then s_n is absolutely guaranteed to be prime
        }
      }
    }
  }
}

//set b to an n-bit random BigInt.  If s=1, then nth bit (most significant bit) is set to 1.
//array b must be big enough to hold the result. Must have n>=1
function randBigInt_(b,n,s) {
  var i,a;
  for (i=0;i<b.length;i++)
    b[i]=0;
  a=Math.floor((n-1)/bpe)+1; //# array elements to hold the BigInt
  for (i=0;i<a;i++) {
    b[i]=Math.floor(Math.random()*(1<<(bpe-1)));
  }
  b[a-1] &= (2<<((n-1)%bpe))-1;
  if (s)
    b[a-1] |= (1<<((n-1)%bpe));
}

//set x to the greatest common divisor of x and y.
//x,y are bigInts with the same number of elements.  y is destroyed.
function GCD_(x,y) {
  var i,xp,yp,A,B,C,D,q,sing;
  if (T.length!=x.length)
    T=dup(x);

  sing=1;
  while (sing) { //while y has nonzero elements other than y[0]
    sing=0;
    for (i=1;i<y.length;i++) //check if y has nonzero elements other than 0
      if (y[i]) {
        sing=1;
        break;
      }
    if (!sing) break; //quit when y all zero elements except possibly y[0]

    for (i=x.length;!x[i] && i>=0;i--);  //find most significant element of x
    xp=x[i];
    yp=y[i];
    A=1; B=0; C=0; D=1;
    while ((yp+C) && (yp+D)) {
      q =Math.floor((xp+A)/(yp+C));
      qp=Math.floor((xp+B)/(yp+D));
      if (q!=qp)
        break;
      t= A-q*C;   A=C;   C=t;    //  do (A,B,xp, C,D,yp) = (C,D,yp, A,B,xp) - q*(0,0,0, C,D,yp)      
      t= B-q*D;   B=D;   D=t;
      t=xp-q*yp; xp=yp; yp=t;
    }
    if (B) {
      copy_(T,x);
      linComb_(x,y,A,B); //x=A*x+B*y
      linComb_(y,T,D,C); //y=D*y+C*T
    } else {
      mod_(x,y);
      copy_(T,x);
      copy_(x,y);
      copy_(y,T);
    } 
  }
  if (y[0]==0)
    return;
  t=modInt(x,y[0]);
  copyInt_(x,y[0]);
  y[0]=t;
  while (y[0]) {
    x[0]%=y[0];
    t=x[0]; x[0]=y[0]; y[0]=t;
  }
}

//do x=x**(-1) mod n, for bigInts x and n.
//If no inverse exists, it sets x to zero and returns 0, else it returns 1.
//The x array must be at least as large as the n array.
function inverseMod_(x,n) {
  var k=1+2*Math.max(x.length,n.length);

  if(!(x[0]&1)  && !(n[0]&1)) {  //if both inputs are even, then inverse doesn't exist
    copyInt_(x,0);
    return 0;
  }

  if (eg_u.length!=k) {
    eg_u=new Array(k);
    eg_v=new Array(k);
    eg_A=new Array(k);
    eg_B=new Array(k);
    eg_C=new Array(k);
    eg_D=new Array(k);
  }

  copy_(eg_u,x);
  copy_(eg_v,n);
  copyInt_(eg_A,1);
  copyInt_(eg_B,0);
  copyInt_(eg_C,0);
  copyInt_(eg_D,1);
  for (;;) {
    while(!(eg_u[0]&1)) {  //while eg_u is even
      halve_(eg_u);
      if (!(eg_A[0]&1) && !(eg_B[0]&1)) { //if eg_A==eg_B==0 mod 2
        halve_(eg_A);
        halve_(eg_B);      
      } else {
        add_(eg_A,n);  halve_(eg_A);
        sub_(eg_B,x);  halve_(eg_B);
      }
    }

    while (!(eg_v[0]&1)) {  //while eg_v is even
      halve_(eg_v);
      if (!(eg_C[0]&1) && !(eg_D[0]&1)) { //if eg_C==eg_D==0 mod 2
        halve_(eg_C);
        halve_(eg_D);      
      } else {
        add_(eg_C,n);  halve_(eg_C);
        sub_(eg_D,x);  halve_(eg_D);
      }
    }

    if (!greater(eg_v,eg_u)) { //eg_v <= eg_u
      sub_(eg_u,eg_v);
      sub_(eg_A,eg_C);
      sub_(eg_B,eg_D);
    } else {                   //eg_v > eg_u
      sub_(eg_v,eg_u);
      sub_(eg_C,eg_A);
      sub_(eg_D,eg_B);
    }
  
    if (equalsInt(eg_u,0)) {
      if (negative(eg_C)) //make sure answer is nonnegative
        add_(eg_C,n);
      copy_(x,eg_C);

      if (!equalsInt(eg_v,1)) { //if GCD_(x,n)!=1, then there is no inverse
        copyInt_(x,0);
        return 0;
      }
      return 1;
    }
  }
}

//return x**(-1) mod n, for integers x and n.  Return 0 if there is no inverse
function inverseModInt_(x,n) {
  var a=1,b=0,t;
  for (;;) {
    if (x==1) return a;
    if (x==0) return 0;
    b-=a*Math.floor(n/x);
    n%=x;

    if (n==1) return b; //to avoid negatives, change this b to n-b, and each -= to +=
    if (n==0) return 0;
    a-=b*Math.floor(x/n);
    x%=n;
  }
}

//Given positive bigInts x and y, change the bigints v, a, and b to positive bigInts such that:
//     v = GCD_(x,y) = a*x-b*y
//The bigInts v, a, b, must have exactly as many elements as the larger of x and y.
function eGCD_(x,y,v,a,b) {
  var g=0;
  var k=Math.max(x.length,y.length);
  if (eg_u.length!=k) {
    eg_u=new Array(k);
    eg_A=new Array(k);
    eg_B=new Array(k);
    eg_C=new Array(k);
    eg_D=new Array(k);
  }
  while(!(x[0]&1)  && !(y[0]&1)) {  //while x and y both even
    halve_(x);
    halve_(y);
    g++;
  }
  copy_(eg_u,x);
  copy_(v,y);
  copyInt_(eg_A,1);
  copyInt_(eg_B,0);
  copyInt_(eg_C,0);
  copyInt_(eg_D,1);
  for (;;) {
    while(!(eg_u[0]&1)) {  //while u is even
      halve_(eg_u);
      if (!(eg_A[0]&1) && !(eg_B[0]&1)) { //if A==B==0 mod 2
        halve_(eg_A);
        halve_(eg_B);      
      } else {
        add_(eg_A,y);  halve_(eg_A);
        sub_(eg_B,x);  halve_(eg_B);
      }
    }

    while (!(v[0]&1)) {  //while v is even
      halve_(v);
      if (!(eg_C[0]&1) && !(eg_D[0]&1)) { //if C==D==0 mod 2
        halve_(eg_C);
        halve_(eg_D);      
      } else {
        add_(eg_C,y);  halve_(eg_C);
        sub_(eg_D,x);  halve_(eg_D);
      }
    }

    if (!greater(v,eg_u)) { //v<=u
      sub_(eg_u,v);
      sub_(eg_A,eg_C);
      sub_(eg_B,eg_D);
    } else {                //v>u
      sub_(v,eg_u);
      sub_(eg_C,eg_A);
      sub_(eg_D,eg_B);
    }
    if (equalsInt(eg_u,0)) {
      if (negative(eg_C)) {   //make sure a (C)is nonnegative
        add_(eg_C,y);
        sub_(eg_D,x);
      }
      multInt_(eg_D,-1);  ///make sure b (D) is nonnegative
      copy_(a,eg_C);
      copy_(b,eg_D);
      leftShift_(v,g);
      return;
    }
  }
}


//is bigInt x negative?
function negative(x) {
  return ((x[x.length-1]>>(bpe-1))&1);
}


//is (x << (shift*bpe)) > y?
//x and y are nonnegative bigInts
//shift is a nonnegative integer
function greaterShift(x,y,shift) {
  var kx=x.length, ky=y.length;
  k=((kx+shift)<ky) ? (kx+shift) : ky;
  for (i=ky-1-shift; i<kx && i>=0; i++) 
    if (x[i]>0)
      return 1; //if there are nonzeros in x to the left of the first column of y, then x is bigger
  for (i=kx-1+shift; i<ky; i++)
    if (y[i]>0)
      return 0; //if there are nonzeros in y to the left of the first column of x, then x is not bigger
  for (i=k-1; i>=shift; i--)
    if      (x[i-shift]>y[i]) return 1;
    else if (x[i-shift]<y[i]) return 0;
  return 0;
}

//is x > y? (x and y both nonnegative)
function greater(x,y) {
  var i;
  var k=(x.length<y.length) ? x.length : y.length;

  for (i=x.length;i<y.length;i++)
    if (y[i])
      return 0;  //y has more digits

  for (i=y.length;i<x.length;i++)
    if (x[i])
      return 1;  //x has more digits

  for (i=k-1;i>=0;i--)
    if (x[i]>y[i])
      return 1;
    else if (x[i]<y[i])
      return 0;
  return 0;
}

//divide_ x by y giving quotient q and remainder r.  (q=floor(x/y),  r=x mod y).  All 4 are bigints.
//x must have at least one leading zero element.
//y must be nonzero.
//q and r must be arrays that are exactly the same length as x.
//the x array must have at least as many elements as y.
function divide_(x,y,q,r) {
  var kx, ky;
  var i,j,y1,y2,c,a,b;
  copy_(r,x);
  for (ky=y.length;y[ky-1]==0;ky--); //kx,ky is number of elements in x,y, not including leading zeros
  for (kx=r.length;r[kx-1]==0 && kx>ky;kx--);

  //normalize: ensure the most significant element of y has its highest bit set  
  b=y[ky-1];
  for (a=0; b; a++)
    b>>=1;  
  a=bpe-a;  //a is how many bits to shift so that the high order bit of y is leftmost in its array element
  leftShift_(y,a);  //multiply both by 1<<a now, then divide_ both by that at the end
  leftShift_(r,a);

  copyInt_(q,0);                // q=0
  while (!greaterShift(y,r,kx-ky)) {  // while (leftShift_(y,kx-ky) <= r) {
    subShift_(r,y,kx-ky);      //   r=r-leftShift_(y,kx-ky)
    q[kx-ky]++;                  //   q[kx-ky]++;
  }                              // }

  for (i=kx-1; i>=ky; i--) {
    if (r[i]==y[ky-1])
      q[i-ky]=mask;
    else
      q[i-ky]=Math.floor((r[i]*radix+r[i-1])/y[ky-1]);	

    //The following for(;;) loop is equivalent to the commented while loop, 
    //except that the uncommented version avoids overflow.
    //The commented loop comes from HAC, which assumes r[-1]==y[-1]==0
    //  while (q[i-ky]*(y[ky-1]*radix+y[ky-2]) > r[i]*radix*radix+r[i-1]*radix+r[i-2])
    //    q[i-ky]--;    
    for (;;) {
      y2=(ky>1 ? y[ky-2] : 0)*q[i-ky];
      c=y2>>bpe;
      y2=y2 & mask;
      y1=c+q[i-ky]*y[ky-1];
      c=y1>>bpe;
      y1=y1 & mask;

      if (c==r[i] ? y1==r[i-1] ? y2>(i>1 ? r[i-2] : 0) : y1>r[i-1] : c>r[i]) 
        q[i-ky]--;
      else
        break;
    }

    linCombShift_(r,y,-q[i-ky],i-ky);    //r=r-q[i-ky]*leftShift_(y,i-ky)
    if (negative(r)) {
      addShift_(r,y,i-ky);         //r=r+leftShift_(y,i-ky)
      q[i-ky]--;
    }
  }

  rightShift_(y,a);  //undo the normalization step
  rightShift_(r,a);  //undo the normalization step
}

//do carries and borrows so each element of the bigInt x fits in bpe bits.
function carry_(x) {
  var i,k,c,b;
  k=x.length;
  c=0;
  for (i=0;i<k;i++) {
    c+=x[i];
    b=0;
    if (c<0) {
      b=-(c>>bpe);
      c+=b*radix;
    }
    x[i]=c & mask;
    c=(c>>bpe)-b;
  }
}

//return x mod n for bigInt x and integer n.
function modInt(x,n) {
  var i,c=0;
  for (i=x.length-1; i>=0; i--)
    c=(c*radix+x[i])%n;
  return c;
}

//convert the integer t into a bigInt with at least the given number of bits.
//the returned array stores the bigInt in bpe-bit chunks, little endian (buff[0] is least significant word)
//Pad the array with leading zeros so that it has at least minSize elements.
//There will always be at least one leading 0 element.
function int2bigInt(t,bits,minSize) {   
  var i,k;
  k=Math.ceil(bits/bpe)+1;
  k=minSize>k ? minSize : k;
  buff=new Array(k);
  copyInt_(buff,t);
  return buff;
}

//return the bigInt given a string representation in a given base.  
//Pad the array with leading zeros so that it has at least minSize elements.
//If base=-1, then it reads in a space-separated list of array elements in decimal.
//The array will always have at least one leading zero, unless base=-1.
function str2bigInt(s,base,minSize) {
  var d, i, j, x, y, kk;
  var k=s.length;
  if (base==-1) { //comma-separated list of array elements in decimal
    x=new Array(0);
    for (;;) {
      y=new Array(x.length+1);
      for (i=0;i<x.length;i++)
        y[i+1]=x[i];
      y[0]=parseInt(s,10);
      x=y;
      d=s.indexOf(',',0);
      if (d<1) 
        break;
      s=s.substring(d+1);
      if (s.length==0)
        break;
    }
    if (x.length<minSize) {
      y=new Array(minSize);
      copy_(y,x);
      return y;
    }
    return x;
  }

  x=int2bigInt(0,base*k,0);
  for (i=0;i<k;i++) {
    d=digitsStr.indexOf(s.substring(i,i+1),0);
    if (base<=36 && d>=36)  //convert lowercase to uppercase if base<=36
      d-=26;
    if (d<base && d>=0) {   //ignore illegal characters
      multInt_(x,base);
      addInt_(x,d);
    }
  }

  for (k=x.length;k>0 && !x[k-1];k--); //strip off leading zeros
  k=minSize>k+1 ? minSize : k+1;
  y=new Array(k);
  kk=k<x.length ? k : x.length;
  for (i=0;i<kk;i++)
    y[i]=x[i];
  for (;i<k;i++)
    y[i]=0;
  return y;
}

//is bigint x equal to integer y?
//y must have less than bpe bits
function equalsInt(x,y) {
  var i;
  if (x[0]!=y)
    return 0;
  for (i=1;i<x.length;i++)
    if (x[i])
      return 0;
  return 1;
}

//are bigints x and y equal?
//this works even if x and y are different lengths and have arbitrarily many leading zeros
function equals(x,y) {
  var i;
  var k=x.length<y.length ? x.length : y.length;
  for (i=0;i<k;i++)
    if (x[i]!=y[i])
      return 0;
  if (x.length>y.length) {
    for (;i<x.length;i++)
      if (x[i])
        return 0;
  } else {
    for (;i<y.length;i++)
      if (y[i])
        return 0;
  }
  return 1;
}

//is the bigInt x equal to zero?
function isZero(x) {
  var i;
  for (i=0;i<x.length;i++)
    if (x[i])
      return 0;
  return 1;
}

//convert a bigInt into a string in a given base, from base 2 up to base 95.
//Base -1 prints the contents of the array representing the number.
function bigInt2str(x,base) {
  var i,t,s="";

  if (s6.length!=x.length) 
    s6=dup(x);
  else
    copy_(s6,x);

  if (base==-1) { //return the list of array contents
    for (i=x.length-1;i>0;i--)
      s+=x[i]+',';
    s+=x[0];
  }
  else { //return it in the given base
    while (!isZero(s6)) {
      t=divInt_(s6,base);  //t=s6 % base; s6=floor(s6/base);
      s=digitsStr.substring(t,t+1)+s;
    }
  }
  if (s.length==0)
    s="0";
  return s;
}

//returns a duplicate of bigInt x
function dup(x) {
  var i;
  buff=new Array(x.length);
  copy_(buff,x);
  return buff;
}

//do x=y on bigInts x and y.  x must be an array at least as big as y (not counting the leading zeros in y).
function copy_(x,y) {
  var i;
  var k=x.length<y.length ? x.length : y.length;
  for (i=0;i<k;i++)
    x[i]=y[i];
  for (i=k;i<x.length;i++)
    x[i]=0;
}

//do x=y on bigInt x and integer y.  
function copyInt_(x,n) {
  var i,c;
  for (c=n,i=0;i<x.length;i++) {
    x[i]=c & mask;
    c>>=bpe;
  }
}

//do x=x+n where x is a bigInt and n is an integer.
//x must be large enough to hold the result.
function addInt_(x,n) {
  var i,k,c,b;
  x[0]+=n;
  k=x.length;
  c=0;
  for (i=0;i<k;i++) {
    c+=x[i];
    b=0;
    if (c<0) {
      b=-(c>>bpe);
      c+=b*radix;
    }
    x[i]=c & mask;
    c=(c>>bpe)-b;
    if (!c) return; //stop carrying as soon as the carry_ is zero
  }
}

//right shift bigInt x by n bits.  0 <= n < bpe.
function rightShift_(x,n) {
  var i;
  var k=Math.floor(n/bpe);
  if (k) {
    for (i=0;i<x.length-k;i++) //right shift x by k elements
      x[i]=x[i+k];
    for (;i<x.length;i++)
      x[i]=0;
    n%=bpe;
  }
  for (i=0;i<x.length-1;i++) {
    x[i]=mask & ((x[i+1]<<(bpe-n)) | (x[i]>>n));
  }
  x[i]>>=n;
}

//do x=floor(|x|/2)*sgn(x) for bigInt x in 2's complement
function halve_(x) {
  var i;
  for (i=0;i<x.length-1;i++) {
    x[i]=mask & ((x[i+1]<<(bpe-1)) | (x[i]>>1));
  }
  x[i]=(x[i]>>1) | (x[i] & (radix>>1));  //most significant bit stays the same
}

//left shift bigInt x by n bits.
function leftShift_(x,n) {
  var i;
  var k=Math.floor(n/bpe);
  if (k) {
    for (i=x.length; i>=k; i--) //left shift x by k elements
      x[i]=x[i-k];
    for (;i>=0;i--)
      x[i]=0;  
    n%=bpe;
  }
  if (!n)
    return;
  for (i=x.length-1;i>0;i--) {
    x[i]=mask & ((x[i]<<n) | (x[i-1]>>(bpe-n)));
  }
  x[i]=mask & (x[i]<<n);
}

//do x=x*n where x is a bigInt and n is an integer.
//x must be large enough to hold the result.
function multInt_(x,n) {
  var i,k,c,b;
  if (!n)
    return;
  k=x.length;
  c=0;
  for (i=0;i<k;i++) {
    c+=x[i]*n;
    b=0;
    if (c<0) {
      b=-(c>>bpe);
      c+=b*radix;
    }
    x[i]=c & mask;
    c=(c>>bpe)-b;
  }
}

//do x=floor(x/n) for bigInt x and integer n, and return the remainder
function divInt_(x,n) {
  var i,r=0,s;
  for (i=x.length-1;i>=0;i--) {
    s=r*radix+x[i];
    x[i]=Math.floor(s/n);
    r=s%n;
  }
  return r;
}

//do the linear combination x=a*x+b*y for bigInts x and y, and integers a and b.
//x must be large enough to hold the answer.
function linComb_(x,y,a,b) {
  var i,c,k,kk;
  k=x.length<y.length ? x.length : y.length;
  kk=x.length;
  for (c=0,i=0;i<k;i++) {
    c+=a*x[i]+b*y[i];
    x[i]=c & mask;
    c>>=bpe;
  }
  for (i=k;i<kk;i++) {
    c+=a*x[i];
    x[i]=c & mask;
    c>>=bpe;
  }
}

//do the linear combination x=a*x+b*(y<<(ys*bpe)) for bigInts x and y, and integers a, b and ys.
//x must be large enough to hold the answer.
function linCombShift_(x,y,b,ys) {
  var i,c,k,kk;
  k=x.length<ys+y.length ? x.length : ys+y.length;
  kk=x.length;
  for (c=0,i=ys;i<k;i++) {
    c+=x[i]+b*y[i-ys];
    x[i]=c & mask;
    c>>=bpe;
  }
  for (i=k;c && i<kk;i++) {
    c+=x[i];
    x[i]=c & mask;
    c>>=bpe;
  }
}

//do x=x+(y<<(ys*bpe)) for bigInts x and y, and integers a,b and ys.
//x must be large enough to hold the answer.
function addShift_(x,y,ys) {
  var i,c,k,kk;
  k=x.length<ys+y.length ? x.length : ys+y.length;
  kk=x.length;
  for (c=0,i=ys;i<k;i++) {
    c+=x[i]+y[i-ys];
    x[i]=c & mask;
    c>>=bpe;
  }
  for (i=k;c && i<kk;i++) {
    c+=x[i];
    x[i]=c & mask;
    c>>=bpe;
  }
}

//do x=x-(y<<(ys*bpe)) for bigInts x and y, and integers a,b and ys.
//x must be large enough to hold the answer.
function subShift_(x,y,ys) {
  var i,c,k,kk;
  k=x.length<ys+y.length ? x.length : ys+y.length;
  kk=x.length;
  for (c=0,i=ys;i<k;i++) {
    c+=x[i]-y[i-ys];
    x[i]=c & mask;
    c>>=bpe;
  }
  for (i=k;c && i<kk;i++) {
    c+=x[i];
    x[i]=c & mask;
    c>>=bpe;
  }
}

//do x=x-y for bigInts x and y.
//x must be large enough to hold the answer.
//negative answers will be 2s complement
function sub_(x,y) {
  var i,c,k,kk;
  k=x.length<y.length ? x.length : y.length;
  for (c=0,i=0;i<k;i++) {
    c+=x[i]-y[i];
    x[i]=c & mask;
    c>>=bpe;
  }
  for (i=k;c && i<x.length;i++) {
    c+=x[i];
    x[i]=c & mask;
    c>>=bpe;
  }
}

//do x=x+y for bigInts x and y.
//x must be large enough to hold the answer.
function add_(x,y) {
  var i,c,k,kk;
  k=x.length<y.length ? x.length : y.length;
  for (c=0,i=0;i<k;i++) {
    c+=x[i]+y[i];
    x[i]=c & mask;
    c>>=bpe;
  }
  for (i=k;c && i<x.length;i++) {
    c+=x[i];
    x[i]=c & mask;
    c>>=bpe;
  }
}

//do x=x*y for bigInts x and y.  This is faster when y<x.
function mult_(x,y) {
  var i;
  if (ss.length!=2*x.length)
    ss=new Array(2*x.length);
  copyInt_(ss,0);
  for (i=0;i<y.length;i++)
    if (y[i])
      linCombShift_(ss,x,y[i],i);   //ss=1*ss+y[i]*(x<<(i*bpe))
  copy_(x,ss);
}

//do x=x mod n for bigInts x and n.
function mod_(x,n) {
  if (s4.length!=x.length)
    s4=dup(x);
  else
    copy_(s4,x);
  if (s5.length!=x.length)
    s5=dup(x);  
  divide_(s4,n,s5,x);  //x = remainder of s4 / n
}

//do x=x*y mod n for bigInts x,y,n.
//for greater speed, let y<x.
function multMod_(x,y,n) {
  var i;
  if (s0.length!=2*x.length)
    s0=new Array(2*x.length);
  copyInt_(s0,0);
  for (i=0;i<y.length;i++)
    if (y[i])
      linCombShift_(s0,x,y[i],i);   //s0=1*s0+y[i]*(x<<(i*bpe))
  mod_(s0,n);
  copy_(x,s0);
}

//do x=x*x mod n for bigInts x,n.
function squareMod_(x,n) {
  var i,j,d,c,kx,kn,k;
  for (kx=x.length; kx>0 && !x[kx-1]; kx--);  //ignore leading zeros in x
  k=kx>n.length ? 2*kx : 2*n.length; //k=# elements in the product, which is twice the elements in the larger of x and n
  if (s0.length!=k) 
    s0=new Array(k);
  copyInt_(s0,0);
  for (i=0;i<kx;i++) {
    c=s0[2*i]+x[i]*x[i];
    s0[2*i]=c & mask;
    c>>=bpe;
    for (j=i+1;j<kx;j++) {
      c=s0[i+j]+2*x[i]*x[j]+c;
      s0[i+j]=(c & mask);
      c>>=bpe;
    }
    s0[i+kx]=c;
  }
  mod_(s0,n);
  copy_(x,s0);
}

//return x with exactly k leading zero elements
function trim(x,k) {
  var i,y;
  for (i=x.length; i>0 && !x[i-1]; i--);
  y=new Array(i+k);
  copy_(y,x);
  return y;
}

//do x=x**y mod n, where x,y,n are bigInts and ** is exponentiation.  0**0=1.
//this is faster when n is odd.  x usually needs to have as many elements as n.
function powMod_(x,y,n) {
  var k1,k2,kn,np;
  if(s7.length!=n.length)
    s7=dup(n);

  //for even modulus, use a simple square-and-multiply algorithm,
  //rather than using the more complex Montgomery algorithm.
  if ((n[0]&1)==0) {
    copy_(s7,x);
    copyInt_(x,1);
    while(!equalsInt(y,0)) {
      if (y[0]&1)
        multMod_(x,s7,n);
      divInt_(y,2);
      squareMod_(s7,n); 
    }
    return;
  }

  //calculate np from n for the Montgomery multiplications
  copyInt_(s7,0);
  for (kn=n.length;kn>0 && !n[kn-1];kn--);
  np=radix-inverseModInt_(modInt(n,radix),radix);
  s7[kn]=1;
  multMod_(x ,s7,n);   // x = x * 2**(kn*bp) mod n

  if (s3.length!=x.length)
    s3=dup(x);
  else
    copy_(s3,x);

  for (k1=y.length-1;k1>0 & !y[k1]; k1--);  //k1=first nonzero element of y
  if (y[k1]==0) {  //anything to the 0th power is 1
    copyInt_(x,1);
    return;
  }
  for (k2=1<<(bpe-1);k2 && !(y[k1] & k2); k2>>=1);  //k2=position of first 1 bit in y[k1]
  for (;;) {
    if (!(k2>>=1)) {  //look at next bit of y
      k1--;
      if (k1<0) {
        mont_(x,one,n,np);
        return;
      }
      k2=1<<(bpe-1);
    }    
    mont_(x,x,n,np);

    if (k2 & y[k1]) //if next bit is a 1
      mont_(x,s3,n,np);
  }
}    

//do x=x*y*Ri mod n for bigInts x,y,n, 
//  where Ri = 2**(-kn*bpe) mod n, and kn is the 
//  number of elements in the n array, not 
//  counting leading zeros.  
//x must be large enough to hold the answer.
//It's OK if x and y are the same variable.
//must have:
//  x,y < n
//  n is odd
//  np = -(n^(-1)) mod radix
function mont_(x,y,n,np) {
  var i,j,c,ui,t;
  var kn=n.length;
  var ky=y.length;

  if (sa.length!=kn)
    sa=new Array(kn);

  for (;kn>0 && n[kn-1]==0;kn--); //ignore leading zeros of n
  //this function sometimes gives wrong answers when the next line is uncommented
  //for (;ky>0 && y[ky-1]==0;ky--); //ignore leading zeros of y

  copyInt_(sa,0);

  //the following loop consumes 95% of the runtime for randTruePrime_() and powMod_() for large keys
  for (i=0; i<kn; i++) {
    t=sa[0]+x[i]*y[0];
    ui=((t & mask) * np) & mask;  //the inner "& mask" is needed on Macintosh MSIE, but not windows MSIE
    c=(t+ui*n[0]) >> bpe;
    t=x[i];

    //do sa=(sa+x[i]*y+ui*n)/b   where b=2**bpe
    for (j=1;j<ky;j++) { 
      c+=sa[j]+t*y[j]+ui*n[j];
      sa[j-1]=c & mask;
      c>>=bpe;
    }    
    for (;j<kn;j++) { 
      c+=sa[j]+ui*n[j];
      sa[j-1]=c & mask;
      c>>=bpe;
    }    
    sa[j-1]=c & mask;
  }

  if (!greater(n,sa))
    sub_(sa,n);
  copy_(x,sa);
}




//#############################################################################
//#############################################################################
//#############################################################################
//#############################################################################
//#############################################################################
//#############################################################################
//#############################################################################





//#############################################################################

Clipperz.Crypto.BigInt = function (aValue, aBase) {
	var	base;
	var	value;
	
	if (typeof(aValue) == 'object') {
		this._internalValue = aValue;
	} else {
		if (typeof(aValue) == 'undefined') {
			value = "0";
		} else {
			value = aValue + "";
		}
	
		if (typeof(aBase) == 'undefined') {
			base = 10;
		} else {
			base = aBase;
		}

		this._internalValue = str2bigInt(value, base, 1, 1);
	}
	
	return this;
}

//=============================================================================

MochiKit.Base.update(Clipperz.Crypto.BigInt.prototype, {

	'clone': function() {
		return new Clipperz.Crypto.BigInt(this.internalValue());
	},
	
	//-------------------------------------------------------------------------

	'internalValue': function () {
		return this._internalValue;
	},
	
	//-------------------------------------------------------------------------

	'isBigInt': true,
	
	//-------------------------------------------------------------------------

	'toString': function(aBase) {
		return this.asString(aBase);
	},

	//-------------------------------------------------------------------------

	'asString': function (aBase, minimumLength) {
		var	result;
		var	base;

		if (typeof(aBase) == 'undefined') {
			base = 10;
		} else {
			base = aBase;
		}
		
		result = bigInt2str(this.internalValue(), base).toLowerCase();

		if ((typeof(minimumLength) != 'undefined') && (result.length < minimumLength)) {
			var i, c;
//MochiKit.Logging.logDebug(">>> FIXING BigInt.asString length issue")			
			c = (minimumLength - result.length);
			for (i=0; i<c; i++) {
				result = '0' + result;
			}
		}
		
		return result;
	},

	//-------------------------------------------------------------------------

	'asByteArray': function() {
		return new Clipperz.ByteArray("0x" + this.asString(16), 16);
	},
	
	//-------------------------------------------------------------------------

	'equals': function (aValue) {
		var result;
		
		if (aValue.isBigInt) {
		 	result = equals(this.internalValue(), aValue.internalValue());
		} else if (typeof(aValue) == "number") {
			result = equalsInt(this.internalValue(), aValue);
		} else {
			throw Clipperz.Crypt.BigInt.exception.UnknownType;
		}
		
		return result;
	},

	//-------------------------------------------------------------------------

	'compare': function(aValue) {
/*
		var result;
		var thisAsString;
		var aValueAsString;
		
		thisAsString = this.asString(10);
		aValueAsString = aValue.asString(10);
		
		result = MochiKit.Base.compare(thisAsString.length, aValueAsString.length);
		if (result == 0) {
			result = MochiKit.Base.compare(thisAsString, aValueAsString);
		}
		
		return result;
*/
		var result;
		
		if (equals(this.internalValue(), aValue.internalValue())) {
			result = 0;
		} else if (greater(this.internalValue(), aValue.internalValue())) {
			result = 1;
		} else {
			result = -1;
		}
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'add': function (aValue) {
		var result;

		if (aValue.isBigInt) {
		 	result = add(this.internalValue(), aValue.internalValue());
		} else {
			result = addInt(this.internalValue(), aValue);
		}
		
		return new Clipperz.Crypto.BigInt(result);
	},
	
	//-------------------------------------------------------------------------

	'subtract': function (aValue) {
		var result;
		var value;

		if (aValue.isBigInt) {
			value = aValue;
		} else {
			value = new Clipperz.Crypto.BigInt(aValue);
		}

	 	result = sub(this.internalValue(), value.internalValue());

		return new Clipperz.Crypto.BigInt(result);
	},
	
	//-------------------------------------------------------------------------

	'multiply': function (aValue, aModule) {
		var result;
		var value;

		if (aValue.isBigInt) {
			value = aValue;
		} else {
			value = new Clipperz.Crypto.BigInt(aValue);
		}
			
		if (typeof(aModule) == 'undefined') {
	 		result = mult(this.internalValue(), value.internalValue());
		} else {
			if (greater(this.internalValue(), value.internalValue())) {
				result = multMod(this.internalValue(), value.internalValue(), aModule);
			} else {
				result = multMod(value.internalValue(), this.internalValue(), aModule);
			}
		}
		
		return new Clipperz.Crypto.BigInt(result);
	},
	
	//-------------------------------------------------------------------------

	'module': function (aModule) {
		var	result;
		var module;
		
		if (aModule.isBigInt) {
			module = aModule;
		} else {
			module = new Clipperz.Crypto.BigInt(aModule);
		}

		result = mod(this.internalValue(), module.internalValue());
		
		return new Clipperz.Crypto.BigInt(result);
	},

	//-------------------------------------------------------------------------

	'powerModule': function(aValue, aModule) {
		var	result;
		var	value;
		var module;
		
		if (aValue.isBigInt) {
			value = aValue;
		} else {
			value = new Clipperz.Crypto.BigInt(aValue);
		}

		if (aModule.isBigInt) {
			module = aModule;
		} else {
			module = new Clipperz.Crypto.BigInt(aModule);
		}

		if (aValue == -1) {
			result = inverseMod(this.internalValue(), module.internalValue());
		} else {
			result = powMod(this.internalValue(), value.internalValue(), module.internalValue());
		}
		
		return new Clipperz.Crypto.BigInt(result);
	},
	
	//-------------------------------------------------------------------------

	'xor': function(aValue) {
		var result;
		var	thisByteArray;
		var aValueByteArray;
		var xorArray;
		
		thisByteArray = new Clipperz.ByteArray("0x" + this.asString(16), 16);
		aValueByteArray = new Clipperz.ByteArray("0x" + aValue.asString(16), 16);
		xorArray = thisByteArray.xorMergeWithBlock(aValueByteArray, 'right');
		result = new Clipperz.Crypto.BigInt(xorArray.toHexString(), 16);

		return result;
	},

	//-------------------------------------------------------------------------

	'shiftLeft': function(aNumberOfBitsToShift) {
		var result;
		var internalResult;
		var wholeByteToShift;
		var bitsLeftToShift;
		
		wholeByteToShift = Math.floor(aNumberOfBitsToShift / 8);
		bitsLeftToShift = aNumberOfBitsToShift % 8;

		if (wholeByteToShift == 0) {
			internalResult = this.internalValue();
		} else {
			var hexValue;
			var i,c;
			
			hexValue = this.asString(16);
			c = wholeByteToShift;
			for (i=0; i<c; i++) {
				hexValue += "00";
			}
			internalResult = str2bigInt(hexValue, 16, 1, 1);
		}

		if (bitsLeftToShift > 0) {
			leftShift_(internalResult, bitsLeftToShift);
		}
		result = new Clipperz.Crypto.BigInt(internalResult);
		
		return result;
	},

	//-------------------------------------------------------------------------
	
	'bitSize': function() {
		return bitSize(this.internalValue());
	},

	//-------------------------------------------------------------------------

	'isBitSet': function(aBitPosition) {
		var result;
		
		if (this.asByteArray().bitAtIndex(aBitPosition) == 0) {
			result = false;
		} else {
			result = true;
		};
		
		return result;
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"

});

//#############################################################################

Clipperz.Crypto.BigInt.randomPrime = function(aBitSize) {
	return new Clipperz.Crypto.BigInt(randTruePrime(aBitSize));
}

//#############################################################################
//#############################################################################

Clipperz.Crypto.BigInt.ZERO = new Clipperz.Crypto.BigInt(0);

//#############################################################################

Clipperz.Crypto.BigInt.equals = function(a, b) {
	return a.equals(b);
}

Clipperz.Crypto.BigInt.add = function(a, b) {
	return a.add(b);
}

Clipperz.Crypto.BigInt.subtract = function(a, b) {
	return a.subtract(b);
}

Clipperz.Crypto.BigInt.multiply = function(a, b, module) {
	return a.multiply(b, module);
}

Clipperz.Crypto.BigInt.module = function(a, module) {
	return a.module(module);
}

Clipperz.Crypto.BigInt.powerModule = function(a, b, module) {
	return a.powerModule(b, module);
}

Clipperz.Crypto.BigInt.exception = {
	UnknownType: new MochiKit.Base.NamedError("Clipperz.Crypto.BigInt.exception.UnknownType") 
}
try { if (typeof(Clipperz.ByteArray) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.PRNG depends on Clipperz.ByteArray!";
}  

try { if (typeof(Clipperz.Crypto.SHA) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.PRNG depends on Clipperz.Crypto.SHA!";
}  

try { if (typeof(Clipperz.Crypto.AES) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.PRNG depends on Clipperz.Crypto.AES!";
}  

if (typeof(Clipperz.Crypto.PRNG) == 'undefined') { Clipperz.Crypto.PRNG = {}; }

//#############################################################################

Clipperz.Crypto.PRNG.EntropyAccumulator = function(args) {
	args = args || {};
//	MochiKit.Base.bindMethods(this);

	this._stack = new Clipperz.ByteArray();
	this._maxStackLengthBeforeHashing = args.maxStackLengthBeforeHashing || 256;
	return this;
}

Clipperz.Crypto.PRNG.EntropyAccumulator.prototype = MochiKit.Base.update(null, {

	'toString': function() {
		return "Clipperz.Crypto.PRNG.EntropyAccumulator";
	},

	//-------------------------------------------------------------------------

	'stack': function() {
		return this._stack;
	},
	
	'setStack': function(aValue) {
		this._stack = aValue;
	},

	'resetStack': function() {
		this.stack().reset();
	},
	
	'maxStackLengthBeforeHashing': function() {
		return this._maxStackLengthBeforeHashing;
	},

	//-------------------------------------------------------------------------

	'addRandomByte': function(aValue) {
		this.stack().appendByte(aValue);
				
		if (this.stack().length() > this.maxStackLengthBeforeHashing()) {
			this.setStack(Clipperz.Crypto.SHA.sha_d256(this.stack()));
		}
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//#############################################################################

Clipperz.Crypto.PRNG.RandomnessSource = function(args) {
	args = args || {};
	MochiKit.Base.bindMethods(this);

	this._generator = args.generator || null;
	this._sourceId = args.sourceId || null;
	this._boostMode = args.boostMode || false;
	
	this._nextPoolIndex = 0;
	
	return this;
}

Clipperz.Crypto.PRNG.RandomnessSource.prototype = MochiKit.Base.update(null, {

	'generator': function() {
		return this._generator;
	},

	'setGenerator': function(aValue) {
		this._generator = aValue;
	},

	//-------------------------------------------------------------------------

	'boostMode': function() {
		return this._boostMode;
	},
	
	'setBoostMode': function(aValue) {
		this._boostMode = aValue;
	},
	
	//-------------------------------------------------------------------------
	
	'sourceId': function() {
		return this._sourceId;
	},

	'setSourceId': function(aValue) {
		this._sourceId = aValue;
	},
	
	//-------------------------------------------------------------------------

	'nextPoolIndex': function() {
		return this._nextPoolIndex;
	},
	
	'incrementNextPoolIndex': function() {
		this._nextPoolIndex = ((this._nextPoolIndex + 1) % this.generator().numberOfEntropyAccumulators());
	},
	
	//-------------------------------------------------------------------------

	'updateGeneratorWithValue': function(aRandomValue) {
		if (this.generator() != null) {
			this.generator().addRandomByte(this.sourceId(), this.nextPoolIndex(), aRandomValue);
			this.incrementNextPoolIndex();
		}
	},
	
	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//#############################################################################
	
Clipperz.Crypto.PRNG.TimeRandomnessSource = function(args) {
	args = args || {};
//	MochiKit.Base.bindMethods(this);

	this._intervalTime = args.intervalTime || 1000;
	
	Clipperz.Crypto.PRNG.RandomnessSource.call(this, args);

	this.collectEntropy();
	return this;
}

Clipperz.Crypto.PRNG.TimeRandomnessSource.prototype = MochiKit.Base.update(new Clipperz.Crypto.PRNG.RandomnessSource, {

	'intervalTime': function() {
		return this._intervalTime;
	},
	
	//-------------------------------------------------------------------------

	'collectEntropy': function() {
		var	now;
		var	entropyByte;
		var intervalTime;
		now = new Date();
		entropyByte = (now.getTime() & 0xff);
		
		intervalTime = this.intervalTime();
		if (this.boostMode() == true) {
			intervalTime = intervalTime / 9;
		}
		
		this.updateGeneratorWithValue(entropyByte);
		setTimeout(this.collectEntropy, intervalTime);
	},
	
	//-------------------------------------------------------------------------

	'numberOfRandomBits': function() {
		return 5;
	},
	
	//-------------------------------------------------------------------------

	'pollingFrequency': function() {
		return 10;
	},

	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//*****************************************************************************

Clipperz.Crypto.PRNG.MouseRandomnessSource = function(args) {
	args = args || {};

	Clipperz.Crypto.PRNG.RandomnessSource.call(this, args);

	this._numberOfBitsToCollectAtEachEvent = 4;
	this._randomBitsCollector = 0;
	this._numberOfRandomBitsCollected = 0;
	
	MochiKit.Signal.connect(document, 'onmousemove', this, 'collectEntropy');

	return this;
}

Clipperz.Crypto.PRNG.MouseRandomnessSource.prototype = MochiKit.Base.update(new Clipperz.Crypto.PRNG.RandomnessSource, {

	//-------------------------------------------------------------------------

	'numberOfBitsToCollectAtEachEvent': function() {
		return this._numberOfBitsToCollectAtEachEvent;
	},
	
	//-------------------------------------------------------------------------

	'randomBitsCollector': function() {
		return this._randomBitsCollector;
	},

	'setRandomBitsCollector': function(aValue) {
		this._randomBitsCollector = aValue;
	},

	'appendRandomBitsToRandomBitsCollector': function(aValue) {
		var collectedBits;
		var numberOfRandomBitsCollected;
		
		numberOfRandomBitsCollected = this.numberOfRandomBitsCollected();
		collectetBits = this.randomBitsCollector() | (aValue << numberOfRandomBitsCollected);
		this.setRandomBitsCollector(collectetBits);
		numberOfRandomBitsCollected += this.numberOfBitsToCollectAtEachEvent();
		
		if (numberOfRandomBitsCollected == 8) {
			this.updateGeneratorWithValue(collectetBits);
			numberOfRandomBitsCollected = 0;
			this.setRandomBitsCollector(0);
		}
		
		this.setNumberOfRandomBitsCollected(numberOfRandomBitsCollected)
	},
	
	//-------------------------------------------------------------------------

	'numberOfRandomBitsCollected': function() {
		return this._numberOfRandomBitsCollected;
	},

	'setNumberOfRandomBitsCollected': function(aValue) {
		this._numberOfRandomBitsCollected = aValue;
	},

	//-------------------------------------------------------------------------

	'collectEntropy': function(anEvent) {
		var mouseLocation;
		var randomBit;
		var mask;
		
		mask = 0xffffffff >>> (32 - this.numberOfBitsToCollectAtEachEvent());
		
		mouseLocation = anEvent.mouse().client;
		randomBit = ((mouseLocation.x ^ mouseLocation.y) & mask);
		this.appendRandomBitsToRandomBitsCollector(randomBit)
	},
	
	//-------------------------------------------------------------------------

	'numberOfRandomBits': function() {
		return 1;
	},
	
	//-------------------------------------------------------------------------

	'pollingFrequency': function() {
		return 10;
	},

	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//*****************************************************************************

Clipperz.Crypto.PRNG.KeyboardRandomnessSource = function(args) {
	args = args || {};
	Clipperz.Crypto.PRNG.RandomnessSource.call(this, args);

	this._randomBitsCollector = 0;
	this._numberOfRandomBitsCollected = 0;
	
	MochiKit.Signal.connect(document, 'onkeypress', this, 'collectEntropy');

	return this;
}

Clipperz.Crypto.PRNG.KeyboardRandomnessSource.prototype = MochiKit.Base.update(new Clipperz.Crypto.PRNG.RandomnessSource, {

	//-------------------------------------------------------------------------

	'randomBitsCollector': function() {
		return this._randomBitsCollector;
	},

	'setRandomBitsCollector': function(aValue) {
		this._randomBitsCollector = aValue;
	},

	'appendRandomBitToRandomBitsCollector': function(aValue) {
		var collectedBits;
		var numberOfRandomBitsCollected;
		
		numberOfRandomBitsCollected = this.numberOfRandomBitsCollected();
		collectetBits = this.randomBitsCollector() | (aValue << numberOfRandomBitsCollected);
		this.setRandomBitsCollector(collectetBits);
		numberOfRandomBitsCollected ++;
		
		if (numberOfRandomBitsCollected == 8) {
			this.updateGeneratorWithValue(collectetBits);
			numberOfRandomBitsCollected = 0;
			this.setRandomBitsCollector(0);
		}
		
		this.setNumberOfRandomBitsCollected(numberOfRandomBitsCollected)
	},
	
	//-------------------------------------------------------------------------

	'numberOfRandomBitsCollected': function() {
		return this._numberOfRandomBitsCollected;
	},

	'setNumberOfRandomBitsCollected': function(aValue) {
		this._numberOfRandomBitsCollected = aValue;
	},

	//-------------------------------------------------------------------------

	'collectEntropy': function(anEvent) {
/*
		var mouseLocation;
		var randomBit;
		
		mouseLocation = anEvent.mouse().client;
			
		randomBit = ((mouseLocation.x ^ mouseLocation.y) & 0x1);
		this.appendRandomBitToRandomBitsCollector(randomBit);
*/
	},
	
	//-------------------------------------------------------------------------

	'numberOfRandomBits': function() {
		return 1;
	},
	
	//-------------------------------------------------------------------------

	'pollingFrequency': function() {
		return 10;
	},

	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//#############################################################################

Clipperz.Crypto.PRNG.Fortuna = function(args) {
	var	i,c;
	
	args = args || {};

	this._key = args.seed || null;
	if (this._key == null) {
		this._counter = 0;
		this._key = new Clipperz.ByteArray();
	} else {
		this._counter = 1;
	}
	
	this._aesKey = null;
	
	this._firstPoolReseedLevel = args.firstPoolReseedLevel || 32 || 64;
	this._numberOfEntropyAccumulators = args.numberOfEntropyAccumulators || 32;
	
	this._accumulators = [];
	c = this.numberOfEntropyAccumulators();
	for (i=0; i<c; i++) {
		this._accumulators.push(new Clipperz.Crypto.PRNG.EntropyAccumulator());
	}

	this._randomnessSources = [];
	this._reseedCounter = 0;
	
	return this;
}

Clipperz.Crypto.PRNG.Fortuna.prototype = MochiKit.Base.update(null, {

	'toString': function() {
		return "Clipperz.Crypto.PRNG.Fortuna";
	},

	//-------------------------------------------------------------------------

	'key': function() {
		return this._key;
	},

	'setKey': function(aValue) {
		this._key = aValue;
		this._aesKey = null;
	},
	
	'aesKey': function() {
		if (this._aesKey == null) {
			this._aesKey = new Clipperz.Crypto.AES.Key({key:this.key()});
		}
		
		return this._aesKey;
	},
	
	'accumulators': function() {
		return this._accumulators;
	},
	
	'firstPoolReseedLevel': function() {
		return this._firstPoolReseedLevel;
	},
	
	//-------------------------------------------------------------------------

	'reseedCounter': function() {
		return this._reseedCounter;
	},

	'incrementReseedCounter': function() {
		this._reseedCounter = this._reseedCounter +1;
	},

	//-------------------------------------------------------------------------

	'reseed': function() {
		var	newKeySeed;
		var reseedCounter;
		var	reseedCounterMask;
		var i, c;
		
		newKeySeed = this.key();
		this.incrementReseedCounter();
		reseedCounter = this.reseedCounter();
		
		c = this.numberOfEntropyAccumulators();
		reseedCounterMask = 0xffffffff >>> (32 - c);
		for (i=0; i<c; i++) {
			if ((i == 0) || ((reseedCounter & (reseedCounterMask >>> (c - i))) == 0)) {
				newKeySeed.appendBlock(this.accumulators()[i].stack());
				this.accumulators()[i].resetStack();
			} 
		}
		
		if (reseedCounter == 1) {
			c = this.randomnessSources().length;
			for (i=0; i<c; i++) {
				this.randomnessSources()[i].setBoostMode(false);
			}
		}
		
		this.setKey(Clipperz.Crypto.SHA.sha_d256(newKeySeed));
		if (reseedCounter == 1) {
			MochiKit.Logging.logDebug("### PRNG.readyToGenerateRandomBytes");
			MochiKit.Signal.signal(this, 'readyToGenerateRandomBytes');
		}
		MochiKit.Signal.signal(this, 'reseeded');
	},
	
	//-------------------------------------------------------------------------

	'isReadyToGenerateRandomValues': function() {
		return this.reseedCounter() != 0;
	},
	
	//-------------------------------------------------------------------------

	'entropyLevel': function() {
		return this.accumulators()[0].stack().length() + (this.reseedCounter() * this.firstPoolReseedLevel());
	},
	
	//-------------------------------------------------------------------------

	'counter': function() {
		return this._counter;
	},
	
	'incrementCounter': function() {
		this._counter += 1;
	},
	
	'counterBlock': function() {
		var result;

		result = new Clipperz.ByteArray().appendWords(this.counter(), 0, 0, 0);
		
		return result;
	},

	//-------------------------------------------------------------------------

	'getRandomBlock': function() {
		var result;

		result = new Clipperz.ByteArray(Clipperz.Crypto.AES.encryptBlock(this.aesKey(), this.counterBlock().arrayValues()));
		this.incrementCounter();
		
		return result;
	},
	
	//-------------------------------------------------------------------------

	'getRandomBytes': function(aSize) {
		var result;

		if (this.isReadyToGenerateRandomValues()) {
			var i,c;
			var newKey;
			
			result = new Clipperz.ByteArray();
		
			c = Math.ceil(aSize / (128 / 8));
			for (i=0; i<c; i++) {
				result.appendBlock(this.getRandomBlock());
			}

			if (result.length() != aSize) {
				result = result.split(0, aSize);
			}
			
			newKey = this.getRandomBlock().appendBlock(this.getRandomBlock());
			this.setKey(newKey);
		} else {
MochiKit.Logging.logWarning("Fortuna generator has not enough entropy, yet!");
			throw Clipperz.Crypto.PRNG.exception.NotEnoughEntropy;
		}

		return result;
	},

	//-------------------------------------------------------------------------

	'addRandomByte': function(aSourceId, aPoolId, aRandomValue) {
		var	selectedAccumulator;

		selectedAccumulator = this.accumulators()[aPoolId];
		selectedAccumulator.addRandomByte(aRandomValue);

		if (aPoolId == 0) {
			MochiKit.Signal.signal(this, 'addedRandomByte')
			if (selectedAccumulator.stack().length() > this.firstPoolReseedLevel()) {
				this.reseed();
			}
		}
	},

	//-------------------------------------------------------------------------
	
	'numberOfEntropyAccumulators': function() {
		return this._numberOfEntropyAccumulators;
	},

	//-------------------------------------------------------------------------

	'randomnessSources': function() {
		return this._randomnessSources;
	},
	
	'addRandomnessSource': function(aRandomnessSource) {
		aRandomnessSource.setGenerator(this);
		aRandomnessSource.setSourceId(this.randomnessSources().length);
		this.randomnessSources().push(aRandomnessSource);
		
		if (this.isReadyToGenerateRandomValues() == false) {
			aRandomnessSource.setBoostMode(true);
		}
	},

	//-------------------------------------------------------------------------

	'deferredEntropyCollection': function(aValue) {
		var result;

//MochiKit.Logging.logDebug(">>> PRNG.deferredEntropyCollection");

		if (this.isReadyToGenerateRandomValues()) {
//MochiKit.Logging.logDebug("--- PRNG.deferredEntropyCollection - 1");
			result = aValue;
		} else {
//MochiKit.Logging.logDebug("--- PRNG.deferredEntropyCollection - 2");
			var deferredResult;

			Clipperz.NotificationCenter.notify(this, 'updatedProgressState', 'collectingEntropy', true);

			deferredResult = new MochiKit.Async.Deferred();
//			deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("1.2.1 - PRNG.deferredEntropyCollection - 1: " + res); return res;});
			deferredResult.addCallback(MochiKit.Base.partial(MochiKit.Async.succeed, aValue));
//			deferredResult.addBoth(function(res) {MochiKit.Logging.logDebug("1.2.2 - PRNG.deferredEntropyCollection - 2: " + res); return res;});
			MochiKit.Signal.connect(this,
									'readyToGenerateRandomBytes',
									deferredResult,
									'callback');
									
			result = deferredResult;
		}
//MochiKit.Logging.logDebug("<<< PRNG.deferredEntropyCollection - result: " + result);

		return result;
	},
	
	//-------------------------------------------------------------------------

	'fastEntropyAccumulationForTestingPurpose': function() {
		while (! this.isReadyToGenerateRandomValues()) {
			this.addRandomByte(Math.floor(Math.random() * 32), Math.floor(Math.random() * 32), Math.floor(Math.random() * 256));
		}
	},
	
	//-------------------------------------------------------------------------

	'dump': function(appendToDoc) {
		var tbl;
		var i,c;
		
		tbl = document.createElement("table");
		tbl.border = 0;
		with (tbl.style) {
			border = "1px solid lightgrey";
			fontFamily = 'Helvetica, Arial, sans-serif';
			fontSize = '8pt';
			//borderCollapse = "collapse";
		}
		var hdr = tbl.createTHead();
		var hdrtr = hdr.insertRow(0);
		// document.createElement("tr");
		{
			var ntd;
			
			ntd = hdrtr.insertCell(0);
			ntd.style.borderBottom = "1px solid lightgrey";
			ntd.style.borderRight = "1px solid lightgrey";
			ntd.appendChild(document.createTextNode("#"));

			ntd = hdrtr.insertCell(1);
			ntd.style.borderBottom = "1px solid lightgrey";
			ntd.style.borderRight = "1px solid lightgrey";
			ntd.appendChild(document.createTextNode("s"));

			ntd = hdrtr.insertCell(2);
			ntd.colSpan = this.firstPoolReseedLevel();
			ntd.style.borderBottom = "1px solid lightgrey";
			ntd.style.borderRight = "1px solid lightgrey";
			ntd.appendChild(document.createTextNode("base values"));
			
			ntd = hdrtr.insertCell(3);
			ntd.colSpan = 20;
			ntd.style.borderBottom = "1px solid lightgrey";
			ntd.appendChild(document.createTextNode("extra values"));

		}

		c = this.accumulators().length;
		for (i=0; i<c ; i++) {
			var	currentAccumulator;
			var bdytr;
			var bdytd;
			var ii, cc;

			currentAccumulator = this.accumulators()[i]
			
			bdytr = tbl.insertRow(true);
			
			bdytd = bdytr.insertCell(0);
			bdytd.style.borderRight = "1px solid lightgrey";
			bdytd.style.color = "lightgrey";
			bdytd.appendChild(document.createTextNode("" + i));

			bdytd = bdytr.insertCell(1);
			bdytd.style.borderRight = "1px solid lightgrey";
			bdytd.style.color = "gray";
			bdytd.appendChild(document.createTextNode("" + currentAccumulator.stack().length()));


			cc = Math.max(currentAccumulator.stack().length(), this.firstPoolReseedLevel());
			for (ii=0; ii<cc; ii++) {
				var cellText;
				
				bdytd = bdytr.insertCell(ii + 2);
				
				if (ii < currentAccumulator.stack().length()) {
					cellText = Clipperz.ByteArray.byteToHex(currentAccumulator.stack().byteAtIndex(ii));
				} else {
					cellText = "_";
				}
				
				if (ii == (this.firstPoolReseedLevel() - 1)) {
					bdytd.style.borderRight = "1px solid lightgrey";
				}
				
				bdytd.appendChild(document.createTextNode(cellText));
			}
			
		}
		

		if (appendToDoc) {
			var ne = document.createElement("div");
			ne.id = "entropyGeneratorStatus";
			with (ne.style) {
				fontFamily = "Courier New, monospace";
				fontSize = "12px";
				lineHeight = "16px";
				borderTop = "1px solid black";
				padding = "10px";
			}
			if (document.getElementById(ne.id)) {
				MochiKit.DOM.swapDOM(ne.id, ne);
			} else {
				document.body.appendChild(ne);
			}
			ne.appendChild(tbl);
		}

		return tbl;
	},

	//-----------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//#############################################################################

Clipperz.Crypto.PRNG.Random = function(args) {
	args = args || {};
//	MochiKit.Base.bindMethods(this);

	return this;
}

Clipperz.Crypto.PRNG.Random.prototype = MochiKit.Base.update(null, {

	'toString': function() {
		return "Clipperz.Crypto.PRNG.Random";
	},

	//-------------------------------------------------------------------------

	'getRandomBytes': function(aSize) {
//Clipperz.Profile.start("Clipperz.Crypto.PRNG.Random.getRandomBytes");
		var	result;
		var i,c;
		
		result = new Clipperz.ByteArray()
		c = aSize || 1;
		for (i=0; i<c; i++) {
			result.appendByte((Math.random()*255) & 0xff);
		}
		
//Clipperz.Profile.stop("Clipperz.Crypto.PRNG.Random.getRandomBytes");
		return result;
	},

	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
});

//#############################################################################

_clipperz_crypt_prng_defaultPRNG = null;

Clipperz.Crypto.PRNG.defaultRandomGenerator = function() {
	if (_clipperz_crypt_prng_defaultPRNG == null) {
		_clipperz_crypt_prng_defaultPRNG = new Clipperz.Crypto.PRNG.Fortuna();

		//.............................................................
		//
		//		TimeRandomnessSource
		//
		//.............................................................
		{
			var newRandomnessSource;
		
			newRandomnessSource = new Clipperz.Crypto.PRNG.TimeRandomnessSource({intervalTime:111});
			_clipperz_crypt_prng_defaultPRNG.addRandomnessSource(newRandomnessSource);
		}

		//.............................................................
		//
		//		MouseRandomnessSource
		//
		//.............................................................
		{
			var	newRandomnessSource;
			
			newRandomnessSource = new Clipperz.Crypto.PRNG.MouseRandomnessSource();
			_clipperz_crypt_prng_defaultPRNG.addRandomnessSource(newRandomnessSource);
		}

		//.............................................................
		//
		//		KeyboardRandomnessSource
		//
		//.............................................................
		{
			var	newRandomnessSource;
			
			newRandomnessSource = new Clipperz.Crypto.PRNG.KeyboardRandomnessSource();
			_clipperz_crypt_prng_defaultPRNG.addRandomnessSource(newRandomnessSource);
		}

	}

	return _clipperz_crypt_prng_defaultPRNG;
};

//#############################################################################

Clipperz.Crypto.PRNG.exception =  {
	NotEnoughEntropy: new MochiKit.Base.NamedError("Clipperz.Crypto.PRNG.exception.NotEnoughEntropy") 
};


MochiKit.DOM.addLoadEvent(Clipperz.Crypto.PRNG.defaultRandomGenerator);
try { if (typeof(Clipperz.ByteArray) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.PRNG depends on Clipperz.ByteArray!";
}  

if (typeof(Clipperz.Crypto) == 'undefined') { Clipperz.Crypto = {}; }
if (typeof(Clipperz.Crypto.SHA) == 'undefined') { Clipperz.Crypto.SHA = {}; }

Clipperz.Crypto.SHA.VERSION = "0.3";
Clipperz.Crypto.SHA.NAME = "Clipperz.Crypto.SHA";

MochiKit.Base.update(Clipperz.Crypto.SHA, {

	'__repr__': function () {
		return "[" + this.NAME + " " + this.VERSION + "]";
	},

	'toString': function () {
		return this.__repr__();
	},

	//-----------------------------------------------------------------------------

	'rotateRight': function(aValue, aNumberOfBits) {
//Clipperz.Profile.start("Clipperz.Crypto.SHA.rotateRight");
		var result;
		
		result = (aValue >>> aNumberOfBits) | (aValue << (32 - aNumberOfBits));
		
//Clipperz.Profile.stop("Clipperz.Crypto.SHA.rotateRight");
		return result;
	},

	'shiftRight': function(aValue, aNumberOfBits) {
//Clipperz.Profile.start("Clipperz.Crypto.SHA.shiftRight");
		var result;
		
		result = aValue >>> aNumberOfBits;
		
//Clipperz.Profile.stop("Clipperz.Crypto.SHA.shiftRight");
		return result;
	},

	//-----------------------------------------------------------------------------

	'safeAdd': function() {
//Clipperz.Profile.start("Clipperz.Crypto.SHA.safeAdd");
		var	result;
		var	i, c;
		
		result = arguments[0];
		c = arguments.length;
		for (i=1; i<c; i++) {
			var	lowerBytesSum;

			lowerBytesSum = (result & 0xffff) + (arguments[i] & 0xffff);
			result = (((result >> 16) + (arguments[i] >> 16) + (lowerBytesSum >> 16)) << 16) | (lowerBytesSum & 0xffff);
		}
		
//Clipperz.Profile.stop("Clipperz.Crypto.SHA.safeAdd");
		return result;
	},
	
	//-----------------------------------------------------------------------------

	'sha256_array': function(aValue) {
//Clipperz.Profile.start("Clipperz.Crypto.SHA.sha256_array");
		var	result;
		var	message;
		var h0, h1, h2, h3, h4, h5, h6, h7;
		var	k;
		var	messageLength;
		var	messageLengthInBits;
		var	_i, _c;
		var charBits;
		var rotateRight;
		var shiftRight;
		var safeAdd;
		var	bytesPerBlock;
		var currentMessageIndex;

		bytesPerBlock = 512/8;
		rotateRight = Clipperz.Crypto.SHA.rotateRight;
		shiftRight = Clipperz.Crypto.SHA.shiftRight;
		safeAdd = Clipperz.Crypto.SHA.safeAdd;
		
		charBits = 8;
		
		h0 = 0x6a09e667;
		h1 = 0xbb67ae85;
		h2 = 0x3c6ef372;
		h3 = 0xa54ff53a;
		h4 = 0x510e527f;
		h5 = 0x9b05688c;
		h6 = 0x1f83d9ab;
		h7 = 0x5be0cd19;

		k = [	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
				0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
				0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
				0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
				0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
				0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
				0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
				0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2];

		message = aValue;
		messageLength = message.length;

		//Pre-processing:
		message.push(0x80);	//	append a single "1" bit to  message

		_c = (512 - (((messageLength + 1) * charBits) % 512) - 64) / charBits;
		for (_i=0; _i<_c; _i++) {
			message.push(0x00);			//	append "0" bits until message length ≡ 448 ≡ -64 (mod 512)
		}
		messageLengthInBits = messageLength * charBits;
		message.push(0x00);	//	the 4 most high byte are alway 0 as message length is represented with a 32bit value;
		message.push(0x00);
		message.push(0x00);
		message.push(0x00);
		message.push((messageLengthInBits >> 24)	& 0xff);
		message.push((messageLengthInBits >> 16)	& 0xff);
		message.push((messageLengthInBits >> 8)		& 0xff);
		message.push( messageLengthInBits			& 0xff);

		currentMessageIndex = 0;
		while(currentMessageIndex < message.length) {
			var	w;
			var	a, b, c, d, e, f, g, h;

			w = Array(64);

			_c = 16;
			for (_i=0; _i<_c; _i++) {
				var _j;
				
				_j = currentMessageIndex + _i*4;
				w[_i] = (message[_j] << 24) | (message[_j + 1] << 16) | (message[_j + 2] << 8) | (message[_j + 3] << 0);
			}

			_c = 64;
			for (_i=16; _i<_c; _i++) {
				var	s0, s1;
				
				s0 = (rotateRight(w[_i-15], 7)) ^ (rotateRight(w[_i-15], 18)) ^ (shiftRight(w[_i-15], 3));
				s1 = (rotateRight(w[_i-2], 17)) ^ (rotateRight(w[_i-2], 19)) ^ (shiftRight(w[_i-2], 10));
				w[_i] = safeAdd(w[_i-16], s0, w[_i-7], s1);
			}

			a=h0; b=h1; c=h2; d=h3; e=h4; f=h5; g=h6; h=h7;

			_c = 64;
			for (_i=0; _i<_c; _i++) {
				var s0, s1, ch, maj, t1, t2;
				
				s0  = (rotateRight(a, 2)) ^ (rotateRight(a, 13)) ^ (rotateRight(a, 22));
				maj = (a & b) ^ (a & c) ^ (b & c);
				t2  = safeAdd(s0, maj);
				s1  = (rotateRight(e, 6)) ^ (rotateRight(e, 11)) ^ (rotateRight(e, 25));
				ch  = (e & f) ^ ((~e) & g);
				t1  = safeAdd(h, s1, ch, k[_i], w[_i]);

				h = g;
				g = f;
				f = e;
				e = safeAdd(d, t1);
				d = c;
				c = b;
				b = a;
				a = safeAdd(t1, t2);
			}

		    h0 = safeAdd(h0, a);
		    h1 = safeAdd(h1, b);
		    h2 = safeAdd(h2, c);
		    h3 = safeAdd(h3, d);
		    h4 = safeAdd(h4, e);
		    h5 = safeAdd(h5, f);
		    h6 = safeAdd(h6, g);
		    h7 = safeAdd(h7, h);
			
			currentMessageIndex += bytesPerBlock;
		}

		result = new Array(256/8);
		result[0]  = (h0 >> 24)	& 0xff;
		result[1]  = (h0 >> 16)	& 0xff;
		result[2]  = (h0 >> 8)	& 0xff;
		result[3]  =  h0		& 0xff;

		result[4]  = (h1 >> 24)	& 0xff;
		result[5]  = (h1 >> 16)	& 0xff;
		result[6]  = (h1 >> 8)	& 0xff;
		result[7]  =  h1		& 0xff;

		result[8]  = (h2 >> 24)	& 0xff;
		result[9]  = (h2 >> 16)	& 0xff;
		result[10] = (h2 >> 8)	& 0xff;
		result[11] =  h2		& 0xff;
		
		result[12] = (h3 >> 24)	& 0xff;
		result[13] = (h3 >> 16)	& 0xff;
		result[14] = (h3 >> 8)	& 0xff;
		result[15] =  h3		& 0xff;

		result[16] = (h4 >> 24)	& 0xff;
		result[17] = (h4 >> 16)	& 0xff;
		result[18] = (h4 >> 8)	& 0xff;
		result[19] =  h4		& 0xff;

		result[20] = (h5 >> 24)	& 0xff;
		result[21] = (h5 >> 16)	& 0xff;
		result[22] = (h5 >> 8)	& 0xff;
		result[23] =  h5	 	& 0xff;

		result[24] = (h6 >> 24)	& 0xff;
		result[25] = (h6 >> 16)	& 0xff;
		result[26] = (h6 >> 8)	& 0xff;
		result[27] =  h6		& 0xff;
			
		result[28] = (h7 >> 24)	& 0xff;
		result[29] = (h7 >> 16)	& 0xff;
		result[30] = (h7 >> 8)	& 0xff;
		result[31] =  h7		& 0xff;
		
//Clipperz.Profile.stop("Clipperz.Crypto.SHA.sha256_array");
		return result;
	},

	//-----------------------------------------------------------------------------

	'sha256': function(aValue) {
//Clipperz.Profile.start("Clipperz.Crypto.SHA.sha256");
		var result;
		var resultArray;
		var	valueArray;
		
		valueArray = aValue.arrayValues();
		resultArray = Clipperz.Crypto.SHA.sha256_array(valueArray);
		
		result = new Clipperz.ByteArray(resultArray);
		
//Clipperz.Profile.stop("Clipperz.Crypto.SHA.sha256");
		return result;
	},
	
	//-----------------------------------------------------------------------------

	'sha_d256': function(aValue) {
//Clipperz.Profile.start("Clipperz.Crypto.SHA.sha_d256");
		var result;
		var resultArray;
		var	valueArray;
		
		valueArray = aValue.arrayValues();
		resultArray = Clipperz.Crypto.SHA.sha256_array(valueArray);
		resultArray = Clipperz.Crypto.SHA.sha256_array(resultArray);
		
		result = new Clipperz.ByteArray(resultArray);
		
//Clipperz.Profile.stop("Clipperz.Crypto.SHA.sha256");
		return result;
	},
	
	//-----------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"
	
});
try { if (typeof(Clipperz.ByteArray) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.PRNG depends on Clipperz.ByteArray!";
}  

try { if (typeof(Clipperz.Crypto.BigInt) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.SRP depends on Clipperz.Crypto.BigInt!";
}  

try { if (typeof(Clipperz.Crypto.PRNG) == 'undefined') { throw ""; }} catch (e) {
	throw "Clipperz.Crypto.SRP depends on Clipperz.Crypto.PRNG!";
}  

if (typeof(Clipperz.Crypto.SRP) == 'undefined') { Clipperz.Crypto.SRP = {}; }

Clipperz.Crypto.SRP.VERSION = "0.1";
Clipperz.Crypto.SRP.NAME = "Clipperz.Crypto.SRP";

//#############################################################################

MochiKit.Base.update(Clipperz.Crypto.SRP, {

	'_n': null,
	'_g': null,
	//-------------------------------------------------------------------------

	'n': function() {
		if (Clipperz.Crypto.SRP._n == null) {
		 	Clipperz.Crypto.SRP._n = new Clipperz.Crypto.BigInt("115b8b692e0e045692cf280b436735c77a5a9e8a9e7ed56c965f87db5b2a2ece3", 16);
		}
		
		return Clipperz.Crypto.SRP._n;
	},

	//-------------------------------------------------------------------------

	'g': function() {
		if (Clipperz.Crypto.SRP._g == null) {
			Clipperz.Crypto.SRP._g = new Clipperz.Crypto.BigInt(2);	//	eventually 5 (as suggested on the Diffi-Helmann documentation)
		}
		
		return Clipperz.Crypto.SRP._g;
	},

	//-----------------------------------------------------------------------------

	'exception': {
		'InvalidValue': new MochiKit.Base.NamedError("Clipperz.Crypto.SRP.exception.InvalidValue") 
	},

	//-------------------------------------------------------------------------
	__syntaxFix__: "syntax fix"

});

//#############################################################################
//
//		S R P   C o n n e c t i o n     version 1.0
//
//=============================================================================
Clipperz.Crypto.SRP.Connection = function (args) {
	args = args || {};

	this._C = args.C;
	this._P = args.P;
	this.hash = args.hash;

	this._a = null;
	this._A = null;
	
	this._s = null;
	this._B = null;

	this._x = null;
	
	this._u = null;
	this._K = null;
	this._M1 = null;
	this._M2 = null;
	
	this._sessionKey = null;

	return this;
}

Clipperz.Crypto.SRP.Connection.prototype = MochiKit.Base.update(null, {

	'toString': function () {
		return "Clipperz.Crypto.SRP.Connection (username: " + this.username() + "). Status: " + this.statusDescription();
	},

	//-------------------------------------------------------------------------

	'C': function () {
		return this._C;
	},

	//-------------------------------------------------------------------------

	'P': function () {
		return this._P;
	},

	//-------------------------------------------------------------------------

	'a': function () {
		if (this._a == null) {
			this._a = new Clipperz.Crypto.BigInt(Clipperz.Crypto.PRNG.defaultRandomGenerator().getRandomBytes(32).toHexString().substring(2), 16);
//			this._a = new Clipperz.Crypto.BigInt("37532428169486597638072888476611365392249575518156687476805936694442691012367", 10);
//MochiKit.Logging.logDebug("SRP a: " + this._a);
		}
		
		return this._a;
	},

	//-------------------------------------------------------------------------

	'A': function () {
		if (this._A == null) {
			//	Warning: this value should be strictly greater than zero: how should we perform this check?
			this._A = Clipperz.Crypto.SRP.g().powerModule(this.a(), Clipperz.Crypto.SRP.n());
			
			if (this._A.equals(0)) {
MochiKit.Logging.logError("Clipperz.Crypto.SRP.Connection: trying to set 'A' to 0.");
				throw Clipperz.Crypto.SRP.exception.InvalidValue;
			}
//MochiKit.Logging.logDebug("SRP A: " + this._A);
		}
		
		return this._A;
	},

	//-------------------------------------------------------------------------

	's': function () {
		return this._s;
//MochiKit.Logging.logDebug("SRP s: " + this._S);
	},

	'set_s': function(aValue) {
		this._s = aValue;
	},
	
	//-------------------------------------------------------------------------

	'B': function () {
		return this._B;
	},

	'set_B': function(aValue) {
		//	Warning: this value should be strictly greater than zero: how should we perform this check?
		if (! aValue.equals(0)) {
			this._B = aValue;
//MochiKit.Logging.logDebug("SRP B: " + this._B);
		} else {
MochiKit.Logging.logError("Clipperz.Crypto.SRP.Connection: trying to set 'B' to 0.");
			throw Clipperz.Crypto.SRP.exception.InvalidValue;
		}
	},
	
	//-------------------------------------------------------------------------

	'x': function () {
		if (this._x == null) {
			this._x = new Clipperz.Crypto.BigInt(this.stringHash(this.s().asString(16, 64) + this.P()), 16);
//MochiKit.Logging.logDebug("SRP x: " + this._x);
		}
		
		return this._x;
	},

	//-------------------------------------------------------------------------

	'u': function () {
		if (this._u == null) {
			this._u = new Clipperz.Crypto.BigInt(this.stringHash(this.B().asString()), 16);
//MochiKit.Logging.logDebug("SRP u: " + this._u);
		}
		
		return this._u;
	},

	//-------------------------------------------------------------------------

	'S': function () {
		if (this._S == null) {
			var bigint;
			var	srp;

			bigint = Clipperz.Crypto.BigInt;
			srp = 	 Clipperz.Crypto.SRP;

			this._S =	bigint.powerModule(
								bigint.subtract(this.B(), bigint.powerModule(srp.g(), this.x(), srp.n())),
								bigint.add(this.a(), bigint.multiply(this.u(), this.x())),
								srp.n()
						)
//MochiKit.Logging.logDebug("SRP S: " + this._S);
		}
		
		return this._S;
	},

	//-------------------------------------------------------------------------

	'K': function () {
		if (this._K == null) {
			this._K = this.stringHash(this.S().asString());
//MochiKit.Logging.logDebug("SRP K: " + this._K);
		}
		
		return this._K;
	},

	//-------------------------------------------------------------------------

	'M1': function () {
		if (this._M1 == null) {
			this._M1 = this.stringHash(this.A().asString(10) + this.B().asString(10) + this.K());
//MochiKit.Logging.logDebug("SRP M1: " + this._M1);
		}
		
		return this._M1;
	},

	//-------------------------------------------------------------------------

	'M2': function () {
		if (this._M2 == null) {
			this._M2 = this.stringHash(this.A().asString(10) + this.M1() + this.K());
//MochiKit.Logging.logDebug("SRP M2: " + this._M2);
		}
		
		return this._M2;
	},

	//=========================================================================

	'serverSideCredentialsWithSalt': function(aSalt) {
		var result;
		var s, x, v;
		
		s = aSalt;
		x = this.stringHash(s + this.P());
		v = Clipperz.Crypto.SRP.g().powerModule(new Clipperz.Crypto.BigInt(x, 16), Clipperz.Crypto.SRP.n());

		result = {};
		result['C'] = this.C();
		result['s'] = s;
		result['v'] = v.asString(16);
		
		return result;
	},
	
	'serverSideCredentials': function() {
		var result;
		var s;
		
		s = Clipperz.Crypto.PRNG.defaultRandomGenerator().getRandomBytes(32).toHexString().substring(2);

		result = this.serverSideCredentialsWithSalt(s);
		
		return result;
	},
	
	//=========================================================================
/*
	'computeServerSide_S': function(b) {
		var result;
		var v;
		var bigint;
		var	srp;

		bigint = Clipperz.Crypto.BigInt;
		srp = 	 Clipperz.Crypto.SRP;

		v = new Clipperz.Crypto.BigInt(srpConnection.serverSideCredentialsWithSalt(this.s().asString(16, 64)).v, 16);
//		_S =  (this.A().multiply(this.v().modPow(this.u(), this.n()))).modPow(this.b(), this.n());
		result = bigint.powerModule(
					bigint.multiply(
						this.A(),
						bigint.powerModule(v, this.u(), srp.n())
					), new Clipperz.Crypto.BigInt(b, 10), srp.n()
				);

		return result;
	},
*/
	//=========================================================================

	'stringHash': function(aValue) {
		var	result;

		result = this.hash(new Clipperz.ByteArray(aValue)).toHexString().substring(2);
		
		return result;
	},
	
	//=========================================================================
	__syntaxFix__: "syntax fix"
	
});

//#############################################################################
