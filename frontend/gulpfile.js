'use strict';

var gulp = require('gulp');
var watch = require('gulp-watch');
var browserSync = require('browser-sync');
var reload = browserSync.reload;
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer');
var stylus = require('gulp-stylus');
var browserify = require('browserify');
var watchify = require('watchify');
var source = require('vinyl-source-stream');
var sourcemaps = require('gulp-sourcemaps');
var buffer = require('vinyl-buffer');
var gutil = require('gulp-util');
var assign = require('lodash.assign');
var csso = require('gulp-csso');
var concat = require('gulp-concat');
var imagemin = require('gulp-imagemin');
var pngquant = require('imagemin-pngquant');
var eslint = require('gulp-eslint');
var stylint = require('gulp-stylint');
var stringify = require('stringify');
var babel = require('babelify');
var es2015 = require('babel-preset-es2015');

var path = {
  build: {
    html: '../public/',
    js: '../public/js',
    style: '../public/css',
    img: '../public/img'
  },
  src: {
    html: 'src/*.html',
    js: 'src/app.js',
    style: 'src/main.styl',
    img: 'src/components/images/**/*'
  },
  watch: {
    html: 'src/**/*.html',
    js: 'src/js/**/*.js',
    style: 'src/**/*.styl',
    img: 'src/components/images/**/*'
  }
};

var config = {
  server: {
    baseDir: './build'
  },
  host: 'localhost',
  port: 9000,
  logPrefix: 'foodHub'
};

var customOpts = {
  entries: path.src.js,
  debug: true
};

var opts = assign({transform : ['stringify']}, watchify.args, customOpts);
var b = watchify(browserify(opts).transform(babel, {presets: [es2015]}));

gulp.task('webserver', function() {
  browserSync(config);
});

gulp.task('eslint', function () {
  return gulp.src(['src/**/*.js'])
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(eslint.failAfterError());
});

gulp.task('styluslint', function () {
  return gulp.src('src/**/*.styl')
    .pipe(stylint({config: '.stylintrc'}))
    .pipe(stylint.reporter());
});

gulp.task('html:build', function() {
  return gulp.src(path.src.html)
    .pipe(gulp.dest(path.build.html))
    .pipe(reload({
      stream: true
    }));
});

gulp.task('js:build', bundle);

b.on('update', bundle);
b.on('log', gutil.log);

function bundle() {
  return b.bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source('bundle.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(path.build.js));
}

gulp.task('style:build', function() {
  return gulp.src(path.src.style)
    .pipe(stylus({
      'include css': true
    }))
    .pipe(csso())
    .pipe(postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ]))
    .pipe(gulp.dest(path.build.style))
    .pipe(reload({
      stream: true
    }));
});

gulp.task('image:build', function() {
  return gulp.src(path.src.img)
    .pipe(imagemin({
      progressive: true,
      svgoPlugins: [{
        removeViewBox: false
      }],
      use: [pngquant()],
      interlaced: true
    }))
    .pipe(gulp.dest(path.build.img))
    .pipe(reload({
      stream: true
    }));
});

gulp.task('build', [
  'html:build',
  'js:build',
  'style:build',
  //'image:build'
  // 'lint'
], function () {
  process.exit(0);
});

gulp.task('watch', function() {
  watch([path.watch.html], function(event, cb) {
    gulp.start('html:build');
  });
  watch([path.watch.style], function(event, cb) {
    gulp.start('style:build');
  });
  watch([path.watch.img], function(event, cb) {
    gulp.start('image:build');
  });
});

gulp.task('default', ['build', 'webserver', 'watch']);
gulp.task('lint', ['styluslint', 'eslint']);
