const express=require('express');
const cookieParser = require('cookie-parser');
const app=express();
const port=80;
const db=require('./config/mongoose');

const session=require('express-session');
const passport=require('passport');
const passportLocal=require('./config/passport-local-strategy');

const MongoStore=require('connect-mongo');

const expressLayouts=require('express-ejs-layouts');
app.use(expressLayouts);
//extract styles and scripts from subpages into the layout
app.set('layout extractStyles',true)
app.set('layout extractScripts',true)

//use express router
// app.use('/',require('./routes/index'));

app.use(express.urlencoded());

app.use(cookieParser());

//static files
app.use(express.static('./assets'))

//set up the view engine
app.set('view engine','ejs');
app.set('views','./views')

app.use(session({
    name:'AdoptConnect',
    secret:'something',
    saveUninitialized:false,//when user is not logged in then not required to store extra data in cookie
    resave:false,//when identity is establised, not save data repetitively
    cookie:{
        maxAge:(1000*60*100)//its in milli-seconds(age of cookie)
    },
    store:  MongoStore.create(
        {
            mongoUrl:'mongodb+srv://admin:abcdefgh@cluster0.zshjdva.mongodb.net/',
            autoRemove: 'disabled'
        
        },
        function(err){
            console.log(err ||  'connect-mongodb setup ok');
        }
    )
}))
app.use(passport.initialize());
app.use(passport.session());
app.use(passport.setAuthenticatedUser);

app.use('/', require('./routes'));

app.listen(port,function(error){
    if(error){
        console.log(`Error in running the server:${err}`);
    }
    console.log(`server is running on port ${port}`);
})