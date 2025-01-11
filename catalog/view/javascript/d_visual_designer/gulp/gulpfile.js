/*jslint node: true */
"use strict";

var gulp = require("gulp");
var concat = require("gulp-concat");
var uglify = require("gulp-uglify");
var cleanCSS = require("gulp-clean-css");
var del = require("del");
var sass = require("gulp-sass");
var sourcemaps = require("gulp-sourcemaps");
var autoprefixer = require("gulp-autoprefixer");
var browserSync = require("browser-sync");
var path = require("path");

//script paths
var jsDest = "../dist/";

var sassDest = "../../../theme/default/stylesheet/d_visual_designer/";

var baseDir = path.resolve(__dirname, "../../../../");

gulp.task("clean", function () {
    return del(jsDest + "**", {force: true});
});

gulp.task("copy", ["copy-fonts"], function () {
    gulp.start(["basic-scripts", "basic-styles"]);
});

gulp.task("copy-fonts", function () {
    return gulp.src([
        "../library/icon-fonts/fonts/*"
    ])
        .pipe(gulp.dest(jsDest + "fonts/"));
});

gulp.task("basic-scripts", function () {
    return gulp.src([
        "../library/sharrre/jquery.sharrre.min.js",
        "../library/magnific/jquery.magnific-popup.min.js",
        "../library/chart/Chart.min.js",
        "../library/pie-chart.js",
        "../library/circle-progress.js",
		"../library/swiperjs/swiper-bundle.min.js",
        //"../library/owl-carousel/owl.carousel.min.js",
        "../library/webfont.js",
        "../library/underscore-min.js",
        "../library/fastclone.js"
    ])
        .pipe(concat("vd-basic-libraries.min.js"))
        .pipe(uglify())
        .pipe(gulp.dest(jsDest));
});

gulp.task("basic-styles", function () {
    return gulp.src([
        "../library/sharrre/style.css",
        "../library/magnific/magnific-popup.css",
        "../library/swiperjs/swiper-bundle.min.css",
        // "../library/owl-carousel/owl.transitions.scss",
        "../library/animate.css",
        "../library/icon-fonts/elusive-icons.scss",
        "../library/icon-fonts/fontawesome.scss",
        "../library/icon-fonts/ionicons.scss",
        "../library/icon-fonts/map-icons.scss",
        "../library/icon-fonts/material-design-iconic-font.scss",
        "../library/icon-fonts/octicons.scss",
        "../library/icon-fonts/typicons.scss",
        "../library/icon-fonts/weather-icons.scss"
    ])
        .pipe(sass({outputStyle: "compressed"}).on("error", sass.logError))
        .pipe(concat("vd-basic-libraries.min.css"))
        .pipe(cleanCSS())
        .pipe(gulp.dest(jsDest));
});


gulp.task("build_library", ["clean"], function () {
    gulp.start("copy")
});

gulp.task("sass", function () {
    return gulp.src(sassDest + "*.scss")
        .pipe(sourcemaps.init())
        .pipe(sass({outputStyle: "compressed"}).on("error", sass.logError))
        .pipe(autoprefixer({
            browsers: ["last 15 versions"]
        }))
        .pipe(sourcemaps.write("./"))
        .pipe(gulp.dest(sassDest))
        .pipe(browserSync.reload({stream: true}));
});
gulp.task("sass:blocks", function () {
    return gulp.src(sassDest + "blocks/*.scss")
        .pipe(sourcemaps.init())
        .pipe(sass({outputStyle: "compressed"}).on("error", sass.logError))
        .pipe(autoprefixer({
            browsers: ["last 15 versions"]
        }))
        .pipe(sourcemaps.write("./blocks/"))
        .pipe(gulp.dest(sassDest+'blocks/'))
        .pipe(browserSync.reload({stream: true}));
});

gulp.task("sass:watch", function () {
    gulp.watch([sassDest + "*.scss", sassDest + "core/*.scss", sassDest+"blocks/*.scss"], ["sass", "sass:blocks"]);
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
            baseDir + "/view/theme/default/template/extension/d_visual_designer/**/*.tag"
        ], browserSync.reload);
    }
    gulp.start(["sass", "sass:blocks", "sass:watch"]);
})
