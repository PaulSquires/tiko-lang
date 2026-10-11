'' Returns the time the module was compiled: modcache-clock checks it is never cached.
#module "stamp"
public function BuiltAt( ) as string
    return __TIME__
end function
