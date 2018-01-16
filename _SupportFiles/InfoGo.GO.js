/* Position content correctly below header and GO box */

function goPositionHeaders(){

	var goExtraHeight = 12; /* Add custom padding to top */

	var goHeaderHeight = document.getElementById('divGoHeader').offsetHeight;
	var goPushHeight = goHeaderHeight + goExtraHeight;

	/* push body container down by height of OEM header plus extra height */
	document.getElementById('divGoContainer').style.cssText = "padding-top:" + goPushHeight.toString() + "px;";

	/* push GO box down by height of OEM header */
	document.getElementById('divGoBoxContainer').style.cssText = "top:" + goHeaderHeight.toString() + "px;";

}

goPositionHeaders();

if (!window.addEventListener) {
	window.attachEvent('onresize', goPositionHeaders);
} else {
	window.addEventListener('resize', goPositionHeaders, false);
}