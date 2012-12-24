# install less => css and compress css and so on
# recess ./bootstrap.less --compress > ./bootstrap-production.css
# https://github.com/twitter/recess
npm install recess uglify-js jshint -g

# install coffee script
# https://github.com/jashkenas/coffee-script
# http://coffeescript.org/
# execute a script : coffee a.coffee
# compile a script : coffee -c a.coffee
npm install -g coffee-script

# support browers: ie8+, chrome, firefox

# jquery tip
# http://projects.nickstakenburg.com/tipped/documentation

# less => css
sh build.sh

# css master
box model
padding: 5, border: 0, margin: 10, width: 70
ie: padding + width + margin = 90
other: padding + width + margin = 100

# css layout
# fluid layout
# 1, body
# 2, container
# 3, masthead
# 4, content
# 5, sidebar
# 6, footer
# body {
margin: 10px;
background: #FFF;
}
#container {
margin: 0 auto;
width: 760px;
}
#masthead {
position: relative;
background: #F7F7F4 url(../img/bg_repeat.gif) repeat-x;
}
#content
float: right;
width: 50%;
}
#sidebar{
float: left;
width: 49.9%;
width: 50% !important;


# icon Font Awesome

