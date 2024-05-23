#include <YSI_Coding\y_hooks>

/**
 * # Forwards
 */

forward OnPlayerRequestRegister(playerid);
forward OnPlayerRequestLogIn(playerid);

forward OnAccountCheck(playerid);

/**
 * # Hooks
 */

hook OnPlayerRequestClass(playerid, classid) {
    TogglePlayerSpectating(playerid, true);

    new
        query[128]
    ;

    mysql_format(MYSQL_DEFAULT_HANDLE, query, sizeof (query), "SELECT `id`, `hash` FROM `accounts` WHERE `name` = '%e' LIMIT 1;", ReturnPlayerName(playerid));
    mysql_tquery(MYSQL_DEFAULT_HANDLE, query, "OnAccountCheck", "i", playerid);

    return 1;
}

/**
 * # Calls
 */

public OnAccountCheck(playerid) {
    if (!cache_num_rows()) {
        CallLocalFunction("OnPlayerRequestRegister", "i", playerid);
    
        return 1;
    }

    new
        DBID:id,
        hash[BCRYPT_HASH_LENGTH]
    ;

    cache_get_value_int(0, "id", _:id);
    cache_get_value(0, "hash", hash);

    SetAccountDatabaseID(playerid, id);
    SetAccountHash(playerid, hash);

    CallLocalFunction("OnPlayerRequestLogIn", "i", playerid);

    return 1;
}
