'' A module of the root package: it sees the package's [defines].
#module "util"
public function Flag( ) as long
#ifdef APP_FLAG
    return 1
#else
    return 0
#endif
end function
