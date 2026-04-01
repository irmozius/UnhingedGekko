extends fade_rule

class_name point_fade

@export var median : float = 50.0 ## The value at which the track should be max volume.
@export var padding : float = 2.0 ## Extra space above and below the median to still be considered max volume. 35 with a padding of 5 gives max volume between 30 and 40.
@export var range : float = 50.0 ## The max distance from the median, beyond which the track is silent. For example, if the median is 120, and the range is 40, the track will be silent at either 160 or 80.

var fade_type := "point"
