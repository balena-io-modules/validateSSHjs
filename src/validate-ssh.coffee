# Gets added by gulp build.
# base64 = require 'base64binary'

uint8ArrayToInt = (arr) ->
	len = arr.length
	return 0 if len == 0

	return arr[len-1] + (uint8ArrayToInt(arr.subarray(0, len-1)) << 8)

# Classify as RSA or DSA and extract the key.
classify = (key) ->
	# See http://crypto.stackexchange.com/a/5948. We also allow DSA.

	return null if typeof key != 'string'

	# Remove unix/windows linebreaks.
	key = key.replace(/\r?\n/g, '')

	# RSA/DSA.
	matches = /AAAAB3NzaC1(yc2E|kc3M)[A-Za-z0-9+\/=]+/.exec(key)

	return null if !matches?

	key = matches[0]

	switch matches[1]
		when 'yc2E' then { type: 'rsa', key }
		when 'kc3M' then { type: 'dsa', key }
		else throw new Error('Unrecognised type.')

extract = (key) ->
	# TODO: Reduce duplcate work.
	return classify(key)?.key

validate = (key) ->
	{ type, key } = classify(key)

	if !key?
		return 'Missing header.'

	# TODO: The below code only handles, RSA, we have only the header check for DSA.
	return true if type == 'dsa'

	arr = base64binary.decode(key)

	secondLength = uint8ArrayToInt(arr.subarray(11, 15))
	lengthSoFar = 4 + 7 + 4 + secondLength
	thirdLength = uint8ArrayToInt(arr.subarray(lengthSoFar, lengthSoFar+4))
	lengthSoFar += 4 + thirdLength

	if lengthSoFar != arr.length
		return 'Invalid key length.'

	return true

exposed = { classify, extract, validate }
