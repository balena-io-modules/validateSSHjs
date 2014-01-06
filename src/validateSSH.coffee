# The MIT License (MIT)
#
# Copyright (c) 2013, 2014 resin.io
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

uint8ArrayToInt = (arr) ->
	len = arr.length
	return 0 if len == 0

	return arr[len-1] + (uint8ArrayToInt(arr[...len-1]) << 8)

uint8ArrayToString = (uintArray) ->
	(String.fromCharCode(i) for i in uintArray).join('')

validateOpenSSHKey = (key) ->
	key = key.replace('\n', '').split(' ')

	if key.length < 2 or key.length > 3
		return 'invalid key structure'

	if key[0] != 'ssh-rsa'
		return "invalid key type: #{key[0]}"

	uint8Array = base64binary.decode(key[1])

	if uint8ArrayToInt(uint8Array[...4]) != 7
		return 'invalid key type length'

	type = uint8ArrayToString(uint8Array[4..10])
	if type != 'ssh-rsa'
		return "invalid key type: #{type}"

	secondLength = uint8ArrayToInt(uint8Array[11..14])
	lengthSoFar = 4 + 7 + 4 + secondLength
	thirdLength = uint8ArrayToInt(uint8Array[lengthSoFar..lengthSoFar+3])
	lengthSoFar += 4 + thirdLength

	if lengthSoFar != uint8Array.length
		return 'invalid key length'

	return true
