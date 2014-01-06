gulp = require 'gulp'

coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
gutil = require 'gulp-util'
uglify = require 'gulp-uglify'
wrap = require 'gulp-wrap-umd'

gulp.task 'caffeinate', ->
	gulp.src('src/*.coffee')
		.pipe(coffee(bare: true)).on('error', gutil.log)
		.pipe(gulp.dest('./tmp/build'))

	gulp.src('test/*.coffee')
		.pipe(coffee()).on('error', gutil.log)
		.pipe(gulp.dest('./tmp'))

gulp.task 'build', [ 'caffeinate' ], ->
	gulp.src([ 'lib/*.js', 'tmp/build/*.js' ])
		.pipe(concat('main.js'))
		.pipe(wrap
			exports: 'validateOpenSSHKey'
		)
		.pipe(uglify())
		.pipe(gulp.dest('./dist/'))

gulp.task 'default', ->
	gulp.run 'build'

	gulp.watch [
		'lib/base64-binary.js',
		'src/validateSSH.coffee'
	], (event) ->
		gulp.run 'build'
