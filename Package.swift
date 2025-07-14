// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription



let package = Package(
	name: "MouseTracking",
	
	platforms: [
		.iOS(.v15),
		.macOS(.v12)	//	overlay() requires 12 
	],
	

	products: [
		.library(
			name: "MouseTracking",
			targets: [
				"MouseTracking"
			]),
	],
	targets: [

		.target(
			name: "MouseTracking",
			path: "./"
		)
	]
)
