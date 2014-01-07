uint8ArrayToInt = (arr) ->
	len = arr.length
	return 0 if len == 0

	return arr[len-1] + (uint8ArrayToInt(arr[...len-1]) << 8)

uint8ArrayToString = (uintArray) ->
	(String.fromCharCode(i) for i in uintArray).join('')

validate = (key) ->
	# See http://crypto.stackexchange.com/a/5948.
	key = key.replace(/\r?\n/g, '')
	key = /AAAAB3NzaC1yc2E[A-Za-z0-9+\/]+/.exec(key)?[0]

	if !key?
		return 'missing header'

	uint8Array = base64binary.decode(key)

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
