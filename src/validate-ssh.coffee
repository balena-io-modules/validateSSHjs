# Gets added by gulp build.
# base64 = require 'base64binary'

uint8ArrayToInt = (arr) ->
	len = arr.length
	return 0 if len == 0

	return arr[len-1] + (uint8ArrayToInt(arr.subarray(0, len-1)) << 8)


extract = (key) ->
	return null if typeof key != 'string'

	# See http://crypto.stackexchange.com/a/5948.
	ret = key.replace(/\r?\n/g, '')
	ret = /AAAAB3NzaC1yc2E[A-Za-z0-9+\/=]+/.exec(ret)?[0]

	return ret

validate = (key) ->
	key = extract(key)

	if !key?
		return 'Missing header.'

	arr = base64binary.decode(key)

	secondLength = uint8ArrayToInt(arr.subarray(11, 15))
	lengthSoFar = 4 + 7 + 4 + secondLength
	thirdLength = uint8ArrayToInt(arr.subarray(lengthSoFar, lengthSoFar+4))
	lengthSoFar += 4 + thirdLength

	if lengthSoFar != arr.length
		return 'Invalid key length.'

	return true

exposed = { extract, validate }
