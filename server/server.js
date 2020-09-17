const http = require('http');

const hostname = '0.0.0.0';
const port = 3000;
const MAP_SIZE = 5;

let map = {
	size  : MAP_SIZE,
	tiles : new Array(MAP_SIZE)
};

for (var i = 0; i < MAP_SIZE; ++i) {
	map.tiles[i] = new Array(MAP_SIZE);
	for (var j = 0; j < MAP_SIZE; ++j) {
		map.tiles[i][j] = {
			type : 'grass'
		}
	}
}

const server = http.createServer((req, res) => {
	res.statusCode = 200;
	res.setHeader('Content-Type', 'application/json');
	res.end(JSON.stringify(map));
})

server.listen(port, hostname, () => {
	console.log('Server running at https://'+hostname+':'+port+'/');
})

