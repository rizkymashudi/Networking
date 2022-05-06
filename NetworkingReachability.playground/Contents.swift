import UIKit
import SystemConfiguration

func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
  let isReachable = flags.contains(.reachable)
  let needsConnection = flags.contains(.connectionRequired)
  let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
  let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
  
  return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
}

let reachability = SCNetworkReachabilityCreateWithName(nil, "www.dicoding.com") //Initialize reachability object
var flags = SCNetworkReachabilityFlags()  //create flags
SCNetworkReachabilityGetFlags(reachability!, &flags)

//check if host accessible
if !isNetworkReachable(with: flags) {
  print("Device doesnt have internet connection")
} else {
  print("Host www.dicoding.com is reachable")
}

//validate if using packet data
if flags.contains(.isWWAN) {
  print("Device is using mobile data")
}
