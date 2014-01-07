uint8ArrayToInt = (arr) ->
	len = arr.length
	return 0 if len == 0

	return arr[len-1] + (uint8ArrayToInt(arr[...len-1]) << 8)

uint8ArrayToString = (arr) ->
	(String.fromCharCode(i) for i in arr).join('')

validate = (key) ->
	# See http://crypto.stackexchange.com/a/5948.
	key = key.replace(/\r?\n/g, '')
	key = /AAAAB3NzaC1yc2E[A-Za-z0-9+\/]+/.exec(key)?[0]

	if !key?
		return 'missing header'


	secondLength = uint8ArrayToInt(uint8Array[11..14])
	lengthSoFar = 4 + 7 + 4 + secondLength
	thirdLength = uint8ArrayToInt(uint8Array[lengthSoFar..lengthSoFar+3])
	lengthSoFar += 4 + thirdLength

	if lengthSoFar != uint8Array.length
		return 'invalid key length'

	return true
