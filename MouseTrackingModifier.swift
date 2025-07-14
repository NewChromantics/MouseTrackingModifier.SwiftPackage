import SwiftUI


public struct MouseState
{
	public var leftDown : Bool
	public var middleDown : Bool
	public var rightDown : Bool

	public var position : CGPoint	//	in view space
}

public struct MouseScrollEvent
{
	public var scrollDelta : CGFloat
	public var position : CGPoint	//	in view space
}

public struct MouseTrackingModifier : ViewModifier
{
	var onMouseStateChanged : (MouseState)->Void 
	var onMouseScroll : (MouseScrollEvent)->Void 
	
	public func body(content: Content) -> some View 
	{
		content
			.overlay
		{
			MouseTrackingView(onMouseStateChanged: onMouseStateChanged, onMouseScroll: onMouseScroll)
		}
	}
}

public extension View 
{
	func mouseTracking(_ onMouseStateChanged:@escaping (MouseState)->Void,onScroll:@escaping (MouseScrollEvent)->Void) -> some View 
	{
		modifier(MouseTrackingModifier(onMouseStateChanged: onMouseStateChanged, onMouseScroll: onScroll))
	}

	func mouseTracking(_ onMouseStateChanged:@escaping (MouseState)->Void) -> some View 
	{
		mouseTracking( onMouseStateChanged, onScroll:{_ in} )
	}
}



internal struct MouseTestView : View 
{
	@State var debug : String = "Hello"
	@State var scroll : CGFloat = 0.0
	
	var body: some View 
	{
		Rectangle()
			.fill(.blue)
			.frame(width:300,height:300)
			.overlay
		{
			VStack
			{
				Text("Scroll: \(scroll)")
				Text(debug)
				//.foregroundStyle(.white)	//	macos14
			}
		}
		.mouseTracking
		{
			debug = "\($0)"
			print($0)
		}
		onScroll:
		{
			scroll += $0.scrollDelta
		}
	}
}

#Preview
{
	MouseTestView()
}
