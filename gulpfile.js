var gulp = require('gulp');

var gutil = require('gulp-util');

var plumber = require('gulp-plumber');

var purescript = require('gulp-purescript');

var del = require('del');

var sequence = require('run-sequence');

var config = {
  src: [
    'bower_components/purescript-*/src/**/*.purs',
    'src/**/*.purs'
  ],
  ffi: [
    'bower_components/purescript-*/src/**/*.js',
    'src/**/*.js'
  ],
  examples: 'examples/**/*.purs',
  examplesFFI: 'examples/**/*.js',
  dest: 'build',
  docs: 'README.md',
  options: {
    main: 'Example.Main'
  }
};

function error(e) {
  gutil.log(gutil.colors.magenta('>>>> Error <<<<') + '\n' + e.toString().trim());
  this.emit('end');
}

gulp.task('clean', function(cb){
  del(config.dest, cb);
});

gulp.task('make', function(){
  return purescript.psc({
    src: config.src,
    ffi: config.ffi,
    output: config.dest
  });
});

gulp.task('make:examples', function(){
  return purescript.psc({
    src: [config.examples].concat(config.src),
    ffi: [config.examplesFFI].concat(config.ffi),
    output: config.dest
  });
});

gulp.task('bundle:examples', function(){
  return purescript.pscBundle({
    src: config.dest + '/**/*.js',
    main: config.options.main,
    output: 'bundle.js'
  });
});

gulp.task('psci', function(){
  return purescript.psci({
    src: config.src,
    ffi: config.ffi
  }).pipe(gulp.dest('.'));
});

gulp.task('docs', function(){
  return purescript.pscDocs({
    src: config.src,
    docgen: {
      'Data.Options': config.docs
    }
  });
});

gulp.task('watch', function(cb){
  gulp.watch(config.src, ['make']);
});

gulp.task('watch:examples', function(cb){
  gulp.watch([ config.src
             , config.examples ], ['examples']);
});

gulp.task('examples', function(){
  sequence('make:examples', 'bundle:examples');
});

gulp.task('default', function(){
  sequence('clean', 'make', ['psci', 'docs']);
});
