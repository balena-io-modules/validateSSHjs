/*
Copyright (c) 2011, Daniel Guerrero
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL DANIEL GUERRERO BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Uses the new array typed in javascript to binary base64 encode/decode
 * at the moment just decodes a binary base64 encoded
 * into either an ArrayBuffer (decodeArrayBuffer)
 * or into an Uint8Array (decode)
 * 
 * References:
 * https://developer.mozilla.org/en/JavaScript_typed_arrays/ArrayBuffer
 * https://developer.mozilla.org/en/JavaScript_typed_arrays/Uint8Array
 */

var base64binary = {
	_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
	
	/* will return a  Uint8Array type */
	decodeArrayBuffer: function(input) {
		var bytes = (input.length/4) * 3;
		var ab = new ArrayBuffer(bytes);
		this.decode(input, ab);
		
		return ab;
	},
	
	decode: function(input, arrayBuffer) {
		//get last chars to see if are valid
		var lkey1 = this._keyStr.indexOf(input.charAt(input.length-1));		 
		var lkey2 = this._keyStr.indexOf(input.charAt(input.length-2));		 
	
		var bytes = (input.length/4) * 3;
		if (lkey1 == 64) bytes--; //padding chars, so skip
		if (lkey2 == 64) bytes--; //padding chars, so skip
		
		var uarray;
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;
		var j = 0;
		
		if (arrayBuffer)
			uarray = new Uint8Array(arrayBuffer);
		else
			uarray = new Uint8Array(bytes);
		
		input = input.replace(/[^A-Za-z0-9\+\/=]/g, "");
		
		for (i=0; i<bytes; i+=3) {	
			//get the 3 octects in 4 ascii chars
			enc1 = this._keyStr.indexOf(input.charAt(j++));
			enc2 = this._keyStr.indexOf(input.charAt(j++));
			enc3 = this._keyStr.indexOf(input.charAt(j++));
			enc4 = this._keyStr.indexOf(input.charAt(j++));
	
			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;
	
			uarray[i] = chr1;			
			if (enc3 != 64) uarray[i+1] = chr2;
			if (enc4 != 64) uarray[i+2] = chr3;
		}
	
		return uarray;	
	}
};

var input, uint8ArrayToInt, uint8ArrayToString, validateOpenSSHKey;

uint8ArrayToInt = function(uintArray) {
  var len;
  if (uintArray.length > 0) {
    len = uintArray.length;
    return uintArray[len - 1] + (uint8ArrayToInt(uintArray.slice(0, len - 1)) << 8);
  } else {
    return 0;
  }
};

uint8ArrayToString = function(uintArray) {
  var i;
  return ((function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = uintArray.length; _i < _len; _i++) {
      i = uintArray[_i];
      _results.push(String.fromCharCode(i));
    }
    return _results;
  })()).join('');
};

validateOpenSSHKey = function(key) {
  var lengthSoFar, secondLength, thirdLength, uint8Array, _ref;
  key = key.replace("\n", "").split(" ");
  if ((2 <= (_ref = key.length) && _ref <= 3)) {
    if (key[0] === "ssh-rsa") {
      uint8Array = base64binary.decode(key[1]);
      if (uint8ArrayToInt(uint8Array.slice(0, 4)) === 7) {
        if (uint8ArrayToString(uint8Array.slice(4, 11)) === "ssh-rsa") {
          secondLength = uint8ArrayToInt(uint8Array.slice(11, 15));
          lengthSoFar = 4 + 7 + 4 + secondLength;
          thirdLength = uint8ArrayToInt(uint8Array.slice(lengthSoFar, lengthSoFar + 4));
          lengthSoFar += 4 + thirdLength;
          if (lengthSoFar === uint8Array.length) {
            return true;
          } else {
            return "invalid key length";
          }
        } else {
          return "invalid key type: " + (uint8ArrayToString(uint8Array.slice(4, 11)));
        }
      } else {
        return "invalid key type length";
      }
    } else {
      return "invalid key type: " + key[0];
    }
  } else {
    return "invalid key structure";
  }
};

input = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDItBls3aRTbVzfpBlRLdDCn8tErUuhBafqfu6mWoBalyo5+DcpTIWKP29RXNJw6tmPPAkUbWP6+I6MD9+ki1TWizIw9e8if6yhuEkBuTE8Lwimy00NkzrUgXBicdbQL8lwusEdF+CSSQ7/SOrnkThVObUO0ZL9oVWDUNdzWX9IUu16Uwq9ZtdXcQqFCnYDvYgdFUlUMKfe9jNEexQRBgnU4BjX89CNjgMhQ1i637QiVPKLHnLTd8u2b5V9f+UV9NYSfn37vcUGeNkFXauvMmpv5CY2ZxuCN873UUmvCTGmyH3n7KvfVxcBlz8QgI9cW77SzAqnh5TEU7hkGTLlW8hP petrosagg@rachmaninoff";

console.log(validateOpenSSHKey(input));
