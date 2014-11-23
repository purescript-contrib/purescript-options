var gulp = require('gulp')
  , gutil = require('gulp-util')
  , plumber = require('gulp-plumber')
  , purescript = require('gulp-purescript')
  , rimraf = require('rimraf')
  , sequence = require('run-sequence')
  , config = {
      clean: 'dist',
      purescript: {
        src: [
          'bower_components/purescript-*/src/**/*.purs*',
          'src/**/*.purs'
        ],
        examples: 'examples/**/*.purs',
        dest: 'dist',
        docgen: 'MODULE.md',
        options: {
          main: 'Main'
        }
      }
    }
;

function error(e) {
  gutil.log(gutil.colors.magenta('>>>> Error <<<<') + '\n' + e.toString().trim());
  this.emit('end');
}

gulp.task('clean', function(cb){
  rimraf(config.clean, cb);
});

gulp.task('examples', function(){
  return (
    gulp.src([config.purescript.examples].concat(config.purescript.src)).
    pipe(plumber()).
    pipe(purescript.psc(config.purescript.options)).
    on('error', error).
    pipe(gulp.dest(config.purescript.dest))
  );
});

gulp.task('make', function(){
  return (
    gulp.src(config.purescript.src).
    pipe(plumber()).
    pipe(purescript.pscMake({output: config.purescript.dest})).
    on('error', error)
  );
});

gulp.task('psci', function(){
  return (
    gulp.src(config.purescript.src).
    pipe(plumber()).
    pipe(purescript.dotPsci()).
    on('error', error)
  );
});

gulp.task('docgen', function(){
  return (
    gulp.src(config.purescript.src[1]).
    pipe(plumber()).
    pipe(purescript.docgen()).
    on('error', error).
    pipe(gulp.dest(config.purescript.docgen))
  );
});

gulp.task('watch', function(cb){
  gulp.watch(config.purescript.src, ['make']);
});

gulp.task('watch.examples', function(cb){
  gulp.watch([ config.purescript.src
             , config.purescript.examples ], ['examples']);
});

gulp.task('default', function(){
  sequence('clean', 'make', ['psci', 'docgen']);
});
