package utils;

class MathUtils {
    public static function toRads(degrees:Float):Float {
		return degrees * Math.PI / 180;
	}

    public static function toDegrees(rads:Float):Float {
		return rads * 180 / Math.PI;
	}
}