# Gets added by gulp build.
# base64 = require 'base64binary'

uint8ArrayToInt = (arr) ->
	len = arr.length
	return 0 if len == 0

	return arr[len-1] + (uint8ArrayToInt(arr[...len-1]) << 8)

validate = (key) ->
	# See http://crypto.stackexchange.com/a/5948.
	key = key.replace(/\r?\n/g, '')
	key = /AAAAB3NzaC1yc2E[A-Za-z0-9+\/=]+/.exec(key)?[0]

	if !key?
		return 'missing header'

	arr = base64binary.decode(key)

	secondLength = uint8ArrayToInt(arr[11..14])
	lengthSoFar = 4 + 7 + 4 + secondLength
	thirdLength = uint8ArrayToInt(arr[lengthSoFar..lengthSoFar+3])
	lengthSoFar += 4 + thirdLength

	if lengthSoFar != arr.length
		return 'invalid key length'

	return true
