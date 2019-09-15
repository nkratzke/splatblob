(function(){var supportsDirectProtoAccess=function(){var z=function(){}
z.prototype={p:{}}
var y=new z()
if(!(y.__proto__&&y.__proto__.p===z.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var x=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(x))return true}}catch(w){}return false}()
function map(a){a=Object.create(null)
a.x=0
delete a.x
return a}var A=map()
var B=map()
var C=map()
var D=map()
var E=map()
var F=map()
var G=map()
var H=map()
var J=map()
var K=map()
var L=map()
var M=map()
var N=map()
var O=map()
var P=map()
var Q=map()
var R=map()
var S=map()
var T=map()
var U=map()
var V=map()
var W=map()
var X=map()
var Y=map()
var Z=map()
function I(){}init()
function setupProgram(a,b){"use strict"
function generateAccessor(a9,b0,b1){var g=a9.split("-")
var f=g[0]
var e=f.length
var d=f.charCodeAt(e-1)
var c
if(g.length>1)c=true
else c=false
d=d>=60&&d<=64?d-59:d>=123&&d<=126?d-117:d>=37&&d<=43?d-27:0
if(d){var a0=d&3
var a1=d>>2
var a2=f=f.substring(0,e-1)
var a3=f.indexOf(":")
if(a3>0){a2=f.substring(0,a3)
f=f.substring(a3+1)}if(a0){var a4=a0&2?"r":""
var a5=a0&1?"this":"r"
var a6="return "+a5+"."+f
var a7=b1+".prototype.g"+a2+"="
var a8="function("+a4+"){"+a6+"}"
if(c)b0.push(a7+"$reflectable("+a8+");\n")
else b0.push(a7+a8+";\n")}if(a1){var a4=a1&2?"r,v":"v"
var a5=a1&1?"this":"r"
var a6=a5+"."+f+"=v"
var a7=b1+".prototype.s"+a2+"="
var a8="function("+a4+"){"+a6+"}"
if(c)b0.push(a7+"$reflectable("+a8+");\n")
else b0.push(a7+a8+";\n")}}return f}function defineClass(a2,a3){var g=[]
var f="function "+a2+"("
var e=""
var d=""
for(var c=0;c<a3.length;c++){if(c!=0)f+=", "
var a0=generateAccessor(a3[c],g,a2)
d+="'"+a0+"',"
var a1="p_"+a0
f+=a1
e+="this."+a0+" = "+a1+";\n"}if(supportsDirectProtoAccess)e+="this."+"$deferredAction"+"();"
f+=") {\n"+e+"}\n"
f+=a2+".builtin$cls=\""+a2+"\";\n"
f+="$desc=$collectedClasses."+a2+"[1];\n"
f+=a2+".prototype = $desc;\n"
if(typeof defineClass.name!="string")f+=a2+".name=\""+a2+"\";\n"
f+=a2+"."+"$__fields__"+"=["+d+"];\n"
f+=g.join("")
return f}init.createNewIsolate=function(){return new I()}
init.classIdExtractor=function(c){return c.constructor.name}
init.classFieldsExtractor=function(c){var g=c.constructor.$__fields__
if(!g)return[]
var f=[]
f.length=g.length
for(var e=0;e<g.length;e++)f[e]=c[g[e]]
return f}
init.instanceFromClassId=function(c){return new init.allClasses[c]()}
init.initializeEmptyInstance=function(c,d,e){init.allClasses[c].apply(d,e)
return d}
var z=supportsDirectProtoAccess?function(c,d){var g=c.prototype
g.__proto__=d.prototype
g.constructor=c
g["$is"+c.name]=c
return convertToFastObject(g)}:function(){function tmp(){}return function(a0,a1){tmp.prototype=a1.prototype
var g=new tmp()
convertToSlowObject(g)
var f=a0.prototype
var e=Object.keys(f)
for(var d=0;d<e.length;d++){var c=e[d]
g[c]=f[c]}g["$is"+a0.name]=a0
g.constructor=a0
a0.prototype=g
return g}}()
function finishClasses(a4){var g=init.allClasses
a4.combinedConstructorFunction+="return [\n"+a4.constructorsList.join(",\n  ")+"\n]"
var f=new Function("$collectedClasses",a4.combinedConstructorFunction)(a4.collected)
a4.combinedConstructorFunction=null
for(var e=0;e<f.length;e++){var d=f[e]
var c=d.name
var a0=a4.collected[c]
var a1=a0[0]
a0=a0[1]
g[c]=d
a1[c]=d}f=null
var a2=init.finishedClasses
function finishClass(c1){if(a2[c1])return
a2[c1]=true
var a5=a4.pending[c1]
if(a5&&a5.indexOf("+")>0){var a6=a5.split("+")
a5=a6[0]
var a7=a6[1]
finishClass(a7)
var a8=g[a7]
var a9=a8.prototype
var b0=g[c1].prototype
var b1=Object.keys(a9)
for(var b2=0;b2<b1.length;b2++){var b3=b1[b2]
if(!u.call(b0,b3))b0[b3]=a9[b3]}}if(!a5||typeof a5!="string"){var b4=g[c1]
var b5=b4.prototype
b5.constructor=b4
b5.$isb=b4
b5.$deferredAction=function(){}
return}finishClass(a5)
var b6=g[a5]
if(!b6)b6=existingIsolateProperties[a5]
var b4=g[c1]
var b5=z(b4,b6)
if(a9)b5.$deferredAction=mixinDeferredActionHelper(a9,b5)
if(Object.prototype.hasOwnProperty.call(b5,"%")){var b7=b5["%"].split(";")
if(b7[0]){var b8=b7[0].split("|")
for(var b2=0;b2<b8.length;b2++){init.interceptorsByTag[b8[b2]]=b4
init.leafTags[b8[b2]]=true}}if(b7[1]){b8=b7[1].split("|")
if(b7[2]){var b9=b7[2].split("|")
for(var b2=0;b2<b9.length;b2++){var c0=g[b9[b2]]
c0.$nativeSuperclassTag=b8[0]}}for(b2=0;b2<b8.length;b2++){init.interceptorsByTag[b8[b2]]=b4
init.leafTags[b8[b2]]=false}}b5.$deferredAction()}if(b5.$isf)b5.$deferredAction()}var a3=Object.keys(a4.pending)
for(var e=0;e<a3.length;e++)finishClass(a3[e])}function finishAddStubsHelper(){var g=this
while(!g.hasOwnProperty("$deferredAction"))g=g.__proto__
delete g.$deferredAction
var f=Object.keys(g)
for(var e=0;e<f.length;e++){var d=f[e]
var c=d.charCodeAt(0)
var a0
if(d!=="^"&&d!=="$reflectable"&&c!==43&&c!==42&&(a0=g[d])!=null&&a0.constructor===Array&&d!=="<>")addStubs(g,a0,d,false,[])}convertToFastObject(g)
g=g.__proto__
g.$deferredAction()}function mixinDeferredActionHelper(c,d){var g
if(d.hasOwnProperty("$deferredAction"))g=d.$deferredAction
return function foo(){if(!supportsDirectProtoAccess)return
var f=this
while(!f.hasOwnProperty("$deferredAction"))f=f.__proto__
if(g)f.$deferredAction=g
else{delete f.$deferredAction
convertToFastObject(f)}c.$deferredAction()
f.$deferredAction()}}function processClassData(b1,b2,b3){b2=convertToSlowObject(b2)
var g
var f=Object.keys(b2)
var e=false
var d=supportsDirectProtoAccess&&b1!="b"
for(var c=0;c<f.length;c++){var a0=f[c]
var a1=a0.charCodeAt(0)
if(a0==="p"){processStatics(init.statics[b1]=b2.p,b3)
delete b2.p}else if(a1===43){w[g]=a0.substring(1)
var a2=b2[a0]
if(a2>0)b2[g].$reflectable=a2}else if(a1===42){b2[g].$defaultValues=b2[a0]
var a3=b2.$methodsWithOptionalArguments
if(!a3)b2.$methodsWithOptionalArguments=a3={}
a3[a0]=g}else{var a4=b2[a0]
if(a0!=="^"&&a4!=null&&a4.constructor===Array&&a0!=="<>")if(d)e=true
else addStubs(b2,a4,a0,false,[])
else g=a0}}if(e)b2.$deferredAction=finishAddStubsHelper
var a5=b2["^"],a6,a7,a8=a5
var a9=a8.split(";")
a8=a9[1]?a9[1].split(","):[]
a7=a9[0]
a6=a7.split(":")
if(a6.length==2){a7=a6[0]
var b0=a6[1]
if(b0)b2.$signature=function(b4){return function(){return init.types[b4]}}(b0)}if(a7)b3.pending[b1]=a7
b3.combinedConstructorFunction+=defineClass(b1,a8)
b3.constructorsList.push(b1)
b3.collected[b1]=[m,b2]
i.push(b1)}function processStatics(a3,a4){var g=Object.keys(a3)
for(var f=0;f<g.length;f++){var e=g[f]
if(e==="^")continue
var d=a3[e]
var c=e.charCodeAt(0)
var a0
if(c===43){v[a0]=e.substring(1)
var a1=a3[e]
if(a1>0)a3[a0].$reflectable=a1
if(d&&d.length)init.typeInformation[a0]=d}else if(c===42){m[a0].$defaultValues=d
var a2=a3.$methodsWithOptionalArguments
if(!a2)a3.$methodsWithOptionalArguments=a2={}
a2[e]=a0}else if(typeof d==="function"){m[a0=e]=d
h.push(e)
init.globalFunctions[e]=d}else if(d.constructor===Array)addStubs(m,d,e,true,h)
else{a0=e
processClassData(e,d,a4)}}}function addStubs(b2,b3,b4,b5,b6){var g=0,f=b3[g],e
if(typeof f=="string")e=b3[++g]
else{e=f
f=b4}var d=[b2[b4]=b2[f]=e]
e.$stubName=b4
b6.push(b4)
for(g++;g<b3.length;g++){e=b3[g]
if(typeof e!="function")break
if(!b5)e.$stubName=b3[++g]
d.push(e)
if(e.$stubName){b2[e.$stubName]=e
b6.push(e.$stubName)}}for(var c=0;c<d.length;g++,c++)d[c].$callName=b3[g]
var a0=b3[g]
b3=b3.slice(++g)
var a1=b3[0]
var a2=a1>>1
var a3=(a1&1)===1
var a4=a1===3
var a5=a1===1
var a6=b3[1]
var a7=a6>>1
var a8=(a6&1)===1
var a9=a2+a7!=d[0].length
var b0=b3[2]
if(typeof b0=="number")b3[2]=b0+b
var b1=2*a7+a2+3
if(a0){e=tearOff(d,b3,b5,b4,a9)
b2[b4].$getter=e
e.$getterStub=true
if(b5){init.globalFunctions[b4]=e
b6.push(a0)}b2[a0]=e
d.push(e)
e.$stubName=a0
e.$callName=null}}function tearOffGetter(c,d,e,f){return f?new Function("funcs","reflectionInfo","name","H","c","return function tearOff_"+e+y+++"(x) {"+"if (c === null) c = "+"H.cd"+"("+"this, funcs, reflectionInfo, false, [x], name);"+"return new c(this, funcs[0], x, name);"+"}")(c,d,e,H,null):new Function("funcs","reflectionInfo","name","H","c","return function tearOff_"+e+y+++"() {"+"if (c === null) c = "+"H.cd"+"("+"this, funcs, reflectionInfo, false, [], name);"+"return new c(this, funcs[0], null, name);"+"}")(c,d,e,H,null)}function tearOff(c,d,e,f,a0){var g
return e?function(){if(g===void 0)g=H.cd(this,c,d,true,[],f).prototype
return g}:tearOffGetter(c,d,f,a0)}var y=0
if(!init.libraries)init.libraries=[]
if(!init.mangledNames)init.mangledNames=map()
if(!init.mangledGlobalNames)init.mangledGlobalNames=map()
if(!init.statics)init.statics=map()
if(!init.typeInformation)init.typeInformation=map()
if(!init.globalFunctions)init.globalFunctions=map()
var x=init.libraries
var w=init.mangledNames
var v=init.mangledGlobalNames
var u=Object.prototype.hasOwnProperty
var t=a.length
var s=map()
s.collected=map()
s.pending=map()
s.constructorsList=[]
s.combinedConstructorFunction="function $reflectable(fn){fn.$reflectable=1;return fn};\n"+"var $desc;\n"
for(var r=0;r<t;r++){var q=a[r]
var p=q[0]
var o=q[1]
var n=q[2]
var m=q[3]
var l=q[4]
var k=!!q[5]
var j=l&&l["^"]
if(j instanceof Array)j=j[0]
var i=[]
var h=[]
processStatics(l,s)
x.push([p,o,i,h,n,j,k,m])}finishClasses(s)}I.G=function(){}
var dart=[["","",,H,{"^":"",jQ:{"^":"b;a"}}],["","",,J,{"^":"",
n:function(a){return void 0},
bw:function(a,b,c,d){return{i:a,p:b,e:c,x:d}},
bt:function(a){var z,y,x,w,v
z=a[init.dispatchPropertyName]
if(z==null)if($.cf==null){H.iU()
z=a[init.dispatchPropertyName]}if(z!=null){y=z.p
if(!1===y)return z.i
if(!0===y)return a
x=Object.getPrototypeOf(a)
if(y===x)return z.i
if(z.e===x)throw H.c(new P.dm("Return interceptor for "+H.d(y(a,z))))}w=a.constructor
v=w==null?null:w[$.$get$bL()]
if(v!=null)return v
v=H.j1(a)
if(v!=null)return v
if(typeof a=="function")return C.V
y=Object.getPrototypeOf(a)
if(y==null)return C.F
if(y===Object.prototype)return C.F
if(typeof w=="function"){Object.defineProperty(w,$.$get$bL(),{value:C.p,enumerable:false,writable:true,configurable:true})
return C.p}return C.p},
f:{"^":"b;",
w:function(a,b){return a===b},
gC:function(a){return H.a9(a)},
i:["cS",function(a){return H.bh(a)}],
"%":"Blob|DOMError|DOMImplementation|File|FileError|MediaError|MediaKeyError|NavigatorUserMediaError|PositionError|Range|SQLError|SVGAnimatedLength|SVGAnimatedLengthList|SVGAnimatedNumber|SVGAnimatedNumberList|SVGAnimatedString"},
f2:{"^":"f;",
i:function(a){return String(a)},
gC:function(a){return a?519018:218159},
$isaN:1},
f4:{"^":"f;",
w:function(a,b){return null==b},
i:function(a){return"null"},
gC:function(a){return 0}},
bM:{"^":"f;",
gC:function(a){return 0},
i:["cU",function(a){return String(a)}],
$isf5:1},
fo:{"^":"bM;"},
b2:{"^":"bM;"},
b_:{"^":"bM;",
i:function(a){var z=a[$.$get$cw()]
return z==null?this.cU(a):J.E(z)},
$signature:function(){return{func:1,opt:[,,,,,,,,,,,,,,,,]}}},
aX:{"^":"f;$ti",
ce:function(a,b){if(!!a.immutable$list)throw H.c(new P.t(b))},
bd:function(a,b){if(!!a.fixed$length)throw H.c(new P.t(b))},
ac:function(a,b){this.bd(a,"removeAt")
if(b<0||b>=a.length)throw H.c(P.aG(b,null,null))
return a.splice(b,1)[0]},
u:function(a,b){var z
this.bd(a,"remove")
for(z=0;z<a.length;++z)if(J.x(a[z],b)){a.splice(z,1)
return!0}return!1},
X:function(a,b){var z,y
z=a.length
for(y=0;y<z;++y){b.$1(a[y])
if(a.length!==z)throw H.c(new P.S(a))}},
Y:function(a,b){return new H.b0(a,b,[null,null])},
ab:function(a,b){var z,y,x,w
z=a.length
y=new Array(z)
y.fixed$length=Array
for(x=0;x<a.length;++x){w=H.d(a[x])
if(x>=z)return H.a(y,x)
y[x]=w}return y.join(b)},
e7:function(a,b,c){var z,y,x
z=a.length
for(y=!1,x=0;x<z;++x){y=c.$2(y,a[x])
if(a.length!==z)throw H.c(new P.S(a))}return y},
H:function(a,b){if(b<0||b>=a.length)return H.a(a,b)
return a[b]},
ge5:function(a){if(a.length>0)return a[0]
throw H.c(H.bJ())},
T:function(a,b,c,d,e){var z,y,x
this.ce(a,"set range")
P.c_(b,c,a.length,null,null,null)
z=c-b
if(z===0)return
if(e<0)H.v(P.H(e,0,null,"skipCount",null))
if(e+z>d.length)throw H.c(H.cG())
if(e<b)for(y=z-1;y>=0;--y){x=e+y
if(x<0||x>=d.length)return H.a(d,x)
a[b+y]=d[x]}else for(y=0;y<z;++y){x=e+y
if(x<0||x>=d.length)return H.a(d,x)
a[b+y]=d[x]}},
ca:function(a,b){var z,y
z=a.length
for(y=0;y<z;++y){if(b.$1(a[y])===!0)return!0
if(a.length!==z)throw H.c(new P.S(a))}return!1},
cQ:function(a,b){var z,y,x,w
this.ce(a,"shuffle")
z=a.length
for(;z>1;){y=C.I.ar(z);--z
x=a.length
if(z>=x)return H.a(a,z)
w=a[z]
if(y<0||y>=x)return H.a(a,y)
this.n(a,z,a[y])
this.n(a,y,w)}},
bw:function(a){return this.cQ(a,null)},
an:function(a,b,c){var z
if(c>=a.length)return-1
for(z=c;z<a.length;++z)if(J.x(a[z],b))return z
return-1},
bg:function(a,b){return this.an(a,b,0)},
q:function(a,b){var z
for(z=0;z<a.length;++z)if(J.x(a[z],b))return!0
return!1},
i:function(a){return P.bd(a,"[","]")},
gv:function(a){return new J.em(a,a.length,0,null)},
gC:function(a){return H.a9(a)},
gj:function(a){return a.length},
sj:function(a,b){this.bd(a,"set length")
if(b<0)throw H.c(P.H(b,0,null,"newLength",null))
a.length=b},
h:function(a,b){if(typeof b!=="number"||Math.floor(b)!==b)throw H.c(H.y(a,b))
if(b>=a.length||b<0)throw H.c(H.y(a,b))
return a[b]},
n:function(a,b,c){if(!!a.immutable$list)H.v(new P.t("indexed set"))
if(typeof b!=="number"||Math.floor(b)!==b)throw H.c(H.y(a,b))
if(b>=a.length||b<0)throw H.c(H.y(a,b))
a[b]=c},
$isK:1,
$asK:I.G,
$ish:1,
$ash:null,
$isi:1,
$asi:null},
jP:{"^":"aX;$ti"},
em:{"^":"b;a,b,c,d",
gt:function(){return this.d},
k:function(){var z,y,x
z=this.a
y=z.length
if(this.b!==y)throw H.c(H.a5(z))
x=this.c
if(x>=y){this.d=null
return!1}this.d=z[x]
this.c=x+1
return!0}},
aY:{"^":"f;",
e6:function(a){var z,y
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){z=a|0
return a===z?z:z-1}y=Math.floor(a)
if(isFinite(y))return y
throw H.c(new P.t(""+a+".floor()"))},
eQ:function(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw H.c(new P.t(""+a+".round()"))},
i:function(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gC:function(a){return a&0x1FFFFFFF},
S:function(a,b){if(typeof b!=="number")throw H.c(H.L(b))
return a+b},
ag:function(a,b){if(typeof b!=="number")throw H.c(H.L(b))
return a-b},
O:function(a,b){return a*b},
I:function(a,b){var z=a%b
if(z===0)return 0
if(z>0)return z
if(b<0)return z-b
else return z+b},
aR:function(a,b){if(typeof b!=="number")throw H.c(H.L(b))
if((a|0)===a)if(b>=1||!1)return a/b|0
return this.c3(a,b)},
D:function(a,b){return(a|0)===a?a/b|0:this.c3(a,b)},
c3:function(a,b){var z=a/b
if(z>=-2147483648&&z<=2147483647)return z|0
if(z>0){if(z!==1/0)return Math.floor(z)}else if(z>-1/0)return Math.ceil(z)
throw H.c(new P.t("Result of truncating division is "+H.d(z)+": "+H.d(a)+" ~/ "+b))},
c2:function(a,b){var z
if(a>0)z=b>31?0:a>>>b
else{z=b>31?31:b
z=a>>z>>>0}return z},
ae:function(a,b){if(typeof b!=="number")throw H.c(H.L(b))
return a<b},
ad:function(a,b){if(typeof b!=="number")throw H.c(H.L(b))
return a>b},
$isav:1},
cI:{"^":"aY;",$isav:1,$isk:1},
f3:{"^":"aY;",$isav:1},
aZ:{"^":"f;",
be:function(a,b){if(typeof b!=="number"||Math.floor(b)!==b)throw H.c(H.y(a,b))
if(b<0)throw H.c(H.y(a,b))
if(b>=a.length)H.v(H.y(a,b))
return a.charCodeAt(b)},
aw:function(a,b){if(b>=a.length)throw H.c(H.y(a,b))
return a.charCodeAt(b)},
dJ:function(a,b,c){if(c>b.length)throw H.c(P.H(c,0,b.length,null,null))
return new H.id(b,a,c)},
dI:function(a,b){return this.dJ(a,b,0)},
co:function(a,b,c){var z,y,x
z=J.aO(c)
if(z.ae(c,0)||z.ad(c,b.length))throw H.c(P.H(c,0,b.length,null,null))
y=a.length
if(J.by(z.S(c,y),b.length))return
for(x=0;x<y;++x)if(this.be(b,z.S(c,x))!==this.aw(a,x))return
return new H.d3(c,b,a)},
S:function(a,b){if(typeof b!=="string")throw H.c(P.bz(b,null,null))
return a+b},
cR:function(a,b,c){var z
if(c>a.length)throw H.c(P.H(c,0,a.length,null,null))
z=c+b.length
if(z>a.length)return!1
return b===a.substring(c,z)},
by:function(a,b){return this.cR(a,b,0)},
ah:function(a,b,c){var z
if(typeof b!=="number"||Math.floor(b)!==b)H.v(H.L(b))
if(c==null)c=a.length
if(typeof c!=="number"||Math.floor(c)!==c)H.v(H.L(c))
z=J.aO(b)
if(z.ae(b,0))throw H.c(P.aG(b,null,null))
if(z.ad(b,c))throw H.c(P.aG(b,null,null))
if(J.by(c,a.length))throw H.c(P.aG(c,null,null))
return a.substring(b,c)},
U:function(a,b){return this.ah(a,b,null)},
eV:function(a){return a.toLowerCase()},
eW:function(a){return a.toUpperCase()},
eX:function(a){var z,y,x,w,v
z=a.trim()
y=z.length
if(y===0)return z
if(this.aw(z,0)===133){x=J.f6(z,1)
if(x===y)return""}else x=0
w=y-1
v=this.be(z,w)===133?J.f7(z,w):y
if(x===0&&v===y)return z
return z.substring(x,v)},
an:function(a,b,c){var z,y,x,w
if(b==null)H.v(H.L(b))
if(c>a.length)throw H.c(P.H(c,0,a.length,null,null))
if(typeof b==="string")return a.indexOf(b,c)
z=J.n(b)
if(!!z.$iscK){y=b.dh(a,c)
return y==null?-1:y.b.index}for(x=a.length,w=c;w<=x;++w)if(z.co(b,a,w)!=null)return w
return-1},
bg:function(a,b){return this.an(a,b,0)},
dQ:function(a,b,c){if(c>a.length)throw H.c(P.H(c,0,a.length,null,null))
return H.j7(a,b,c)},
q:function(a,b){return this.dQ(a,b,0)},
i:function(a){return a},
gC:function(a){var z,y,x
for(z=a.length,y=0,x=0;x<z;++x){y=536870911&y+a.charCodeAt(x)
y=536870911&y+((524287&y)<<10)
y^=y>>6}y=536870911&y+((67108863&y)<<3)
y^=y>>11
return 536870911&y+((16383&y)<<15)},
gj:function(a){return a.length},
h:function(a,b){if(typeof b!=="number"||Math.floor(b)!==b)throw H.c(H.y(a,b))
if(b>=a.length||b<0)throw H.c(H.y(a,b))
return a[b]},
$isK:1,
$asK:I.G,
$isu:1,
p:{
cJ:function(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
f6:function(a,b){var z,y
for(z=a.length;b<z;){y=C.e.aw(a,b)
if(y!==32&&y!==13&&!J.cJ(y))break;++b}return b},
f7:function(a,b){var z,y
for(;b>0;b=z){z=b-1
y=C.e.be(a,z)
if(y!==32&&y!==13&&!J.cJ(y))break}return b}}}}],["","",,H,{"^":"",
bJ:function(){return new P.Z("No element")},
f1:function(){return new P.Z("Too many elements")},
cG:function(){return new P.Z("Too few elements")},
i:{"^":"J;$ti",$asi:null},
aE:{"^":"i;$ti",
gv:function(a){return new H.a2(this,this.gj(this),0,null)},
bs:function(a,b){return this.cT(0,b)},
Y:function(a,b){return new H.b0(this,b,[H.A(this,"aE",0),null])},
at:function(a,b){var z,y,x
z=H.j([],[H.A(this,"aE",0)])
C.b.sj(z,this.gj(this))
for(y=0;y<this.gj(this);++y){x=this.H(0,y)
if(y>=z.length)return H.a(z,y)
z[y]=x}return z},
aL:function(a){return this.at(a,!0)}},
fD:{"^":"aE;a,b,c,$ti",
gdf:function(){var z=J.D(this.a)
return z},
gdB:function(){var z,y
z=J.D(this.a)
y=this.b
if(y>z)return z
return y},
gj:function(a){var z,y
z=J.D(this.a)
y=this.b
if(y>=z)return 0
return z-y},
H:function(a,b){var z,y
z=this.gdB()+b
if(b>=0){y=this.gdf()
if(typeof y!=="number")return H.w(y)
y=z>=y}else y=!0
if(y)throw H.c(P.aC(b,this,"index",null,null))
return J.cl(this.a,z)},
at:function(a,b){var z,y,x,w,v,u,t,s
z=this.b
y=this.a
x=J.z(y)
w=x.gj(y)
v=w-z
if(v<0)v=0
u=H.j(new Array(v),this.$ti)
for(t=0;t<v;++t){s=x.H(y,z+t)
if(t>=u.length)return H.a(u,t)
u[t]=s
if(x.gj(y)<w)throw H.c(new P.S(this))}return u}},
a2:{"^":"b;a,b,c,d",
gt:function(){return this.d},
k:function(){var z,y,x,w
z=this.a
y=J.z(z)
x=y.gj(z)
if(this.b!==x)throw H.c(new P.S(z))
w=this.c
if(w>=x){this.d=null
return!1}this.d=y.H(z,w);++this.c
return!0}},
bR:{"^":"J;a,b,$ti",
gv:function(a){return new H.fg(null,J.aU(this.a),this.b,this.$ti)},
gj:function(a){return J.D(this.a)},
$asJ:function(a,b){return[b]},
p:{
bf:function(a,b,c,d){if(!!J.n(a).$isi)return new H.bE(a,b,[c,d])
return new H.bR(a,b,[c,d])}}},
bE:{"^":"bR;a,b,$ti",$isi:1,
$asi:function(a,b){return[b]}},
fg:{"^":"cH;a,b,c,$ti",
k:function(){var z=this.b
if(z.k()){this.a=this.c.$1(z.gt())
return!0}this.a=null
return!1},
gt:function(){return this.a}},
b0:{"^":"aE;a,b,$ti",
gj:function(a){return J.D(this.a)},
H:function(a,b){return this.b.$1(J.cl(this.a,b))},
$asaE:function(a,b){return[b]},
$asi:function(a,b){return[b]},
$asJ:function(a,b){return[b]}},
dn:{"^":"J;a,b,$ti",
gv:function(a){return new H.h7(J.aU(this.a),this.b,this.$ti)},
Y:function(a,b){return new H.bR(this,b,[H.a4(this,0),null])}},
h7:{"^":"cH;a,b,$ti",
k:function(){var z,y
for(z=this.a,y=this.b;z.k();)if(y.$1(z.gt())===!0)return!0
return!1},
gt:function(){return this.a.gt()}},
cB:{"^":"b;$ti",
sj:function(a,b){throw H.c(new P.t("Cannot change the length of a fixed-length list"))},
u:function(a,b){throw H.c(new P.t("Cannot remove from a fixed-length list"))},
ac:function(a,b){throw H.c(new P.t("Cannot remove from a fixed-length list"))}}}],["","",,H,{"^":"",
b4:function(a,b){var z=a.am(b)
if(!init.globalState.d.cy)init.globalState.f.as()
return z},
dY:function(a,b){var z,y,x,w,v,u
z={}
z.a=b
if(b==null){b=[]
z.a=b
y=b}else y=b
if(!J.n(y).$ish)throw H.c(P.b8("Arguments to main must be a List: "+H.d(y)))
init.globalState=new H.hT(0,0,1,null,null,null,null,null,null,null,null,null,a)
y=init.globalState
x=self.window==null
w=self.Worker
v=x&&!!self.postMessage
y.x=v
v=!v
if(v)w=w!=null&&$.$get$cE()!=null
else w=!0
y.y=w
y.r=x&&v
y.f=new H.ho(P.bQ(null,H.b3),0)
x=P.k
y.z=new H.aj(0,null,null,null,null,null,0,[x,H.c9])
y.ch=new H.aj(0,null,null,null,null,null,0,[x,null])
if(y.x===!0){w=new H.hS()
y.Q=w
self.onmessage=function(c,d){return function(e){c(d,e)}}(H.eV,w)
self.dartPrint=self.dartPrint||function(c){return function(d){if(self.console&&self.console.log)self.console.log(d)
else self.postMessage(c(d))}}(H.hU)}if(init.globalState.x===!0)return
y=init.globalState.a++
w=new H.aj(0,null,null,null,null,null,0,[x,H.bi])
x=P.M(null,null,null,x)
v=new H.bi(0,null,!1)
u=new H.c9(y,w,x,init.createNewIsolate(),v,new H.ag(H.bx()),new H.ag(H.bx()),!1,!1,[],P.M(null,null,null,null),null,null,!1,!0,P.M(null,null,null,null))
x.A(0,0)
u.bB(0,v)
init.globalState.e=u
init.globalState.d=u
if(H.as(a,{func:1,args:[,]}))u.am(new H.j5(z,a))
else if(H.as(a,{func:1,args:[,,]}))u.am(new H.j6(z,a))
else u.am(a)
init.globalState.f.as()},
eZ:function(){var z=init.currentScript
if(z!=null)return String(z.src)
if(init.globalState.x===!0)return H.f_()
return},
f_:function(){var z,y
z=new Error().stack
if(z==null){z=function(){try{throw new Error()}catch(x){return x.stack}}()
if(z==null)throw H.c(new P.t("No stack trace"))}y=z.match(new RegExp("^ *at [^(]*\\((.*):[0-9]*:[0-9]*\\)$","m"))
if(y!=null)return y[1]
y=z.match(new RegExp("^[^@]*@(.*):[0-9]*$","m"))
if(y!=null)return y[1]
throw H.c(new P.t('Cannot extract URI from "'+H.d(z)+'"'))},
eV:function(a,b){var z,y,x,w,v,u,t,s,r,q,p,o,n
z=new H.bl(!0,[]).a1(b.data)
y=J.z(z)
switch(y.h(z,"command")){case"start":init.globalState.b=y.h(z,"id")
x=y.h(z,"functionName")
w=x==null?init.globalState.cx:init.globalFunctions[x]()
v=y.h(z,"args")
u=new H.bl(!0,[]).a1(y.h(z,"msg"))
t=y.h(z,"isSpawnUri")
s=y.h(z,"startPaused")
r=new H.bl(!0,[]).a1(y.h(z,"replyTo"))
y=init.globalState.a++
q=P.k
p=new H.aj(0,null,null,null,null,null,0,[q,H.bi])
q=P.M(null,null,null,q)
o=new H.bi(0,null,!1)
n=new H.c9(y,p,q,init.createNewIsolate(),o,new H.ag(H.bx()),new H.ag(H.bx()),!1,!1,[],P.M(null,null,null,null),null,null,!1,!0,P.M(null,null,null,null))
q.A(0,0)
n.bB(0,o)
init.globalState.f.a.V(new H.b3(n,new H.eW(w,v,u,t,s,r),"worker-start"))
init.globalState.d=n
init.globalState.f.as()
break
case"spawn-worker":break
case"message":if(y.h(z,"port")!=null)J.ay(y.h(z,"port"),y.h(z,"msg"))
init.globalState.f.as()
break
case"close":init.globalState.ch.u(0,$.$get$cF().h(0,a))
a.terminate()
init.globalState.f.as()
break
case"log":H.eU(y.h(z,"msg"))
break
case"print":if(init.globalState.x===!0){y=init.globalState.Q
q=P.aD(["command","print","msg",z])
q=new H.an(!0,P.aJ(null,P.k)).J(q)
y.toString
self.postMessage(q)}else P.ch(y.h(z,"msg"))
break
case"error":throw H.c(y.h(z,"msg"))}},
eU:function(a){var z,y,x,w
if(init.globalState.x===!0){y=init.globalState.Q
x=P.aD(["command","log","msg",a])
x=new H.an(!0,P.aJ(null,P.k)).J(x)
y.toString
self.postMessage(x)}else try{self.console.log(a)}catch(w){H.B(w)
z=H.N(w)
throw H.c(P.bb(z))}},
eX:function(a,b,c,d,e,f){var z,y,x,w
z=init.globalState.d
y=z.a
$.cU=$.cU+("_"+y)
$.cV=$.cV+("_"+y)
y=z.e
x=init.globalState.d.a
w=z.f
J.ay(f,["spawned",new H.bp(y,x),w,z.r])
x=new H.eY(a,b,c,d,z)
if(e===!0){z.c9(w,w)
init.globalState.f.a.V(new H.b3(z,x,"start isolate"))}else x.$0()},
is:function(a){return new H.bl(!0,[]).a1(new H.an(!1,P.aJ(null,P.k)).J(a))},
j5:{"^":"e:0;a,b",
$0:function(){this.b.$1(this.a.a)}},
j6:{"^":"e:0;a,b",
$0:function(){this.b.$2(this.a.a,null)}},
hT:{"^":"b;a,b,c,d,e,f,r,x,y,z,Q,ch,cx",p:{
hU:function(a){var z=P.aD(["command","print","msg",a])
return new H.an(!0,P.aJ(null,P.k)).J(z)}}},
c9:{"^":"b;a5:a>,b,c,em:d<,dR:e<,f,r,x,y,z,Q,ch,cx,cy,db,dx",
c9:function(a,b){if(!this.f.w(0,a))return
if(this.Q.A(0,b)&&!this.y)this.y=!0
this.b9()},
eO:function(a){var z,y,x,w,v,u
if(!this.y)return
z=this.Q
z.u(0,a)
if(z.a===0){for(z=this.z;y=z.length,y!==0;){if(0>=y)return H.a(z,-1)
x=z.pop()
y=init.globalState.f.a
w=y.b
v=y.a
u=v.length
w=(w-1&u-1)>>>0
y.b=w
if(w<0||w>=u)return H.a(v,w)
v[w]=x
if(w===y.c)y.bL();++y.d}this.y=!1}this.b9()},
dG:function(a,b){var z,y,x
if(this.ch==null)this.ch=[]
for(z=J.n(a),y=0;x=this.ch,y<x.length;y+=2)if(z.w(a,x[y])){z=this.ch
x=y+1
if(x>=z.length)return H.a(z,x)
z[x]=b
return}x.push(a)
this.ch.push(b)},
eF:function(a){var z,y,x
if(this.ch==null)return
for(z=J.n(a),y=0;x=this.ch,y<x.length;y+=2)if(z.w(a,x[y])){z=this.ch
x=y+2
z.toString
if(typeof z!=="object"||z===null||!!z.fixed$length)H.v(new P.t("removeRange"))
P.c_(y,x,z.length,null,null,null)
z.splice(y,x-y)
return}},
cO:function(a,b){if(!this.r.w(0,a))return
this.db=b},
eb:function(a,b,c){var z=J.n(b)
if(!z.w(b,0))z=z.w(b,1)&&!this.cy
else z=!0
if(z){J.ay(a,c)
return}z=this.cx
if(z==null){z=P.bQ(null,null)
this.cx=z}z.V(new H.hI(a,c))},
ea:function(a,b){var z
if(!this.r.w(0,a))return
z=J.n(b)
if(!z.w(b,0))z=z.w(b,1)&&!this.cy
else z=!0
if(z){this.bh()
return}z=this.cx
if(z==null){z=P.bQ(null,null)
this.cx=z}z.V(this.gen())},
ec:function(a,b){var z,y,x
z=this.dx
if(z.a===0){if(this.db===!0&&this===init.globalState.e)return
if(self.console&&self.console.error)self.console.error(a,b)
else{P.ch(a)
if(b!=null)P.ch(b)}return}y=new Array(2)
y.fixed$length=Array
y[0]=J.E(a)
y[1]=b==null?null:J.E(b)
for(x=new P.bo(z,z.r,null,null),x.c=z.e;x.k();)J.ay(x.d,y)},
am:function(a){var z,y,x,w,v,u,t
z=init.globalState.d
init.globalState.d=this
$=this.d
y=null
x=this.cy
this.cy=!0
try{y=a.$0()}catch(u){t=H.B(u)
w=t
v=H.N(u)
this.ec(w,v)
if(this.db===!0){this.bh()
if(this===init.globalState.e)throw u}}finally{this.cy=x
init.globalState.d=z
if(z!=null)$=z.gem()
if(this.cx!=null)for(;t=this.cx,!t.gG(t);)this.cx.cq().$0()}return y},
bj:function(a){return this.b.h(0,a)},
bB:function(a,b){var z=this.b
if(z.aa(a))throw H.c(P.bb("Registry: ports must be registered only once."))
z.n(0,a,b)},
b9:function(){var z=this.b
if(z.gj(z)-this.c.a>0||this.y||!this.x)init.globalState.z.n(0,this.a,this)
else this.bh()},
bh:[function(){var z,y,x,w,v
z=this.cx
if(z!=null)z.K(0)
for(z=this.b,y=z.gcB(z),y=y.gv(y);y.k();)y.gt().da()
z.K(0)
this.c.K(0)
init.globalState.z.u(0,this.a)
this.dx.K(0)
if(this.ch!=null){for(x=0;z=this.ch,y=z.length,x<y;x+=2){w=z[x]
v=x+1
if(v>=y)return H.a(z,v)
J.ay(w,z[v])}this.ch=null}},"$0","gen",0,0,2]},
hI:{"^":"e:2;a,b",
$0:function(){J.ay(this.a,this.b)}},
ho:{"^":"b;a,b",
e_:function(){var z=this.a
if(z.b===z.c)return
return z.cq()},
cu:function(){var z,y,x
z=this.e_()
if(z==null){if(init.globalState.e!=null)if(init.globalState.z.aa(init.globalState.e.a))if(init.globalState.r===!0){y=init.globalState.e.b
y=y.gG(y)}else y=!1
else y=!1
else y=!1
if(y)H.v(P.bb("Program exited with open ReceivePorts."))
y=init.globalState
if(y.x===!0){x=y.z
x=x.gG(x)&&y.f.b===0}else x=!1
if(x){y=y.Q
x=P.aD(["command","close"])
x=new H.an(!0,new P.dA(0,null,null,null,null,null,0,[null,P.k])).J(x)
y.toString
self.postMessage(x)}return!1}z.eD()
return!0},
bY:function(){if(self.window!=null)new H.hp(this).$0()
else for(;this.cu(););},
as:function(){var z,y,x,w,v
if(init.globalState.x!==!0)this.bY()
else try{this.bY()}catch(x){w=H.B(x)
z=w
y=H.N(x)
w=init.globalState.Q
v=P.aD(["command","error","msg",H.d(z)+"\n"+H.d(y)])
v=new H.an(!0,P.aJ(null,P.k)).J(v)
w.toString
self.postMessage(v)}}},
hp:{"^":"e:2;a",
$0:function(){if(!this.a.cu())return
P.h3(C.B,this)}},
b3:{"^":"b;a,b,c",
eD:function(){var z=this.a
if(z.y){z.z.push(this)
return}z.am(this.b)}},
hS:{"^":"b;"},
eW:{"^":"e:0;a,b,c,d,e,f",
$0:function(){H.eX(this.a,this.b,this.c,this.d,this.e,this.f)}},
eY:{"^":"e:2;a,b,c,d,e",
$0:function(){var z,y
z=this.e
z.x=!0
if(this.d!==!0)this.a.$1(this.c)
else{y=this.a
if(H.as(y,{func:1,args:[,,]}))y.$2(this.b,this.c)
else if(H.as(y,{func:1,args:[,]}))y.$1(this.b)
else y.$0()}z.b9()}},
dq:{"^":"b;"},
bp:{"^":"dq;b,a",
av:function(a,b){var z,y,x
z=init.globalState.z.h(0,this.a)
if(z==null)return
y=this.b
if(y.gbP())return
x=H.is(b)
if(z.gdR()===y){y=J.z(x)
switch(y.h(x,0)){case"pause":z.c9(y.h(x,1),y.h(x,2))
break
case"resume":z.eO(y.h(x,1))
break
case"add-ondone":z.dG(y.h(x,1),y.h(x,2))
break
case"remove-ondone":z.eF(y.h(x,1))
break
case"set-errors-fatal":z.cO(y.h(x,1),y.h(x,2))
break
case"ping":z.eb(y.h(x,1),y.h(x,2),y.h(x,3))
break
case"kill":z.ea(y.h(x,1),y.h(x,2))
break
case"getErrors":y=y.h(x,1)
z.dx.A(0,y)
break
case"stopErrors":y=y.h(x,1)
z.dx.u(0,y)
break}return}init.globalState.f.a.V(new H.b3(z,new H.i0(this,x),"receive"))},
w:function(a,b){if(b==null)return!1
return b instanceof H.bp&&J.x(this.b,b.b)},
gC:function(a){return this.b.gb1()}},
i0:{"^":"e:0;a,b",
$0:function(){var z=this.a.b
if(!z.gbP())z.d7(this.b)}},
ca:{"^":"dq;b,c,a",
av:function(a,b){var z,y,x
z=P.aD(["command","message","port",this,"msg",b])
y=new H.an(!0,P.aJ(null,P.k)).J(z)
if(init.globalState.x===!0){init.globalState.Q.toString
self.postMessage(y)}else{x=init.globalState.ch.h(0,this.b)
if(x!=null)x.postMessage(y)}},
w:function(a,b){if(b==null)return!1
return b instanceof H.ca&&J.x(this.b,b.b)&&J.x(this.a,b.a)&&J.x(this.c,b.c)},
gC:function(a){var z,y,x
z=this.b
if(typeof z!=="number")return z.cP()
y=this.a
if(typeof y!=="number")return y.cP()
x=this.c
if(typeof x!=="number")return H.w(x)
return(z<<16^y<<8^x)>>>0}},
bi:{"^":"b;b1:a<,b,bP:c<",
da:function(){this.c=!0
this.b=null},
d7:function(a){if(this.c)return
this.b.$1(a)},
$isfq:1},
d9:{"^":"b;a,b,c",
d0:function(a,b){if(self.setTimeout!=null){++init.globalState.f.b
this.c=self.setInterval(H.ar(new H.h0(this,b),0),a)}else throw H.c(new P.t("Periodic timer."))},
d_:function(a,b){var z,y
if(a===0)z=self.setTimeout==null||init.globalState.x===!0
else z=!1
if(z){this.c=1
z=init.globalState.f
y=init.globalState.d
z.a.V(new H.b3(y,new H.h1(this,b),"timer"))
this.b=!0}else if(self.setTimeout!=null){++init.globalState.f.b
this.c=self.setTimeout(H.ar(new H.h2(this,b),0),a)}else throw H.c(new P.t("Timer greater than 0."))},
p:{
fZ:function(a,b){var z=new H.d9(!0,!1,null)
z.d_(a,b)
return z},
h_:function(a,b){var z=new H.d9(!1,!1,null)
z.d0(a,b)
return z}}},
h1:{"^":"e:2;a,b",
$0:function(){this.a.c=null
this.b.$0()}},
h2:{"^":"e:2;a,b",
$0:function(){this.a.c=null;--init.globalState.f.b
this.b.$0()}},
h0:{"^":"e:0;a,b",
$0:function(){this.b.$1(this.a)}},
ag:{"^":"b;b1:a<",
gC:function(a){var z=this.a
if(typeof z!=="number")return z.f1()
z=C.a.c2(z,0)^C.a.D(z,4294967296)
z=(~z>>>0)+(z<<15>>>0)&4294967295
z=((z^z>>>12)>>>0)*5&4294967295
z=((z^z>>>4)>>>0)*2057&4294967295
return(z^z>>>16)>>>0},
w:function(a,b){var z,y
if(b==null)return!1
if(b===this)return!0
if(b instanceof H.ag){z=this.a
y=b.a
return z==null?y==null:z===y}return!1}},
an:{"^":"b;a,b",
J:[function(a){var z,y,x,w,v
if(a==null||typeof a==="string"||typeof a==="number"||typeof a==="boolean")return a
z=this.b
y=z.h(0,a)
if(y!=null)return["ref",y]
z.n(0,a,z.gj(z))
z=J.n(a)
if(!!z.$isbS)return["buffer",a]
if(!!z.$isbU)return["typed",a]
if(!!z.$isK)return this.cJ(a)
if(!!z.$iseT){x=this.gcG()
w=a.gR()
w=H.bf(w,x,H.A(w,"J",0),null)
w=P.be(w,!0,H.A(w,"J",0))
z=z.gcB(a)
z=H.bf(z,x,H.A(z,"J",0),null)
return["map",w,P.be(z,!0,H.A(z,"J",0))]}if(!!z.$isf5)return this.cK(a)
if(!!z.$isf)this.cv(a)
if(!!z.$isfq)this.au(a,"RawReceivePorts can't be transmitted:")
if(!!z.$isbp)return this.cL(a)
if(!!z.$isca)return this.cM(a)
if(!!z.$ise){v=a.$static_name
if(v==null)this.au(a,"Closures can't be transmitted:")
return["function",v]}if(!!z.$isag)return["capability",a.a]
if(!(a instanceof P.b))this.cv(a)
return["dart",init.classIdExtractor(a),this.cI(init.classFieldsExtractor(a))]},"$1","gcG",2,0,1],
au:function(a,b){throw H.c(new P.t(H.d(b==null?"Can't transmit:":b)+" "+H.d(a)))},
cv:function(a){return this.au(a,null)},
cJ:function(a){var z=this.cH(a)
if(!!a.fixed$length)return["fixed",z]
if(!a.fixed$length)return["extendable",z]
if(!a.immutable$list)return["mutable",z]
if(a.constructor===Array)return["const",z]
this.au(a,"Can't serialize indexable: ")},
cH:function(a){var z,y,x
z=[]
C.b.sj(z,a.length)
for(y=0;y<a.length;++y){x=this.J(a[y])
if(y>=z.length)return H.a(z,y)
z[y]=x}return z},
cI:function(a){var z
for(z=0;z<a.length;++z)C.b.n(a,z,this.J(a[z]))
return a},
cK:function(a){var z,y,x,w
if(!!a.constructor&&a.constructor!==Object)this.au(a,"Only plain JS Objects are supported:")
z=Object.keys(a)
y=[]
C.b.sj(y,z.length)
for(x=0;x<z.length;++x){w=this.J(a[z[x]])
if(x>=y.length)return H.a(y,x)
y[x]=w}return["js-object",z,y]},
cM:function(a){if(this.a)return["sendport",a.b,a.a,a.c]
return["raw sendport",a]},
cL:function(a){if(this.a)return["sendport",init.globalState.b,a.a,a.b.gb1()]
return["raw sendport",a]}},
bl:{"^":"b;a,b",
a1:[function(a){var z,y,x,w,v,u
if(a==null||typeof a==="string"||typeof a==="number"||typeof a==="boolean")return a
if(typeof a!=="object"||a===null||a.constructor!==Array)throw H.c(P.b8("Bad serialized message: "+H.d(a)))
switch(C.b.ge5(a)){case"ref":if(1>=a.length)return H.a(a,1)
z=a[1]
y=this.b
if(z>>>0!==z||z>=y.length)return H.a(y,z)
return y[z]
case"buffer":if(1>=a.length)return H.a(a,1)
x=a[1]
this.b.push(x)
return x
case"typed":if(1>=a.length)return H.a(a,1)
x=a[1]
this.b.push(x)
return x
case"fixed":if(1>=a.length)return H.a(a,1)
x=a[1]
this.b.push(x)
y=H.j(this.al(x),[null])
y.fixed$length=Array
return y
case"extendable":if(1>=a.length)return H.a(a,1)
x=a[1]
this.b.push(x)
return H.j(this.al(x),[null])
case"mutable":if(1>=a.length)return H.a(a,1)
x=a[1]
this.b.push(x)
return this.al(x)
case"const":if(1>=a.length)return H.a(a,1)
x=a[1]
this.b.push(x)
y=H.j(this.al(x),[null])
y.fixed$length=Array
return y
case"map":return this.e2(a)
case"sendport":return this.e3(a)
case"raw sendport":if(1>=a.length)return H.a(a,1)
x=a[1]
this.b.push(x)
return x
case"js-object":return this.e1(a)
case"function":if(1>=a.length)return H.a(a,1)
x=init.globalFunctions[a[1]]()
this.b.push(x)
return x
case"capability":if(1>=a.length)return H.a(a,1)
return new H.ag(a[1])
case"dart":y=a.length
if(1>=y)return H.a(a,1)
w=a[1]
if(2>=y)return H.a(a,2)
v=a[2]
u=init.instanceFromClassId(w)
this.b.push(u)
this.al(v)
return init.initializeEmptyInstance(w,u,v)
default:throw H.c("couldn't deserialize: "+H.d(a))}},"$1","ge0",2,0,1],
al:function(a){var z,y,x
z=J.z(a)
y=0
while(!0){x=z.gj(a)
if(typeof x!=="number")return H.w(x)
if(!(y<x))break
z.n(a,y,this.a1(z.h(a,y)));++y}return a},
e2:function(a){var z,y,x,w,v,u
z=a.length
if(1>=z)return H.a(a,1)
y=a[1]
if(2>=z)return H.a(a,2)
x=a[2]
w=P.bO()
this.b.push(w)
y=J.ee(y,this.ge0()).aL(0)
for(z=J.z(y),v=J.z(x),u=0;u<z.gj(y);++u){if(u>=y.length)return H.a(y,u)
w.n(0,y[u],this.a1(v.h(x,u)))}return w},
e3:function(a){var z,y,x,w,v,u,t
z=a.length
if(1>=z)return H.a(a,1)
y=a[1]
if(2>=z)return H.a(a,2)
x=a[2]
if(3>=z)return H.a(a,3)
w=a[3]
if(J.x(y,init.globalState.b)){v=init.globalState.z.h(0,x)
if(v==null)return
u=v.bj(w)
if(u==null)return
t=new H.bp(u,x)}else t=new H.ca(y,w,x)
this.b.push(t)
return t},
e1:function(a){var z,y,x,w,v,u,t
z=a.length
if(1>=z)return H.a(a,1)
y=a[1]
if(2>=z)return H.a(a,2)
x=a[2]
w={}
this.b.push(w)
z=J.z(y)
v=J.z(x)
u=0
while(!0){t=z.gj(y)
if(typeof t!=="number")return H.w(t)
if(!(u<t))break
w[z.h(y,u)]=this.a1(v.h(x,u));++u}return w}}}],["","",,H,{"^":"",
iN:function(a){return init.types[a]},
dT:function(a,b){var z
if(b!=null){z=b.x
if(z!=null)return z}return!!J.n(a).$isP},
d:function(a){var z
if(typeof a==="string")return a
if(typeof a==="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
z=J.E(a)
if(typeof z!=="string")throw H.c(H.L(a))
return z},
a9:function(a){var z=a.$identityHash
if(z==null){z=Math.random()*0x3fffffff|0
a.$identityHash=z}return z},
cT:function(a,b){throw H.c(new P.bI(a,null,null))},
ak:function(a,b,c){var z,y
H.iH(a)
z=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(z==null)return H.cT(a,c)
if(3>=z.length)return H.a(z,3)
y=z[3]
if(y!=null)return parseInt(a,10)
if(z[2]!=null)return parseInt(a,16)
return H.cT(a,c)},
cW:function(a){var z,y,x,w,v,u,t,s
z=J.n(a)
y=z.constructor
if(typeof y=="function"){x=y.name
w=typeof x==="string"?x:null}else w=null
if(w==null||z===C.O||!!J.n(a).$isb2){v=C.D(a)
if(v==="Object"){u=a.constructor
if(typeof u=="function"){t=String(u).match(/^\s*function\s*([\w$]*)\s*\(/)
s=t==null?null:t[1]
if(typeof s==="string"&&/^\w+$/.test(s))w=s}if(w==null)w=v}else w=v}w=w
if(w.length>1&&C.e.aw(w,0)===36)w=C.e.U(w,1)
return function(b,c){return b.replace(/[^<,> ]+/g,function(d){return c[d]||d})}(w+H.dU(H.bu(a),0,null),init.mangledGlobalNames)},
bh:function(a){return"Instance of '"+H.cW(a)+"'"},
kf:[function(){return Date.now()},"$0","iv",0,0,22],
bY:function(){var z,y
if($.aF!=null)return
$.aF=1000
$.T=H.iv()
if(typeof window=="undefined")return
z=window
if(z==null)return
y=z.performance
if(y==null)return
if(typeof y.now!="function")return
$.aF=1e6
$.T=new H.fp(y)},
bX:function(a,b){if(a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string")throw H.c(H.L(a))
return a[b]},
cX:function(a,b,c){if(a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string")throw H.c(H.L(a))
a[b]=c},
w:function(a){throw H.c(H.L(a))},
a:function(a,b){if(a==null)J.D(a)
throw H.c(H.y(a,b))},
y:function(a,b){var z,y
if(typeof b!=="number"||Math.floor(b)!==b)return new P.a6(!0,b,"index",null)
z=J.D(a)
if(!(b<0)){if(typeof z!=="number")return H.w(z)
y=b>=z}else y=!0
if(y)return P.aC(b,a,"index",null,z)
return P.aG(b,"index",null)},
L:function(a){return new P.a6(!0,a,null,null)},
iH:function(a){if(typeof a!=="string")throw H.c(H.L(a))
return a},
c:function(a){var z
if(a==null)a=new P.bW()
z=new Error()
z.dartException=a
if("defineProperty" in Object){Object.defineProperty(z,"message",{get:H.e_})
z.name=""}else z.toString=H.e_
return z},
e_:function(){return J.E(this.dartException)},
v:function(a){throw H.c(a)},
a5:function(a){throw H.c(new P.S(a))},
B:function(a){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l
z=new H.j9(a)
if(a==null)return
if(a instanceof H.bH)return z.$1(a.a)
if(typeof a!=="object")return a
if("dartException" in a)return z.$1(a.dartException)
else if(!("message" in a))return a
y=a.message
if("number" in a&&typeof a.number=="number"){x=a.number
w=x&65535
if((C.c.c2(x,16)&8191)===10)switch(w){case 438:return z.$1(H.bN(H.d(y)+" (Error "+w+")",null))
case 445:case 5007:v=H.d(y)+" (Error "+w+")"
return z.$1(new H.cS(v,null))}}if(a instanceof TypeError){u=$.$get$db()
t=$.$get$dc()
s=$.$get$dd()
r=$.$get$de()
q=$.$get$di()
p=$.$get$dj()
o=$.$get$dg()
$.$get$df()
n=$.$get$dl()
m=$.$get$dk()
l=u.M(y)
if(l!=null)return z.$1(H.bN(y,l))
else{l=t.M(y)
if(l!=null){l.method="call"
return z.$1(H.bN(y,l))}else{l=s.M(y)
if(l==null){l=r.M(y)
if(l==null){l=q.M(y)
if(l==null){l=p.M(y)
if(l==null){l=o.M(y)
if(l==null){l=r.M(y)
if(l==null){l=n.M(y)
if(l==null){l=m.M(y)
v=l!=null}else v=!0}else v=!0}else v=!0}else v=!0}else v=!0}else v=!0}else v=!0
if(v)return z.$1(new H.cS(y,l==null?null:l.method))}}return z.$1(new H.h6(typeof y==="string"?y:""))}if(a instanceof RangeError){if(typeof y==="string"&&y.indexOf("call stack")!==-1)return new P.d1()
y=function(b){try{return String(b)}catch(k){}return null}(a)
return z.$1(new P.a6(!1,null,null,typeof y==="string"?y.replace(/^RangeError:\s*/,""):y))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof y==="string"&&y==="too much recursion")return new P.d1()
return a},
N:function(a){var z
if(a instanceof H.bH)return a.b
if(a==null)return new H.dC(a,null)
z=a.$cachedTrace
if(z!=null)return z
return a.$cachedTrace=new H.dC(a,null)},
j3:function(a){if(a==null||typeof a!='object')return J.W(a)
else return H.a9(a)},
iM:function(a,b){var z,y,x,w
z=a.length
for(y=0;y<z;y=w){x=y+1
w=x+1
b.n(0,a[y],a[x])}return b},
iW:function(a,b,c,d,e,f,g){switch(c){case 0:return H.b4(b,new H.iX(a))
case 1:return H.b4(b,new H.iY(a,d))
case 2:return H.b4(b,new H.iZ(a,d,e))
case 3:return H.b4(b,new H.j_(a,d,e,f))
case 4:return H.b4(b,new H.j0(a,d,e,f,g))}throw H.c(P.bb("Unsupported number of arguments for wrapped closure"))},
ar:function(a,b){var z
if(a==null)return
z=a.$identity
if(!!z)return z
z=function(c,d,e,f){return function(g,h,i,j){return f(c,e,d,g,h,i,j)}}(a,b,init.globalState.d,H.iW)
a.$identity=z
return z},
er:function(a,b,c,d,e,f){var z,y,x,w,v,u,t,s,r,q,p,o,n,m
z=b[0]
y=z.$callName
if(!!J.n(c).$ish){z.$reflectionInfo=c
x=H.fs(z).r}else x=c
w=d?Object.create(new H.fx().constructor.prototype):Object.create(new H.bB(null,null,null,null).constructor.prototype)
w.$initialize=w.constructor
if(d)v=function(){this.$initialize()}
else{u=$.X
$.X=J.ax(u,1)
u=new Function("a,b,c,d"+u,"this.$initialize(a,b,c,d"+u+")")
v=u}w.constructor=v
v.prototype=w
if(!d){t=e.length==1&&!0
s=H.cu(a,z,t)
s.$reflectionInfo=c}else{w.$static_name=f
s=z
t=!1}if(typeof x=="number")r=function(g,h){return function(){return g(h)}}(H.iN,x)
else if(typeof x=="function")if(d)r=x
else{q=t?H.ct:H.bC
r=function(g,h){return function(){return g.apply({$receiver:h(this)},arguments)}}(x,q)}else throw H.c("Error in reflectionInfo.")
w.$signature=r
w[y]=s
for(u=b.length,p=1;p<u;++p){o=b[p]
n=o.$callName
if(n!=null){m=d?o:H.cu(a,o,t)
w[n]=m}}w["call*"]=s
w.$requiredArgCount=z.$requiredArgCount
w.$defaultValues=z.$defaultValues
return v},
eo:function(a,b,c,d){var z=H.bC
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,z)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,z)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,z)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,z)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,z)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,z)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,z)}},
cu:function(a,b,c){var z,y,x,w,v,u,t
if(c)return H.eq(a,b)
z=b.$stubName
y=b.length
x=a[z]
w=b==null?x==null:b===x
v=!w||y>=27
if(v)return H.eo(y,!w,z,b)
if(y===0){w=$.X
$.X=J.ax(w,1)
u="self"+H.d(w)
w="return function(){var "+u+" = this."
v=$.az
if(v==null){v=H.ba("self")
$.az=v}return new Function(w+H.d(v)+";return "+u+"."+H.d(z)+"();}")()}t="abcdefghijklmnopqrstuvwxyz".split("").splice(0,y).join(",")
w=$.X
$.X=J.ax(w,1)
t+=H.d(w)
w="return function("+t+"){return this."
v=$.az
if(v==null){v=H.ba("self")
$.az=v}return new Function(w+H.d(v)+"."+H.d(z)+"("+t+");}")()},
ep:function(a,b,c,d){var z,y
z=H.bC
y=H.ct
switch(b?-1:a){case 0:throw H.c(new H.fu("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,z,y)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,z,y)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,z,y)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,z,y)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,z,y)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,z,y)
default:return function(e,f,g,h){return function(){h=[g(this)]
Array.prototype.push.apply(h,arguments)
return e.apply(f(this),h)}}(d,z,y)}},
eq:function(a,b){var z,y,x,w,v,u,t,s
z=H.en()
y=$.cs
if(y==null){y=H.ba("receiver")
$.cs=y}x=b.$stubName
w=b.length
v=a[x]
u=b==null?v==null:b===v
t=!u||w>=28
if(t)return H.ep(w,!u,x,b)
if(w===1){y="return function(){return this."+H.d(z)+"."+H.d(x)+"(this."+H.d(y)+");"
u=$.X
$.X=J.ax(u,1)
return new Function(y+H.d(u)+"}")()}s="abcdefghijklmnopqrstuvwxyz".split("").splice(0,w-1).join(",")
y="return function("+s+"){return this."+H.d(z)+"."+H.d(x)+"(this."+H.d(y)+", "+s+");"
u=$.X
$.X=J.ax(u,1)
return new Function(y+H.d(u)+"}")()},
cd:function(a,b,c,d,e,f){var z
b.fixed$length=Array
if(!!J.n(c).$ish){c.fixed$length=Array
z=c}else z=c
return H.er(a,b,z,!!d,e,f)},
iK:function(a){var z=J.n(a)
return"$signature" in z?z.$signature():null},
as:function(a,b){var z
if(a==null)return!1
z=H.iK(a)
return z==null?!1:H.dS(z,b)},
j8:function(a){throw H.c(new P.ey(a))},
bx:function(){return(Math.random()*0x100000000>>>0)+(Math.random()*0x100000000>>>0)*4294967296},
dQ:function(a){return init.getIsolateTag(a)},
j:function(a,b){a.$ti=b
return a},
bu:function(a){if(a==null)return
return a.$ti},
dR:function(a,b){return H.ci(a["$as"+H.d(b)],H.bu(a))},
A:function(a,b,c){var z=H.dR(a,b)
return z==null?null:z[c]},
a4:function(a,b){var z=H.bu(a)
return z==null?null:z[b]},
aw:function(a,b){var z
if(a==null)return"dynamic"
if(typeof a==="object"&&a!==null&&a.constructor===Array)return a[0].builtin$cls+H.dU(a,1,b)
if(typeof a=="function")return a.builtin$cls
if(typeof a==="number"&&Math.floor(a)===a)return H.d(a)
if(typeof a.func!="undefined"){z=a.typedef
if(z!=null)return H.aw(z,b)
return H.it(a,b)}return"unknown-reified-type"},
it:function(a,b){var z,y,x,w,v,u,t,s,r,q,p
z=!!a.v?"void":H.aw(a.ret,b)
if("args" in a){y=a.args
for(x=y.length,w="",v="",u=0;u<x;++u,v=", "){t=y[u]
w=w+v+H.aw(t,b)}}else{w=""
v=""}if("opt" in a){s=a.opt
w+=v+"["
for(x=s.length,v="",u=0;u<x;++u,v=", "){t=s[u]
w=w+v+H.aw(t,b)}w+="]"}if("named" in a){r=a.named
w+=v+"{"
for(x=H.iL(r),q=x.length,v="",u=0;u<q;++u,v=", "){p=x[u]
w=w+v+H.aw(r[p],b)+(" "+H.d(p))}w+="}"}return"("+w+") => "+z},
dU:function(a,b,c){var z,y,x,w,v,u
if(a==null)return""
z=new P.c1("")
for(y=b,x=!0,w=!0,v="";y<a.length;++y){if(x)x=!1
else z.B=v+", "
u=a[y]
if(u!=null)w=!1
v=z.B+=H.aw(u,c)}return w?"":"<"+z.i(0)+">"},
ci:function(a,b){if(a==null)return b
a=a.apply(null,b)
if(a==null)return
if(typeof a==="object"&&a!==null&&a.constructor===Array)return a
if(typeof a=="function")return a.apply(null,b)
return b},
b6:function(a,b,c,d){var z,y
if(a==null)return!1
z=H.bu(a)
y=J.n(a)
if(y[b]==null)return!1
return H.dM(H.ci(y[d],z),c)},
dM:function(a,b){var z,y
if(a==null||b==null)return!0
z=a.length
for(y=0;y<z;++y)if(!H.O(a[y],b[y]))return!1
return!0},
dO:function(a,b,c){return a.apply(b,H.dR(b,c))},
O:function(a,b){var z,y,x,w,v,u
if(a===b)return!0
if(a==null||b==null)return!0
if(a.builtin$cls==="fm")return!0
if('func' in b)return H.dS(a,b)
if('func' in a)return b.builtin$cls==="eF"||b.builtin$cls==="b"
z=typeof a==="object"&&a!==null&&a.constructor===Array
y=z?a[0]:a
x=typeof b==="object"&&b!==null&&b.constructor===Array
w=x?b[0]:b
if(w!==y){v=H.aw(w,null)
if(!('$is'+v in y.prototype))return!1
u=y.prototype["$as"+v]}else u=null
if(!z&&u==null||!x)return!0
z=z?a.slice(1):null
x=b.slice(1)
return H.dM(H.ci(u,z),x)},
dL:function(a,b,c){var z,y,x,w,v
z=b==null
if(z&&a==null)return!0
if(z)return c
if(a==null)return!1
y=a.length
x=b.length
if(c){if(y<x)return!1}else if(y!==x)return!1
for(w=0;w<x;++w){z=a[w]
v=b[w]
if(!(H.O(z,v)||H.O(v,z)))return!1}return!0},
iD:function(a,b){var z,y,x,w,v,u
if(b==null)return!0
if(a==null)return!1
z=Object.getOwnPropertyNames(b)
z.fixed$length=Array
y=z
for(z=y.length,x=0;x<z;++x){w=y[x]
if(!Object.hasOwnProperty.call(a,w))return!1
v=b[w]
u=a[w]
if(!(H.O(v,u)||H.O(u,v)))return!1}return!0},
dS:function(a,b){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l
if(!('func' in a))return!1
if("v" in a){if(!("v" in b)&&"ret" in b)return!1}else if(!("v" in b)){z=a.ret
y=b.ret
if(!(H.O(z,y)||H.O(y,z)))return!1}x=a.args
w=b.args
v=a.opt
u=b.opt
t=x!=null?x.length:0
s=w!=null?w.length:0
r=v!=null?v.length:0
q=u!=null?u.length:0
if(t>s)return!1
if(t+r<s+q)return!1
if(t===s){if(!H.dL(x,w,!1))return!1
if(!H.dL(v,u,!0))return!1}else{for(p=0;p<t;++p){o=x[p]
n=w[p]
if(!(H.O(o,n)||H.O(n,o)))return!1}for(m=p,l=0;m<s;++l,++m){o=v[l]
n=w[m]
if(!(H.O(o,n)||H.O(n,o)))return!1}for(m=0;m<q;++l,++m){o=v[l]
n=u[m]
if(!(H.O(o,n)||H.O(n,o)))return!1}}return H.iD(a.named,b.named)},
kQ:function(a){var z=$.ce
return"Instance of "+(z==null?"<Unknown>":z.$1(a))},
kO:function(a){return H.a9(a)},
kN:function(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
j1:function(a){var z,y,x,w,v,u
z=$.ce.$1(a)
y=$.bs[z]
if(y!=null){Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}x=$.bv[z]
if(x!=null)return x
w=init.interceptorsByTag[z]
if(w==null){z=$.dK.$2(a,z)
if(z!=null){y=$.bs[z]
if(y!=null){Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}x=$.bv[z]
if(x!=null)return x
w=init.interceptorsByTag[z]}}if(w==null)return
x=w.prototype
v=z[0]
if(v==="!"){y=H.cg(x)
$.bs[z]=y
Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}if(v==="~"){$.bv[z]=x
return x}if(v==="-"){u=H.cg(x)
Object.defineProperty(Object.getPrototypeOf(a),init.dispatchPropertyName,{value:u,enumerable:false,writable:true,configurable:true})
return u.i}if(v==="+")return H.dV(a,x)
if(v==="*")throw H.c(new P.dm(z))
if(init.leafTags[z]===true){u=H.cg(x)
Object.defineProperty(Object.getPrototypeOf(a),init.dispatchPropertyName,{value:u,enumerable:false,writable:true,configurable:true})
return u.i}else return H.dV(a,x)},
dV:function(a,b){var z=Object.getPrototypeOf(a)
Object.defineProperty(z,init.dispatchPropertyName,{value:J.bw(b,z,null,null),enumerable:false,writable:true,configurable:true})
return b},
cg:function(a){return J.bw(a,!1,null,!!a.$isP)},
j2:function(a,b,c){var z=b.prototype
if(init.leafTags[a]===true)return J.bw(z,!1,null,!!z.$isP)
else return J.bw(z,c,null,null)},
iU:function(){if(!0===$.cf)return
$.cf=!0
H.iV()},
iV:function(){var z,y,x,w,v,u,t,s
$.bs=Object.create(null)
$.bv=Object.create(null)
H.iQ()
z=init.interceptorsByTag
y=Object.getOwnPropertyNames(z)
if(typeof window!="undefined"){window
x=function(){}
for(w=0;w<y.length;++w){v=y[w]
u=$.dW.$1(v)
if(u!=null){t=H.j2(v,z[v],u)
if(t!=null){Object.defineProperty(u,init.dispatchPropertyName,{value:t,enumerable:false,writable:true,configurable:true})
x.prototype=u}}}}for(w=0;w<y.length;++w){v=y[w]
if(/^[A-Za-z_]/.test(v)){s=z[v]
z["!"+v]=s
z["~"+v]=s
z["-"+v]=s
z["+"+v]=s
z["*"+v]=s}}},
iQ:function(){var z,y,x,w,v,u,t
z=C.S()
z=H.aq(C.P,H.aq(C.U,H.aq(C.C,H.aq(C.C,H.aq(C.T,H.aq(C.Q,H.aq(C.R(C.D),z)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){y=dartNativeDispatchHooksTransformer
if(typeof y=="function")y=[y]
if(y.constructor==Array)for(x=0;x<y.length;++x){w=y[x]
if(typeof w=="function")z=w(z)||z}}v=z.getTag
u=z.getUnknownTag
t=z.prototypeForTag
$.ce=new H.iR(v)
$.dK=new H.iS(u)
$.dW=new H.iT(t)},
aq:function(a,b){return a(b)||b},
j7:function(a,b,c){var z
if(typeof b==="string")return a.indexOf(b,c)>=0
else{z=J.e3(b,C.e.U(a,c))
return!z.gG(z)}},
fr:{"^":"b;a,b,c,d,e,f,r,x",p:{
fs:function(a){var z,y,x
z=a.$reflectionInfo
if(z==null)return
z.fixed$length=Array
z=z
y=z[0]
x=z[1]
return new H.fr(a,z,(y&1)===1,y>>1,x>>1,(x&1)===1,z[2],null)}}},
fp:{"^":"e:0;a",
$0:function(){return C.a.e6(1000*this.a.now())}},
h5:{"^":"b;a,b,c,d,e,f",
M:function(a){var z,y,x
z=new RegExp(this.a).exec(a)
if(z==null)return
y=Object.create(null)
x=this.b
if(x!==-1)y.arguments=z[x+1]
x=this.c
if(x!==-1)y.argumentsExpr=z[x+1]
x=this.d
if(x!==-1)y.expr=z[x+1]
x=this.e
if(x!==-1)y.method=z[x+1]
x=this.f
if(x!==-1)y.receiver=z[x+1]
return y},
p:{
a_:function(a){var z,y,x,w,v,u
a=a.replace(String({}),'$receiver$').replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
z=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(z==null)z=[]
y=z.indexOf("\\$arguments\\$")
x=z.indexOf("\\$argumentsExpr\\$")
w=z.indexOf("\\$expr\\$")
v=z.indexOf("\\$method\\$")
u=z.indexOf("\\$receiver\\$")
return new H.h5(a.replace(new RegExp('\\\\\\$arguments\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$argumentsExpr\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$expr\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$method\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$receiver\\\\\\$','g'),'((?:x|[^x])*)'),y,x,w,v,u)},
bj:function(a){return function($expr$){var $argumentsExpr$='$arguments$'
try{$expr$.$method$($argumentsExpr$)}catch(z){return z.message}}(a)},
dh:function(a){return function($expr$){try{$expr$.$method$}catch(z){return z.message}}(a)}}},
cS:{"^":"I;a,b",
i:function(a){var z=this.b
if(z==null)return"NullError: "+H.d(this.a)
return"NullError: method not found: '"+H.d(z)+"' on null"}},
f9:{"^":"I;a,b,c",
i:function(a){var z,y
z=this.b
if(z==null)return"NoSuchMethodError: "+H.d(this.a)
y=this.c
if(y==null)return"NoSuchMethodError: method not found: '"+z+"' ("+H.d(this.a)+")"
return"NoSuchMethodError: method not found: '"+z+"' on '"+y+"' ("+H.d(this.a)+")"},
p:{
bN:function(a,b){var z,y
z=b==null
y=z?null:b.method
return new H.f9(a,y,z?null:b.receiver)}}},
h6:{"^":"I;a",
i:function(a){var z=this.a
return z.length===0?"Error":"Error: "+z}},
bH:{"^":"b;a,a_:b<"},
j9:{"^":"e:1;a",
$1:function(a){if(!!J.n(a).$isI)if(a.$thrownJsError==null)a.$thrownJsError=this.a
return a}},
dC:{"^":"b;a,b",
i:function(a){var z,y
z=this.b
if(z!=null)return z
z=this.a
y=z!==null&&typeof z==="object"?z.stack:null
z=y==null?"":y
this.b=z
return z}},
iX:{"^":"e:0;a",
$0:function(){return this.a.$0()}},
iY:{"^":"e:0;a,b",
$0:function(){return this.a.$1(this.b)}},
iZ:{"^":"e:0;a,b,c",
$0:function(){return this.a.$2(this.b,this.c)}},
j_:{"^":"e:0;a,b,c,d",
$0:function(){return this.a.$3(this.b,this.c,this.d)}},
j0:{"^":"e:0;a,b,c,d,e",
$0:function(){return this.a.$4(this.b,this.c,this.d,this.e)}},
e:{"^":"b;",
i:function(a){return"Closure '"+H.cW(this).trim()+"'"},
gcD:function(){return this},
gcD:function(){return this}},
d6:{"^":"e;"},
fx:{"^":"d6;",
i:function(a){var z=this.$static_name
if(z==null)return"Closure of unknown static method"
return"Closure '"+z+"'"}},
bB:{"^":"d6;a,b,c,d",
w:function(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof H.bB))return!1
return this.a===b.a&&this.b===b.b&&this.c===b.c},
gC:function(a){var z,y
z=this.c
if(z==null)y=H.a9(this.a)
else y=typeof z!=="object"?J.W(z):H.a9(z)
z=H.a9(this.b)
if(typeof y!=="number")return y.f2()
return(y^z)>>>0},
i:function(a){var z=this.c
if(z==null)z=this.a
return"Closure '"+H.d(this.d)+"' of "+H.bh(z)},
p:{
bC:function(a){return a.a},
ct:function(a){return a.c},
en:function(){var z=$.az
if(z==null){z=H.ba("self")
$.az=z}return z},
ba:function(a){var z,y,x,w,v
z=new H.bB("self","target","receiver","name")
y=Object.getOwnPropertyNames(z)
y.fixed$length=Array
x=y
for(y=x.length,w=0;w<y;++w){v=x[w]
if(z[v]===a)return v}}}},
fu:{"^":"I;a",
i:function(a){return"RuntimeError: "+H.d(this.a)}},
aj:{"^":"b;a,b,c,d,e,f,r,$ti",
gj:function(a){return this.a},
gG:function(a){return this.a===0},
gR:function(){return new H.fd(this,[H.a4(this,0)])},
gcB:function(a){return H.bf(this.gR(),new H.f8(this),H.a4(this,0),H.a4(this,1))},
aa:function(a){var z,y
if(typeof a==="string"){z=this.b
if(z==null)return!1
return this.bI(z,a)}else if(typeof a==="number"&&(a&0x3ffffff)===a){y=this.c
if(y==null)return!1
return this.bI(y,a)}else return this.ei(a)},
ei:function(a){var z=this.d
if(z==null)return!1
return this.ap(this.aC(z,this.ao(a)),a)>=0},
h:function(a,b){var z,y,x
if(typeof b==="string"){z=this.b
if(z==null)return
y=this.ai(z,b)
return y==null?null:y.ga3()}else if(typeof b==="number"&&(b&0x3ffffff)===b){x=this.c
if(x==null)return
y=this.ai(x,b)
return y==null?null:y.ga3()}else return this.ej(b)},
ej:function(a){var z,y,x
z=this.d
if(z==null)return
y=this.aC(z,this.ao(a))
x=this.ap(y,a)
if(x<0)return
return y[x].ga3()},
n:function(a,b,c){var z,y,x,w,v,u
if(typeof b==="string"){z=this.b
if(z==null){z=this.b3()
this.b=z}this.bA(z,b,c)}else if(typeof b==="number"&&(b&0x3ffffff)===b){y=this.c
if(y==null){y=this.b3()
this.c=y}this.bA(y,b,c)}else{x=this.d
if(x==null){x=this.b3()
this.d=x}w=this.ao(b)
v=this.aC(x,w)
if(v==null)this.b7(x,w,[this.b4(b,c)])
else{u=this.ap(v,b)
if(u>=0)v[u].sa3(c)
else v.push(this.b4(b,c))}}},
u:function(a,b){if(typeof b==="string")return this.bX(this.b,b)
else if(typeof b==="number"&&(b&0x3ffffff)===b)return this.bX(this.c,b)
else return this.ek(b)},
ek:function(a){var z,y,x,w
z=this.d
if(z==null)return
y=this.aC(z,this.ao(a))
x=this.ap(y,a)
if(x<0)return
w=y.splice(x,1)[0]
this.c5(w)
return w.ga3()},
K:function(a){if(this.a>0){this.f=null
this.e=null
this.d=null
this.c=null
this.b=null
this.a=0
this.r=this.r+1&67108863}},
X:function(a,b){var z,y
z=this.e
y=this.r
for(;z!=null;){b.$2(z.a,z.b)
if(y!==this.r)throw H.c(new P.S(this))
z=z.c}},
bA:function(a,b,c){var z=this.ai(a,b)
if(z==null)this.b7(a,b,this.b4(b,c))
else z.sa3(c)},
bX:function(a,b){var z
if(a==null)return
z=this.ai(a,b)
if(z==null)return
this.c5(z)
this.bJ(a,b)
return z.ga3()},
b4:function(a,b){var z,y
z=new H.fc(a,b,null,null)
if(this.e==null){this.f=z
this.e=z}else{y=this.f
z.d=y
y.c=z
this.f=z}++this.a
this.r=this.r+1&67108863
return z},
c5:function(a){var z,y
z=a.gdt()
y=a.c
if(z==null)this.e=y
else z.c=y
if(y==null)this.f=z
else y.d=z;--this.a
this.r=this.r+1&67108863},
ao:function(a){return J.W(a)&0x3ffffff},
ap:function(a,b){var z,y
if(a==null)return-1
z=a.length
for(y=0;y<z;++y)if(J.x(a[y].gcl(),b))return y
return-1},
i:function(a){return P.cM(this)},
ai:function(a,b){return a[b]},
aC:function(a,b){return a[b]},
b7:function(a,b,c){a[b]=c},
bJ:function(a,b){delete a[b]},
bI:function(a,b){return this.ai(a,b)!=null},
b3:function(){var z=Object.create(null)
this.b7(z,"<non-identifier-key>",z)
this.bJ(z,"<non-identifier-key>")
return z},
$iseT:1},
f8:{"^":"e:1;a",
$1:function(a){return this.a.h(0,a)}},
fc:{"^":"b;cl:a<,a3:b@,c,dt:d<"},
fd:{"^":"i;a,$ti",
gj:function(a){return this.a.a},
gv:function(a){var z,y
z=this.a
y=new H.fe(z,z.r,null,null)
y.c=z.e
return y}},
fe:{"^":"b;a,b,c,d",
gt:function(){return this.d},
k:function(){var z=this.a
if(this.b!==z.r)throw H.c(new P.S(z))
else{z=this.c
if(z==null){this.d=null
return!1}else{this.d=z.a
this.c=z.c
return!0}}}},
iR:{"^":"e:1;a",
$1:function(a){return this.a(a)}},
iS:{"^":"e:9;a",
$2:function(a,b){return this.a(a,b)}},
iT:{"^":"e:10;a",
$1:function(a){return this.a(a)}},
cK:{"^":"b;a,b,c,d",
i:function(a){return"RegExp/"+this.a+"/"},
gds:function(){var z=this.c
if(z!=null)return z
z=this.b
z=H.bK(this.a,z.multiline,!z.ignoreCase,!0)
this.c=z
return z},
gdr:function(){var z=this.d
if(z!=null)return z
z=this.b
z=H.bK(this.a+"|()",z.multiline,!z.ignoreCase,!0)
this.d=z
return z},
dh:function(a,b){var z,y
z=this.gds()
z.lastIndex=b
y=z.exec(a)
if(y==null)return
return new H.dB(this,y)},
dg:function(a,b){var z,y
z=this.gdr()
z.lastIndex=b
y=z.exec(a)
if(y==null)return
if(0>=y.length)return H.a(y,-1)
if(y.pop()!=null)return
return new H.dB(this,y)},
co:function(a,b,c){if(c>b.length)throw H.c(P.H(c,0,b.length,null,null))
return this.dg(b,c)},
p:{
bK:function(a,b,c,d){var z,y,x,w
z=b?"m":""
y=c?"":"i"
x=d?"g":""
w=function(e,f){try{return new RegExp(e,f)}catch(v){return v}}(a,z+y+x)
if(w instanceof RegExp)return w
throw H.c(new P.bI("Illegal RegExp pattern ("+String(w)+")",a,null))}}},
dB:{"^":"b;a,b",
h:function(a,b){var z=this.b
if(b>>>0!==b||b>=z.length)return H.a(z,b)
return z[b]}},
d3:{"^":"b;a,b,c",
h:function(a,b){if(!J.x(b,0))H.v(P.aG(b,null,null))
return this.c}},
id:{"^":"J;a,b,c",
gv:function(a){return new H.ie(this.a,this.b,this.c,null)},
$asJ:function(){return[P.fi]}},
ie:{"^":"b;a,b,c,d",
k:function(){var z,y,x,w,v,u,t
z=this.c
y=this.b
x=y.length
w=this.a
v=w.length
if(z+x>v){this.d=null
return!1}u=w.indexOf(y,z)
if(u<0){this.c=v+1
this.d=null
return!1}t=u+x
this.d=new H.d3(u,w,y)
this.c=t===this.c?t+1:t
return!0},
gt:function(){return this.d}}}],["","",,H,{"^":"",
iL:function(a){var z=H.j(a?Object.keys(a):[],[null])
z.fixed$length=Array
return z}}],["","",,H,{"^":"",
j4:function(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof window=="object")return
if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)}}],["","",,H,{"^":"",
ir:function(a){return a},
bS:{"^":"f;",$isbS:1,"%":"ArrayBuffer"},
bU:{"^":"f;",
dm:function(a,b,c,d){throw H.c(P.H(b,0,c,d,null))},
bD:function(a,b,c,d){if(b>>>0!==b||b>c)this.dm(a,b,c,d)},
$isbU:1,
"%":"DataView;ArrayBufferView;bT|cN|cP|bg|cO|cQ|a3"},
bT:{"^":"bU;",
gj:function(a){return a.length},
c1:function(a,b,c,d,e){var z,y,x
z=a.length
this.bD(a,b,z,"start")
this.bD(a,c,z,"end")
if(b>c)throw H.c(P.H(b,0,c,null,null))
y=c-b
if(e<0)throw H.c(P.b8(e))
x=d.length
if(x-e<y)throw H.c(new P.Z("Not enough elements"))
if(e!==0||x!==y)d=d.subarray(e,e+y)
a.set(d,b)},
$isP:1,
$asP:I.G,
$isK:1,
$asK:I.G},
bg:{"^":"cP;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
n:function(a,b,c){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
a[b]=c},
T:function(a,b,c,d,e){if(!!J.n(d).$isbg){this.c1(a,b,c,d,e)
return}this.bz(a,b,c,d,e)}},
cN:{"^":"bT+a8;",$asP:I.G,$asK:I.G,
$ash:function(){return[P.ab]},
$asi:function(){return[P.ab]},
$ish:1,
$isi:1},
cP:{"^":"cN+cB;",$asP:I.G,$asK:I.G,
$ash:function(){return[P.ab]},
$asi:function(){return[P.ab]}},
a3:{"^":"cQ;",
n:function(a,b,c){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
a[b]=c},
T:function(a,b,c,d,e){if(!!J.n(d).$isa3){this.c1(a,b,c,d,e)
return}this.bz(a,b,c,d,e)},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]}},
cO:{"^":"bT+a8;",$asP:I.G,$asK:I.G,
$ash:function(){return[P.k]},
$asi:function(){return[P.k]},
$ish:1,
$isi:1},
cQ:{"^":"cO+cB;",$asP:I.G,$asK:I.G,
$ash:function(){return[P.k]},
$asi:function(){return[P.k]}},
k0:{"^":"bg;",$ish:1,
$ash:function(){return[P.ab]},
$isi:1,
$asi:function(){return[P.ab]},
"%":"Float32Array"},
k1:{"^":"bg;",$ish:1,
$ash:function(){return[P.ab]},
$isi:1,
$asi:function(){return[P.ab]},
"%":"Float64Array"},
k2:{"^":"a3;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]},
"%":"Int16Array"},
k3:{"^":"a3;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]},
"%":"Int32Array"},
k4:{"^":"a3;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]},
"%":"Int8Array"},
k5:{"^":"a3;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]},
"%":"Uint16Array"},
k6:{"^":"a3;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]},
"%":"Uint32Array"},
k7:{"^":"a3;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]},
"%":"CanvasPixelArray|Uint8ClampedArray"},
k8:{"^":"a3;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)H.v(H.y(a,b))
return a[b]},
$ish:1,
$ash:function(){return[P.k]},
$isi:1,
$asi:function(){return[P.k]},
"%":";Uint8Array"}}],["","",,P,{"^":"",
ha:function(){var z,y,x
z={}
if(self.scheduleImmediate!=null)return P.iE()
if(self.MutationObserver!=null&&self.document!=null){y=self.document.createElement("div")
x=self.document.createElement("span")
z.a=null
new self.MutationObserver(H.ar(new P.hc(z),1)).observe(y,{childList:true})
return new P.hb(z,y,x)}else if(self.setImmediate!=null)return P.iF()
return P.iG()},
kv:[function(a){++init.globalState.f.b
self.scheduleImmediate(H.ar(new P.hd(a),0))},"$1","iE",2,0,4],
kw:[function(a){++init.globalState.f.b
self.setImmediate(H.ar(new P.he(a),0))},"$1","iF",2,0,4],
kx:[function(a){P.c2(C.B,a)},"$1","iG",2,0,4],
bq:function(a,b,c){if(b===0){J.e4(c,a)
return}else if(b===1){c.cf(H.B(a),H.N(a))
return}P.io(a,b)
return c.ge8()},
io:function(a,b){var z,y,x,w
z=new P.ip(b)
y=new P.iq(b)
x=J.n(a)
if(!!x.$isQ)a.b8(z,y)
else if(!!x.$isY)a.bp(z,y)
else{w=new P.Q(0,$.l,null,[null])
w.a=4
w.c=a
w.b8(z,null)}},
iA:function(a){var z=function(b,c){return function(d,e){while(true)try{b(d,e)
break}catch(y){e=y
d=c}}}(a,1)
$.l.toString
return new P.iB(z)},
dF:function(a,b){if(H.as(a,{func:1,args:[,,]})){b.toString
return a}else{b.toString
return a}},
et:function(a){return new P.ih(new P.Q(0,$.l,null,[a]),[a])},
iw:function(){var z,y
for(;z=$.ao,z!=null;){$.aL=null
y=z.b
$.ao=y
if(y==null)$.aK=null
z.a.$0()}},
kM:[function(){$.cb=!0
try{P.iw()}finally{$.aL=null
$.cb=!1
if($.ao!=null)$.$get$c3().$1(P.dN())}},"$0","dN",0,0,2],
dJ:function(a){var z=new P.dp(a,null)
if($.ao==null){$.aK=z
$.ao=z
if(!$.cb)$.$get$c3().$1(P.dN())}else{$.aK.b=z
$.aK=z}},
iz:function(a){var z,y,x
z=$.ao
if(z==null){P.dJ(a)
$.aL=$.aK
return}y=new P.dp(a,null)
x=$.aL
if(x==null){y.b=z
$.aL=y
$.ao=y}else{y.b=x.b
x.b=y
$.aL=y
if(y.b==null)$.aK=y}},
dX:function(a){var z=$.l
if(C.d===z){P.ap(null,null,C.d,a)
return}z.toString
P.ap(null,null,z,z.bc(a,!0))},
kk:function(a,b){return new P.ic(null,a,!1,[b])},
im:function(a,b,c){$.l.toString
a.aS(b,c)},
h3:function(a,b){var z=$.l
if(z===C.d){z.toString
return P.c2(a,b)}return P.c2(a,z.bc(b,!0))},
h4:function(a,b){var z,y
z=$.l
if(z===C.d){z.toString
return P.da(a,b)}y=z.cb(b,!0)
$.l.toString
return P.da(a,y)},
c2:function(a,b){var z=C.a.D(a.a,1000)
return H.fZ(z<0?0:z,b)},
da:function(a,b){var z=C.a.D(a.a,1000)
return H.h_(z<0?0:z,b)},
b5:function(a,b,c,d,e){var z={}
z.a=d
P.iz(new P.iy(z,e))},
dG:function(a,b,c,d){var z,y
y=$.l
if(y===c)return d.$0()
$.l=c
z=y
try{y=d.$0()
return y}finally{$.l=z}},
dI:function(a,b,c,d,e){var z,y
y=$.l
if(y===c)return d.$1(e)
$.l=c
z=y
try{y=d.$1(e)
return y}finally{$.l=z}},
dH:function(a,b,c,d,e,f){var z,y
y=$.l
if(y===c)return d.$2(e,f)
$.l=c
z=y
try{y=d.$2(e,f)
return y}finally{$.l=z}},
ap:function(a,b,c,d){var z=C.d!==c
if(z)d=c.bc(d,!(!z||!1))
P.dJ(d)},
hc:{"^":"e:1;a",
$1:function(a){var z,y;--init.globalState.f.b
z=this.a
y=z.a
z.a=null
y.$0()}},
hb:{"^":"e:11;a,b,c",
$1:function(a){var z,y;++init.globalState.f.b
this.a.a=a
z=this.b
y=this.c
z.firstChild?z.removeChild(y):z.appendChild(y)}},
hd:{"^":"e:0;a",
$0:function(){--init.globalState.f.b
this.a.$0()}},
he:{"^":"e:0;a",
$0:function(){--init.globalState.f.b
this.a.$0()}},
ip:{"^":"e:1;a",
$1:function(a){return this.a.$2(0,a)}},
iq:{"^":"e:12;a",
$2:function(a,b){this.a.$2(1,new H.bH(a,b))}},
iB:{"^":"e:13;a",
$2:function(a,b){this.a(a,b)}},
Y:{"^":"b;$ti"},
dr:{"^":"b;e8:a<,$ti",
cf:[function(a,b){if(a==null)a=new P.bW()
if(this.a.a!==0)throw H.c(new P.Z("Future already completed"))
$.l.toString
this.W(a,b)},function(a){return this.cf(a,null)},"dP","$2","$1","gdO",2,2,5,0]},
h9:{"^":"dr;a,$ti",
aG:function(a,b){var z=this.a
if(z.a!==0)throw H.c(new P.Z("Future already completed"))
z.bC(b)},
W:function(a,b){this.a.d9(a,b)}},
ih:{"^":"dr;a,$ti",
aG:function(a,b){var z=this.a
if(z.a!==0)throw H.c(new P.Z("Future already completed"))
z.ax(b)},
W:function(a,b){this.a.W(a,b)}},
du:{"^":"b;b5:a<,b,c,d,e",
gdE:function(){return this.b.b},
gck:function(){return(this.c&1)!==0},
gef:function(){return(this.c&2)!==0},
gcj:function(){return this.c===8},
ed:function(a){return this.b.b.bm(this.d,a)},
eo:function(a){if(this.c!==6)return!0
return this.b.b.bm(this.d,J.aT(a))},
e9:function(a){var z,y,x
z=this.e
y=J.m(a)
x=this.b.b
if(H.as(z,{func:1,args:[,,]}))return x.eR(z,y.ga2(a),a.ga_())
else return x.bm(z,y.ga2(a))},
ee:function(){return this.b.b.cs(this.d)}},
Q:{"^":"b;ak:a<,b,dw:c<,$ti",
gdn:function(){return this.a===2},
gb2:function(){return this.a>=4},
bp:function(a,b){var z=$.l
if(z!==C.d){z.toString
if(b!=null)b=P.dF(b,z)}return this.b8(a,b)},
bo:function(a){return this.bp(a,null)},
b8:function(a,b){var z=new P.Q(0,$.l,null,[null])
this.aU(new P.du(null,z,b==null?1:3,a,b))
return z},
cC:function(a){var z,y
z=$.l
y=new P.Q(0,z,null,this.$ti)
if(z!==C.d)z.toString
this.aU(new P.du(null,y,8,a,null))
return y},
aU:function(a){var z,y
z=this.a
if(z<=1){a.a=this.c
this.c=a}else{if(z===2){y=this.c
if(!y.gb2()){y.aU(a)
return}this.a=y.a
this.c=y.c}z=this.b
z.toString
P.ap(null,null,z,new P.hv(this,a))}},
bW:function(a){var z,y,x,w,v
z={}
z.a=a
if(a==null)return
y=this.a
if(y<=1){x=this.c
this.c=a
if(x!=null){for(w=a;w.gb5()!=null;)w=w.a
w.a=x}}else{if(y===2){v=this.c
if(!v.gb2()){v.bW(a)
return}this.a=v.a
this.c=v.c}z.a=this.aE(a)
y=this.b
y.toString
P.ap(null,null,y,new P.hC(z,this))}},
aD:function(){var z=this.c
this.c=null
return this.aE(z)},
aE:function(a){var z,y,x
for(z=a,y=null;z!=null;y=z,z=x){x=z.gb5()
z.a=y}return y},
ax:function(a){var z,y
z=this.$ti
if(H.b6(a,"$isY",z,"$asY"))if(H.b6(a,"$isQ",z,null))P.bn(a,this)
else P.dv(a,this)
else{y=this.aD()
this.a=4
this.c=a
P.am(this,y)}},
W:[function(a,b){var z=this.aD()
this.a=8
this.c=new P.b9(a,b)
P.am(this,z)},function(a){return this.W(a,null)},"f3","$2","$1","gbH",2,2,5,0],
bC:function(a){var z=this.$ti
if(H.b6(a,"$isY",z,"$asY")){if(H.b6(a,"$isQ",z,null))if(a.gak()===8){this.a=1
z=this.b
z.toString
P.ap(null,null,z,new P.hx(this,a))}else P.bn(a,this)
else P.dv(a,this)
return}this.a=1
z=this.b
z.toString
P.ap(null,null,z,new P.hy(this,a))},
d9:function(a,b){var z
this.a=1
z=this.b
z.toString
P.ap(null,null,z,new P.hw(this,a,b))},
$isY:1,
p:{
hu:function(a,b){var z=new P.Q(0,$.l,null,[b])
z.bC(a)
return z},
dv:function(a,b){var z,y,x,w
b.a=1
try{a.bp(new P.hz(b),new P.hA(b))}catch(x){w=H.B(x)
z=w
y=H.N(x)
P.dX(new P.hB(b,z,y))}},
bn:function(a,b){var z,y,x
for(;a.gdn();)a=a.c
z=a.gb2()
y=b.c
if(z){b.c=null
x=b.aE(y)
b.a=a.a
b.c=a.c
P.am(b,x)}else{b.a=2
b.c=a
a.bW(y)}},
am:function(a,b){var z,y,x,w,v,u,t,s,r,q,p,o
z={}
z.a=a
for(y=a;!0;){x={}
w=y.a===8
if(b==null){if(w){v=y.c
z=y.b
y=J.aT(v)
x=v.ga_()
z.toString
P.b5(null,null,z,y,x)}return}for(;b.gb5()!=null;b=u){u=b.a
b.a=null
P.am(z.a,b)}t=z.a.c
x.a=w
x.b=t
y=!w
if(!y||b.gck()||b.gcj()){s=b.gdE()
if(w){r=z.a.b
r.toString
r=r==null?s==null:r===s
if(!r)s.toString
else r=!0
r=!r}else r=!1
if(r){y=z.a
v=y.c
y=y.b
x=J.aT(v)
r=v.ga_()
y.toString
P.b5(null,null,y,x,r)
return}q=$.l
if(q==null?s!=null:q!==s)$.l=s
else q=null
if(b.gcj())new P.hF(z,x,w,b).$0()
else if(y){if(b.gck())new P.hE(x,b,t).$0()}else if(b.gef())new P.hD(z,x,b).$0()
if(q!=null)$.l=q
y=x.b
if(!!J.n(y).$isY){p=b.b
if(y.a>=4){o=p.c
p.c=null
b=p.aE(o)
p.a=y.a
p.c=y.c
z.a=y
continue}else P.bn(y,p)
return}}p=b.b
b=p.aD()
y=x.a
x=x.b
if(!y){p.a=4
p.c=x}else{p.a=8
p.c=x}z.a=p
y=p}}}},
hv:{"^":"e:0;a,b",
$0:function(){P.am(this.a,this.b)}},
hC:{"^":"e:0;a,b",
$0:function(){P.am(this.b,this.a.a)}},
hz:{"^":"e:1;a",
$1:function(a){var z=this.a
z.a=0
z.ax(a)}},
hA:{"^":"e:14;a",
$2:function(a,b){this.a.W(a,b)},
$1:function(a){return this.$2(a,null)}},
hB:{"^":"e:0;a,b,c",
$0:function(){this.a.W(this.b,this.c)}},
hx:{"^":"e:0;a,b",
$0:function(){P.bn(this.b,this.a)}},
hy:{"^":"e:0;a,b",
$0:function(){var z,y
z=this.a
y=z.aD()
z.a=4
z.c=this.b
P.am(z,y)}},
hw:{"^":"e:0;a,b,c",
$0:function(){this.a.W(this.b,this.c)}},
hF:{"^":"e:2;a,b,c,d",
$0:function(){var z,y,x,w,v,u,t
z=null
try{z=this.d.ee()}catch(w){v=H.B(w)
y=v
x=H.N(w)
if(this.c){v=J.aT(this.a.a.c)
u=y
u=v==null?u==null:v===u
v=u}else v=!1
u=this.b
if(v)u.b=this.a.a.c
else u.b=new P.b9(y,x)
u.a=!0
return}if(!!J.n(z).$isY){if(z instanceof P.Q&&z.gak()>=4){if(z.gak()===8){v=this.b
v.b=z.gdw()
v.a=!0}return}t=this.a.a
v=this.b
v.b=z.bo(new P.hG(t))
v.a=!1}}},
hG:{"^":"e:1;a",
$1:function(a){return this.a}},
hE:{"^":"e:2;a,b,c",
$0:function(){var z,y,x,w
try{this.a.b=this.b.ed(this.c)}catch(x){w=H.B(x)
z=w
y=H.N(x)
w=this.a
w.b=new P.b9(z,y)
w.a=!0}}},
hD:{"^":"e:2;a,b,c",
$0:function(){var z,y,x,w,v,u,t,s
try{z=this.a.a.c
w=this.c
if(w.eo(z)===!0&&w.e!=null){v=this.b
v.b=w.e9(z)
v.a=!1}}catch(u){w=H.B(u)
y=w
x=H.N(u)
w=this.a
v=J.aT(w.a.c)
t=y
s=this.b
if(v==null?t==null:v===t)s.b=w.a.c
else s.b=new P.b9(y,x)
s.a=!0}}},
dp:{"^":"b;a,b"},
aH:{"^":"b;$ti",
Y:function(a,b){return new P.hV(b,this,[H.A(this,"aH",0),null])},
gj:function(a){var z,y
z={}
y=new P.Q(0,$.l,null,[P.k])
z.a=0
this.aq(new P.fz(z),!0,new P.fA(z,y),y.gbH())
return y},
aL:function(a){var z,y,x
z=H.A(this,"aH",0)
y=H.j([],[z])
x=new P.Q(0,$.l,null,[[P.h,z]])
this.aq(new P.fB(this,y),!0,new P.fC(y,x),x.gbH())
return x}},
fz:{"^":"e:1;a",
$1:function(a){++this.a.a}},
fA:{"^":"e:0;a,b",
$0:function(){this.b.ax(this.a.a)}},
fB:{"^":"e;a,b",
$1:function(a){this.b.push(a)},
$signature:function(){return H.dO(function(a){return{func:1,args:[a]}},this.a,"aH")}},
fC:{"^":"e:0;a,b",
$0:function(){this.b.ax(this.a)}},
fy:{"^":"b;$ti"},
kC:{"^":"b;"},
bk:{"^":"b;ak:e<,$ti",
bk:function(a,b){var z=this.e
if((z&8)!==0)return
this.e=(z+128|4)>>>0
if(z<128&&this.r!=null)this.r.cd()
if((z&4)===0&&(this.e&32)===0)this.bM(this.gbS())},
cp:function(a){return this.bk(a,null)},
cr:function(){var z=this.e
if((z&8)!==0)return
if(z>=128){z-=128
this.e=z
if(z<128){if((z&64)!==0){z=this.r
z=!z.gG(z)}else z=!1
if(z)this.r.aN(this)
else{z=(this.e&4294967291)>>>0
this.e=z
if((z&32)===0)this.bM(this.gbU())}}}},
cc:function(){var z=(this.e&4294967279)>>>0
this.e=z
if((z&8)===0)this.aX()
z=this.f
return z==null?$.$get$bc():z},
aX:function(){var z=(this.e|8)>>>0
this.e=z
if((z&64)!==0)this.r.cd()
if((this.e&32)===0)this.r=null
this.f=this.bR()},
aW:["cV",function(a){var z=this.e
if((z&8)!==0)return
if(z<32)this.bZ(a)
else this.aV(new P.hk(a,null,[H.A(this,"bk",0)]))}],
aS:["cW",function(a,b){var z=this.e
if((z&8)!==0)return
if(z<32)this.c0(a,b)
else this.aV(new P.hm(a,b,null))}],
d8:function(){var z=this.e
if((z&8)!==0)return
z=(z|2)>>>0
this.e=z
if(z<32)this.c_()
else this.aV(C.H)},
bT:[function(){},"$0","gbS",0,0,2],
bV:[function(){},"$0","gbU",0,0,2],
bR:function(){return},
aV:function(a){var z,y
z=this.r
if(z==null){z=new P.ib(null,null,0,[H.A(this,"bk",0)])
this.r=z}z.A(0,a)
y=this.e
if((y&64)===0){y=(y|64)>>>0
this.e=y
if(y<128)this.r.aN(this)}},
bZ:function(a){var z=this.e
this.e=(z|32)>>>0
this.d.bn(this.a,a)
this.e=(this.e&4294967263)>>>0
this.aY((z&4)!==0)},
c0:function(a,b){var z,y
z=this.e
y=new P.hi(this,a,b)
if((z&1)!==0){this.e=(z|16)>>>0
this.aX()
z=this.f
if(!!J.n(z).$isY&&z!==$.$get$bc())z.cC(y)
else y.$0()}else{y.$0()
this.aY((z&4)!==0)}},
c_:function(){var z,y
z=new P.hh(this)
this.aX()
this.e=(this.e|16)>>>0
y=this.f
if(!!J.n(y).$isY&&y!==$.$get$bc())y.cC(z)
else z.$0()},
bM:function(a){var z=this.e
this.e=(z|32)>>>0
a.$0()
this.e=(this.e&4294967263)>>>0
this.aY((z&4)!==0)},
aY:function(a){var z,y
if((this.e&64)!==0){z=this.r
z=z.gG(z)}else z=!1
if(z){z=(this.e&4294967231)>>>0
this.e=z
if((z&4)!==0)if(z<128){z=this.r
z=z==null||z.gG(z)}else z=!1
else z=!1
if(z)this.e=(this.e&4294967291)>>>0}for(;!0;a=y){z=this.e
if((z&8)!==0){this.r=null
return}y=(z&4)!==0
if(a===y)break
this.e=(z^32)>>>0
if(y)this.bT()
else this.bV()
this.e=(this.e&4294967263)>>>0}z=this.e
if((z&64)!==0&&z<128)this.r.aN(this)},
d1:function(a,b,c,d,e){var z=this.d
z.toString
this.a=a
this.b=P.dF(b,z)
this.c=c}},
hi:{"^":"e:2;a,b,c",
$0:function(){var z,y,x,w,v,u
z=this.a
y=z.e
if((y&8)!==0&&(y&16)===0)return
z.e=(y|32)>>>0
y=z.b
x=H.as(y,{func:1,args:[P.b,P.al]})
w=z.d
v=this.b
u=z.b
if(x)w.eS(u,v,this.c)
else w.bn(u,v)
z.e=(z.e&4294967263)>>>0}},
hh:{"^":"e:2;a",
$0:function(){var z,y
z=this.a
y=z.e
if((y&16)===0)return
z.e=(y|42)>>>0
z.d.ct(z.c)
z.e=(z.e&4294967263)>>>0}},
ds:{"^":"b;aK:a@"},
hk:{"^":"ds;b,a,$ti",
bl:function(a){a.bZ(this.b)}},
hm:{"^":"ds;a2:b>,a_:c<,a",
bl:function(a){a.c0(this.b,this.c)}},
hl:{"^":"b;",
bl:function(a){a.c_()},
gaK:function(){return},
saK:function(a){throw H.c(new P.Z("No events after a done."))}},
i1:{"^":"b;ak:a<",
aN:function(a){var z=this.a
if(z===1)return
if(z>=1){this.a=1
return}P.dX(new P.i2(this,a))
this.a=1},
cd:function(){if(this.a===1)this.a=3}},
i2:{"^":"e:0;a,b",
$0:function(){var z,y,x,w
z=this.a
y=z.a
z.a=0
if(y===3)return
x=z.b
w=x.gaK()
z.b=w
if(w==null)z.c=null
x.bl(this.b)}},
ib:{"^":"i1;b,c,a,$ti",
gG:function(a){return this.c==null},
A:function(a,b){var z=this.c
if(z==null){this.c=b
this.b=b}else{z.saK(b)
this.c=b}}},
ic:{"^":"b;a,b,c,$ti"},
c6:{"^":"aH;$ti",
aq:function(a,b,c,d){return this.de(a,d,c,!0===b)},
cn:function(a,b,c){return this.aq(a,null,b,c)},
de:function(a,b,c,d){return P.ht(this,a,b,c,d,H.A(this,"c6",0),H.A(this,"c6",1))},
bN:function(a,b){b.aW(a)},
dl:function(a,b,c){c.aS(a,b)},
$asaH:function(a,b){return[b]}},
dt:{"^":"bk;x,y,a,b,c,d,e,f,r,$ti",
aW:function(a){if((this.e&2)!==0)return
this.cV(a)},
aS:function(a,b){if((this.e&2)!==0)return
this.cW(a,b)},
bT:[function(){var z=this.y
if(z==null)return
z.cp(0)},"$0","gbS",0,0,2],
bV:[function(){var z=this.y
if(z==null)return
z.cr()},"$0","gbU",0,0,2],
bR:function(){var z=this.y
if(z!=null){this.y=null
return z.cc()}return},
f4:[function(a){this.x.bN(a,this)},"$1","gdi",2,0,function(){return H.dO(function(a,b){return{func:1,v:true,args:[a]}},this.$receiver,"dt")}],
f6:[function(a,b){this.x.dl(a,b,this)},"$2","gdk",4,0,15],
f5:[function(){this.d8()},"$0","gdj",0,0,2],
d3:function(a,b,c,d,e,f,g){this.y=this.x.a.cn(this.gdi(),this.gdj(),this.gdk())},
$asbk:function(a,b){return[b]},
p:{
ht:function(a,b,c,d,e,f,g){var z,y
z=$.l
y=e?1:0
y=new P.dt(a,null,null,null,null,z,y,null,null,[f,g])
y.d1(b,c,d,e,g)
y.d3(a,b,c,d,e,f,g)
return y}}},
hV:{"^":"c6;b,a,$ti",
bN:function(a,b){var z,y,x,w,v
z=null
try{z=this.b.$1(a)}catch(w){v=H.B(w)
y=v
x=H.N(w)
P.im(b,y,x)
return}b.aW(z)}},
b9:{"^":"b;a2:a>,a_:b<",
i:function(a){return H.d(this.a)},
$isI:1},
il:{"^":"b;"},
iy:{"^":"e:0;a,b",
$0:function(){var z,y,x
z=this.a
y=z.a
if(y==null){x=new P.bW()
z.a=x
z=x}else z=y
y=this.b
if(y==null)throw H.c(z)
x=H.c(z)
x.stack=J.E(y)
throw x}},
i3:{"^":"il;",
ct:function(a){var z,y,x,w
try{if(C.d===$.l){x=a.$0()
return x}x=P.dG(null,null,this,a)
return x}catch(w){x=H.B(w)
z=x
y=H.N(w)
return P.b5(null,null,this,z,y)}},
bn:function(a,b){var z,y,x,w
try{if(C.d===$.l){x=a.$1(b)
return x}x=P.dI(null,null,this,a,b)
return x}catch(w){x=H.B(w)
z=x
y=H.N(w)
return P.b5(null,null,this,z,y)}},
eS:function(a,b,c){var z,y,x,w
try{if(C.d===$.l){x=a.$2(b,c)
return x}x=P.dH(null,null,this,a,b,c)
return x}catch(w){x=H.B(w)
z=x
y=H.N(w)
return P.b5(null,null,this,z,y)}},
bc:function(a,b){if(b)return new P.i4(this,a)
else return new P.i5(this,a)},
cb:function(a,b){return new P.i6(this,a)},
h:function(a,b){return},
cs:function(a){if($.l===C.d)return a.$0()
return P.dG(null,null,this,a)},
bm:function(a,b){if($.l===C.d)return a.$1(b)
return P.dI(null,null,this,a,b)},
eR:function(a,b,c){if($.l===C.d)return a.$2(b,c)
return P.dH(null,null,this,a,b,c)}},
i4:{"^":"e:0;a,b",
$0:function(){return this.a.ct(this.b)}},
i5:{"^":"e:0;a,b",
$0:function(){return this.a.cs(this.b)}},
i6:{"^":"e:1;a,b",
$1:function(a){return this.a.bn(this.b,a)}}}],["","",,P,{"^":"",
bO:function(){return new H.aj(0,null,null,null,null,null,0,[null,null])},
aD:function(a){return H.iM(a,new H.aj(0,null,null,null,null,null,0,[null,null]))},
f0:function(a,b,c){var z,y
if(P.cc(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}z=[]
y=$.$get$aM()
y.push(a)
try{P.iu(a,z)}finally{if(0>=y.length)return H.a(y,-1)
y.pop()}y=P.d2(b,z,", ")+c
return y.charCodeAt(0)==0?y:y},
bd:function(a,b,c){var z,y,x
if(P.cc(a))return b+"..."+c
z=new P.c1(b)
y=$.$get$aM()
y.push(a)
try{x=z
x.B=P.d2(x.gB(),a,", ")}finally{if(0>=y.length)return H.a(y,-1)
y.pop()}y=z
y.B=y.gB()+c
y=z.gB()
return y.charCodeAt(0)==0?y:y},
cc:function(a){var z,y
for(z=0;y=$.$get$aM(),z<y.length;++z)if(a===y[z])return!0
return!1},
iu:function(a,b){var z,y,x,w,v,u,t,s,r,q
z=a.gv(a)
y=0
x=0
while(!0){if(!(y<80||x<3))break
if(!z.k())return
w=H.d(z.gt())
b.push(w)
y+=w.length+2;++x}if(!z.k()){if(x<=5)return
if(0>=b.length)return H.a(b,-1)
v=b.pop()
if(0>=b.length)return H.a(b,-1)
u=b.pop()}else{t=z.gt();++x
if(!z.k()){if(x<=4){b.push(H.d(t))
return}v=H.d(t)
if(0>=b.length)return H.a(b,-1)
u=b.pop()
y+=v.length+2}else{s=z.gt();++x
for(;z.k();t=s,s=r){r=z.gt();++x
if(x>100){while(!0){if(!(y>75&&x>3))break
if(0>=b.length)return H.a(b,-1)
y-=b.pop().length+2;--x}b.push("...")
return}}u=H.d(t)
v=H.d(s)
y+=v.length+u.length+4}}if(x>b.length+2){y+=5
q="..."}else q=null
while(!0){if(!(y>80&&b.length>3))break
if(0>=b.length)return H.a(b,-1)
y-=b.pop().length+2
if(q==null){y+=5
q="..."}}if(q!=null)b.push(q)
b.push(u)
b.push(v)},
M:function(a,b,c,d){return new P.hO(0,null,null,null,null,null,0,[d])},
cL:function(a,b){var z,y,x
z=P.M(null,null,null,b)
for(y=a.length,x=0;x<a.length;a.length===y||(0,H.a5)(a),++x)z.A(0,a[x])
return z},
cM:function(a){var z,y,x
z={}
if(P.cc(a))return"{...}"
y=new P.c1("")
try{$.$get$aM().push(a)
x=y
x.B=x.gB()+"{"
z.a=!0
a.X(0,new P.fh(z,y))
z=y
z.B=z.gB()+"}"}finally{z=$.$get$aM()
if(0>=z.length)return H.a(z,-1)
z.pop()}z=y.gB()
return z.charCodeAt(0)==0?z:z},
dA:{"^":"aj;a,b,c,d,e,f,r,$ti",
ao:function(a){return H.j3(a)&0x3ffffff},
ap:function(a,b){var z,y,x
if(a==null)return-1
z=a.length
for(y=0;y<z;++y){x=a[y].gcl()
if(x==null?b==null:x===b)return y}return-1},
p:{
aJ:function(a,b){return new P.dA(0,null,null,null,null,null,0,[a,b])}}},
hO:{"^":"hH;a,b,c,d,e,f,r,$ti",
gv:function(a){var z=new P.bo(this,this.r,null,null)
z.c=this.e
return z},
gj:function(a){return this.a},
q:function(a,b){var z,y
if(typeof b==="string"&&b!=="__proto__"){z=this.b
if(z==null)return!1
return z[b]!=null}else if(typeof b==="number"&&(b&0x3ffffff)===b){y=this.c
if(y==null)return!1
return y[b]!=null}else return this.dd(b)},
dd:function(a){var z=this.d
if(z==null)return!1
return this.aB(z[this.ay(a)],a)>=0},
bj:function(a){var z
if(!(typeof a==="string"&&a!=="__proto__"))z=typeof a==="number"&&(a&0x3ffffff)===a
else z=!0
if(z)return this.q(0,a)?a:null
else return this.dq(a)},
dq:function(a){var z,y,x
z=this.d
if(z==null)return
y=z[this.ay(a)]
x=this.aB(y,a)
if(x<0)return
return J.C(y,x).gbK()},
A:function(a,b){var z,y,x
if(typeof b==="string"&&b!=="__proto__"){z=this.b
if(z==null){y=Object.create(null)
y["<non-identifier-key>"]=y
delete y["<non-identifier-key>"]
this.b=y
z=y}return this.bE(z,b)}else if(typeof b==="number"&&(b&0x3ffffff)===b){x=this.c
if(x==null){y=Object.create(null)
y["<non-identifier-key>"]=y
delete y["<non-identifier-key>"]
this.c=y
x=y}return this.bE(x,b)}else return this.V(b)},
V:function(a){var z,y,x
z=this.d
if(z==null){z=P.hQ()
this.d=z}y=this.ay(a)
x=z[y]
if(x==null)z[y]=[this.aZ(a)]
else{if(this.aB(x,a)>=0)return!1
x.push(this.aZ(a))}return!0},
u:function(a,b){if(typeof b==="string"&&b!=="__proto__")return this.bF(this.b,b)
else if(typeof b==="number"&&(b&0x3ffffff)===b)return this.bF(this.c,b)
else return this.b6(b)},
b6:function(a){var z,y,x
z=this.d
if(z==null)return!1
y=z[this.ay(a)]
x=this.aB(y,a)
if(x<0)return!1
this.bG(y.splice(x,1)[0])
return!0},
K:function(a){if(this.a>0){this.f=null
this.e=null
this.d=null
this.c=null
this.b=null
this.a=0
this.r=this.r+1&67108863}},
bE:function(a,b){if(a[b]!=null)return!1
a[b]=this.aZ(b)
return!0},
bF:function(a,b){var z
if(a==null)return!1
z=a[b]
if(z==null)return!1
this.bG(z)
delete a[b]
return!0},
aZ:function(a){var z,y
z=new P.hP(a,null,null)
if(this.e==null){this.f=z
this.e=z}else{y=this.f
z.c=y
y.b=z
this.f=z}++this.a
this.r=this.r+1&67108863
return z},
bG:function(a){var z,y
z=a.gdc()
y=a.b
if(z==null)this.e=y
else z.b=y
if(y==null)this.f=z
else y.c=z;--this.a
this.r=this.r+1&67108863},
ay:function(a){return J.W(a)&0x3ffffff},
aB:function(a,b){var z,y
if(a==null)return-1
z=a.length
for(y=0;y<z;++y)if(J.x(a[y].gbK(),b))return y
return-1},
$isi:1,
$asi:null,
p:{
hQ:function(){var z=Object.create(null)
z["<non-identifier-key>"]=z
delete z["<non-identifier-key>"]
return z}}},
hP:{"^":"b;bK:a<,b,dc:c<"},
bo:{"^":"b;a,b,c,d",
gt:function(){return this.d},
k:function(){var z=this.a
if(this.b!==z.r)throw H.c(new P.S(z))
else{z=this.c
if(z==null){this.d=null
return!1}else{this.d=z.a
this.c=z.b
return!0}}}},
hH:{"^":"fv;$ti"},
bP:{"^":"fn;$ti"},
fn:{"^":"b+a8;",$ash:null,$asi:null,$ish:1,$isi:1},
a8:{"^":"b;$ti",
gv:function(a){return new H.a2(a,this.gj(a),0,null)},
H:function(a,b){return this.h(a,b)},
Y:function(a,b){return new H.b0(a,b,[H.A(a,"a8",0),null])},
u:function(a,b){var z
for(z=0;z<this.gj(a);++z)this.h(a,z)
return!1},
T:["bz",function(a,b,c,d,e){var z,y,x,w,v
P.c_(b,c,this.gj(a),null,null,null)
z=c-b
if(z===0)return
y=e<0
if(y)H.v(P.H(e,0,null,"skipCount",null))
if(H.b6(d,"$ish",[H.A(a,"a8",0)],"$ash")){x=e
w=d}else{if(y)H.v(P.H(e,0,null,"start",null))
w=new H.fD(d,e,null,[H.A(d,"a8",0)]).at(0,!1)
x=0}y=J.z(w)
if(x+z>y.gj(w))throw H.c(H.cG())
if(x<b)for(v=z-1;v>=0;--v)this.n(a,b+v,y.h(w,x+v))
else for(v=0;v<z;++v)this.n(a,b+v,y.h(w,x+v))}],
an:function(a,b,c){var z
if(c>=this.gj(a))return-1
for(z=c;z<this.gj(a);++z)if(this.h(a,z)===b)return z
return-1},
bg:function(a,b){return this.an(a,b,0)},
ac:function(a,b){var z=this.h(a,b)
this.T(a,b,this.gj(a)-1,a,b+1)
this.sj(a,this.gj(a)-1)
return z},
i:function(a){return P.bd(a,"[","]")},
$ish:1,
$ash:null,
$isi:1,
$asi:null},
fh:{"^":"e:16;a,b",
$2:function(a,b){var z,y
z=this.a
if(!z.a)this.b.B+=", "
z.a=!1
z=this.b
y=z.B+=H.d(a)
z.B=y+": "
z.B+=H.d(b)}},
ff:{"^":"aE;a,b,c,d,$ti",
gv:function(a){return new P.hR(this,this.c,this.d,this.b,null)},
gG:function(a){return this.b===this.c},
gj:function(a){return(this.c-this.b&this.a.length-1)>>>0},
H:function(a,b){var z,y,x,w
z=(this.c-this.b&this.a.length-1)>>>0
if(0>b||b>=z)H.v(P.aC(b,this,"index",null,z))
y=this.a
x=y.length
w=(this.b+b&x-1)>>>0
if(w<0||w>=x)return H.a(y,w)
return y[w]},
u:function(a,b){var z,y
for(z=this.b;z!==this.c;z=(z+1&this.a.length-1)>>>0){y=this.a
if(z<0||z>=y.length)return H.a(y,z)
if(J.x(y[z],b)){this.b6(z);++this.d
return!0}}return!1},
K:function(a){var z,y,x,w,v
z=this.b
y=this.c
if(z!==y){for(x=this.a,w=x.length,v=w-1;z!==y;z=(z+1&v)>>>0){if(z<0||z>=w)return H.a(x,z)
x[z]=null}this.c=0
this.b=0;++this.d}},
i:function(a){return P.bd(this,"{","}")},
cq:function(){var z,y,x,w
z=this.b
if(z===this.c)throw H.c(H.bJ());++this.d
y=this.a
x=y.length
if(z>=x)return H.a(y,z)
w=y[z]
y[z]=null
this.b=(z+1&x-1)>>>0
return w},
V:function(a){var z,y,x
z=this.a
y=this.c
x=z.length
if(y<0||y>=x)return H.a(z,y)
z[y]=a
x=(y+1&x-1)>>>0
this.c=x
if(this.b===x)this.bL();++this.d},
b6:function(a){var z,y,x,w,v,u,t,s
z=this.a
y=z.length
x=y-1
w=this.b
v=this.c
if((a-w&x)>>>0<(v-a&x)>>>0){for(u=a;u!==w;u=t){t=(u-1&x)>>>0
if(t<0||t>=y)return H.a(z,t)
v=z[t]
if(u<0||u>=y)return H.a(z,u)
z[u]=v}if(w>=y)return H.a(z,w)
z[w]=null
this.b=(w+1&x)>>>0
return(a+1&x)>>>0}else{w=(v-1&x)>>>0
this.c=w
for(u=a;u!==w;u=s){s=(u+1&x)>>>0
if(s<0||s>=y)return H.a(z,s)
v=z[s]
if(u<0||u>=y)return H.a(z,u)
z[u]=v}if(w<0||w>=y)return H.a(z,w)
z[w]=null
return a}},
bL:function(){var z,y,x,w
z=new Array(this.a.length*2)
z.fixed$length=Array
y=H.j(z,this.$ti)
z=this.a
x=this.b
w=z.length-x
C.b.T(y,0,w,z,x)
C.b.T(y,w,w+this.b,this.a,0)
this.b=0
this.c=this.a.length
this.a=y},
cY:function(a,b){var z=new Array(8)
z.fixed$length=Array
this.a=H.j(z,[b])},
$asi:null,
p:{
bQ:function(a,b){var z=new P.ff(null,0,0,0,[b])
z.cY(a,b)
return z}}},
hR:{"^":"b;a,b,c,d,e",
gt:function(){return this.e},
k:function(){var z,y,x
z=this.a
if(this.c!==z.d)H.v(new P.S(z))
y=this.d
if(y===this.b){this.e=null
return!1}z=z.a
x=z.length
if(y>=x)return H.a(z,y)
this.e=z[y]
this.d=(y+1&x-1)>>>0
return!0}},
fw:{"^":"b;$ti",
P:function(a,b){var z
for(z=J.aU(b);z.k();)this.A(0,z.gt())},
Y:function(a,b){return new H.bE(this,b,[H.a4(this,0),null])},
i:function(a){return P.bd(this,"{","}")},
ab:function(a,b){var z,y
z=new P.bo(this,this.r,null,null)
z.c=this.e
if(!z.k())return""
if(b===""){y=""
do y+=H.d(z.d)
while(z.k())}else{y=H.d(z.d)
for(;z.k();)y=y+b+H.d(z.d)}return y.charCodeAt(0)==0?y:y},
$isi:1,
$asi:null},
fv:{"^":"fw;$ti"}}],["","",,P,{"^":"",
br:function(a){var z
if(a==null)return
if(typeof a!="object")return a
if(Object.getPrototypeOf(a)!==Array.prototype)return new P.hN(a,Object.create(null),null)
for(z=0;z<a.length;++z)a[z]=P.br(a[z])
return a},
ix:function(a,b){var z,y,x,w
if(typeof a!=="string")throw H.c(H.L(a))
z=null
try{z=JSON.parse(a)}catch(x){w=H.B(x)
y=w
throw H.c(new P.bI(String(y),null,null))}return P.br(z)},
hN:{"^":"b;a,b,c",
h:function(a,b){var z,y
z=this.b
if(z==null)return this.c.h(0,b)
else if(typeof b!=="string")return
else{y=z[b]
return typeof y=="undefined"?this.du(b):y}},
gj:function(a){var z
if(this.b==null){z=this.c
z=z.gj(z)}else z=this.az().length
return z},
gG:function(a){var z
if(this.b==null){z=this.c
z=z.gj(z)}else z=this.az().length
return z===0},
n:function(a,b,c){var z,y
if(this.b==null)this.c.n(0,b,c)
else if(this.aa(b)){z=this.b
z[b]=c
y=this.a
if(y==null?z!=null:y!==z)y[b]=null}else this.c7().n(0,b,c)},
aa:function(a){if(this.b==null)return this.c.aa(a)
if(typeof a!=="string")return!1
return Object.prototype.hasOwnProperty.call(this.a,a)},
u:function(a,b){if(this.b!=null&&!this.aa(b))return
return this.c7().u(0,b)},
X:function(a,b){var z,y,x,w
if(this.b==null)return this.c.X(0,b)
z=this.az()
for(y=0;y<z.length;++y){x=z[y]
w=this.b[x]
if(typeof w=="undefined"){w=P.br(this.a[x])
this.b[x]=w}b.$2(x,w)
if(z!==this.c)throw H.c(new P.S(this))}},
i:function(a){return P.cM(this)},
az:function(){var z=this.c
if(z==null){z=Object.keys(this.a)
this.c=z}return z},
c7:function(){var z,y,x,w,v
if(this.b==null)return this.c
z=P.bO()
y=this.az()
for(x=0;w=y.length,x<w;++x){v=y[x]
z.n(0,v,this.h(0,v))}if(w===0)y.push(null)
else C.b.sj(y,0)
this.b=null
this.a=null
this.c=z
return z},
du:function(a){var z
if(!Object.prototype.hasOwnProperty.call(this.a,a))return
z=P.br(this.a[a])
return this.b[a]=z}},
es:{"^":"b;"},
eu:{"^":"b;"},
fa:{"^":"es;a,b",
dY:function(a,b){return P.ix(a,this.gdZ().a)},
dX:function(a){return this.dY(a,null)},
gdZ:function(){return C.X}},
fb:{"^":"eu;a"}}],["","",,P,{"^":"",
cz:function(a){if(typeof a==="number"||typeof a==="boolean"||null==a)return J.E(a)
if(typeof a==="string")return JSON.stringify(a)
return P.eD(a)},
eD:function(a){var z=J.n(a)
if(!!z.$ise)return z.i(a)
return H.bh(a)},
bb:function(a){return new P.hs(a)},
be:function(a,b,c){var z,y
z=H.j([],[c])
for(y=J.aU(a);y.k();)z.push(y.gt())
return z},
ch:function(a){var z=H.d(a)
H.j4(z)},
ft:function(a,b,c){return new H.cK(a,H.bK(a,!1,!0,!1),null,null)},
aN:{"^":"b;"},
"+bool":0,
ji:{"^":"b;"},
ab:{"^":"av;"},
"+double":0,
a0:{"^":"b;aA:a<",
S:function(a,b){return new P.a0(this.a+b.gaA())},
ag:function(a,b){return new P.a0(this.a-b.gaA())},
O:function(a,b){return new P.a0(C.a.eQ(this.a*b))},
aR:function(a,b){if(b===0)throw H.c(new P.eN())
if(typeof b!=="number")return H.w(b)
return new P.a0(C.a.aR(this.a,b))},
ae:function(a,b){return C.a.ae(this.a,b.gaA())},
ad:function(a,b){return this.a>b.gaA()},
w:function(a,b){if(b==null)return!1
if(!(b instanceof P.a0))return!1
return this.a===b.a},
gC:function(a){return this.a&0x1FFFFFFF},
i:function(a){var z,y,x,w,v
z=new P.eB()
y=this.a
if(y<0)return"-"+new P.a0(0-y).i(0)
x=z.$1(C.a.D(y,6e7)%60)
w=z.$1(C.a.D(y,1e6)%60)
v=new P.eA().$1(y%1e6)
return H.d(C.a.D(y,36e8))+":"+H.d(x)+":"+H.d(w)+"."+H.d(v)},
p:{
bD:function(a,b,c,d,e,f){if(typeof c!=="number")return H.w(c)
return new P.a0(864e8*a+36e8*b+6e7*e+1e6*f+1000*d+c)}}},
eA:{"^":"e:6;",
$1:function(a){if(a>=1e5)return H.d(a)
if(a>=1e4)return"0"+H.d(a)
if(a>=1000)return"00"+H.d(a)
if(a>=100)return"000"+H.d(a)
if(a>=10)return"0000"+H.d(a)
return"00000"+H.d(a)}},
eB:{"^":"e:6;",
$1:function(a){if(a>=10)return""+a
return"0"+a}},
I:{"^":"b;",
ga_:function(){return H.N(this.$thrownJsError)}},
bW:{"^":"I;",
i:function(a){return"Throw of null."}},
a6:{"^":"I;a,b,c,d",
gb0:function(){return"Invalid argument"+(!this.a?"(s)":"")},
gb_:function(){return""},
i:function(a){var z,y,x,w,v,u
z=this.c
y=z!=null?" ("+z+")":""
z=this.d
x=z==null?"":": "+H.d(z)
w=this.gb0()+y+x
if(!this.a)return w
v=this.gb_()
u=P.cz(this.b)
return w+v+": "+H.d(u)},
p:{
b8:function(a){return new P.a6(!1,null,null,a)},
bz:function(a,b,c){return new P.a6(!0,a,b,c)}}},
bZ:{"^":"a6;e,f,a,b,c,d",
gb0:function(){return"RangeError"},
gb_:function(){var z,y,x
z=this.e
if(z==null){z=this.f
y=z!=null?": Not less than or equal to "+H.d(z):""}else{x=this.f
if(x==null)y=": Not greater than or equal to "+H.d(z)
else if(x>z)y=": Not in range "+H.d(z)+".."+H.d(x)+", inclusive"
else y=x<z?": Valid value range is empty":": Only valid value is "+H.d(z)}return y},
p:{
cZ:function(a){return new P.bZ(null,null,!1,null,null,a)},
aG:function(a,b,c){return new P.bZ(null,null,!0,a,b,"Value not in range")},
H:function(a,b,c,d,e){return new P.bZ(b,c,!0,a,d,"Invalid value")},
c_:function(a,b,c,d,e,f){if(0>a||a>c)throw H.c(P.H(a,0,c,"start",f))
if(a>b||b>c)throw H.c(P.H(b,a,c,"end",f))
return b}}},
eM:{"^":"a6;e,j:f>,a,b,c,d",
gb0:function(){return"RangeError"},
gb_:function(){if(J.cj(this.b,0))return": index must not be negative"
var z=this.f
if(z===0)return": no indices are valid"
return": index should be less than "+H.d(z)},
p:{
aC:function(a,b,c,d,e){var z=e!=null?e:J.D(b)
return new P.eM(b,z,!0,a,c,"Index out of range")}}},
t:{"^":"I;a",
i:function(a){return"Unsupported operation: "+this.a}},
dm:{"^":"I;a",
i:function(a){var z=this.a
return z!=null?"UnimplementedError: "+H.d(z):"UnimplementedError"}},
Z:{"^":"I;a",
i:function(a){return"Bad state: "+this.a}},
S:{"^":"I;a",
i:function(a){var z=this.a
if(z==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+H.d(P.cz(z))+"."}},
d1:{"^":"b;",
i:function(a){return"Stack Overflow"},
ga_:function(){return},
$isI:1},
ey:{"^":"I;a",
i:function(a){var z=this.a
return z==null?"Reading static variable during its initialization":"Reading static variable '"+H.d(z)+"' during its initialization"}},
hs:{"^":"b;a",
i:function(a){var z=this.a
if(z==null)return"Exception"
return"Exception: "+H.d(z)}},
bI:{"^":"b;a,b,c",
i:function(a){var z,y,x
z=this.a
y=z!=null&&""!==z?"FormatException: "+H.d(z):"FormatException"
x=this.b
if(typeof x!=="string")return y
if(x.length>78)x=C.e.ah(x,0,75)+"..."
return y+"\n"+x}},
eN:{"^":"b;",
i:function(a){return"IntegerDivisionByZeroException"}},
eE:{"^":"b;a,bQ",
i:function(a){return"Expando:"+H.d(this.a)},
h:function(a,b){var z,y
z=this.bQ
if(typeof z!=="string"){if(b==null||typeof b==="boolean"||typeof b==="number"||typeof b==="string")H.v(P.bz(b,"Expandos are not allowed on strings, numbers, booleans or null",null))
return z.get(b)}y=H.bX(b,"expando$values")
return y==null?null:H.bX(y,z)},
n:function(a,b,c){var z,y
z=this.bQ
if(typeof z!=="string")z.set(b,c)
else{y=H.bX(b,"expando$values")
if(y==null){y=new P.b()
H.cX(b,"expando$values",y)}H.cX(y,z,c)}}},
eF:{"^":"b;"},
k:{"^":"av;"},
"+int":0,
J:{"^":"b;$ti",
Y:function(a,b){return H.bf(this,b,H.A(this,"J",0),null)},
bs:["cT",function(a,b){return new H.dn(this,b,[H.A(this,"J",0)])}],
at:function(a,b){return P.be(this,!0,H.A(this,"J",0))},
aL:function(a){return this.at(a,!0)},
gj:function(a){var z,y
z=this.gv(this)
for(y=0;z.k();)++y
return y},
gG:function(a){return!this.gv(this).k()},
ga7:function(a){var z,y
z=this.gv(this)
if(!z.k())throw H.c(H.bJ())
y=z.gt()
if(z.k())throw H.c(H.f1())
return y},
H:function(a,b){var z,y,x
if(b<0)H.v(P.H(b,0,null,"index",null))
for(z=this.gv(this),y=0;z.k();){x=z.gt()
if(b===y)return x;++y}throw H.c(P.aC(b,this,"index",null,y))},
i:function(a){return P.f0(this,"(",")")}},
cH:{"^":"b;"},
h:{"^":"b;$ti",$ash:null,$isi:1,$asi:null},
"+List":0,
fm:{"^":"b;",
gC:function(a){return P.b.prototype.gC.call(this,this)},
i:function(a){return"null"}},
"+Null":0,
av:{"^":"b;"},
"+num":0,
b:{"^":";",
w:function(a,b){return this===b},
gC:function(a){return H.a9(this)},
i:function(a){return H.bh(this)},
toString:function(){return this.i(this)}},
fi:{"^":"b;"},
al:{"^":"b;"},
c0:{"^":"b;a,b",
bx:function(a){if(this.b!=null){this.a=J.ax(this.a,J.ac($.T.$0(),this.b))
this.b=null}}},
u:{"^":"b;"},
"+String":0,
c1:{"^":"b;B<",
gj:function(a){return this.B.length},
i:function(a){var z=this.B
return z.charCodeAt(0)==0?z:z},
p:{
d2:function(a,b,c){var z=J.aU(b)
if(!z.k())return a
if(c.length===0){do a+=H.d(z.gt())
while(z.k())}else{a+=H.d(z.gt())
for(;z.k();)a=a+c+H.d(z.gt())}return a}}}}],["","",,W,{"^":"",
eC:function(a,b,c){var z,y
z=document.body
y=(z&&C.q).L(z,a,b,c)
y.toString
z=new H.dn(new W.V(y),new W.iJ(),[W.p])
return z.ga7(z)},
aA:function(a){var z,y,x
z="element tag unavailable"
try{y=J.ec(a)
if(typeof y==="string")z=a.tagName}catch(x){H.B(x)}return z},
eI:function(a,b,c){return W.eK(a,null,null,b,null,null,null,c).bo(new W.eJ())},
eK:function(a,b,c,d,e,f,g,h){var z,y,x,w
z=W.aW
y=new P.Q(0,$.l,null,[z])
x=new P.h9(y,[z])
w=new XMLHttpRequest()
C.N.eA(w,"GET",a,!0)
z=W.kg
W.c5(w,"load",new W.eL(x,w),!1,z)
W.c5(w,"error",x.gdO(),!1,z)
w.send()
return y},
aa:function(a,b){a=536870911&a+b
a=536870911&a+((524287&a)<<10)
return a^a>>>6},
dz:function(a){a=536870911&a+((67108863&a)<<3)
a^=a>>>11
return 536870911&a+((16383&a)<<15)},
iC:function(a){var z=$.l
if(z===C.d)return a
return z.cb(a,!0)},
q:{"^":"a1;","%":"HTMLAppletElement|HTMLBRElement|HTMLCanvasElement|HTMLContentElement|HTMLDListElement|HTMLDataListElement|HTMLDetailsElement|HTMLDialogElement|HTMLDirectoryElement|HTMLDivElement|HTMLFontElement|HTMLFrameElement|HTMLHRElement|HTMLHeadElement|HTMLHeadingElement|HTMLHtmlElement|HTMLLIElement|HTMLLabelElement|HTMLLegendElement|HTMLMarqueeElement|HTMLMenuElement|HTMLMenuItemElement|HTMLMeterElement|HTMLModElement|HTMLOListElement|HTMLOptGroupElement|HTMLOptionElement|HTMLParagraphElement|HTMLPictureElement|HTMLPreElement|HTMLProgressElement|HTMLQuoteElement|HTMLScriptElement|HTMLShadowElement|HTMLSourceElement|HTMLSpanElement|HTMLStyleElement|HTMLTableCaptionElement|HTMLTableColElement|HTMLTitleElement|HTMLTrackElement|HTMLUListElement|HTMLUnknownElement|PluginPlaceholderElement;HTMLElement"},
jb:{"^":"q;aH:href}",
i:function(a){return String(a)},
$isf:1,
"%":"HTMLAnchorElement"},
jd:{"^":"q;aH:href}",
i:function(a){return String(a)},
$isf:1,
"%":"HTMLAreaElement"},
je:{"^":"q;aH:href}","%":"HTMLBaseElement"},
bA:{"^":"q;",$isbA:1,$isf:1,"%":"HTMLBodyElement"},
jf:{"^":"q;E:name=","%":"HTMLButtonElement"},
jg:{"^":"p;j:length=",$isf:1,"%":"CDATASection|CharacterData|Comment|ProcessingInstruction|Text"},
jh:{"^":"eO;j:length=","%":"CSS2Properties|CSSStyleDeclaration|MSStyleCSSProperties"},
eO:{"^":"f+ex;"},
ex:{"^":"b;"},
jj:{"^":"p;",$isf:1,"%":"DocumentFragment|ShadowRoot"},
jk:{"^":"f;",
i:function(a){return String(a)},
"%":"DOMException"},
ez:{"^":"f;",
i:function(a){return"Rectangle ("+H.d(a.left)+", "+H.d(a.top)+") "+H.d(this.ga6(a))+" x "+H.d(this.ga4(a))},
w:function(a,b){var z
if(b==null)return!1
z=J.n(b)
if(!z.$isb1)return!1
return a.left===z.gbi(b)&&a.top===z.gbq(b)&&this.ga6(a)===z.ga6(b)&&this.ga4(a)===z.ga4(b)},
gC:function(a){var z,y,x,w
z=a.left
y=a.top
x=this.ga6(a)
w=this.ga4(a)
return W.dz(W.aa(W.aa(W.aa(W.aa(0,z&0x1FFFFFFF),y&0x1FFFFFFF),x&0x1FFFFFFF),w&0x1FFFFFFF))},
ga4:function(a){return a.height},
gbi:function(a){return a.left},
gbq:function(a){return a.top},
ga6:function(a){return a.width},
gl:function(a){return a.x},
gm:function(a){return a.y},
$isb1:1,
$asb1:I.G,
"%":";DOMRectReadOnly"},
jl:{"^":"f;j:length=",
u:function(a,b){return a.remove(b)},
"%":"DOMSettableTokenList|DOMTokenList"},
aI:{"^":"bP;a,$ti",
gj:function(a){return this.a.length},
h:function(a,b){var z=this.a
if(b>>>0!==b||b>=z.length)return H.a(z,b)
return z[b]},
n:function(a,b,c){throw H.c(new P.t("Cannot modify list"))},
sj:function(a,b){throw H.c(new P.t("Cannot modify list"))},
gF:function(a){return W.hX(this)},
$ish:1,
$ash:null,
$isi:1,
$asi:null},
a1:{"^":"p;dM:className},a5:id=,eT:tagName=",
gdL:function(a){return new W.bm(a)},
gF:function(a){return new W.hn(a)},
gdW:function(a){return new W.c4(new W.bm(a))},
i:function(a){return a.localName},
L:["aQ",function(a,b,c,d){var z,y,x,w,v
if(c==null){z=$.cy
if(z==null){z=H.j([],[W.bV])
y=new W.cR(z)
z.push(W.dw(null))
z.push(W.dD())
$.cy=y
d=y}else d=z
z=$.cx
if(z==null){z=new W.dE(d)
$.cx=z
c=z}else{z.a=d
c=z}}if($.a7==null){z=document
y=z.implementation.createHTMLDocument("")
$.a7=y
$.bF=y.createRange()
y=$.a7
y.toString
x=y.createElement("base")
J.ek(x,z.baseURI)
$.a7.head.appendChild(x)}z=$.a7
if(!!this.$isbA)w=z.body
else{y=a.tagName
z.toString
w=z.createElement(y)
$.a7.body.appendChild(w)}if("createContextualFragment" in window.Range.prototype&&!C.b.q(C.Z,a.tagName)){$.bF.selectNodeContents(w)
v=$.bF.createContextualFragment(b)}else{w.innerHTML=b
v=$.a7.createDocumentFragment()
for(;z=w.firstChild,z!=null;)v.appendChild(z)}z=$.a7.body
if(w==null?z!=null:w!==z)J.ef(w)
c.bu(v)
document.adoptNode(v)
return v},function(a,b,c){return this.L(a,b,c,null)},"dT",null,null,"gf7",2,5,null,0,0],
scm:function(a,b){this.aO(a,b)},
aP:function(a,b,c,d){a.textContent=null
a.appendChild(this.L(a,b,c,d))},
aO:function(a,b){return this.aP(a,b,null,null)},
$isa1:1,
$isp:1,
$isb:1,
$isf:1,
"%":";Element"},
iJ:{"^":"e:1;",
$1:function(a){return!!J.n(a).$isa1}},
jm:{"^":"q;E:name=","%":"HTMLEmbedElement"},
jn:{"^":"bG;a2:error=","%":"ErrorEvent"},
bG:{"^":"f;","%":"AnimationEvent|AnimationPlayerEvent|ApplicationCacheErrorEvent|AudioProcessingEvent|AutocompleteErrorEvent|BeforeInstallPromptEvent|BeforeUnloadEvent|ClipboardEvent|CloseEvent|CompositionEvent|CrossOriginConnectEvent|CustomEvent|DefaultSessionStartEvent|DeviceLightEvent|DeviceMotionEvent|DeviceOrientationEvent|DragEvent|ExtendableEvent|FetchEvent|FocusEvent|FontFaceSetLoadEvent|GamepadEvent|HashChangeEvent|IDBVersionChangeEvent|KeyboardEvent|MIDIConnectionEvent|MIDIMessageEvent|MediaEncryptedEvent|MediaKeyEvent|MediaKeyMessageEvent|MediaQueryListEvent|MediaStreamEvent|MediaStreamTrackEvent|MessageEvent|MouseEvent|NotificationEvent|OfflineAudioCompletionEvent|PageTransitionEvent|PeriodicSyncEvent|PointerEvent|PopStateEvent|ProgressEvent|PromiseRejectionEvent|PushEvent|RTCDTMFToneChangeEvent|RTCDataChannelEvent|RTCIceCandidateEvent|RTCPeerConnectionIceEvent|RelatedEvent|ResourceProgressEvent|SVGZoomEvent|SecurityPolicyViolationEvent|ServicePortConnectEvent|ServiceWorkerMessageEvent|SpeechRecognitionEvent|SpeechSynthesisEvent|StorageEvent|SyncEvent|TextEvent|TouchEvent|TrackEvent|TransitionEvent|UIEvent|WebGLContextEvent|WebKitTransitionEvent|WheelEvent|XMLHttpRequestProgressEvent;Event|InputEvent"},
aV:{"^":"f;",
c8:function(a,b,c,d){if(c!=null)this.aT(a,b,c,d)},
dH:function(a,b,c){return this.c8(a,b,c,null)},
eG:function(a,b,c,d){if(c!=null)this.dv(a,b,c,!1)},
aT:function(a,b,c,d){return a.addEventListener(b,H.ar(c,1),d)},
dv:function(a,b,c,d){return a.removeEventListener(b,H.ar(c,1),!1)},
"%":"CrossOriginServiceWorkerClient|MediaQueryList;EventTarget"},
jG:{"^":"q;E:name=","%":"HTMLFieldSetElement"},
jJ:{"^":"q;j:length=,E:name=","%":"HTMLFormElement"},
jK:{"^":"bG;a5:id=","%":"GeofencingEvent"},
aW:{"^":"eH;eP:responseText=",
fg:function(a,b,c,d,e,f){return a.open(b,c,!0,f,e)},
eA:function(a,b,c,d){return a.open(b,c,d)},
av:function(a,b){return a.send(b)},
$isaW:1,
$isb:1,
"%":"XMLHttpRequest"},
eJ:{"^":"e:17;",
$1:function(a){return J.eb(a)}},
eL:{"^":"e:1;a,b",
$1:function(a){var z,y,x,w,v
z=this.b
y=z.status
if(typeof y!=="number")return y.f_()
x=y>=200&&y<300
w=y>307&&y<400
y=x||y===0||y===304||w
v=this.a
if(y)v.aG(0,z)
else v.dP(a)}},
eH:{"^":"aV;","%":";XMLHttpRequestEventTarget"},
jL:{"^":"q;E:name=","%":"HTMLIFrameElement"},
jM:{"^":"q;",
aG:function(a,b){return a.complete.$1(b)},
"%":"HTMLImageElement"},
jO:{"^":"q;E:name=",$isa1:1,$isf:1,"%":"HTMLInputElement"},
jR:{"^":"q;E:name=","%":"HTMLKeygenElement"},
jS:{"^":"q;aH:href}","%":"HTMLLinkElement"},
jT:{"^":"f;",
i:function(a){return String(a)},
"%":"Location"},
jU:{"^":"q;E:name=","%":"HTMLMapElement"},
jX:{"^":"q;a2:error=","%":"HTMLAudioElement|HTMLMediaElement|HTMLVideoElement"},
jY:{"^":"aV;a5:id=","%":"MediaStream"},
jZ:{"^":"q;E:name=","%":"HTMLMetaElement"},
k_:{"^":"fj;",
f0:function(a,b,c){return a.send(b,c)},
av:function(a,b){return a.send(b)},
"%":"MIDIOutput"},
fj:{"^":"aV;a5:id=","%":"MIDIInput;MIDIPort"},
k9:{"^":"f;",$isf:1,"%":"Navigator"},
V:{"^":"bP;a",
ga7:function(a){var z,y
z=this.a
y=z.childNodes.length
if(y===0)throw H.c(new P.Z("No elements"))
if(y>1)throw H.c(new P.Z("More than one element"))
return z.firstChild},
P:function(a,b){var z,y,x,w
z=b.a
y=this.a
if(z!==y)for(x=z.childNodes.length,w=0;w<x;++w)y.appendChild(z.firstChild)
return},
ac:function(a,b){var z,y,x
z=this.a
y=z.childNodes
if(b<0||b>=y.length)return H.a(y,b)
x=y[b]
z.removeChild(x)
return x},
u:function(a,b){return!1},
n:function(a,b,c){var z,y
z=this.a
y=z.childNodes
if(b>>>0!==b||b>=y.length)return H.a(y,b)
z.replaceChild(c,y[b])},
gv:function(a){var z=this.a.childNodes
return new W.cC(z,z.length,-1,null)},
T:function(a,b,c,d,e){throw H.c(new P.t("Cannot setRange on Node list"))},
gj:function(a){return this.a.childNodes.length},
sj:function(a,b){throw H.c(new P.t("Cannot set length on immutable List."))},
h:function(a,b){var z=this.a.childNodes
if(b>>>0!==b||b>=z.length)return H.a(z,b)
return z[b]},
$asbP:function(){return[W.p]},
$ash:function(){return[W.p]},
$asi:function(){return[W.p]}},
p:{"^":"aV;eB:parentNode=,eC:previousSibling=,eU:textContent=",
gez:function(a){return new W.V(a)},
eE:function(a){var z=a.parentNode
if(z!=null)z.removeChild(a)},
i:function(a){var z=a.nodeValue
return z==null?this.cS(a):z},
$isp:1,
$isb:1,
"%":"Document|HTMLDocument|XMLDocument;Node"},
ka:{"^":"eR;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)throw H.c(P.aC(b,a,null,null,null))
return a[b]},
n:function(a,b,c){throw H.c(new P.t("Cannot assign element of immutable List."))},
sj:function(a,b){throw H.c(new P.t("Cannot resize immutable List."))},
H:function(a,b){if(b<0||b>=a.length)return H.a(a,b)
return a[b]},
$ish:1,
$ash:function(){return[W.p]},
$isi:1,
$asi:function(){return[W.p]},
$isP:1,
$asP:function(){return[W.p]},
$isK:1,
$asK:function(){return[W.p]},
"%":"NodeList|RadioNodeList"},
eP:{"^":"f+a8;",
$ash:function(){return[W.p]},
$asi:function(){return[W.p]},
$ish:1,
$isi:1},
eR:{"^":"eP+cD;",
$ash:function(){return[W.p]},
$asi:function(){return[W.p]},
$ish:1,
$isi:1},
kb:{"^":"q;E:name=","%":"HTMLObjectElement"},
kc:{"^":"q;E:name=","%":"HTMLOutputElement"},
kd:{"^":"q;E:name=","%":"HTMLParamElement"},
ki:{"^":"q;j:length=,E:name=","%":"HTMLSelectElement"},
kj:{"^":"bG;a2:error=","%":"SpeechRecognitionError"},
kn:{"^":"q;dN:colSpan}","%":"HTMLTableCellElement|HTMLTableDataCellElement|HTMLTableHeaderCellElement"},
fY:{"^":"q;",
aF:function(a){return a.insertRow(-1)},
L:function(a,b,c,d){var z,y
if("createContextualFragment" in window.Range.prototype)return this.aQ(a,b,c,d)
z=W.eC("<table>"+b+"</table>",c,d)
y=document.createDocumentFragment()
y.toString
new W.V(y).P(0,J.e8(z))
return y},
"%":"HTMLTableElement"},
ko:{"^":"q;",
bb:function(a){return a.insertCell(-1)},
L:function(a,b,c,d){var z,y,x,w
if("createContextualFragment" in window.Range.prototype)return this.aQ(a,b,c,d)
z=document
y=z.createDocumentFragment()
z=C.G.L(z.createElement("table"),b,c,d)
z.toString
z=new W.V(z)
x=z.ga7(z)
x.toString
z=new W.V(x)
w=z.ga7(z)
y.toString
w.toString
new W.V(y).P(0,new W.V(w))
return y},
"%":"HTMLTableRowElement"},
kp:{"^":"q;",
aF:function(a){return a.insertRow(-1)},
L:function(a,b,c,d){var z,y,x
if("createContextualFragment" in window.Range.prototype)return this.aQ(a,b,c,d)
z=document
y=z.createDocumentFragment()
z=C.G.L(z.createElement("table"),b,c,d)
z.toString
z=new W.V(z)
x=z.ga7(z)
y.toString
x.toString
new W.V(y).P(0,new W.V(x))
return y},
"%":"HTMLTableSectionElement"},
d7:{"^":"q;",
aP:function(a,b,c,d){var z
a.textContent=null
z=this.L(a,b,c,d)
a.content.appendChild(z)},
aO:function(a,b){return this.aP(a,b,null,null)},
$isd7:1,
"%":"HTMLTemplateElement"},
kq:{"^":"q;E:name=","%":"HTMLTextAreaElement"},
h8:{"^":"aV;",$isf:1,"%":"DOMWindow|Window"},
ky:{"^":"p;E:name=","%":"Attr"},
kz:{"^":"f;a4:height=,bi:left=,bq:top=,a6:width=",
i:function(a){return"Rectangle ("+H.d(a.left)+", "+H.d(a.top)+") "+H.d(a.width)+" x "+H.d(a.height)},
w:function(a,b){var z,y,x
if(b==null)return!1
z=J.n(b)
if(!z.$isb1)return!1
y=a.left
x=z.gbi(b)
if(y==null?x==null:y===x){y=a.top
x=z.gbq(b)
if(y==null?x==null:y===x){y=a.width
x=z.ga6(b)
if(y==null?x==null:y===x){y=a.height
z=z.ga4(b)
z=y==null?z==null:y===z}else z=!1}else z=!1}else z=!1
return z},
gC:function(a){var z,y,x,w
z=J.W(a.left)
y=J.W(a.top)
x=J.W(a.width)
w=J.W(a.height)
return W.dz(W.aa(W.aa(W.aa(W.aa(0,z),y),x),w))},
$isb1:1,
$asb1:I.G,
"%":"ClientRect"},
kA:{"^":"p;",$isf:1,"%":"DocumentType"},
kB:{"^":"ez;",
ga4:function(a){return a.height},
ga6:function(a){return a.width},
gl:function(a){return a.x},
gm:function(a){return a.y},
"%":"DOMRect"},
kF:{"^":"q;",$isf:1,"%":"HTMLFrameSetElement"},
kI:{"^":"eS;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)throw H.c(P.aC(b,a,null,null,null))
return a[b]},
n:function(a,b,c){throw H.c(new P.t("Cannot assign element of immutable List."))},
sj:function(a,b){throw H.c(new P.t("Cannot resize immutable List."))},
H:function(a,b){if(b<0||b>=a.length)return H.a(a,b)
return a[b]},
$ish:1,
$ash:function(){return[W.p]},
$isi:1,
$asi:function(){return[W.p]},
$isP:1,
$asP:function(){return[W.p]},
$isK:1,
$asK:function(){return[W.p]},
"%":"MozNamedAttrMap|NamedNodeMap"},
eQ:{"^":"f+a8;",
$ash:function(){return[W.p]},
$asi:function(){return[W.p]},
$ish:1,
$isi:1},
eS:{"^":"eQ+cD;",
$ash:function(){return[W.p]},
$asi:function(){return[W.p]},
$ish:1,
$isi:1},
hg:{"^":"b;bO:a<",
X:function(a,b){var z,y,x,w,v
for(z=this.gR(),y=z.length,x=this.a,w=0;w<z.length;z.length===y||(0,H.a5)(z),++w){v=z[w]
b.$2(v,x.getAttribute(v))}},
gR:function(){var z,y,x,w,v
z=this.a.attributes
y=H.j([],[P.u])
for(x=z.length,w=0;w<x;++w){if(w>=z.length)return H.a(z,w)
v=z[w]
if(v.namespaceURI==null)y.push(J.e7(v))}return y}},
bm:{"^":"hg;a",
h:function(a,b){return this.a.getAttribute(b)},
n:function(a,b,c){this.a.setAttribute(b,c)},
u:function(a,b){var z,y
z=this.a
y=z.getAttribute(b)
z.removeAttribute(b)
return y},
gj:function(a){return this.gR().length}},
c4:{"^":"b;a",
h:function(a,b){return this.a.a.getAttribute("data-"+this.a8(b))},
n:function(a,b,c){this.a.a.setAttribute("data-"+this.a8(b),c)},
u:function(a,b){var z,y,x
z="data-"+this.a8(b)
y=this.a.a
x=y.getAttribute(z)
y.removeAttribute(z)
return x},
gR:function(){var z=H.j([],[P.u])
this.a.X(0,new W.hj(this,z))
return z},
gj:function(a){return this.gR().length},
dD:function(a,b){var z,y,x,w,v
z=a.split("-")
for(y=1;y<z.length;++y){x=z[y]
w=J.z(x)
v=w.gj(x)
if(typeof v!=="number")return v.ad()
if(v>0){w=J.el(w.h(x,0))+w.U(x,1)
if(y>=z.length)return H.a(z,y)
z[y]=w}}return C.b.ab(z,"")},
dC:function(a){return this.dD(a,!1)},
a8:function(a){var z,y,x,w,v
z=J.z(a)
y=0
x=""
while(!0){w=z.gj(a)
if(typeof w!=="number")return H.w(w)
if(!(y<w))break
v=J.cp(z.h(a,y))
x=(!J.x(z.h(a,y),v)&&y>0?x+"-":x)+v;++y}return x.charCodeAt(0)==0?x:x}},
hj:{"^":"e:18;a,b",
$2:function(a,b){if(J.aP(a).by(a,"data-"))this.b.push(this.a.dC(C.e.U(a,5)))}},
hW:{"^":"ah;a,b",
N:function(){var z=P.M(null,null,null,P.u)
C.b.X(this.b,new W.hZ(z))
return z},
aM:function(a){var z,y
z=a.ab(0," ")
for(y=this.a,y=new H.a2(y,y.gj(y),0,null);y.k();)J.ei(y.d,z)},
aJ:function(a){C.b.X(this.b,new W.hY(a))},
u:function(a,b){return C.b.e7(this.b,!1,new W.i_(b))},
p:{
hX:function(a){return new W.hW(a,new H.b0(a,new W.iI(),[H.a4(a,0),null]).aL(0))}}},
iI:{"^":"e:19;",
$1:function(a){return J.cn(a)}},
hZ:{"^":"e:7;a",
$1:function(a){return this.a.P(0,a.N())}},
hY:{"^":"e:7;a",
$1:function(a){return a.aJ(this.a)}},
i_:{"^":"e:20;a",
$2:function(a,b){return J.eg(b,this.a)===!0||a===!0}},
hn:{"^":"ah;bO:a<",
N:function(){var z,y,x,w,v
z=P.M(null,null,null,P.u)
for(y=this.a.className.split(" "),x=y.length,w=0;w<y.length;y.length===x||(0,H.a5)(y),++w){v=J.cq(y[w])
if(v.length!==0)z.A(0,v)}return z},
aM:function(a){this.a.className=a.ab(0," ")},
gj:function(a){return this.a.classList.length},
K:function(a){this.a.className=""},
q:function(a,b){return typeof b==="string"&&this.a.classList.contains(b)},
A:function(a,b){var z,y
z=this.a.classList
y=z.contains(b)
z.add(b)
return!y},
u:function(a,b){var z,y,x
z=this.a.classList
y=z.contains(b)
z.remove(b)
x=y
return x}},
kD:{"^":"aH;a,b,c,$ti",
aq:function(a,b,c,d){return W.c5(this.a,this.b,a,!1,H.a4(this,0))},
cn:function(a,b,c){return this.aq(a,null,b,c)}},
hq:{"^":"fy;a,b,c,d,e,$ti",
cc:function(){if(this.b==null)return
this.c6()
this.b=null
this.d=null
return},
bk:function(a,b){if(this.b==null)return;++this.a
this.c6()},
cp:function(a){return this.bk(a,null)},
cr:function(){if(this.b==null||this.a<=0)return;--this.a
this.c4()},
c4:function(){var z=this.d
if(z!=null&&this.a<=0)J.e1(this.b,this.c,z,!1)},
c6:function(){var z=this.d
if(z!=null)J.eh(this.b,this.c,z,!1)},
d2:function(a,b,c,d,e){this.c4()},
p:{
c5:function(a,b,c,d,e){var z=W.iC(new W.hr(c))
z=new W.hq(0,a,b,z,!1,[e])
z.d2(a,b,c,!1,e)
return z}}},
hr:{"^":"e:1;a",
$1:function(a){return this.a.$1(a)}},
c7:{"^":"b;cA:a<",
a9:function(a){return $.$get$dx().q(0,W.aA(a))},
a0:function(a,b,c){var z,y,x
z=W.aA(a)
y=$.$get$c8()
x=y.h(0,H.d(z)+"::"+b)
if(x==null)x=y.h(0,"*::"+b)
if(x==null)return!1
return x.$4(a,b,c,this)},
d4:function(a){var z,y
z=$.$get$c8()
if(z.gG(z)){for(y=0;y<262;++y)z.n(0,C.Y[y],W.iO())
for(y=0;y<12;++y)z.n(0,C.o[y],W.iP())}},
$isbV:1,
p:{
dw:function(a){var z,y
z=document.createElement("a")
y=new W.i7(z,window.location)
y=new W.c7(y)
y.d4(a)
return y},
kG:[function(a,b,c,d){return!0},"$4","iO",8,0,8],
kH:[function(a,b,c,d){var z,y,x,w,v
z=d.gcA()
y=z.a
y.href=c
x=y.hostname
z=z.b
w=z.hostname
if(x==null?w==null:x===w){w=y.port
v=z.port
if(w==null?v==null:w===v){w=y.protocol
z=z.protocol
z=w==null?z==null:w===z}else z=!1}else z=!1
if(!z)if(x==="")if(y.port===""){z=y.protocol
z=z===":"||z===""}else z=!1
else z=!1
else z=!0
return z},"$4","iP",8,0,8]}},
cD:{"^":"b;$ti",
gv:function(a){return new W.cC(a,this.gj(a),-1,null)},
ac:function(a,b){throw H.c(new P.t("Cannot remove from immutable List."))},
u:function(a,b){throw H.c(new P.t("Cannot remove from immutable List."))},
T:function(a,b,c,d,e){throw H.c(new P.t("Cannot setRange on immutable List."))},
$ish:1,
$ash:null,
$isi:1,
$asi:null},
cR:{"^":"b;a",
a9:function(a){return C.b.ca(this.a,new W.fl(a))},
a0:function(a,b,c){return C.b.ca(this.a,new W.fk(a,b,c))}},
fl:{"^":"e:1;a",
$1:function(a){return a.a9(this.a)}},
fk:{"^":"e:1;a,b,c",
$1:function(a){return a.a0(this.a,this.b,this.c)}},
i8:{"^":"b;cA:d<",
a9:function(a){return this.a.q(0,W.aA(a))},
a0:["cX",function(a,b,c){var z,y
z=W.aA(a)
y=this.c
if(y.q(0,H.d(z)+"::"+b))return this.d.dK(c)
else if(y.q(0,"*::"+b))return this.d.dK(c)
else{y=this.b
if(y.q(0,H.d(z)+"::"+b))return!0
else if(y.q(0,"*::"+b))return!0
else if(y.q(0,H.d(z)+"::*"))return!0
else if(y.q(0,"*::*"))return!0}return!1}],
d6:function(a,b,c,d){var z,y,x
this.a.P(0,c)
z=b.bs(0,new W.i9())
y=b.bs(0,new W.ia())
this.b.P(0,z)
x=this.c
x.P(0,C.a_)
x.P(0,y)}},
i9:{"^":"e:1;",
$1:function(a){return!C.b.q(C.o,a)}},
ia:{"^":"e:1;",
$1:function(a){return C.b.q(C.o,a)}},
ii:{"^":"i8;e,a,b,c,d",
a0:function(a,b,c){if(this.cX(a,b,c))return!0
if(b==="template"&&c==="")return!0
if(J.cm(a).a.getAttribute("template")==="")return this.e.q(0,b)
return!1},
p:{
dD:function(){var z=P.u
z=new W.ii(P.cL(C.E,z),P.M(null,null,null,z),P.M(null,null,null,z),P.M(null,null,null,z),null)
z.d6(null,new H.b0(C.E,new W.ij(),[null,null]),["TEMPLATE"],null)
return z}}},
ij:{"^":"e:1;",
$1:function(a){return"TEMPLATE::"+H.d(a)}},
ig:{"^":"b;",
a9:function(a){var z=J.n(a)
if(!!z.$isd_)return!1
z=!!z.$iso
if(z&&W.aA(a)==="foreignObject")return!1
if(z)return!0
return!1},
a0:function(a,b,c){if(b==="is"||C.e.by(b,"on"))return!1
return this.a9(a)}},
cC:{"^":"b;a,b,c,d",
k:function(){var z,y
z=this.c+1
y=this.b
if(z<y){this.d=J.C(this.a,z)
this.c=z
return!0}this.d=null
this.c=y
return!1},
gt:function(){return this.d}},
bV:{"^":"b;"},
i7:{"^":"b;a,b"},
dE:{"^":"b;a",
bu:function(a){new W.ik(this).$2(a,null)},
aj:function(a,b){var z
if(b==null){z=a.parentNode
if(z!=null)z.removeChild(a)}else b.removeChild(a)},
dA:function(a,b){var z,y,x,w,v,u,t,s
z=!0
y=null
x=null
try{y=J.cm(a)
x=y.gbO().getAttribute("is")
w=function(c){if(!(c.attributes instanceof NamedNodeMap))return true
var r=c.childNodes
if(c.lastChild&&c.lastChild!==r[r.length-1])return true
if(c.children)if(!(c.children instanceof HTMLCollection||c.children instanceof NodeList))return true
var q=0
if(c.children)q=c.children.length
for(var p=0;p<q;p++){var o=c.children[p]
if(o.id=='attributes'||o.name=='attributes'||o.id=='lastChild'||o.name=='lastChild'||o.id=='children'||o.name=='children')return true}return false}(a)
z=w===!0?!0:!(a.attributes instanceof NamedNodeMap)}catch(t){H.B(t)}v="element unprintable"
try{v=J.E(a)}catch(t){H.B(t)}try{u=W.aA(a)
this.dz(a,b,z,v,u,y,x)}catch(t){if(H.B(t) instanceof P.a6)throw t
else{this.aj(a,b)
window
s="Removing corrupted element "+H.d(v)
if(typeof console!="undefined")console.warn(s)}}},
dz:function(a,b,c,d,e,f,g){var z,y,x,w,v
if(c){this.aj(a,b)
window
z="Removing element due to corrupted attributes on <"+d+">"
if(typeof console!="undefined")console.warn(z)
return}if(!this.a.a9(a)){this.aj(a,b)
window
z="Removing disallowed element <"+H.d(e)+"> from "+J.E(b)
if(typeof console!="undefined")console.warn(z)
return}if(g!=null)if(!this.a.a0(a,"is",g)){this.aj(a,b)
window
z="Removing disallowed type extension <"+H.d(e)+' is="'+g+'">'
if(typeof console!="undefined")console.warn(z)
return}z=f.gR()
y=H.j(z.slice(),[H.a4(z,0)])
for(x=f.gR().length-1,z=f.a;x>=0;--x){if(x>=y.length)return H.a(y,x)
w=y[x]
if(!this.a.a0(a,J.cp(w),z.getAttribute(w))){window
v="Removing disallowed attribute <"+H.d(e)+" "+w+'="'+H.d(z.getAttribute(w))+'">'
if(typeof console!="undefined")console.warn(v)
z.getAttribute(w)
z.removeAttribute(w)}}if(!!J.n(a).$isd7)this.bu(a.content)}},
ik:{"^":"e:21;a",
$2:function(a,b){var z,y,x,w,v
x=this.a
switch(a.nodeType){case 1:x.dA(a,b)
break
case 8:case 11:case 3:case 4:break
default:x.aj(a,b)}z=a.lastChild
for(x=a==null;null!=z;){y=null
try{y=J.ea(z)}catch(w){H.B(w)
v=z
if(x){if(J.e9(v)!=null)v.parentNode.removeChild(v)}else a.removeChild(v)
z=null
y=a.lastChild}if(z!=null)this.$2(z,a)
z=y}}}}],["","",,P,{"^":"",ah:{"^":"b;",
ba:function(a){if($.$get$cv().b.test(a))return a
throw H.c(P.bz(a,"value","Not a valid class token"))},
i:function(a){return this.N().ab(0," ")},
gv:function(a){var z,y
z=this.N()
y=new P.bo(z,z.r,null,null)
y.c=z.e
return y},
Y:function(a,b){var z=this.N()
return new H.bE(z,b,[H.a4(z,0),null])},
gj:function(a){return this.N().a},
q:function(a,b){if(typeof b!=="string")return!1
this.ba(b)
return this.N().q(0,b)},
bj:function(a){return this.q(0,a)?a:null},
A:function(a,b){this.ba(b)
return this.aJ(new P.ev(b))},
u:function(a,b){var z,y
this.ba(b)
z=this.N()
y=z.u(0,b)
this.aM(z)
return y},
K:function(a){this.aJ(new P.ew())},
aJ:function(a){var z,y
z=this.N()
y=a.$1(z)
this.aM(z)
return y},
$isi:1,
$asi:function(){return[P.u]}},ev:{"^":"e:1;a",
$1:function(a){return a.A(0,this.a)}},ew:{"^":"e:1;",
$1:function(a){return a.K(0)}}}],["","",,P,{"^":""}],["","",,P,{"^":"",
dy:function(a,b){a=536870911&a+b
a=536870911&a+((524287&a)<<10)
return a^a>>>6},
hM:function(a){a=536870911&a+((67108863&a)<<3)
a^=a>>>11
return 536870911&a+((16383&a)<<15)},
hJ:{"^":"b;",
ar:function(a){if(a<=0||a>4294967296)throw H.c(P.cZ("max must be in range 0 < max \u2264 2^32, was "+a))
return Math.random()*a>>>0}},
hK:{"^":"b;a",
ar:function(a){var z,y,x,w,v,u,t,s,r
if(a<=0||a>4294967296)throw H.c(P.cZ("max must be in range 0 < max \u2264 2^32, was "+a))
if(a>255)if(a>65535)z=a>16777215?4:3
else z=2
else z=1
y=this.a
y.setUint32(0,0,!1)
x=4-z
w=Math.pow(256,z)
for(v=a-1,u=(a&v)===0;!0;){t=y.buffer
t.toString
if(!J.n(t).$isbS)H.v(P.b8("Invalid view buffer"))
t=new Uint8Array(t,x,z)
crypto.getRandomValues(t)
s=y.getUint32(0,!1)
if(u)return(s&v)>>>0
r=s%a
if(s-r+a<w)return r}},
d5:function(){var z=self.crypto
if(z!=null)if(z.getRandomValues!=null)return
throw H.c(new P.t("No source of cryptographically secure random numbers available."))},
p:{
hL:function(){var z=new P.hK(new DataView(new ArrayBuffer(H.ir(8))))
z.d5()
return z}}},
r:{"^":"b;l:a>,m:b>,$ti",
i:function(a){return"Point("+H.d(this.a)+", "+H.d(this.b)+")"},
w:function(a,b){var z,y
if(b==null)return!1
if(!(b instanceof P.r))return!1
z=this.a
y=b.a
if(z==null?y==null:z===y){z=this.b
y=b.b
y=z==null?y==null:z===y
z=y}else z=!1
return z},
gC:function(a){var z,y
z=J.W(this.a)
y=J.W(this.b)
return P.hM(P.dy(P.dy(0,z),y))},
S:function(a,b){var z,y,x,w
z=this.a
y=J.ed(b)
if(typeof z!=="number")return z.S()
if(typeof y!=="number")return H.w(y)
x=this.b
w=b.b
if(typeof x!=="number")return x.S()
if(typeof w!=="number")return H.w(w)
return new P.r(z+y,x+w,this.$ti)},
ag:function(a,b){var z,y,x,w
z=this.a
y=J.m(b)
x=y.gl(b)
if(typeof z!=="number")return z.ag()
if(typeof x!=="number")return H.w(x)
w=this.b
y=y.gm(b)
if(typeof w!=="number")return w.ag()
if(typeof y!=="number")return H.w(y)
return new P.r(z-x,w-y,this.$ti)},
O:function(a,b){var z,y
z=this.a
if(typeof z!=="number")return z.O()
y=this.b
if(typeof y!=="number")return y.O()
return new P.r(z*b,y*b,this.$ti)}}}],["","",,P,{"^":"",ja:{"^":"ai;",$isf:1,"%":"SVGAElement"},jc:{"^":"o;",$isf:1,"%":"SVGAnimateElement|SVGAnimateMotionElement|SVGAnimateTransformElement|SVGAnimationElement|SVGSetElement"},jo:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEBlendElement"},jp:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEColorMatrixElement"},jq:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEComponentTransferElement"},jr:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFECompositeElement"},js:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEConvolveMatrixElement"},jt:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEDiffuseLightingElement"},ju:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEDisplacementMapElement"},jv:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEFloodElement"},jw:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEGaussianBlurElement"},jx:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEImageElement"},jy:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEMergeElement"},jz:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEMorphologyElement"},jA:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFEOffsetElement"},jB:{"^":"o;l:x=,m:y=","%":"SVGFEPointLightElement"},jC:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFESpecularLightingElement"},jD:{"^":"o;l:x=,m:y=","%":"SVGFESpotLightElement"},jE:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFETileElement"},jF:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFETurbulenceElement"},jH:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGFilterElement"},jI:{"^":"ai;l:x=,m:y=","%":"SVGForeignObjectElement"},eG:{"^":"ai;","%":"SVGCircleElement|SVGEllipseElement|SVGLineElement|SVGPathElement|SVGPolygonElement|SVGPolylineElement;SVGGeometryElement"},ai:{"^":"o;",$isf:1,"%":"SVGClipPathElement|SVGDefsElement|SVGGElement|SVGSwitchElement;SVGGraphicsElement"},jN:{"^":"ai;l:x=,m:y=",$isf:1,"%":"SVGImageElement"},jV:{"^":"o;",$isf:1,"%":"SVGMarkerElement"},jW:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGMaskElement"},ke:{"^":"o;l:x=,m:y=",$isf:1,"%":"SVGPatternElement"},kh:{"^":"eG;l:x=,m:y=","%":"SVGRectElement"},d_:{"^":"o;",$isd_:1,$isf:1,"%":"SVGScriptElement"},hf:{"^":"ah;a",
N:function(){var z,y,x,w,v,u
z=this.a.getAttribute("class")
y=P.M(null,null,null,P.u)
if(z==null)return y
for(x=z.split(" "),w=x.length,v=0;v<x.length;x.length===w||(0,H.a5)(x),++v){u=J.cq(x[v])
if(u.length!==0)y.A(0,u)}return y},
aM:function(a){this.a.setAttribute("class",a.ab(0," "))}},o:{"^":"a1;",
gF:function(a){return new P.hf(a)},
scm:function(a,b){this.aO(a,b)},
L:function(a,b,c,d){var z,y,x,w,v,u
z=H.j([],[W.bV])
d=new W.cR(z)
z.push(W.dw(null))
z.push(W.dD())
z.push(new W.ig())
c=new W.dE(d)
y='<svg version="1.1">'+b+"</svg>"
z=document
x=z.body
w=(x&&C.q).dT(x,y,c)
v=z.createDocumentFragment()
w.toString
z=new W.V(w)
u=z.ga7(z)
for(;z=u.firstChild,z!=null;)v.appendChild(z)
return v},
$iso:1,
$isf:1,
"%":"SVGComponentTransferFunctionElement|SVGDescElement|SVGDiscardElement|SVGFEDistantLightElement|SVGFEFuncAElement|SVGFEFuncBElement|SVGFEFuncGElement|SVGFEFuncRElement|SVGFEMergeNodeElement|SVGMetadataElement|SVGStopElement|SVGStyleElement|SVGTitleElement;SVGElement"},kl:{"^":"ai;l:x=,m:y=",$isf:1,"%":"SVGSVGElement"},km:{"^":"o;",$isf:1,"%":"SVGSymbolElement"},d8:{"^":"ai;","%":";SVGTextContentElement"},kr:{"^":"d8;",$isf:1,"%":"SVGTextPathElement"},ks:{"^":"d8;l:x=,m:y=","%":"SVGTSpanElement|SVGTextElement|SVGTextPositioningElement"},kt:{"^":"ai;l:x=,m:y=",$isf:1,"%":"SVGUseElement"},ku:{"^":"o;",$isf:1,"%":"SVGViewElement"},kE:{"^":"o;",$isf:1,"%":"SVGGradientElement|SVGLinearGradientElement|SVGRadialGradientElement"},kJ:{"^":"o;",$isf:1,"%":"SVGCursorElement"},kK:{"^":"o;",$isf:1,"%":"SVGFEDropShadowElement"},kL:{"^":"o;",$isf:1,"%":"SVGMPathElement"}}],["","",,P,{"^":""}],["","",,P,{"^":""}],["","",,P,{"^":""}],["","",,L,{"^":"",fE:{"^":"b;a,b,c,d,e,f,r,x,y",
dF:function(){var z,y,x,w,v,u
this.e=P.h4(C.L,new L.fF(this))
if($.U==null){H.bY()
$.U=$.aF}this.f=new P.c0(0,0)
J.R(this.b,"click",this.geq(),null)
J.R(this.c,"click",this.geg(),null)
z=window
C.a0.aT(z,"resize",this.geZ(),null)
z=document
y=[null]
x=new W.aI(z.querySelectorAll(".GameCell"),y)
for(w=new H.a2(x,x.gj(x),0,null);w.k();){v=w.d
J.ck(v,"click",new L.fG(this,v))}u=new W.aI(z.querySelectorAll(".ControlCell"),y)
for(y=new H.a2(u,u.gj(u),0,null);y.k();){v=y.d
J.ck(v,"click",new L.fH(this,v))}v=z.querySelector("#Control_Hint")
J.R(v,"click",new L.fI(this,v),null)},
fh:[function(a){var z,y,x,w,v,u,t
z=this.y
y=z.d
x=y.style
x.height="100%"
x=y.style
x.width="100%"
w=window.matchMedia("only screen and (max-width: 760px)")
v=window.matchMedia("(orientation: landscape)")
if(w.matches===!0){x=z.b
if(v.matches===!0){J.af(x,"<h1>Please rotate device!</h1><img src='img/Logo_Hell.png' id='logo' class='logo' alt='Sudoku'>")
y=y.style
y.display="none"}else{J.af(x,"")
y=y.style
y.display="initial"}}else{J.af(z.b,"")
y=y.style
y.display="initial"}u=z.bt()
y=z.f.style
x=C.c.i(u)+"px"
y.width=x
y=z.f.style
x=C.c.i(u)+"px"
y.height=x
y=window.innerHeight
x=$.d5
if(typeof y!=="number")return y.O()
t=C.c.D(y*x,100)
z=z.r
x=z.style
y=C.c.i(t)+"px"
x.width=y
z=z.style
y=C.c.i(t)+"px"
z.height=y},"$1","geZ",2,0,3],
fe:[function(a){this.Z(C.M)},"$1","gew",2,0,3],
ff:[function(a){this.Z(C.j)},"$1","gey",2,0,3],
fb:[function(a){this.Z(C.k)},"$1","ger",2,0,3],
fc:[function(a){this.Z(C.l)},"$1","ges",2,0,3],
f9:[function(a){this.Z(C.m)},"$1","gep",2,0,3],
fd:[function(a){this.Z(C.n)},"$1","geu",2,0,3],
fa:[function(a){var z,y,x,w,v,u,t
J.af(this.y.c,"<div id='newGame'><table id='newGameTable'><tr><td><img src='img/Standard-Sudoku.png' id ='newStandardSudoku' class='newGame' alt='Standard-Sudoku'></td><td><img src='img/X-Sudoku.png' id ='newXSudoku' class='newGame' alt='X-Sudoku'></td></tr><tr><td><img src='img/Hyper-Sudoku.png' id ='newHyperSudoku' class='newGame' alt='Hyper-Sudoku'></td><td><img src='img/Middlepoint-Sudoku.png' id ='newMiddlepointSudoku' class='newGame' alt='Middlepoint-Sudoku'></td></tr><tr><td><img src='img/Color-Sudoku.png' id ='newColorSudoku' class='newGame' alt='Color-Sudoku'></td><td><img src='img/Nonomino-Sudoku.png' id ='newNonominoSudoku' class='newGame' alt='Nonomino-Sudoku'></td></tr></table></div>")
z=document
y=z.getElementById("newStandardSudoku")
x=z.getElementById("newXSudoku")
w=z.getElementById("newHyperSudoku")
v=z.getElementById("newMiddlepointSudoku")
u=z.getElementById("newColorSudoku")
t=z.getElementById("newNonominoSudoku")
J.R(y,"click",this.gew(),null)
J.R(x,"click",this.gey(),null)
J.R(w,"click",this.ger(),null)
J.R(v,"click",this.ges(),null)
J.R(u,"click",this.gep(),null)
J.R(t,"click",this.geu(),null)
J.R(this.a,"click",new L.fJ(this),null)},"$1","geq",2,0,3],
Z:function(a){var z,y,x
z=this.r.Z(a)
this.x=z
y=this.y
y.a=z
y.eh()
this.y.cw()
this.y.af(this.d)
this.y.cN()
y=this.f
z=y.b
y.a=z==null?$.T.$0():z
this.f.bx(0)
z=this.y
y=this.f
x=y.b
if(x==null)x=$.T.$0()
z.cz(P.bD(0,0,J.aR(J.aQ(J.ac(x,y.a),1e6),$.U),0,0,0))},
f8:[function(a){var z
if(this.x!=null){z=!this.d
this.d=z
this.y.af(z)}},"$1","geg",2,0,3],
eY:function(){var z,y,x,w,v,u
if(this.x.el()){z=this.f
if(z.b==null)z.b=$.T.$0()
z=this.y
y=this.f
x=y.b
if(x==null)x=$.T.$0()
y=P.bD(0,0,J.aR(J.aQ(J.ac(x,y.a),1e6),$.U),0,0,0).a
w=C.a.I(C.a.D(y,36e8),24)
v=C.a.I(C.a.D(y,6e7),60)
u=C.a.I(C.a.D(y,1e6),60)
J.af(z.c,"<div id='win'><p>You have solved the sudoku in<p><p>Hours: "+C.a.i(w)+" Minutes: "+C.a.i(v)+" Seconds: "+C.a.i(u))
J.R(this.a,"click",new L.fK(this),null)}}},fF:{"^":"e:1;a",
$1:function(a){var z,y,x
z=this.a
y=z.y
z=z.f
x=z.b
if(x==null)x=$.T.$0()
y.cz(P.bD(0,0,J.aR(J.aQ(J.ac(x,z.a),1e6),$.U),0,0,0))
return}},fG:{"^":"e:1;a,b",
$1:function(a){var z,y,x,w,v,u
z=this.a
if(z.x!=null){y=J.b7(J.e6(this.b),5)
x=H.ak(C.e.ah(y,0,1),null,null)
w=H.ak(C.e.U(y,2),null,null)
v=z.x
u=v.c
if(x>>>0!==x||x>=u.length)return H.a(u,x)
u=u[x]
if(w>>>0!==w||w>=u.length)return H.a(u,w)
if(u[w]===!0)if(J.x(v.f,-2)){if(v.r>0){u=v.b
if(x>=u.length)return H.a(u,x)
J.aS(u[x],w,J.C(J.C(v.a,x),w));--v.r}}else{u=v.b
if(x>=u.length)return H.a(u,x)
if(J.x(J.C(u[x],w),v.f)){v=v.b
if(x>=v.length)return H.a(v,x)
J.aS(v[x],w,-1)}else{u=v.b
if(x>=u.length)return H.a(u,x)
J.aS(u[x],w,v.f)}}z.y.cw()
z.y.af(z.d)
z.eY()}return}},fH:{"^":"e:1;a,b",
$1:function(a){var z,y
z=this.a
y=this.b
if(z.x!=null)if(!J.e5(J.co(y),"hint")){z.x.bv(y.textContent)
z.y.br(y)
z.y.af(z.d)}return}},fI:{"^":"e:1;a,b",
$1:function(a){var z,y
z=this.a
y=z.x
if(y!=null){y.bv("hint")
z.y.br(this.b)
z.y.af(z.d)}return}},fJ:{"^":"e:1;a",
$1:function(a){J.af(this.a.a,"")
return""}},fK:{"^":"e:1;a",
$1:function(a){J.af(this.a.a,"")
return""}},cr:{"^":"b;a,b",
i:function(a){return this.b}},F:{"^":"b;a,b",
i:function(a){return this.b}},aB:{"^":"b;a,b",
i:function(a){return this.b}},d4:{"^":"b;a,b,c,d,e,f,r",
el:function(){var z,y,x,w
z=0
while(!0){y=J.D(this.a)
if(typeof y!=="number")return H.w(y)
if(!(z<y))break
x=0
while(!0){y=J.D(J.C(this.a,0))
if(typeof y!=="number")return H.w(y)
if(!(x<y))break
y=J.C(J.C(this.a,z),x)
w=this.b
if(z>=w.length)return H.a(w,z)
if(!J.x(y,J.C(w[z],x)))return!1;++x}++z}return!0},
bv:function(a){if(a==="hint"){this.f=-2
return}this.f=H.ak(a,null,null)}},d0:{"^":"b;a,b,c,d,e,f",
i:function(a){return"left: "+J.E(this.a)+", bottom:"+J.E(this.b)+", right:"+J.E(this.c)+", top:"+J.E(this.d)+" ("+H.d(this.e)+","+H.d(this.f)+")"}},fL:{"^":"b;a,b,c,d,e,f",
aI:function(a){var z=0,y=new P.et(),x=1,w,v=this
var $async$aI=P.iA(function(b,c){if(b===1){w=c
z=x}while(true)switch(z){case 0:z=2
return P.bq(W.eI(a,null,null).bo(new L.fN(v)),$async$aI,y)
case 2:return P.bq(null,0,y)
case 1:return P.bq(w,1,y)}})
return P.bq(null,$async$aI,y)},
bf:function(a){var z,y,x,w,v,u,t
z=H.j([],[[P.h,P.k]])
y=J.z(a)
x=[P.k]
w=0
while(!0){v=y.gj(a)
if(typeof v!=="number")return H.w(v)
if(!(w<v))break
u=H.j([],x)
t=0
while(!0){v=J.D(y.h(a,w))
if(typeof v!=="number")return H.w(v)
if(!(t<v))break
u.push(J.C(y.h(a,w),t));++t}z.push(u);++w}return z},
ex:function(a){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c
z=new L.d4(null,null,null,null,null,null,null)
z.f=1
z.r=5
y=this.cE(a)
x=this.dV(y)
w=this.ci(x,-1)
z.a=y
z.b=x
z.c=w
v=H.j(new Array(y.length),[[P.h,L.F]])
for(u=v.length,t=[L.F],s=0;s<y.length;++s){r=H.j(new Array(y[0].length),t)
if(0>=y.length)return H.a(y,0)
q=r.length
p=s>=3
o=s<=5
n=s>=3
m=s>5
l=0
for(;l<y[0].length;++l){if(p)if(o)k=l<3||l>5
else k=!1
else k=!1
if(!k)if(l>=3)if(l<=5)k=!n||m
else k=!1
else k=!1
else k=!0
if(k){if(l>=q)return H.a(r,l)
r[l]=C.K}else{if(l>=q)return H.a(r,l)
r[l]=C.J}}if(s>=u)return H.a(v,s)
v[s]=r}if(a===C.j)for(s=0;s<9;++s){t=8-s
if(t>=u)return H.a(v,t)
t=v[t]
if(s>=u)return H.a(v,s)
q=v[s]
if(s>=q.length)return H.a(q,s)
q[s]=C.i
if(s>=t.length)return H.a(t,s)
t[s]=C.i}if(a===C.l)for(s=0;s<3;++s)for(t=s*3+1,j=0;j<3;++j){if(t>=u)return H.a(v,t)
q=v[t]
p=j*3+1
if(p>=q.length)return H.a(q,p)
q[p]=C.i}if(a===C.k)for(s=0;s<2;++s)for(t=s*4+1,j=0;j<2;++j)for(q=j*4+1,i=0;i<3;++i)for(p=t+i,h=0;h<3;++h){if(p>=u)return H.a(v,p)
o=v[p]
n=q+h
if(n>=o.length)return H.a(o,n)
o[n]=C.i}if(a===C.m){g=[C.u,C.v,C.w,C.x,C.y,C.z,C.A,C.r,C.t]
C.b.bw(g)
for(t=g.length,s=0;s<3;++s)for(q=s*3,j=0;j<3;++j)for(p=j*3,i=0;i<3;++i)for(o=q+i,n=i*3,h=0;h<3;++h){if(o>=u)return H.a(v,o)
m=v[o]
k=p+h
f=n+h
if(f>=t)return H.a(g,f)
f=g[f]
if(k>=m.length)return H.a(m,k)
m[k]=f}}e=[]
for(s=0;s<9;++s){d=[]
for(u=s%3,t=u===2,u=u===0,j=0;j<9;++j){c=new L.d0(null,null,null,null,null,null)
q=j%3
c.a=q===0?C.h:C.f
c.c=q===2?C.h:C.f
c.d=u?C.h:C.f
c.b=t?C.h:C.f
c.e=s
c.f=j
d.push(c)}e.push(d)}z.e=e
z.d=v
return z},
dV:function(a){var z,y,x,w,v
z=this.bf(a)
for(y=this.b,x=0;x<20;++x){w=y.ar(9)
v=y.ar(9)
if(w>>>0!==w||w>=z.length)return H.a(z,w)
J.aS(z[w],v,-1)}return z},
ci:function(a,b){var z,y,x,w,v,u,t,s
z=J.z(a)
y=z.gj(a)
if(typeof y!=="number")return H.w(y)
x=H.j(new Array(y),[[P.h,P.aN]])
y=x.length
w=0
while(!0){v=z.gj(a)
if(typeof v!=="number")return H.w(v)
if(!(w<v))break
v=J.D(z.h(a,0))
if(typeof v!=="number")return H.w(v)
u=new Array(v)
t=0
while(!0){s=J.D(z.h(a,0))
if(typeof s!=="number")return H.w(s)
if(!(t<s))break
if(J.x(J.C(z.h(a,w),t),b)){if(t>=v)return H.a(u,t)
u[t]=!0}else{if(t>=v)return H.a(u,t)
u[t]=!1}++t}if(w>=y)return H.a(x,w)
x[w]=u;++w}return x},
Z:function(a){if(a===C.n)return this.ev()
else return this.ex(a)},
ev:function(){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a
z=this.b.ar(3)
y=this.a
if(z>>>0!==z||z>=y.length)return H.a(y,z)
x=C.W.dX(y[z])
w=new L.d4(null,null,null,null,null,null,null)
w.f=1
w.r=5
y=J.z(x)
v=y.h(x,"fields")
u=this.ci(y.h(x,"empty"),1)
t=this.cF(v,u)
s=y.h(x,"colors")
y=J.D(v)
if(typeof y!=="number")return H.w(y)
r=H.j(new Array(y),[[P.h,L.F]])
y=J.z(s)
q=r.length
p=[L.F]
o=0
while(!0){n=y.gj(s)
if(typeof n!=="number")return H.w(n)
if(!(o<n))break
n=J.D(y.h(s,0))
if(typeof n!=="number")return H.w(n)
m=H.j(new Array(n),p)
n=m.length
l=0
while(!0){k=J.D(y.h(s,0))
if(typeof k!=="number")return H.w(k)
if(!(l<k))break
switch(J.C(y.h(s,o),l)){case 0:if(l>=n)return H.a(m,l)
m[l]=C.u
break
case 1:if(l>=n)return H.a(m,l)
m[l]=C.v
break
case 2:if(l>=n)return H.a(m,l)
m[l]=C.w
break
case 3:if(l>=n)return H.a(m,l)
m[l]=C.x
break
case 4:if(l>=n)return H.a(m,l)
m[l]=C.y
break
case 5:if(l>=n)return H.a(m,l)
m[l]=C.z
break
case 6:if(l>=n)return H.a(m,l)
m[l]=C.A
break
case 7:if(l>=n)return H.a(m,l)
m[l]=C.r
break
case 8:if(l>=n)return H.a(m,l)
m[l]=C.t
break}++l}if(o>=q)return H.a(r,o)
r[o]=m;++o}j=[]
for(o=0;o<9;o=h){i=[]
for(y=o!==8,p=o!==0,n=o-1,k=n>=0,h=o+1,g=h<=8,f=0;f<9;++f){e=new L.d0(null,null,null,null,null,null)
e.b=C.f
e.d=C.f
e.c=C.f
e.a=C.f
if(f!==0){d=f-1
if(d>=0){if(o>=q)return H.a(r,o)
c=r[o]
b=c.length
if(f>=b)return H.a(c,f)
a=c[f]
if(d>=b)return H.a(c,d)
d=c[d]
d=a==null?d!=null:a!==d}else d=!1}else d=!0
if(d)e.a=C.h
if(f!==8){d=f+1
if(d<=8){if(o>=q)return H.a(r,o)
c=r[o]
b=c.length
if(f>=b)return H.a(c,f)
a=c[f]
if(d>=b)return H.a(c,d)
d=c[d]
d=a==null?d!=null:a!==d}else d=!1}else d=!0
if(d)e.c=C.h
if(p)if(k){if(o>=q)return H.a(r,o)
d=r[o]
if(f>=d.length)return H.a(d,f)
d=d[f]
if(n>=q)return H.a(r,n)
c=r[n]
if(f>=c.length)return H.a(c,f)
c=c[f]
c=d==null?c!=null:d!==c
d=c}else d=!1
else d=!0
if(d)e.d=C.h
if(y)if(g){if(o>=q)return H.a(r,o)
d=r[o]
if(f>=d.length)return H.a(d,f)
d=d[f]
if(h>=q)return H.a(r,h)
c=r[h]
if(f>=c.length)return H.a(c,f)
c=c[f]
c=d==null?c!=null:d!==c
d=c}else d=!1
else d=!0
if(d)e.b=C.h
e.e=o
e.f=f
i.push(e)}j.push(i)}w.e=j
w.a=v
w.b=t
w.c=u
w.d=r
return w},
cE:function(a){var z,y,x,w,v,u,t,s,r,q,p,o
z=[[P.h,P.k]]
y=H.j([],z)
for(x=[P.k],w=0;w<9;++w){v=H.j([],x)
for(u=0;u<9;++u)v.push(-1)
y.push(v)}t=H.j([],[[P.h,[P.h,P.k]]])
for(w=0;w<9;++w){v=H.j([],z)
for(u=0;u<9;++u){s=H.j([],x)
for(r=1;r<10;++r)s.push(r)
v.push(s)}t.push(v)}q=new P.c0(0,0)
if($.U==null){H.bY()
$.U=$.aF}q.bx(0)
do{p=new P.c0(0,0)
if($.U==null){H.bY()
$.U=$.aF}z=J.ac($.T.$0(),0)
if(typeof z!=="number")return H.w(z)
p.a=0+z
p.b=null
o=this.cg(y,t,a,p)
if(!o){z=q.b
if(z==null)z=$.T.$0()
z=J.cj(J.aR(J.aQ(J.ac(z,q.a),1000),$.U),1e4)}else z=!1}while(z)
if(o)return y
else return},
cg:function(a,b,c,d){var z,y,x,w,v,u,t,s,r,q,p
z=d.b
if(z==null)z=$.T.$0()
if(J.by(J.aR(J.aQ(J.ac(z,d.a),1000),$.U),1000))return!1
y=this.e4(a)
if(y!=null){x=y.a
w=y.b
if(x>>>0!==x||x>=b.length)return H.a(b,x)
z=b[x]
if(w>>>0!==w||w>=z.length)return H.a(z,w)
v=P.k
u=P.be(z[w],!0,v)
t=u.length
if(t>0){s=H.j([],[v])
for(r=0;r<t;++r)s.push(r)
C.b.bw(s)
for(r=0;r<t;++r){q=C.b.ac(s,0)
if(q>>>0!==q||q>=u.length)return H.a(u,q)
p=u[q]
if(x>=a.length)return H.a(a,x)
z=a[x]
if(w>=z.length)return H.a(z,w)
z[w]=p
if(this.cg(a,this.eN(x,w,p,b,c),c,d))return!0
else{if(x>=a.length)return H.a(a,x)
z=a[x]
if(w>=z.length)return H.a(z,w)
z[w]=-1
continue}}return!1}else return!1}else return!0},
e4:function(a){var z,y,x
for(z=0;z<9;++z)for(y=0;y<9;++y){if(z>=a.length)return H.a(a,z)
x=a[z]
if(y>=x.length)return H.a(x,y)
if(J.x(x[y],-1))return new P.r(z,y,[null])}return},
eN:function(a,b,c,d,e){var z,y
z=H.j([],[[P.h,[P.h,P.k]]])
for(y=0;y<d.length;++y)z.push(this.bf(d[y]))
this.eM(a,b,c,z)
if(e!==C.n)this.eH(a,b,c,z)
if(e===C.j)this.eJ(a,b,c,z)
if(e===C.k)this.eK(a,b,c,z)
if(e===C.l)this.eL(a,b,c,z)
if(e===C.m)this.eI(a,b,c,z)
return z},
eM:function(a,b,c,d){var z,y,x,w
for(z=0;z<9;++z){if(z>=d.length)return H.a(d,z)
y=d[z]
if(b>>>0!==b||b>=y.length)return H.a(y,b)
x=J.ad(y[b],c)
if(x>=0){if(z>=d.length)return H.a(d,z)
y=d[z]
if(b>=y.length)return H.a(y,b)
J.ae(y[b],x)}if(a>>>0!==a||a>=d.length)return H.a(d,a)
y=d[a]
if(z>=y.length)return H.a(y,z)
w=J.ad(y[z],c)
if(w>=0){if(a>=d.length)return H.a(d,a)
y=d[a]
if(z>=y.length)return H.a(y,z)
J.ae(y[z],w)}}},
eH:function(a,b,c,d){var z,y,x,w,v,u,t,s
if(typeof a!=="number")return a.I()
z=a-C.a.I(a,3)
if(typeof b!=="number")return b.I()
y=b-C.a.I(b,3)
for(x=z+3,w=y+3,v=z;v<x;++v)for(u=y;u<w;++u){if(v>>>0!==v||v>=d.length)return H.a(d,v)
t=d[v]
if(u>>>0!==u||u>=t.length)return H.a(t,u)
s=J.ad(t[u],c)
if(s>=0){if(v>=d.length)return H.a(d,v)
t=d[v]
if(u>=t.length)return H.a(t,u)
J.ae(t[u],s)}}},
eJ:function(a,b,c,d){var z,y,x,w,v,u,t,s,r,q,p
z=new P.r(a,b,[null])
for(y=this.d,x=y.length,w=0;w<y.length;y.length===x||(0,H.a5)(y),++w){v=y[w]
if(C.b.q(v,z))for(u=C.b.gv(v);u.k();){t=u.gt()
s=J.m(t)
r=s.gl(t)
if(r>>>0!==r||r>=d.length)return H.a(d,r)
r=d[r]
q=s.gm(t)
if(q>>>0!==q||q>=r.length)return H.a(r,q)
p=J.ad(r[q],c)
if(p>=0){r=s.gl(t)
if(r>>>0!==r||r>=d.length)return H.a(d,r)
r=d[r]
s=s.gm(t)
if(s>>>0!==s||s>=r.length)return H.a(r,s)
J.ae(r[s],p)}}}},
eK:function(a,b,c,d){var z,y,x,w,v,u,t,s,r,q,p
z=new P.r(a,b,[null])
for(y=this.e,x=y.length,w=0;w<y.length;y.length===x||(0,H.a5)(y),++w){v=y[w]
if(C.b.q(v,z))for(u=C.b.gv(v);u.k();){t=u.gt()
s=J.m(t)
r=s.gl(t)
if(r>>>0!==r||r>=d.length)return H.a(d,r)
r=d[r]
q=s.gm(t)
if(q>>>0!==q||q>=r.length)return H.a(r,q)
p=J.ad(r[q],c)
if(p>=0){r=s.gl(t)
if(r>>>0!==r||r>=d.length)return H.a(d,r)
r=d[r]
s=s.gm(t)
if(s>>>0!==s||s>=r.length)return H.a(r,s)
J.ae(r[s],p)}}}},
eL:function(a,b,c,d){var z,y,x,w,v,u,t,s
z=this.c
if((z&&C.b).q(z,new P.r(a,b,[null])))for(z=this.c,y=z.length,x=0;x<z.length;z.length===y||(0,H.a5)(z),++x){w=z[x]
v=w.a
if(v>>>0!==v||v>=d.length)return H.a(d,v)
u=d[v]
t=w.b
if(t>>>0!==t||t>=u.length)return H.a(u,t)
s=J.ad(u[t],c)
if(s>=0){if(v>=d.length)return H.a(d,v)
v=d[v]
if(t>=v.length)return H.a(v,t)
J.ae(v[t],s)}}},
eI:function(a,b,c,d){var z,y,x,w,v,u,t,s,r,q,p
z=new P.r(a,b,[null])
for(y=this.f,x=y.length,w=0;w<y.length;y.length===x||(0,H.a5)(y),++w){v=y[w]
if(C.b.q(v,z))for(u=C.b.gv(v);u.k();){t=u.gt()
s=J.m(t)
r=s.gl(t)
if(r>>>0!==r||r>=d.length)return H.a(d,r)
r=d[r]
q=s.gm(t)
if(q>>>0!==q||q>=r.length)return H.a(r,q)
p=J.ad(r[q],c)
if(p>=0){r=s.gl(t)
if(r>>>0!==r||r>=d.length)return H.a(d,r)
r=d[r]
s=s.gm(t)
if(s>>>0!==s||s>=r.length)return H.a(r,s)
J.ae(r[s],p)}}}},
cF:function(a,b){var z,y,x,w,v
z=this.bf(a)
for(y=b.length,x=0;x<y;++x)for(w=0;w<b[0].length;++w){v=b[x]
if(w>=v.length)return H.a(v,w)
if(v[w]===!0){if(x>=z.length)return H.a(z,x)
J.aS(z[x],w,-1)}}return z},
cZ:function(){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
z=[[P.r,P.k]]
this.c=H.j([],z)
for(y=[null],x=1;x<=7;x+=3)for(w=1;w<=7;w+=3)this.c.push(new P.r(x,w,y))
v=[[P.h,[P.r,P.k]]]
this.d=H.j([],v)
u=H.j([],z)
t=H.j([],z)
for(x=0;x<9;++x){u.push(new P.r(x,x,y))
t.push(new P.r(x,8-x,y))}this.d.push(u)
this.d.push(t)
this.e=H.j([],v)
s=H.j([],z)
r=H.j([],z)
q=H.j([],z)
p=H.j([],z)
for(x=1;x<=3;++x)for(o=x+4,w=1;w<=3;++w){s.push(new P.r(x,w,y))
r.push(new P.r(o,w,y))
n=w+4
q.push(new P.r(x,n,y))
p.push(new P.r(o,n,y))}this.e.push(s)
this.e.push(r)
this.e.push(q)
this.e.push(p)
this.f=H.j([],v)
m=H.j([],z)
l=H.j([],z)
k=H.j([],z)
j=H.j([],z)
i=H.j([],z)
h=H.j([],z)
g=H.j([],z)
f=H.j([],z)
e=H.j([],z)
for(x=0;x<=6;x+=3)for(z=x+1,v=x+2,w=0;w<=6;w+=3){m.push(new P.r(x,w,y))
o=w+1
l.push(new P.r(x,o,y))
n=w+2
k.push(new P.r(x,n,y))
j.push(new P.r(z,w,y))
i.push(new P.r(z,o,y))
h.push(new P.r(z,n,y))
g.push(new P.r(v,w,y))
f.push(new P.r(v,o,y))
e.push(new P.r(v,n,y))}this.f.push(m)
this.f.push(l)
this.f.push(k)
this.f.push(j)
this.f.push(i)
this.f.push(h)
this.f.push(g)
this.f.push(f)
this.f.push(e)
this.a=H.j([],[P.u])
for(x=1;x<4;++x)this.aI("level/nonomino/level"+C.c.i(x)+".json")},
p:{
fM:function(){var z=new L.fL(null,$.$get$cY(),null,null,null,null)
z.cZ()
return z}}},fN:{"^":"e:1;a",
$1:function(a){this.a.a.push(a)
return}},fO:{"^":"b;a,b,c,d,e,f,r",
dU:function(){var z,y,x,w,v,u,t
for(z=0;z<$.fT;++z){y=J.e2(this.f)
for(x=J.m(y),w=0;w<$.fR;++w){v=x.bb(y)
v.id="Game_"+C.c.i(z)+"_"+C.c.i(w)
v.classList.add("GameCell")}}u=this.bt()
x=this.f.style
t=C.c.i(u)+"px"
x.width=t
x=this.f.style
t=C.c.i(u)+"px"
x.height=t},
bt:function(){var z,y,x,w
z=window.innerWidth
y=$.fU
if(typeof z!=="number")return z.O()
x=C.c.D(z*y,100)
y=window.innerHeight
z=$.fS
if(typeof y!=="number")return y.O()
w=C.c.D(y*z,100)
if(x<=w)return x
return w},
dS:function(){var z,y,x,w,v,u,t,s,r,q,p
for(z=this.r,y=J.m(z),x=1,w=0;w<$.fQ;++w){v=y.aF(z)
for(u=w===0,t=J.m(v),s=0;s<$.fP;++s){r=t.bb(v)
r.id="Control_"+C.c.i(w)+"_"+C.c.i(s)
r.classList.add("ControlCell")
r.textContent=C.c.i(x)
if(u&&s===0)r.classList.add("selectedControl");++x}}q=J.e0(y.aF(z))
q.id="Control_Hint"
q.classList.add("ControlCell")
q.textContent="hint (  )"
J.ej(q,3)
y=window.innerHeight
u=$.d5
if(typeof y!=="number")return y.O()
p=C.c.D(y*u,100)
u=z.style
y=C.c.i(p)+"px"
u.width=y
z=z.style
y=C.c.i(p)+"px"
z.height=y},
cw:function(){var z,y,x,w
z=this.a.b
for(y=0;y<9;++y)for(x=0;x<9;++x){w=document.getElementById("Game_"+C.c.i(y)+"_"+C.c.i(x))
if(y>=z.length)return H.a(z,y)
if(J.x(J.C(z[y],x),-1))w.textContent=""
else{if(y>=z.length)return H.a(z,y)
w.textContent=J.E(J.C(z[y],x))}}document.getElementById("Control_Hint").textContent="hint ( "+C.c.i(this.a.r)+" )"},
cN:function(){var z,y,x,w
z=new W.aI(document.querySelectorAll(".ControlCell"),[null])
y=new H.a2(z,z.gj(z),0,null)
$loop$0:if(y.k()){x=y.d
y=J.co(x)
w=J.E(this.a.f)
if(y==null?w==null:y===w)this.br(x)
break $loop$0}},
br:function(a){var z,y,x,w
z=new W.aI(document.querySelectorAll(".ControlCell"),[null])
for(y=new H.a2(z,z.gj(z),0,null);y.k();){x=y.d
w=J.m(x)
if(w.gF(x).q(0,"selectedControl")){w.gF(x).u(0,"selectedControl")
break}}J.cn(a).A(0,"selectedControl")},
eh:function(){var z,y,x,w,v,u,t,s,r,q,p,o,n,m
z=new W.aI(document.querySelectorAll(".GameCell"),[null])
y=this.a
x=y.b
w=y.d
v=y.e
for(y=new H.a2(z,z.gj(z),0,null),u=v!=null;y.k();){t=y.d
s=J.m(t)
s.gF(t).K(0)
s.gF(t).A(0,"GameCell")
s.gF(t).A(0,"COLOR_STANDARD")
r=J.b7(s.ga5(t),5)
q=H.ak(C.e.ah(r,0,1),null,null)
p=H.ak(C.e.U(r,2),null,null)
if(q>>>0!==q||q>=x.length)return H.a(x,q)
if(!J.x(J.C(x[q],p),-1))s.gF(t).A(0,"fixedGameField")
if(q>=w.length)return H.a(w,q)
o=w[q]
if(p>>>0!==p||p>=o.length)return H.a(o,p)
n=J.b7(J.E(o[p]),7)
s.gF(t).A(0,n)
if(u){if(q>=v.length)return H.a(v,q)
o=v[q]
if(p>=o.length)return H.a(o,p)
m=o[p]
s=s.gdW(t)
o="data-"+s.a8("col")
s=s.a.a
if(s.hasAttribute(o)!==!0)s.setAttribute(o,new L.fV(p).$0())
s.getAttribute(o)
s="data-"+new W.c4(new W.bm(t)).a8("row")
if(t.hasAttribute(s)!==!0)t.setAttribute(s,new L.fW(q).$0())
t.getAttribute(s)
s="data-"+new W.c4(new W.bm(t)).a8("sides")
if(t.hasAttribute(s)!==!0)t.setAttribute(s,new L.fX(m).$0())
t.getAttribute(s)
s=t.style
o=m.a===C.f?"inset":"solid"
s.borderLeft=o
s=t.style
o=m.b===C.f?"inset":"solid"
s.borderBottom=o
s=t.style
o=m.c===C.f?"inset":"solid"
s.borderRight=o
s=t.style
o=m.d===C.f?"inset":"solid"
s.borderTop=o}}},
cz:function(a){var z,y,x,w
z=a.a
y=C.a.I(C.a.D(z,36e8),24)
x=C.a.I(C.a.D(z,6e7),60)
w=C.a.I(C.a.D(z,1e6),60)
this.e.textContent=C.a.i(y)+":"+C.a.i(x)+":"+C.a.i(w)},
af:function(a){var z,y,x,w,v,u,t,s
z=new W.aI(document.querySelectorAll(".GameCell"),[null])
for(y=new H.a2(z,z.gj(z),0,null);y.k();){x=y.d
w=J.m(x)
v=J.b7(w.ga5(x),5)
u=H.ak(C.e.ah(v,0,1),null,null)
t=H.ak(C.e.U(v,2),null,null)
if(a){s=this.a.b
if(u>>>0!==u||u>=s.length)return H.a(s,u)
if(J.x(J.C(s[u],t),this.a.f))w.gF(x).A(0,"highlighted")
else if(w.gF(x).q(0,"highlighted"))w.gF(x).u(0,"highlighted")}else w.gF(x).u(0,"highlighted")}}},fV:{"^":"e:0;a",
$0:function(){return H.d(this.a)}},fW:{"^":"e:0;a",
$0:function(){return H.d(this.a)}},fX:{"^":"e:0;a",
$0:function(){return this.a.i(0)}}}],["","",,B,{"^":"",
kP:[function(){var z,y
z=document
y=new L.fE(z.getElementById("overlay"),z.getElementById("newGameButton"),z.getElementById("helpButton"),!1,null,null,null,null,null)
y.r=L.fM()
z=new L.fO(null,z.getElementById("warningOverlay"),z.getElementById("overlay"),z.getElementById("container"),z.getElementById("clock"),z.getElementById("sudokuGameField"),z.getElementById("sudokuControlField"))
z.dU()
z.dS()
y.y=z
y.dF()
return y},"$0","dZ",0,0,0]},1]]
setupProgram(dart,0)
J.n=function(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.cI.prototype
return J.f3.prototype}if(typeof a=="string")return J.aZ.prototype
if(a==null)return J.f4.prototype
if(typeof a=="boolean")return J.f2.prototype
if(a.constructor==Array)return J.aX.prototype
if(typeof a!="object"){if(typeof a=="function")return J.b_.prototype
return a}if(a instanceof P.b)return a
return J.bt(a)}
J.z=function(a){if(typeof a=="string")return J.aZ.prototype
if(a==null)return a
if(a.constructor==Array)return J.aX.prototype
if(typeof a!="object"){if(typeof a=="function")return J.b_.prototype
return a}if(a instanceof P.b)return a
return J.bt(a)}
J.at=function(a){if(a==null)return a
if(a.constructor==Array)return J.aX.prototype
if(typeof a!="object"){if(typeof a=="function")return J.b_.prototype
return a}if(a instanceof P.b)return a
return J.bt(a)}
J.aO=function(a){if(typeof a=="number")return J.aY.prototype
if(a==null)return a
if(!(a instanceof P.b))return J.b2.prototype
return a}
J.dP=function(a){if(typeof a=="number")return J.aY.prototype
if(typeof a=="string")return J.aZ.prototype
if(a==null)return a
if(!(a instanceof P.b))return J.b2.prototype
return a}
J.aP=function(a){if(typeof a=="string")return J.aZ.prototype
if(a==null)return a
if(!(a instanceof P.b))return J.b2.prototype
return a}
J.m=function(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.b_.prototype
return a}if(a instanceof P.b)return a
return J.bt(a)}
J.ax=function(a,b){if(typeof a=="number"&&typeof b=="number")return a+b
return J.dP(a).S(a,b)}
J.x=function(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.n(a).w(a,b)}
J.by=function(a,b){if(typeof a=="number"&&typeof b=="number")return a>b
return J.aO(a).ad(a,b)}
J.cj=function(a,b){if(typeof a=="number"&&typeof b=="number")return a<b
return J.aO(a).ae(a,b)}
J.aQ=function(a,b){if(typeof a=="number"&&typeof b=="number")return a*b
return J.dP(a).O(a,b)}
J.ac=function(a,b){if(typeof a=="number"&&typeof b=="number")return a-b
return J.aO(a).ag(a,b)}
J.aR=function(a,b){return J.aO(a).aR(a,b)}
J.C=function(a,b){if(typeof b==="number")if(a.constructor==Array||typeof a=="string"||H.dT(a,a[init.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.z(a).h(a,b)}
J.aS=function(a,b,c){if(typeof b==="number")if((a.constructor==Array||H.dT(a,a[init.dispatchPropertyName]))&&!a.immutable$list&&b>>>0===b&&b<a.length)return a[b]=c
return J.at(a).n(a,b,c)}
J.R=function(a,b,c,d){return J.m(a).aT(a,b,c,d)}
J.e0=function(a){return J.m(a).bb(a)}
J.ck=function(a,b,c){return J.m(a).dH(a,b,c)}
J.e1=function(a,b,c,d){return J.m(a).c8(a,b,c,d)}
J.e2=function(a){return J.m(a).aF(a)}
J.e3=function(a,b){return J.aP(a).dI(a,b)}
J.e4=function(a,b){return J.m(a).aG(a,b)}
J.e5=function(a,b){return J.z(a).q(a,b)}
J.cl=function(a,b){return J.at(a).H(a,b)}
J.cm=function(a){return J.m(a).gdL(a)}
J.cn=function(a){return J.m(a).gF(a)}
J.aT=function(a){return J.m(a).ga2(a)}
J.W=function(a){return J.n(a).gC(a)}
J.e6=function(a){return J.m(a).ga5(a)}
J.aU=function(a){return J.at(a).gv(a)}
J.D=function(a){return J.z(a).gj(a)}
J.e7=function(a){return J.m(a).gE(a)}
J.e8=function(a){return J.m(a).gez(a)}
J.e9=function(a){return J.m(a).geB(a)}
J.ea=function(a){return J.m(a).geC(a)}
J.eb=function(a){return J.m(a).geP(a)}
J.ec=function(a){return J.m(a).geT(a)}
J.co=function(a){return J.m(a).geU(a)}
J.ed=function(a){return J.m(a).gl(a)}
J.ad=function(a,b){return J.z(a).bg(a,b)}
J.ee=function(a,b){return J.at(a).Y(a,b)}
J.ef=function(a){return J.at(a).eE(a)}
J.eg=function(a,b){return J.at(a).u(a,b)}
J.ae=function(a,b){return J.at(a).ac(a,b)}
J.eh=function(a,b,c,d){return J.m(a).eG(a,b,c,d)}
J.ay=function(a,b){return J.m(a).av(a,b)}
J.ei=function(a,b){return J.m(a).sdM(a,b)}
J.ej=function(a,b){return J.m(a).sdN(a,b)}
J.ek=function(a,b){return J.m(a).saH(a,b)}
J.af=function(a,b){return J.m(a).scm(a,b)}
J.b7=function(a,b){return J.aP(a).U(a,b)}
J.cp=function(a){return J.aP(a).eV(a)}
J.E=function(a){return J.n(a).i(a)}
J.el=function(a){return J.aP(a).eW(a)}
J.cq=function(a){return J.aP(a).eX(a)}
I.au=function(a){a.immutable$list=Array
a.fixed$length=Array
return a}
var $=I.p
C.q=W.bA.prototype
C.N=W.aW.prototype
C.O=J.f.prototype
C.b=J.aX.prototype
C.c=J.cI.prototype
C.a=J.aY.prototype
C.e=J.aZ.prototype
C.V=J.b_.prototype
C.F=J.fo.prototype
C.G=W.fY.prototype
C.p=J.b2.prototype
C.a0=W.h8.prototype
C.h=new L.cr(0,"BorderType.THICK")
C.f=new L.cr(1,"BorderType.THIN")
C.H=new P.hl()
C.I=new P.hJ()
C.d=new P.i3()
C.J=new L.F(0,"Colors.COLOR_STANDARD")
C.K=new L.F(1,"Colors.COLOR_STANDARD_DARK")
C.r=new L.F(10,"Colors.COLOR_8")
C.t=new L.F(11,"Colors.COLOR_9")
C.i=new L.F(2,"Colors.COLOR_HIGHLIGHTED")
C.u=new L.F(3,"Colors.COLOR_1")
C.v=new L.F(4,"Colors.COLOR_2")
C.w=new L.F(5,"Colors.COLOR_3")
C.x=new L.F(6,"Colors.COLOR_4")
C.y=new L.F(7,"Colors.COLOR_5")
C.z=new L.F(8,"Colors.COLOR_6")
C.A=new L.F(9,"Colors.COLOR_7")
C.B=new P.a0(0)
C.L=new P.a0(1e6)
C.M=new L.aB(0,"GameTypes.STANDARD_SUDOKU")
C.j=new L.aB(1,"GameTypes.X_SUDOKU")
C.k=new L.aB(2,"GameTypes.HYPER_SUDOKU")
C.l=new L.aB(3,"GameTypes.MIDDELPOINT_SUDOKU")
C.m=new L.aB(4,"GameTypes.COLOR_SUDOKU")
C.n=new L.aB(5,"GameTypes.NONOMINO_SUDOKU")
C.P=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
C.Q=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
C.C=function(hooks) { return hooks; }

C.R=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var ua = navigator.userAgent;
    if (ua.indexOf("DumpRenderTree") >= 0) return hooks;
    if (ua.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
C.S=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (self.HTMLElement && object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof navigator == "object";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
C.T=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
C.U=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
C.D=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
C.W=new P.fa(null,null)
C.X=new P.fb(null)
C.Y=H.j(I.au(["*::class","*::dir","*::draggable","*::hidden","*::id","*::inert","*::itemprop","*::itemref","*::itemscope","*::lang","*::spellcheck","*::title","*::translate","A::accesskey","A::coords","A::hreflang","A::name","A::shape","A::tabindex","A::target","A::type","AREA::accesskey","AREA::alt","AREA::coords","AREA::nohref","AREA::shape","AREA::tabindex","AREA::target","AUDIO::controls","AUDIO::loop","AUDIO::mediagroup","AUDIO::muted","AUDIO::preload","BDO::dir","BODY::alink","BODY::bgcolor","BODY::link","BODY::text","BODY::vlink","BR::clear","BUTTON::accesskey","BUTTON::disabled","BUTTON::name","BUTTON::tabindex","BUTTON::type","BUTTON::value","CANVAS::height","CANVAS::width","CAPTION::align","COL::align","COL::char","COL::charoff","COL::span","COL::valign","COL::width","COLGROUP::align","COLGROUP::char","COLGROUP::charoff","COLGROUP::span","COLGROUP::valign","COLGROUP::width","COMMAND::checked","COMMAND::command","COMMAND::disabled","COMMAND::label","COMMAND::radiogroup","COMMAND::type","DATA::value","DEL::datetime","DETAILS::open","DIR::compact","DIV::align","DL::compact","FIELDSET::disabled","FONT::color","FONT::face","FONT::size","FORM::accept","FORM::autocomplete","FORM::enctype","FORM::method","FORM::name","FORM::novalidate","FORM::target","FRAME::name","H1::align","H2::align","H3::align","H4::align","H5::align","H6::align","HR::align","HR::noshade","HR::size","HR::width","HTML::version","IFRAME::align","IFRAME::frameborder","IFRAME::height","IFRAME::marginheight","IFRAME::marginwidth","IFRAME::width","IMG::align","IMG::alt","IMG::border","IMG::height","IMG::hspace","IMG::ismap","IMG::name","IMG::usemap","IMG::vspace","IMG::width","INPUT::accept","INPUT::accesskey","INPUT::align","INPUT::alt","INPUT::autocomplete","INPUT::autofocus","INPUT::checked","INPUT::disabled","INPUT::inputmode","INPUT::ismap","INPUT::list","INPUT::max","INPUT::maxlength","INPUT::min","INPUT::multiple","INPUT::name","INPUT::placeholder","INPUT::readonly","INPUT::required","INPUT::size","INPUT::step","INPUT::tabindex","INPUT::type","INPUT::usemap","INPUT::value","INS::datetime","KEYGEN::disabled","KEYGEN::keytype","KEYGEN::name","LABEL::accesskey","LABEL::for","LEGEND::accesskey","LEGEND::align","LI::type","LI::value","LINK::sizes","MAP::name","MENU::compact","MENU::label","MENU::type","METER::high","METER::low","METER::max","METER::min","METER::value","OBJECT::typemustmatch","OL::compact","OL::reversed","OL::start","OL::type","OPTGROUP::disabled","OPTGROUP::label","OPTION::disabled","OPTION::label","OPTION::selected","OPTION::value","OUTPUT::for","OUTPUT::name","P::align","PRE::width","PROGRESS::max","PROGRESS::min","PROGRESS::value","SELECT::autocomplete","SELECT::disabled","SELECT::multiple","SELECT::name","SELECT::required","SELECT::size","SELECT::tabindex","SOURCE::type","TABLE::align","TABLE::bgcolor","TABLE::border","TABLE::cellpadding","TABLE::cellspacing","TABLE::frame","TABLE::rules","TABLE::summary","TABLE::width","TBODY::align","TBODY::char","TBODY::charoff","TBODY::valign","TD::abbr","TD::align","TD::axis","TD::bgcolor","TD::char","TD::charoff","TD::colspan","TD::headers","TD::height","TD::nowrap","TD::rowspan","TD::scope","TD::valign","TD::width","TEXTAREA::accesskey","TEXTAREA::autocomplete","TEXTAREA::cols","TEXTAREA::disabled","TEXTAREA::inputmode","TEXTAREA::name","TEXTAREA::placeholder","TEXTAREA::readonly","TEXTAREA::required","TEXTAREA::rows","TEXTAREA::tabindex","TEXTAREA::wrap","TFOOT::align","TFOOT::char","TFOOT::charoff","TFOOT::valign","TH::abbr","TH::align","TH::axis","TH::bgcolor","TH::char","TH::charoff","TH::colspan","TH::headers","TH::height","TH::nowrap","TH::rowspan","TH::scope","TH::valign","TH::width","THEAD::align","THEAD::char","THEAD::charoff","THEAD::valign","TR::align","TR::bgcolor","TR::char","TR::charoff","TR::valign","TRACK::default","TRACK::kind","TRACK::label","TRACK::srclang","UL::compact","UL::type","VIDEO::controls","VIDEO::height","VIDEO::loop","VIDEO::mediagroup","VIDEO::muted","VIDEO::preload","VIDEO::width"]),[P.u])
C.Z=I.au(["HEAD","AREA","BASE","BASEFONT","BR","COL","COLGROUP","EMBED","FRAME","FRAMESET","HR","IMAGE","IMG","INPUT","ISINDEX","LINK","META","PARAM","SOURCE","STYLE","TITLE","WBR"])
C.a_=I.au([])
C.E=H.j(I.au(["bind","if","ref","repeat","syntax"]),[P.u])
C.o=H.j(I.au(["A::href","AREA::href","BLOCKQUOTE::cite","BODY::background","COMMAND::icon","DEL::cite","FORM::action","IMG::src","INPUT::src","INS::cite","Q::cite","VIDEO::poster"]),[P.u])
$.cU="$cachedFunction"
$.cV="$cachedInvocation"
$.aF=null
$.T=null
$.X=0
$.az=null
$.cs=null
$.ce=null
$.dK=null
$.dW=null
$.bs=null
$.bv=null
$.cf=null
$.ao=null
$.aK=null
$.aL=null
$.cb=!1
$.l=C.d
$.cA=0
$.U=null
$.a7=null
$.bF=null
$.cy=null
$.cx=null
$.fT=9
$.fR=9
$.fU=90
$.fS=60
$.fQ=3
$.fP=3
$.d5=25
$=null
init.isHunkLoaded=function(a){return!!$dart_deferred_initializers$[a]}
init.deferredInitialized=new Object(null)
init.isHunkInitialized=function(a){return init.deferredInitialized[a]}
init.initializeLoadedHunk=function(a){$dart_deferred_initializers$[a]($globals$,$)
init.deferredInitialized[a]=true}
init.deferredLibraryUris={}
init.deferredLibraryHashes={};(function(a){for(var z=0;z<a.length;){var y=a[z++]
var x=a[z++]
var w=a[z++]
I.$lazy(y,x,w)}})(["cw","$get$cw",function(){return H.dQ("_$dart_dartClosure")},"bL","$get$bL",function(){return H.dQ("_$dart_js")},"cE","$get$cE",function(){return H.eZ()},"cF","$get$cF",function(){if(typeof WeakMap=="function")var z=new WeakMap()
else{z=$.cA
$.cA=z+1
z="expando$key$"+z}return new P.eE(null,z)},"db","$get$db",function(){return H.a_(H.bj({
toString:function(){return"$receiver$"}}))},"dc","$get$dc",function(){return H.a_(H.bj({$method$:null,
toString:function(){return"$receiver$"}}))},"dd","$get$dd",function(){return H.a_(H.bj(null))},"de","$get$de",function(){return H.a_(function(){var $argumentsExpr$='$arguments$'
try{null.$method$($argumentsExpr$)}catch(z){return z.message}}())},"di","$get$di",function(){return H.a_(H.bj(void 0))},"dj","$get$dj",function(){return H.a_(function(){var $argumentsExpr$='$arguments$'
try{(void 0).$method$($argumentsExpr$)}catch(z){return z.message}}())},"dg","$get$dg",function(){return H.a_(H.dh(null))},"df","$get$df",function(){return H.a_(function(){try{null.$method$}catch(z){return z.message}}())},"dl","$get$dl",function(){return H.a_(H.dh(void 0))},"dk","$get$dk",function(){return H.a_(function(){try{(void 0).$method$}catch(z){return z.message}}())},"c3","$get$c3",function(){return P.ha()},"bc","$get$bc",function(){return P.hu(null,null)},"aM","$get$aM",function(){return[]},"dx","$get$dx",function(){return P.cL(["A","ABBR","ACRONYM","ADDRESS","AREA","ARTICLE","ASIDE","AUDIO","B","BDI","BDO","BIG","BLOCKQUOTE","BR","BUTTON","CANVAS","CAPTION","CENTER","CITE","CODE","COL","COLGROUP","COMMAND","DATA","DATALIST","DD","DEL","DETAILS","DFN","DIR","DIV","DL","DT","EM","FIELDSET","FIGCAPTION","FIGURE","FONT","FOOTER","FORM","H1","H2","H3","H4","H5","H6","HEADER","HGROUP","HR","I","IFRAME","IMG","INPUT","INS","KBD","LABEL","LEGEND","LI","MAP","MARK","MENU","METER","NAV","NOBR","OL","OPTGROUP","OPTION","OUTPUT","P","PRE","PROGRESS","Q","S","SAMP","SECTION","SELECT","SMALL","SOURCE","SPAN","STRIKE","STRONG","SUB","SUMMARY","SUP","TABLE","TBODY","TD","TEXTAREA","TFOOT","TH","THEAD","TIME","TR","TRACK","TT","U","UL","VAR","VIDEO","WBR"],null)},"c8","$get$c8",function(){return P.bO()},"cv","$get$cv",function(){return P.ft("^\\S+$",!0,!1)},"cY","$get$cY",function(){return P.hL()}])
I=I.$finishIsolateConstructor(I)
$=new I()
init.metadata=[null]
init.types=[{func:1},{func:1,args:[,]},{func:1,v:true},{func:1,v:true,args:[,]},{func:1,v:true,args:[{func:1,v:true}]},{func:1,v:true,args:[P.b],opt:[P.al]},{func:1,ret:P.u,args:[P.k]},{func:1,args:[P.ah]},{func:1,ret:P.aN,args:[W.a1,P.u,P.u,W.c7]},{func:1,args:[,P.u]},{func:1,args:[P.u]},{func:1,args:[{func:1,v:true}]},{func:1,args:[,P.al]},{func:1,args:[P.k,,]},{func:1,args:[,],opt:[,]},{func:1,v:true,args:[,P.al]},{func:1,args:[,,]},{func:1,args:[W.aW]},{func:1,args:[P.u,P.u]},{func:1,args:[W.a1]},{func:1,args:[P.aN,P.ah]},{func:1,v:true,args:[W.p,W.p]},{func:1,ret:P.av}]
function convertToFastObject(a){function MyClass(){}MyClass.prototype=a
new MyClass()
return a}function convertToSlowObject(a){a.__MAGIC_SLOW_PROPERTY=1
delete a.__MAGIC_SLOW_PROPERTY
return a}A=convertToFastObject(A)
B=convertToFastObject(B)
C=convertToFastObject(C)
D=convertToFastObject(D)
E=convertToFastObject(E)
F=convertToFastObject(F)
G=convertToFastObject(G)
H=convertToFastObject(H)
J=convertToFastObject(J)
K=convertToFastObject(K)
L=convertToFastObject(L)
M=convertToFastObject(M)
N=convertToFastObject(N)
O=convertToFastObject(O)
P=convertToFastObject(P)
Q=convertToFastObject(Q)
R=convertToFastObject(R)
S=convertToFastObject(S)
T=convertToFastObject(T)
U=convertToFastObject(U)
V=convertToFastObject(V)
W=convertToFastObject(W)
X=convertToFastObject(X)
Y=convertToFastObject(Y)
Z=convertToFastObject(Z)
function init(){I.p=Object.create(null)
init.allClasses=map()
init.getTypeFromName=function(a){return init.allClasses[a]}
init.interceptorsByTag=map()
init.leafTags=map()
init.finishedClasses=map()
I.$lazy=function(a,b,c,d,e){if(!init.lazies)init.lazies=Object.create(null)
init.lazies[a]=b
e=e||I.p
var z={}
var y={}
e[a]=z
e[b]=function(){var x=this[a]
if(x==y)H.j8(d||a)
try{if(x===z){this[a]=y
try{x=this[a]=c()}finally{if(x===z)this[a]=null}}return x}finally{this[b]=function(){return this[a]}}}}
I.$finishIsolateConstructor=function(a){var z=a.p
function Isolate(){var y=Object.keys(z)
for(var x=0;x<y.length;x++){var w=y[x]
this[w]=z[w]}var v=init.lazies
var u=v?Object.keys(v):[]
for(var x=0;x<u.length;x++)this[v[u[x]]]=null
function ForceEfficientMap(){}ForceEfficientMap.prototype=this
new ForceEfficientMap()
for(var x=0;x<u.length;x++){var t=v[u[x]]
this[t]=z[t]}}Isolate.prototype=a.prototype
Isolate.prototype.constructor=Isolate
Isolate.p=z
Isolate.au=a.au
Isolate.G=a.G
return Isolate}}!function(){var z=function(a){var t={}
t[a]=1
return Object.keys(convertToFastObject(t))[0]}
init.getIsolateTag=function(a){return z("___dart_"+a+init.isolateTag)}
var y="___dart_isolate_tags_"
var x=Object[y]||(Object[y]=Object.create(null))
var w="_ZxYxX"
for(var v=0;;v++){var u=z(w+"_"+v+"_")
if(!(u in x)){x[u]=1
init.isolateTag=u
break}}init.dispatchPropertyName=init.getIsolateTag("dispatch_record")}();(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!='undefined'){a(document.currentScript)
return}var z=document.scripts
function onLoad(b){for(var x=0;x<z.length;++x)z[x].removeEventListener("load",onLoad,false)
a(b.target)}for(var y=0;y<z.length;++y)z[y].addEventListener("load",onLoad,false)})(function(a){init.currentScript=a
if(typeof dartMainRunner==="function")dartMainRunner(function(b){H.dY(B.dZ(),b)},[])
else (function(b){H.dY(B.dZ(),b)})([])})})()