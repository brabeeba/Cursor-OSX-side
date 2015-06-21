//
//  ViewController.swift
//  multipeer connectivity osx
//
//  Created by Brabeeba Wang on 12/3/14.
//  Copyright (c) 2014 Brabeeba Wang. All rights reserved.
//

import Cocoa
import MultipeerConnectivity
import Foundation
import CoreGraphics
import AppKit
import ApplicationServices



class ViewController: NSViewController,  MCSessionDelegate{
    var lastPosition=CGFloat(0)
    
    //this is a global variable which will be used to record input
    var originx=CGFloat(0)
    var originy=CGFloat(0)
    //self-defined prototype
    let serviceType = "brabeeba"
    
    //here we make framework to handle the advertising
    var assistant: MCAdvertiserAssistant!
    var session: MCSession!
    var peerID: MCPeerID!
    
    //execute after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize all the Multipeer objects
        self.peerID=MCPeerID(displayName: NSHost.currentHost().name)
        self.session=MCSession(peer: peerID)
        self.session.delegate=self
        self.assistant=MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session)
        //advertising
        self.assistant.start()
    }
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        // Called when a peer sends an NSData to us
        // This needs to run on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            var msg = NSString(data: data, encoding: NSUTF8StringEncoding)
            //parse the string into an array
            var array=msg!.componentsSeparatedByString(" ")
            //identify the first instant of input and record them as origin
            if(array[0] as! NSString=="tap"){
                var point=CGPoint()
                point.x=NSEvent.mouseLocation().x
                //because the CGWarpMouseCursorPosition has different coordinate as NSEvent.mouseLocation() (One from up to bottom, the other from bottom to top), we need to use the height minus what we want
                point.y=NSScreen.mainScreen()!.frame.size.height-NSEvent.mouseLocation().y
                let event1 = CGEventCreateMouseEvent(nil, CGEventType(kCGEventLeftMouseDown)  , point,  CGMouseButton(kCGMouseButtonLeft) )
                CGEventPost(CGEventTapLocation(kCGHIDEventTap), event1.takeRetainedValue())
                let event2 = CGEventCreateMouseEvent(nil, CGEventType(kCGEventLeftMouseUp)  , point,  CGMouseButton(kCGMouseButtonLeft) )
                CGEventPost(CGEventTapLocation(kCGHIDEventTap), event2.takeRetainedValue())
            }
            else if(array[0] as! NSString=="move")
            {
                if(array.count==4){
                    self.originx=NSEvent.mouseLocation().x
                    self.originy=NSEvent.mouseLocation().y
                }
                //typecast them as NSString
                var x=array[1] as! NSString
                var y=array[2] as! NSString
                
                var speed=1.7
                //create the translation point value
                var coordinatex=CGFloat(x.floatValue)*CGFloat(speed)
                var coordinatey=CGFloat(y.floatValue)*CGFloat(speed)
                var point=CGPoint()
                point.x=self.originx+coordinatex
                //because the CGWarpMouseCursorPosition has different coordinate as NSEvent.mouseLocation() (One from up to bottom, the other from bottom to top), we need to use the height minus what we want
                point.y=NSScreen.mainScreen()!.frame.size.height-(self.originy-coordinatey)
                
                if(point.x>NSScreen.mainScreen()!.frame.size.width-1)
                {
                    point.x=NSScreen.mainScreen()!.frame.size.width-1
                }
                if(point.x<0)
                {
                    point.x=0
                }
                if(point.y>NSScreen.mainScreen()!.frame.size.height-1)
                {
                    point.y=NSScreen.mainScreen()!.frame.size.height-1
                }
                if(point.y<0)
                {
                    point.y=0
                }
                //set mouse position
                let event3 = CGEventCreateMouseEvent(nil, CGEventType(kCGEventMouseMoved)  , point,  CGMouseButton(kCGMouseButtonLeft) )
                CGEventPost(CGEventTapLocation(kCGHIDEventTap), event3.takeRetainedValue())
                
            }
            else if(array[0] as! NSString=="scroll"){
                var x=array[1] as! NSString
                if(array.count==3){
                    if(array[2] as! NSString=="begin")
                    {
                        self.lastPosition=CGFloat(x.doubleValue)
                    }
                    if(array[2] as! NSString=="cancel")
                    {
                        
                    }
                }
                if(array.count==2)
                {
                    var translation=CGFloat(x.doubleValue)-self.lastPosition
                    println(translation)
                    self.lastPosition=CGFloat(x.doubleValue)
                    
                    var instanceOfCustomObject: CustomObject = CustomObject()
                    var y=Int32(round(translation*0.5))
                  
                    instanceOfCustomObject.someMethod(y)
                }
                
            }
                
        }
    }
    //those functions below are required by the protocal.
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    }
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    }
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    }
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    }
}

