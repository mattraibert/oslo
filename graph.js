$.get('main.json').done(function(links) {
    var nodes = {};

    // Compute the distinct nodes from the links.
    links.forEach(function(link) {
	link.source = nodes[link.source] || (nodes[link.source] = {name: link.source});
	link.target = nodes[link.target] || (nodes[link.target] = {name: link.target});
    });

    var width = 960,
    height = 500;

    var force = d3.layout.force()
	.nodes(d3.values(nodes))
	.links(links)
	.size([width, height])
	.linkDistance(60)
	.charge(-300)
	.on("tick", tick)
	.start();

    var svg = d3.select("body").append("svg")
	.attr("width", width)
	.attr("height", height);

    var path = svg.append("g").selectAll("path")
	.data(force.links())
	.enter().append("path")
	.attr("class", function(d) { return "link " + d.type; })
	.attr("marker-end", function(d) { return "url(#" + d.type + ")"; });

    var circle = svg.append("g").selectAll("circle")
	.data(force.nodes())
	.enter().append("circle")
	.attr("r", 6)
	.call(force.drag);

    var text = svg.append("g").selectAll("text")
	.data(force.nodes())
	.enter().append("text")
	.attr("x", 8)
	.attr("y", ".31em")
	.text(function(d) { return d.name; });

    // Use elliptical arc path segments to doubly-encode directionality.
    function tick() {
	path.attr("d", linkArc);
	circle.attr("transform", transform);
	text.attr("transform", transform);
    }

    function linkArc(d) {
	return "M" + d.source.x + "," + d.source.y +" L" + d.target.x + "," + d.target.y;
    }

    function transform(d) {
	return "translate(" + d.x + "," + d.y + ")";
    }
});
