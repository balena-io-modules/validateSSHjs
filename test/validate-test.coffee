assert = require 'assert'
validator = require '../dist/main'

validKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJr5NXKYoyFryOzCZ8tTknPV7dtAGJWJ3PmvUvRdY+4ECgWqwHpTbGD5BthPZQA
fh51twyejF+F6JdbZAGeDFsmlST1AJICIcC3UoHM9A9sB3gJ+xmO7nYSFBmy4tDTdbhP1rzsqpoLIFy2D1rLG5T4qoV5RrFmLkS59
5cZjWQTlv1SFThNKY8ELxQm7k7pkbYhDqXK6LF+6tHkkTO0nL/zR9uY6dWU1EabvSRcMS66RTYX2r2Zaiy5NGMTF3RI+HbN45drvS
TysxTohpCKDPnmVbjCI0BhLNHqleUAPtqgfU2Ld+lU1Z5ZSFoq1PIPJB52nEmyEhqdXnLm2gi0LjH'

describe 'validate function', ->
	it 'Should correctly validate generated keys', ->
		assert.equal(validator.validate(validKey), true)
