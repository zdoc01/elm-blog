var gulp = require('gulp'),
    elm = require('gulp-elm'),
    gutil = require('gulp-util'),
    plumber = require('gulp-plumber'), // replaces pipe method and removes standard onerror handler on error event, which unpipes streams on error by default
    connect = require('gulp-connect');

var paths = {
  dest: 'dist',
  elm: 'src/*.elm',
  static: 'src/*.{html,css}'
};

gulp.task('elm-init', elm.init);

// Compile Elm to HTML
gulp.task('elm', ['elm-init'], function() {
  return gulp.src(paths.elm)
             .pipe(plumber())
             .pipe(elm())
             .pipe(gulp.dest(paths.dest));
});

// Move static assets to dist
gulp.task('static', function() {
  return gulp.src(paths.static)
             .pipe(plumber())
             .pipe(gulp.dest(paths.dest));
});

// Watch for changes and Compile
gulp.task('watch', function() {
  gulp.watch(paths.elm, ['elm']);
  gulp.watch(paths.static, ['static']);
});

// local server
gulp.task('connect', function() {
  connect.server({
    root: 'dist',
    port: 3000
  });
});

gulp.task('build', ['elm', 'static']);
gulp.task('default', ['connect', 'build', 'watch']);
