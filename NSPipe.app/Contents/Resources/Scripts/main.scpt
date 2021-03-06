JsOsaDAS1.001.00bplist00�Vscript_// NSPipe: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSPipe_Class/Reference/Reference.html

ObjC.import("Cocoa");

var windowWidth = 400;
var windowHeight = 135;

var textFieldLabel = $.NSTextField.alloc.initWithFrame($.NSMakeRect(25, (windowHeight - 40), windowWidth - 50, 24));
textFieldLabel.stringValue = "Where is:";
textFieldLabel.drawsBackground = false;
textFieldLabel.editable = false;
textFieldLabel.bezeled = false;
textFieldLabel.selectable = true;

var textField = $.NSTextField.alloc.initWithFrame($.NSMakeRect(25, (windowHeight - 65), windowWidth - 150, 24));
textField.stringValue = "ruby";

var locField = $.NSTextField.alloc.initWithFrame($.NSMakeRect(25, (windowHeight - 110), windowWidth - 50, 24));
locField.drawsBackground = false;
locField.editable = false;
locField.bezeled = false;
locField.selectable = true;
locField.font = $.NSFont.boldSystemFontOfSize(18);

ObjC.registerSubclass({
	name: "AppDelegate",
	methods: {
		"btnClickHandler:": {
			types: ["void", ["id"]],
			implementation: function (sender) {
				if (textField.stringValue.length > 0) {
					var task = $.NSTask.alloc.init;
					var programName = textField.stringValue;
					task.launchPath = "/usr/bin/which";
					task.arguments = $([programName]);

					var out = $.NSPipe.pipe;
					task.standardOutput = out;
					task.standardError = out;

					task.launch;
					task.waitUntilExit;
					task.release;

					var read = out.fileHandleForReading;
					var dataRead = read.readDataToEndOfFile;

					if (dataRead.length > 0) {
						var stringRead = $.NSString.alloc.initWithDataEncoding(dataRead, $.NSUTF8StringEncoding).autorelease;
						
						locField.textColor = $.NSColor.blackColor;
						locField.stringValue = stringRead;
					}
					else {
						locField.textColor = $.NSColor.redColor;
						locField.stringValue = "Not found";
					}
				}
			}
		}
	}
});

var appDelegate = $.AppDelegate.alloc.init;

var styleMask = $.NSTitledWindowMask | $.NSClosableWindowMask | $.NSMiniaturizableWindowMask;
var window = $.NSWindow.alloc.initWithContentRectStyleMaskBackingDefer(
	$.NSMakeRect(0, 0, windowWidth, windowHeight),
	styleMask,
	$.NSBackingStoreBuffered,
	false
);

var btn = $.NSButton.alloc.initWithFrame($.NSMakeRect(25 + (windowWidth - 150), (windowHeight - 67), 100, 25));
btn.title = "Locate";
btn.bezelStyle = $.NSRoundedBezelStyle;
btn.buttonType = $.NSMomentaryLightButton;
// NOTE: See NSButton docs for info on target/action
btn.target = appDelegate;
btn.action = "btnClickHandler:";
btn.keyEquivalent = "\r"; // Enter key

window.contentView.addSubview(textField);
window.contentView.addSubview(textFieldLabel);
window.contentView.addSubview(btn);
window.contentView.addSubview(locField);

window.center;
window.title = "NSPipe Example";
window.makeKeyAndOrderFront(window);                              0jscr  ��ޭ