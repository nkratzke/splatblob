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
b5.$isa=b4
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
var d=supportsDirectProtoAccess&&b1!="a"
for(var c=0;c<f.length;c++){var a0=f[c]
var a1=a0.charCodeAt(0)
if(a0==="l"){processStatics(init.statics[b1]=b2.l,b3)
delete b2.l}else if(a1===43){w[g]=a0.substring(1)
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
e.$callName=null}}function tearOffGetter(c,d,e,f){return f?new Function("funcs","reflectionInfo","name","H","c","return function tearOff_"+e+y+++"(x) {"+"if (c === null) c = "+"H.c4"+"("+"this, funcs, reflectionInfo, false, [x], name);"+"return new c(this, funcs[0], x, name);"+"}")(c,d,e,H,null):new Function("funcs","reflectionInfo","name","H","c","return function tearOff_"+e+y+++"() {"+"if (c === null) c = "+"H.c4"+"("+"this, funcs, reflectionInfo, false, [], name);"+"return new c(this, funcs[0], null, name);"+"}")(c,d,e,H,null)}function tearOff(c,d,e,f,a0){var g
return e?function(){if(g===void 0)g=H.c4(this,c,d,true,[],f).prototype
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
x.push([p,o,i,h,n,j,k,m])}finishClasses(s)}I.B=function(){}
var dart=[["","",,H,{"^":"",jd:{"^":"a;a"}}],["","",,J,{"^":"",
r:function(a){return void 0},
bv:function(a,b,c,d){return{i:a,p:b,e:c,x:d}},
bs:function(a){var z,y,x,w,v
z=a[init.dispatchPropertyName]
if(z==null)if($.c6==null){H.il()
z=a[init.dispatchPropertyName]}if(z!=null){y=z.p
if(!1===y)return z.i
if(!0===y)return a
x=Object.getPrototypeOf(a)
if(y===x)return z.i
if(z.e===x)throw H.d(new P.da("Return interceptor for "+H.b(y(a,z))))}w=a.constructor
v=w==null?null:w[$.$get$bH()]
if(v!=null)return v
v=H.iv(a)
if(v!=null)return v
if(typeof a=="function")return C.B
y=Object.getPrototypeOf(a)
if(y==null)return C.o
if(y===Object.prototype)return C.o
if(typeof w=="function"){Object.defineProperty(w,$.$get$bH(),{value:C.j,enumerable:false,writable:true,configurable:true})
return C.j}return C.j},
f:{"^":"a;",
p:function(a,b){return a===b},
gu:function(a){return H.a9(a)},
i:["cT",function(a){return H.bf(a)}],
"%":"Blob|DOMError|DOMImplementation|File|FileError|MediaError|MediaKeyError|NavigatorUserMediaError|PositionError|SQLError|SVGAnimatedLength|SVGAnimatedLengthList|SVGAnimatedNumber|SVGAnimatedNumberList|SVGAnimatedString"},
eV:{"^":"f;",
i:function(a){return String(a)},
gu:function(a){return a?519018:218159},
$isc3:1},
eX:{"^":"f;",
p:function(a,b){return null==b},
i:function(a){return"null"},
gu:function(a){return 0}},
bI:{"^":"f;",
gu:function(a){return 0},
i:["cV",function(a){return String(a)}],
$iseY:1},
fj:{"^":"bI;"},
aZ:{"^":"bI;"},
aT:{"^":"bI;",
i:function(a){var z=a[$.$get$cl()]
return z==null?this.cV(a):J.W(z)},
$signature:function(){return{func:1,opt:[,,,,,,,,,,,,,,,,]}}},
aQ:{"^":"f;$ti",
c6:function(a,b){if(!!a.immutable$list)throw H.d(new P.z(b))},
c5:function(a,b){if(!!a.fixed$length)throw H.d(new P.z(b))},
aG:function(a,b){this.c5(a,"removeAt")
if(b<0||b>=a.length)throw H.d(P.aX(b,null,null))
return a.splice(b,1)[0]},
a0:function(a,b){return new H.az(a,b,[null,null])},
I:function(a,b){if(b<0||b>=a.length)return H.c(a,b)
return a[b]},
gdS:function(a){if(a.length>0)return a[0]
throw H.d(H.bG())},
br:function(a,b,c,d,e){var z,y,x
this.c6(a,"set range")
P.cQ(b,c,a.length,null,null,null)
z=c-b
if(z===0)return
if(e<0)H.w(P.aA(e,0,null,"skipCount",null))
if(e+z>d.length)throw H.d(H.eT())
if(e<b)for(y=z-1;y>=0;--y){x=e+y
if(x<0||x>=d.length)return H.c(d,x)
a[b+y]=d[x]}else for(y=0;y<z;++y){x=e+y
if(x<0||x>=d.length)return H.c(d,x)
a[b+y]=d[x]}},
c1:function(a,b){var z,y
z=a.length
for(y=0;y<z;++y){if(b.$1(a[y])===!0)return!0
if(a.length!==z)throw H.d(new P.a3(a))}return!1},
t:function(a,b){var z
for(z=0;z<a.length;++z)if(J.V(a[z],b))return!0
return!1},
i:function(a){return P.bb(a,"[","]")},
gv:function(a){return new J.e4(a,a.length,0,null)},
gu:function(a){return H.a9(a)},
gj:function(a){return a.length},
sj:function(a,b){this.c5(a,"set length")
if(b<0)throw H.d(P.aA(b,0,null,"newLength",null))
a.length=b},
h:function(a,b){if(typeof b!=="number"||Math.floor(b)!==b)throw H.d(H.v(a,b))
if(b>=a.length||b<0)throw H.d(H.v(a,b))
return a[b]},
m:function(a,b,c){this.c6(a,"indexed set")
if(typeof b!=="number"||Math.floor(b)!==b)throw H.d(H.v(a,b))
if(b>=a.length||b<0)throw H.d(H.v(a,b))
a[b]=c},
$isE:1,
$asE:I.B,
$isi:1,
$asi:null,
$ish:1,
$ash:null},
jc:{"^":"aQ;$ti"},
e4:{"^":"a;a,b,c,d",
gn:function(){return this.d},
k:function(){var z,y,x
z=this.a
y=z.length
if(this.b!==y)throw H.d(H.bx(z))
x=this.c
if(x>=y){this.d=null
return!1}this.d=z[x]
this.c=x+1
return!0}},
aR:{"^":"f;",
eu:function(a){var z
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){z=a<0?Math.ceil(a):Math.floor(a)
return z+0}throw H.d(new P.z(""+a+".toInt()"))},
dT:function(a){var z,y
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){z=a|0
return a===z?z:z-1}y=Math.floor(a)
if(isFinite(y))return y
throw H.d(new P.z(""+a+".floor()"))},
ep:function(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw H.d(new P.z(""+a+".round()"))},
aH:function(a){if(a<0)return-Math.round(-a)
else return Math.round(a)},
i:function(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gu:function(a){return a&0x1FFFFFFF},
H:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
return a+b},
a3:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
return a-b},
aa:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
return a*b},
aP:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
if((a|0)===a)if(b>=1||!1)return a/b|0
return this.bX(a,b)},
a5:function(a,b){return(a|0)===a?a/b|0:this.bX(a,b)},
bX:function(a,b){var z=a/b
if(z>=-2147483648&&z<=2147483647)return z|0
if(z>0){if(z!==1/0)return Math.floor(z)}else if(z>-1/0)return Math.ceil(z)
throw H.d(new P.z("Result of truncating division is "+H.b(z)+": "+H.b(a)+" ~/ "+b))},
bW:function(a,b){var z
if(a>0)z=b>31?0:a>>>b
else{z=b>31?31:b
z=a>>z>>>0}return z},
aq:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
return a<b},
W:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
return a>b},
aL:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
return a<=b},
ap:function(a,b){if(typeof b!=="number")throw H.d(H.F(b))
return a>=b},
$isar:1},
cz:{"^":"aR;",$isar:1,$isl:1},
eW:{"^":"aR;",$isar:1},
aS:{"^":"f;",
c8:function(a,b){if(b<0)throw H.d(H.v(a,b))
if(b>=a.length)H.w(H.v(a,b))
return a.charCodeAt(b)},
aW:function(a,b){if(b>=a.length)throw H.d(H.v(a,b))
return a.charCodeAt(b)},
H:function(a,b){if(typeof b!=="string")throw H.d(P.cg(b,null,null))
return a+b},
cR:function(a,b,c){var z
if(c>a.length)throw H.d(P.aA(c,0,a.length,null,null))
z=c+b.length
if(z>a.length)return!1
return b===a.substring(c,z)},
cQ:function(a,b){return this.cR(a,b,0)},
X:function(a,b,c){if(c==null)c=a.length
H.i7(c)
if(b<0)throw H.d(P.aX(b,null,null))
if(typeof c!=="number")return H.u(c)
if(b>c)throw H.d(P.aX(b,null,null))
if(c>a.length)throw H.d(P.aX(c,null,null))
return a.substring(b,c)},
cS:function(a,b){return this.X(a,b,null)},
ev:function(a){return a.toLowerCase()},
ew:function(a){var z,y,x,w,v
z=a.trim()
y=z.length
if(y===0)return z
if(this.aW(z,0)===133){x=J.eZ(z,1)
if(x===y)return""}else x=0
w=y-1
v=this.c8(z,w)===133?J.f_(z,w):y
if(x===0&&v===y)return z
return z.substring(x,v)},
aa:function(a,b){var z,y
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw H.d(C.q)
for(z=a,y="";!0;){if((b&1)===1)y=z+y
b=b>>>1
if(b===0)break
z+=z}return y},
i:function(a){return a},
gu:function(a){var z,y,x
for(z=a.length,y=0,x=0;x<z;++x){y=536870911&y+a.charCodeAt(x)
y=536870911&y+((524287&y)<<10)
y^=y>>6}y=536870911&y+((67108863&y)<<3)
y^=y>>11
return 536870911&y+((16383&y)<<15)},
gj:function(a){return a.length},
h:function(a,b){if(typeof b!=="number"||Math.floor(b)!==b)throw H.d(H.v(a,b))
if(b>=a.length||b<0)throw H.d(H.v(a,b))
return a[b]},
$isE:1,
$asE:I.B,
$isy:1,
l:{
cA:function(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
eZ:function(a,b){var z,y
for(z=a.length;b<z;){y=C.d.aW(a,b)
if(y!==32&&y!==13&&!J.cA(y))break;++b}return b},
f_:function(a,b){var z,y
for(;b>0;b=z){z=b-1
y=C.d.c8(a,z)
if(y!==32&&y!==13&&!J.cA(y))break}return b}}}}],["","",,H,{"^":"",
bG:function(){return new P.Y("No element")},
eU:function(){return new P.Y("Too many elements")},
eT:function(){return new P.Y("Too few elements")},
h:{"^":"L;$ti",$ash:null},
aU:{"^":"h;$ti",
gv:function(a){return new H.S(this,this.gj(this),0,null)},
bn:function(a,b){return this.cU(0,b)},
a0:function(a,b){return new H.az(this,b,[H.C(this,"aU",0),null])},
bm:function(a,b){var z,y,x
z=H.q([],[H.C(this,"aU",0)])
C.a.sj(z,this.gj(this))
for(y=0;y<this.gj(this);++y){x=this.I(0,y)
if(y>=z.length)return H.c(z,y)
z[y]=x}return z},
bl:function(a){return this.bm(a,!0)}},
S:{"^":"a;a,b,c,d",
gn:function(){return this.d},
k:function(){var z,y,x,w
z=this.a
y=J.U(z)
x=y.gj(z)
if(this.b!==x)throw H.d(new P.a3(z))
w=this.c
if(w>=x){this.d=null
return!1}this.d=y.I(z,w);++this.c
return!0}},
bN:{"^":"L;a,b,$ti",
gv:function(a){return new H.f8(null,J.aI(this.a),this.b,this.$ti)},
gj:function(a){return J.aJ(this.a)},
$asL:function(a,b){return[b]},
l:{
bd:function(a,b,c,d){if(!!J.r(a).$ish)return new H.cm(a,b,[c,d])
return new H.bN(a,b,[c,d])}}},
cm:{"^":"bN;a,b,$ti",$ish:1,
$ash:function(a,b){return[b]}},
f8:{"^":"cy;a,b,c,$ti",
k:function(){var z=this.b
if(z.k()){this.a=this.c.$1(z.gn())
return!0}this.a=null
return!1},
gn:function(){return this.a}},
az:{"^":"aU;a,b,$ti",
gj:function(a){return J.aJ(this.a)},
I:function(a,b){return this.b.$1(J.dQ(this.a,b))},
$asaU:function(a,b){return[b]},
$ash:function(a,b){return[b]},
$asL:function(a,b){return[b]}},
db:{"^":"L;a,b,$ti",
gv:function(a){return new H.fM(J.aI(this.a),this.b,this.$ti)},
a0:function(a,b){return new H.bN(this,b,[H.I(this,0),null])}},
fM:{"^":"cy;a,b,$ti",
k:function(){var z,y
for(z=this.a,y=this.b;z.k();)if(y.$1(z.gn())===!0)return!0
return!1},
gn:function(){return this.a.gn()}},
cs:{"^":"a;$ti"}}],["","",,H,{"^":"",
b0:function(a,b){var z=a.ai(b)
if(!init.globalState.d.cy)init.globalState.f.an()
return z},
dL:function(a,b){var z,y,x,w,v,u
z={}
z.a=b
if(b==null){b=[]
z.a=b
y=b}else y=b
if(!J.r(y).$isi)throw H.d(P.bA("Arguments to main must be a List: "+H.b(y)))
init.globalState=new H.hw(0,0,1,null,null,null,null,null,null,null,null,null,a)
y=init.globalState
x=self.window==null
w=self.Worker
v=x&&!!self.postMessage
y.x=v
v=!v
if(v)w=w!=null&&$.$get$cw()!=null
else w=!0
y.y=w
y.r=x&&v
y.f=new H.h3(P.bM(null,H.b_),0)
x=P.l
y.z=new H.ah(0,null,null,null,null,null,0,[x,H.c_])
y.ch=new H.ah(0,null,null,null,null,null,0,[x,null])
if(y.x===!0){w=new H.hv()
y.Q=w
self.onmessage=function(c,d){return function(e){c(d,e)}}(H.eM,w)
self.dartPrint=self.dartPrint||function(c){return function(d){if(self.console&&self.console.log)self.console.log(d)
else self.postMessage(c(d))}}(H.hx)}if(init.globalState.x===!0)return
y=init.globalState.a++
w=new H.ah(0,null,null,null,null,null,0,[x,H.bg])
x=P.G(null,null,null,x)
v=new H.bg(0,null,!1)
u=new H.c_(y,w,x,init.createNewIsolate(),v,new H.af(H.bw()),new H.af(H.bw()),!1,!1,[],P.G(null,null,null,null),null,null,!1,!0,P.G(null,null,null,null))
x.P(0,0)
u.bx(0,v)
init.globalState.e=u
init.globalState.d=u
if(H.ap(a,{func:1,args:[,]}))u.ai(new H.iz(z,a))
else if(H.ap(a,{func:1,args:[,,]}))u.ai(new H.iA(z,a))
else u.ai(a)
init.globalState.f.an()},
eQ:function(){var z=init.currentScript
if(z!=null)return String(z.src)
if(init.globalState.x===!0)return H.eR()
return},
eR:function(){var z,y
z=new Error().stack
if(z==null){z=function(){try{throw new Error()}catch(x){return x.stack}}()
if(z==null)throw H.d(new P.z("No stack trace"))}y=z.match(new RegExp("^ *at [^(]*\\((.*):[0-9]*:[0-9]*\\)$","m"))
if(y!=null)return y[1]
y=z.match(new RegExp("^[^@]*@(.*):[0-9]*$","m"))
if(y!=null)return y[1]
throw H.d(new P.z('Cannot extract URI from "'+H.b(z)+'"'))},
eM:function(a,b){var z,y,x,w,v,u,t,s,r,q,p,o,n
z=new H.bj(!0,[]).Y(b.data)
y=J.U(z)
switch(y.h(z,"command")){case"start":init.globalState.b=y.h(z,"id")
x=y.h(z,"functionName")
w=x==null?init.globalState.cx:init.globalFunctions[x]()
v=y.h(z,"args")
u=new H.bj(!0,[]).Y(y.h(z,"msg"))
t=y.h(z,"isSpawnUri")
s=y.h(z,"startPaused")
r=new H.bj(!0,[]).Y(y.h(z,"replyTo"))
y=init.globalState.a++
q=P.l
p=new H.ah(0,null,null,null,null,null,0,[q,H.bg])
q=P.G(null,null,null,q)
o=new H.bg(0,null,!1)
n=new H.c_(y,p,q,init.createNewIsolate(),o,new H.af(H.bw()),new H.af(H.bw()),!1,!1,[],P.G(null,null,null,null),null,null,!1,!0,P.G(null,null,null,null))
q.P(0,0)
n.bx(0,o)
init.globalState.f.a.N(new H.b_(n,new H.eN(w,v,u,t,s,r),"worker-start"))
init.globalState.d=n
init.globalState.f.an()
break
case"spawn-worker":break
case"message":if(y.h(z,"port")!=null)J.au(y.h(z,"port"),y.h(z,"msg"))
init.globalState.f.an()
break
case"close":init.globalState.ch.am(0,$.$get$cx().h(0,a))
a.terminate()
init.globalState.f.an()
break
case"log":H.eL(y.h(z,"msg"))
break
case"print":if(init.globalState.x===!0){y=init.globalState.Q
q=P.ax(["command","print","msg",z])
q=new H.ak(!0,P.aD(null,P.l)).C(q)
y.toString
self.postMessage(q)}else P.c8(y.h(z,"msg"))
break
case"error":throw H.d(y.h(z,"msg"))}},
eL:function(a){var z,y,x,w
if(init.globalState.x===!0){y=init.globalState.Q
x=P.ax(["command","log","msg",a])
x=new H.ak(!0,P.aD(null,P.l)).C(x)
y.toString
self.postMessage(x)}else try{self.console.log(a)}catch(w){H.x(w)
z=H.H(w)
throw H.d(P.b9(z))}},
eO:function(a,b,c,d,e,f){var z,y,x,w
z=init.globalState.d
y=z.a
$.cM=$.cM+("_"+y)
$.cN=$.cN+("_"+y)
y=z.e
x=init.globalState.d.a
w=z.f
J.au(f,["spawned",new H.bl(y,x),w,z.r])
x=new H.eP(a,b,c,d,z)
if(e===!0){z.c0(w,w)
init.globalState.f.a.N(new H.b_(z,x,"start isolate"))}else x.$0()},
hU:function(a){return new H.bj(!0,[]).Y(new H.ak(!1,P.aD(null,P.l)).C(a))},
iz:{"^":"e:1;a,b",
$0:function(){this.b.$1(this.a.a)}},
iA:{"^":"e:1;a,b",
$0:function(){this.b.$2(this.a.a,null)}},
hw:{"^":"a;a,b,c,d,e,f,r,x,y,z,Q,ch,cx",l:{
hx:function(a){var z=P.ax(["command","print","msg",a])
return new H.ak(!0,P.aD(null,P.l)).C(z)}}},
c_:{"^":"a;a,b,c,e5:d<,dH:e<,f,r,x,y,z,Q,ch,cx,cy,db,dx",
c0:function(a,b){if(!this.f.p(0,a))return
if(this.Q.P(0,b)&&!this.y)this.y=!0
this.b6()},
en:function(a){var z,y,x,w,v,u
if(!this.y)return
z=this.Q
z.am(0,a)
if(z.a===0){for(z=this.z;y=z.length,y!==0;){if(0>=y)return H.c(z,-1)
x=z.pop()
y=init.globalState.f.a
w=y.b
v=y.a
u=v.length
w=(w-1&u-1)>>>0
y.b=w
if(w<0||w>=u)return H.c(v,w)
v[w]=x
if(w===y.c)y.bG();++y.d}this.y=!1}this.b6()},
dA:function(a,b){var z,y,x
if(this.ch==null)this.ch=[]
for(z=J.r(a),y=0;x=this.ch,y<x.length;y+=2)if(z.p(a,x[y])){z=this.ch
x=y+1
if(x>=z.length)return H.c(z,x)
z[x]=b
return}x.push(a)
this.ch.push(b)},
el:function(a){var z,y,x
if(this.ch==null)return
for(z=J.r(a),y=0;x=this.ch,y<x.length;y+=2)if(z.p(a,x[y])){z=this.ch
x=y+2
z.toString
if(typeof z!=="object"||z===null||!!z.fixed$length)H.w(new P.z("removeRange"))
P.cQ(y,x,z.length,null,null,null)
z.splice(y,x-y)
return}},
cM:function(a,b){if(!this.r.p(0,a))return
this.db=b},
dX:function(a,b,c){var z=J.r(b)
if(!z.p(b,0))z=z.p(b,1)&&!this.cy
else z=!0
if(z){J.au(a,c)
return}z=this.cx
if(z==null){z=P.bM(null,null)
this.cx=z}z.N(new H.ho(a,c))},
dW:function(a,b){var z
if(!this.r.p(0,a))return
z=J.r(b)
if(!z.p(b,0))z=z.p(b,1)&&!this.cy
else z=!0
if(z){this.ba()
return}z=this.cx
if(z==null){z=P.bM(null,null)
this.cx=z}z.N(this.ge6())},
dY:function(a,b){var z,y,x
z=this.dx
if(z.a===0){if(this.db===!0&&this===init.globalState.e)return
if(self.console&&self.console.error)self.console.error(a,b)
else{P.c8(a)
if(b!=null)P.c8(b)}return}y=new Array(2)
y.fixed$length=Array
y[0]=J.W(a)
y[1]=b==null?null:J.W(b)
for(x=new P.dm(z,z.r,null,null),x.c=z.e;x.k();)J.au(x.d,y)},
ai:function(a){var z,y,x,w,v,u,t
z=init.globalState.d
init.globalState.d=this
$=this.d
y=null
x=this.cy
this.cy=!0
try{y=a.$0()}catch(u){t=H.x(u)
w=t
v=H.H(u)
this.dY(w,v)
if(this.db===!0){this.ba()
if(this===init.globalState.e)throw u}}finally{this.cy=x
init.globalState.d=z
if(z!=null)$=z.ge5()
if(this.cx!=null)for(;t=this.cx,!t.gE(t);)this.cx.ck().$0()}return y},
cf:function(a){return this.b.h(0,a)},
bx:function(a,b){var z=this.b
if(z.ag(a))throw H.d(P.b9("Registry: ports must be registered only once."))
z.m(0,a,b)},
b6:function(){var z=this.b
if(z.gj(z)-this.c.a>0||this.y||!this.x)init.globalState.z.m(0,this.a,this)
else this.ba()},
ba:[function(){var z,y,x,w,v
z=this.cx
if(z!=null)z.a7(0)
for(z=this.b,y=z.gcr(z),y=y.gv(y);y.k();)y.gn().da()
z.a7(0)
this.c.a7(0)
init.globalState.z.am(0,this.a)
this.dx.a7(0)
if(this.ch!=null){for(x=0;z=this.ch,y=z.length,x<y;x+=2){w=z[x]
v=x+1
if(v>=y)return H.c(z,v)
J.au(w,z[v])}this.ch=null}},"$0","ge6",0,0,2]},
ho:{"^":"e:2;a,b",
$0:function(){J.au(this.a,this.b)}},
h3:{"^":"a;a,b",
dM:function(){var z=this.a
if(z.b===z.c)return
return z.ck()},
co:function(){var z,y,x
z=this.dM()
if(z==null){if(init.globalState.e!=null)if(init.globalState.z.ag(init.globalState.e.a))if(init.globalState.r===!0){y=init.globalState.e.b
y=y.gE(y)}else y=!1
else y=!1
else y=!1
if(y)H.w(P.b9("Program exited with open ReceivePorts."))
y=init.globalState
if(y.x===!0){x=y.z
x=x.gE(x)&&y.f.b===0}else x=!1
if(x){y=y.Q
x=P.ax(["command","close"])
x=new H.ak(!0,new P.dn(0,null,null,null,null,null,0,[null,P.l])).C(x)
y.toString
self.postMessage(x)}return!1}z.ej()
return!0},
bS:function(){if(self.window!=null)new H.h4(this).$0()
else for(;this.co(););},
an:function(){var z,y,x,w,v
if(init.globalState.x!==!0)this.bS()
else try{this.bS()}catch(x){w=H.x(x)
z=w
y=H.H(x)
w=init.globalState.Q
v=P.ax(["command","error","msg",H.b(z)+"\n"+H.b(y)])
v=new H.ak(!0,P.aD(null,P.l)).C(v)
w.toString
self.postMessage(v)}}},
h4:{"^":"e:2;a",
$0:function(){if(!this.a.co())return
P.fI(C.k,this)}},
b_:{"^":"a;a,b,c",
ej:function(){var z=this.a
if(z.y){z.z.push(this)
return}z.ai(this.b)}},
hv:{"^":"a;"},
eN:{"^":"e:1;a,b,c,d,e,f",
$0:function(){H.eO(this.a,this.b,this.c,this.d,this.e,this.f)}},
eP:{"^":"e:2;a,b,c,d,e",
$0:function(){var z,y
z=this.e
z.x=!0
if(this.d!==!0)this.a.$1(this.c)
else{y=this.a
if(H.ap(y,{func:1,args:[,,]}))y.$2(this.b,this.c)
else if(H.ap(y,{func:1,args:[,]}))y.$1(this.b)
else y.$0()}z.b6()}},
dd:{"^":"a;"},
bl:{"^":"dd;b,a",
ar:function(a,b){var z,y,x
z=init.globalState.z.h(0,this.a)
if(z==null)return
y=this.b
if(y.gbJ())return
x=H.hU(b)
if(z.gdH()===y){y=J.U(x)
switch(y.h(x,0)){case"pause":z.c0(y.h(x,1),y.h(x,2))
break
case"resume":z.en(y.h(x,1))
break
case"add-ondone":z.dA(y.h(x,1),y.h(x,2))
break
case"remove-ondone":z.el(y.h(x,1))
break
case"set-errors-fatal":z.cM(y.h(x,1),y.h(x,2))
break
case"ping":z.dX(y.h(x,1),y.h(x,2),y.h(x,3))
break
case"kill":z.dW(y.h(x,1),y.h(x,2))
break
case"getErrors":y=y.h(x,1)
z.dx.P(0,y)
break
case"stopErrors":y=y.h(x,1)
z.dx.am(0,y)
break}return}init.globalState.f.a.N(new H.b_(z,new H.hz(this,x),"receive"))},
p:function(a,b){if(b==null)return!1
return b instanceof H.bl&&J.V(this.b,b.b)},
gu:function(a){return this.b.gb_()}},
hz:{"^":"e:1;a,b",
$0:function(){var z=this.a.b
if(!z.gbJ())z.d5(this.b)}},
c0:{"^":"dd;b,c,a",
ar:function(a,b){var z,y,x
z=P.ax(["command","message","port",this,"msg",b])
y=new H.ak(!0,P.aD(null,P.l)).C(z)
if(init.globalState.x===!0){init.globalState.Q.toString
self.postMessage(y)}else{x=init.globalState.ch.h(0,this.b)
if(x!=null)x.postMessage(y)}},
p:function(a,b){if(b==null)return!1
return b instanceof H.c0&&J.V(this.b,b.b)&&J.V(this.a,b.a)&&J.V(this.c,b.c)},
gu:function(a){var z,y,x
z=this.b
if(typeof z!=="number")return z.cN()
y=this.a
if(typeof y!=="number")return y.cN()
x=this.c
if(typeof x!=="number")return H.u(x)
return(z<<16^y<<8^x)>>>0}},
bg:{"^":"a;b_:a<,b,bJ:c<",
da:function(){this.c=!0
this.b=null},
d5:function(a){if(this.c)return
this.b.$1(a)},
$isfn:1},
cY:{"^":"a;a,b,c",
af:function(){if(self.setTimeout!=null){if(this.b)throw H.d(new P.z("Timer in event loop cannot be canceled."))
var z=this.c
if(z==null)return;--init.globalState.f.b
if(this.a)self.clearTimeout(z)
else self.clearInterval(z)
this.c=null}else throw H.d(new P.z("Canceling a timer."))},
d_:function(a,b){if(self.setTimeout!=null){++init.globalState.f.b
this.c=self.setInterval(H.ao(new H.fF(this,b),0),a)}else throw H.d(new P.z("Periodic timer."))},
cZ:function(a,b){var z,y
if(a===0)z=self.setTimeout==null||init.globalState.x===!0
else z=!1
if(z){this.c=1
z=init.globalState.f
y=init.globalState.d
z.a.N(new H.b_(y,new H.fG(this,b),"timer"))
this.b=!0}else if(self.setTimeout!=null){++init.globalState.f.b
this.c=self.setTimeout(H.ao(new H.fH(this,b),0),a)}else throw H.d(new P.z("Timer greater than 0."))},
l:{
fD:function(a,b){var z=new H.cY(!0,!1,null)
z.cZ(a,b)
return z},
fE:function(a,b){var z=new H.cY(!1,!1,null)
z.d_(a,b)
return z}}},
fG:{"^":"e:2;a,b",
$0:function(){this.a.c=null
this.b.$0()}},
fH:{"^":"e:2;a,b",
$0:function(){this.a.c=null;--init.globalState.f.b
this.b.$0()}},
fF:{"^":"e:1;a,b",
$0:function(){this.b.$1(this.a)}},
af:{"^":"a;b_:a<",
gu:function(a){var z=this.a
if(typeof z!=="number")return z.ey()
z=C.f.bW(z,0)^C.f.a5(z,4294967296)
z=(~z>>>0)+(z<<15>>>0)&4294967295
z=((z^z>>>12)>>>0)*5&4294967295
z=((z^z>>>4)>>>0)*2057&4294967295
return(z^z>>>16)>>>0},
p:function(a,b){var z,y
if(b==null)return!1
if(b===this)return!0
if(b instanceof H.af){z=this.a
y=b.a
return z==null?y==null:z===y}return!1}},
ak:{"^":"a;a,b",
C:[function(a){var z,y,x,w,v
if(a==null||typeof a==="string"||typeof a==="number"||typeof a==="boolean")return a
z=this.b
y=z.h(0,a)
if(y!=null)return["ref",y]
z.m(0,a,z.gj(z))
z=J.r(a)
if(!!z.$iscE)return["buffer",a]
if(!!z.$isbQ)return["typed",a]
if(!!z.$isE)return this.cI(a)
if(!!z.$iseK){x=this.gcF()
w=a.ga8()
w=H.bd(w,x,H.C(w,"L",0),null)
w=P.bc(w,!0,H.C(w,"L",0))
z=z.gcr(a)
z=H.bd(z,x,H.C(z,"L",0),null)
return["map",w,P.bc(z,!0,H.C(z,"L",0))]}if(!!z.$iseY)return this.cJ(a)
if(!!z.$isf)this.cp(a)
if(!!z.$isfn)this.ao(a,"RawReceivePorts can't be transmitted:")
if(!!z.$isbl)return this.cK(a)
if(!!z.$isc0)return this.cL(a)
if(!!z.$ise){v=a.$static_name
if(v==null)this.ao(a,"Closures can't be transmitted:")
return["function",v]}if(!!z.$isaf)return["capability",a.a]
if(!(a instanceof P.a))this.cp(a)
return["dart",init.classIdExtractor(a),this.cH(init.classFieldsExtractor(a))]},"$1","gcF",2,0,0],
ao:function(a,b){throw H.d(new P.z(H.b(b==null?"Can't transmit:":b)+" "+H.b(a)))},
cp:function(a){return this.ao(a,null)},
cI:function(a){var z=this.cG(a)
if(!!a.fixed$length)return["fixed",z]
if(!a.fixed$length)return["extendable",z]
if(!a.immutable$list)return["mutable",z]
if(a.constructor===Array)return["const",z]
this.ao(a,"Can't serialize indexable: ")},
cG:function(a){var z,y,x
z=[]
C.a.sj(z,a.length)
for(y=0;y<a.length;++y){x=this.C(a[y])
if(y>=z.length)return H.c(z,y)
z[y]=x}return z},
cH:function(a){var z
for(z=0;z<a.length;++z)C.a.m(a,z,this.C(a[z]))
return a},
cJ:function(a){var z,y,x,w
if(!!a.constructor&&a.constructor!==Object)this.ao(a,"Only plain JS Objects are supported:")
z=Object.keys(a)
y=[]
C.a.sj(y,z.length)
for(x=0;x<z.length;++x){w=this.C(a[z[x]])
if(x>=y.length)return H.c(y,x)
y[x]=w}return["js-object",z,y]},
cL:function(a){if(this.a)return["sendport",a.b,a.a,a.c]
return["raw sendport",a]},
cK:function(a){if(this.a)return["sendport",init.globalState.b,a.a,a.b.gb_()]
return["raw sendport",a]}},
bj:{"^":"a;a,b",
Y:[function(a){var z,y,x,w,v,u
if(a==null||typeof a==="string"||typeof a==="number"||typeof a==="boolean")return a
if(typeof a!=="object"||a===null||a.constructor!==Array)throw H.d(P.bA("Bad serialized message: "+H.b(a)))
switch(C.a.gdS(a)){case"ref":if(1>=a.length)return H.c(a,1)
z=a[1]
y=this.b
if(z>>>0!==z||z>=y.length)return H.c(y,z)
return y[z]
case"buffer":if(1>=a.length)return H.c(a,1)
x=a[1]
this.b.push(x)
return x
case"typed":if(1>=a.length)return H.c(a,1)
x=a[1]
this.b.push(x)
return x
case"fixed":if(1>=a.length)return H.c(a,1)
x=a[1]
this.b.push(x)
y=H.q(this.ah(x),[null])
y.fixed$length=Array
return y
case"extendable":if(1>=a.length)return H.c(a,1)
x=a[1]
this.b.push(x)
return H.q(this.ah(x),[null])
case"mutable":if(1>=a.length)return H.c(a,1)
x=a[1]
this.b.push(x)
return this.ah(x)
case"const":if(1>=a.length)return H.c(a,1)
x=a[1]
this.b.push(x)
y=H.q(this.ah(x),[null])
y.fixed$length=Array
return y
case"map":return this.dP(a)
case"sendport":return this.dQ(a)
case"raw sendport":if(1>=a.length)return H.c(a,1)
x=a[1]
this.b.push(x)
return x
case"js-object":return this.dO(a)
case"function":if(1>=a.length)return H.c(a,1)
x=init.globalFunctions[a[1]]()
this.b.push(x)
return x
case"capability":if(1>=a.length)return H.c(a,1)
return new H.af(a[1])
case"dart":y=a.length
if(1>=y)return H.c(a,1)
w=a[1]
if(2>=y)return H.c(a,2)
v=a[2]
u=init.instanceFromClassId(w)
this.b.push(u)
this.ah(v)
return init.initializeEmptyInstance(w,u,v)
default:throw H.d("couldn't deserialize: "+H.b(a))}},"$1","gdN",2,0,0],
ah:function(a){var z,y,x
z=J.U(a)
y=0
while(!0){x=z.gj(a)
if(typeof x!=="number")return H.u(x)
if(!(y<x))break
z.m(a,y,this.Y(z.h(a,y)));++y}return a},
dP:function(a){var z,y,x,w,v,u
z=a.length
if(1>=z)return H.c(a,1)
y=a[1]
if(2>=z)return H.c(a,2)
x=a[2]
w=P.bK()
this.b.push(w)
y=J.dZ(y,this.gdN()).bl(0)
for(z=J.U(y),v=J.U(x),u=0;u<z.gj(y);++u){if(u>=y.length)return H.c(y,u)
w.m(0,y[u],this.Y(v.h(x,u)))}return w},
dQ:function(a){var z,y,x,w,v,u,t
z=a.length
if(1>=z)return H.c(a,1)
y=a[1]
if(2>=z)return H.c(a,2)
x=a[2]
if(3>=z)return H.c(a,3)
w=a[3]
if(J.V(y,init.globalState.b)){v=init.globalState.z.h(0,x)
if(v==null)return
u=v.cf(w)
if(u==null)return
t=new H.bl(u,x)}else t=new H.c0(y,w,x)
this.b.push(t)
return t},
dO:function(a){var z,y,x,w,v,u,t
z=a.length
if(1>=z)return H.c(a,1)
y=a[1]
if(2>=z)return H.c(a,2)
x=a[2]
w={}
this.b.push(w)
z=J.U(y)
v=J.U(x)
u=0
while(!0){t=z.gj(y)
if(typeof t!=="number")return H.u(t)
if(!(u<t))break
w[z.h(y,u)]=this.Y(v.h(x,u));++u}return w}}}],["","",,H,{"^":"",
id:function(a){return init.types[a]},
iu:function(a,b){var z
if(b!=null){z=b.x
if(z!=null)return z}return!!J.r(a).$isM},
b:function(a){var z
if(typeof a==="string")return a
if(typeof a==="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
z=J.W(a)
if(typeof z!=="string")throw H.d(H.F(a))
return z},
a9:function(a){var z=a.$identityHash
if(z==null){z=Math.random()*0x3fffffff|0
a.$identityHash=z}return z},
cK:function(a,b){throw H.d(new P.cu("Invalid double",a,null))},
aV:function(a,b){var z,y
if(!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(a))return H.cK(a,b)
z=parseFloat(a)
if(isNaN(z)){y=C.d.ew(a)
if(y==="NaN"||y==="+NaN"||y==="-NaN")return z
return H.cK(a,b)}return z},
cO:function(a){var z,y,x,w,v,u,t,s
z=J.r(a)
y=z.constructor
if(typeof y=="function"){x=y.name
w=typeof x==="string"?x:null}else w=null
if(w==null||z===C.u||!!J.r(a).$isaZ){v=C.m(a)
if(v==="Object"){u=a.constructor
if(typeof u=="function"){t=String(u).match(/^\s*function\s*([\w$]*)\s*\(/)
s=t==null?null:t[1]
if(typeof s==="string"&&/^\w+$/.test(s))w=s}if(w==null)w=v}else w=v}w=w
if(w.length>1&&C.d.aW(w,0)===36)w=C.d.cS(w,1)
return function(b,c){return b.replace(/[^<,> ]+/g,function(d){return c[d]||d})}(w+H.dG(H.bt(a),0,null),init.mangledGlobalNames)},
bf:function(a){return"Instance of '"+H.cO(a)+"'"},
jC:[function(){return Date.now()},"$0","hX",0,0,19],
cL:function(){var z,y
if($.aW!=null)return
$.aW=1000
$.N=H.hX()
if(typeof window=="undefined")return
z=window
if(z==null)return
y=z.performance
if(y==null)return
if(typeof y.now!="function")return
$.aW=1e6
$.N=new H.fl(y)},
bS:function(a,b){if(a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string")throw H.d(H.F(a))
return a[b]},
cP:function(a,b,c){if(a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string")throw H.d(H.F(a))
a[b]=c},
u:function(a){throw H.d(H.F(a))},
c:function(a,b){if(a==null)J.aJ(a)
throw H.d(H.v(a,b))},
v:function(a,b){var z,y
if(typeof b!=="number"||Math.floor(b)!==b)return new P.a2(!0,b,"index",null)
z=J.aJ(a)
if(!(b<0)){if(typeof z!=="number")return H.u(z)
y=b>=z}else y=!0
if(y)return P.aP(b,a,"index",null,z)
return P.aX(b,"index",null)},
F:function(a){return new P.a2(!0,a,null,null)},
i7:function(a){if(typeof a!=="number"||Math.floor(a)!==a)throw H.d(H.F(a))
return a},
d:function(a){var z
if(a==null)a=new P.bR()
z=new Error()
z.dartException=a
if("defineProperty" in Object){Object.defineProperty(z,"message",{get:H.dM})
z.name=""}else z.toString=H.dM
return z},
dM:function(){return J.W(this.dartException)},
w:function(a){throw H.d(a)},
bx:function(a){throw H.d(new P.a3(a))},
x:function(a){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l
z=new H.iC(a)
if(a==null)return
if(a instanceof H.bF)return z.$1(a.a)
if(typeof a!=="object")return a
if("dartException" in a)return z.$1(a.dartException)
else if(!("message" in a))return a
y=a.message
if("number" in a&&typeof a.number=="number"){x=a.number
w=x&65535
if((C.c.bW(x,16)&8191)===10)switch(w){case 438:return z.$1(H.bJ(H.b(y)+" (Error "+w+")",null))
case 445:case 5007:v=H.b(y)+" (Error "+w+")"
return z.$1(new H.cJ(v,null))}}if(a instanceof TypeError){u=$.$get$d_()
t=$.$get$d0()
s=$.$get$d1()
r=$.$get$d2()
q=$.$get$d6()
p=$.$get$d7()
o=$.$get$d4()
$.$get$d3()
n=$.$get$d9()
m=$.$get$d8()
l=u.G(y)
if(l!=null)return z.$1(H.bJ(y,l))
else{l=t.G(y)
if(l!=null){l.method="call"
return z.$1(H.bJ(y,l))}else{l=s.G(y)
if(l==null){l=r.G(y)
if(l==null){l=q.G(y)
if(l==null){l=p.G(y)
if(l==null){l=o.G(y)
if(l==null){l=r.G(y)
if(l==null){l=n.G(y)
if(l==null){l=m.G(y)
v=l!=null}else v=!0}else v=!0}else v=!0}else v=!0}else v=!0}else v=!0}else v=!0
if(v)return z.$1(new H.cJ(y,l==null?null:l.method))}}return z.$1(new H.fL(typeof y==="string"?y:""))}if(a instanceof RangeError){if(typeof y==="string"&&y.indexOf("call stack")!==-1)return new P.cS()
y=function(b){try{return String(b)}catch(k){}return null}(a)
return z.$1(new P.a2(!1,null,null,typeof y==="string"?y.replace(/^RangeError:\s*/,""):y))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof y==="string"&&y==="too much recursion")return new P.cS()
return a},
H:function(a){var z
if(a instanceof H.bF)return a.b
if(a==null)return new H.dr(a,null)
z=a.$cachedTrace
if(z!=null)return z
return a.$cachedTrace=new H.dr(a,null)},
ix:function(a){if(a==null||typeof a!='object')return J.a1(a)
else return H.a9(a)},
ib:function(a,b){var z,y,x,w
z=a.length
for(y=0;y<z;y=w){x=y+1
w=x+1
b.m(0,a[y],a[x])}return b},
io:function(a,b,c,d,e,f,g){switch(c){case 0:return H.b0(b,new H.ip(a))
case 1:return H.b0(b,new H.iq(a,d))
case 2:return H.b0(b,new H.ir(a,d,e))
case 3:return H.b0(b,new H.is(a,d,e,f))
case 4:return H.b0(b,new H.it(a,d,e,f,g))}throw H.d(P.b9("Unsupported number of arguments for wrapped closure"))},
ao:function(a,b){var z
if(a==null)return
z=a.$identity
if(!!z)return z
z=function(c,d,e,f){return function(g,h,i,j){return f(c,e,d,g,h,i,j)}}(a,b,init.globalState.d,H.io)
a.$identity=z
return z},
e9:function(a,b,c,d,e,f){var z,y,x,w,v,u,t,s,r,q,p,o,n,m
z=b[0]
y=z.$callName
if(!!J.r(c).$isi){z.$reflectionInfo=c
x=H.fp(z).r}else x=c
w=d?Object.create(new H.fv().constructor.prototype):Object.create(new H.bC(null,null,null,null).constructor.prototype)
w.$initialize=w.constructor
if(d)v=function(){this.$initialize()}
else{u=$.R
$.R=J.ae(u,1)
u=new Function("a,b,c,d"+u,"this.$initialize(a,b,c,d"+u+")")
v=u}w.constructor=v
v.prototype=w
if(!d){t=e.length==1&&!0
s=H.cj(a,z,t)
s.$reflectionInfo=c}else{w.$static_name=f
s=z
t=!1}if(typeof x=="number")r=function(g,h){return function(){return g(h)}}(H.id,x)
else if(typeof x=="function")if(d)r=x
else{q=t?H.ci:H.bD
r=function(g,h){return function(){return g.apply({$receiver:h(this)},arguments)}}(x,q)}else throw H.d("Error in reflectionInfo.")
w.$signature=r
w[y]=s
for(u=b.length,p=1;p<u;++p){o=b[p]
n=o.$callName
if(n!=null){m=d?o:H.cj(a,o,t)
w[n]=m}}w["call*"]=s
w.$requiredArgCount=z.$requiredArgCount
w.$defaultValues=z.$defaultValues
return v},
e6:function(a,b,c,d){var z=H.bD
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,z)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,z)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,z)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,z)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,z)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,z)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,z)}},
cj:function(a,b,c){var z,y,x,w,v,u,t
if(c)return H.e8(a,b)
z=b.$stubName
y=b.length
x=a[z]
w=b==null?x==null:b===x
v=!w||y>=27
if(v)return H.e6(y,!w,z,b)
if(y===0){w=$.R
$.R=J.ae(w,1)
u="self"+H.b(w)
w="return function(){var "+u+" = this."
v=$.aw
if(v==null){v=H.b5("self")
$.aw=v}return new Function(w+H.b(v)+";return "+u+"."+H.b(z)+"();}")()}t="abcdefghijklmnopqrstuvwxyz".split("").splice(0,y).join(",")
w=$.R
$.R=J.ae(w,1)
t+=H.b(w)
w="return function("+t+"){return this."
v=$.aw
if(v==null){v=H.b5("self")
$.aw=v}return new Function(w+H.b(v)+"."+H.b(z)+"("+t+");}")()},
e7:function(a,b,c,d){var z,y
z=H.bD
y=H.ci
switch(b?-1:a){case 0:throw H.d(new H.fq("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,z,y)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,z,y)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,z,y)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,z,y)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,z,y)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,z,y)
default:return function(e,f,g,h){return function(){h=[g(this)]
Array.prototype.push.apply(h,arguments)
return e.apply(f(this),h)}}(d,z,y)}},
e8:function(a,b){var z,y,x,w,v,u,t,s
z=H.e5()
y=$.ch
if(y==null){y=H.b5("receiver")
$.ch=y}x=b.$stubName
w=b.length
v=a[x]
u=b==null?v==null:b===v
t=!u||w>=28
if(t)return H.e7(w,!u,x,b)
if(w===1){y="return function(){return this."+H.b(z)+"."+H.b(x)+"(this."+H.b(y)+");"
u=$.R
$.R=J.ae(u,1)
return new Function(y+H.b(u)+"}")()}s="abcdefghijklmnopqrstuvwxyz".split("").splice(0,w-1).join(",")
y="return function("+s+"){return this."+H.b(z)+"."+H.b(x)+"(this."+H.b(y)+", "+s+");"
u=$.R
$.R=J.ae(u,1)
return new Function(y+H.b(u)+"}")()},
c4:function(a,b,c,d,e,f){var z
b.fixed$length=Array
if(!!J.r(c).$isi){c.fixed$length=Array
z=c}else z=c
return H.e9(a,b,z,!!d,e,f)},
i9:function(a){var z=J.r(a)
return"$signature" in z?z.$signature():null},
ap:function(a,b){var z
if(a==null)return!1
z=H.i9(a)
return z==null?!1:H.dF(z,b)},
iB:function(a){throw H.d(new P.ed(a))},
bw:function(){return(Math.random()*0x100000000>>>0)+(Math.random()*0x100000000>>>0)*4294967296},
dD:function(a){return init.getIsolateTag(a)},
q:function(a,b){a.$ti=b
return a},
bt:function(a){if(a==null)return
return a.$ti},
dE:function(a,b){return H.c9(a["$as"+H.b(b)],H.bt(a))},
C:function(a,b,c){var z=H.dE(a,b)
return z==null?null:z[c]},
I:function(a,b){var z=H.bt(a)
return z==null?null:z[b]},
as:function(a,b){var z
if(a==null)return"dynamic"
if(typeof a==="object"&&a!==null&&a.constructor===Array)return a[0].builtin$cls+H.dG(a,1,b)
if(typeof a=="function")return a.builtin$cls
if(typeof a==="number"&&Math.floor(a)===a)return H.b(a)
if(typeof a.func!="undefined"){z=a.typedef
if(z!=null)return H.as(z,b)
return H.hV(a,b)}return"unknown-reified-type"},
hV:function(a,b){var z,y,x,w,v,u,t,s,r,q,p
z=!!a.v?"void":H.as(a.ret,b)
if("args" in a){y=a.args
for(x=y.length,w="",v="",u=0;u<x;++u,v=", "){t=y[u]
w=w+v+H.as(t,b)}}else{w=""
v=""}if("opt" in a){s=a.opt
w+=v+"["
for(x=s.length,v="",u=0;u<x;++u,v=", "){t=s[u]
w=w+v+H.as(t,b)}w+="]"}if("named" in a){r=a.named
w+=v+"{"
for(x=H.ia(r),q=x.length,v="",u=0;u<q;++u,v=", "){p=x[u]
w=w+v+H.as(r[p],b)+(" "+H.b(p))}w+="}"}return"("+w+") => "+z},
dG:function(a,b,c){var z,y,x,w,v,u
if(a==null)return""
z=new P.bU("")
for(y=b,x=!0,w=!0,v="";y<a.length;++y){if(x)x=!1
else z.q=v+", "
u=a[y]
if(u!=null)w=!1
v=z.q+=H.as(u,c)}return w?"":"<"+z.i(0)+">"},
c9:function(a,b){if(a==null)return b
a=a.apply(null,b)
if(a==null)return
if(typeof a==="object"&&a!==null&&a.constructor===Array)return a
if(typeof a=="function")return a.apply(null,b)
return b},
bo:function(a,b,c,d){var z,y
if(a==null)return!1
z=H.bt(a)
y=J.r(a)
if(y[b]==null)return!1
return H.dA(H.c9(y[d],z),c)},
dA:function(a,b){var z,y
if(a==null||b==null)return!0
z=a.length
for(y=0;y<z;++y)if(!H.J(a[y],b[y]))return!1
return!0},
dC:function(a,b,c){return a.apply(b,H.dE(b,c))},
J:function(a,b){var z,y,x,w,v,u
if(a===b)return!0
if(a==null||b==null)return!0
if(a.builtin$cls==="ff")return!0
if('func' in b)return H.dF(a,b)
if('func' in a)return b.builtin$cls==="ex"||b.builtin$cls==="a"
z=typeof a==="object"&&a!==null&&a.constructor===Array
y=z?a[0]:a
x=typeof b==="object"&&b!==null&&b.constructor===Array
w=x?b[0]:b
if(w!==y){v=H.as(w,null)
if(!('$is'+v in y.prototype))return!1
u=y.prototype["$as"+v]}else u=null
if(!z&&u==null||!x)return!0
z=z?a.slice(1):null
x=b.slice(1)
return H.dA(H.c9(u,z),x)},
dz:function(a,b,c){var z,y,x,w,v
z=b==null
if(z&&a==null)return!0
if(z)return c
if(a==null)return!1
y=a.length
x=b.length
if(c){if(y<x)return!1}else if(y!==x)return!1
for(w=0;w<x;++w){z=a[w]
v=b[w]
if(!(H.J(z,v)||H.J(v,z)))return!1}return!0},
i3:function(a,b){var z,y,x,w,v,u
if(b==null)return!0
if(a==null)return!1
z=Object.getOwnPropertyNames(b)
z.fixed$length=Array
y=z
for(z=y.length,x=0;x<z;++x){w=y[x]
if(!Object.hasOwnProperty.call(a,w))return!1
v=b[w]
u=a[w]
if(!(H.J(v,u)||H.J(u,v)))return!1}return!0},
dF:function(a,b){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l
if(!('func' in a))return!1
if("v" in a){if(!("v" in b)&&"ret" in b)return!1}else if(!("v" in b)){z=a.ret
y=b.ret
if(!(H.J(z,y)||H.J(y,z)))return!1}x=a.args
w=b.args
v=a.opt
u=b.opt
t=x!=null?x.length:0
s=w!=null?w.length:0
r=v!=null?v.length:0
q=u!=null?u.length:0
if(t>s)return!1
if(t+r<s+q)return!1
if(t===s){if(!H.dz(x,w,!1))return!1
if(!H.dz(v,u,!0))return!1}else{for(p=0;p<t;++p){o=x[p]
n=w[p]
if(!(H.J(o,n)||H.J(n,o)))return!1}for(m=p,l=0;m<s;++l,++m){o=v[l]
n=w[m]
if(!(H.J(o,n)||H.J(n,o)))return!1}for(m=0;m<q;++l,++m){o=v[l]
n=u[m]
if(!(H.J(o,n)||H.J(n,o)))return!1}}return H.i3(a.named,b.named)},
ka:function(a){var z=$.c5
return"Instance of "+(z==null?"<Unknown>":z.$1(a))},
k8:function(a){return H.a9(a)},
k7:function(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
iv:function(a){var z,y,x,w,v,u
z=$.c5.$1(a)
y=$.bp[z]
if(y!=null){Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}x=$.bu[z]
if(x!=null)return x
w=init.interceptorsByTag[z]
if(w==null){z=$.dy.$2(a,z)
if(z!=null){y=$.bp[z]
if(y!=null){Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}x=$.bu[z]
if(x!=null)return x
w=init.interceptorsByTag[z]}}if(w==null)return
x=w.prototype
v=z[0]
if(v==="!"){y=H.c7(x)
$.bp[z]=y
Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}if(v==="~"){$.bu[z]=x
return x}if(v==="-"){u=H.c7(x)
Object.defineProperty(Object.getPrototypeOf(a),init.dispatchPropertyName,{value:u,enumerable:false,writable:true,configurable:true})
return u.i}if(v==="+")return H.dI(a,x)
if(v==="*")throw H.d(new P.da(z))
if(init.leafTags[z]===true){u=H.c7(x)
Object.defineProperty(Object.getPrototypeOf(a),init.dispatchPropertyName,{value:u,enumerable:false,writable:true,configurable:true})
return u.i}else return H.dI(a,x)},
dI:function(a,b){var z=Object.getPrototypeOf(a)
Object.defineProperty(z,init.dispatchPropertyName,{value:J.bv(b,z,null,null),enumerable:false,writable:true,configurable:true})
return b},
c7:function(a){return J.bv(a,!1,null,!!a.$isM)},
iw:function(a,b,c){var z=b.prototype
if(init.leafTags[a]===true)return J.bv(z,!1,null,!!z.$isM)
else return J.bv(z,c,null,null)},
il:function(){if(!0===$.c6)return
$.c6=!0
H.im()},
im:function(){var z,y,x,w,v,u,t,s
$.bp=Object.create(null)
$.bu=Object.create(null)
H.ih()
z=init.interceptorsByTag
y=Object.getOwnPropertyNames(z)
if(typeof window!="undefined"){window
x=function(){}
for(w=0;w<y.length;++w){v=y[w]
u=$.dJ.$1(v)
if(u!=null){t=H.iw(v,z[v],u)
if(t!=null){Object.defineProperty(u,init.dispatchPropertyName,{value:t,enumerable:false,writable:true,configurable:true})
x.prototype=u}}}}for(w=0;w<y.length;++w){v=y[w]
if(/^[A-Za-z_]/.test(v)){s=z[v]
z["!"+v]=s
z["~"+v]=s
z["-"+v]=s
z["+"+v]=s
z["*"+v]=s}}},
ih:function(){var z,y,x,w,v,u,t
z=C.y()
z=H.an(C.v,H.an(C.A,H.an(C.l,H.an(C.l,H.an(C.z,H.an(C.w,H.an(C.x(C.m),z)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){y=dartNativeDispatchHooksTransformer
if(typeof y=="function")y=[y]
if(y.constructor==Array)for(x=0;x<y.length;++x){w=y[x]
if(typeof w=="function")z=w(z)||z}}v=z.getTag
u=z.getUnknownTag
t=z.prototypeForTag
$.c5=new H.ii(v)
$.dy=new H.ij(u)
$.dJ=new H.ik(t)},
an:function(a,b){return a(b)||b},
fo:{"^":"a;a,b,c,d,e,f,r,x",l:{
fp:function(a){var z,y,x
z=a.$reflectionInfo
if(z==null)return
z.fixed$length=Array
z=z
y=z[0]
x=z[1]
return new H.fo(a,z,(y&1)===1,y>>1,x>>1,(x&1)===1,z[2],null)}}},
fl:{"^":"e:1;a",
$0:function(){return C.f.dT(1000*this.a.now())}},
fK:{"^":"a;a,b,c,d,e,f",
G:function(a){var z,y,x
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
l:{
T:function(a){var z,y,x,w,v,u
a=a.replace(String({}),'$receiver$').replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
z=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(z==null)z=[]
y=z.indexOf("\\$arguments\\$")
x=z.indexOf("\\$argumentsExpr\\$")
w=z.indexOf("\\$expr\\$")
v=z.indexOf("\\$method\\$")
u=z.indexOf("\\$receiver\\$")
return new H.fK(a.replace(new RegExp('\\\\\\$arguments\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$argumentsExpr\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$expr\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$method\\\\\\$','g'),'((?:x|[^x])*)').replace(new RegExp('\\\\\\$receiver\\\\\\$','g'),'((?:x|[^x])*)'),y,x,w,v,u)},
bh:function(a){return function($expr$){var $argumentsExpr$='$arguments$'
try{$expr$.$method$($argumentsExpr$)}catch(z){return z.message}}(a)},
d5:function(a){return function($expr$){try{$expr$.$method$}catch(z){return z.message}}(a)}}},
cJ:{"^":"D;a,b",
i:function(a){var z=this.b
if(z==null)return"NullError: "+H.b(this.a)
return"NullError: method not found: '"+H.b(z)+"' on null"}},
f1:{"^":"D;a,b,c",
i:function(a){var z,y
z=this.b
if(z==null)return"NoSuchMethodError: "+H.b(this.a)
y=this.c
if(y==null)return"NoSuchMethodError: method not found: '"+z+"' ("+H.b(this.a)+")"
return"NoSuchMethodError: method not found: '"+z+"' on '"+y+"' ("+H.b(this.a)+")"},
l:{
bJ:function(a,b){var z,y
z=b==null
y=z?null:b.method
return new H.f1(a,y,z?null:b.receiver)}}},
fL:{"^":"D;a",
i:function(a){var z=this.a
return z.length===0?"Error":"Error: "+z}},
bF:{"^":"a;a,M:b<"},
iC:{"^":"e:0;a",
$1:function(a){if(!!J.r(a).$isD)if(a.$thrownJsError==null)a.$thrownJsError=this.a
return a}},
dr:{"^":"a;a,b",
i:function(a){var z,y
z=this.b
if(z!=null)return z
z=this.a
y=z!==null&&typeof z==="object"?z.stack:null
z=y==null?"":y
this.b=z
return z}},
ip:{"^":"e:1;a",
$0:function(){return this.a.$0()}},
iq:{"^":"e:1;a,b",
$0:function(){return this.a.$1(this.b)}},
ir:{"^":"e:1;a,b,c",
$0:function(){return this.a.$2(this.b,this.c)}},
is:{"^":"e:1;a,b,c,d",
$0:function(){return this.a.$3(this.b,this.c,this.d)}},
it:{"^":"e:1;a,b,c,d,e",
$0:function(){return this.a.$4(this.b,this.c,this.d,this.e)}},
e:{"^":"a;",
i:function(a){return"Closure '"+H.cO(this).trim()+"'"},
gct:function(){return this},
gct:function(){return this}},
cV:{"^":"e;"},
fv:{"^":"cV;",
i:function(a){var z=this.$static_name
if(z==null)return"Closure of unknown static method"
return"Closure '"+z+"'"}},
bC:{"^":"cV;a,b,c,d",
p:function(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof H.bC))return!1
return this.a===b.a&&this.b===b.b&&this.c===b.c},
gu:function(a){var z,y
z=this.c
if(z==null)y=H.a9(this.a)
else y=typeof z!=="object"?J.a1(z):H.a9(z)
z=H.a9(this.b)
if(typeof y!=="number")return y.ez()
return(y^z)>>>0},
i:function(a){var z=this.c
if(z==null)z=this.a
return"Closure '"+H.b(this.d)+"' of "+H.bf(z)},
l:{
bD:function(a){return a.a},
ci:function(a){return a.c},
e5:function(){var z=$.aw
if(z==null){z=H.b5("self")
$.aw=z}return z},
b5:function(a){var z,y,x,w,v
z=new H.bC("self","target","receiver","name")
y=Object.getOwnPropertyNames(z)
y.fixed$length=Array
x=y
for(y=x.length,w=0;w<y;++w){v=x[w]
if(z[v]===a)return v}}}},
fq:{"^":"D;a",
i:function(a){return"RuntimeError: "+H.b(this.a)}},
ah:{"^":"a;a,b,c,d,e,f,r,$ti",
gj:function(a){return this.a},
gE:function(a){return this.a===0},
ga8:function(){return new H.f5(this,[H.I(this,0)])},
gcr:function(a){return H.bd(this.ga8(),new H.f0(this),H.I(this,0),H.I(this,1))},
ag:function(a){var z,y
if(typeof a==="string"){z=this.b
if(z==null)return!1
return this.bD(z,a)}else if(typeof a==="number"&&(a&0x3ffffff)===a){y=this.c
if(y==null)return!1
return this.bD(y,a)}else return this.e2(a)},
e2:function(a){var z=this.d
if(z==null)return!1
return this.ak(this.aw(z,this.aj(a)),a)>=0},
h:function(a,b){var z,y,x
if(typeof b==="string"){z=this.b
if(z==null)return
y=this.ac(z,b)
return y==null?null:y.ga_()}else if(typeof b==="number"&&(b&0x3ffffff)===b){x=this.c
if(x==null)return
y=this.ac(x,b)
return y==null?null:y.ga_()}else return this.e3(b)},
e3:function(a){var z,y,x
z=this.d
if(z==null)return
y=this.aw(z,this.aj(a))
x=this.ak(y,a)
if(x<0)return
return y[x].ga_()},
m:function(a,b,c){var z,y,x,w,v,u
if(typeof b==="string"){z=this.b
if(z==null){z=this.b1()
this.b=z}this.bw(z,b,c)}else if(typeof b==="number"&&(b&0x3ffffff)===b){y=this.c
if(y==null){y=this.b1()
this.c=y}this.bw(y,b,c)}else{x=this.d
if(x==null){x=this.b1()
this.d=x}w=this.aj(b)
v=this.aw(x,w)
if(v==null)this.b4(x,w,[this.b2(b,c)])
else{u=this.ak(v,b)
if(u>=0)v[u].sa_(c)
else v.push(this.b2(b,c))}}},
am:function(a,b){if(typeof b==="string")return this.bR(this.b,b)
else if(typeof b==="number"&&(b&0x3ffffff)===b)return this.bR(this.c,b)
else return this.e4(b)},
e4:function(a){var z,y,x,w
z=this.d
if(z==null)return
y=this.aw(z,this.aj(a))
x=this.ak(y,a)
if(x<0)return
w=y.splice(x,1)[0]
this.bZ(w)
return w.ga_()},
a7:function(a){if(this.a>0){this.f=null
this.e=null
this.d=null
this.c=null
this.b=null
this.a=0
this.r=this.r+1&67108863}},
b9:function(a,b){var z,y
z=this.e
y=this.r
for(;z!=null;){b.$2(z.a,z.b)
if(y!==this.r)throw H.d(new P.a3(this))
z=z.c}},
bw:function(a,b,c){var z=this.ac(a,b)
if(z==null)this.b4(a,b,this.b2(b,c))
else z.sa_(c)},
bR:function(a,b){var z
if(a==null)return
z=this.ac(a,b)
if(z==null)return
this.bZ(z)
this.bE(a,b)
return z.ga_()},
b2:function(a,b){var z,y
z=new H.f4(a,b,null,null)
if(this.e==null){this.f=z
this.e=z}else{y=this.f
z.d=y
y.c=z
this.f=z}++this.a
this.r=this.r+1&67108863
return z},
bZ:function(a){var z,y
z=a.gdm()
y=a.c
if(z==null)this.e=y
else z.c=y
if(y==null)this.f=z
else y.d=z;--this.a
this.r=this.r+1&67108863},
aj:function(a){return J.a1(a)&0x3ffffff},
ak:function(a,b){var z,y
if(a==null)return-1
z=a.length
for(y=0;y<z;++y)if(J.V(a[y].gcc(),b))return y
return-1},
i:function(a){return P.cD(this)},
ac:function(a,b){return a[b]},
aw:function(a,b){return a[b]},
b4:function(a,b,c){a[b]=c},
bE:function(a,b){delete a[b]},
bD:function(a,b){return this.ac(a,b)!=null},
b1:function(){var z=Object.create(null)
this.b4(z,"<non-identifier-key>",z)
this.bE(z,"<non-identifier-key>")
return z},
$iseK:1},
f0:{"^":"e:0;a",
$1:function(a){return this.a.h(0,a)}},
f4:{"^":"a;cc:a<,a_:b@,c,dm:d<"},
f5:{"^":"h;a,$ti",
gj:function(a){return this.a.a},
gv:function(a){var z,y
z=this.a
y=new H.f6(z,z.r,null,null)
y.c=z.e
return y}},
f6:{"^":"a;a,b,c,d",
gn:function(){return this.d},
k:function(){var z=this.a
if(this.b!==z.r)throw H.d(new P.a3(z))
else{z=this.c
if(z==null){this.d=null
return!1}else{this.d=z.a
this.c=z.c
return!0}}}},
ii:{"^":"e:0;a",
$1:function(a){return this.a(a)}},
ij:{"^":"e:7;a",
$2:function(a,b){return this.a(a,b)}},
ik:{"^":"e:8;a",
$1:function(a){return this.a(a)}}}],["","",,H,{"^":"",
ia:function(a){var z=H.q(a?Object.keys(a):[],[null])
z.fixed$length=Array
return z}}],["","",,H,{"^":"",
iy:function(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof window=="object")return
if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)}}],["","",,H,{"^":"",cE:{"^":"f;",$iscE:1,"%":"ArrayBuffer"},bQ:{"^":"f;",$isbQ:1,"%":"DataView;ArrayBufferView;bO|cF|cH|bP|cG|cI|a7"},bO:{"^":"bQ;",
gj:function(a){return a.length},
$isM:1,
$asM:I.B,
$isE:1,
$asE:I.B},bP:{"^":"cH;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
m:function(a,b,c){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
a[b]=c}},cF:{"^":"bO+ay;",$asM:I.B,$asE:I.B,
$asi:function(){return[P.ad]},
$ash:function(){return[P.ad]},
$isi:1,
$ish:1},cH:{"^":"cF+cs;",$asM:I.B,$asE:I.B,
$asi:function(){return[P.ad]},
$ash:function(){return[P.ad]}},a7:{"^":"cI;",
m:function(a,b,c){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
a[b]=c},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]}},cG:{"^":"bO+ay;",$asM:I.B,$asE:I.B,
$asi:function(){return[P.l]},
$ash:function(){return[P.l]},
$isi:1,
$ish:1},cI:{"^":"cG+cs;",$asM:I.B,$asE:I.B,
$asi:function(){return[P.l]},
$ash:function(){return[P.l]}},jn:{"^":"bP;",$isi:1,
$asi:function(){return[P.ad]},
$ish:1,
$ash:function(){return[P.ad]},
"%":"Float32Array"},jo:{"^":"bP;",$isi:1,
$asi:function(){return[P.ad]},
$ish:1,
$ash:function(){return[P.ad]},
"%":"Float64Array"},jp:{"^":"a7;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]},
"%":"Int16Array"},jq:{"^":"a7;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]},
"%":"Int32Array"},jr:{"^":"a7;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]},
"%":"Int8Array"},js:{"^":"a7;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]},
"%":"Uint16Array"},jt:{"^":"a7;",
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]},
"%":"Uint32Array"},ju:{"^":"a7;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]},
"%":"CanvasPixelArray|Uint8ClampedArray"},jv:{"^":"a7;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)H.w(H.v(a,b))
return a[b]},
$isi:1,
$asi:function(){return[P.l]},
$ish:1,
$ash:function(){return[P.l]},
"%":";Uint8Array"}}],["","",,P,{"^":"",
fO:function(){var z,y,x
z={}
if(self.scheduleImmediate!=null)return P.i4()
if(self.MutationObserver!=null&&self.document!=null){y=self.document.createElement("div")
x=self.document.createElement("span")
z.a=null
new self.MutationObserver(H.ao(new P.fQ(z),1)).observe(y,{childList:true})
return new P.fP(z,y,x)}else if(self.setImmediate!=null)return P.i5()
return P.i6()},
jR:[function(a){++init.globalState.f.b
self.scheduleImmediate(H.ao(new P.fR(a),0))},"$1","i4",2,0,3],
jS:[function(a){++init.globalState.f.b
self.setImmediate(H.ao(new P.fS(a),0))},"$1","i5",2,0,3],
jT:[function(a){P.bV(C.k,a)},"$1","i6",2,0,3],
A:function(a,b,c){if(b===0){J.dP(c,a)
return}else if(b===1){c.c9(H.x(a),H.H(a))
return}P.hR(a,b)
return c.gdU()},
hR:function(a,b){var z,y,x,w
z=new P.hS(b)
y=new P.hT(b)
x=J.r(a)
if(!!x.$isP)a.b5(z,y)
else if(!!x.$isK)a.bk(z,y)
else{w=new P.P(0,$.k,null,[null])
w.a=4
w.c=a
w.b5(z,null)}},
bn:function(a){var z=function(b,c){return function(d,e){while(true)try{b(d,e)
break}catch(y){e=y
d=c}}}(a,1)
$.k.toString
return new P.i1(z)},
dt:function(a,b){if(H.ap(a,{func:1,args:[,,]})){b.toString
return a}else{b.toString
return a}},
b6:function(a){return new P.hL(new P.P(0,$.k,null,[a]),[a])},
hY:function(){var z,y
for(;z=$.al,z!=null;){$.aF=null
y=z.b
$.al=y
if(y==null)$.aE=null
z.a.$0()}},
k6:[function(){$.c1=!0
try{P.hY()}finally{$.aF=null
$.c1=!1
if($.al!=null)$.$get$bW().$1(P.dB())}},"$0","dB",0,0,2],
dx:function(a){var z=new P.dc(a,null)
if($.al==null){$.aE=z
$.al=z
if(!$.c1)$.$get$bW().$1(P.dB())}else{$.aE.b=z
$.aE=z}},
i0:function(a){var z,y,x
z=$.al
if(z==null){P.dx(a)
$.aF=$.aE
return}y=new P.dc(a,null)
x=$.aF
if(x==null){y.b=z
$.aF=y
$.al=y}else{y.b=x.b
x.b=y
$.aF=y
if(y.b==null)$.aE=y}},
dK:function(a){var z=$.k
if(C.b===z){P.am(null,null,C.b,a)
return}z.toString
P.am(null,null,z,z.b8(a,!0))},
jH:function(a,b){return new P.hJ(null,a,!1,[b])},
hQ:function(a,b,c){$.k.toString
a.aQ(b,c)},
fI:function(a,b){var z=$.k
if(z===C.b){z.toString
return P.bV(a,b)}return P.bV(a,z.b8(b,!0))},
fJ:function(a,b){var z,y
z=$.k
if(z===C.b){z.toString
return P.cZ(a,b)}y=z.c3(b,!0)
$.k.toString
return P.cZ(a,y)},
bV:function(a,b){var z=C.c.a5(a.a,1000)
return H.fD(z<0?0:z,b)},
cZ:function(a,b){var z=C.c.a5(a.a,1000)
return H.fE(z<0?0:z,b)},
b1:function(a,b,c,d,e){var z={}
z.a=d
P.i0(new P.i_(z,e))},
du:function(a,b,c,d){var z,y
y=$.k
if(y===c)return d.$0()
$.k=c
z=y
try{y=d.$0()
return y}finally{$.k=z}},
dw:function(a,b,c,d,e){var z,y
y=$.k
if(y===c)return d.$1(e)
$.k=c
z=y
try{y=d.$1(e)
return y}finally{$.k=z}},
dv:function(a,b,c,d,e,f){var z,y
y=$.k
if(y===c)return d.$2(e,f)
$.k=c
z=y
try{y=d.$2(e,f)
return y}finally{$.k=z}},
am:function(a,b,c,d){var z=C.b!==c
if(z)d=c.b8(d,!(!z||!1))
P.dx(d)},
fQ:{"^":"e:0;a",
$1:function(a){var z,y;--init.globalState.f.b
z=this.a
y=z.a
z.a=null
y.$0()}},
fP:{"^":"e:9;a,b,c",
$1:function(a){var z,y;++init.globalState.f.b
this.a.a=a
z=this.b
y=this.c
z.firstChild?z.removeChild(y):z.appendChild(y)}},
fR:{"^":"e:1;a",
$0:function(){--init.globalState.f.b
this.a.$0()}},
fS:{"^":"e:1;a",
$0:function(){--init.globalState.f.b
this.a.$0()}},
hS:{"^":"e:0;a",
$1:function(a){return this.a.$2(0,a)}},
hT:{"^":"e:10;a",
$2:function(a,b){this.a.$2(1,new H.bF(a,b))}},
i1:{"^":"e:11;a",
$2:function(a,b){this.a(a,b)}},
K:{"^":"a;$ti"},
de:{"^":"a;dU:a<,$ti",
c9:[function(a,b){if(a==null)a=new P.bR()
if(this.a.a!==0)throw H.d(new P.Y("Future already completed"))
$.k.toString
this.O(a,b)},function(a){return this.c9(a,null)},"dG","$2","$1","gdF",2,2,4,0]},
fN:{"^":"de;a,$ti",
aB:function(a,b){var z=this.a
if(z.a!==0)throw H.d(new P.Y("Future already completed"))
z.by(b)},
O:function(a,b){this.a.d8(a,b)}},
hL:{"^":"de;a,$ti",
aB:function(a,b){var z=this.a
if(z.a!==0)throw H.d(new P.Y("Future already completed"))
z.as(b)},
O:function(a,b){this.a.O(a,b)}},
di:{"^":"a;b3:a<,b,c,d,e",
gdz:function(){return this.b.b},
gcb:function(){return(this.c&1)!==0},
ge0:function(){return(this.c&2)!==0},
gca:function(){return this.c===8},
dZ:function(a){return this.b.b.bh(this.d,a)},
ed:function(a){if(this.c!==6)return!0
return this.b.b.bh(this.d,J.aH(a))},
dV:function(a){var z,y,x
z=this.e
y=J.m(a)
x=this.b.b
if(H.ap(z,{func:1,args:[,,]}))return x.eq(z,y.gZ(a),a.gM())
else return x.bh(z,y.gZ(a))},
e_:function(){return this.b.b.cm(this.d)}},
P:{"^":"a;ae:a<,b,ds:c<,$ti",
gdk:function(){return this.a===2},
gb0:function(){return this.a>=4},
bk:function(a,b){var z=$.k
if(z!==C.b){z.toString
if(b!=null)b=P.dt(b,z)}return this.b5(a,b)},
bj:function(a){return this.bk(a,null)},
b5:function(a,b){var z=new P.P(0,$.k,null,[null])
this.aR(new P.di(null,z,b==null?1:3,a,b))
return z},
cs:function(a){var z,y
z=$.k
y=new P.P(0,z,null,this.$ti)
if(z!==C.b)z.toString
this.aR(new P.di(null,y,8,a,null))
return y},
aR:function(a){var z,y
z=this.a
if(z<=1){a.a=this.c
this.c=a}else{if(z===2){y=this.c
if(!y.gb0()){y.aR(a)
return}this.a=y.a
this.c=y.c}z=this.b
z.toString
P.am(null,null,z,new P.hb(this,a))}},
bQ:function(a){var z,y,x,w,v
z={}
z.a=a
if(a==null)return
y=this.a
if(y<=1){x=this.c
this.c=a
if(x!=null){for(w=a;w.gb3()!=null;)w=w.a
w.a=x}}else{if(y===2){v=this.c
if(!v.gb0()){v.bQ(a)
return}this.a=v.a
this.c=v.c}z.a=this.az(a)
y=this.b
y.toString
P.am(null,null,y,new P.hi(z,this))}},
ay:function(){var z=this.c
this.c=null
return this.az(z)},
az:function(a){var z,y,x
for(z=a,y=null;z!=null;y=z,z=x){x=z.gb3()
z.a=y}return y},
as:function(a){var z,y
z=this.$ti
if(H.bo(a,"$isK",z,"$asK"))if(H.bo(a,"$isP",z,null))P.bk(a,this)
else P.dj(a,this)
else{y=this.ay()
this.a=4
this.c=a
P.aj(this,y)}},
O:[function(a,b){var z=this.ay()
this.a=8
this.c=new P.b4(a,b)
P.aj(this,z)},function(a){return this.O(a,null)},"eA","$2","$1","gbC",2,2,4,0],
by:function(a){var z=this.$ti
if(H.bo(a,"$isK",z,"$asK")){if(H.bo(a,"$isP",z,null))if(a.gae()===8){this.a=1
z=this.b
z.toString
P.am(null,null,z,new P.hd(this,a))}else P.bk(a,this)
else P.dj(a,this)
return}this.a=1
z=this.b
z.toString
P.am(null,null,z,new P.he(this,a))},
d8:function(a,b){var z
this.a=1
z=this.b
z.toString
P.am(null,null,z,new P.hc(this,a,b))},
$isK:1,
l:{
ha:function(a,b){var z=new P.P(0,$.k,null,[b])
z.by(a)
return z},
dj:function(a,b){var z,y,x,w
b.a=1
try{a.bk(new P.hf(b),new P.hg(b))}catch(x){w=H.x(x)
z=w
y=H.H(x)
P.dK(new P.hh(b,z,y))}},
bk:function(a,b){var z,y,x
for(;a.gdk();)a=a.c
z=a.gb0()
y=b.c
if(z){b.c=null
x=b.az(y)
b.a=a.a
b.c=a.c
P.aj(b,x)}else{b.a=2
b.c=a
a.bQ(y)}},
aj:function(a,b){var z,y,x,w,v,u,t,s,r,q,p,o
z={}
z.a=a
for(y=a;!0;){x={}
w=y.a===8
if(b==null){if(w){v=y.c
z=y.b
y=J.aH(v)
x=v.gM()
z.toString
P.b1(null,null,z,y,x)}return}for(;b.gb3()!=null;b=u){u=b.a
b.a=null
P.aj(z.a,b)}t=z.a.c
x.a=w
x.b=t
y=!w
if(!y||b.gcb()||b.gca()){s=b.gdz()
if(w){r=z.a.b
r.toString
r=r==null?s==null:r===s
if(!r)s.toString
else r=!0
r=!r}else r=!1
if(r){y=z.a
v=y.c
y=y.b
x=J.aH(v)
r=v.gM()
y.toString
P.b1(null,null,y,x,r)
return}q=$.k
if(q==null?s!=null:q!==s)$.k=s
else q=null
if(b.gca())new P.hl(z,x,w,b).$0()
else if(y){if(b.gcb())new P.hk(x,b,t).$0()}else if(b.ge0())new P.hj(z,x,b).$0()
if(q!=null)$.k=q
y=x.b
if(!!J.r(y).$isK){p=b.b
if(y.a>=4){o=p.c
p.c=null
b=p.az(o)
p.a=y.a
p.c=y.c
z.a=y
continue}else P.bk(y,p)
return}}p=b.b
b=p.ay()
y=x.a
x=x.b
if(!y){p.a=4
p.c=x}else{p.a=8
p.c=x}z.a=p
y=p}}}},
hb:{"^":"e:1;a,b",
$0:function(){P.aj(this.a,this.b)}},
hi:{"^":"e:1;a,b",
$0:function(){P.aj(this.b,this.a.a)}},
hf:{"^":"e:0;a",
$1:function(a){var z=this.a
z.a=0
z.as(a)}},
hg:{"^":"e:12;a",
$2:function(a,b){this.a.O(a,b)},
$1:function(a){return this.$2(a,null)}},
hh:{"^":"e:1;a,b,c",
$0:function(){this.a.O(this.b,this.c)}},
hd:{"^":"e:1;a,b",
$0:function(){P.bk(this.b,this.a)}},
he:{"^":"e:1;a,b",
$0:function(){var z,y
z=this.a
y=z.ay()
z.a=4
z.c=this.b
P.aj(z,y)}},
hc:{"^":"e:1;a,b,c",
$0:function(){this.a.O(this.b,this.c)}},
hl:{"^":"e:2;a,b,c,d",
$0:function(){var z,y,x,w,v,u,t
z=null
try{z=this.d.e_()}catch(w){v=H.x(w)
y=v
x=H.H(w)
if(this.c){v=J.aH(this.a.a.c)
u=y
u=v==null?u==null:v===u
v=u}else v=!1
u=this.b
if(v)u.b=this.a.a.c
else u.b=new P.b4(y,x)
u.a=!0
return}if(!!J.r(z).$isK){if(z instanceof P.P&&z.gae()>=4){if(z.gae()===8){v=this.b
v.b=z.gds()
v.a=!0}return}t=this.a.a
v=this.b
v.b=z.bj(new P.hm(t))
v.a=!1}}},
hm:{"^":"e:0;a",
$1:function(a){return this.a}},
hk:{"^":"e:2;a,b,c",
$0:function(){var z,y,x,w
try{this.a.b=this.b.dZ(this.c)}catch(x){w=H.x(x)
z=w
y=H.H(x)
w=this.a
w.b=new P.b4(z,y)
w.a=!0}}},
hj:{"^":"e:2;a,b,c",
$0:function(){var z,y,x,w,v,u,t,s
try{z=this.a.a.c
w=this.c
if(w.ed(z)===!0&&w.e!=null){v=this.b
v.b=w.dV(z)
v.a=!1}}catch(u){w=H.x(u)
y=w
x=H.H(u)
w=this.a
v=J.aH(w.a.c)
t=y
s=this.b
if(v==null?t==null:v===t)s.b=w.a.c
else s.b=new P.b4(y,x)
s.a=!0}}},
dc:{"^":"a;a,b"},
aC:{"^":"a;$ti",
a0:function(a,b){return new P.hy(b,this,[H.C(this,"aC",0),null])},
gj:function(a){var z,y
z={}
y=new P.P(0,$.k,null,[P.l])
z.a=0
this.al(new P.fx(z),!0,new P.fy(z,y),y.gbC())
return y},
bl:function(a){var z,y,x
z=H.C(this,"aC",0)
y=H.q([],[z])
x=new P.P(0,$.k,null,[[P.i,z]])
this.al(new P.fz(this,y),!0,new P.fA(y,x),x.gbC())
return x}},
fx:{"^":"e:0;a",
$1:function(a){++this.a.a}},
fy:{"^":"e:1;a,b",
$0:function(){this.b.as(this.a.a)}},
fz:{"^":"e;a,b",
$1:function(a){this.b.push(a)},
$signature:function(){return H.dC(function(a){return{func:1,args:[a]}},this.a,"aC")}},
fA:{"^":"e:1;a,b",
$0:function(){this.b.as(this.a)}},
fw:{"^":"a;$ti"},
jY:{"^":"a;"},
bi:{"^":"a;ae:e<,$ti",
bf:function(a,b){var z=this.e
if((z&8)!==0)return
this.e=(z+128|4)>>>0
if(z<128&&this.r!=null)this.r.c4()
if((z&4)===0&&(this.e&32)===0)this.bH(this.gbM())},
ci:function(a){return this.bf(a,null)},
cl:function(){var z=this.e
if((z&8)!==0)return
if(z>=128){z-=128
this.e=z
if(z<128){if((z&64)!==0){z=this.r
z=!z.gE(z)}else z=!1
if(z)this.r.aM(this)
else{z=(this.e&4294967291)>>>0
this.e=z
if((z&32)===0)this.bH(this.gbO())}}}},
af:function(){var z=(this.e&4294967279)>>>0
this.e=z
if((z&8)===0)this.aU()
z=this.f
return z==null?$.$get$ba():z},
aU:function(){var z=(this.e|8)>>>0
this.e=z
if((z&64)!==0)this.r.c4()
if((this.e&32)===0)this.r=null
this.f=this.bL()},
aT:["cW",function(a){var z=this.e
if((z&8)!==0)return
if(z<32)this.bT(a)
else this.aS(new P.h_(a,null,[H.C(this,"bi",0)]))}],
aQ:["cX",function(a,b){var z=this.e
if((z&8)!==0)return
if(z<32)this.bV(a,b)
else this.aS(new P.h1(a,b,null))}],
d7:function(){var z=this.e
if((z&8)!==0)return
z=(z|2)>>>0
this.e=z
if(z<32)this.bU()
else this.aS(C.r)},
bN:[function(){},"$0","gbM",0,0,2],
bP:[function(){},"$0","gbO",0,0,2],
bL:function(){return},
aS:function(a){var z,y
z=this.r
if(z==null){z=new P.hI(null,null,0,[H.C(this,"bi",0)])
this.r=z}z.P(0,a)
y=this.e
if((y&64)===0){y=(y|64)>>>0
this.e=y
if(y<128)this.r.aM(this)}},
bT:function(a){var z=this.e
this.e=(z|32)>>>0
this.d.bi(this.a,a)
this.e=(this.e&4294967263)>>>0
this.aV((z&4)!==0)},
bV:function(a,b){var z,y
z=this.e
y=new P.fV(this,a,b)
if((z&1)!==0){this.e=(z|16)>>>0
this.aU()
z=this.f
if(!!J.r(z).$isK&&z!==$.$get$ba())z.cs(y)
else y.$0()}else{y.$0()
this.aV((z&4)!==0)}},
bU:function(){var z,y
z=new P.fU(this)
this.aU()
this.e=(this.e|16)>>>0
y=this.f
if(!!J.r(y).$isK&&y!==$.$get$ba())y.cs(z)
else z.$0()},
bH:function(a){var z=this.e
this.e=(z|32)>>>0
a.$0()
this.e=(this.e&4294967263)>>>0
this.aV((z&4)!==0)},
aV:function(a){var z,y
if((this.e&64)!==0){z=this.r
z=z.gE(z)}else z=!1
if(z){z=(this.e&4294967231)>>>0
this.e=z
if((z&4)!==0)if(z<128){z=this.r
z=z==null||z.gE(z)}else z=!1
else z=!1
if(z)this.e=(this.e&4294967291)>>>0}for(;!0;a=y){z=this.e
if((z&8)!==0){this.r=null
return}y=(z&4)!==0
if(a===y)break
this.e=(z^32)>>>0
if(y)this.bN()
else this.bP()
this.e=(this.e&4294967263)>>>0}z=this.e
if((z&64)!==0&&z<128)this.r.aM(this)},
d0:function(a,b,c,d,e){var z=this.d
z.toString
this.a=a
this.b=P.dt(b,z)
this.c=c}},
fV:{"^":"e:2;a,b,c",
$0:function(){var z,y,x,w,v,u
z=this.a
y=z.e
if((y&8)!==0&&(y&16)===0)return
z.e=(y|32)>>>0
y=z.b
x=H.ap(y,{func:1,args:[P.a,P.ai]})
w=z.d
v=this.b
u=z.b
if(x)w.er(u,v,this.c)
else w.bi(u,v)
z.e=(z.e&4294967263)>>>0}},
fU:{"^":"e:2;a",
$0:function(){var z,y
z=this.a
y=z.e
if((y&16)===0)return
z.e=(y|42)>>>0
z.d.cn(z.c)
z.e=(z.e&4294967263)>>>0}},
df:{"^":"a;aE:a@"},
h_:{"^":"df;b,a,$ti",
bg:function(a){a.bT(this.b)}},
h1:{"^":"df;Z:b>,M:c<,a",
bg:function(a){a.bV(this.b,this.c)}},
h0:{"^":"a;",
bg:function(a){a.bU()},
gaE:function(){return},
saE:function(a){throw H.d(new P.Y("No events after a done."))}},
hA:{"^":"a;ae:a<",
aM:function(a){var z=this.a
if(z===1)return
if(z>=1){this.a=1
return}P.dK(new P.hB(this,a))
this.a=1},
c4:function(){if(this.a===1)this.a=3}},
hB:{"^":"e:1;a,b",
$0:function(){var z,y,x,w
z=this.a
y=z.a
z.a=0
if(y===3)return
x=z.b
w=x.gaE()
z.b=w
if(w==null)z.c=null
x.bg(this.b)}},
hI:{"^":"hA;b,c,a,$ti",
gE:function(a){return this.c==null},
P:function(a,b){var z=this.c
if(z==null){this.c=b
this.b=b}else{z.saE(b)
this.c=b}}},
hJ:{"^":"a;a,b,c,$ti"},
bX:{"^":"aC;$ti",
al:function(a,b,c,d){return this.de(a,d,c,!0===b)},
ce:function(a,b,c){return this.al(a,null,b,c)},
de:function(a,b,c,d){return P.h9(this,a,b,c,d,H.C(this,"bX",0),H.C(this,"bX",1))},
bI:function(a,b){b.aT(a)},
di:function(a,b,c){c.aQ(a,b)},
$asaC:function(a,b){return[b]}},
dh:{"^":"bi;x,y,a,b,c,d,e,f,r,$ti",
aT:function(a){if((this.e&2)!==0)return
this.cW(a)},
aQ:function(a,b){if((this.e&2)!==0)return
this.cX(a,b)},
bN:[function(){var z=this.y
if(z==null)return
z.ci(0)},"$0","gbM",0,0,2],
bP:[function(){var z=this.y
if(z==null)return
z.cl()},"$0","gbO",0,0,2],
bL:function(){var z=this.y
if(z!=null){this.y=null
return z.af()}return},
eB:[function(a){this.x.bI(a,this)},"$1","gdf",2,0,function(){return H.dC(function(a,b){return{func:1,v:true,args:[a]}},this.$receiver,"dh")}],
eD:[function(a,b){this.x.di(a,b,this)},"$2","gdh",4,0,13],
eC:[function(){this.d7()},"$0","gdg",0,0,2],
d3:function(a,b,c,d,e,f,g){this.y=this.x.a.ce(this.gdf(),this.gdg(),this.gdh())},
$asbi:function(a,b){return[b]},
l:{
h9:function(a,b,c,d,e,f,g){var z,y
z=$.k
y=e?1:0
y=new P.dh(a,null,null,null,null,z,y,null,null,[f,g])
y.d0(b,c,d,e,g)
y.d3(a,b,c,d,e,f,g)
return y}}},
hy:{"^":"bX;b,a,$ti",
bI:function(a,b){var z,y,x,w,v
z=null
try{z=this.b.$1(a)}catch(w){v=H.x(w)
y=v
x=H.H(w)
P.hQ(b,y,x)
return}b.aT(z)}},
cX:{"^":"a;"},
b4:{"^":"a;Z:a>,M:b<",
i:function(a){return H.b(this.a)},
$isD:1},
hP:{"^":"a;"},
i_:{"^":"e:1;a,b",
$0:function(){var z,y,x
z=this.a
y=z.a
if(y==null){x=new P.bR()
z.a=x
z=x}else z=y
y=this.b
if(y==null)throw H.d(z)
x=H.d(z)
x.stack=J.W(y)
throw x}},
hC:{"^":"hP;",
cn:function(a){var z,y,x,w
try{if(C.b===$.k){x=a.$0()
return x}x=P.du(null,null,this,a)
return x}catch(w){x=H.x(w)
z=x
y=H.H(w)
return P.b1(null,null,this,z,y)}},
bi:function(a,b){var z,y,x,w
try{if(C.b===$.k){x=a.$1(b)
return x}x=P.dw(null,null,this,a,b)
return x}catch(w){x=H.x(w)
z=x
y=H.H(w)
return P.b1(null,null,this,z,y)}},
er:function(a,b,c){var z,y,x,w
try{if(C.b===$.k){x=a.$2(b,c)
return x}x=P.dv(null,null,this,a,b,c)
return x}catch(w){x=H.x(w)
z=x
y=H.H(w)
return P.b1(null,null,this,z,y)}},
b8:function(a,b){if(b)return new P.hD(this,a)
else return new P.hE(this,a)},
c3:function(a,b){return new P.hF(this,a)},
h:function(a,b){return},
cm:function(a){if($.k===C.b)return a.$0()
return P.du(null,null,this,a)},
bh:function(a,b){if($.k===C.b)return a.$1(b)
return P.dw(null,null,this,a,b)},
eq:function(a,b,c){if($.k===C.b)return a.$2(b,c)
return P.dv(null,null,this,a,b,c)}},
hD:{"^":"e:1;a,b",
$0:function(){return this.a.cn(this.b)}},
hE:{"^":"e:1;a,b",
$0:function(){return this.a.cm(this.b)}},
hF:{"^":"e:0;a,b",
$1:function(a){return this.a.bi(this.b,a)}}}],["","",,P,{"^":"",
bK:function(){return new H.ah(0,null,null,null,null,null,0,[null,null])},
ax:function(a){return H.ib(a,new H.ah(0,null,null,null,null,null,0,[null,null]))},
eS:function(a,b,c){var z,y
if(P.c2(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}z=[]
y=$.$get$aG()
y.push(a)
try{P.hW(a,z)}finally{if(0>=y.length)return H.c(y,-1)
y.pop()}y=P.cU(b,z,", ")+c
return y.charCodeAt(0)==0?y:y},
bb:function(a,b,c){var z,y,x
if(P.c2(a))return b+"..."+c
z=new P.bU(b)
y=$.$get$aG()
y.push(a)
try{x=z
x.q=P.cU(x.gq(),a,", ")}finally{if(0>=y.length)return H.c(y,-1)
y.pop()}y=z
y.q=y.gq()+c
y=z.gq()
return y.charCodeAt(0)==0?y:y},
c2:function(a){var z,y
for(z=0;y=$.$get$aG(),z<y.length;++z)if(a===y[z])return!0
return!1},
hW:function(a,b){var z,y,x,w,v,u,t,s,r,q
z=a.gv(a)
y=0
x=0
while(!0){if(!(y<80||x<3))break
if(!z.k())return
w=H.b(z.gn())
b.push(w)
y+=w.length+2;++x}if(!z.k()){if(x<=5)return
if(0>=b.length)return H.c(b,-1)
v=b.pop()
if(0>=b.length)return H.c(b,-1)
u=b.pop()}else{t=z.gn();++x
if(!z.k()){if(x<=4){b.push(H.b(t))
return}v=H.b(t)
if(0>=b.length)return H.c(b,-1)
u=b.pop()
y+=v.length+2}else{s=z.gn();++x
for(;z.k();t=s,s=r){r=z.gn();++x
if(x>100){while(!0){if(!(y>75&&x>3))break
if(0>=b.length)return H.c(b,-1)
y-=b.pop().length+2;--x}b.push("...")
return}}u=H.b(t)
v=H.b(s)
y+=v.length+u.length+4}}if(x>b.length+2){y+=5
q="..."}else q=null
while(!0){if(!(y>80&&b.length>3))break
if(0>=b.length)return H.c(b,-1)
y-=b.pop().length+2
if(q==null){y+=5
q="..."}}if(q!=null)b.push(q)
b.push(u)
b.push(v)},
G:function(a,b,c,d){return new P.hr(0,null,null,null,null,null,0,[d])},
cC:function(a,b){var z,y,x
z=P.G(null,null,null,b)
for(y=a.length,x=0;x<a.length;a.length===y||(0,H.bx)(a),++x)z.P(0,a[x])
return z},
cD:function(a){var z,y,x
z={}
if(P.c2(a))return"{...}"
y=new P.bU("")
try{$.$get$aG().push(a)
x=y
x.q=x.gq()+"{"
z.a=!0
a.b9(0,new P.f9(z,y))
z=y
z.q=z.gq()+"}"}finally{z=$.$get$aG()
if(0>=z.length)return H.c(z,-1)
z.pop()}z=y.gq()
return z.charCodeAt(0)==0?z:z},
dn:{"^":"ah;a,b,c,d,e,f,r,$ti",
aj:function(a){return H.ix(a)&0x3ffffff},
ak:function(a,b){var z,y,x
if(a==null)return-1
z=a.length
for(y=0;y<z;++y){x=a[y].gcc()
if(x==null?b==null:x===b)return y}return-1},
l:{
aD:function(a,b){return new P.dn(0,null,null,null,null,null,0,[a,b])}}},
hr:{"^":"hn;a,b,c,d,e,f,r,$ti",
gv:function(a){var z=new P.dm(this,this.r,null,null)
z.c=this.e
return z},
gj:function(a){return this.a},
t:function(a,b){var z,y
if(typeof b==="string"&&b!=="__proto__"){z=this.b
if(z==null)return!1
return z[b]!=null}else if(typeof b==="number"&&(b&0x3ffffff)===b){y=this.c
if(y==null)return!1
return y[b]!=null}else return this.dd(b)},
dd:function(a){var z=this.d
if(z==null)return!1
return this.av(z[this.at(a)],a)>=0},
cf:function(a){var z
if(!(typeof a==="string"&&a!=="__proto__"))z=typeof a==="number"&&(a&0x3ffffff)===a
else z=!0
if(z)return this.t(0,a)?a:null
else return this.dl(a)},
dl:function(a){var z,y,x
z=this.d
if(z==null)return
y=z[this.at(a)]
x=this.av(y,a)
if(x<0)return
return J.j(y,x).gbF()},
P:function(a,b){var z,y,x
if(typeof b==="string"&&b!=="__proto__"){z=this.b
if(z==null){y=Object.create(null)
y["<non-identifier-key>"]=y
delete y["<non-identifier-key>"]
this.b=y
z=y}return this.bz(z,b)}else if(typeof b==="number"&&(b&0x3ffffff)===b){x=this.c
if(x==null){y=Object.create(null)
y["<non-identifier-key>"]=y
delete y["<non-identifier-key>"]
this.c=y
x=y}return this.bz(x,b)}else return this.N(b)},
N:function(a){var z,y,x
z=this.d
if(z==null){z=P.ht()
this.d=z}y=this.at(a)
x=z[y]
if(x==null)z[y]=[this.aX(a)]
else{if(this.av(x,a)>=0)return!1
x.push(this.aX(a))}return!0},
am:function(a,b){if(typeof b==="string"&&b!=="__proto__")return this.bA(this.b,b)
else if(typeof b==="number"&&(b&0x3ffffff)===b)return this.bA(this.c,b)
else return this.dq(b)},
dq:function(a){var z,y,x
z=this.d
if(z==null)return!1
y=z[this.at(a)]
x=this.av(y,a)
if(x<0)return!1
this.bB(y.splice(x,1)[0])
return!0},
a7:function(a){if(this.a>0){this.f=null
this.e=null
this.d=null
this.c=null
this.b=null
this.a=0
this.r=this.r+1&67108863}},
bz:function(a,b){if(a[b]!=null)return!1
a[b]=this.aX(b)
return!0},
bA:function(a,b){var z
if(a==null)return!1
z=a[b]
if(z==null)return!1
this.bB(z)
delete a[b]
return!0},
aX:function(a){var z,y
z=new P.hs(a,null,null)
if(this.e==null){this.f=z
this.e=z}else{y=this.f
z.c=y
y.b=z
this.f=z}++this.a
this.r=this.r+1&67108863
return z},
bB:function(a){var z,y
z=a.gdc()
y=a.b
if(z==null)this.e=y
else z.b=y
if(y==null)this.f=z
else y.c=z;--this.a
this.r=this.r+1&67108863},
at:function(a){return J.a1(a)&0x3ffffff},
av:function(a,b){var z,y
if(a==null)return-1
z=a.length
for(y=0;y<z;++y)if(J.V(a[y].gbF(),b))return y
return-1},
$ish:1,
$ash:null,
l:{
ht:function(){var z=Object.create(null)
z["<non-identifier-key>"]=z
delete z["<non-identifier-key>"]
return z}}},
hs:{"^":"a;bF:a<,b,dc:c<"},
dm:{"^":"a;a,b,c,d",
gn:function(){return this.d},
k:function(){var z=this.a
if(this.b!==z.r)throw H.d(new P.a3(z))
else{z=this.c
if(z==null){this.d=null
return!1}else{this.d=z.a
this.c=z.b
return!0}}}},
hn:{"^":"fr;$ti"},
bL:{"^":"fh;$ti"},
fh:{"^":"a+ay;",$asi:null,$ash:null,$isi:1,$ish:1},
ay:{"^":"a;$ti",
gv:function(a){return new H.S(a,this.gj(a),0,null)},
I:function(a,b){return this.h(a,b)},
a0:function(a,b){return new H.az(a,b,[H.C(a,"ay",0),null])},
i:function(a){return P.bb(a,"[","]")},
$isi:1,
$asi:null,
$ish:1,
$ash:null},
f9:{"^":"e:14;a,b",
$2:function(a,b){var z,y
z=this.a
if(!z.a)this.b.q+=", "
z.a=!1
z=this.b
y=z.q+=H.b(a)
z.q=y+": "
z.q+=H.b(b)}},
f7:{"^":"aU;a,b,c,d,$ti",
gv:function(a){return new P.hu(this,this.c,this.d,this.b,null)},
gE:function(a){return this.b===this.c},
gj:function(a){return(this.c-this.b&this.a.length-1)>>>0},
I:function(a,b){var z,y,x,w
z=(this.c-this.b&this.a.length-1)>>>0
if(0>b||b>=z)H.w(P.aP(b,this,"index",null,z))
y=this.a
x=y.length
w=(this.b+b&x-1)>>>0
if(w<0||w>=x)return H.c(y,w)
return y[w]},
a7:function(a){var z,y,x,w,v
z=this.b
y=this.c
if(z!==y){for(x=this.a,w=x.length,v=w-1;z!==y;z=(z+1&v)>>>0){if(z<0||z>=w)return H.c(x,z)
x[z]=null}this.c=0
this.b=0;++this.d}},
i:function(a){return P.bb(this,"{","}")},
ck:function(){var z,y,x,w
z=this.b
if(z===this.c)throw H.d(H.bG());++this.d
y=this.a
x=y.length
if(z>=x)return H.c(y,z)
w=y[z]
y[z]=null
this.b=(z+1&x-1)>>>0
return w},
N:function(a){var z,y,x
z=this.a
y=this.c
x=z.length
if(y<0||y>=x)return H.c(z,y)
z[y]=a
x=(y+1&x-1)>>>0
this.c=x
if(this.b===x)this.bG();++this.d},
bG:function(){var z,y,x,w
z=new Array(this.a.length*2)
z.fixed$length=Array
y=H.q(z,this.$ti)
z=this.a
x=this.b
w=z.length-x
C.a.br(y,0,w,z,x)
C.a.br(y,w,w+this.b,this.a,0)
this.b=0
this.c=this.a.length
this.a=y},
cY:function(a,b){var z=new Array(8)
z.fixed$length=Array
this.a=H.q(z,[b])},
$ash:null,
l:{
bM:function(a,b){var z=new P.f7(null,0,0,0,[b])
z.cY(a,b)
return z}}},
hu:{"^":"a;a,b,c,d,e",
gn:function(){return this.e},
k:function(){var z,y,x
z=this.a
if(this.c!==z.d)H.w(new P.a3(z))
y=this.d
if(y===this.b){this.e=null
return!1}z=z.a
x=z.length
if(y>=x)return H.c(z,y)
this.e=z[y]
this.d=(y+1&x-1)>>>0
return!0}},
fs:{"^":"a;$ti",
R:function(a,b){var z
for(z=J.aI(b);z.k();)this.P(0,z.gn())},
a0:function(a,b){return new H.cm(this,b,[H.I(this,0),null])},
i:function(a){return P.bb(this,"{","}")},
$ish:1,
$ash:null},
fr:{"^":"fs;$ti"}}],["","",,P,{"^":"",
bm:function(a){var z
if(a==null)return
if(typeof a!="object")return a
if(Object.getPrototypeOf(a)!==Array.prototype)return new P.hq(a,Object.create(null),null)
for(z=0;z<a.length;++z)a[z]=P.bm(a[z])
return a},
hZ:function(a,b){var z,y,x,w
if(typeof a!=="string")throw H.d(H.F(a))
z=null
try{z=JSON.parse(a)}catch(x){w=H.x(x)
y=w
throw H.d(new P.cu(String(y),null,null))}return P.bm(z)},
hq:{"^":"a;a,b,c",
h:function(a,b){var z,y
z=this.b
if(z==null)return this.c.h(0,b)
else if(typeof b!=="string")return
else{y=z[b]
return typeof y=="undefined"?this.dn(b):y}},
gj:function(a){var z
if(this.b==null){z=this.c
z=z.gj(z)}else z=this.au().length
return z},
gE:function(a){var z
if(this.b==null){z=this.c
z=z.gj(z)}else z=this.au().length
return z===0},
m:function(a,b,c){var z,y
if(this.b==null)this.c.m(0,b,c)
else if(this.ag(b)){z=this.b
z[b]=c
y=this.a
if(y==null?z!=null:y!==z)y[b]=null}else this.dw().m(0,b,c)},
ag:function(a){if(this.b==null)return this.c.ag(a)
if(typeof a!=="string")return!1
return Object.prototype.hasOwnProperty.call(this.a,a)},
b9:function(a,b){var z,y,x,w
if(this.b==null)return this.c.b9(0,b)
z=this.au()
for(y=0;y<z.length;++y){x=z[y]
w=this.b[x]
if(typeof w=="undefined"){w=P.bm(this.a[x])
this.b[x]=w}b.$2(x,w)
if(z!==this.c)throw H.d(new P.a3(this))}},
i:function(a){return P.cD(this)},
au:function(){var z=this.c
if(z==null){z=Object.keys(this.a)
this.c=z}return z},
dw:function(){var z,y,x,w,v
if(this.b==null)return this.c
z=P.bK()
y=this.au()
for(x=0;w=y.length,x<w;++x){v=y[x]
z.m(0,v,this.h(0,v))}if(w===0)y.push(null)
else C.a.sj(y,0)
this.b=null
this.a=null
this.c=z
return z},
dn:function(a){var z
if(!Object.prototype.hasOwnProperty.call(this.a,a))return
z=P.bm(this.a[a])
return this.b[a]=z}},
ea:{"^":"a;"},
ec:{"^":"a;"},
f2:{"^":"ea;a,b",
dK:function(a,b){return P.hZ(a,this.gdL().a)},
dJ:function(a){return this.dK(a,null)},
gdL:function(){return C.D}},
f3:{"^":"ec;a"}}],["","",,P,{"^":"",
cp:function(a){if(typeof a==="number"||typeof a==="boolean"||null==a)return J.W(a)
if(typeof a==="string")return JSON.stringify(a)
return P.ej(a)},
ej:function(a){var z=J.r(a)
if(!!z.$ise)return z.i(a)
return H.bf(a)},
b9:function(a){return new P.h8(a)},
bc:function(a,b,c){var z,y
z=H.q([],[c])
for(y=J.aI(a);y.k();)z.push(y.gn())
return z},
c8:function(a){var z=H.b(a)
H.iy(z)},
c3:{"^":"a;"},
"+bool":0,
iL:{"^":"a;"},
ad:{"^":"ar;"},
"+double":0,
a4:{"^":"a;a4:a<",
H:function(a,b){return new P.a4(this.a+b.ga4())},
a3:function(a,b){return new P.a4(this.a-b.ga4())},
aa:function(a,b){return new P.a4(C.f.ep(this.a*b))},
aP:function(a,b){if(b===0)throw H.d(new P.eE())
if(typeof b!=="number")return H.u(b)
return new P.a4(C.c.aP(this.a,b))},
aq:function(a,b){return C.c.aq(this.a,b.ga4())},
W:function(a,b){return C.c.W(this.a,b.ga4())},
aL:function(a,b){return C.c.aL(this.a,b.ga4())},
ap:function(a,b){return C.c.ap(this.a,b.ga4())},
p:function(a,b){if(b==null)return!1
if(!(b instanceof P.a4))return!1
return this.a===b.a},
gu:function(a){return this.a&0x1FFFFFFF},
i:function(a){var z,y,x,w,v
z=new P.eh()
y=this.a
if(y<0)return"-"+new P.a4(0-y).i(0)
x=z.$1(C.c.a5(y,6e7)%60)
w=z.$1(C.c.a5(y,1e6)%60)
v=new P.eg().$1(y%1e6)
return""+C.c.a5(y,36e8)+":"+H.b(x)+":"+H.b(w)+"."+H.b(v)},
l:{
ef:function(a,b,c,d,e,f){return new P.a4(864e8*a+36e8*b+6e7*e+1e6*f+1000*d+c)}}},
eg:{"^":"e:5;",
$1:function(a){if(a>=1e5)return""+a
if(a>=1e4)return"0"+a
if(a>=1000)return"00"+a
if(a>=100)return"000"+a
if(a>=10)return"0000"+a
return"00000"+a}},
eh:{"^":"e:5;",
$1:function(a){if(a>=10)return""+a
return"0"+a}},
D:{"^":"a;",
gM:function(){return H.H(this.$thrownJsError)}},
bR:{"^":"D;",
i:function(a){return"Throw of null."}},
a2:{"^":"D;a,b,c,d",
gaZ:function(){return"Invalid argument"+(!this.a?"(s)":"")},
gaY:function(){return""},
i:function(a){var z,y,x,w,v,u
z=this.c
y=z!=null?" ("+z+")":""
z=this.d
x=z==null?"":": "+H.b(z)
w=this.gaZ()+y+x
if(!this.a)return w
v=this.gaY()
u=P.cp(this.b)
return w+v+": "+H.b(u)},
l:{
bA:function(a){return new P.a2(!1,null,null,a)},
cg:function(a,b,c){return new P.a2(!0,a,b,c)}}},
bT:{"^":"a2;e,f,a,b,c,d",
gaZ:function(){return"RangeError"},
gaY:function(){var z,y,x
z=this.e
if(z==null){z=this.f
y=z!=null?": Not less than or equal to "+H.b(z):""}else{x=this.f
if(x==null)y=": Not greater than or equal to "+H.b(z)
else if(x>z)y=": Not in range "+H.b(z)+".."+H.b(x)+", inclusive"
else y=x<z?": Valid value range is empty":": Only valid value is "+H.b(z)}return y},
l:{
fm:function(a){return new P.bT(null,null,!1,null,null,a)},
aX:function(a,b,c){return new P.bT(null,null,!0,a,b,"Value not in range")},
aA:function(a,b,c,d,e){return new P.bT(b,c,!0,a,d,"Invalid value")},
cQ:function(a,b,c,d,e,f){if(0>a||a>c)throw H.d(P.aA(a,0,c,"start",f))
if(a>b||b>c)throw H.d(P.aA(b,a,c,"end",f))
return b}}},
eD:{"^":"a2;e,j:f>,a,b,c,d",
gaZ:function(){return"RangeError"},
gaY:function(){if(J.ca(this.b,0))return": index must not be negative"
var z=this.f
if(z===0)return": no indices are valid"
return": index should be less than "+H.b(z)},
l:{
aP:function(a,b,c,d,e){var z=e!=null?e:J.aJ(b)
return new P.eD(b,z,!0,a,c,"Index out of range")}}},
z:{"^":"D;a",
i:function(a){return"Unsupported operation: "+this.a}},
da:{"^":"D;a",
i:function(a){var z=this.a
return z!=null?"UnimplementedError: "+H.b(z):"UnimplementedError"}},
Y:{"^":"D;a",
i:function(a){return"Bad state: "+this.a}},
a3:{"^":"D;a",
i:function(a){var z=this.a
if(z==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+H.b(P.cp(z))+"."}},
fi:{"^":"a;",
i:function(a){return"Out of Memory"},
gM:function(){return},
$isD:1},
cS:{"^":"a;",
i:function(a){return"Stack Overflow"},
gM:function(){return},
$isD:1},
ed:{"^":"D;a",
i:function(a){var z=this.a
return z==null?"Reading static variable during its initialization":"Reading static variable '"+H.b(z)+"' during its initialization"}},
h8:{"^":"a;a",
i:function(a){var z=this.a
if(z==null)return"Exception"
return"Exception: "+H.b(z)}},
cu:{"^":"a;a,b,c",
i:function(a){var z,y
z=""!==this.a?"FormatException: "+this.a:"FormatException"
y=this.b
if(typeof y!=="string")return z
if(y.length>78)y=C.d.X(y,0,75)+"..."
return z+"\n"+y}},
eE:{"^":"a;",
i:function(a){return"IntegerDivisionByZeroException"}},
ek:{"^":"a;a,bK",
i:function(a){return"Expando:"+H.b(this.a)},
h:function(a,b){var z,y
z=this.bK
if(typeof z!=="string"){if(b==null||typeof b==="boolean"||typeof b==="number"||typeof b==="string")H.w(P.cg(b,"Expandos are not allowed on strings, numbers, booleans or null",null))
return z.get(b)}y=H.bS(b,"expando$values")
return y==null?null:H.bS(y,z)},
m:function(a,b,c){var z,y
z=this.bK
if(typeof z!=="string")z.set(b,c)
else{y=H.bS(b,"expando$values")
if(y==null){y=new P.a()
H.cP(b,"expando$values",y)}H.cP(y,z,c)}}},
ex:{"^":"a;"},
l:{"^":"ar;"},
"+int":0,
L:{"^":"a;$ti",
a0:function(a,b){return H.bd(this,b,H.C(this,"L",0),null)},
bn:["cU",function(a,b){return new H.db(this,b,[H.C(this,"L",0)])}],
bm:function(a,b){return P.bc(this,!0,H.C(this,"L",0))},
bl:function(a){return this.bm(a,!0)},
gj:function(a){var z,y
z=this.gv(this)
for(y=0;z.k();)++y
return y},
ga1:function(a){var z,y
z=this.gv(this)
if(!z.k())throw H.d(H.bG())
y=z.gn()
if(z.k())throw H.d(H.eU())
return y},
I:function(a,b){var z,y,x
if(b<0)H.w(P.aA(b,0,null,"index",null))
for(z=this.gv(this),y=0;z.k();){x=z.gn()
if(b===y)return x;++y}throw H.d(P.aP(b,this,"index",null,y))},
i:function(a){return P.eS(this,"(",")")}},
cy:{"^":"a;"},
i:{"^":"a;$ti",$asi:null,$ish:1,$ash:null},
"+List":0,
ff:{"^":"a;",
gu:function(a){return P.a.prototype.gu.call(this,this)},
i:function(a){return"null"}},
"+Null":0,
ar:{"^":"a;"},
"+num":0,
a:{"^":";",
p:function(a,b){return this===b},
gu:function(a){return H.a9(this)},
i:function(a){return H.bf(this)},
toString:function(){return this.i(this)}},
ai:{"^":"a;"},
cT:{"^":"a;a,b",
bs:function(a){if(this.b!=null){this.a=J.ae(this.a,J.a0($.N.$0(),this.b))
this.b=null}}},
y:{"^":"a;"},
"+String":0,
bU:{"^":"a;q<",
gj:function(a){return this.q.length},
i:function(a){var z=this.q
return z.charCodeAt(0)==0?z:z},
l:{
cU:function(a,b,c){var z=J.aI(b)
if(!z.k())return a
if(c.length===0){do a+=H.b(z.gn())
while(z.k())}else{a+=H.b(z.gn())
for(;z.k();)a=a+c+H.b(z.gn())}return a}}}}],["","",,W,{"^":"",
cf:function(a){var z=document.createElement("a")
return z},
ei:function(a,b,c){var z,y
z=document.body
y=(z&&C.h).B(z,a,b,c)
y.toString
z=new H.db(new W.Q(y),new W.i8(),[W.o])
return z.ga1(z)},
a6:function(a){var z,y,x
z="element tag unavailable"
try{y=J.dY(a)
if(typeof y==="string")z=a.tagName}catch(x){H.x(x)}return z},
ez:function(a,b,c){return W.eB(a,null,null,b,null,null,null,c).bj(new W.eA())},
eB:function(a,b,c,d,e,f,g,h){var z,y,x,w
z=W.aO
y=new P.P(0,$.k,null,[z])
x=new P.fN(y,[z])
w=new XMLHttpRequest()
C.t.eg(w,"GET",a,!0)
z=W.jD
W.Z(w,"load",new W.eC(x,w),!1,z)
W.Z(w,"error",x.gdF(),!1,z)
w.send()
return y},
ab:function(a,b){a=536870911&a+b
a=536870911&a+((524287&a)<<10)
return a^a>>>6},
dl:function(a){a=536870911&a+((67108863&a)<<3)
a^=a>>>11
return 536870911&a+((16383&a)<<15)},
i2:function(a){var z=$.k
if(z===C.b)return a
return z.c3(a,!0)},
t:{"^":"ag;","%":"HTMLAppletElement|HTMLBRElement|HTMLCanvasElement|HTMLContentElement|HTMLDListElement|HTMLDataListElement|HTMLDetailsElement|HTMLDialogElement|HTMLDirectoryElement|HTMLDivElement|HTMLFontElement|HTMLFrameElement|HTMLHRElement|HTMLHeadElement|HTMLHeadingElement|HTMLHtmlElement|HTMLLIElement|HTMLLabelElement|HTMLLegendElement|HTMLMarqueeElement|HTMLMenuElement|HTMLMenuItemElement|HTMLMeterElement|HTMLModElement|HTMLOListElement|HTMLOptGroupElement|HTMLOptionElement|HTMLParagraphElement|HTMLPictureElement|HTMLPreElement|HTMLProgressElement|HTMLQuoteElement|HTMLScriptElement|HTMLShadowElement|HTMLSourceElement|HTMLSpanElement|HTMLStyleElement|HTMLTableCaptionElement|HTMLTableCellElement|HTMLTableColElement|HTMLTableDataCellElement|HTMLTableHeaderCellElement|HTMLTitleElement|HTMLTrackElement|HTMLUListElement|HTMLUnknownElement|PluginPlaceholderElement;HTMLElement"},
iE:{"^":"t;aC:href}",
i:function(a){return String(a)},
$isf:1,
"%":"HTMLAnchorElement"},
iG:{"^":"t;aC:href}",
i:function(a){return String(a)},
$isf:1,
"%":"HTMLAreaElement"},
iH:{"^":"t;aC:href}","%":"HTMLBaseElement"},
bB:{"^":"t;",$isbB:1,$isf:1,"%":"HTMLBodyElement"},
iI:{"^":"t;w:name=","%":"HTMLButtonElement"},
iJ:{"^":"o;j:length=",$isf:1,"%":"CDATASection|CharacterData|Comment|ProcessingInstruction|Text"},
iK:{"^":"eF;j:length=",
sc2:function(a,b){a.backgroundImage=b==null?"":b},
"%":"CSS2Properties|CSSStyleDeclaration|MSStyleCSSProperties"},
eF:{"^":"f+ck;"},
fW:{"^":"fg;a,b",
dv:function(a,b){var z
for(z=this.a,z=new H.S(z,z.gj(z),0,null);z.k();)z.d.style[a]=b},
sc2:function(a,b){this.dv("backgroundImage",b)},
d1:function(a){this.b=new H.az(P.bc(this.a,!0,null),new W.fY(),[null,null])},
l:{
fX:function(a){var z=new W.fW(a,null)
z.d1(a)
return z}}},
fg:{"^":"a+ck;"},
fY:{"^":"e:0;",
$1:function(a){return J.aK(a)}},
ck:{"^":"a;"},
iM:{"^":"o;",
L:function(a,b,c,d){var z
this.d9(a)
z=document.body
a.appendChild((z&&C.h).B(z,b,c,d))},
ab:function(a,b){return this.L(a,b,null,null)},
aN:function(a,b,c){return this.L(a,b,null,c)},
$isf:1,
"%":"DocumentFragment|ShadowRoot"},
iN:{"^":"f;",
i:function(a){return String(a)},
"%":"DOMException"},
ee:{"^":"f;",
i:function(a){return"Rectangle ("+H.b(a.left)+", "+H.b(a.top)+") "+H.b(this.gV(a))+" x "+H.b(this.gD(a))},
p:function(a,b){var z
if(b==null)return!1
z=J.r(b)
if(!z.$isaY)return!1
return a.left===z.gF(b)&&a.top===z.gA(b)&&this.gV(a)===z.gV(b)&&this.gD(a)===z.gD(b)},
gu:function(a){var z,y,x,w
z=a.left
y=a.top
x=this.gV(a)
w=this.gD(a)
return W.dl(W.ab(W.ab(W.ab(W.ab(0,z&0x1FFFFFFF),y&0x1FFFFFFF),x&0x1FFFFFFF),w&0x1FFFFFFF))},
gaA:function(a){return a.bottom},
gD:function(a){return a.height},
gF:function(a){return a.left},
gU:function(a){return a.right},
gA:function(a){return a.top},
gV:function(a){return a.width},
$isaY:1,
$asaY:I.B,
"%":";DOMRectReadOnly"},
O:{"^":"bL;a,$ti",
gj:function(a){return this.a.length},
h:function(a,b){var z=this.a
if(b>>>0!==b||b>=z.length)return H.c(z,b)
return z[b]},
m:function(a,b,c){throw H.d(new P.z("Cannot modify list"))},
gbt:function(a){return W.fX(this)},
$isi:1,
$asi:null,
$ish:1,
$ash:null},
ag:{"^":"o;bt:style=,c7:className},es:tagName=",
gdD:function(a){return new W.h2(a)},
i:function(a){return a.localName},
B:["aO",function(a,b,c,d){var z,y,x,w,v
if(c==null){if(d==null){z=$.co
if(z==null){z=H.q([],[W.X])
y=new W.a8(z)
z.push(W.aa(null))
z.push(W.ac())
$.co=y
d=y}else d=z}z=$.cn
if(z==null){z=new W.ds(d)
$.cn=z
c=z}else{z.a=d
c=z}}else if(d!=null)throw H.d(P.bA("validator can only be passed if treeSanitizer is null"))
if($.a5==null){z=document
y=z.implementation.createHTMLDocument("")
$.a5=y
$.bE=y.createRange()
y=$.a5
y.toString
x=y.createElement("base")
J.e1(x,z.baseURI)
$.a5.head.appendChild(x)}z=$.a5
if(!!this.$isbB)w=z.body
else{y=a.tagName
z.toString
w=z.createElement(y)
$.a5.body.appendChild(w)}if("createContextualFragment" in window.Range.prototype&&!C.a.t(C.F,a.tagName)){$.bE.selectNodeContents(w)
v=$.bE.createContextualFragment(b)}else{w.innerHTML=b
v=$.a5.createDocumentFragment()
for(;z=w.firstChild,z!=null;)v.appendChild(z)}z=$.a5.body
if(w==null?z!=null:w!==z)J.e_(w)
c.bq(v)
document.adoptNode(v)
return v},function(a,b,c){return this.B(a,b,c,null)},"dI",null,null,"geE",2,5,null,0,0],
scd:function(a,b){this.ab(a,b)},
L:function(a,b,c,d){a.textContent=null
a.appendChild(this.B(a,b,c,d))},
ab:function(a,b){return this.L(a,b,null,null)},
aN:function(a,b,c){return this.L(a,b,null,c)},
a9:function(a){return a.getBoundingClientRect()},
gcg:function(a){return new W.dg(a,"click",!1,[W.fb])},
$isag:1,
$iso:1,
$isa:1,
$isf:1,
"%":";Element"},
i8:{"^":"e:0;",
$1:function(a){return!!J.r(a).$isag}},
iO:{"^":"t;w:name=","%":"HTMLEmbedElement"},
iP:{"^":"cq;Z:error=","%":"ErrorEvent"},
cq:{"^":"f;","%":"AnimationEvent|AnimationPlayerEvent|ApplicationCacheErrorEvent|AudioProcessingEvent|AutocompleteErrorEvent|BeforeInstallPromptEvent|BeforeUnloadEvent|ClipboardEvent|CloseEvent|CompositionEvent|CrossOriginConnectEvent|CustomEvent|DefaultSessionStartEvent|DeviceLightEvent|DeviceMotionEvent|DeviceOrientationEvent|DragEvent|ExtendableEvent|FetchEvent|FocusEvent|FontFaceSetLoadEvent|GamepadEvent|GeofencingEvent|HashChangeEvent|IDBVersionChangeEvent|KeyboardEvent|MIDIConnectionEvent|MIDIMessageEvent|MediaEncryptedEvent|MediaKeyEvent|MediaKeyMessageEvent|MediaQueryListEvent|MediaStreamEvent|MediaStreamTrackEvent|MessageEvent|MouseEvent|NotificationEvent|OfflineAudioCompletionEvent|PageTransitionEvent|PeriodicSyncEvent|PointerEvent|PopStateEvent|ProgressEvent|PromiseRejectionEvent|PushEvent|RTCDTMFToneChangeEvent|RTCDataChannelEvent|RTCIceCandidateEvent|RTCPeerConnectionIceEvent|RelatedEvent|ResourceProgressEvent|SVGZoomEvent|SecurityPolicyViolationEvent|ServicePortConnectEvent|ServiceWorkerMessageEvent|SpeechRecognitionEvent|SpeechSynthesisEvent|StorageEvent|SyncEvent|TextEvent|TouchEvent|TrackEvent|TransitionEvent|UIEvent|WebGLContextEvent|WebKitTransitionEvent|WheelEvent|XMLHttpRequestProgressEvent;Event|InputEvent"},
b8:{"^":"f;",
dB:function(a,b,c,d){if(c!=null)this.d6(a,b,c,!1)},
em:function(a,b,c,d){if(c!=null)this.dr(a,b,c,!1)},
d6:function(a,b,c,d){return a.addEventListener(b,H.ao(c,1),!1)},
dr:function(a,b,c,d){return a.removeEventListener(b,H.ao(c,1),!1)},
"%":"CrossOriginServiceWorkerClient|MediaStream;EventTarget"},
j5:{"^":"t;w:name=","%":"HTMLFieldSetElement"},
j7:{"^":"t;j:length=,w:name=","%":"HTMLFormElement"},
aO:{"^":"ey;eo:responseText=",
eF:function(a,b,c,d,e,f){return a.open(b,c,!0,f,e)},
eg:function(a,b,c,d){return a.open(b,c,d)},
ar:function(a,b){return a.send(b)},
$isaO:1,
$isa:1,
"%":"XMLHttpRequest"},
eA:{"^":"e:15;",
$1:function(a){return J.dW(a)}},
eC:{"^":"e:0;a,b",
$1:function(a){var z,y,x,w,v
z=this.b
y=z.status
if(typeof y!=="number")return y.ap()
x=y>=200&&y<300
w=y>307&&y<400
y=x||y===0||y===304||w
v=this.a
if(y)v.aB(0,z)
else v.dG(a)}},
ey:{"^":"b8;","%":";XMLHttpRequestEventTarget"},
j8:{"^":"t;w:name=","%":"HTMLIFrameElement"},
j9:{"^":"t;",
aB:function(a,b){return a.complete.$1(b)},
"%":"HTMLImageElement"},
jb:{"^":"t;w:name=",$isag:1,$isf:1,"%":"HTMLInputElement"},
je:{"^":"t;w:name=","%":"HTMLKeygenElement"},
jf:{"^":"t;aC:href}","%":"HTMLLinkElement"},
jg:{"^":"f;",
i:function(a){return String(a)},
"%":"Location"},
jh:{"^":"t;w:name=","%":"HTMLMapElement"},
jk:{"^":"t;Z:error=","%":"HTMLAudioElement|HTMLMediaElement|HTMLVideoElement"},
jl:{"^":"t;w:name=","%":"HTMLMetaElement"},
jm:{"^":"fa;",
ex:function(a,b,c){return a.send(b,c)},
ar:function(a,b){return a.send(b)},
"%":"MIDIOutput"},
fa:{"^":"b8;","%":"MIDIInput;MIDIPort"},
jw:{"^":"f;",$isf:1,"%":"Navigator"},
Q:{"^":"bL;a",
ga1:function(a){var z,y
z=this.a
y=z.childNodes.length
if(y===0)throw H.d(new P.Y("No elements"))
if(y>1)throw H.d(new P.Y("More than one element"))
return z.firstChild},
R:function(a,b){var z,y,x,w
z=b.a
y=this.a
if(z!==y)for(x=z.childNodes.length,w=0;w<x;++w)y.appendChild(z.firstChild)
return},
m:function(a,b,c){var z,y
z=this.a
y=z.childNodes
if(b>>>0!==b||b>=y.length)return H.c(y,b)
z.replaceChild(c,y[b])},
gv:function(a){var z=this.a.childNodes
return new W.ct(z,z.length,-1,null)},
gj:function(a){return this.a.childNodes.length},
h:function(a,b){var z=this.a.childNodes
if(b>>>0!==b||b>=z.length)return H.c(z,b)
return z[b]},
$asbL:function(){return[W.o]},
$asi:function(){return[W.o]},
$ash:function(){return[W.o]}},
o:{"^":"b8;eh:parentNode=,ei:previousSibling=",
gef:function(a){return new W.Q(a)},
ek:function(a){var z=a.parentNode
if(z!=null)z.removeChild(a)},
d9:function(a){var z
for(;z=a.firstChild,z!=null;)a.removeChild(z)},
i:function(a){var z=a.nodeValue
return z==null?this.cT(a):z},
$iso:1,
$isa:1,
"%":"Document|HTMLDocument|XMLDocument;Node"},
jx:{"^":"eI;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)throw H.d(P.aP(b,a,null,null,null))
return a[b]},
m:function(a,b,c){throw H.d(new P.z("Cannot assign element of immutable List."))},
I:function(a,b){if(b<0||b>=a.length)return H.c(a,b)
return a[b]},
$isi:1,
$asi:function(){return[W.o]},
$ish:1,
$ash:function(){return[W.o]},
$isM:1,
$asM:function(){return[W.o]},
$isE:1,
$asE:function(){return[W.o]},
"%":"NodeList|RadioNodeList"},
eG:{"^":"f+ay;",
$asi:function(){return[W.o]},
$ash:function(){return[W.o]},
$isi:1,
$ish:1},
eI:{"^":"eG+cv;",
$asi:function(){return[W.o]},
$ash:function(){return[W.o]},
$isi:1,
$ish:1},
jy:{"^":"t;w:name=","%":"HTMLObjectElement"},
jz:{"^":"t;w:name=","%":"HTMLOutputElement"},
jA:{"^":"t;w:name=","%":"HTMLParamElement"},
jE:{"^":"f;",
a9:function(a){return a.getBoundingClientRect()},
"%":"Range"},
jF:{"^":"t;j:length=,w:name=","%":"HTMLSelectElement"},
jG:{"^":"cq;Z:error=","%":"SpeechRecognitionError"},
fB:{"^":"t;",
B:function(a,b,c,d){var z,y
if("createContextualFragment" in window.Range.prototype)return this.aO(a,b,c,d)
z=W.ei("<table>"+b+"</table>",c,d)
y=document.createDocumentFragment()
y.toString
new W.Q(y).R(0,J.dT(z))
return y},
"%":"HTMLTableElement"},
jK:{"^":"t;",
B:function(a,b,c,d){var z,y,x,w
if("createContextualFragment" in window.Range.prototype)return this.aO(a,b,c,d)
z=document
y=z.createDocumentFragment()
z=C.p.B(z.createElement("table"),b,c,d)
z.toString
z=new W.Q(z)
x=z.ga1(z)
x.toString
z=new W.Q(x)
w=z.ga1(z)
y.toString
w.toString
new W.Q(y).R(0,new W.Q(w))
return y},
"%":"HTMLTableRowElement"},
jL:{"^":"t;",
B:function(a,b,c,d){var z,y,x
if("createContextualFragment" in window.Range.prototype)return this.aO(a,b,c,d)
z=document
y=z.createDocumentFragment()
z=C.p.B(z.createElement("table"),b,c,d)
z.toString
z=new W.Q(z)
x=z.ga1(z)
y.toString
x.toString
new W.Q(y).R(0,new W.Q(x))
return y},
"%":"HTMLTableSectionElement"},
cW:{"^":"t;",
L:function(a,b,c,d){var z
a.textContent=null
z=this.B(a,b,c,d)
a.content.appendChild(z)},
ab:function(a,b){return this.L(a,b,null,null)},
aN:function(a,b,c){return this.L(a,b,null,c)},
$iscW:1,
"%":"HTMLTemplateElement"},
jM:{"^":"t;w:name=","%":"HTMLTextAreaElement"},
jQ:{"^":"b8;",$isf:1,"%":"DOMWindow|Window"},
jU:{"^":"o;w:name=","%":"Attr"},
jV:{"^":"f;aA:bottom=,D:height=,F:left=,U:right=,A:top=,V:width=",
i:function(a){return"Rectangle ("+H.b(a.left)+", "+H.b(a.top)+") "+H.b(a.width)+" x "+H.b(a.height)},
p:function(a,b){var z,y,x
if(b==null)return!1
z=J.r(b)
if(!z.$isaY)return!1
y=a.left
x=z.gF(b)
if(y==null?x==null:y===x){y=a.top
x=z.gA(b)
if(y==null?x==null:y===x){y=a.width
x=z.gV(b)
if(y==null?x==null:y===x){y=a.height
z=z.gD(b)
z=y==null?z==null:y===z}else z=!1}else z=!1}else z=!1
return z},
gu:function(a){var z,y,x,w
z=J.a1(a.left)
y=J.a1(a.top)
x=J.a1(a.width)
w=J.a1(a.height)
return W.dl(W.ab(W.ab(W.ab(W.ab(0,z),y),x),w))},
$isaY:1,
$asaY:I.B,
"%":"ClientRect"},
jW:{"^":"o;",$isf:1,"%":"DocumentType"},
jX:{"^":"ee;",
gD:function(a){return a.height},
gV:function(a){return a.width},
"%":"DOMRect"},
k_:{"^":"t;",$isf:1,"%":"HTMLFrameSetElement"},
k2:{"^":"eJ;",
gj:function(a){return a.length},
h:function(a,b){if(b>>>0!==b||b>=a.length)throw H.d(P.aP(b,a,null,null,null))
return a[b]},
m:function(a,b,c){throw H.d(new P.z("Cannot assign element of immutable List."))},
I:function(a,b){if(b<0||b>=a.length)return H.c(a,b)
return a[b]},
$isi:1,
$asi:function(){return[W.o]},
$ish:1,
$ash:function(){return[W.o]},
$isM:1,
$asM:function(){return[W.o]},
$isE:1,
$asE:function(){return[W.o]},
"%":"MozNamedAttrMap|NamedNodeMap"},
eH:{"^":"f+ay;",
$asi:function(){return[W.o]},
$ash:function(){return[W.o]},
$isi:1,
$ish:1},
eJ:{"^":"eH+cv;",
$asi:function(){return[W.o]},
$ash:function(){return[W.o]},
$isi:1,
$ish:1},
fT:{"^":"a;dj:a<",
ga8:function(){var z,y,x,w,v
z=this.a.attributes
y=H.q([],[P.y])
for(x=z.length,w=0;w<x;++w){if(w>=z.length)return H.c(z,w)
v=z[w]
if(v.namespaceURI==null)y.push(J.dS(v))}return y}},
h2:{"^":"fT;a",
h:function(a,b){return this.a.getAttribute(b)},
m:function(a,b,c){this.a.setAttribute(b,c)},
gj:function(a){return this.ga8().length}},
h5:{"^":"aC;a,b,c,$ti",
al:function(a,b,c,d){return W.Z(this.a,this.b,a,!1,H.I(this,0))},
ce:function(a,b,c){return this.al(a,null,b,c)}},
dg:{"^":"h5;a,b,c,$ti"},
h6:{"^":"fw;a,b,c,d,e,$ti",
af:function(){if(this.b==null)return
this.c_()
this.b=null
this.d=null
return},
bf:function(a,b){if(this.b==null)return;++this.a
this.c_()},
ci:function(a){return this.bf(a,null)},
cl:function(){if(this.b==null||this.a<=0)return;--this.a
this.bY()},
bY:function(){var z=this.d
if(z!=null&&this.a<=0)J.dO(this.b,this.c,z,!1)},
c_:function(){var z=this.d
if(z!=null)J.e0(this.b,this.c,z,!1)},
d2:function(a,b,c,d,e){this.bY()},
l:{
Z:function(a,b,c,d,e){var z=W.i2(new W.h7(c))
z=new W.h6(0,a,b,z,!1,[e])
z.d2(a,b,c,!1,e)
return z}}},
h7:{"^":"e:0;a",
$1:function(a){return this.a.$1(a)}},
bY:{"^":"a;cq:a<",
T:function(a){return $.$get$dk().t(0,W.a6(a))},
S:function(a,b,c){var z,y,x
z=W.a6(a)
y=$.$get$bZ()
x=y.h(0,H.b(z)+"::"+b)
if(x==null)x=y.h(0,"*::"+b)
if(x==null)return!1
return x.$4(a,b,c,this)},
d4:function(a){var z,y
z=$.$get$bZ()
if(z.gE(z)){for(y=0;y<262;++y)z.m(0,C.E[y],W.ie())
for(y=0;y<12;++y)z.m(0,C.i[y],W.ig())}},
$isX:1,
l:{
aa:function(a){var z=new W.bY(new W.dp(W.cf(null),window.location))
z.d4(a)
return z},
k0:[function(a,b,c,d){return!0},"$4","ie",8,0,6],
k1:[function(a,b,c,d){return d.gcq().b7(c)},"$4","ig",8,0,6]}},
cv:{"^":"a;$ti",
gv:function(a){return new W.ct(a,this.gj(a),-1,null)},
$isi:1,
$asi:null,
$ish:1,
$ash:null},
a8:{"^":"a;a",
a6:function(a,b,c,d){var z,y,x
z=a.toUpperCase()
y=new H.az(b,new W.fc(z),[null,null])
d=new W.dp(W.cf(null),window.location)
x=P.y
x=new W.fZ(!1,!0,P.G(null,null,null,x),P.G(null,null,null,x),P.G(null,null,null,x),d)
x.bv(d,y,[z],c)
this.a.push(x)},
T:function(a){return C.a.c1(this.a,new W.fe(a))},
S:function(a,b,c){return C.a.c1(this.a,new W.fd(a,b,c))}},
fc:{"^":"e:0;a",
$1:function(a){return this.a+"::"+J.cd(a)}},
fe:{"^":"e:0;a",
$1:function(a){return a.T(this.a)}},
fd:{"^":"e:0;a,b,c",
$1:function(a){return a.S(this.a,this.b,this.c)}},
dq:{"^":"a;cq:d<",
T:function(a){return this.a.t(0,W.a6(a))},
S:["bu",function(a,b,c){var z,y
z=W.a6(a)
y=this.c
if(y.t(0,H.b(z)+"::"+b))return this.d.b7(c)
else if(y.t(0,"*::"+b))return this.d.b7(c)
else{y=this.b
if(y.t(0,H.b(z)+"::"+b))return!0
else if(y.t(0,"*::"+b))return!0
else if(y.t(0,H.b(z)+"::*"))return!0
else if(y.t(0,"*::*"))return!0}return!1}],
bv:function(a,b,c,d){var z,y,x
this.a.R(0,c)
z=b.bn(0,new W.hG())
y=b.bn(0,new W.hH())
this.b.R(0,z)
x=this.c
x.R(0,C.G)
x.R(0,y)}},
hG:{"^":"e:0;",
$1:function(a){return!C.a.t(C.i,a)}},
hH:{"^":"e:0;",
$1:function(a){return C.a.t(C.i,a)}},
fZ:{"^":"dq;e,f,a,b,c,d",
T:function(a){var z,y
if(this.e){z=J.bz(a).a.getAttribute("is")
if(z!=null){y=this.a
return y.t(0,z.toUpperCase())&&y.t(0,W.a6(a))}}return this.f&&this.a.t(0,W.a6(a))},
S:function(a,b,c){if(this.T(a)){if(this.e&&b==="is"&&this.a.t(0,c.toUpperCase()))return!0
return this.bu(a,b,c)}return!1}},
hM:{"^":"dq;e,a,b,c,d",
S:function(a,b,c){if(this.bu(a,b,c))return!0
if(b==="template"&&c==="")return!0
if(J.bz(a).a.getAttribute("template")==="")return this.e.t(0,b)
return!1},
l:{
ac:function(){var z=P.y
z=new W.hM(P.cC(C.n,z),P.G(null,null,null,z),P.G(null,null,null,z),P.G(null,null,null,z),null)
z.bv(null,new H.az(C.n,new W.hN(),[null,null]),["TEMPLATE"],null)
return z}}},
hN:{"^":"e:0;",
$1:function(a){return"TEMPLATE::"+H.b(a)}},
hK:{"^":"a;",
T:function(a){var z=J.r(a)
if(!!z.$iscR)return!1
z=!!z.$isp
if(z&&W.a6(a)==="foreignObject")return!1
if(z)return!0
return!1},
S:function(a,b,c){if(b==="is"||C.d.cQ(b,"on"))return!1
return this.T(a)}},
ct:{"^":"a;a,b,c,d",
k:function(){var z,y
z=this.c+1
y=this.b
if(z<y){this.d=J.j(this.a,z)
this.c=z
return!0}this.d=null
this.c=y
return!1},
gn:function(){return this.d}},
X:{"^":"a;"},
dp:{"^":"a;a,b",
b7:function(a){var z,y,x,w,v
z=this.a
z.href=a
y=z.hostname
x=this.b
w=x.hostname
if(y==null?w==null:y===w){w=z.port
v=x.port
if(w==null?v==null:w===v){w=z.protocol
x=x.protocol
x=w==null?x==null:w===x}else x=!1}else x=!1
if(!x)if(y==="")if(z.port===""){z=z.protocol
z=z===":"||z===""}else z=!1
else z=!1
else z=!0
return z}},
ds:{"^":"a;a",
bq:function(a){new W.hO(this).$2(a,null)},
ad:function(a,b){var z
if(b==null){z=a.parentNode
if(z!=null)z.removeChild(a)}else b.removeChild(a)},
du:function(a,b){var z,y,x,w,v,u,t,s
z=!0
y=null
x=null
try{y=J.bz(a)
x=y.gdj().getAttribute("is")
w=function(c){if(!(c.attributes instanceof NamedNodeMap))return true
var r=c.childNodes
if(c.lastChild&&c.lastChild!==r[r.length-1])return true
if(c.children)if(!(c.children instanceof HTMLCollection||c.children instanceof NodeList))return true
var q=0
if(c.children)q=c.children.length
for(var p=0;p<q;p++){var o=c.children[p]
if(o.id=='attributes'||o.name=='attributes'||o.id=='lastChild'||o.name=='lastChild'||o.id=='children'||o.name=='children')return true}return false}(a)
z=w===!0?!0:!(a.attributes instanceof NamedNodeMap)}catch(t){H.x(t)}v="element unprintable"
try{v=J.W(a)}catch(t){H.x(t)}try{u=W.a6(a)
this.dt(a,b,z,v,u,y,x)}catch(t){if(H.x(t) instanceof P.a2)throw t
else{this.ad(a,b)
window
s="Removing corrupted element "+H.b(v)
if(typeof console!="undefined")console.warn(s)}}},
dt:function(a,b,c,d,e,f,g){var z,y,x,w,v
if(c){this.ad(a,b)
window
z="Removing element due to corrupted attributes on <"+d+">"
if(typeof console!="undefined")console.warn(z)
return}if(!this.a.T(a)){this.ad(a,b)
window
z="Removing disallowed element <"+H.b(e)+"> from "+J.W(b)
if(typeof console!="undefined")console.warn(z)
return}if(g!=null)if(!this.a.S(a,"is",g)){this.ad(a,b)
window
z="Removing disallowed type extension <"+H.b(e)+' is="'+g+'">'
if(typeof console!="undefined")console.warn(z)
return}z=f.ga8()
y=H.q(z.slice(),[H.I(z,0)])
for(x=f.ga8().length-1,z=f.a;x>=0;--x){if(x>=y.length)return H.c(y,x)
w=y[x]
if(!this.a.S(a,J.cd(w),z.getAttribute(w))){window
v="Removing disallowed attribute <"+H.b(e)+" "+w+'="'+H.b(z.getAttribute(w))+'">'
if(typeof console!="undefined")console.warn(v)
z.getAttribute(w)
z.removeAttribute(w)}}if(!!J.r(a).$iscW)this.bq(a.content)}},
hO:{"^":"e:16;a",
$2:function(a,b){var z,y,x,w,v
x=this.a
switch(a.nodeType){case 1:x.du(a,b)
break
case 8:case 11:case 3:case 4:break
default:x.ad(a,b)}z=a.lastChild
for(x=a==null;null!=z;){y=null
try{y=J.dV(z)}catch(w){H.x(w)
v=z
if(x){if(J.dU(v)!=null)v.parentNode.removeChild(v)}else a.removeChild(v)
z=null
y=a.lastChild}if(z!=null)this.$2(z,a)
z=y}}}}],["","",,P,{"^":""}],["","",,P,{"^":"",hp:{"^":"a;",
J:function(a){var z=J.a_(a)
if(z.aL(a,0)||z.W(a,4294967296))throw H.d(P.fm("max must be in range 0 < max \u2264 2^32, was "+H.b(a)))
return Math.random()*a>>>0}}}],["","",,P,{"^":"",iD:{"^":"aN;",$isf:1,"%":"SVGAElement"},iF:{"^":"p;",$isf:1,"%":"SVGAnimateElement|SVGAnimateMotionElement|SVGAnimateTransformElement|SVGAnimationElement|SVGSetElement"},iQ:{"^":"p;",$isf:1,"%":"SVGFEBlendElement"},iR:{"^":"p;",$isf:1,"%":"SVGFEColorMatrixElement"},iS:{"^":"p;",$isf:1,"%":"SVGFEComponentTransferElement"},iT:{"^":"p;",$isf:1,"%":"SVGFECompositeElement"},iU:{"^":"p;",$isf:1,"%":"SVGFEConvolveMatrixElement"},iV:{"^":"p;",$isf:1,"%":"SVGFEDiffuseLightingElement"},iW:{"^":"p;",$isf:1,"%":"SVGFEDisplacementMapElement"},iX:{"^":"p;",$isf:1,"%":"SVGFEFloodElement"},iY:{"^":"p;",$isf:1,"%":"SVGFEGaussianBlurElement"},iZ:{"^":"p;",$isf:1,"%":"SVGFEImageElement"},j_:{"^":"p;",$isf:1,"%":"SVGFEMergeElement"},j0:{"^":"p;",$isf:1,"%":"SVGFEMorphologyElement"},j1:{"^":"p;",$isf:1,"%":"SVGFEOffsetElement"},j2:{"^":"p;",$isf:1,"%":"SVGFESpecularLightingElement"},j3:{"^":"p;",$isf:1,"%":"SVGFETileElement"},j4:{"^":"p;",$isf:1,"%":"SVGFETurbulenceElement"},j6:{"^":"p;",$isf:1,"%":"SVGFilterElement"},aN:{"^":"p;",$isf:1,"%":"SVGCircleElement|SVGClipPathElement|SVGDefsElement|SVGEllipseElement|SVGForeignObjectElement|SVGGElement|SVGGeometryElement|SVGLineElement|SVGPathElement|SVGPolygonElement|SVGPolylineElement|SVGRectElement|SVGSwitchElement;SVGGraphicsElement"},ja:{"^":"aN;",$isf:1,"%":"SVGImageElement"},ji:{"^":"p;",$isf:1,"%":"SVGMarkerElement"},jj:{"^":"p;",$isf:1,"%":"SVGMaskElement"},jB:{"^":"p;",$isf:1,"%":"SVGPatternElement"},cR:{"^":"p;",$iscR:1,$isf:1,"%":"SVGScriptElement"},p:{"^":"ag;",
scd:function(a,b){this.ab(a,b)},
B:function(a,b,c,d){var z,y,x,w,v,u
if(d==null){z=H.q([],[W.X])
d=new W.a8(z)
z.push(W.aa(null))
z.push(W.ac())
z.push(new W.hK())}c=new W.ds(d)
y='<svg version="1.1">'+b+"</svg>"
z=document
x=z.body
w=(x&&C.h).dI(x,y,c)
v=z.createDocumentFragment()
w.toString
z=new W.Q(w)
u=z.ga1(z)
for(;z=u.firstChild,z!=null;)v.appendChild(z)
return v},
gcg:function(a){return new W.dg(a,"click",!1,[W.fb])},
$isp:1,
$isf:1,
"%":"SVGComponentTransferFunctionElement|SVGDescElement|SVGDiscardElement|SVGFEDistantLightElement|SVGFEFuncAElement|SVGFEFuncBElement|SVGFEFuncGElement|SVGFEFuncRElement|SVGFEMergeNodeElement|SVGFEPointLightElement|SVGFESpotLightElement|SVGMetadataElement|SVGStopElement|SVGStyleElement|SVGTitleElement;SVGElement"},jI:{"^":"aN;",$isf:1,"%":"SVGSVGElement"},jJ:{"^":"p;",$isf:1,"%":"SVGSymbolElement"},fC:{"^":"aN;","%":"SVGTSpanElement|SVGTextElement|SVGTextPositioningElement;SVGTextContentElement"},jN:{"^":"fC;",$isf:1,"%":"SVGTextPathElement"},jO:{"^":"aN;",$isf:1,"%":"SVGUseElement"},jP:{"^":"p;",$isf:1,"%":"SVGViewElement"},jZ:{"^":"p;",$isf:1,"%":"SVGGradientElement|SVGLinearGradientElement|SVGRadialGradientElement"},k3:{"^":"p;",$isf:1,"%":"SVGCursorElement"},k4:{"^":"p;",$isf:1,"%":"SVGFEDropShadowElement"},k5:{"^":"p;",$isf:1,"%":"SVGMPathElement"}}],["","",,P,{"^":""}],["","",,P,{"^":""}],["","",,P,{"^":""}],["","",,E,{"^":"",ce:{"^":"a;a,b,c,d",
gcD:function(){return this.d},
K:function(){return"<div class='ammunition' style='left: "+this.b+"vw; top:"+H.b(this.a)+"vh;'></div>"}},eb:{"^":"a;a",
K:function(){return"<div class='coin' style='top: "+H.b(this.a)+"vh;'></div>"}},b7:{"^":"a;a,b,c",
dE:function(a){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
z=new W.O(document.querySelectorAll(".enemy"),[null])
for(y=new H.S(z,z.gj(z),0,null);y.k();){x=y.d
w=J.m(x)
J.n(J.aL(w.a9(x)))
v=w.a9(x)
w=J.m(v)
u=J.n(w.gA(v))
t=J.n(w.gA(v))+J.n(w.gD(v))
s=J.n(w.gF(v))
r=J.n(w.gU(v))
for(w=new H.S(a,a.gj(a),0,null);w.k();){q=w.d
p=J.m(q)
o=p.a9(q)
n=J.m(o)
m=J.n(n.gA(o))
l=J.n(n.gF(o))
k=J.n(n.gU(o))
j=J.n(n.gaA(o))
if(!(u>m&&u<j))n=t<j&&t>m
else n=!0
if(n)if(!(r>l&&r<k))n=s<k&&s>l
else n=!0
else n=!1
if(n){p.sc7(q,"hide")
return!0}}}return!1}},el:{"^":"a;a,b,c",
cP:function(){var z,y
z=document
z.querySelector("#loadingscreen").className="hide"
y=J.at(z.querySelector("#gameoverscreen"))
W.Z(y.a,y.b,new E.en(),!1,H.I(y,0))
y=J.at(z.querySelector("#startbutton"))
W.Z(y.a,y.b,new E.eo(this),!1,H.I(y,0))
y=J.at(z.querySelector("#howtobutton"))
W.Z(y.a,y.b,new E.ep(this),!1,H.I(y,0))
y=J.at(z.querySelector("#howtoscreen"))
W.Z(y.a,y.b,new E.eq(this),!1,H.I(y,0))
y=J.at(z.querySelector("#right"))
W.Z(y.a,y.b,new E.er(this),!1,H.I(y,0))
z=J.at(z.querySelector("#left"))
W.Z(z.a,z.b,new E.es(this),!1,H.I(z,0))}},en:{"^":"e:0;",
$1:function(a){window.location.assign(window.location.href)}},eo:{"^":"e:17;a",
$1:function(a){var z=0,y=new P.b6(),x=1,w,v=this,u
var $async$$1=P.bn(function(b,c){if(b===1){w=c
z=x}while(true)switch(z){case 0:u=v.a
z=2
return P.A(u.b.a2(),$async$$1,y)
case 2:document.querySelector("#screentext").className="hide"
u.c=P.fJ(P.ef(0,0,0,50,0,0),new E.em(u))
return P.A(null,0,y)
case 1:return P.A(w,1,y)}})
return P.A(null,$async$$1,y)}},em:{"^":"e:18;a",
$1:function(a){var z,y,x,w,v,u
z=this.a
if(z.a.r===!0){z.c.af()
y=document
x=y.querySelector("#flappytoken").style
x.backgroundImage="url('images/flappydead.png')"
y.querySelector("#gameoverwrapper").className="show"
y=z.a
y.r=!1
y.x=!1
y.y=H.q([],[E.b7])
y.f=H.q([],[E.be])
y.bc(1)
y.ch=!1
y.Q=!1
y.a=0
y.b=0
y.be()
y.bd()
y.bb()
z.b.a2()}if(z.b.e7()){z.c.af()
y=z.a
y.x=!1
y.y=H.q([],[E.b7])
y.f=H.q([],[E.be])
y.ch=!1
y.Q=!1
x=y.a
w=y.b
if(typeof x!=="number")return x.H()
if(typeof w!=="number")return H.u(w)
y.a=x+w
y.bc(J.ae(y.e,2))
y.bd()
y.bb()
y.be()
z.b.a2()}z=z.b
z.a.ee()
y=z.a.c
y.toString
x=document
v=x.querySelector("#flappytoken").style.top
u=H.aV(C.d.X(v,0,v.length-2),null)
w=J.a_(u)
if(w.aq(u,95)){u=w.H(u,y.d)
if(J.by(u,95))u=95}y=x.querySelector("#flappytoken").style
w=H.b(u)+"vh"
y.top=w
z.dR()
z.dC()
y=x.querySelector("#score")
z=z.a
x=z.b
z=z.a
if(typeof x!=="number")return x.H()
if(typeof z!=="number")return H.u(z)
J.e2(y,""+(x+z))
return}},ep:{"^":"e:0;a",
$1:function(a){document.querySelector("#howtoscreen").className="show"}},eq:{"^":"e:0;a",
$1:function(a){document.querySelector("#howtoscreen").className="hide"}},er:{"^":"e:0;a",
$1:function(a){var z=this.a.a
if(z.r===!1&&z.x===!1)z.c.cO()}},es:{"^":"e:0;a",
$1:function(a){var z,y,x,w,v
z=this.a.a
if(z.r===!1&&z.x===!1){z=z.c
z.toString
y=document
x=y.querySelector("#flappytoken").style.top
w=H.aV(C.d.X(x,0,x.length-2),null)
v=J.a_(w)
if(v.W(w,0)){w=v.a3(w,z.c)
if(J.ca(w,0))w=0}z=y.querySelector("#flappytoken").style
y=H.b(w)+"vh"
z.top=y}}},et:{"^":"a;a,b,c,d,e,f,r,x,y,z,Q,ch,cx",
ax:function(){var z=0,y=new P.b6(),x=1,w,v=this,u
var $async$ax=P.bn(function(a,b){if(a===1){w=b
z=x}while(true)switch(z){case 0:v.r=!1
v.x=!1
v.d=H.q([],[E.cB])
v.y=H.q([],[E.b7])
z=2
return P.A(v.aD(),$async$ax,y)
case 2:v.bc(1)
v.a=0
v.b=0
v.ch=!1
v.Q=!1
v.z=H.q([],[E.fk])
u=new E.ev(null,null,null,null,null)
u.a=H.q([],[E.ce])
u.c=5
u.d=0.5
u.e=10
v.c=u
v.f=H.q([],[E.be])
v.bd()
v.bb()
v.be()
return P.A(null,0,y)
case 1:return P.A(w,1,y)}})
return P.A(null,$async$ax,y)},
aD:function(){var z=0,y=new P.b6(),x=1,w,v=this,u
var $async$aD=P.bn(function(a,b){if(a===1){w=b
z=x}while(true)switch(z){case 0:u={}
u.a=null
u.b=null
u.c=null
u.d=null
u.e=null
u.f=null
u.r=null
u.x=null
u.y=null
u.z=null
u.Q=null
u.ch=null
u.cx=null
u.cy=null
z=2
return P.A(W.ez("levels.json",null,null).bj(new E.eu(u,v)),$async$aD,y)
case 2:return P.A(null,0,y)
case 1:return P.A(w,1,y)}})
return P.A(null,$async$aD,y)},
bc:function(a){var z,y
z=this.d
y=J.a0(a,1)
if(y>>>0!==y||y>=z.length)return H.c(z,y)
this.e=J.a0(z[y].gcA(),1)},
bb:function(){var z,y,x,w,v
z=0
while(!0){y=this.d
x=this.e
if(x>>>0!==x||x>=y.length)return H.c(y,x)
x=y[x].gaI()
if(typeof x!=="number")return H.u(x)
if(!(z<x))break
y=this.y
x=this.d
w=this.e
if(w>>>0!==w||w>=x.length)return H.c(x,w)
w=x[w].gcv()
x=this.d
v=this.e
if(v>>>0!==v||v>=x.length)return H.c(x,v)
v=x[v].gcw()
x=new E.b7(null,null,null)
x.a=w
x.b=v
x.c=C.c.aH(C.e.J(94))
y.push(x);++z}},
be:function(){var z,y,x,w
z=null
y=0
while(!0){x=this.d
w=this.e
if(w>>>0!==w||w>=x.length)return H.c(x,w)
w=x[w].gaK()
if(typeof w!=="number")return H.u(w)
if(!(y<w))break
switch(C.e.J(3)){case 0:z=new E.eb(null)
z.a=C.c.aH(C.e.J(94))+25
break
case 1:z=new E.ft(null)
z.a=C.c.aH(C.e.J(44))+25
break
case 2:z=new E.fu(null)
z.a=C.c.aH(C.e.J(44))+25
break}this.z.push(z);++y}},
bd:function(){var z,y,x,w,v
z=0
while(!0){y=this.d
x=this.e
if(x>>>0!==x||x>=y.length)return H.c(y,x)
x=y[x].gcB()
if(typeof x!=="number")return H.u(x)
if(!(z<x))break
y=this.f
x=this.d
w=this.e
if(w>>>0!==w||w>=x.length)return H.c(x,w)
w=x[w].gbp()
x=this.d
v=this.e
if(v>>>0!==v||v>=x.length)return H.c(x,v)
v=x[v].gbo()
x=new E.be(null,null,null)
w=C.e.J(w)+30
x.a=w
x.b=C.e.J(100-w)
x.c=v
y.push(x);++z}},
ee:function(){var z,y,x,w,v,u,t
z=this.cx
if(z!=null)if(z.b==null){y=$.N.$0()
if(J.by(J.cb(J.b2(J.a0(y,z.a),1000),$.aB),1e4)&&this.ch===!0){z=this.cx
y=z.b
z.a=y==null?$.N.$0():y
this.ch=!1
z=this.cx
if(z.b==null)z.b=$.N.$0()
z=document.querySelector("#flappytoken").style
z.backgroundImage="url('images/flappytoken.gif')"}z=this.cx
y=z.b
if(y==null)y=$.N.$0()
if(J.by(J.cb(J.b2(J.a0(y,z.a),1000),$.aB),2000)&&this.Q===!0){z=this.cx
y=z.b
z.a=y==null?$.N.$0():y
this.Q=!1
z=this.cx
if(z.b==null)z.b=$.N.$0()
z=document.querySelector("#flappytoken").style
z.backgroundImage="url('images/flappytoken.gif')"}}this.e1()
z=document
x=z.querySelector("#pipearea").style.marginLeft
w=H.aV(C.d.X(x,0,x.length-2),null)
y=this.d
v=this.e
if(v>>>0!==v||v>=y.length)return H.c(y,v)
v=y[v].gcz()
if(typeof v!=="number")return H.u(v)
w=J.a0(w,10*v)
v=z.querySelector("#pipearea").style
y=H.b(w)+"px"
v.marginLeft=y
for(y=[null],u=0;v=this.y,t=v.length,u<t;++u)if(t!==0){if(u<0)return H.c(v,u)
if(v[u].dE(new W.O(z.querySelectorAll(".ammunition"),y))){v=this.y
if(u>=v.length)return H.c(v,u)
v=v[u]
v.a=J.a0(v.a,1)
v=this.y
if(u>=v.length)return H.c(v,u)
if(J.V(v[u].a,0)){v=this.y;(v&&C.a).aG(v,u)
v=z.querySelectorAll(".enemy")
if(u>=v.length)return H.c(v,u)
J.aM(v[u],"hide")
v=z.querySelectorAll(".enemywrapper")
if(u>=v.length)return H.c(v,u)
J.aM(v[u],"hide");--u}}}for(u=0;u<this.z.length;++u){if(this.c.aF(new W.O(z.querySelectorAll(".coin"),y))){v=this.z;(v&&C.a).aG(v,u)
v=z.querySelectorAll(".powerupwrapper")
if(u<0||u>=v.length)return H.c(v,u)
J.aM(v[u],"hide");--u
v=this.a
if(typeof v!=="number")return v.H()
this.a=v+10}if(this.c.aF(new W.O(z.querySelectorAll(".shield"),y))){v=this.z;(v&&C.a).aG(v,u)
v=z.querySelectorAll(".powerupwrapper")
if(u<0||u>=v.length)return H.c(v,u)
J.aM(v[u],"hide");--u
this.Q=!0
this.ch=!1
v=this.cx
if(v!=null){t=v.b
v.a=t==null?$.N.$0():t
v=this.cx
if(v.b==null)v.b=$.N.$0()}v=z.querySelector("#flappytoken").style
v.backgroundImage="url('images/Flappyarm.gif')"}if(this.c.aF(new W.O(z.querySelectorAll(".star"),y))){v=this.z;(v&&C.a).aG(v,u)
v=z.querySelectorAll(".powerupwrapper")
if(u<0||u>=v.length)return H.c(v,u)
J.aM(v[u],"hide");--u
v=new P.cT(0,0)
if($.aB==null){H.cL()
$.aB=$.aW}this.cx=v
t=J.a0($.N.$0(),v.b)
if(typeof t!=="number")return H.u(t)
v.a=0+t
v.b=null
this.ch=!0
this.Q=!1
v=z.querySelector("#flappytoken").style
v.backgroundImage="url('images/Flappystar.gif')"}}if(this.ch!==!0)if(this.c.cj(new W.O(z.querySelectorAll(".spacebetweenpipes"),y))||this.c.cj(new W.O(z.querySelectorAll(".spacebetweenpipes_moveable"),y))||this.c.aF(new W.O(z.querySelectorAll(".enemy"),y))||this.c.cE())if(this.Q!==!0)this.r=!0
else{z=this.cx
if(z!=null)z.bs(0)
else{z=new P.cT(0,0)
if($.aB==null){H.cL()
$.aB=$.aW}this.cx=z
z.bs(0)}}},
e1:function(){var z,y,x,w
this.b=0
z=this.d
y=this.e
if(y>>>0!==y||y>=z.length)return H.c(z,y)
x=[null]
w=z[y].gbo()===!0?new W.O(document.querySelectorAll(".spacebetweenpipes_moveable"),x):new W.O(document.querySelectorAll(".spacebetweenpipes"),x)
for(z=new H.S(w,w.gj(w),0,null);z.k();)if(J.n(J.dR(J.b3(z.d)))<0){y=this.b
if(typeof y!=="number")return y.H()
this.b=y+1}},
K:function(){var z,y,x,w,v,u,t
z=this.d
y=this.e
if(y>>>0!==y||y>=z.length)return H.c(z,y)
x=z[y].gaI()
y=this.d
z=this.e
if(z>>>0!==z||z>=y.length)return H.c(y,z)
w=y[z].gaK()
for(v="<div id='pipearea' style='margin-left: 200px ; width: 0px'>",u=0;z=this.f,u<z.length;){v+=z[u].K()
z=C.e.J(100)
y=J.br(x);++u
t=J.b2(y.aa(x,1/this.f.length),u)
if(typeof t!=="number")return H.u(t)
if(z/100<t&&y.W(x,0)){v+="<div class='enemywrapper'></div>"
x=y.a3(x,1)}z=C.e.J(100)
y=J.br(w)
t=J.b2(y.aa(w,1/this.f.length),u)
if(typeof t!=="number")return H.u(t)
if(z/100<t&&y.W(w,0)){v+="<div class='powerupwrapper'></div>"
w=y.a3(w,1)}}return v+"<div id='lvlend'></div></div>"}},eu:{"^":"e:0;a,b",
$1:function(a){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j
z=C.C.dJ(a)
y=this.a
y.a=z
y.b=J.j(z,"levelcount")
x=this.b
w=0
while(!0){v=y.b
if(typeof v!=="number")return H.u(v)
if(!(w<v))break
y.c=J.j(J.j(J.j(y.a,"level"),w),"lvlnr")
y.d=J.j(J.j(J.j(y.a,"level"),w),"gamespeed")
y.e=J.j(J.j(J.j(y.a,"level"),w),"spacebetweenpipes")
y.f=J.j(J.j(J.j(y.a,"level"),w),"pipeimg")
y.r=J.j(J.j(J.j(y.a,"level"),w),"bgndimg")
y.x=J.j(J.j(J.j(y.a,"level"),w),"enemycount")
y.y=J.j(J.j(J.j(y.a,"level"),w),"enemylife")
y.z=J.j(J.j(J.j(y.a,"level"),w),"enemyspeed")
y.Q=J.j(J.j(J.j(y.a,"level"),w),"enemyimg")
y.ch=J.j(J.j(J.j(y.a,"level"),w),"pipecount")
y.cx=J.j(J.j(J.j(y.a,"level"),w),"pipemovement")
u=J.j(J.j(J.j(y.a,"level"),w),"powerupcount")
y.cy=u
v=y.c
t=y.d
s=y.e
r=y.f
q=y.r
p=y.x
o=y.y
n=y.z
m=y.Q
l=y.ch
k=y.cx
j=new E.cB(null,null,null,null,null,null,null,null,null,null,null,null)
j.a=v
j.b=t
j.c=s
j.d=r
j.e=q
j.f=p
j.r=o
j.x=n
j.y=m
j.z=l
j.Q=k
j.ch=u
x.d.push(j);++w}}},ev:{"^":"a;a,b,c,d,e",
cO:function(){var z,y,x,w,v,u
z=document
y=z.querySelector("#flappytoken").style.top
x=H.aV(C.d.X(y,0,y.length-2),null)
z.querySelector("#flappytoken").style.left
for(z=this.a,w=z.length,v=0;v<z.length;z.length===w||(0,H.bx)(z),++v){u=z[v]
if(u.gcD()){u.a=x
u.d=!1
u.b=4
break}}},
cj:function(a){var z,y,x,w,v,u,t,s,r,q,p,o,n,m
z=document
y=J.n(J.aL(z.querySelector("#flappytoken").getBoundingClientRect()))
x=z.querySelector("#flappytoken").getBoundingClientRect()
z=J.m(x)
w=J.n(z.gA(x))
v=J.n(z.gA(x))+J.n(z.gD(x))
u=J.n(z.gF(x))
t=J.n(z.gU(x))
for(z=new H.S(a,a.gj(a),0,null),s=t-y;z.k();){r=J.b3(z.d)
q=J.m(r)
p=J.n(q.gaA(r))
o=J.n(q.gA(r))
n=J.n(q.gF(r))
m=J.n(q.gU(r))
if(w<o||v>p)if(!(t>n&&s<m))q=u<m&&u>n
else q=!0
else q=!1
if(q)return!0}return!1},
cE:function(){var z=document.querySelector("#flappytoken").style.top
if(J.dN(H.aV(C.d.X(z,0,z.length-2),null),94))return!0
else return!1},
aF:function(a){var z,y,x,w,v,u,t,s,r,q,p,o,n,m
z=document
y=J.n(J.aL(z.querySelector("#flappytoken").getBoundingClientRect()))
x=z.querySelector("#flappytoken").getBoundingClientRect()
z=J.m(x)
w=J.n(z.gA(x))
v=J.n(z.gA(x))+J.n(z.gD(x))
u=J.n(z.gF(x))
t=J.n(z.gU(x))
for(z=new H.S(a,a.gj(a),0,null),s=t-y;z.k();){r=J.b3(z.d)
q=J.m(r)
p=J.n(q.gA(r))
o=J.n(q.gF(r))
n=J.n(q.gU(r))
m=J.n(q.gaA(r))
if(!(w>p&&w<m))q=v<m&&v>p
else q=!0
if(q)if(!(t>o&&s<n))q=u<n&&u>o
else q=!0
else q=!1
if(q)return!0}return!1}},ew:{"^":"a;a",
a2:function(){var z=0,y=new P.b6(),x,w=2,v,u=this,t,s,r,q,p,o
var $async$a2=P.bn(function(a,b){if(a===1){v=b
z=w}while(true)switch(z){case 0:t=H.q([],[W.X])
s=new W.a8(t)
t.push(W.aa(null))
t.push(W.ac())
s.a6("div",["style"],null,null)
t=document
J.av(t.querySelector("#pipeareawrapper"),u.a.K(),s)
z=3
return P.A(null,$async$a2,y)
case 3:r=t.querySelectorAll(".pipe")
q=r.length
if(0>=q){x=H.c(r,0)
z=1
break}p=J.aL(J.b3(r[0]))
if(typeof p!=="number"){x=p.H()
z=1
break}r=J.aL(t.querySelector("#lvlend").getBoundingClientRect())
if(typeof r!=="number"){x=H.u(r)
z=1
break}o=t.querySelector("#pipearea").style
r=H.b(q*(p+400)+r)+"px"
o.width=r
u.eb()
u.e8()
u.e9()
u.ea()
u.ec()
r=t.querySelector("#flappytoken").style
r.top="45vh"
t=t.querySelector("#flappytoken").style
t.backgroundImage="url('images/flappytoken.gif')"
case 1:return P.A(x,0,y)
case 2:return P.A(v,1,y)}})
return P.A(null,$async$a2,y)},
e8:function(){var z,y,x,w,v,u,t
z=H.q([],[W.X])
y=new W.a8(z)
z.push(W.aa(null))
z.push(W.ac())
y.a6("div",["style"],null,null)
for(x=0;z=this.a.c,x<z.e;++x){z=z.a
w=new E.ce(null,null,null,null)
w.a=0
w.b=1000
w.c=5
w.d=!0
z.push(w)}for(z=z.a,w=z.length,v="",u=0;u<z.length;z.length===w||(0,H.bx)(z),++u){t=z[u]
v=v+"<div class='ammunitionwrapper'>"+t.K()+"</div>"}J.av(document.querySelector("#ammo"),v,y)},
dC:function(){var z,y,x,w,v,u
z=H.q([],[W.X])
y=new W.a8(z)
z.push(W.aa(null))
z.push(W.ac())
y.a6("div",["style"],null,null)
z=document.querySelectorAll(".ammunitionwrapper")
for(x=0;w=this.a.c,x<w.e;++x){w=w.a
if(x>=w.length)return H.c(w,x)
w=w[x]
v=w.b+w.c
w.b=v
u=z.length
if(v<100){if(x>=u)return H.c(z,x)
J.av(z[x],"<div class='ammunition' style='left: "+v+"vw; top:"+H.b(w.a)+"vh;'></div>",y)}else{if(x>=u)return H.c(z,x)
J.e3(z[x],"")
w=this.a.c.a
if(x>=w.length)return H.c(w,x)
w[x].d=!0}}},
dR:function(){var z,y,x,w,v,u
z=H.q([],[W.X])
y=new W.a8(z)
z.push(W.aa(null))
z.push(W.ac())
y.a6("div",["style"],null,null)
for(z=document,x=0;x<z.querySelectorAll(".enemywrapper").length;++x){w=this.a.y
if(x>=w.length)return H.c(w,x)
w=w[x]
v=w.c
if(v<0){u=w.b
if(typeof u!=="number")return H.u(u)
w.b=-1*u}if(v>=94){u=w.b
if(typeof u!=="number")return H.u(u)
w.b=-1*u}u=w.b
if(typeof u!=="number")return H.u(u)
w.c=v+u
u=z.querySelectorAll(".enemywrapper")
if(x>=u.length)return H.c(u,x)
u=u[x]
v=this.a.y
if(x>=v.length)return H.c(v,x)
J.av(u,"<div class='enemy' style='top: "+H.b(v[x].c)+"vh;'></div>",y)
v=z.querySelectorAll(".enemy")
if(x>=v.length)return H.c(v,x)
v=J.aK(v[x])
u=this.a
w=u.d
u=u.e
if(u>>>0!==u||u>=w.length)return H.c(w,u)
u="url('"+H.b(w[u].gaJ())+"')"
v.backgroundImage=u}},
eb:function(){var z,y,x,w,v,u
z=document
y=new W.O(z.querySelectorAll(".pipe"),[null])
for(x=new H.S(y,y.gj(y),0,null);x.k();){w=J.aK(x.d)
v=this.a
u=v.d
v=v.e
if(v>>>0!==v||v>=u.length)return H.c(u,v)
J.cc(w,"url('"+H.b(u[v].gcC())+"')")}x=z.querySelector("#pipearea").style
w=this.a
v=w.d
w=w.e
if(w>>>0!==w||w>=v.length)return H.c(v,w)
w="url('"+H.b(v[w].gcu())+"')"
x.backgroundImage=w
z.querySelector("#loadingscreen").className="hide"},
e9:function(){var z,y,x,w,v,u
z=H.q([],[W.X])
y=new W.a8(z)
z.push(W.aa(null))
z.push(W.ac())
y.a6("div",["style"],null,null)
z=document.querySelectorAll(".enemywrapper")
x=0
while(!0){w=this.a
v=w.d
w=w.e
if(w>>>0!==w||w>=v.length)return H.c(v,w)
w=v[w].gaI()
if(typeof w!=="number")return H.u(w)
if(!(x<w))break
if(x>=z.length)return H.c(z,x)
w=z[x]
v=this.a.y
if(x>=v.length)return H.c(v,x)
J.av(w,"<div class='enemy' style='top: "+H.b(v[x].c)+"vh;'></div>",y)
if(x>=z.length)return H.c(z,x)
v=J.aK(z[x])
w=this.a
u=w.d
w=w.e
if(w>>>0!==w||w>=u.length)return H.c(u,w)
w=u[w].gaJ()
v.toString
v.backgroundImage=w==null?"":w;++x}},
ec:function(){var z,y,x,w,v
z=H.q([],[W.X])
y=new W.a8(z)
z.push(W.aa(null))
z.push(W.ac())
y.a6("div",["style"],null,null)
z=document.querySelectorAll(".powerupwrapper")
x=0
while(!0){w=this.a
v=w.d
w=w.e
if(w>>>0!==w||w>=v.length)return H.c(v,w)
w=v[w].gaK()
if(typeof w!=="number")return H.u(w)
if(!(x<w))break
if(x>=z.length)return H.c(z,x)
w=z[x]
v=this.a.z
if(x>=v.length)return H.c(v,x)
J.av(w,v[x].K(),y);++x}},
ea:function(){var z,y,x,w,v
z=new W.O(document.querySelectorAll(".enemy"),[null])
for(y=new H.S(z,z.gj(z),0,null);y.k();){x=J.aK(y.d)
w=this.a
v=w.d
w=w.e
if(w>>>0!==w||w>=v.length)return H.c(v,w)
J.cc(x,"url('"+H.b(v[w].gaJ())+"')")}},
e7:function(){var z,y
z=document
y=J.dX(z.querySelector("#pipearea").getBoundingClientRect())
if(typeof y!=="number")return y.a3()
if(y-1500<=0){this.a.x=!0
z.querySelector("#screentext").className="show"
return!0}return!1}},cB:{"^":"a;a,b,c,d,e,f,r,x,y,z,Q,ch",
gbo:function(){return this.Q},
gaK:function(){return this.ch},
gcv:function(){return this.r},
gcw:function(){return this.x},
gcA:function(){return this.a},
gcz:function(){return this.b},
gbp:function(){return this.c},
gcC:function(){return this.d},
gcu:function(){return this.e},
gaI:function(){return this.f},
gcB:function(){return this.z},
gaJ:function(){return this.y}},be:{"^":"a;a,b,c",
gbp:function(){return this.a},
K:function(){var z,y
z=this.c
y=this.a
if(z===!0)return"<div class='pipe'><div class='spacebetweenpipes_moveable' style='height: "+H.b(y)+"vh; margin-top: "+H.b(this.b)+"vh'></div></div>"
else return"<div class='pipe'><div class='spacebetweenpipes' style='height: "+H.b(y)+"vh; margin-top: "+H.b(this.b)+"vh'></div></div>"}},fk:{"^":"a;"},ft:{"^":"a;a",
K:function(){return"<div class='shield' style='top: "+H.b(this.a)+"vh;'></div>"}},fu:{"^":"a;a",
K:function(){return"<div class='star' style='top: "+H.b(this.a)+"vh;'></div>"}}}],["","",,F,{"^":"",
k9:[function(){var z,y,x
z=new E.el(null,null,null)
y=new E.et(null,null,null,null,null,null,null,null,null,null,null,null,null)
y.ax()
z.a=y
x=new E.ew(null)
x.a=y
z.b=x
z.cP()},"$0","dH",0,0,2]},1]]
setupProgram(dart,0)
J.r=function(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.cz.prototype
return J.eW.prototype}if(typeof a=="string")return J.aS.prototype
if(a==null)return J.eX.prototype
if(typeof a=="boolean")return J.eV.prototype
if(a.constructor==Array)return J.aQ.prototype
if(typeof a!="object"){if(typeof a=="function")return J.aT.prototype
return a}if(a instanceof P.a)return a
return J.bs(a)}
J.U=function(a){if(typeof a=="string")return J.aS.prototype
if(a==null)return a
if(a.constructor==Array)return J.aQ.prototype
if(typeof a!="object"){if(typeof a=="function")return J.aT.prototype
return a}if(a instanceof P.a)return a
return J.bs(a)}
J.bq=function(a){if(a==null)return a
if(a.constructor==Array)return J.aQ.prototype
if(typeof a!="object"){if(typeof a=="function")return J.aT.prototype
return a}if(a instanceof P.a)return a
return J.bs(a)}
J.a_=function(a){if(typeof a=="number")return J.aR.prototype
if(a==null)return a
if(!(a instanceof P.a))return J.aZ.prototype
return a}
J.br=function(a){if(typeof a=="number")return J.aR.prototype
if(typeof a=="string")return J.aS.prototype
if(a==null)return a
if(!(a instanceof P.a))return J.aZ.prototype
return a}
J.ic=function(a){if(typeof a=="string")return J.aS.prototype
if(a==null)return a
if(!(a instanceof P.a))return J.aZ.prototype
return a}
J.m=function(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.aT.prototype
return a}if(a instanceof P.a)return a
return J.bs(a)}
J.ae=function(a,b){if(typeof a=="number"&&typeof b=="number")return a+b
return J.br(a).H(a,b)}
J.V=function(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.r(a).p(a,b)}
J.dN=function(a,b){if(typeof a=="number"&&typeof b=="number")return a>=b
return J.a_(a).ap(a,b)}
J.by=function(a,b){if(typeof a=="number"&&typeof b=="number")return a>b
return J.a_(a).W(a,b)}
J.ca=function(a,b){if(typeof a=="number"&&typeof b=="number")return a<b
return J.a_(a).aq(a,b)}
J.b2=function(a,b){if(typeof a=="number"&&typeof b=="number")return a*b
return J.br(a).aa(a,b)}
J.a0=function(a,b){if(typeof a=="number"&&typeof b=="number")return a-b
return J.a_(a).a3(a,b)}
J.cb=function(a,b){return J.a_(a).aP(a,b)}
J.j=function(a,b){if(typeof b==="number")if(a.constructor==Array||typeof a=="string"||H.iu(a,a[init.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.U(a).h(a,b)}
J.dO=function(a,b,c,d){return J.m(a).dB(a,b,c,d)}
J.dP=function(a,b){return J.m(a).aB(a,b)}
J.dQ=function(a,b){return J.bq(a).I(a,b)}
J.bz=function(a){return J.m(a).gdD(a)}
J.aH=function(a){return J.m(a).gZ(a)}
J.a1=function(a){return J.r(a).gu(a)}
J.aI=function(a){return J.bq(a).gv(a)}
J.dR=function(a){return J.m(a).gF(a)}
J.aJ=function(a){return J.U(a).gj(a)}
J.dS=function(a){return J.m(a).gw(a)}
J.dT=function(a){return J.m(a).gef(a)}
J.at=function(a){return J.m(a).gcg(a)}
J.dU=function(a){return J.m(a).geh(a)}
J.dV=function(a){return J.m(a).gei(a)}
J.dW=function(a){return J.m(a).geo(a)}
J.dX=function(a){return J.m(a).gU(a)}
J.aK=function(a){return J.m(a).gbt(a)}
J.dY=function(a){return J.m(a).ges(a)}
J.aL=function(a){return J.m(a).gV(a)}
J.b3=function(a){return J.m(a).a9(a)}
J.dZ=function(a,b){return J.bq(a).a0(a,b)}
J.e_=function(a){return J.bq(a).ek(a)}
J.e0=function(a,b,c,d){return J.m(a).em(a,b,c,d)}
J.au=function(a,b){return J.m(a).ar(a,b)}
J.cc=function(a,b){return J.m(a).sc2(a,b)}
J.aM=function(a,b){return J.m(a).sc7(a,b)}
J.e1=function(a,b){return J.m(a).saC(a,b)}
J.e2=function(a,b){return J.m(a).scd(a,b)}
J.e3=function(a,b){return J.m(a).ab(a,b)}
J.av=function(a,b,c){return J.m(a).aN(a,b,c)}
J.n=function(a){return J.a_(a).eu(a)}
J.cd=function(a){return J.ic(a).ev(a)}
J.W=function(a){return J.r(a).i(a)}
I.aq=function(a){a.immutable$list=Array
a.fixed$length=Array
return a}
var $=I.p
C.h=W.bB.prototype
C.t=W.aO.prototype
C.u=J.f.prototype
C.a=J.aQ.prototype
C.c=J.cz.prototype
C.f=J.aR.prototype
C.d=J.aS.prototype
C.B=J.aT.prototype
C.o=J.fj.prototype
C.p=W.fB.prototype
C.j=J.aZ.prototype
C.q=new P.fi()
C.r=new P.h0()
C.e=new P.hp()
C.b=new P.hC()
C.k=new P.a4(0)
C.v=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
C.w=function(hooks) {
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
C.l=function(hooks) { return hooks; }

C.x=function(getTagFallback) {
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
C.y=function() {
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
C.z=function(hooks) {
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
C.A=function(hooks) {
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
C.m=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
C.C=new P.f2(null,null)
C.D=new P.f3(null)
C.E=H.q(I.aq(["*::class","*::dir","*::draggable","*::hidden","*::id","*::inert","*::itemprop","*::itemref","*::itemscope","*::lang","*::spellcheck","*::title","*::translate","A::accesskey","A::coords","A::hreflang","A::name","A::shape","A::tabindex","A::target","A::type","AREA::accesskey","AREA::alt","AREA::coords","AREA::nohref","AREA::shape","AREA::tabindex","AREA::target","AUDIO::controls","AUDIO::loop","AUDIO::mediagroup","AUDIO::muted","AUDIO::preload","BDO::dir","BODY::alink","BODY::bgcolor","BODY::link","BODY::text","BODY::vlink","BR::clear","BUTTON::accesskey","BUTTON::disabled","BUTTON::name","BUTTON::tabindex","BUTTON::type","BUTTON::value","CANVAS::height","CANVAS::width","CAPTION::align","COL::align","COL::char","COL::charoff","COL::span","COL::valign","COL::width","COLGROUP::align","COLGROUP::char","COLGROUP::charoff","COLGROUP::span","COLGROUP::valign","COLGROUP::width","COMMAND::checked","COMMAND::command","COMMAND::disabled","COMMAND::label","COMMAND::radiogroup","COMMAND::type","DATA::value","DEL::datetime","DETAILS::open","DIR::compact","DIV::align","DL::compact","FIELDSET::disabled","FONT::color","FONT::face","FONT::size","FORM::accept","FORM::autocomplete","FORM::enctype","FORM::method","FORM::name","FORM::novalidate","FORM::target","FRAME::name","H1::align","H2::align","H3::align","H4::align","H5::align","H6::align","HR::align","HR::noshade","HR::size","HR::width","HTML::version","IFRAME::align","IFRAME::frameborder","IFRAME::height","IFRAME::marginheight","IFRAME::marginwidth","IFRAME::width","IMG::align","IMG::alt","IMG::border","IMG::height","IMG::hspace","IMG::ismap","IMG::name","IMG::usemap","IMG::vspace","IMG::width","INPUT::accept","INPUT::accesskey","INPUT::align","INPUT::alt","INPUT::autocomplete","INPUT::autofocus","INPUT::checked","INPUT::disabled","INPUT::inputmode","INPUT::ismap","INPUT::list","INPUT::max","INPUT::maxlength","INPUT::min","INPUT::multiple","INPUT::name","INPUT::placeholder","INPUT::readonly","INPUT::required","INPUT::size","INPUT::step","INPUT::tabindex","INPUT::type","INPUT::usemap","INPUT::value","INS::datetime","KEYGEN::disabled","KEYGEN::keytype","KEYGEN::name","LABEL::accesskey","LABEL::for","LEGEND::accesskey","LEGEND::align","LI::type","LI::value","LINK::sizes","MAP::name","MENU::compact","MENU::label","MENU::type","METER::high","METER::low","METER::max","METER::min","METER::value","OBJECT::typemustmatch","OL::compact","OL::reversed","OL::start","OL::type","OPTGROUP::disabled","OPTGROUP::label","OPTION::disabled","OPTION::label","OPTION::selected","OPTION::value","OUTPUT::for","OUTPUT::name","P::align","PRE::width","PROGRESS::max","PROGRESS::min","PROGRESS::value","SELECT::autocomplete","SELECT::disabled","SELECT::multiple","SELECT::name","SELECT::required","SELECT::size","SELECT::tabindex","SOURCE::type","TABLE::align","TABLE::bgcolor","TABLE::border","TABLE::cellpadding","TABLE::cellspacing","TABLE::frame","TABLE::rules","TABLE::summary","TABLE::width","TBODY::align","TBODY::char","TBODY::charoff","TBODY::valign","TD::abbr","TD::align","TD::axis","TD::bgcolor","TD::char","TD::charoff","TD::colspan","TD::headers","TD::height","TD::nowrap","TD::rowspan","TD::scope","TD::valign","TD::width","TEXTAREA::accesskey","TEXTAREA::autocomplete","TEXTAREA::cols","TEXTAREA::disabled","TEXTAREA::inputmode","TEXTAREA::name","TEXTAREA::placeholder","TEXTAREA::readonly","TEXTAREA::required","TEXTAREA::rows","TEXTAREA::tabindex","TEXTAREA::wrap","TFOOT::align","TFOOT::char","TFOOT::charoff","TFOOT::valign","TH::abbr","TH::align","TH::axis","TH::bgcolor","TH::char","TH::charoff","TH::colspan","TH::headers","TH::height","TH::nowrap","TH::rowspan","TH::scope","TH::valign","TH::width","THEAD::align","THEAD::char","THEAD::charoff","THEAD::valign","TR::align","TR::bgcolor","TR::char","TR::charoff","TR::valign","TRACK::default","TRACK::kind","TRACK::label","TRACK::srclang","UL::compact","UL::type","VIDEO::controls","VIDEO::height","VIDEO::loop","VIDEO::mediagroup","VIDEO::muted","VIDEO::preload","VIDEO::width"]),[P.y])
C.F=I.aq(["HEAD","AREA","BASE","BASEFONT","BR","COL","COLGROUP","EMBED","FRAME","FRAMESET","HR","IMAGE","IMG","INPUT","ISINDEX","LINK","META","PARAM","SOURCE","STYLE","TITLE","WBR"])
C.G=I.aq([])
C.n=H.q(I.aq(["bind","if","ref","repeat","syntax"]),[P.y])
C.i=H.q(I.aq(["A::href","AREA::href","BLOCKQUOTE::cite","BODY::background","COMMAND::icon","DEL::cite","FORM::action","IMG::src","INPUT::src","INS::cite","Q::cite","VIDEO::poster"]),[P.y])
$.cM="$cachedFunction"
$.cN="$cachedInvocation"
$.aW=null
$.N=null
$.R=0
$.aw=null
$.ch=null
$.c5=null
$.dy=null
$.dJ=null
$.bp=null
$.bu=null
$.c6=null
$.al=null
$.aE=null
$.aF=null
$.c1=!1
$.k=C.b
$.cr=0
$.aB=null
$.a5=null
$.bE=null
$.co=null
$.cn=null
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
I.$lazy(y,x,w)}})(["cl","$get$cl",function(){return H.dD("_$dart_dartClosure")},"bH","$get$bH",function(){return H.dD("_$dart_js")},"cw","$get$cw",function(){return H.eQ()},"cx","$get$cx",function(){if(typeof WeakMap=="function")var z=new WeakMap()
else{z=$.cr
$.cr=z+1
z="expando$key$"+z}return new P.ek(null,z)},"d_","$get$d_",function(){return H.T(H.bh({
toString:function(){return"$receiver$"}}))},"d0","$get$d0",function(){return H.T(H.bh({$method$:null,
toString:function(){return"$receiver$"}}))},"d1","$get$d1",function(){return H.T(H.bh(null))},"d2","$get$d2",function(){return H.T(function(){var $argumentsExpr$='$arguments$'
try{null.$method$($argumentsExpr$)}catch(z){return z.message}}())},"d6","$get$d6",function(){return H.T(H.bh(void 0))},"d7","$get$d7",function(){return H.T(function(){var $argumentsExpr$='$arguments$'
try{(void 0).$method$($argumentsExpr$)}catch(z){return z.message}}())},"d4","$get$d4",function(){return H.T(H.d5(null))},"d3","$get$d3",function(){return H.T(function(){try{null.$method$}catch(z){return z.message}}())},"d9","$get$d9",function(){return H.T(H.d5(void 0))},"d8","$get$d8",function(){return H.T(function(){try{(void 0).$method$}catch(z){return z.message}}())},"bW","$get$bW",function(){return P.fO()},"ba","$get$ba",function(){return P.ha(null,null)},"aG","$get$aG",function(){return[]},"dk","$get$dk",function(){return P.cC(["A","ABBR","ACRONYM","ADDRESS","AREA","ARTICLE","ASIDE","AUDIO","B","BDI","BDO","BIG","BLOCKQUOTE","BR","BUTTON","CANVAS","CAPTION","CENTER","CITE","CODE","COL","COLGROUP","COMMAND","DATA","DATALIST","DD","DEL","DETAILS","DFN","DIR","DIV","DL","DT","EM","FIELDSET","FIGCAPTION","FIGURE","FONT","FOOTER","FORM","H1","H2","H3","H4","H5","H6","HEADER","HGROUP","HR","I","IFRAME","IMG","INPUT","INS","KBD","LABEL","LEGEND","LI","MAP","MARK","MENU","METER","NAV","NOBR","OL","OPTGROUP","OPTION","OUTPUT","P","PRE","PROGRESS","Q","S","SAMP","SECTION","SELECT","SMALL","SOURCE","SPAN","STRIKE","STRONG","SUB","SUMMARY","SUP","TABLE","TBODY","TD","TEXTAREA","TFOOT","TH","THEAD","TIME","TR","TRACK","TT","U","UL","VAR","VIDEO","WBR"],null)},"bZ","$get$bZ",function(){return P.bK()}])
I=I.$finishIsolateConstructor(I)
$=new I()
init.metadata=[null]
init.types=[{func:1,args:[,]},{func:1},{func:1,v:true},{func:1,v:true,args:[{func:1,v:true}]},{func:1,v:true,args:[P.a],opt:[P.ai]},{func:1,ret:P.y,args:[P.l]},{func:1,ret:P.c3,args:[W.ag,P.y,P.y,W.bY]},{func:1,args:[,P.y]},{func:1,args:[P.y]},{func:1,args:[{func:1,v:true}]},{func:1,args:[,P.ai]},{func:1,args:[P.l,,]},{func:1,args:[,],opt:[,]},{func:1,v:true,args:[,P.ai]},{func:1,args:[,,]},{func:1,args:[W.aO]},{func:1,v:true,args:[W.o,W.o]},{func:1,ret:P.K,args:[,]},{func:1,args:[P.cX]},{func:1,ret:P.ar}]
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
if(x==y)H.iB(d||a)
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
Isolate.aq=a.aq
Isolate.B=a.B
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
if(typeof dartMainRunner==="function")dartMainRunner(function(b){H.dL(F.dH(),b)},[])
else (function(b){H.dL(F.dH(),b)})([])})})()