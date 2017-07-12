[tags]: / "date,time"

# Working with date and time

The [Date class](http://api.haxe.org/Date.html) provides a basic structure for date and time related information. This article shows how to work with the date and time tools.

In the context of Haxe dates, a timestamp is defined as the number of milliseconds elapsed since 1st January 1970.

#### Create fixed date / time
```haxe
var date = new Date(2020, 1, 2, 12, 30, 0);
// Sun Feb 02 2020 12:30:00 GMT+0100 (W. Europe Standard Time)
```

#### Get the current date/time
```haxe
var today = Date.now();
```

## Formatting a date to string

You can grab the components of a date using these methods (all will return integers):

* `date.getSeconds()` The seconds of this Date (0-59 range).
* `date.getMinutes()` The minutes of this Date (0-59 range).
* `date.getHours()` The hours of this Date (0-23 range).
* `date.getDate()` The day of this Date (1-31 range).
* `date.getDay()` The day of the week of this Date (0-6 range) where 0 is Sunday.
* `date.getMonth()` The month of this Date (0-11 range).
* `date.getFullYear()` The full year of this Date (4-digits).

#### Formatting days / months

_Day and month are starting from zero_, this is different from how you normally read a date, but is convenient when you manually want to format it:

```haxe
var now = Date.now();

var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var monthName = monthNames[now.getMonth()];
trace("this month is called " + monthName);

var dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday"];
var dayName = dayNames[now.getDay()];
trace("this day is called " + dayName);
```

#### Formatting dates using `strftime` standard format

The [DateTools](http://api.haxe.org/DateTools.html) class contains a format function to express time in a convenient way.

```haxe
DateTools.format(Date.now(), "%Y-%m-%d_%H:%M:%S");
// 2018-07-08_14:44:05

DateTools.format(Date.now(), "%r");
// 02:44:05 PM

var t = DateTools.format(Date.now(), "%T");
// 14:44:05

DateTools.format(Date.now(), "%F");
// 2018-07-08

DateTools.format(Date.now(), "%b %d, %Y");
// Jan 08, 2018
```

> For a list of all strftime directives, check out <http://strftime.org>

## Calculating with dates

The [DateTools](http://api.haxe.org/DateTools.html) class contains even some more extra functionalities for calculating with Date instances and timestamps:

[tryhaxe](https://try.haxe.org/embed/Da47E)

## How to create a countdown timer

In this example we create a timer that counts down to a certain date.
When countdown is running, it traces "5 days - 12:02:59" and when it is expired, the timer stops.

The example makes use of the `haxe.Timer` class and the `StringTools` as static extension. Both are available in the standard library and run on any target.

[tryhaxe](https://try.haxe.org/embed/D3512)

> Read more in the Haxe API documentation: 
> 
>  * [Date API](http://api.haxe.org/Date.html)
>  * [DateTools API](http://api.haxe.org/DateTools.html)
