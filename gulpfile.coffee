# Find plugins at https://npmjs.org/browse/keyword/gulpplugin
gulp = require 'gulp'

coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
gutil = require 'gulp-util'
uglify = require 'gulp-uglify'
wrap = require 'gulp-wrap-umd'

gulp.task 'build', ->
	sink = concat('main.js')

	gulp.src('lib/base64-binary.js')
		.pipe(sink, end: false)

	gulp.src('src/validateSSH.coffee')
		.pipe(coffee(bare: true)).on('error', gutil.log)
		.pipe(sink)

	sink
		.pipe(wrap
			exports: 'validateOpenSSHKey'
		)
		.pipe(uglify())
		.pipe(gulp.dest('./dist/'))

# The default task (called when you run `gulp`)
gulp.task 'default', ->
	gulp.run 'build'

	# Watch files and run tasks if they change
	gulp.watch [
		'lib/base64-binary.js',
		'src/validateSSH.coffee'
	], (event) ->
		gulp.run 'build'

