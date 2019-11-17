# **CircularWordCloud**

Circular Word Cloud with N-Words Selector
<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift5-compatible-4BC51D.svg?style=flat" alt="Swift 5 compatible" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://raw.githubusercontent.com/xmartlabs/XLPagerTabStrip/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" />
</a>    
</p>

Made with Team SISISI by [k-elon](https://github.com/minsub0922).

Circular Word Cloud for iOS !

**CircularWordMap** is a *Container View* that allows us to implement word map easily. You can use it for presenting **Word Relationships** or **TItle-Subtitles Architecture**.

<table>
  <tr>
    <th><img width="413" alt="1" src="https://user-images.githubusercontent.com/9532432/69011983-de348000-09b3-11ea-9438-fa736f831194.png" width="250"/></th>
    <th><img width="413" alt="2" src="https://user-images.githubusercontent.com/9532432/69011973-be04c100-09b3-11ea-8347-1c719acfd315.png" width="250"/></th>
    <th><img width="413" alt="3" src="https://user-images.githubusercontent.com/9532432/69011981-cf4dcd80-09b3-11ea-8067-368450ed1608.png" width="250"/></th>
    <th><img src="Example/pagerTabStripTypes.gif" width="250"/></th>
  </tr>
</table>


# Usage

    import CircularWordCloud
    
    class YourViewController: CircularWordCloudDelegate {
    		...
    }

    private func setupCWC(subject: String, strings: [String]) {
    	// count of strings determines your circle type.
    	let container = BubbleContainer(frame: .zero, centerText: subject, childTextArray: strings)
    	container.delegate = self
    	self.view.addSubview(container)
    	container.translatesAutoresizingMaskIntoConstraints = false
    	NSLayoutConstraint.activate([
    	    container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    	    container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    	    container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
    	    container.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
    	])
    }
