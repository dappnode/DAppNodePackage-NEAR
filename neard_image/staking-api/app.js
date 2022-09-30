var express = require('express');
var app = express();
var cors = require('cors');
var shell = require('shelljs');
const {CUSTOM_API_HTTP_PORT = 8080} = process.env

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/api/environment/:key', (req, res) => {
    const command = `echo $${req.params.key}`;
    const value = shell.exec(command).stdout.trim();
    const response = {
        value: value,
    };
    res.send(response);
});

var server = app.listen(CUSTOM_API_HTTP_PORT, function () {
    var host = server.address().address;
    var port = server.address().port;

    console.log('my app is listening at http://%s:%s', host, port);
});
