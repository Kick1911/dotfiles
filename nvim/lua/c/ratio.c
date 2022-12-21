#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static int
clean_ratio(lua_State *L){
    float thresholds[] = {0, 0.2, 0.4, 0.6, 0.8};
    float* t = thresholds + sizeof(thresholds)/sizeof(float) - 1;
    float ratio = lua_tonumber(L, -1); /* Get the single number arg */

    while( (int)(ratio / *t) != 1 && *--t );

    lua_pushnumber(L, *t); /* Push the return */
    return 1; /* One return value */
}

int
luaopen_ratio(lua_State *L){
    lua_register(
        L,               /* Lua state variable */
        "clean_ratio",        /* func name as known in Lua */
        clean_ratio          /* func name in this file */
    );
    return 0;
}
