// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.

var shareImage = require('com.ebm.shareimage');
// open a single window
var win = Ti.UI.createWindow({
	layout:'vertical'
});


var myImg = Ti.UI.createImageView({
	image:'yourimage.png',
	defaultImage:null,
	width:500,
	height:500,
	top:100
});


var myLbl = Ti.UI.createLabel({
	text:'This is my label',
	width:Ti.UI.SIZE,
	height:Ti.UI.SIZE,
	top:50,
	color:'#000'
});

//image share button
var btn1 = Ti.UI.createButton({
	title:'share image',
	top:10
});
	btn1.addEventListener('click',function(){
		//image share
		shareImage.share({
			image: myImg,
			callback: function(e) {
				if (e.success) {
					Ti.UI.createAlertDialog({ message: 'Shared successfully!' }).show();
				} else {
					Ti.UI.createAlertDialog({ message: 'Failed to share.' }).show();
				}
			}
		});
	});


//text share button
var btn2 = Ti.UI.createButton({
	title:'share text',
	top:10
});

	btn2.addEventListener('click',function(){
		//text share
		shareImage.share({
			text: myLbl.text,
			callback: function(e) {
				if (e.success) {
					Ti.UI.createAlertDialog({ message: 'Shared successfully!' }).show();
				} else {
					Ti.UI.createAlertDialog({ message: 'Failed to share.' }).show();
				}
			}
		});
	});

//text and image share button
	var btn3 = Ti.UI.createButton({
		title:'share text and image',
		top:10
	});
	
		btn3.addEventListener('click',function(){
			//text share
			shareImage.share({
				text: myLbl.text,
				image: myImg,
				callback: function(e) {
					if (e.success) {
						Ti.UI.createAlertDialog({ message: 'Shared successfully!' }).show();
					} else {
						Ti.UI.createAlertDialog({ message: 'Failed to share.' }).show();
					}
				}
			});
		});


win.add(myImg);
win.add(myLbl);
win.add(btn1);
//win.add(btn2);
//win.add(btn3);

win.open();
