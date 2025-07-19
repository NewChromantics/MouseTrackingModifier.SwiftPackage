import SwiftUI


#if canImport(UIKit)//ios
public typealias UIRect = CGRect
extension UIView
{
	var theLayer: CALayer? { get{ self.layer } }
}

#else
import AppKit
public typealias UIView = NSView
public typealias UIColor = NSColor
public typealias UIRect = NSRect
public typealias UIViewRepresentable = NSViewRepresentable
public typealias UIEvent = NSEvent

extension UIView
{
	var theLayer: CALayer? { get{ self.layer } }
}

#endif



public class MouseStateTrackingView : UIView 
{
	var onMouseStateChanged : (MouseState)->Void
	var onMouseScroll : (MouseScrollEvent)->Void
	
#if canImport(AppKit)
	var trackingArea: NSTrackingArea?
#endif
	
	required init?(coder: NSCoder) 
	{
		fatalError()
	}
	
	public init(onMouseStateChanged:@escaping(MouseState)->Void,onMouseScroll:@escaping(MouseScrollEvent)->Void)
	{
		self.onMouseStateChanged = onMouseStateChanged
		self.onMouseScroll = onMouseScroll
		super.init(frame: UIRect())
		
#if canImport(AppKit)
		//	enable mouse move events when tracking area changes(layout changes)
		self.window?.acceptsMouseMovedEvents = true
#endif
	}
	
#if canImport(AppKit)
	func getMouseViewPosition(event:UIEvent) -> CGPoint
	{
		//let screenPosition = NSEvent.mouseLocation
		let windowPosition = event.locationInWindow
		//	event for wrong window
		//if self.window?.windowNumber == event.windowNumber
		let viewPosition = self.convert(windowPosition, from:nil)
		return viewPosition
	}
#endif
	
	func updateState(_ event:UIEvent)
	{
		//	todo: ios version
#if canImport(AppKit)
		let viewPosition = getMouseViewPosition(event: event)
		let buttonsPressed = UIEvent.pressedMouseButtons
		
		let leftDown = (buttonsPressed & (1<<0)) != 0
		let rightDown = (buttonsPressed & (1<<1)) != 0
		let middleDown = (buttonsPressed & (1<<2)) != 0
		
		let state = MouseState(leftDown: leftDown, middleDown: middleDown, rightDown: rightDown, position: viewPosition)
		onMouseStateChanged( state )
#endif
	}
	
	
#if canImport(AppKit)
	public override func updateTrackingAreas()
	{
		let trackingOptions : NSTrackingArea.Options = [
			.activeAlways, 
				.mouseEnteredAndExited, 
				.mouseMoved,
			.enabledDuringMouseDrag
		]

		//	update tracking area
		if let trackingArea
		{
			self.removeTrackingArea(trackingArea)
			self.trackingArea = nil
		}
		trackingArea = NSTrackingArea(rect: bounds, 
									  options: trackingOptions, 
									  owner: self, userInfo: nil)
		self.addTrackingArea(trackingArea!)
		
		super.updateTrackingAreas()
	}

	public override func mouseDown(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func rightMouseDown(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func otherMouseDown(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func mouseUp(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func rightMouseUp(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func otherMouseUp(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func mouseMoved(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func mouseDragged(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func rightMouseDragged(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func otherMouseDragged(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func mouseEntered(with theEvent: NSEvent) 		{	updateState(theEvent)	}
	public override func mouseExited(with theEvent: NSEvent)	{	updateState(theEvent)	}

	public override func scrollWheel(with theEvent: NSEvent) 	
	{
		let viewPosition = getMouseViewPosition(event: theEvent)
		//	gr: include x scroll once we establish if device has it
		let scrollEvent = MouseScrollEvent(scrollDelta: theEvent.scrollingDeltaY, position: viewPosition )
		onMouseScroll( scrollEvent )
	}
#endif
}


public struct MouseTrackingView : UIViewRepresentable
{
	public typealias UIViewType = MouseStateTrackingView
	public typealias NSViewType = MouseStateTrackingView
	
	var onMouseStateChanged : (MouseState)->Void
	var onMouseScroll : (MouseScrollEvent)->Void
	
	public init(onMouseStateChanged:@escaping (MouseState)->Void,onMouseScroll:@escaping (MouseScrollEvent)->Void)
	{
		self.onMouseStateChanged = onMouseStateChanged
		self.onMouseScroll = onMouseScroll
	}
	
	public func makeNSView(context: Context) -> NSViewType 
	{
		return makeUIView(context:context)
	}
	
	public func makeUIView(context: Context) -> UIViewType 
	{
		return UIViewType(onMouseStateChanged: onMouseStateChanged, onMouseScroll:onMouseScroll)
	}
	
	public func updateNSView(_ nsView: UIViewType, context: Context) 
	{
		updateUIView( nsView, context: context )
	}
	public func updateUIView(_ nsView: UIViewType, context: Context) 
	{
	}
}		

#Preview
{
	MouseTestView()
}
