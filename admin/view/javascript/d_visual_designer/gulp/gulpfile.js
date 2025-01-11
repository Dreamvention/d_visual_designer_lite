var gulp = require('gulp');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var cleanCSS = require('gulp-clean-css');
var del = require('del');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var autoprefixer = require('gulp-autoprefixer');
var stripCssComments = require('gulp-strip-css-comments');
var browserSync = require("browser-sync");
var path = require("path");
var fs = require("fs");
var glob = require("glob")

//script paths
var jsDest = '../dist/';

var sassDest = '../../../stylesheet/d_visual_designer/'

var baseDir = path.resolve(__dirname, "../../../../");


gulp.task('clean', function () {
    return del(jsDest + '**', {force: true});
});

gulp.task('copy', ['copy-fonts', 'copy-img'], function () {
    gulp.start(['iconsets', 'iconsetsPro'])
});

gulp.task('iconsetsPro', function () {
    const dirs = fs.readdirSync('../library/iconsetsPro').filter(function(dir) {
        return fs.lstatSync('../library/iconsetsPro/'+dir).isDirectory()
    })
    for (var key in dirs) {
        if(fs.existsSync('../library/iconsetsPro/'+dirs[key]+'.js')){
            del('../library/iconsets/'+dirs[key]+'.js')
        }
        var getContent = require('../library/iconsetsPro/'+dirs[key]+'/index.js')
        var content = getContent()
        fs.writeFileSync('../iconset/'+dirs[key]+'.js', content.content)
    }
});

gulp.task('iconsets', function () {
    const dirs = fs.readdirSync('../library/iconsets').filter(function(dir) {
        return fs.lstatSync('../library/iconsets/'+dir).isDirectory()
    })
    for (var key in dirs) {
        if(fs.existsSync('../library/iconsets/'+dirs[key]+'.js')){
            del('../library/iconsets/'+dirs[key]+'.js')
        }
        var getContent = require('../library/iconsets/'+dirs[key]+'/index.js')
        var content = getContent()
        fs.writeFileSync('../library/iconsets/'+dirs[key]+'.js', content.content)
    }
    gulp.start(['scripts', 'styles'])
});


gulp.task('iconsets', function () {
    const dirs = fs.readdirSync('../library/iconsets').filter(function(dir) {
        return fs.lstatSync('../library/iconsets/'+dir).isDirectory()
    })
    for (var key in dirs) {
        if(fs.existsSync('../library/iconsets/'+dirs[key]+'.js')){
            del('../library/iconsets/'+dirs[key]+'.js')
        }
        var getContent = require('../library/iconsets/'+dirs[key]+'/index.js')
        var content = getContent()
        fs.writeFileSync('../library/iconsets/'+dirs[key]+'.js', content.content)
    }
    gulp.start(['scripts', 'styles'])
});

gulp.task('copy-fonts', function () {
    return gulp.src([
        "../library/icon-fonts/fonts/*",
        "../library/fontIconPicker/fonts/*"
    ])
        .pipe(gulp.dest(jsDest + 'fonts/'));
});

gulp.task('copy-img', function () {
    return gulp.src([
        "../library/bootstrap-colorpicker/img/*",
        "../library/select2/img/*"
    ])
        .pipe(gulp.dest(jsDest + 'img/'));
});

gulp.task('scripts', function () {
    return gulp.src([
        "../library/jquery-ui/jquery-ui.js",
        "../library/jquery.serializejson.js",
        "../library/underscore-min.js",
        "../library/jscolor.min.js",
        "../library/bootstrap-switch/bootstrap-switch.min.js",
        "../library/select2/select2.full.min.js",
        "../library/fontset.js",
        "../library/iconsets/*.js"
    ])
        .pipe(concat('vd-libraries.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest(jsDest));
});

gulp.task('styles', function () {
    return gulp.src([
        "../library/icon-fonts/elusive-icons.scss",
        "../library/icon-fonts/fontawesome.scss",
        "../library/icon-fonts/ionicons.scss",
        "../library/icon-fonts/map-icons.scss",
        "../library/icon-fonts/material-design-iconic-font.scss",
        "../library/icon-fonts/octicons.scss",
        "../library/icon-fonts/typicons.scss",
        "../library/icon-fonts/weather-icons.scss",
        "../library/bootstrap-switch/bootstrap-switch.min.css",
        "../library/select2/select2-bootstrap.min.css",
        "../library/select2/select2.font.css",
        "../library/select2/select2.min.css",
        "../library/jquery-ui/jquery-ui.css"
    ])
    .pipe(sass({outputStyle: "compressed"}).on("error", sass.logError))
    .pipe(concat('vd-libraries.min.css'))
    .pipe(cleanCSS())
    .pipe(stripCssComments({preserve: false}))
    .pipe(gulp.dest(jsDest));
});

gulp.task('build_library', ['clean'], function () {
    gulp.start('copy')
});

gulp.task('sass', function () {
    return gulp.src(sassDest + '*.scss')

        .pipe(sourcemaps.init())
        .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
        .pipe(autoprefixer({
            browsers: ['last 15 versions']
        }))
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest(sassDest))
        .pipe(browserSync.reload({stream: true}));
});

gulp.task('sass:watch', function () {
    gulp.watch([sassDest + '*.scss', sassDest + 'core/*.scss'], ['sass']);
});


gulp.task("browser_sync_init", function () {
    if (typeof process.env.HOST !== "undefined") {
        browserSync({
            proxy: process.env.HOST
        });
    }
})

gulp.task("build_sass", ["browser_sync_init"], function () {
    if (typeof process.env.HOST !== "undefined") {
        gulp.watch([
            baseDir + "/controller/extension/d_visual_designer/**/*.php",
            baseDir + "/view/template/extension/d_visual_designer/**/*.tag"
        ], browserSync.reload);
    }
    gulp.start(["sass", "sass:watch"]);
})
