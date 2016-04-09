//
//  AppDelegate.swift
//  Jakobs Tools
//
//  Created by Jakob Stendahl on 20/02/16.
//  Copyright © 2016 Jakob Stendahl. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	var statusItem = NSStatusItem?()
	var button = NSStatusBarButton?()
	
	var filesHiden = true
	let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"

	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your app<ication

		let NSVariableStatusItemLength: CGFloat = -1.0;
		
		self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
		self.button = self.statusItem!.button
		self.button?.title = ""
		self.button?.action = "pressed:"
		self.button?.target = self
		
		let initialState = CheckCurrentState()
		if(initialState.characters.first == "Y") {
			filesHiden = false
			// Initialize app
			setStatusImage("SHOW")
		}
		if(initialState.characters.first == "N") {
			filesHiden = true
			// Initialize app
			setStatusImage("HIDE")
		}
		
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
	func setStatusImage (state : NSString) {
		
		if (appearance == "Dark") {
			if (state == "SHOW") {
				self.button?.image = NSImage(named: "imgShowDark")
			}
			if (state == "HIDE") {
				self.button?.image = NSImage(named: "imgHiddenDark")
			}
		}
		if (appearance == "Light") {
			if (state == "SHOW") {
				self.button?.image = NSImage(named: "imgShow")
			}
			if (state == "HIDE") {
				self.button?.image = NSImage(named: "imgHidden")
			}
		}
	}
	
	func CheckCurrentState() -> String {
		
		// Create a Task instance
		let task = NSTask()
		
		// Set the task parameters
		task.launchPath = "/usr/bin/env"
		task.arguments = ["defaults", "read", "com.apple.finder", "AppleShowAllFiles"]
		
		// Create a Pipe and make the task
		// put all the output there
		let pipe = NSPipe()
		task.standardOutput = pipe
		
		// Launch the task
		task.launch()
		
		// Get the data
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = NSString(data: data, encoding: NSUTF8StringEncoding)
		
		return(output!) as String
	}
	
	func toggleFilesVisible(state : NSString) {
		
		// Create a Task instance
		let task = NSTask()
		
		// Set the task parameters
		task.launchPath = "/usr/bin/env"
		if(state == "SHOW") {
			task.arguments = ["defaults", "write", "com.apple.finder", "AppleShowAllFiles", "YES"]
			print("SHOW")
		}
		if(state == "HIDE") {
			task.arguments = ["defaults", "write", "com.apple.finder", "AppleShowAllFiles", "NO"]
			print("HIDE")
		}
		
		// Create a Pipe and make the task
		// put all the output there
		let pipe = NSPipe()
		task.standardOutput = pipe
		
		// Launch the task
		task.launch()
		
		// Get the data
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = NSString(data: data, encoding: NSUTF8StringEncoding)
		
		print("State changed: ")
		print(output!)
		
	}
	
	func refreshFinder() {
		
		// Create a Task instance
		let task = NSTask()
		
		// Set the task parameters
		task.launchPath = "/usr/bin/env"
		task.arguments = ["killall", "Finder", "/System/Library/CoreServices/Finder.app"]
		
		// Create a Pipe and make the task
		// put all the output there
		let pipe = NSPipe()
		task.standardOutput = pipe
		
		// Launch the task
		task.launch()
		
		// Get the data
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = NSString(data: data, encoding: NSUTF8StringEncoding)
		
		print(output!)
	}
	
	func pressed(sender : AnyObject) {
		
		let currentStateOutput = CheckCurrentState()
		let currentState = currentStateOutput.characters.first
		print(currentState)
		
		if (currentState == "Y") {
			print("YAY")
			filesHiden = false
			toggleFilesVisible("HIDE")
			refreshFinder()
			setStatusImage("HIDE")
		}
		if currentState == "N" {
			print("NAAY")
			filesHiden = true
			toggleFilesVisible("SHOW")
			refreshFinder()
			setStatusImage("SHOW")
		}
		print("POOF")
		
	}
	

}

