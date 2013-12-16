/*
 Find plugins at https://npmjs.org/browse/keyword/gulpplugin
 */
var gulp = require('gulp');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');

gulp.task('build', function() {
    var sink = concat("main.js");

    gulp.src('lib/base64-binary.js')
        .pipe(sink, {end: false});

    gulp.src('src/validateSSH.coffee')
        .pipe(coffee({bare: true}))
        .pipe(sink);

    sink.pipe(gulp.dest('./dist/'));
});

// The default task (called when you run `gulp`)
gulp.task('default', function() {
    gulp.run('build');

    // Watch files and run tasks if they change
    gulp.watch([
        'lib/base64-binary.js',
        'src/validateSSH.coffee'
    ], function(event) {
        gulp.run('build');
    });
});