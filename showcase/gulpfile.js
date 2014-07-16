// ==========================================================================
// Gulpfile.JS
// ==========================================================================

// -------------------------------------
// Include Gulp and plug-ins
// -------------------------------------

var gulp =          require( 'gulp'),
    gutil =         require( 'gulp-util' );

var include =       require( 'gulp-include' ),
    concat =        require( 'gulp-concat' ),
    rename =        require( 'gulp-rename' ),
    //htmlReplace =   require( 'gulp-html-replace' ),
    //minifyHtml =    require( 'gulp-minify-html' ),
    less =          require( 'gulp-less' ),
    // sass =          require( 'gulp-sass' ),
    autoPrefixer =  require( 'gulp-autoprefixer' ),
    minifyCss =     require( 'gulp-minify-css' ),
    jshint =        require( 'gulp-jshint' ),
    minjs =         require( 'gulp-jsmin'),
    //imageMin =      require( 'gulp-imagemin' ),
    spriteSmith =   require( 'gulp.spritesmith' ),
    //clean =         require( 'gulp-clean' ),
    //cache =         require( 'gulp-cache' ),
    changed =       require( 'gulp-changed' );

// -------------------------------------
// Options
// -------------------------------------

var paths =  {
    sprite:           ['img/pages/titles/*/*.png']
};

// -------------------------------------
// Tasks
// -------------------------------------

// HTML
//gulp.task( 'html', function() {
//  gulp.src( paths.html )
//    .pipe( changed(paths.buildHtml) )
//    .pipe( htmlReplace({
//      'css': 'css/styles.min.css',
//      'js': 'js/main.min.js'
//    }))
//    .pipe(minifyHtml())
//    .pipe( gulp.dest(paths.buildHtml) );
//});

// Image
gulp.task( 'sprite', function() {
  var spriteData = gulp.src( paths.sprite )
      .pipe(spriteSmith(
          {
              imgName: 'titles.png',
              imgPath: '../img/titles.png',
              cssVarMap: function (sprite) {
                  // `sprite` has `name`, `image` (full path), `x`, `y`
                  //   `width`, `height`, `total_width`, `total_height`
                  // EXAMPLE: Prefix all sprite names with 'sprite-'
                  var path = sprite.source_image.split('/');
                  var theme_folder = path[path.length-2];

                  sprite.name = theme_folder + '_' + sprite.name;
              },
              cssName: 'titles.sass',
              cssFormat: 'sass',
              padding: 10 }
      ));

  spriteData.img
    .pipe( gulp.dest( 'img' ) );

  spriteData.css
    .pipe( gulp.dest( 'css' ) );
});

gulp.task( 'default', function() {
  setTimeout(function() {
    gulp.start('sprite');
  }, 500);
});