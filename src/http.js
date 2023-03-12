function hello(r) {
    var name=process.env["HELLO_NAME"]
    r.return(200, "Hello, "+(name?name:"world")+"!\n");
}

export default {hello};