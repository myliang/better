#!/bin/bash

less_basepath="./lesses/"
coffee_basepath="./coffees/"
css_basepath="./doc/csses/"
js_basepath="./doc/javascripts/"
app_name="application"

less_file="${less_basepath}${app_name}.less"
css_file="${css_basepath}${app_name}.css"
css_compress_file="${css_basepath}${app_name}.min.css"
recess --compile $less_file > $css_file
recess --compress $less_file > $css_compress_file

# cat $css_file >> $application_css_file
coffee --compile --output $js_basepath $coffee_basepath

jses=("utils" "jquery.popup" "jquery.tip" "jquery.menu" "jquery.form" "jquery.paginate" "other")
echo "" > ${js_basepath}${app_name}.min.js
echo "" > ${js_basepath}${app_name}.js
for js in ${jses[@]}; do
  # echo "filename = ${js_basepath}${js}.js"
  cat ${js_basepath}$js.js >> ${js_basepath}${app_name}.js
  uglifyjs --no-copyright ${js_basepath}$js.js >> ${js_basepath}${app_name}.min.js
done
