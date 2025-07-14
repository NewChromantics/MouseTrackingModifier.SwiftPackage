MouseTrackingModifier
=========================
Attach this view-modifier to a view to get mouse changes as a struct with left/right/middle button states and a view-space position


Todo
---------------
- On ios convert touches to fake pos+left/right/middle for compatibility 
- Implement a dragging modifier to emulate `.onDragGesture` but supporting more buttons


Notes
---------------
- This is implemented as an `.overlay()` so other overlays added after this will have precedent and block mouse clicks (but not position)
	- Would this be better as a background?


Example 
----------------
- See preview code

```
struct MouseTestView : View 
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
			}
		}
		.mouseTracking
		{
			debug = "Mouse State \($0)"
			print($0)
		}
		onScroll:	//	optionally get scroll events
		{
			scroll += $0.scrollDelta
		}
	}
}
```
