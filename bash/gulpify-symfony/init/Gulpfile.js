/**
 gulpify script of tykayn
 https://github.com/tykayn/blog.artlemoine.com
 http://artlemoine.com
 to run this you need bash to install dependencies:
        npm i -D gulp browser-sync --save-dev;
        gulp
 **/
var serverName = 'myservername.dev'; // you NEED to have a vhost of this name setup
var gulp = require('gulp');
var browserSync = require('browser-sync');


// Static server.
gulp.task('browser-sync', function () {
    // init server
    browserSync.init({
        proxy: serverName + "/app_dev.php"
    });
    // the server will automatically reload on change
    var filesToWatch = ["**/*.twig",
        "**/*.js",
        "src/**/*.php"];
    gulp.watch(filesToWatch)
        .on('change', browserSync.reload);
});

gulp.task('default', ['browser-sync']);
