import qs from 'querystring';

function hello(r) {
    var name=process.env["HELLO_NAME"]
    r.return(200, "Hello, "+(name?name:"world")+"!\n");
}

function parse_args(r) {
    return qs.parse(r.requestText);
}

function get_sessionid(){
    return "38afes7a838afes7a8"
}

function is_valid_user(username, password){
    return (
        (username == "user1" && password == "pass1")
        ||
        (username == "user2" && password == "pass2")
    );
}

function check_user(r) {
    var args = parse_args(r);
    var username = args["username"];
    var password = args["password"];
    r.headersOut['Content-Type'] = "text/plain; charset=utf-8";
    if(is_valid_user(username, password)){
        r.headersOut['Set-Cookie'] = "sessionid="+get_sessionid()+"; HttpOnly; Path=/; Max-Age=360";
        r.return(200, "OK");
    }else{
        r.headersOut['Set-Cookie'] = "sessionid=; HttpOnly; Path=/; Max-Age=0";
        r.return(401, "Unauthorized");
    }
}

function debug(r) {
    function json(o) {
        return JSON.stringify(o,null,2);
    }
    function items(o) {
        var _=[]
        for(var i in o){
            _[_.length]=i+" :"+typeof(o[i])
        }
        return _;
    }
    var ret=""
    function print(s){
        ret+=s+"\n"
    }
    print("r: "+json(r));
    print("r.variables: "+json(r.variables));
    print("r.variables['https']: "+json(r.variables['https']));
    print("r.variables['http_accept']: "+json(r.variables['http_accept']));
    print("r.variables['http_user_agent']: "+json(r.variables['http_user_agent']));
    print("r.variables['cookie_sessionid']: "+json(r.variables['cookie_sessionid']));
    print("process.env: "+json(process.env));
    r.headersOut['Content-Type'] = "text/plain; charset=utf-8";
    r.return(200, ret);
}

export default {hello, check_user, debug};