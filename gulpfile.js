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
    //source:         'source',
    //build:            'build',
    //html:             ['*.html'],
    //htmlWatch:        ['*.html'],
    style:            ['less/styles.less'],
    styleWatch:       ['less/*.less'],
    script:           ['js/main.js'],
    scriptVendor:     [
        'js/vendor/jquery-1.11.0.min.js',
        'js/vendor/jquery-migrate-1.2.1.js',
        'js/vendor/jquery-ui-1.10.4.custom.min.js',
        'js/vendor/jquery.parallax.min.js',
        'js/vendor/modernizr2.7.2.min.js',
        'js/vendor/social-likes.min.js'
                      ],
    scriptWatch:      ['js/**/*.js'],
    image:            ['img/**/*'],
    sprite:           ['img/sprite/*.png']
    //media:          ['source/media/**/*', '!source/media/img/**/*']
    //mediaImage:     ['source/media/img/**/*']
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
    .pipe( spriteSmith({ imgName: 'sprite.png', imgPath: '../img/sprite.png', cssName: 'sprite.less', cssFormat: 'less', padding: 10 }) );

  spriteData.img
    .pipe( gulp.dest( 'img' ) );

  spriteData.css
    .pipe( gulp.dest( 'less' ) );
});

//gulp.task( 'image', function() {
//  gulp.src( paths.image )
//    .pipe( changed( paths.build + 'img' ) )
//    .pipe( cache( imageMin({ optimizationLevel: 5, progressive: true, interlaced: true }) ) )
//    .pipe( gulp.dest( paths.build + 'img' ));
//});

// Media
//gulp.task( 'media', function() {
//  gulp.src( paths.media )
//    .pipe( changed( paths.build + '/media/' ) )
//    .pipe( gulp.dest( paths.build + '/media/' ));
//
//  gulp.src( paths.mediaImage )
//    .pipe( changed( paths.build + '/media/img' ) )
//    .pipe( cache( imageMin({ optimizationLevel: 3, progressive: true, interlaced: true }) ) )
//    .pipe( gulp.dest( paths.build + '/media/img' ));
//});

// Style (less > css)
gulp.task( 'style', function() {
  gulp.src( paths.style )
    .pipe( less() )
    .on( 'error', gutil.log )
    .pipe( autoPrefixer( 'last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4', { cascade: true } ) )
    .pipe( gulp.dest( 'css' ) )
    .pipe( rename({ suffix: '.min' }) )
    .pipe( minifyCss() )
    .pipe( gulp.dest( 'css' ) );
});

// Script (js)
gulp.task( 'script', function() {
  gulp.src( paths.script )
    .pipe( jshint() )
    .pipe( jshint.reporter( 'default' ) )
    .pipe( include() )
    .pipe( gulp.dest( 'js' ) )
    .pipe( rename({ suffix: '.min' }) )
    .pipe( minjs() )
    .pipe( gulp.dest( 'js' ) );
gu
  gulp.src( paths.scriptVendor )
    .pipe( include() )
    .pipe( concat('vendor.min.js') )
    .pipe( gulp.dest( 'js/vendor' ) );

  gulp.src(['js/vendor/vendor.min.js', 'js/main.min.js'])
    .pipe( concat('all.min.js') )
    .pipe( gulp.dest( 'js' ) );
});

// Clean
//gulp.task( 'clean', function() {
//  gulp.src(['css', 'js', 'img'], { read: false })
//    .pipe(clean());
//});

// Watch
gulp.task( 'watch', function() {
  //gulp.watch( paths.htmlWatch, ['html']);

  gulp.watch( paths.sprite, ['sprite']);

  gulp.watch( paths.styleWatch, ['style']);

  gulp.watch( paths.scriptWatch, ['script']);

  //gulp.watch( paths.image, ['image']);

  //gulp.watch( paths.media, ['media']);

  //gulp.watch( paths.mediaImage, ['media']);
});

// Default
gulp.task( 'default', function() {
  setTimeout(function() {
    gulp.start('sprite', 'style', 'script', 'watch');
  }, 500);
});