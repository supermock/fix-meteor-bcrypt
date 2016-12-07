var fs = require('fs');

if (process.argv[3] == undefined) {
    fs.readFile(process.argv[2] + '/.meteor/release', 'utf8', function (err, data) {
        if (err) {
            console.log("Error");
        } else {
            console.log(data.substring(7, data.length).replace(/.([^.]*)$/, '_$1'));
        }
    });
} else {
    var exec = require('child_process').exec;
    exec('cd /d ' + process.argv[2] + ' && meteor npm install --save bcrypt', function(error, stdout, stderr) {
        if (stderr) {
            if (stderr.indexOf("node-pre-gyp") > -1) {
                console.log("true");
            } else {
                console.log("false");
                fs.writeFile(process.argv[3] + "/log_error.txt", stderr, function(err) {});
            }
        } else {
            console.log("true");
        }
    });
}