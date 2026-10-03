'' T75: std/tasks without -mt is refused by the facade itself; the headers' own guard
'' tests defined( __FB_MT__ ), which is always defined, so it compiled and then crashed.
#import "std/tasks"
dim ch as tasks.Channel( of long ) = tasks.Channel( of long )( 1 )
