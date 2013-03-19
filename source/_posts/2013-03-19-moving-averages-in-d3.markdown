---
layout: post
title: "Moving Averages in d3"
date: 2013-03-19 20:16
categories: 
---
<div id="plot"></div>
<form id="adjust">
  <input id="rate" type="range" min="0" max="1" step=".05" value=".5">
</form>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script type="text/javascript">

var n = 100; //number of data elements
var w = 800; var h = 100; //plot size
var rate = .5; //discounting factor

document.querySelector("#rate").addEventListener("change", function() {
  rate = +document.querySelector("#rate").value; //look ma, no jQuery!
}, false);

var next_data = (function() {
  //generate a random value from a previous value
  var v = 70;
  return function() {
    v = ~~Math.max(10, Math.min(90, v + 10 * (Math.random() - .5)))
    return v;
  };
})();

var data = d3.range(n).map(next_data);

var next_avg = function(next, prev, discount) {
  //compute the next avg from the previous avg, using the discounting factor
  return next * discount + prev * (1 - discount);
};

var averages = (function(d, a) {
  var current = d[0];
  var avg = []; 
  avg.push(d[0].value);
  for (var i = 1; i < d.length; i++) {
    avg.push(current);
    current = next_avg(d[i], current, a);
  }
  return avg;
})(data, rate);

var x = d3.scale.linear()
    .domain([0, n])
    .range([-1, w+10]);
    
var y = d3.scale.linear()
    .domain([0, 100])
    .rangeRound([0, h]);

var plot = d3.select("#plot").append("svg")
  .attr("width", w)
  .attr("height", h);
 
var area = d3.svg.area()
  .interpolate("basis")
  .x(function(d,i) { return x(i); })
  .y0(h+1)
  .y1(function(d) { return y(d); });
  
var datapath = plot.append("path")
  .datum(data)
  .attr("class", "data")
  .attr("d", area);
  
var line = d3.svg.line()
  .interpolate("basis")
  .x(function(d,i) { return x(i); })
  .y(function(d,i) { return y(d); });

var avgpath = plot.append("path")
  .datum(averages)
  .attr("class", "average")
  .attr("d", line);

var tick = function() {
 
  var nd = next_data();
  var na = next_avg(nd, averages[averages.length - 1], rate);
  data.push(nd);
  averages.push(na);
 
  datapath.attr("d", area)
    .attr("transform", null)
    .transition()
    .duration(200)
    .ease("linear")
    .attr("transform", "translate(" + x(-1) + ")");
    
  avgpath.attr("d", line)
    .attr("transform", null)
    .transition()
    .duration(200)
    .ease("linear")
    .attr("transform", "translate(" + x(-1) + ")")
    .each("end", tick);
    
  data.shift();
  averages.shift();
}
  
tick();

</script>
Moving averages are a nice, easy to understand technique for dampening fluctuations in time series data to emphasize long term trends. They are used, for example, in networks to . . . . In this post, I'll walk through adding an exponentially weighted moving average to a scrolling time series visualization in d3.

To begin, we need some time series data. Here I'm going to cheat and just use the random walk function provided [in the d3 tutorial]().

``` javascript
var next_data = (function() {
  //seed the initial value 
  var v = 60;
  return function() {
    //generate a random value from the seed and update seed
    v = ~~Math.max(10, Math.min(90, v + 10 * (Math.random() - .5)))
    return v;
  };
})();
```

Given this function, which generates success random values, we can use a d3 one-liner to build an initial data set

``` javascript
var data = d3.range(n).map(next_data);
```

Creating a static line or area plot of this data in d3 is simple but making it dynamic involves a little bit of trickery. Let's start with the static plot.

``` javascript
var x = d3.scale.linear()
    .domain([0, n])
    .range([-1, w+10]);
    
var y = d3.scale.linear()
    .domain([0, 100])
    .rangeRound([0, h]);

var plot = d3.select("#plot").append("svg")
  .attr("width", w)
  .attr("height", h);
 
var area = d3.svg.area()
  .interpolate("basis")
  .x(function(d,i) { return x(i); })
  .y0(h+1)
  .y1(function(d) { return y(d); });
  
var datapath = plot.append("path")
  .datum(data)
  .attr("class", "data")
  .attr("d", area);
```

The noteworthy bits are ```plot```, which appends an SVG element to an empty div in the DOM, ```area```, which is a built in d3 layout for, you guessed it, area plots and ```datapath``` which binds the data to an SVG path using the area layout that was just defined.

So how then to update the plot dynamically as new data comes in? We need some a repeating function that ```push``es the new data onto the array, ```shift```s off the oldest element and updates the path. The tricky bit involves how d3's interpolators interact with SVG spec and rather than go into it, I'll let Mike himself [explain](http://bost.ocks.org/mike/path/). 

``` javascript

```

Now, onto moving averages. The nice thing about using the exponentially weighted moving average is that it can be computed recursively. We can take advantage of this fact to precompute an array of moving average values from the initial data and then, anytime we need a new moving average value, compute it from the last moving average value. It's easier to see in code:

``` javascript
var next_avg = function(next, prev, discount) {
  //compute the next avg from the previous avg, using the discounting factor
  return next * discount + prev * (1 - discount);
};
```

Here, ```next``` is the latest data point and ```prev``` is the last moving average that was computed (the element at index ```length - 1``` in the array of averages).

Just like we did with the initial data, we can use this function to build up an initial array of averages as well.

``` javascript
var averages = (function(d, a) {
  //this is the impossibly long form of reduce :(
  var current = d[0]; //base case = first value in the data set
  var avg = []; 
  avg.push(d[0].value);
  for (var i = 1; i < d.length; i++) {
    avg.push(current);
    current = next_avg(d[i], current, a);
  }
  return avg;
})(data, rate);
```

Note that we begin by assigning ```current``` to the value of the first data element. We do this because, since we're using a recursive definition, we need a base case! In truth, there are other techniques we might have used, for example, making the base case equal to the average of the first n elements, but this way is simple and clear.

Now that we have a seed array of moving averages, we just need to plot it dynamically as with the data array. The code is largely the same as before. We can reuse the x and y scales I used a line instead of an area.

OK, so for one last hurrah, let's add a slider so that we can adjust the discount factor.

``` html
<form id="adjust">
  <input id="rate" type="range" min="0" max="1" step=".05" value=".5">
</form>
```

The HTML5 slider is basically perfect for this. All that remains is to add an event listener.

``` html
document.querySelector("#rate").addEventListener("change", function() {
  rate = +document.querySelector("#rate").value; //look ma, no jQuery!
}, false);
```

It's that easy. If you play around with the slider, you can see how the moving average changes. When the discounting factor goes to 0, we ignore all new inputs from the data set, resulting in a straight line from the last average value. When it goes to 1, we ignore the average values track the actual data set. I absolutely d3 for stuff like this.